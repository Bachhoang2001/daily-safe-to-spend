import 'package:budget_engine/budget_engine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_to_spend/core/time/local_date_timezone.dart';

void main() {
  group('LocalDate timezone conversion', () {
    test(
      'T01-6: LocalDate.fromDateTime handles timezone conversions and midnight crossings',
      () {
        // 2026-03-08T07:30:00Z
        final dt1 = DateTime.utc(2026, 3, 8, 7, 30);

        // America/New_York is UTC-5 in March (standard time before DST): 02:30 on 2026-03-08 -> 2026-03-08
        final nyDate = LocalDateFromDateTime.fromDateTime(
          dt1,
          'America/New_York',
        );
        expect(nyDate, equals(const LocalDate(2026, 3, 8)));

        // Pacific/Auckland is UTC+13 in March (daylight saving): 20:30 on 2026-03-08 -> 2026-03-08
        final aucklandDate = LocalDateFromDateTime.fromDateTime(
          dt1,
          'Pacific/Auckland',
        );
        expect(aucklandDate, equals(const LocalDate(2026, 3, 8)));

        // 2026-03-08T03:00:00Z
        final dtMidnightCrossing = DateTime.utc(2026, 3, 8, 3);

        // America/Los_Angeles is UTC-8: 03:00Z - 8h = 19:00 on 2026-03-07 (crosses midnight backwards!)
        final laDate = LocalDateFromDateTime.fromDateTime(
          dtMidnightCrossing,
          'America/Los_Angeles',
        );
        expect(laDate, equals(const LocalDate(2026, 3, 7)));
      },
    );
  });
}
