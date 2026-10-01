import 'package:budget_engine/budget_engine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_to_spend/core/money/money_parser.dart';

void main() {
  group('MoneyParser', () {
    test(
      'T01-8: parses numeric keypad string to Money in cents, clamps at maximum 99,999,999',
      () {
        // "0" -> 0 cents
        expect(MoneyParser.parse('0'), equals(const Money(0)));

        // "" (empty) -> 0 cents
        expect(MoneyParser.parse(''), equals(const Money(0)));

        // "1250" -> 1250 cents ($12.50)
        expect(MoneyParser.parse('1250'), equals(const Money(1250)));

        // Maximum limit: 99,999,999 cents ($999,999.99)
        expect(MoneyParser.parse('99999999'), equals(const Money(99999999)));

        // Exceeding maximum limit -> clamped to 99,999,999 cents
        expect(MoneyParser.parse('100000000'), equals(const Money(99999999)));
        expect(MoneyParser.parse('99999999999'), equals(const Money(99999999)));
      },
    );
  });
}
