import 'package:budget_engine/budget_engine.dart';

/// Helper factory functions for constructing test inputs and entities with sensible defaults.
BudgetConfig testBudgetConfig({
  String currency = 'USD',
  IncomeMode incomeMode = IncomeMode.fixed,
  PayFrequency? payFrequency = PayFrequency.monthly,
  LocalDate? payAnchorDate = const LocalDate(2026, 1, 1),
  Money? incomePerPaycheck = const Money(300000), // $3,000.00
  Money? firstPeriodBalance,
  Money? startingBalance,
  LocalDate trackingStartDate = const LocalDate(2026, 1, 1),
  int safetyHorizonDays = 14,
  int bufferPercent = 0,
  RolloverMode rolloverMode = RolloverMode.spread,
}) {
  return BudgetConfig(
    currency: currency,
    incomeMode: incomeMode,
    payFrequency: payFrequency,
    payAnchorDate: payAnchorDate,
    incomePerPaycheck: incomePerPaycheck,
    firstPeriodBalance: firstPeriodBalance,
    startingBalance: startingBalance,
    trackingStartDate: trackingStartDate,
    safetyHorizonDays: safetyHorizonDays,
    bufferPercent: bufferPercent,
    rolloverMode: rolloverMode,
  );
}

EngineInput testEngineInput({
  BudgetConfig? config,
  List<IncomeEntry> incomes = const [],
  List<Expense> expenses = const [],
  List<Bill> bills = const [],
  Goal? goal,
  List<GoalContribution> contributions = const [],
}) {
  return EngineInput(
    config: config ?? testBudgetConfig(),
    incomes: incomes,
    expenses: expenses,
    bills: bills,
    goal: goal,
    contributions: contributions,
  );
}
