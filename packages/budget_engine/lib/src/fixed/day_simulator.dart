import '../local_date.dart';
import '../models/enums.dart';
import '../models/expense.dart';
import '../models/goal_contribution.dart';
import '../money.dart';

/// Result produced by [simulateFixedPeriod].
class DaySimulationResult {
  /// Base allowance allocated for today.
  final Money dailyAllowanceToday;

  /// Remaining safe to spend today.
  final Money safeToday;

  /// Actual spending on today.
  final Money spentToday;

  /// Projected allowance for tomorrow.
  final Money tomorrowForecast;

  /// Remaining spendable pool in the current period.
  final Money remainingInPeriod;

  /// Days left in the period, inclusive of today.
  final int daysLeftInclToday;

  /// Derived savings accumulated from 'save' rollover mode.
  final Money derivedGoalSaved;

  /// Whether a shortfall occurred.
  final bool shortfall;

  /// Shortfall deficit amount.
  final Money shortfallAmount;

  /// Creates an immutable [DaySimulationResult].
  const DaySimulationResult({
    required this.dailyAllowanceToday,
    required this.safeToday,
    required this.spentToday,
    required this.tomorrowForecast,
    required this.remainingInPeriod,
    required this.daysLeftInclToday,
    this.derivedGoalSaved = const Money(0),
    this.shortfall = false,
    this.shortfallAmount = const Money(0),
  });
}

/// Simulates daily allowances day-by-day from [calcStart] up to [today]
/// according to the selected [rolloverMode].
///
/// ### Simulation Invariants
/// - **Conservation of Money (T02-21):**
///   `Σ allowance(d) + derivedGoalSaved == pool` across all days in the period
///   under normal spending (when not overspent).
/// - **Zero Cent Leakage (T02-22):** All divisions use `Money.divideEvenly` to
///   ensure the remainder cents are allocated deterministically without loss.
///
/// ### Rollover Algorithms
///
/// 1. **Spread (`RolloverMode.spread`):**
///    ```text
///    allowance(d) = poolRemaining.divideEvenly(daysLeft(d))[0]
///    outflow(d)   = spent(d) + contributions(d)
///    poolRemaining = poolRemaining - outflow(d)
///    ```
///    Any underspending or overspending from day `d` is smoothly amortized across
///    all days from `d + 1` to `periodEnd`.
///
/// 2. **Tomorrow Boost (`RolloverMode.tomorrow`):**
///    ```text
///    baseSchedule = pool.divideEvenly(totalDays)
///    carry(d)     = allowance(d - 1) - outflow(d - 1)
///    if carry(d) >= 0:
///      allowance(d) = baseSchedule[d] + carry(d)
///    else:
///      deductionParts = (-carry).divideEvenly(remainingDaysCount)
///      baseSchedule[k] = baseSchedule[k] - deductionParts[k - d] for k in [d .. totalDays - 1]
///      allowance(d) = max(0, baseSchedule[d])
///    ```
///    Surplus rewards the next day directly; deficits are smoothed across
///    the remaining days to cushion the blow.
///
/// 3. **Save It (`RolloverMode.save`):**
///    Simulates daily allowances like Spread. At the end of past days (`d < today`),
///    if `allowance(d) - outflow(d) > 0`, the surplus is transferred to
///    [DaySimulationResult.derivedGoalSaved] and excluded from future allowances.
///    If [hasActiveGoal] is false, automatically falls back to Spread.
DaySimulationResult simulateFixedPeriod({
  required LocalDate calcStart,
  required LocalDate periodEnd,
  required LocalDate today,
  required Money pool,
  required List<Expense> expenses,
  required List<GoalContribution> contributions,
  required RolloverMode rolloverMode,
  required bool hasActiveGoal,
  Money Function()? nextPeriodBaseForecast,
}) {
  final currency = pool.currency;
  final totalDays = calcStart.daysUntil(periodEnd) + 1;
  final daysLeftInclToday = today.daysUntil(periodEnd) + 1;
  final todayIndex = calcStart.daysUntil(today);

  // Group spending and contributions by date
  final spentByDate = <LocalDate, Money>{};
  for (final exp in expenses) {
    if (exp.spentOn.isBefore(calcStart)) continue;
    if (exp.spentOn.isAfter(today)) continue;
    spentByDate[exp.spentOn] =
        (spentByDate[exp.spentOn] ?? Money.zero(currency)) + exp.amount;
  }

  final contribByDate = <LocalDate, Money>{};
  for (final contrib in contributions) {
    if (contrib.onDate.isBefore(calcStart)) continue;
    if (contrib.onDate.isAfter(today)) continue;
    contribByDate[contrib.onDate] =
        (contribByDate[contrib.onDate] ?? Money.zero(currency)) +
        contrib.amount;
  }

  // Handle immediate shortfall if pool < 0
  if (pool < Money.zero(currency)) {
    final spentToday = spentByDate[today] ?? Money.zero(currency);
    final contribToday = contribByDate[today] ?? Money.zero(currency);
    var totalOutflow = Money.zero(currency);
    for (var i = 0; i <= todayIndex; i++) {
      final d = calcStart.addDays(i);
      totalOutflow =
          totalOutflow +
          (spentByDate[d] ?? Money.zero(currency)) +
          (contribByDate[d] ?? Money.zero(currency));
    }

    return DaySimulationResult(
      dailyAllowanceToday: Money.zero(currency),
      safeToday: Money.zero(currency) - spentToday - contribToday,
      spentToday: spentToday,
      tomorrowForecast: Money.zero(currency),
      remainingInPeriod: pool - totalOutflow,
      daysLeftInclToday: daysLeftInclToday,
      shortfall: true,
      shortfallAmount: pool.abs,
    );
  }

  final effectiveRolloverMode =
      (rolloverMode == RolloverMode.save && !hasActiveGoal)
      ? RolloverMode.spread
      : rolloverMode;

  switch (effectiveRolloverMode) {
    case RolloverMode.spread:
      var poolRemaining = pool;
      var allowanceToday = Money.zero(currency);

      for (var dayIndex = 0; dayIndex <= todayIndex; dayIndex++) {
        final d = calcStart.addDays(dayIndex);
        final daysLeft = d.daysUntil(periodEnd) + 1;
        final dailyAllowance = poolRemaining <= Money.zero(currency)
            ? Money.zero(currency)
            : poolRemaining.divideEvenly(daysLeft)[0];

        if (dayIndex == todayIndex) {
          allowanceToday = dailyAllowance;
        }

        final spentD = spentByDate[d] ?? Money.zero(currency);
        final contribD = contribByDate[d] ?? Money.zero(currency);
        poolRemaining = poolRemaining - (spentD + contribD);
      }

      final spentToday = spentByDate[today] ?? Money.zero(currency);
      final contribToday = contribByDate[today] ?? Money.zero(currency);
      final safeToday = allowanceToday - spentToday - contribToday;

      Money tomorrowForecast;
      final daysLeftTomorrow = daysLeftInclToday - 1;
      if (daysLeftTomorrow > 0) {
        tomorrowForecast = poolRemaining <= Money.zero(currency)
            ? Money.zero(currency)
            : poolRemaining.divideEvenly(daysLeftTomorrow)[0];
      } else {
        tomorrowForecast = nextPeriodBaseForecast != null
            ? nextPeriodBaseForecast()
            : allowanceToday;
      }

      return DaySimulationResult(
        dailyAllowanceToday: allowanceToday,
        safeToday: safeToday,
        spentToday: spentToday,
        tomorrowForecast: tomorrowForecast,
        remainingInPeriod: poolRemaining,
        daysLeftInclToday: daysLeftInclToday,
      );

    case RolloverMode.tomorrow:
      final baseSchedule = pool.divideEvenly(totalDays);
      var currentAllowance = Money.zero(currency);

      for (var dayIndex = 0; dayIndex <= todayIndex; dayIndex++) {
        if (dayIndex == 0) {
          currentAllowance = baseSchedule[0];
        } else {
          final prevDay = calcStart.addDays(dayIndex - 1);
          final prevOutflow =
              (spentByDate[prevDay] ?? Money.zero(currency)) +
              (contribByDate[prevDay] ?? Money.zero(currency));
          final carry = currentAllowance - prevOutflow;

          if (carry >= Money.zero(currency)) {
            currentAllowance = baseSchedule[dayIndex] + carry;
          } else {
            final remainingDaysCount = totalDays - dayIndex;
            final deficitParts = (-carry).divideEvenly(remainingDaysCount);
            for (var k = dayIndex; k < totalDays; k++) {
              baseSchedule[k] = baseSchedule[k] - deficitParts[k - dayIndex];
            }
            currentAllowance = baseSchedule[dayIndex] < Money.zero(currency)
                ? Money.zero(currency)
                : baseSchedule[dayIndex];
          }
        }
      }

      final allowanceToday = currentAllowance;
      final spentToday = spentByDate[today] ?? Money.zero(currency);
      final contribToday = contribByDate[today] ?? Money.zero(currency);
      final safeToday = allowanceToday - spentToday - contribToday;

      Money tomorrowForecast;
      if (todayIndex < totalDays - 1) {
        final tomorrowBase = baseSchedule[todayIndex + 1];
        if (safeToday >= Money.zero(currency)) {
          final boosted = tomorrowBase + safeToday;
          tomorrowForecast = boosted < Money.zero(currency)
              ? Money.zero(currency)
              : boosted;
        } else {
          final remainingAfterTomorrow = totalDays - (todayIndex + 1);
          final deduction = (-safeToday).divideEvenly(
            remainingAfterTomorrow,
          )[0];
          tomorrowForecast = tomorrowBase - deduction < Money.zero(currency)
              ? Money.zero(currency)
              : tomorrowBase - deduction;
        }
      } else {
        tomorrowForecast = nextPeriodBaseForecast != null
            ? nextPeriodBaseForecast()
            : allowanceToday;
      }

      var totalOutflow = Money.zero(currency);
      for (var dayIndex = 0; dayIndex <= todayIndex; dayIndex++) {
        final d = calcStart.addDays(dayIndex);
        totalOutflow =
            totalOutflow +
            (spentByDate[d] ?? Money.zero(currency)) +
            (contribByDate[d] ?? Money.zero(currency));
      }

      return DaySimulationResult(
        dailyAllowanceToday: allowanceToday,
        safeToday: safeToday,
        spentToday: spentToday,
        tomorrowForecast: tomorrowForecast,
        remainingInPeriod: pool - totalOutflow,
        daysLeftInclToday: daysLeftInclToday,
      );

    case RolloverMode.save:
      var poolRemaining = pool;
      var allowanceToday = Money.zero(currency);
      var derivedGoalSaved = Money.zero(currency);

      for (var dayIndex = 0; dayIndex <= todayIndex; dayIndex++) {
        final d = calcStart.addDays(dayIndex);
        final daysLeft = d.daysUntil(periodEnd) + 1;
        final dailyAllowance = poolRemaining <= Money.zero(currency)
            ? Money.zero(currency)
            : poolRemaining.divideEvenly(daysLeft)[0];

        if (dayIndex == todayIndex) {
          allowanceToday = dailyAllowance;
        }

        final spentD = spentByDate[d] ?? Money.zero(currency);
        final contribD = contribByDate[d] ?? Money.zero(currency);

        if (dayIndex < todayIndex) {
          final surplus = dailyAllowance - spentD - contribD;
          if (surplus > Money.zero(currency)) {
            derivedGoalSaved = derivedGoalSaved + surplus;
            poolRemaining = poolRemaining - (spentD + contribD + surplus);
          } else {
            poolRemaining = poolRemaining - (spentD + contribD);
          }
        } else {
          poolRemaining = poolRemaining - (spentD + contribD);
        }
      }

      final spentToday = spentByDate[today] ?? Money.zero(currency);
      final contribToday = contribByDate[today] ?? Money.zero(currency);
      final safeToday = allowanceToday - spentToday - contribToday;

      Money tomorrowForecast;
      final daysLeftTomorrow = daysLeftInclToday - 1;
      if (daysLeftTomorrow > 0) {
        final poolForTomorrow = safeToday > Money.zero(currency)
            ? poolRemaining - safeToday
            : poolRemaining;
        tomorrowForecast = poolForTomorrow <= Money.zero(currency)
            ? Money.zero(currency)
            : poolForTomorrow.divideEvenly(daysLeftTomorrow)[0];
      } else {
        tomorrowForecast = nextPeriodBaseForecast != null
            ? nextPeriodBaseForecast()
            : allowanceToday;
      }

      return DaySimulationResult(
        dailyAllowanceToday: allowanceToday,
        safeToday: safeToday,
        spentToday: spentToday,
        tomorrowForecast: tomorrowForecast,
        remainingInPeriod: poolRemaining,
        daysLeftInclToday: daysLeftInclToday,
        derivedGoalSaved: derivedGoalSaved,
      );
  }
}
