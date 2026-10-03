import 'dart:async';
import 'dart:convert';

import 'package:budget_engine/budget_engine.dart';
import 'package:get/get.dart';
import 'package:safe_to_spend/core/analytics/analytics_events.dart';
import 'package:safe_to_spend/core/navigation/navigator.dart';
import 'package:safe_to_spend/core/routes/app_routes.dart';
import 'package:safe_to_spend/core/state/view_state.dart';
import 'package:safe_to_spend/core/time/clock.dart';
import 'package:safe_to_spend/core/time/local_date_timezone.dart';
import 'package:safe_to_spend/data/models/date_range.dart';
import 'package:safe_to_spend/data/models/onboarding_draft.dart';
import 'package:safe_to_spend/domain/models/budget_profile_model.dart';
import 'package:safe_to_spend/domain/repositories/i_profile_repository.dart';
import 'package:safe_to_spend/domain/repositories/i_settings_repository.dart';
import 'package:safe_to_spend/domain/services/i_analytics_service.dart';
import 'package:safe_to_spend/domain/services/i_budget_snapshot_service.dart';
import 'package:safe_to_spend/domain/services/i_notification_service.dart';
import 'package:url_launcher/url_launcher.dart';

/// Central controller managing the multi-step onboarding wizard.
class OnboardingController extends GetxController {
  /// Creates an instance of [OnboardingController].
  OnboardingController({
    required this.analytics,
    required this.navigator,
    this.settingsRepo,
    Clock? clock,
    this.urlLauncher,
    this.snapshotService,
    this.profileRepo,
    this.notificationService,
  }) : clock = clock ?? const SystemClock();

  /// Budget snapshot computation service.
  final IBudgetSnapshotService? snapshotService;

  /// User profile persistence repository.
  final IProfileRepository? profileRepo;

  /// System notification permission service.
  final INotificationService? notificationService;

  /// Analytics service for tracking onboarding events.
  final IAnalyticsService analytics;

  /// Navigation abstraction.
  final INavigator navigator;

  /// Application settings repository.
  final ISettingsRepository? settingsRepo;

  /// Time provider for deterministic date operations.
  final Clock clock;

  /// Optional custom URL launcher callback for tests.
  final Future<bool> Function(Uri url)? urlLauncher;

  /// Storage key for saving onboarding draft into app settings.
  static const String _draftStorageKey = 'onboarding_draft';

  /// Current step in the 4-step onboarding flow (1..4).
  final currentStep = 1.obs;

  /// In-memory draft holding user-configured settings before database persistence.
  final draft = const OnboardingDraft().obs;

  /// View state representing the status of asynchronous operations.
  final state = ViewState.idle.obs;

  /// Error message if an error occurs.
  final errorMessage = RxnString();

  /// Calculated budget preview snapshot shown in Step 4.
  final previewSnapshot = Rxn<BudgetSnapshot>();

  /// Whether database persistence is currently in progress.
  final isSaving = false.obs;

  /// Whether the notification pre-prompt card has been responded to.
  final notificationPromptHandled = false.obs;

  // --- Step 1: Welcome ---

  /// Starts the onboarding setup by advancing to the Income configuration step.
  void start() {
    analytics.logEvent(AnalyticsEvents.onboardingStart);
    currentStep.value = 2;
    navigator.toNamed<dynamic>(AppRoutes.onboardingIncome);
  }

  /// Opens the external Privacy Policy URL.
  Future<bool> openPrivacyPolicy() async {
    return _launchUrlString('https://safetospend.app/privacy');
  }

  /// Opens the external Terms of Service URL.
  Future<bool> openTermsOfService() async {
    return _launchUrlString('https://safetospend.app/terms');
  }

  // --- Step 2: Income ---

  /// Selects the income mode (Fixed or Irregular).
  ///
  /// Clears obsolete mode-specific fields to avoid state leakage (T07-4).
  void selectIncomeMode(IncomeMode mode) {
    analytics.logEvent(
      AnalyticsEvents.onboardingIncomeModeSelected,
      parameters: {'mode': mode.name},
    );
    if (mode == IncomeMode.fixed) {
      draft.value = draft.value.copyWith(
        incomeMode: IncomeMode.fixed,
        bufferPercent: 0,
        clearStartingBalance: true,
        clearSafetyHorizonDays: true,
      );
    } else {
      draft.value = draft.value.copyWith(
        incomeMode: IncomeMode.irregular,
        bufferPercent: 10,
        safetyHorizonDays: 14,
        clearPayFrequency: true,
        clearPayAnchorDate: true,
        clearNextPayday: true,
        clearIncomePerPaycheck: true,
        clearFirstPeriodBalance: true,
      );
    }
    saveDraft();
  }

  /// Selects paycheck frequency for fixed income.
  void selectFrequency(PayFrequency freq) {
    analytics.logEvent(
      AnalyticsEvents.onboardingPayFrequencySelected,
      parameters: {'frequency': freq.name},
    );
    draft.value = draft.value.copyWith(payFrequency: freq);

    // Validate that current nextPayday remains within valid range
    if (draft.value.nextPayday != null) {
      final range = allowedPaydayRange;
      if (draft.value.nextPayday!.isAfter(range.end) ||
          draft.value.nextPayday!.isBefore(range.start)) {
        setNextPayday(range.start);
      } else {
        setNextPayday(draft.value.nextPayday!);
      }
    }
    saveDraft();
  }

  /// Compatibility alias for [selectFrequency].
  void setPayFrequency(PayFrequency freq) => selectFrequency(freq);

  /// Sets the next upcoming payday.
  ///
  /// Rejects past dates and automatically derives payAnchorDate.
  void setNextPayday(LocalDate date) {
    final today = LocalDateFromDateTime.fromDateTime(
      clock.now(),
      draft.value.timezone,
    );
    if (date.isBefore(today)) return;

    final anchor = _derivePayAnchorDate(date, draft.value.payFrequency);
    draft.value = draft.value.copyWith(nextPayday: date, payAnchorDate: anchor);

    final suggested = suggestedFirstPeriodBalance;
    if (suggested != null && draft.value.firstPeriodBalance == null) {
      draft.value = draft.value.copyWith(firstPeriodBalance: suggested);
    }
    saveDraft();
  }

  LocalDate _derivePayAnchorDate(LocalDate nextPayday, PayFrequency? freq) {
    return nextPayday;
  }

  /// Sets net income amount per paycheck.
  void setIncomePerPaycheck(Money amount) {
    draft.value = draft.value.copyWith(incomePerPaycheck: amount);
    final suggested = suggestedFirstPeriodBalance;
    if (suggested != null) {
      draft.value = draft.value.copyWith(firstPeriodBalance: suggested);
    }
    saveDraft();
  }

  /// Sets available spending balance for the initial period.
  void setFirstPeriodBalance(Money amount) {
    draft.value = draft.value.copyWith(firstPeriodBalance: amount);
    saveDraft();
  }

  /// Sets starting balance for irregular income mode.
  void setStartingBalance(Money amount) {
    draft.value = draft.value.copyWith(startingBalance: amount);
    saveDraft();
  }

  /// Sets safety horizon window in days for irregular income (7, 14, 30).
  void setHorizon(int days) {
    if (days != 7 && days != 14 && days != 30) return;
    draft.value = draft.value.copyWith(safetyHorizonDays: days);
    saveDraft();
  }

  /// Sets the display and calculation currency.
  void setCurrency(String currencyCode) {
    draft.value = draft.value.copyWith(currency: currencyCode);
    saveDraft();
  }

  /// Completes Step 2 and advances to Step 3 (Bills).
  void submitIncomeStep() {
    if (!canContinue) return;
    analytics.logEvent(
      AnalyticsEvents.onboardingStepCompleted,
      parameters: {'step': 'income'},
    );
    currentStep.value = 3;
    saveDraft();
    navigator.toNamed<dynamic>(AppRoutes.onboardingBills);
  }

  // --- Getters ---

  /// Whether the user has entered valid inputs to proceed past Step 2.
  bool get canContinue {
    final d = draft.value;
    if (d.incomeMode == IncomeMode.fixed) {
      return d.payFrequency != null &&
          d.nextPayday != null &&
          d.incomePerPaycheck != null &&
          d.incomePerPaycheck!.cents > 0 &&
          d.firstPeriodBalance != null &&
          d.firstPeriodBalance!.cents > 0;
    } else {
      return d.startingBalance != null &&
          d.startingBalance!.cents > 0 &&
          d.safetyHorizonDays != null &&
          d.safetyHorizonDays! > 0;
    }
  }

  /// Allowed selectable range for next payday based on frequency.
  DateRange get allowedPaydayRange {
    final today = LocalDateFromDateTime.fromDateTime(
      clock.now(),
      draft.value.timezone,
    );
    final freq = draft.value.payFrequency ?? PayFrequency.monthly;
    switch (freq) {
      case PayFrequency.weekly:
        return DateRange(start: today, end: today.addDays(7));
      case PayFrequency.biweekly:
        return DateRange(start: today, end: today.addDays(14));
      case PayFrequency.semimonthly:
        return DateRange(start: today, end: today.addDays(16));
      case PayFrequency.monthly:
        return DateRange(start: today, end: today.addDays(31));
    }
  }

  /// Calculates suggested initial period balance.
  Money? get suggestedFirstPeriodBalance {
    final d = draft.value;
    if (d.incomePerPaycheck == null || d.nextPayday == null) return null;

    final today = LocalDateFromDateTime.fromDateTime(clock.now(), d.timezone);
    final remainingDays = today.daysUntil(d.nextPayday!);

    if (remainingDays <= 0) return d.incomePerPaycheck;

    final freq = d.payFrequency ?? PayFrequency.monthly;
    int periodLength;
    switch (freq) {
      case PayFrequency.weekly:
        periodLength = 7;
      case PayFrequency.biweekly:
        periodLength = 14;
      case PayFrequency.semimonthly:
        periodLength = today.day <= 15
            ? 15
            : (LocalDate.daysInMonth(today.year, today.month) - 15);
      case PayFrequency.monthly:
        periodLength = LocalDate.daysInMonth(today.year, today.month);
    }

    final calculatedCents =
        (d.incomePerPaycheck!.cents * remainingDays / periodLength).round();
    final clampedCents = calculatedCents.clamp(1, d.incomePerPaycheck!.cents);
    return Money(clampedCents, d.currency);
  }

  // --- Step 3: Bills ---

  /// Adds a new bill to the onboarding draft.
  void addDraftBill(OnboardingBillDraft bill) {
    final updated = List<OnboardingBillDraft>.from(draft.value.bills)
      ..add(bill);
    draft.value = draft.value.copyWith(bills: updated);
    saveDraft();
  }

  /// Updates an existing bill in the draft.
  void updateDraftBill(OnboardingBillDraft bill) {
    final updated = draft.value.bills
        .map((b) => b.id == bill.id ? bill : b)
        .toList();
    draft.value = draft.value.copyWith(bills: updated);
    saveDraft();
  }

  /// Removes a bill from the draft by ID.
  void removeDraftBill(String billId) {
    final updated = draft.value.bills.where((b) => b.id != billId).toList();
    draft.value = draft.value.copyWith(bills: updated);
    saveDraft();
  }

  /// Computes the total bill occurrences before next payday (or within horizon for irregular mode).
  Money get billsTotalBeforePayday {
    final d = draft.value;
    final currency = d.currency;
    if (d.bills.isEmpty) return Money.zero(currency);

    final today = LocalDateFromDateTime.fromDateTime(clock.now(), d.timezone);
    LocalDate windowEnd;

    if (d.incomeMode == IncomeMode.fixed) {
      if (d.nextPayday == null) {
        windowEnd = today.addDays(30);
      } else {
        // Occurrences before next payday [today .. nextPayday - 1]
        windowEnd = d.nextPayday!.addDays(-1);
      }
    } else {
      final horizon = d.safetyHorizonDays ?? 14;
      windowEnd = today.addDays(horizon - 1);
    }

    if (windowEnd.isBefore(today)) return Money.zero(currency);

    final engineBills = d.bills
        .map(
          (b) => Bill(
            id: b.id,
            name: b.name,
            amount: b.amount,
            recurrence: b.recurrence,
            firstDueDate: b.firstDueDate,
          ),
        )
        .toList();

    final occurrences = generateBillOccurrences(engineBills, today, windowEnd);
    var total = Money.zero(currency);
    for (final occ in occurrences) {
      total = total + occ.amount;
    }
    return total;
  }

  /// Completes bills step, logs analytics, and navigates to the result screen.
  void submitBillsStep() {
    final count = draft.value.bills.length;
    if (count > 0) {
      analytics.logEvent(
        AnalyticsEvents.onboardingBillsAdded,
        parameters: {'count': count},
      );
    } else {
      analytics.logEvent(AnalyticsEvents.onboardingBillsSkipped);
    }
    currentStep.value = 4;
    saveDraft();
    navigator.toNamed<dynamic>(AppRoutes.onboardingResult);
  }

  /// Skips bills step without adding bills, logs analytics, and navigates to result screen.
  void skipBillsStep() {
    analytics.logEvent(AnalyticsEvents.onboardingBillsSkipped);
    currentStep.value = 4;
    saveDraft();
    navigator.toNamed<dynamic>(AppRoutes.onboardingResult);
  }

  // --- Step 4: Result & Notifications ---

  /// Computes and caches a preview [BudgetSnapshot] from the current in-flight draft.
  BudgetSnapshot computePreview() {
    final snap =
        snapshotService?.preview(draft.value) ??
        const BudgetSnapshot(
          safeToday: Money(0),
          tomorrowForecast: Money(0),
          status: BudgetStatus.good,
          remainingInPeriod: Money(0),
          daysLeftInPeriod: 1,
          dailyBaseline: Money(0),
        );
    previewSnapshot.value = snap;
    return snap;
  }

  /// Persists onboarding setup atomically in a single transaction and navigates to main shell.
  Future<void> completeOnboarding() async {
    if (isSaving.value) return;
    isSaving.value = true;
    state.value = ViewState.loading;
    errorMessage.value = null;

    try {
      final currentDraft = draft.value;
      final today = LocalDateFromDateTime.fromDateTime(
        clock.now(),
        currentDraft.timezone,
      );

      final profile = BudgetProfileModel(
        id: '',
        config: BudgetConfig(
          currency: currentDraft.currency,
          incomeMode: currentDraft.incomeMode,
          payFrequency: currentDraft.payFrequency,
          payAnchorDate: currentDraft.payAnchorDate,
          incomePerPaycheck: currentDraft.incomePerPaycheck,
          firstPeriodBalance: currentDraft.firstPeriodBalance,
          startingBalance: currentDraft.startingBalance,
          trackingStartDate: today,
          safetyHorizonDays: currentDraft.safetyHorizonDays ?? 14,
          bufferPercent: currentDraft.bufferPercent,
          rolloverMode: currentDraft.rolloverMode,
        ),
        timezone: currentDraft.timezone,
        onboardingCompleted: true,
      );

      final bills = currentDraft.bills
          .map(
            (b) => Bill(
              id: b.id,
              name: b.name,
              amount: b.amount,
              recurrence: b.recurrence,
              firstDueDate: b.firstDueDate,
            ),
          )
          .toList();

      if (profileRepo != null) {
        await profileRepo!.saveOnboarding(profile: profile, bills: bills);
      }

      if (settingsRepo != null) {
        await settingsRepo!.setString('notification_morning_time', '08:00');
        await settingsRepo!.setString('notification_evening_time', '20:30');
        await settingsRepo!.setBool('show_paywall_after_onboarding', false);
        await settingsRepo!.remove(_draftStorageKey);
      }

      await analytics.logEvent(
        AnalyticsEvents.onboardingComplete,
        parameters: {
          'income_mode': currentDraft.incomeMode.name,
          'pay_frequency': currentDraft.payFrequency?.name ?? 'none',
          'bills_count': currentDraft.bills.length,
        },
      );

      state.value = ViewState.success;
      isSaving.value = false;
      unawaited(navigator.offAllNamed<dynamic>(AppRoutes.root));
    } on Object catch (e, st) {
      state.value = ViewState.error;
      errorMessage.value = 'Failed to save profile';
      await analytics.recordError(
        e,
        st,
        reason: 'Failed to complete onboarding',
      );
      isSaving.value = false;
    }
  }

  /// Requests notification permissions via the system dialog and logs analytics.
  Future<bool> requestNotifications() async {
    notificationPromptHandled.value = true;
    final granted = (await notificationService?.requestPermission()) ?? false;
    await analytics.logEvent(
      AnalyticsEvents.notificationPermissionResult,
      parameters: {'granted': granted},
    );
    return granted;
  }

  /// Dismisses the notification pre-prompt without requesting system permissions.
  Future<void> skipNotifications() async {
    notificationPromptHandled.value = true;
    await analytics.logEvent(
      AnalyticsEvents.notificationPermissionResult,
      parameters: {'granted': false, 'action': 'not_now'},
    );
  }

  // --- Draft Persistence ---

  /// Persists current draft to app settings storage.
  Future<void> saveDraft() async {
    if (settingsRepo == null) return;
    try {
      final jsonStr = jsonEncode(draft.value.toJson());
      await settingsRepo!.setString(_draftStorageKey, jsonStr);
    } on Object catch (e, st) {
      await analytics.recordError(
        e,
        st,
        reason: 'Failed to persist onboarding draft',
      );
    }
  }

  /// Restores onboarding draft from app settings storage.
  ///
  /// Resets safely to default draft upon corrupt JSON (T07-5).
  Future<void> loadDraft() async {
    if (settingsRepo == null) return;
    try {
      final jsonStr = await settingsRepo!.getString(_draftStorageKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        draft.value = OnboardingDraft.fromJson(map);
      }
    } on Object catch (e, st) {
      await analytics.recordError(
        e,
        st,
        reason: 'Failed to parse corrupted onboarding draft',
      );
      await settingsRepo!.remove(_draftStorageKey);
      draft.value = const OnboardingDraft();
    }
  }

  Future<bool> _launchUrlString(String url) async {
    try {
      final uri = Uri.parse(url);
      if (urlLauncher != null) {
        return await urlLauncher!(uri);
      }
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Object catch (e, st) {
      state.value = ViewState.error;
      errorMessage.value = e.toString();
      await analytics.recordError(e, st);
      return false;
    }
  }
}
