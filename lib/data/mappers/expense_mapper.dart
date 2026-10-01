import 'package:budget_engine/budget_engine.dart';
import 'package:safe_to_spend/data/db/app_database.dart';

/// Extension methods for converting [ExpenseData] to engine [Expense].
extension ExpenseMapper on ExpenseData {
  /// Converts Drift database row [ExpenseData] to domain [Expense].
  Expense toDomain() {
    final safeCurrency = currency.isEmpty ? 'USD' : currency;
    final safeDate = LocalDate.tryParse(spentOn) ?? const LocalDate(2026, 1, 1);
    return Expense(
      id: id,
      amount: Money(amountCents, safeCurrency),
      spentOn: safeDate,
      categoryId: categoryId,
      note: note,
    );
  }
}
