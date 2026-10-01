import 'package:budget_engine/budget_engine.dart';
import 'package:safe_to_spend/data/db/app_database.dart';

/// Extension methods for converting [BillData] to engine [Bill].
extension BillMapper on BillData {
  /// Converts Drift database row [BillData] to domain [Bill].
  Bill toDomain([String currency = 'USD']) {
    final safeCurrency = currency.isEmpty ? 'USD' : currency;
    final safeDate =
        LocalDate.tryParse(firstDueDate) ?? const LocalDate(2026, 1, 1);
    return Bill(
      id: id,
      name: name,
      amount: Money(amountCents, safeCurrency),
      recurrence: _parseBillRecurrence(recurrence),
      firstDueDate: safeDate,
      remindDaysBefore: remindDaysBefore < 0 ? 1 : remindDaysBefore,
      isActive: isActive,
    );
  }
}

BillRecurrence _parseBillRecurrence(String value) {
  for (final r in BillRecurrence.values) {
    if (r.name == value) return r;
  }
  return BillRecurrence.monthly;
}
