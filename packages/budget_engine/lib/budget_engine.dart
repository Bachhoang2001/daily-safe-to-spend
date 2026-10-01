/// Pure Dart business logic & calculation engine for Daily Safe-to-Spend.
///
/// This package encapsulates the pure financial algorithm of the Safe-to-Spend
/// philosophy, completely free of any Flutter SDK, platform channels, or I/O.
library;

/// Current version of the budget engine package.
const String budgetEngineVersion = '0.0.1';

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

  /// Premium: Surplus from today is entirely transferred to boost tomorrow's allowance.
  /// Overspending is amortized evenly across all remaining days.
  tomorrow,

  /// Premium: Leftover allowance at the end of each past day is transferred into the active
  /// savings goal as derived savings, keeping the daily allowance baseline stable.
  save,
}

/// Financial health status of today's safe-to-spend balance.
enum BudgetStatus {
  /// Healthy: remaining safe-to-spend is `>= 20%` of today's initial allowance.
  onTrack,

  /// Caution: remaining safe-to-spend is between `0` and `< 20%` of today's initial allowance.
  caution,

  /// Overspent: `safeToday < 0`.
  over,
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

/// Abstract contract of the input payload passed to the budget engine.
abstract class EngineInput {
  /// Budget configuration parameters.
  dynamic get config;

  /// Incomes recorded within the tracking window (used by irregular mode).
  List<dynamic> get incomes;

  /// Active, non-deleted expenses.
  List<dynamic> get expenses;

  /// Active recurring bills.
  List<dynamic> get bills;

  /// Current savings goal, if any (maximum 1 in MVP).
  dynamic get goal;

  /// Manual contributions made towards the savings goal.
  List<dynamic> get contributions;
}

/// Abstract contract of the snapshot produced by [computeSnapshot].
abstract class BudgetSnapshot {
  /// Remaining amount safe to spend today (can be negative if overspent).
  dynamic get safeToday;

  /// Base daily allowance allocated for today before any expenses today.
  dynamic get dailyAllowanceToday;

  /// Total spending recorded for today.
  dynamic get spentToday;

  /// Projected allowance for tomorrow if no further spending occurs today.
  dynamic get tomorrowForecast;

  /// Total remaining spendable pool in the current period / window.
  dynamic get remainingInPeriod;

  /// Number of days left in the period, including today.
  int get daysLeftInclToday;

  /// Start date of the current calculation period.
  dynamic get periodStart;

  /// End date of the current calculation period.
  dynamic get periodEnd;

  /// Overall health status of the daily budget.
  BudgetStatus get status;

  /// Bills due in the upcoming period / safety window.
  List<dynamic> get upcomingBills;

  /// Progress of the active savings goal, if applicable.
  dynamic get goalProgress;

  /// Flag indicating an irregular cash deficit where bills exceed balance.
  bool get shortfall;

  /// Deficit amount if [shortfall] is true.
  dynamic get shortfallAmount;
}

/// Pure computation function that evaluates safe-to-spend metrics for [today].
///
/// ### Mathematical Foundations
///
/// #### 1. Fixed Income Mode (`IncomeMode.fixed`)
/// - **Paycheck Period:**
///   - `weekly`: 7 days, anchored to `payAnchorDate`.
///   - `biweekly`: 14 days, anchored to `payAnchorDate` by integer multiples of 14.
///   - `semimonthly`: `[1..15]` and `[16..lastDayOfMonth]`.
///   - `monthly`: from `payAnchorDate.day` to day before next pay date.
///   - `periodStart` = nearest pay date `<= today`; `periodEnd` = day before next pay date.
/// - **Period Pool Calculation:**
///   ```text
///   income      = (kỳ chứa trackingStartDate) ? firstPeriodBalance : incomePerPaycheck
///   bills       = Σ hóa đơn có ngày đến hạn ∈ [periodStart, periodEnd]
///                 (kỳ đầu: chỉ tính hóa đơn đến hạn ∈ [trackingStartDate, periodEnd])
///   goalReserve = goal?.perPaycheckAmount ?? 0 (khi goal active và chưa đạt target)
///   buffer      = income * (bufferPercent / 100) (làm tròn xuống cent)
///   pool        = income − bills − goalReserve − buffer
///   ```
///
/// #### 2. Rollover Policies (Fixed Mode)
/// - **Spread (Default):**
///   ```text
///   allowance(d) = (pool − spentBefore(d)) / daysLeftInclDay(d)
///   safeToday    = allowance(today) − spent(today)
///   ```
/// - **Tomorrow Boost (Premium — Spec 023):**
///   ```text
///   base         = pool / totalDaysInPeriod
///   carry(d)     = allowance(d - 1) − spent(d - 1)
///   nếu carry(d) > 0: allowance(d) = baseAdjusted(d) + carry(d)
///   nếu carry(d) < 0: phần âm chia đều cho các ngày còn lại (giảm baseAdjusted từ ngày d)
///   ```
/// - **Save it (Premium — Spec 023):**
///   - Cuối mỗi ngày đã qua, nếu `allowance(d) − spent(d) > 0` thì phần dư
///     chuyển vào `goalSaved` (dữ liệu dẫn xuất, không lưu DB).
///   - Phần dư này không cộng dồn vào các ngày sau.
///   - Nếu không có goal active, hành xử giống `Spread`.
///
/// #### 3. Irregular Income Mode (`IncomeMode.irregular`)
/// - **Rolling Balance:**
///   ```text
///   balance(today) = startingBalance
///                  + Σ income có receivedOn ∈ [trackingStartDate, today]
///                  − Σ expense có spentOn ∈ [trackingStartDate, today)
///                  − Σ contribution có onDate ∈ [trackingStartDate, today)
///                  − Σ bill occurrence có due ∈ [trackingStartDate, today)
///   ```
/// - **Rolling Safety Horizon Window H (mặc định 14 ngày):**
///   ```text
///   window         = [today, today + H − 1]
///   billsInWindow  = Σ bill occurrence có due ∈ window
///   buffer         = balance * (bufferPercent / 100) (nếu balance > 0, ngược lại 0)
///   allowanceToday = max(0, balance − billsInWindow − buffer) / H
///   safeToday      = allowanceToday − spentToday − contributionToday
///   ```
/// - Nếu `balance − billsInWindow − buffer < 0`:
///   `allowanceToday = 0`, `safeToday = -spentToday - contributionToday`,
///   `status = BudgetStatus.over`, `shortfall = true`.
///
/// #### 4. Budget Status Thresholds
/// - `BudgetStatus.over`: `safeToday < 0`.
/// - `BudgetStatus.caution`: `0 <= safeToday < 0.20 * dailyAllowanceToday` (hoặc `dailyAllowanceToday == 0`).
/// - `BudgetStatus.onTrack`: các trường hợp còn lại.
///
/// Note: Full implementation and core primitives (`Money`, `LocalDate`) are implemented in Specs 002 & 003.
BudgetSnapshot computeSnapshot(EngineInput input, dynamic today) {
  throw UnimplementedError('computeSnapshot will be implemented in Spec 003.');
}
