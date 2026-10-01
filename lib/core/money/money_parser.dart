import 'package:budget_engine/budget_engine.dart';

/// Parser that converts numeric keypad strings directly into [Money] instances in cents.
///
/// Designed for `AmountKeypad` input where the user types whole digits representing cents.
///
/// Example:
/// ```dart
/// final m = MoneyParser.parse('1250'); // Money(1250, USD) -> $12.50
/// ```
class MoneyParser {
  const MoneyParser._();

  /// Maximum allowed monetary value: 99,999,999 cents ($999,999.99).
  static const int maxCents = 99999999;

  /// Parses a string of digits entered via `AmountKeypad` into a [Money] instance.
  ///
  /// Non-digit characters are filtered out. Empty or zero strings return a zero [Money].
  /// Values exceeding [maxCents] are clamped to [maxCents].
  ///
  /// Examples:
  /// ```dart
  /// MoneyParser.parse('0'); // Money(0)
  /// MoneyParser.parse(''); // Money(0)
  /// MoneyParser.parse('1250'); // Money(1250) -> $12.50
  /// MoneyParser.parse('100000000'); // Clamped to Money(99999999)
  /// ```
  static Money parse(
    String keypadDigits, [
    String currency = Money.defaultCurrency,
  ]) {
    final cleaned = keypadDigits.replaceAll(RegExp(r'\D'), '');
    if (cleaned.isEmpty) {
      return Money.zero(currency);
    }

    final parsed = int.tryParse(cleaned);
    if (parsed == null || parsed <= 0) {
      return Money.zero(currency);
    }

    final clampedCents = parsed > maxCents ? maxCents : parsed;
    return Money(clampedCents, currency);
  }
}
