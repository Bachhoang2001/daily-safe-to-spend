import 'package:budget_engine/budget_engine.dart';
import 'package:test/test.dart';

void main() {
  group('Money', () {
    test(
      'T01-1: addition and subtraction with same currency and throw on mismatch',
      () {
        const m1 = Money(1000, 'USD');
        const m2 = Money(250, 'USD');

        expect(m1 + m2, equals(const Money(1250, 'USD')));
        expect(m1 - m2, equals(const Money(750, 'USD')));

        const eur = Money(250, 'EUR');
        expect(() => m1 + eur, throwsA(isA<CurrencyMismatchError>()));
        expect(() => m1 - eur, throwsA(isA<CurrencyMismatchError>()));
      },
    );

    test(
      'T01-2: divideEvenly allocates remainder cents to earliest parts and preserves total',
      () {
        const money = Money(1000, 'USD');
        final parts = money.divideEvenly(3);

        expect(parts.length, equals(3));
        expect(parts[0], equals(const Money(334, 'USD')));
        expect(parts[1], equals(const Money(333, 'USD')));
        expect(parts[2], equals(const Money(333, 'USD')));

        final totalCents = parts.fold<int>(0, (sum, item) => sum + item.cents);
        expect(totalCents, equals(money.cents));
      },
    );

    test('T01-3: percent rounds down to cent', () {
      const m999 = Money(999, 'USD');
      // 999 * 10% = 99.9 cents -> rounds DOWN (floor) to 99 cents
      expect(m999.percent(10), equals(const Money(99, 'USD')));

      const m1000 = Money(1000, 'USD');
      expect(m1000.percent(10), equals(const Money(100, 'USD')));
    });
  });
}
