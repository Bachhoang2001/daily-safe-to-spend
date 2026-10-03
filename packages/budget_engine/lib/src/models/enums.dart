/// Mode of user income for budget calculation.
enum IncomeMode {
  /// Regular income with a predictable paycheck frequency and amount.
  fixed,

  /// Variable or unpredictable income streams (e.g. freelancers, gig workers).
  irregular,
}

/// Frequency of recurring paychecks in [IncomeMode.fixed].
enum PayFrequency {
  /// Every 7 days, anchored to a known payday.
  weekly,

  /// Every 14 days, anchored to a known payday (computed forward and backward).
  biweekly,

  /// Twice a month: 1st–15th and 16th to end-of-month.
  semimonthly,

  /// Once a month on a specific day of the month (e.g. 25th).
  monthly,
}

/// Policy for how daily surplus or overspending is redistributed on future days.
enum RolloverMode {
  /// Default: Surplus/deficit is evenly distributed across all remaining days in the period.
  spread,

  /// Premium: Surplus from today boosts tomorrow's allowance. Overspending is amortized.
  tomorrow,

  /// Premium: Surplus at the end of each past day is transferred into the savings goal.
  save,
}

/// Financial health status of today's safe-to-spend balance.
enum BudgetStatus {
  /// Healthy: remaining safe-to-spend is `>= 20%` of today's initial allowance.
  onTrack,

  /// Caution: remaining safe-to-spend is between `0` and `< 20%` of today's initial allowance.
  caution,

  /// Overspent: `safeToday < 0`.
  over;

  /// Alias for [onTrack].
  static const BudgetStatus good = BudgetStatus.onTrack;
}

/// Recurrence schedule for recurring bills.
enum BillRecurrence {
  /// Bill repeats every week on a specific weekday.
  weekly,

  /// Bill repeats every month on a specific day of the month.
  monthly,

  /// Bill repeats every year on a specific month and day.
  yearly,
}
