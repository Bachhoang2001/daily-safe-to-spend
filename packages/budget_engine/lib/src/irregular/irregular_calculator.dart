import '../bill_occurrences.dart';
import '../local_date.dart';
import '../models/bill.dart';
import '../models/bill_occurrence.dart';
import '../models/budget_config.dart';
import '../models/budget_snapshot.dart';
import '../models/enums.dart';
import '../models/expense.dart';
import '../models/goal_contribution.dart';
import '../models/income_entry.dart';
import '../money.dart';

/// Calculates the [BudgetSnapshot] for irregular income mode ([IncomeMode.irregular]).
///
/// Irregular income mode is tailored for freelancers and gig workers whose cash
/// inflow is variable and unpredictable. Rather than using fixed pay periods,
/// it calculates safe-to-spend dynamically from the current rolling balance
/// projected over a rolling safety horizon window of `H = safetyHorizonDays`
/// (default 14 days).
///
/// ### Algorithmic Steps & Mathematical Formulas
///
/// 1. **Rolling Balance at Today (F02.5):**
///    ```text
///    balance(today) = startingBalance
///                   + Σ income[trackingStartDate .. today]
///                   − Σ expense[trackingStartDate .. today)
///                   − Σ contribution[trackingStartDate .. today)
///                   − Σ bill_occurrence[trackingStartDate .. today)
///    ```
///    *Note:* Past bills due prior to [today] are assumed paid.
///
/// 2. **Safety Horizon Window (H days):**
///    ```text
///    windowEnd     = today.addDays(H - 1)
///    billsInWindow = Σ bill_occurrence.amount for due ∈ [today, windowEnd]
///    buffer        = balance(today) > 0 ? balance(today).percent(bufferPercent) : 0
///    spendable     = balance(today) − billsInWindow − buffer
///    ```
///
/// 3. **Daily Allowance & Shortfall Handling:**
///    - If `spendable < 0` (Shortfall condition):
///      `shortfall = true`, `shortfallAmount = spendable.abs`,
///      `dailyAllowanceToday = Money.zero`,
///      `safeToday = Money.zero − spentToday − contribToday`,
///      `status = BudgetStatus.over`.
///    - If `spendable >= 0`:
///      `shortfall = false`, `shortfallAmount = Money.zero`,
///      `dailyAllowanceToday = spendable.divideEvenly(H)[0]`,
///      `safeToday = dailyAllowanceToday − spentToday − contribToday`,
///      `status = computeStatus(safeToday, dailyAllowanceToday)`.
///
/// 4. **Tomorrow Forecast:**
///    Projects tomorrow's balance as `balanceTomorrow = balanceToday − spentToday − contribToday`,
///    and recalculates spendable balance over window `[today + 1, today + 1 + H - 1]`.
BudgetSnapshot calculateIrregularSnapshot({
  required BudgetConfig config,
  required List<IncomeEntry> incomes,
  required List<Expense> expenses,
  required List<Bill> bills,
  required List<GoalContribution> contributions,
  required LocalDate today,
}) {
  final currency = config.currency;
  final H = config.safetyHorizonDays;
  final trackingStart = config.trackingStartDate;

  // 1. Incomes received up to and including today
  var totalIncome = Money.zero(currency);
  for (final inc in incomes) {
    if (!inc.receivedOn.isBefore(trackingStart) &&
        !inc.receivedOn.isAfter(today)) {
      totalIncome = totalIncome + inc.amount;
    }
  }

  // 2. Expenses and contributions spent strictly before today
  var pastExpenses = Money.zero(currency);
  var spentToday = Money.zero(currency);
  for (final exp in expenses) {
    if (exp.spentOn.isBefore(trackingStart)) continue;
    if (exp.spentOn.isBefore(today)) {
      pastExpenses = pastExpenses + exp.amount;
    } else if (exp.spentOn.isAtSameMomentAs(today)) {
      spentToday = spentToday + exp.amount;
    }
  }

  var pastContrib = Money.zero(currency);
  var contribToday = Money.zero(currency);
  for (final c in contributions) {
    if (c.onDate.isBefore(trackingStart)) continue;
    if (c.onDate.isBefore(today)) {
      pastContrib = pastContrib + c.amount;
    } else if (c.onDate.isAtSameMomentAs(today)) {
      contribToday = contribToday + c.amount;
    }
  }

  // 3. Past bills treated as paid before today
  final pastBillsList = today.isAfter(trackingStart)
      ? generateBillOccurrences(bills, trackingStart, today.addDays(-1))
      : const <BillOccurrence>[];
  var pastBillsSum = Money.zero(currency);
  for (final b in pastBillsList) {
    pastBillsSum = pastBillsSum + b.amount;
  }

  final startBal = config.startingBalance ?? Money.zero(currency);
  final balanceToday =
      startBal + totalIncome - pastExpenses - pastContrib - pastBillsSum;

  // 4. Safety horizon window [today .. today + H - 1]
  final windowEnd = today.addDays(H - 1);
  final windowBills = generateBillOccurrences(bills, today, windowEnd);
  var billsInWindow = Money.zero(currency);
  for (final b in windowBills) {
    billsInWindow = billsInWindow + b.amount;
  }

  final buffer = balanceToday > Money.zero(currency)
      ? balanceToday.percent(config.bufferPercent)
      : Money.zero(currency);

  final spendable = balanceToday - billsInWindow - buffer;

  Money dailyAllowanceToday;
  Money safeToday;
  bool shortfall;
  Money shortfallAmount;
  BudgetStatus status;

  if (spendable < Money.zero(currency)) {
    shortfall = true;
    shortfallAmount = spendable.abs;
    dailyAllowanceToday = Money.zero(currency);
    safeToday = Money.zero(currency) - spentToday - contribToday;
    status = BudgetStatus.over;
  } else {
    shortfall = false;
    shortfallAmount = Money.zero(currency);
    dailyAllowanceToday = spendable.divideEvenly(H)[0];
    safeToday = dailyAllowanceToday - spentToday - contribToday;

    if (safeToday < Money.zero(currency)) {
      status = BudgetStatus.over;
    } else if (dailyAllowanceToday == Money.zero(currency) ||
        safeToday < dailyAllowanceToday.percent(20)) {
      status = BudgetStatus.caution;
    } else {
      status = BudgetStatus.onTrack;
    }
  }

  // 5. Tomorrow forecast
  final balanceTomorrow = balanceToday - spentToday - contribToday;
  final windowTomorrowEnd = today.addDays(H);
  final billsTomorrowList = generateBillOccurrences(
    bills,
    today.addDays(1),
    windowTomorrowEnd,
  );
  var billsTomorrow = Money.zero(currency);
  for (final b in billsTomorrowList) {
    billsTomorrow = billsTomorrow + b.amount;
  }

  final bufferTomorrow = balanceTomorrow > Money.zero(currency)
      ? balanceTomorrow.percent(config.bufferPercent)
      : Money.zero(currency);

  final spendableTomorrow = balanceTomorrow - billsTomorrow - bufferTomorrow;
  final tomorrowForecast = spendableTomorrow > Money.zero(currency)
      ? spendableTomorrow.divideEvenly(H)[0]
      : Money.zero(currency);

  final remainingInPeriod =
      spendable - spentToday - contribToday > Money.zero(currency)
      ? spendable - spentToday - contribToday
      : Money.zero(currency);

  return BudgetSnapshot(
    safeToday: safeToday,
    dailyAllowanceToday: dailyAllowanceToday,
    spentToday: spentToday,
    tomorrowForecast: tomorrowForecast,
    remainingInPeriod: remainingInPeriod,
    daysLeftInclToday: H,
    periodStart: today,
    periodEnd: windowEnd,
    status: status,
    upcomingBills: windowBills,
    shortfall: shortfall,
    shortfallAmount: shortfallAmount,
  );
}
