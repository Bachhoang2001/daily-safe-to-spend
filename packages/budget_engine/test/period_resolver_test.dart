import 'package:budget_engine/budget_engine.dart';
import 'package:test/test.dart';

import 'helpers/test_factories.dart';

void main() {
  group('PeriodResolver & Pay Period Resolution', () {
    test(
      'T02-5: Biweekly anchor 2026-09-25, hôm nay 2026-10-10 -> periodStart 2026-10-09, periodEnd 2026-10-22',
      () {
        const anchor = LocalDate(2026, 9, 25);
        const today = LocalDate(2026, 10, 10);

        final period = resolvePeriod(PayFrequency.biweekly, anchor, today);

        expect(period.start, equals(const LocalDate(2026, 10, 9)));
        expect(period.end, equals(const LocalDate(2026, 10, 22)));
        expect(period.start.daysUntil(period.end) + 1, equals(14));
      },
    );

    test(
      'T02-5.1: Biweekly backwards calculation when today is before anchor date',
      () {
        const anchor = LocalDate(2026, 9, 25);
        const today = LocalDate(2026, 9, 15);

        final period = resolvePeriod(PayFrequency.biweekly, anchor, today);

        expect(period.start, equals(const LocalDate(2026, 9, 11)));
        expect(period.end, equals(const LocalDate(2026, 9, 24)));
        expect(period.start.daysUntil(period.end) + 1, equals(14));
      },
    );

    test(
      'T02-6: Semimonthly, hôm nay 2026-02-20 -> kỳ [16..28], 13 ngày (tháng 2 không nhuận)',
      () {
        const anchor = LocalDate(2026, 1, 1);
        const today = LocalDate(2026, 2, 20);

        final period = resolvePeriod(PayFrequency.semimonthly, anchor, today);

        expect(period.start, equals(const LocalDate(2026, 2, 16)));
        expect(period.end, equals(const LocalDate(2026, 2, 28)));
        expect(period.start.daysUntil(period.end) + 1, equals(13));
      },
    );

    test('T02-6.1: Semimonthly first half of month -> kỳ [1..15], 15 ngày', () {
      const anchor = LocalDate(2026, 1, 1);
      const today = LocalDate(2026, 5, 8);

      final period = resolvePeriod(PayFrequency.semimonthly, anchor, today);

      expect(period.start, equals(const LocalDate(2026, 5, 1)));
      expect(period.end, equals(const LocalDate(2026, 5, 15)));
      expect(period.start.daysUntil(period.end) + 1, equals(15));
    });

    test(
      'T02-6.2: Semimonthly in leap year February 2028 -> kỳ [16..29], 14 ngày',
      () {
        const anchor = LocalDate(2028, 1, 1);
        const today = LocalDate(2028, 2, 25);

        final period = resolvePeriod(PayFrequency.semimonthly, anchor, today);

        expect(period.start, equals(const LocalDate(2028, 2, 16)));
        expect(period.end, equals(const LocalDate(2028, 2, 29)));
        expect(period.start.daysUntil(period.end) + 1, equals(14));
      },
    );

    test(
      'T02-7: Monthly anchor ngày 31, tháng 2 -> ngày lương 28/02 (29 năm nhuận)',
      () {
        const anchor = LocalDate(2026, 1, 31);
        const today = LocalDate(2026, 2, 28);

        final period = resolvePeriod(PayFrequency.monthly, anchor, today);

        // Tháng 2 năm 2026 có 28 ngày -> ngày lương là 28/02, kéo dài tới ngày trước lương tháng 3 (30/03)
        expect(period.start, equals(const LocalDate(2026, 2, 28)));
        expect(period.end, equals(const LocalDate(2026, 3, 30)));
      },
    );

    test(
      'T02-7.1: Monthly anchor ngày 31 trong năm nhuận 2024 -> ngày lương 29/02',
      () {
        const anchor = LocalDate(2024, 1, 31);
        const today = LocalDate(2024, 2, 20);

        final period = resolvePeriod(PayFrequency.monthly, anchor, today);

        // Ngày 20/02 nằm trước ngày lương 29/02, thuộc kỳ từ 31/01 tới 28/02
        expect(period.start, equals(const LocalDate(2024, 1, 31)));
        expect(period.end, equals(const LocalDate(2024, 2, 28)));
      },
    );

    test(
      'T02-7.2: Weekly anchor 2026-10-01 (Thu), hôm nay 2026-10-05 -> kỳ 7 ngày [2026-10-01..2026-10-07]',
      () {
        const anchor = LocalDate(2026, 10, 1);
        const today = LocalDate(2026, 10, 5);

        final period = resolvePeriod(PayFrequency.weekly, anchor, today);

        expect(period.start, equals(const LocalDate(2026, 10, 1)));
        expect(period.end, equals(const LocalDate(2026, 10, 7)));
        expect(period.start.daysUntil(period.end) + 1, equals(7));
      },
    );

    test(
      'T02-8: Kỳ đầu: onboarding ngày 20, firstPeriodBalance \$500, lương kế ngày 1 -> start = ngày 20, chỉ tính bill từ ngày 20',
      () {
        final config = testBudgetConfig(
          incomeMode: IncomeMode.fixed,
          payFrequency: PayFrequency.monthly,
          payAnchorDate: const LocalDate(2026, 10, 1),
          incomePerPaycheck: const Money(300000),
          firstPeriodBalance: const Money(50000), // $500.00
          trackingStartDate: const LocalDate(2026, 10, 20),
        );

        final billPast = Bill(
          id: 'bill-1',
          name: 'Gym',
          amount: const Money(10000), // $100
          recurrence: BillRecurrence.monthly,
          firstDueDate: const LocalDate(2026, 10, 5), // trước ngày 20
          isActive: true,
        );

        final billInPeriod = Bill(
          id: 'bill-2',
          name: 'Internet',
          amount: const Money(6000), // $60
          recurrence: BillRecurrence.monthly,
          firstDueDate: const LocalDate(2026, 10, 25), // sau ngày 20
          isActive: true,
        );

        final input = testEngineInput(
          config: config,
          bills: [billPast, billInPeriod],
        );

        final snapshot = computeSnapshot(input, const LocalDate(2026, 10, 20));

        // Kỳ từ 20/10 đến 31/10 (12 ngày)
        // Pool = $500 - $60 (chỉ tính bill ngày 25, bỏ qua ngày 5) = $440
        // allowance = 440 / 12 = $36.67
        expect(snapshot.periodStart, equals(const LocalDate(2026, 10, 1)));
        expect(snapshot.daysLeftInclToday, equals(12));
        expect(snapshot.upcomingBills.length, equals(1));
        expect(snapshot.upcomingBills.first.billId, equals('bill-2'));
        expect(snapshot.dailyAllowanceToday, equals(const Money(3667)));
      },
    );
  });
}
