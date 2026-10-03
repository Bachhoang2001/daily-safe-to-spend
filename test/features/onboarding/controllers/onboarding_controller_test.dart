import 'package:budget_engine/budget_engine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_to_spend/core/analytics/analytics_events.dart';
import 'package:safe_to_spend/core/navigation/navigator.dart';
import 'package:safe_to_spend/core/routes/app_routes.dart';
import 'package:safe_to_spend/core/state/view_state.dart';
import 'package:safe_to_spend/data/models/onboarding_draft.dart';
import 'package:safe_to_spend/domain/models/budget_profile_model.dart';
import 'package:safe_to_spend/features/onboarding/controllers/onboarding_controller.dart';

import '../../../helpers/fake_clock.dart';
import '../../../helpers/mock_services.dart';

class MockNavigator extends Mock implements INavigator {}

class FakeBudgetProfileModel extends Fake implements BudgetProfileModel {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeBudgetProfileModel());
    registerFallbackValue(const <Bill>[]);
    registerFallbackValue(const OnboardingDraft());
  });

  late MockAnalyticsService mockAnalytics;
  late MockNavigator mockNavigator;
  late MockSettingsRepository mockSettings;
  late MockProfileRepository mockProfileRepo;
  late MockBudgetSnapshotService mockSnapshotService;
  late MockNotificationService mockNotificationService;
  late FakeClock fakeClock;
  late OnboardingController controller;

  setUp(() {
    mockAnalytics = MockAnalyticsService();
    mockNavigator = MockNavigator();
    mockSettings = MockSettingsRepository();
    mockProfileRepo = MockProfileRepository();
    mockSnapshotService = MockBudgetSnapshotService();
    mockNotificationService = MockNotificationService();
    fakeClock = FakeClock(DateTime.utc(2026, 1, 1, 12));

    when(
      () => mockAnalytics.logEvent(any(), parameters: any(named: 'parameters')),
    ).thenAnswer((_) async {});

    when(
      () =>
          mockAnalytics.recordError(any(), any(), reason: any(named: 'reason')),
    ).thenAnswer((_) async {});

    when(() => mockSettings.setString(any(), any())).thenAnswer((_) async {});
    when(() => mockSettings.getString(any())).thenAnswer((_) async => null);
    when(() => mockSettings.setBool(any(), any())).thenAnswer((_) async {});
    when(() => mockSettings.getBool(any())).thenAnswer((_) async => null);
    when(() => mockSettings.remove(any())).thenAnswer((_) async {});

    when(
      () => mockNavigator.toNamed<dynamic>(
        any(),
        arguments: any<dynamic>(named: 'arguments'),
        parameters: any(named: 'parameters'),
      ),
    ).thenAnswer((_) async => null);

    when(
      () => mockNavigator.offAllNamed<dynamic>(
        any(),
        arguments: any<dynamic>(named: 'arguments'),
        parameters: any(named: 'parameters'),
      ),
    ).thenAnswer((_) async => null);

    when(
      () => mockProfileRepo.saveOnboarding(
        profile: any(named: 'profile'),
        bills: any(named: 'bills'),
      ),
    ).thenAnswer((_) async {});

    when(
      () => mockNotificationService.hasPermission(),
    ).thenAnswer((_) async => false);
    when(
      () => mockNotificationService.requestPermission(),
    ).thenAnswer((_) async => true);

    controller = OnboardingController(
      analytics: mockAnalytics,
      navigator: mockNavigator,
      settingsRepo: mockSettings,
      clock: fakeClock,
      urlLauncher: (uri) async => true,
      snapshotService: mockSnapshotService,
      profileRepo: mockProfileRepo,
      notificationService: mockNotificationService,
    );
  });

  group('OnboardingController - Welcome (T06-1, T06-2)', () {
    test(
      'T06-1: initial state has currentStep 1, idle state, and default draft',
      () {
        expect(controller.currentStep.value, equals(1));
        expect(controller.state.value, equals(ViewState.idle));
        expect(controller.errorMessage.value, isNull);
        expect(controller.draft.value.currency, equals('USD'));
        expect(controller.draft.value.bufferPercent, equals(5));
      },
    );

    test(
      'T06-1: start() records onboarding_start event and navigates to onboarding income',
      () async {
        controller.start();

        verify(
          () => mockAnalytics.logEvent(AnalyticsEvents.onboardingStart),
        ).called(1);
        verify(
          () => mockNavigator.toNamed<dynamic>(AppRoutes.onboardingIncome),
        ).called(1);
        expect(controller.currentStep.value, equals(2));
      },
    );

    test(
      'T06-2: openPrivacyPolicy() and openTermsOfService() open external legal URLs successfully',
      () async {
        final privacyResult = await controller.openPrivacyPolicy();
        final termsResult = await controller.openTermsOfService();

        expect(privacyResult, isTrue);
        expect(termsResult, isTrue);
        expect(controller.state.value, equals(ViewState.idle));
      },
    );

    test(
      'T06-2: failed URL launch transitions to ViewState.error and records error without throwing',
      () async {
        final failingController = OnboardingController(
          analytics: mockAnalytics,
          navigator: mockNavigator,
          settingsRepo: mockSettings,
          clock: fakeClock,
          urlLauncher: (uri) async => throw Exception('Unable to open URL'),
        );

        final result = await failingController.openPrivacyPolicy();

        expect(result, isFalse);
        expect(failingController.state.value, equals(ViewState.error));
        expect(
          failingController.errorMessage.value,
          contains('Unable to open URL'),
        );
        verify(
          () => mockAnalytics.recordError(
            any(),
            any(),
            reason: any(named: 'reason'),
          ),
        ).called(1);
      },
    );
  });

  group('OnboardingController - Income (T07-1 to T07-6)', () {
    test(
      'T07-1: Fixed mode canContinue is false until frequency, nextPayday, and positive amounts are set',
      () {
        controller.selectIncomeMode(IncomeMode.fixed);
        expect(controller.canContinue, isFalse);

        controller.selectFrequency(PayFrequency.monthly);
        expect(controller.canContinue, isFalse);

        controller.setNextPayday(const LocalDate(2026, 1, 15));
        expect(controller.canContinue, isFalse);

        controller
          ..setIncomePerPaycheck(const Money(300000))
          ..setFirstPeriodBalance(const Money(0));
        expect(controller.canContinue, isFalse);

        controller.setFirstPeriodBalance(const Money(150000));
        expect(controller.canContinue, isTrue);
      },
    );

    test(
      'T07-1: submitIncomeStep records onboarding_step_completed, saves draft, and navigates to bills route',
      () {
        controller
          ..selectIncomeMode(IncomeMode.fixed)
          ..selectFrequency(PayFrequency.biweekly)
          ..setNextPayday(const LocalDate(2026, 1, 15))
          ..setIncomePerPaycheck(const Money(250000))
          ..setFirstPeriodBalance(const Money(120000));

        expect(controller.canContinue, isTrue);

        controller.submitIncomeStep();

        verify(
          () => mockAnalytics.logEvent(
            AnalyticsEvents.onboardingStepCompleted,
            parameters: {'step': 'income'},
          ),
        ).called(1);
        verify(
          () => mockNavigator.toNamed<dynamic>(AppRoutes.onboardingBills),
        ).called(1);
        expect(controller.currentStep.value, equals(3));
      },
    );

    test(
      'T07-2: suggestedFirstPeriodBalance calculates income * (remainingDays / periodLength) and clamps between 1 cent and full income',
      () {
        controller
          ..selectIncomeMode(IncomeMode.fixed)
          ..selectFrequency(PayFrequency.biweekly)
          ..setIncomePerPaycheck(const Money(280000))
          ..setNextPayday(const LocalDate(2026, 1, 8));
        // 280000 * 7 / 14 = 140000
        expect(
          controller.suggestedFirstPeriodBalance,
          equals(const Money(140000)),
        );

        // Weekly (7 days), today Jan 1, nextPayday Jan 4 -> 3 days remaining
        controller
          ..selectFrequency(PayFrequency.weekly)
          ..setIncomePerPaycheck(const Money(70000))
          ..setNextPayday(const LocalDate(2026, 1, 4));
        // (70000 * 3 / 7).round() = 30000
        expect(
          controller.suggestedFirstPeriodBalance,
          equals(const Money(30000)),
        );

        // Monthly (31 days in Jan), today Jan 1, nextPayday Jan 16 -> 15 days remaining
        controller
          ..selectFrequency(PayFrequency.monthly)
          ..setIncomePerPaycheck(const Money(310000))
          ..setNextPayday(const LocalDate(2026, 1, 16));
        // (310000 * 15 / 31).round() = 150000
        expect(
          controller.suggestedFirstPeriodBalance,
          equals(const Money(150000)),
        );
      },
    );

    test(
      'T07-2: suggestedFirstPeriodBalance returns full income when next payday is today (0 remaining days)',
      () {
        controller
          ..selectIncomeMode(IncomeMode.fixed)
          ..selectFrequency(PayFrequency.biweekly)
          ..setIncomePerPaycheck(const Money(200000))
          ..setNextPayday(const LocalDate(2026, 1, 1));
        // Paid today: has full paycheck to spend
        expect(
          controller.suggestedFirstPeriodBalance,
          equals(const Money(200000)),
        );
      },
    );

    test(
      'T07-3: Irregular mode defaults to 14 days horizon, 10% buffer, and validates positive startingBalance',
      () {
        controller.selectIncomeMode(IncomeMode.irregular);

        expect(controller.draft.value.safetyHorizonDays, equals(14));
        expect(controller.draft.value.bufferPercent, equals(10));
        expect(controller.canContinue, isFalse);

        controller.setStartingBalance(const Money(0));
        expect(controller.canContinue, isFalse);

        controller.setStartingBalance(const Money(60000));
        expect(controller.canContinue, isTrue);

        controller.setHorizon(7);
        expect(controller.draft.value.safetyHorizonDays, equals(7));

        controller.setHorizon(30);
        expect(controller.draft.value.safetyHorizonDays, equals(30));

        // Invalid horizon ignored
        controller.setHorizon(45);
        expect(controller.draft.value.safetyHorizonDays, equals(30));
      },
    );

    test(
      'T07-4: Switching from Irregular to Fixed clears startingBalance and safetyHorizonDays, resets buffer to 0',
      () {
        controller
          ..selectIncomeMode(IncomeMode.irregular)
          ..setStartingBalance(const Money(100000))
          ..setHorizon(14);
        expect(controller.draft.value.startingBalance, isNotNull);

        controller.selectIncomeMode(IncomeMode.fixed);
        expect(controller.draft.value.startingBalance, isNull);
        expect(controller.draft.value.safetyHorizonDays, isNull);
        expect(controller.draft.value.bufferPercent, equals(0));
      },
    );

    test(
      'T07-4: Switching from Fixed to Irregular clears payFrequency, payAnchorDate, nextPayday, incomePerPaycheck, firstPeriodBalance',
      () {
        controller
          ..selectIncomeMode(IncomeMode.fixed)
          ..selectFrequency(PayFrequency.monthly)
          ..setNextPayday(const LocalDate(2026, 1, 15))
          ..setIncomePerPaycheck(const Money(400000))
          ..setFirstPeriodBalance(const Money(200000))
          ..selectIncomeMode(IncomeMode.irregular);

        expect(controller.draft.value.incomePerPaycheck, isNull);
        expect(controller.draft.value.firstPeriodBalance, isNull);
        expect(controller.draft.value.nextPayday, isNull);
        expect(controller.draft.value.payAnchorDate, isNull);
        expect(controller.draft.value.bufferPercent, equals(10));
        expect(controller.draft.value.safetyHorizonDays, equals(14));
      },
    );

    test(
      'T07-5: Draft persistence saves valid JSON to app_settings and restores full state on loadDraft',
      () async {
        String? savedJson;
        when(
          () => mockSettings.setString('onboarding_draft', any()),
        ).thenAnswer((invocation) async {
          savedJson = invocation.positionalArguments[1] as String;
        });

        controller
          ..selectIncomeMode(IncomeMode.fixed)
          ..selectFrequency(PayFrequency.biweekly)
          ..setNextPayday(const LocalDate(2026, 1, 15))
          ..setIncomePerPaycheck(const Money(250000))
          ..setFirstPeriodBalance(const Money(120000));

        await controller.saveDraft();
        expect(savedJson, isNotNull);

        when(
          () => mockSettings.getString('onboarding_draft'),
        ).thenAnswer((_) async => savedJson);

        final restoredController = OnboardingController(
          analytics: mockAnalytics,
          navigator: mockNavigator,
          settingsRepo: mockSettings,
          clock: fakeClock,
        );

        await restoredController.loadDraft();

        expect(
          restoredController.draft.value.incomeMode,
          equals(IncomeMode.fixed),
        );
        expect(
          restoredController.draft.value.payFrequency,
          equals(PayFrequency.biweekly),
        );
        expect(
          restoredController.draft.value.nextPayday,
          equals(const LocalDate(2026, 1, 15)),
        );
        expect(
          restoredController.draft.value.incomePerPaycheck,
          equals(const Money(250000)),
        );
        expect(
          restoredController.draft.value.firstPeriodBalance,
          equals(const Money(120000)),
        );
      },
    );

    test(
      'T07-5: Draft persistence recovers from corrupted or malformed JSON without crashing and resets to default draft',
      () async {
        when(
          () => mockSettings.getString('onboarding_draft'),
        ).thenAnswer((_) async => 'CORRUPTED_NOT_VALID_JSON{[[{');

        final freshController = OnboardingController(
          analytics: mockAnalytics,
          navigator: mockNavigator,
          settingsRepo: mockSettings,
          clock: fakeClock,
        );

        // Must not throw an unhandled exception
        await expectLater(freshController.loadDraft(), completes);

        // Logs error safely
        verify(
          () => mockAnalytics.recordError(
            any(),
            any(),
            reason: any(named: 'reason'),
          ),
        ).called(1);

        // Removes corrupted key
        verify(() => mockSettings.remove('onboarding_draft')).called(1);

        // Resets to safe default draft
        expect(freshController.draft.value, equals(const OnboardingDraft()));
      },
    );

    test(
      'T07-6: allowedPaydayRange starts today and enforces upper bound per frequency',
      () {
        controller
          ..selectIncomeMode(IncomeMode.fixed)
          ..selectFrequency(PayFrequency.weekly);
        expect(
          controller.allowedPaydayRange.start,
          equals(const LocalDate(2026, 1, 1)),
        );
        expect(
          controller.allowedPaydayRange.end,
          equals(const LocalDate(2026, 1, 8)),
        );

        controller.selectFrequency(PayFrequency.biweekly);
        expect(
          controller.allowedPaydayRange.start,
          equals(const LocalDate(2026, 1, 1)),
        );
        expect(
          controller.allowedPaydayRange.end,
          equals(const LocalDate(2026, 1, 15)),
        );

        controller.selectFrequency(PayFrequency.semimonthly);
        expect(
          controller.allowedPaydayRange.start,
          equals(const LocalDate(2026, 1, 1)),
        );
        expect(
          controller.allowedPaydayRange.end,
          equals(const LocalDate(2026, 1, 17)),
        );

        controller.selectFrequency(PayFrequency.monthly);
        expect(
          controller.allowedPaydayRange.start,
          equals(const LocalDate(2026, 1, 1)),
        );
        expect(
          controller.allowedPaydayRange.end,
          equals(const LocalDate(2026, 2, 1)),
        );
      },
    );

    test(
      'T07-6: setNextPayday rejects dates strictly before today and sets payAnchorDate',
      () {
        controller
          ..selectIncomeMode(IncomeMode.fixed)
          ..selectFrequency(PayFrequency.monthly)
          // Date in past (2025-12-31 is before today 2026-01-01)
          ..setNextPayday(const LocalDate(2025, 12, 31));
        expect(controller.draft.value.nextPayday, isNull);

        // Valid future date
        controller.setNextPayday(const LocalDate(2026, 1, 15));
        expect(
          controller.draft.value.nextPayday,
          equals(const LocalDate(2026, 1, 15)),
        );
        expect(
          controller.draft.value.payAnchorDate,
          equals(const LocalDate(2026, 1, 15)),
        );
      },
    );

    test(
      'Point 1 & 7: OnboardingDraft.fromJson safely parses abnormal data (null, empty, wrong types, large numbers) without crash',
      () {
        // Empty map
        final emptyDraft = OnboardingDraft.fromJson(const <String, dynamic>{});
        expect(emptyDraft.currency, equals('USD'));
        expect(emptyDraft.incomeMode, equals(IncomeMode.fixed));
        expect(emptyDraft.payFrequency, isNull);
        expect(emptyDraft.incomePerPaycheck, isNull);

        // String numbers and abnormal types
        final abnormalMap = <String, dynamic>{
          'currency': '  eur  ',
          'income_mode': 'unknown_mode',
          'pay_frequency': 'invalid_freq',
          'pay_anchor_date': 'not-a-date',
          'next_payday': 'also-not-a-date',
          'income_per_paycheck_cents': '350000',
          'first_period_balance_cents': 999999999999,
          'starting_balance_cents': -500,
          'safety_horizon_days': '14',
          'buffer_percent': '10',
          'rollover_mode': 'invalid_mode',
          'timezone': 12345,
          'bills': [
            'invalid_item',
            {
              'id': 101,
              'name': null,
              'amount_cents': '5000',
              'recurrence': 'yearly',
              'first_due_date': 'invalid-date',
            },
          ],
        };

        final parsed = OnboardingDraft.fromJson(abnormalMap);
        expect(parsed.currency, equals('EUR'));
        expect(parsed.incomeMode, equals(IncomeMode.fixed));
        expect(parsed.payFrequency, isNull);
        expect(parsed.payAnchorDate, isNull);
        expect(parsed.nextPayday, isNull);
        expect(parsed.incomePerPaycheck?.cents, equals(350000));
        expect(parsed.firstPeriodBalance?.cents, equals(999999999999));
        expect(parsed.startingBalance?.cents, equals(-500));
        expect(parsed.safetyHorizonDays, equals(14));
        expect(parsed.bufferPercent, equals(10));
        expect(parsed.rolloverMode, equals(RolloverMode.spread));
        expect(parsed.timezone, equals('12345'));
        expect(parsed.bills.length, equals(1));
        expect(parsed.bills.first.id, equals('101'));
        expect(parsed.bills.first.amount.cents, equals(5000));
        expect(parsed.bills.first.recurrence, equals(BillRecurrence.yearly));
        expect(
          parsed.bills.first.firstDueDate,
          equals(const LocalDate(2026, 1, 1)),
        );
      },
    );
  });

  group('OnboardingController - Bills (T08-1, T08-2, T08-3, T08-4)', () {
    test(
      'T08-1: addDraftBill adds bills and billsTotalBeforePayday calculates sum of occurrences before next payday',
      () {
        controller
          ..selectIncomeMode(IncomeMode.fixed)
          ..selectFrequency(PayFrequency.biweekly)
          ..setNextPayday(const LocalDate(2026, 1, 15));

        expect(controller.billsTotalBeforePayday, equals(const Money(0)));

        const bill1 = OnboardingBillDraft(
          id: 'bill-1',
          name: 'Rent',
          amount: Money(100000), // $1,000
          recurrence: BillRecurrence.monthly,
          firstDueDate: LocalDate(2026, 1, 5),
        );
        const bill2 = OnboardingBillDraft(
          id: 'bill-2',
          name: 'Internet',
          amount: Money(6000), // $60
          recurrence: BillRecurrence.monthly,
          firstDueDate: LocalDate(2026, 1, 10),
        );
        const bill3OutsideWindow = OnboardingBillDraft(
          id: 'bill-3',
          name: 'Gym',
          amount: Money(5000), // $50, occurs on or after next payday (Jan 15)
          recurrence: BillRecurrence.monthly,
          firstDueDate: LocalDate(2026, 1, 15),
        );

        controller
          ..addDraftBill(bill1)
          ..addDraftBill(bill2)
          ..addDraftBill(bill3OutsideWindow);

        // billsTotalBeforePayday should only sum bill1 ($1,000) and bill2 ($60) = $1,060 (106000 cents)
        expect(controller.billsTotalBeforePayday, equals(const Money(106000)));

        // In irregular mode with 14-day horizon: window is Jan 1 .. Jan 14
        controller.selectIncomeMode(IncomeMode.irregular);
        expect(controller.billsTotalBeforePayday, equals(const Money(106000)));

        // Edge case: when nextPayday is today (Jan 1) -> window is empty -> total is 0
        controller
          ..selectIncomeMode(IncomeMode.fixed)
          ..setNextPayday(const LocalDate(2026, 1, 1));
        expect(controller.billsTotalBeforePayday, equals(const Money(0)));
      },
    );

    test(
      'T08-2: skipBillsStep logs onboarding_bills_skipped, advances to step 4, and navigates to onboarding result',
      () {
        controller.skipBillsStep();

        verify(
          () => mockAnalytics.logEvent(AnalyticsEvents.onboardingBillsSkipped),
        ).called(1);
        expect(controller.currentStep.value, equals(4));
        verify(
          () => mockNavigator.toNamed<dynamic>(AppRoutes.onboardingResult),
        ).called(1);
        expect(controller.draft.value.bills, isEmpty);
      },
    );

    test(
      'T08-2: submitBillsStep with bills logs onboarding_bills_added with count, advances step, and navigates to result',
      () {
        const bill1 = OnboardingBillDraft(
          id: 'bill-1',
          name: 'Rent',
          amount: Money(100000),
          recurrence: BillRecurrence.monthly,
          firstDueDate: LocalDate(2026, 1, 5),
        );
        controller
          ..addDraftBill(bill1)
          ..submitBillsStep();

        verify(
          () => mockAnalytics.logEvent(
            AnalyticsEvents.onboardingBillsAdded,
            parameters: {'count': 1},
          ),
        ).called(1);
        expect(controller.currentStep.value, equals(4));
        verify(
          () => mockNavigator.toNamed<dynamic>(AppRoutes.onboardingResult),
        ).called(1);
      },
    );

    test(
      'T08-3: updateDraftBill updates an existing bill by id and refreshes billsTotalBeforePayday',
      () {
        controller
          ..selectIncomeMode(IncomeMode.fixed)
          ..setNextPayday(const LocalDate(2026, 1, 15));

        const bill1 = OnboardingBillDraft(
          id: 'bill-1',
          name: 'Rent',
          amount: Money(100000),
          recurrence: BillRecurrence.monthly,
          firstDueDate: LocalDate(2026, 1, 5),
        );
        controller.addDraftBill(bill1);
        expect(controller.billsTotalBeforePayday, equals(const Money(100000)));

        final updatedBill1 = bill1.copyWith(amount: const Money(120000));
        controller.updateDraftBill(updatedBill1);

        expect(
          controller.draft.value.bills.first.amount,
          equals(const Money(120000)),
        );
        expect(controller.billsTotalBeforePayday, equals(const Money(120000)));
      },
    );

    test(
      'T08-4: removeDraftBill removes bill from draft, saves draft, and reduces billsTotalBeforePayday',
      () {
        controller
          ..selectIncomeMode(IncomeMode.fixed)
          ..setNextPayday(const LocalDate(2026, 1, 15));

        const bill1 = OnboardingBillDraft(
          id: 'bill-1',
          name: 'Rent',
          amount: Money(100000),
          recurrence: BillRecurrence.monthly,
          firstDueDate: LocalDate(2026, 1, 5),
        );
        const bill2 = OnboardingBillDraft(
          id: 'bill-2',
          name: 'Internet',
          amount: Money(6000),
          recurrence: BillRecurrence.monthly,
          firstDueDate: LocalDate(2026, 1, 10),
        );

        controller
          ..addDraftBill(bill1)
          ..addDraftBill(bill2);

        expect(controller.draft.value.bills.length, equals(2));
        expect(controller.billsTotalBeforePayday, equals(const Money(106000)));

        controller.removeDraftBill('bill-2');

        expect(controller.draft.value.bills.length, equals(1));
        expect(controller.draft.value.bills.first.id, equals('bill-1'));
        expect(controller.billsTotalBeforePayday, equals(const Money(100000)));
      },
    );
  });

  group('OnboardingController - Result (T09-1..T09-5)', () {
    test(
      'T09-1: computePreview delegates to snapshotService.preview(draft) and updates previewSnapshot',
      () {
        controller
          ..selectIncomeMode(IncomeMode.fixed)
          ..setIncomePerPaycheck(const Money(300000))
          ..setPayFrequency(PayFrequency.biweekly)
          ..setNextPayday(const LocalDate(2026, 1, 15));

        const expectedSnapshot = BudgetSnapshot(
          safeToday: Money(4200),
          tomorrowForecast: Money(4200),
          status: BudgetStatus.good,
          remainingInPeriod: Money(42000),
          daysLeftInPeriod: 10,
          dailyBaseline: Money(4200),
        );

        when(
          () => mockSnapshotService.preview(any()),
        ).thenReturn(expectedSnapshot);

        final snapshot = controller.computePreview();

        expect(snapshot, equals(expectedSnapshot));
        expect(controller.previewSnapshot.value, equals(expectedSnapshot));
        verify(
          () => mockSnapshotService.preview(controller.draft.value),
        ).called(1);
      },
    );

    test(
      'T09-2: completeOnboarding saves profile with onboardingCompleted=true and bills in one transaction, writes default settings, removes draft, logs onboarding_complete, and navigates to AppRoutes.root',
      () async {
        controller
          ..selectIncomeMode(IncomeMode.fixed)
          ..setIncomePerPaycheck(const Money(300000))
          ..setPayFrequency(PayFrequency.biweekly)
          ..setNextPayday(const LocalDate(2026, 1, 15))
          ..addDraftBill(
            const OnboardingBillDraft(
              id: 'b-1',
              name: 'Internet',
              amount: Money(6000),
              recurrence: BillRecurrence.monthly,
              firstDueDate: LocalDate(2026, 1, 10),
            ),
          );

        await controller.completeOnboarding();

        verify(
          () => mockProfileRepo.saveOnboarding(
            profile: any(
              named: 'profile',
              that: isA<BudgetProfileModel>().having(
                (p) => p.onboardingCompleted,
                'onboardingCompleted',
                isTrue,
              ),
            ),
            bills: any(named: 'bills', that: hasLength(1)),
          ),
        ).called(1);

        verify(
          () => mockSettings.setString('notification_morning_time', '08:00'),
        ).called(1);
        verify(
          () => mockSettings.setString('notification_evening_time', '20:30'),
        ).called(1);
        verify(
          () => mockSettings.setBool('show_paywall_after_onboarding', false),
        ).called(1);
        verify(() => mockSettings.remove('onboarding_draft')).called(1);

        verify(
          () => mockAnalytics.logEvent(
            AnalyticsEvents.onboardingComplete,
            parameters: any(named: 'parameters'),
          ),
        ).called(1);

        verify(
          () => mockNavigator.offAllNamed<dynamic>(AppRoutes.root),
        ).called(1);
      },
    );

    test(
      'T09-3: completeOnboarding on database failure keeps draft, sets ViewState.error, records analytics, and resets isSaving',
      () async {
        controller
          ..selectIncomeMode(IncomeMode.fixed)
          ..setIncomePerPaycheck(const Money(300000));

        final dbException = Exception('Database transaction failed');
        when(
          () => mockProfileRepo.saveOnboarding(
            profile: any(named: 'profile'),
            bills: any(named: 'bills'),
          ),
        ).thenThrow(dbException);

        await controller.completeOnboarding();

        verifyNever(() => mockSettings.remove('onboarding_draft'));
        verifyNever(() => mockNavigator.offAllNamed<dynamic>(any()));

        expect(controller.state.value, equals(ViewState.error));
        expect(controller.errorMessage.value, isNotNull);
        expect(controller.isSaving.value, isFalse);

        verify(
          () => mockAnalytics.recordError(
            dbException,
            any(),
            reason: any(named: 'reason'),
          ),
        ).called(1);
      },
    );

    test(
      'T09-4: skipNotifications logs analytics with granted: false and does not call notificationService.requestPermission',
      () async {
        await controller.skipNotifications();

        verifyNever(() => mockNotificationService.requestPermission());
        verify(
          () => mockAnalytics.logEvent(
            AnalyticsEvents.notificationPermissionResult,
            parameters: any(
              named: 'parameters',
              that: containsPair('granted', false),
            ),
          ),
        ).called(1);
        expect(controller.notificationPromptHandled.value, isTrue);
      },
    );

    test(
      'T09-4: requestNotifications calls notificationService.requestPermission and logs analytics with result',
      () async {
        when(
          () => mockNotificationService.requestPermission(),
        ).thenAnswer((_) async => true);

        final granted = await controller.requestNotifications();

        expect(granted, isTrue);
        verify(() => mockNotificationService.requestPermission()).called(1);
        verify(
          () => mockAnalytics.logEvent(
            AnalyticsEvents.notificationPermissionResult,
            parameters: any(
              named: 'parameters',
              that: containsPair('granted', true),
            ),
          ),
        ).called(1);
        expect(controller.notificationPromptHandled.value, isTrue);
      },
    );

    test(
      'T09-5: computePreview with deficit pool computes BudgetStatus.over and non-positive safeToday',
      () {
        const deficitSnapshot = BudgetSnapshot(
          safeToday: Money.usd(0),
          tomorrowForecast: Money.usd(0),
          status: BudgetStatus.over,
          remainingInPeriod: Money.usd(-5000),
          daysLeftInPeriod: 10,
          dailyBaseline: Money.usd(0),
        );

        when(
          () => mockSnapshotService.preview(any()),
        ).thenReturn(deficitSnapshot);

        final result = controller.computePreview();

        expect(result.status, equals(BudgetStatus.over));
        expect(result.safeToday.cents, lessThanOrEqualTo(0));
      },
    );

    test(
      'T09-AntiDoubleTap: completeOnboarding ignores subsequent calls while isSaving is true',
      () async {
        controller.isSaving.value = true;

        await controller.completeOnboarding();

        verifyNever(
          () => mockProfileRepo.saveOnboarding(
            profile: any(named: 'profile'),
            bills: any(named: 'bills'),
          ),
        );
      },
    );
  });
}
