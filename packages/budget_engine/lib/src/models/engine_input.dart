import 'bill.dart';
import 'budget_config.dart';
import 'expense.dart';
import 'goal.dart';
import 'goal_contribution.dart';
import 'income_entry.dart';

/// Immutable input payload supplied to [computeSnapshot].
class EngineInput {
  /// Budget configuration parameters.
  final BudgetConfig config;

  /// Income entries recorded (used by irregular mode).
  final List<IncomeEntry> incomes;

  /// Non-deleted expenses recorded.
  final List<Expense> expenses;

  /// Active recurring bills.
  final List<Bill> bills;

  /// Currently active savings goal (maximum 1 in MVP).
  final Goal? goal;

  /// Manual contributions made towards the goal.
  final List<GoalContribution> contributions;

  /// Creates an immutable [EngineInput].
  const EngineInput({
    required this.config,
    this.incomes = const [],
    this.expenses = const [],
    this.bills = const [],
    this.goal,
    this.contributions = const [],
  });
}
