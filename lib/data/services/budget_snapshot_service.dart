import 'dart:async';
import 'dart:developer' as developer;

import 'package:budget_engine/budget_engine.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' hide Rx;

import 'package:safe_to_spend/core/time/clock.dart';
import 'package:safe_to_spend/core/time/local_date_timezone.dart';
import 'package:safe_to_spend/data/models/onboarding_draft.dart';
import 'package:safe_to_spend/domain/models/budget_profile_model.dart';
import 'package:safe_to_spend/domain/repositories/i_bill_repository.dart';
import 'package:safe_to_spend/domain/repositories/i_expense_repository.dart';
import 'package:safe_to_spend/domain/repositories/i_goal_repository.dart';
import 'package:safe_to_spend/domain/repositories/i_income_repository.dart';
import 'package:safe_to_spend/domain/repositories/i_profile_repository.dart';
import 'package:safe_to_spend/domain/services/i_budget_snapshot_service.dart';

/// Service coordinating real-time reactive calculation of [BudgetSnapshot].
///
/// Combines streams from all data repositories, debounces burst mutations,
/// converts data into [EngineInput], and invokes the pure budget engine.
class BudgetSnapshotService extends GetxService
    implements IBudgetSnapshotService {
  /// Creates a [BudgetSnapshotService].
  BudgetSnapshotService({
    required this.profileRepo,
    required this.expenseRepo,
    required this.incomeRepo,
    required this.billRepo,
    required this.goalRepo,
    required this.clock,
    this.debounceDuration = const Duration(milliseconds: 25),
  });

  /// Repository for accessing user budget profiles.
  final IProfileRepository profileRepo;

  /// Repository for managing daily expenses.
  final IExpenseRepository expenseRepo;

  /// Repository for managing income entries.
  final IIncomeRepository incomeRepo;

  /// Repository for managing recurring bills.
  final IBillRepository billRepo;

  /// Repository for managing savings goals and contributions.
  final IGoalRepository goalRepo;

  /// System clock provider.
  final Clock clock;

  /// Debounce duration for batching reactive mutations.
  final Duration debounceDuration;

  @override
  final Rx<BudgetSnapshot?> snapshot = Rx<BudgetSnapshot?>(null);

  @override
  final Rx<String?> error = Rx<String?>(null);

  @override
  BudgetSnapshot? get currentSnapshot => snapshot.value;

  final List<StreamSubscription<dynamic>> _subscriptions = [];
  StreamSubscription<dynamic>? _pipelineSubscription;

  /// Whether active stream listeners are maintained.
  bool get hasActiveSubscriptions =>
      _subscriptions.isNotEmpty || _pipelineSubscription != null;

  @override
  void onInit() {
    super.onInit();
    final sub = profileRepo.watchActiveProfile().listen(
      _onProfileChanged,
      onError: _handleStreamError,
    );
    _subscriptions.add(sub);
  }

  void _handleStreamError(Object err, StackTrace stack) {
    developer.log(
      'Database stream error in BudgetSnapshotService',
      name: 'BudgetSnapshotService',
      error: err,
      stackTrace: stack,
    );
    error.value = 'Database stream error';
  }

  void _onProfileChanged(BudgetProfileModel? profile) {
    _pipelineSubscription?.cancel();
    _pipelineSubscription = null;

    if (profile == null) {
      snapshot.value = null;
      error.value = null;
      return;
    }

    final today = LocalDateFromDateTime.fromDateTime(
      clock.now(),
      profile.timezone,
    );

    LocalDate from;
    LocalDate to;

    if (profile.config.incomeMode == IncomeMode.fixed &&
        profile.config.payFrequency != null &&
        profile.config.payAnchorDate != null) {
      final period = resolvePeriod(
        profile.config.payFrequency!,
        profile.config.payAnchorDate!,
        today,
      );
      from = period.start;
      to = period.end;
    } else {
      from = profile.config.trackingStartDate;
      to = today.addDays(365);
    }

    _pipelineSubscription =
        CombineLatestStream.combine4<
              List<Expense>,
              List<Bill>,
              List<IncomeEntry>,
              Goal?,
              _CombinedData
            >(
              expenseRepo.watchRange(from: from, to: to),
              billRepo.watchActive(),
              incomeRepo.watchAll(),
              goalRepo.watchActiveGoal(),
              (expenses, bills, incomes, goal) => _CombinedData(
                expenses: expenses,
                bills: bills,
                incomes: incomes,
                goal: goal,
              ),
            )
            .debounceTime(debounceDuration)
            .listen(
              (data) => _computeFromData(profile, today, data),
              onError: _handleStreamError,
            );
  }

  Future<void> _computeFromData(
    BudgetProfileModel profile,
    LocalDate today,
    _CombinedData data,
  ) async {
    try {
      var contributions = const <GoalContribution>[];
      if (data.goal != null) {
        contributions = await goalRepo.getContributions(data.goal!.id);
      }

      final input = EngineInput(
        config: profile.config,
        expenses: data.expenses,
        bills: data.bills,
        goal: data.goal,
        contributions: contributions,
        incomes: data.incomes,
      );

      snapshot.value = computeSnapshot(input, today);
      error.value = null;
    } on Object catch (e, stack) {
      developer.log(
        'Failed to compute budget snapshot',
        name: 'BudgetSnapshotService',
        error: e,
        stackTrace: stack,
      );
      error.value = 'Failed to compute budget snapshot';
    }
  }

  @override
  Future<void> refresh() async {
    try {
      final profile = await profileRepo.getActiveProfile();
      if (profile == null) {
        snapshot.value = null;
        error.value = null;
        return;
      }

      final today = LocalDateFromDateTime.fromDateTime(
        clock.now(),
        profile.timezone,
      );

      LocalDate from;
      LocalDate to;

      if (profile.config.incomeMode == IncomeMode.fixed &&
          profile.config.payFrequency != null &&
          profile.config.payAnchorDate != null) {
        final period = resolvePeriod(
          profile.config.payFrequency!,
          profile.config.payAnchorDate!,
          today,
        );
        from = period.start;
        to = period.end;
      } else {
        from = profile.config.trackingStartDate;
        to = today.addDays(365);
      }

      final expenses = await expenseRepo.getRange(from: from, to: to);
      final bills = await billRepo.getActive();
      final incomes = await incomeRepo.getAll();
      final goal = await goalRepo.getActiveGoal();
      var contributions = const <GoalContribution>[];
      if (goal != null) {
        contributions = await goalRepo.getContributions(goal.id);
      }

      final input = EngineInput(
        config: profile.config,
        expenses: expenses,
        bills: bills,
        goal: goal,
        contributions: contributions,
        incomes: incomes,
      );

      snapshot.value = computeSnapshot(input, today);
      error.value = null;
    } on Object catch (e, stack) {
      developer.log(
        'Failed to refresh budget snapshot',
        name: 'BudgetSnapshotService',
        error: e,
        stackTrace: stack,
      );
      error.value = 'Failed to refresh budget snapshot';
    }
  }

  @override
  BudgetSnapshot preview(OnboardingDraft draft) {
    final today = LocalDateFromDateTime.fromDateTime(
      clock.now(),
      draft.timezone,
    );

    final config = BudgetConfig(
      currency: draft.currency,
      incomeMode: draft.incomeMode,
      payFrequency: draft.payFrequency,
      payAnchorDate: draft.payAnchorDate,
      incomePerPaycheck: draft.incomePerPaycheck,
      firstPeriodBalance: draft.firstPeriodBalance,
      startingBalance: draft.startingBalance,
      trackingStartDate: today,
      safetyHorizonDays: draft.safetyHorizonDays ?? 14,
      bufferPercent: draft.bufferPercent,
      rolloverMode: draft.rolloverMode,
    );

    final bills = draft.bills
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

    final input = EngineInput(config: config, bills: bills);

    return computeSnapshot(input, today);
  }

  @override
  void onClose() {
    _pipelineSubscription?.cancel();
    _pipelineSubscription = null;

    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
    super.onClose();
  }
}

class _CombinedData {
  _CombinedData({
    required this.expenses,
    required this.bills,
    required this.incomes,
    required this.goal,
  });

  final List<Expense> expenses;
  final List<Bill> bills;
  final List<IncomeEntry> incomes;
  final Goal? goal;
}
