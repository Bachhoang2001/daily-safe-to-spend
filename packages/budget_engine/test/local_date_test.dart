import 'package:budget_engine/budget_engine.dart';
import 'package:test/test.dart';

void main() {
  group('LocalDate', () {
    test(
      'T01-4: addMonths clamps to last day of month including leap years',
      () {
        // 2026 is not a leap year: Feb has 28 days
        const d1 = LocalDate(2026, 1, 31);
        expect(d1.addMonths(1), equals(const LocalDate(2026, 2, 28)));

        // 2028 is a leap year: Feb has 29 days
        const dLeap = LocalDate(2028, 1, 31);
        expect(dLeap.addMonths(1), equals(const LocalDate(2028, 2, 29)));

        // March 31 + 1 month -> April 30
        const dMarch = LocalDate(2026, 3, 31);
        expect(dMarch.addMonths(1), equals(const LocalDate(2026, 4, 30)));
      },
    );

    test(
      'T01-5: daysUntil calculates correctly across month and year boundaries',
      () {
        // Across month boundary
        const jan30 = LocalDate(2026, 1, 30);
        const feb2 = LocalDate(2026, 2, 2);
        expect(jan30.daysUntil(feb2), equals(3));
        expect(feb2.daysUntil(jan30), equals(-3));

        // Across year boundary
        const dec31 = LocalDate(2025, 12, 31);
        const jan1 = LocalDate(2026, 1, 1);
        expect(dec31.daysUntil(jan1), equals(1));

        // February in non-leap year (2026)
        const feb28 = LocalDate(2026, 2, 28);
        const mar1 = LocalDate(2026, 3, 1);
        expect(feb28.daysUntil(mar1), equals(1));

        // February in leap year (2028)
        const feb28Leap = LocalDate(2028, 2, 28);
        const mar1Leap = LocalDate(2028, 3, 1);
        expect(feb28Leap.daysUntil(mar1Leap), equals(2));
      },
    );

    test(
      'tryParse parses valid ISO-8601 strings and returns null for invalid',
      () {
        expect(
          LocalDate.tryParse('2026-03-15'),
          equals(const LocalDate(2026, 3, 15)),
        );
        expect(LocalDate.tryParse(null), isNull);
        expect(LocalDate.tryParse(''), isNull);
        expect(LocalDate.tryParse('invalid'), isNull);
        expect(LocalDate.tryParse('2026-02-30'), isNull);
        expect(LocalDate.tryParse('2026-13-01'), isNull);
      },
    );
  });
}
