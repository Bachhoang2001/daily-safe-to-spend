import '../local_date.dart';
import '../money.dart';
import 'bill_occurrence.dart';
import 'enums.dart';
import 'goal_progress.dart';

/// An immutable financial snapshot representing today's safe-to-spend balance
/// and forecast metrics computed by the budget engine.
class BudgetSnapshot {
  /// Remaining spendable amount safe to spend today (can be negative if overspent).
  final Money safeToday;

  /// Base daily allowance allocated for today before any expenses or manual contributions today.
  final Money dailyAllowanceToday;

  /// Total spending recorded for today.
  final Money spentToday;

  /// Projected allowance for tomorrow if no further spending occurs today.
  final Money tomorrowForecast;

  /// Remaining spendable pool in the current period (fixed) or spendable balance (irregular).
  final Money remainingInPeriod;

  /// Number of days left in the period or horizon window, including today.
  final int daysLeftInclToday;

  /// Start date of the current calculation period.
  final LocalDate periodStart;

  /// End date of the current calculation period.
  final LocalDate periodEnd;

  /// Overall health status of today's budget ([BudgetStatus.onTrack], caution, or over).
  final BudgetStatus status;

  /// Upcoming bill occurrences within the current period or safety horizon window.
  final List<BillOccurrence> upcomingBills;

  /// Progress of the active savings goal, if configured.
  final GoalProgress? goalProgress;

  /// True if income/balance is insufficient to cover mandatory bills and buffer.
  final bool shortfall;

  /// Deficit amount if [shortfall] is true; otherwise zero.
  final Money shortfallAmount;

  /// Creates an immutable [BudgetSnapshot].
  const BudgetSnapshot({
    required this.safeToday,
    required this.dailyAllowanceToday,
    required this.spentToday,
    required this.tomorrowForecast,
    required this.remainingInPeriod,
    required this.daysLeftInclToday,
    required this.periodStart,
    required this.periodEnd,
    required this.status,
    this.upcomingBills = const [],
    this.goalProgress,
    this.shortfall = false,
    this.shortfallAmount = const Money(0),
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetSnapshot &&
          runtimeType == other.runtimeType &&
          safeToday == other.safeToday &&
          dailyAllowanceToday == other.dailyAllowanceToday &&
          spentToday == other.spentToday &&
          tomorrowForecast == other.tomorrowForecast &&
          remainingInPeriod == other.remainingInPeriod &&
          daysLeftInclToday == other.daysLeftInclToday &&
          periodStart == other.periodStart &&
          periodEnd == other.periodEnd &&
          status == other.status &&
          shortfall == other.shortfall &&
          shortfallAmount == other.shortfallAmount &&
          goalProgress == other.goalProgress;

  @override
  int get hashCode => Object.hash(
    safeToday,
    dailyAllowanceToday,
    spentToday,
    tomorrowForecast,
    remainingInPeriod,
    daysLeftInclToday,
    periodStart,
    periodEnd,
    status,
    shortfall,
    shortfallAmount,
    goalProgress,
  );

  @override
  String toString() =>
      'BudgetSnapshot(safeToday: $safeToday, allowanceToday: $dailyAllowanceToday, spentToday: $spentToday, status: $status)';
}
