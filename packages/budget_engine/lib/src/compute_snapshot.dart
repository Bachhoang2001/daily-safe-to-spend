import 'bill_occurrences.dart';
import 'fixed/day_simulator.dart';
import 'irregular/irregular_calculator.dart';
import 'local_date.dart';
import 'models/budget_snapshot.dart';
import 'models/engine_input.dart';
import 'models/enums.dart';
import 'models/goal_progress.dart';
import 'money.dart';
import 'period_resolver.dart';

/// Evaluates financial metrics and calculates the daily safe-to-spend allowance
/// for [today] based on the provided [EngineInput].
///
/// This is a 100% pure function:
/// - Zero dependencies on Flutter SDK, UI layers, or platform channels.
/// - Zero I/O operations (no SQLite, no shared preferences, no network calls).
/// - Zero access to the system clock (`DateTime.now()`). The target date is
///   injected explicitly via [today].
/// - Zero floating-point arithmetic. Monetary amounts are represented via
///   integer cents in [Money].
///
/// ---
///
/// ### Edge Cases Handled
/// - **Device Clock Drift / Future Tracking Start (F02.9-6):** If [today] is
///   before [BudgetConfig.trackingStartDate], the calculation clamps to
///   [BudgetConfig.trackingStartDate] to guarantee positive time intervals.
///
/// ---
///
/// ### Mode 1: Fixed Income Mode (`IncomeMode.fixed`)
///
/// 1. **Pay Period Resolution (F02.2):**
///    The engine determines the current pay period `[periodStart, periodEnd]`
///    anchored by [BudgetConfig.payAnchorDate] and [BudgetConfig.payFrequency]:
///    - `weekly`: 7-day intervals starting at `anchor + k * 7`.
///    - `biweekly`: 14-day intervals starting at `anchor + k * 14`.
///    - `semimonthly`: Days 1–15 and 16–end of month.
///    - `monthly`: Days anchored to `anchor.day` (clamped to the last day of shorter months).
///
/// 2. **Available Pool Calculation (F02.3):**
///    ```text
///    income      = (isFirstPeriod && firstPeriodBalance != null)
///                    ? firstPeriodBalance
///                    : incomePerPaycheck
///    bills       = Σ bill_occurrence.amount for due dates ∈ [calcStart, periodEnd]
///    goalReserve = (goal != null && goal.isActive && !isReached)
///                    ? goal.perPaycheckAmount
///                    : Money.zero
///    buffer      = income.percent(bufferPercent)  // floor to cent
///    pool        = income − bills − goalReserve − buffer
///    ```
///    *Note:* For onboarding periods containing `trackingStartDate`, `calcStart`
///    is set to `trackingStartDate`, and bills due before onboarding are excluded.
///
/// 3. **Day-by-Day Deterministic Simulation (F02.4):**
///    The engine simulates daily allowances sequentially from `calcStart` up to [today]:
///
///    - **Spread Mode (`RolloverMode.spread` - Default):**
///      ```text
///      allowance(d) = poolRemaining.divideEvenly(daysLeftInclDay(d))[0]
///      safeToday    = allowance(today) − spentToday − contributionsToday
///      forecast     = poolRemaining.divideEvenly(daysLeftInclToday - 1)[0]
///      ```
///      Any surplus or deficit from prior days is distributed evenly across all
///      remaining days in the pay period.
///
///    - **Tomorrow Boost Mode (`RolloverMode.tomorrow` - Premium):**
///      ```text
///      baseSchedule = pool.divideEvenly(totalDaysInPeriod)
///      carry(d)     = allowance(d - 1) − outflow(d - 1)
///      if carry(d) >= 0:
///        allowance(d) = baseSchedule[d] + carry(d)
///      else:
///        amortize deficit (-carry) evenly across all days from d to periodEnd
///        allowance(d) = max(0, baseSchedule[d])
///      ```
///      Surplus rewards the immediate next day directly; deficits are cushioned
///      across the rest of the period.
///
///    - **Save It Mode (`RolloverMode.save` - Premium):**
///      Calculates daily allowances like Spread. At the end of past days (`d < today`),
///      if `allowance(d) − outflow(d) > 0`, the unspent surplus is routed into
///      `derivedGoalSaved` (derived data, not saved to DB — ADR-002) and not rolled
///      over into future allowances. If no active goal exists, acts identically to Spread.
///
/// 4. **Budget Status Evaluation (F02.7):**
///    - `BudgetStatus.over`: `safeToday < Money.zero` or `shortfall == true`.
///    - `BudgetStatus.caution`: `safeToday < dailyAllowanceToday.percent(20)` or `dailyAllowanceToday == Money.zero`.
///    - `BudgetStatus.onTrack`: otherwise.
///
/// 5. **Savings Goal Progress (F02.8):**
///    ```text
///    goalSaved = Σ manualContributions + (goalReserve * periodsStartedCount) + derivedGoalSaved
///    percent   = clamp((goalSaved / targetAmount) * 100, 0, 100)
///    isReached = goalSaved >= targetAmount
///    ```
///
/// ---
///
/// ### Mode 2: Irregular Income Mode (`IncomeMode.irregular`)
///
/// 1. **Rolling Balance at Today (F02.5):**
///    ```text
///    balance(today) = startingBalance
///                   + Σ income[trackingStartDate .. today]
///                   − Σ expense[trackingStartDate .. today)
///                   − Σ contribution[trackingStartDate .. today)
///                   − Σ bill_occurrence[trackingStartDate .. today)
///    ```
///
/// 2. **Safety Horizon Window (H = `safetyHorizonDays`, default 14):**
///    ```text
///    windowEnd     = today.addDays(H - 1)
///    billsInWindow = Σ bill_occurrence.amount for due ∈ [today, windowEnd]
///    buffer        = balance(today) > 0 ? balance(today).percent(bufferPercent) : 0
///    spendable     = balance(today) − billsInWindow − buffer
///    ```
///
/// 3. **Daily Allowance & Safe-to-Spend:**
///    - If `spendable < Money.zero`:
///      `shortfall = true`, `shortfallAmount = spendable.abs`,
///      `dailyAllowanceToday = Money.zero`, `safeToday = Money.zero − spentToday − contribToday`,
///      `status = BudgetStatus.over`.
///    - Else:
///      `shortfall = false`,
///      `dailyAllowanceToday = spendable.divideEvenly(H)[0]`,
///      `safeToday = dailyAllowanceToday − spentToday − contribToday`,
///      `status = computeStatus(safeToday, dailyAllowanceToday)`.
///
/// 4. **Tomorrow Forecast:**
///    Simulated on window `[today + 1, today + 1 + H - 1]` with projected
///    balance `balanceTomorrow = balanceToday − spentToday − contribToday`.
BudgetSnapshot computeSnapshot(EngineInput input, LocalDate today) {
  final config = input.config;

  // Edge case F02.9-6: if device date is before trackingStartDate, clamp to trackingStartDate
  final effectiveToday = today.isBefore(config.trackingStartDate)
      ? config.trackingStartDate
      : today;

  if (config.incomeMode == IncomeMode.irregular) {
    return calculateIrregularSnapshot(
      config: config,
      incomes: input.incomes,
      expenses: input.expenses,
      bills: input.bills,
      contributions: input.contributions,
      today: effectiveToday,
    );
  }

  // Fixed Income Mode
  final currency = config.currency;
  final payFrequency = config.payFrequency ?? PayFrequency.monthly;
  final payAnchorDate = config.payAnchorDate ?? const LocalDate(2026, 1, 1);

  final payPeriod = resolvePeriod(payFrequency, payAnchorDate, effectiveToday);

  // Check if this pay period contains trackingStartDate (first period)
  final isFirstPeriod =
      (config.trackingStartDate.isAfter(payPeriod.start) ||
          config.trackingStartDate.isAtSameMomentAs(payPeriod.start)) &&
      (config.trackingStartDate.isBefore(payPeriod.end) ||
          config.trackingStartDate.isAtSameMomentAs(payPeriod.end));

  final calcStart = isFirstPeriod ? config.trackingStartDate : payPeriod.start;

  final income = (isFirstPeriod && config.firstPeriodBalance != null)
      ? config.firstPeriodBalance!
      : (config.incomePerPaycheck ?? Money.zero(currency));

  // Bill occurrences within this period (starting from calcStart)
  final billsInPeriod = generateBillOccurrences(
    input.bills,
    calcStart,
    payPeriod.end,
  );
  var totalBills = Money.zero(currency);
  for (final b in billsInPeriod) {
    totalBills = totalBills + b.amount;
  }

  // Goal evaluation
  final goal = input.goal;
  var goalReserve = Money.zero(currency);
  var periodsStartedCount = 0;
  var manualSaved = Money.zero(currency);

  if (goal != null && goal.isActive) {
    // Manual contributions up to effectiveToday
    for (final c in input.contributions) {
      if (c.goalId == goal.id && !c.onDate.isAfter(effectiveToday)) {
        manualSaved = manualSaved + c.amount;
      }
    }

    if (!goal.createdOn.isAfter(payPeriod.end)) {
      periodsStartedCount = _countPeriodsStarted(
        goal.createdOn,
        payPeriod.start,
        payFrequency,
        payAnchorDate,
      );
    }

    // Check if target is already achieved through prior savings
    final priorSaved =
        manualSaved +
        (goal.perPaycheckAmount *
            (periodsStartedCount > 1 ? periodsStartedCount - 1 : 0));
    final alreadyReached = priorSaved >= goal.targetAmount;

    if (!alreadyReached) {
      goalReserve = goal.perPaycheckAmount;
    }
  }

  final buffer = income.percent(config.bufferPercent);
  final pool = income - totalBills - goalReserve - buffer;

  // Simulate day by day
  final simResult = simulateFixedPeriod(
    calcStart: calcStart,
    periodEnd: payPeriod.end,
    today: effectiveToday,
    pool: pool,
    expenses: input.expenses,
    contributions: input.contributions,
    rolloverMode: config.rolloverMode,
    hasActiveGoal: goal != null && goal.isActive,
    nextPeriodBaseForecast: () {
      final nextStart = payPeriod.end.addDays(1);
      final nextPeriod = resolvePeriod(payFrequency, payAnchorDate, nextStart);
      final nextDays = nextStart.daysUntil(nextPeriod.end) + 1;
      final nextIncome = config.incomePerPaycheck ?? Money.zero(currency);
      final nextBillsList = generateBillOccurrences(
        input.bills,
        nextStart,
        nextPeriod.end,
      );
      var nextBills = Money.zero(currency);
      for (final b in nextBillsList) {
        nextBills = nextBills + b.amount;
      }
      final nextBuffer = nextIncome.percent(config.bufferPercent);
      final nextPool = nextIncome - nextBills - goalReserve - nextBuffer;
      return nextPool > Money.zero(currency)
          ? nextPool.divideEvenly(nextDays)[0]
          : Money.zero(currency);
    },
  );

  // Compute GoalProgress if goal is configured
  GoalProgress? goalProgress;
  if (goal != null) {
    final totalSaved =
        manualSaved +
        (goalReserve * periodsStartedCount) +
        simResult.derivedGoalSaved;
    final isReached = totalSaved >= goal.targetAmount;
    final percent = goal.targetAmount.cents > 0
        ? ((totalSaved.cents / goal.targetAmount.cents) * 100.0).clamp(
            0.0,
            100.0,
          )
        : 100.0;

    goalProgress = GoalProgress(
      savedAmount: totalSaved,
      targetAmount: goal.targetAmount,
      percent: percent,
      isReached: isReached,
      reachedOn: isReached ? effectiveToday : null,
    );
  }

  // Evaluate budget status
  BudgetStatus status;
  if (simResult.shortfall || simResult.safeToday < Money.zero(currency)) {
    status = BudgetStatus.over;
  } else if (simResult.dailyAllowanceToday == Money.zero(currency) ||
      simResult.safeToday < simResult.dailyAllowanceToday.percent(20)) {
    status = BudgetStatus.caution;
  } else {
    status = BudgetStatus.onTrack;
  }

  return BudgetSnapshot(
    safeToday: simResult.safeToday,
    dailyAllowanceToday: simResult.dailyAllowanceToday,
    spentToday: simResult.spentToday,
    tomorrowForecast: simResult.tomorrowForecast,
    remainingInPeriod: simResult.remainingInPeriod,
    daysLeftInclToday: simResult.daysLeftInclToday,
    periodStart: payPeriod.start,
    periodEnd: payPeriod.end,
    status: status,
    upcomingBills: billsInPeriod,
    goalProgress: goalProgress,
    shortfall: simResult.shortfall,
    shortfallAmount: simResult.shortfallAmount,
  );
}

int _countPeriodsStarted(
  LocalDate createdOn,
  LocalDate currentPeriodStart,
  PayFrequency frequency,
  LocalDate payAnchorDate,
) {
  final firstPeriod = resolvePeriod(frequency, payAnchorDate, createdOn);
  if (firstPeriod.start.isAfter(currentPeriodStart)) return 1;

  switch (frequency) {
    case PayFrequency.weekly:
      final days = firstPeriod.start.daysUntil(currentPeriodStart).abs();
      return (days ~/ 7) + 1;
    case PayFrequency.biweekly:
      final days = firstPeriod.start.daysUntil(currentPeriodStart).abs();
      return (days ~/ 14) + 1;
    case PayFrequency.monthly:
      final months =
          (currentPeriodStart.year - firstPeriod.start.year) * 12 +
          (currentPeriodStart.month - firstPeriod.start.month);
      return months + 1;
    case PayFrequency.semimonthly:
      final months =
          (currentPeriodStart.year - firstPeriod.start.year) * 12 +
          (currentPeriodStart.month - firstPeriod.start.month);
      final diffHalf =
          (currentPeriodStart.day >= 16 ? 1 : 0) -
          (firstPeriod.start.day >= 16 ? 1 : 0);
      return (months * 2) + diffHalf + 1;
  }
}
