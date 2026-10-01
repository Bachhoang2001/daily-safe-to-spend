import 'package:budget_engine/budget_engine.dart';
import 'package:intl/intl.dart';

/// Formatter for converting [Money] instances into localized display strings.
class MoneyFormatter {
  const MoneyFormatter._();

  /// Formats [money] according to the designated [locale] and currency symbol.
  ///
  /// Examples:
  /// - `Money(1250, 'USD')` in `en_US` -> `"$12.50"`
  /// - `Money(1250, 'EUR')` in `de_DE` -> `"12,50 €"`
  /// - `Money(1250, 'GBP')` in `en_GB` -> `"£12.50"`
  /// - `Money(-1250, 'USD')` in `en_US` -> `"-$12.50"`
  static String format(
    Money money, {
    String? locale,
    bool includeSymbol = true,
  }) {
    final formatCurrency = NumberFormat.simpleCurrency(
      locale: locale,
      name: money.currency,
      decimalDigits: 2,
    );

    final decimalValue = money.cents / 100.0;
    final formatted = formatCurrency.format(decimalValue);

    if (!includeSymbol) {
      return formatted.replaceAll(formatCurrency.currencySymbol, '').trim();
    }
    return formatted;
  }

  /// Formats [money] in a compact form suitable for widgets and small displays.
  ///
  /// Examples: `"$1.2k"`, `"$150"`.
  static String formatCompact(Money money, {String? locale}) {
    final formatCompact = NumberFormat.compactSimpleCurrency(
      locale: locale,
      name: money.currency,
    );
    final decimalValue = money.cents / 100.0;
    return formatCompact.format(decimalValue);
  }
}
