import 'package:budget_engine/budget_engine.dart';
import 'package:test/test.dart';

void main() {
  group('Money comprehensive & edge case coverage', () {
    test('CurrencyMismatchError toString()', () {
      final err = CurrencyMismatchError('USD', 'EUR');
      expect(err.toString(), contains('USD'));
      expect(err.toString(), contains('EUR'));
    });

    test('isNegative, isPositive, isZero and abs', () {
      const negative = Money(-500);
      const positive = Money(500);
      const zero = Money.zero();

      expect(negative.isNegative, isTrue);
      expect(negative.isPositive, isFalse);
      expect(negative.isZero, isFalse);
      expect(negative.abs, equals(const Money(500)));

      expect(positive.isNegative, isFalse);
      expect(positive.isPositive, isTrue);
      expect(positive.isZero, isFalse);
      expect(positive.abs, equals(const Money(500)));

      expect(zero.isNegative, isFalse);
      expect(zero.isPositive, isFalse);
      expect(zero.isZero, isTrue);
    });

    test('compareTo, hashCode and toString', () {
      const m1 = Money(100);
      const m2 = Money(200);
      const m3 = Money(100);

      expect(m1.compareTo(m2), isNegative);
      expect(m2.compareTo(m1), isPositive);
      expect(m1.compareTo(m3), equals(0));

      expect(m1.hashCode, equals(m3.hashCode));
      expect(m1.toString(), equals('Money(100, USD)'));
    });

    test('divideEvenly throws ArgumentError on parts <= 0', () {
      const m = Money(1000);
      expect(() => m.divideEvenly(0), throwsArgumentError);
      expect(() => m.divideEvenly(-3), throwsArgumentError);
    });

    test(
      'divideEvenly with negative cents distributes remainder step correctly',
      () {
        const negative = Money(-10);
        final parts = negative.divideEvenly(3);
        // -10 ~/ 3 = -3, remainder = -1
        // part 0: -4, part 1: -3, part 2: -3 -> sum = -10
        expect(parts.length, equals(3));
        expect(parts[0], equals(const Money(-4)));
        expect(parts[1], equals(const Money(-3)));
        expect(parts[2], equals(const Money(-3)));
        expect(
          parts.fold(const Money(0), (acc, p) => acc + p),
          equals(negative),
        );
      },
    );
  });

  group('LocalDate comprehensive & parse edge cases (Item 8)', () {
    test('LocalDate.parse with valid ISO-8601 strings', () {
      final d1 = LocalDate.parse('2026-10-01');
      expect(d1.year, equals(2026));
      expect(d1.month, equals(10));
      expect(d1.day, equals(1));

      final leap = LocalDate.parse('2028-02-29');
      expect(leap.year, equals(2028));
      expect(leap.month, equals(2));
      expect(leap.day, equals(29));
    });

    test(
      'LocalDate.parse throws FormatException on invalid inputs (Item 8)',
      () {
        // Empty or garbage string
        expect(() => LocalDate.parse(''), throwsFormatException);
        expect(() => LocalDate.parse('invalid-date'), throwsFormatException);
        expect(() => LocalDate.parse('2026/10/01'), throwsFormatException);
        expect(() => LocalDate.parse('2026-1-1'), throwsFormatException);

        // Invalid month
        expect(() => LocalDate.parse('2026-00-15'), throwsFormatException);
        expect(() => LocalDate.parse('2026-13-15'), throwsFormatException);

        // Invalid day
        expect(() => LocalDate.parse('2026-04-00'), throwsFormatException);
        expect(
          () => LocalDate.parse('2026-04-31'),
          throwsFormatException,
        ); // April has 30 days
        expect(
          () => LocalDate.parse('2026-02-29'),
          throwsFormatException,
        ); // 2026 is non-leap
        expect(() => LocalDate.parse('2026-01-32'), throwsFormatException);
      },
    );

    test('isLeapYear, lastDayOfMonth, weekday and toString', () {
      const nonLeap = LocalDate(2026, 2, 10);
      const leap = LocalDate(2028, 2, 10);
      const centuryLeap = LocalDate(2000, 1, 1);
      const centuryNonLeap = LocalDate(1900, 1, 1);

      expect(nonLeap.isLeapYear, isFalse);
      expect(leap.isLeapYear, isTrue);
      expect(centuryLeap.isLeapYear, isTrue);
      expect(centuryNonLeap.isLeapYear, isFalse);

      expect(nonLeap.lastDayOfMonth, equals(28));
      expect(leap.lastDayOfMonth, equals(29));

      // 2026-10-01 is Thursday (4)
      const oct1 = LocalDate(2026, 10, 1);
      expect(oct1.weekday, equals(4));

      expect(oct1.toString(), equals('2026-10-01'));
    });

    test('Comparison operators <, <=, >, >=', () {
      const d1 = LocalDate(2026, 1, 1);
      const d2 = LocalDate(2026, 1, 1);
      const d3 = LocalDate(2026, 1, 2);

      expect(d1 < d3, isTrue);
      expect(d3 < d1, isFalse);

      expect(d1 <= d2, isTrue);
      expect(d1 <= d3, isTrue);
      expect(d3 <= d1, isFalse);

      expect(d3 > d1, isTrue);
      expect(d1 > d3, isFalse);

      expect(d1 >= d2, isTrue);
      expect(d3 >= d1, isTrue);
      expect(d1 >= d3, isFalse);
    });
  });
}
