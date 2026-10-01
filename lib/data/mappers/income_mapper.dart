import 'package:budget_engine/budget_engine.dart';
import 'package:safe_to_spend/data/db/app_database.dart';

/// Extension methods for converting [IncomeEntryData] to engine [IncomeEntry].
extension IncomeMapper on IncomeEntryData {
  /// Converts Drift database row [IncomeEntryData] to domain [IncomeEntry].
  IncomeEntry toDomain([String currency = 'USD']) {
    final safeCurrency = currency.isEmpty ? 'USD' : currency;
    final safeDate =
        LocalDate.tryParse(receivedOn) ?? const LocalDate(2026, 1, 1);
    return IncomeEntry(
      id: id,
      amount: Money(amountCents, safeCurrency),
      receivedOn: safeDate,
      note: note,
    );
  }
}
