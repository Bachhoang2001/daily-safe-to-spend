import 'package:budget_engine/budget_engine.dart';
import 'package:test/test.dart';

void main() {
  group('BillOccurrenceGenerator', () {
    test(
      'F02.6-1: Weekly bill generates occurrences every 7 days from firstDueDate weekday',
      () {
        final bill = Bill(
          id: 'bill-weekly',
          name: 'Weekly Fruit Basket',
          amount: const Money(2500), // $25.00
          recurrence: BillRecurrence.weekly,
          firstDueDate: const LocalDate(2026, 10, 5), // Monday
          isActive: true,
        );

        final occurrences = generateBillOccurrences(
          [bill],
          const LocalDate(2026, 10, 1),
          const LocalDate(2026, 10, 26),
        );

        expect(
          occurrences.map((o) => o.dueDate.toIsoString()).toList(),
          equals(['2026-10-05', '2026-10-12', '2026-10-19', '2026-10-26']),
        );
        expect(occurrences.every((o) => o.amount == const Money(2500)), isTrue);
      },
    );

    test('F02.6-2: Monthly bill generates on same day each month', () {
      final bill = Bill(
        id: 'bill-monthly',
        name: 'Electric Utility',
        amount: const Money(8500), // $85.00
        recurrence: BillRecurrence.monthly,
        firstDueDate: const LocalDate(2026, 1, 15),
        isActive: true,
      );

      final occurrences = generateBillOccurrences(
        [bill],
        const LocalDate(2026, 1, 1),
        const LocalDate(2026, 4, 30),
      );

      expect(
        occurrences.map((o) => o.dueDate.toIsoString()).toList(),
        equals(['2026-01-15', '2026-02-15', '2026-03-15', '2026-04-15']),
      );
    });

    test(
      'F02.6-3: Monthly bill on day 31 clamps to month-end for shorter months (Feb 28, Apr 30)',
      () {
        final bill = Bill(
          id: 'bill-end-of-month',
          name: 'Cloud Subscription',
          amount: const Money(1500),
          recurrence: BillRecurrence.monthly,
          firstDueDate: const LocalDate(2026, 1, 31),
          isActive: true,
        );

        final occurrences = generateBillOccurrences(
          [bill],
          const LocalDate(2026, 1, 1),
          const LocalDate(2026, 4, 30),
        );

        expect(
          occurrences.map((o) => o.dueDate.toIsoString()).toList(),
          equals([
            '2026-01-31',
            '2026-02-28', // clamped in 2026
            '2026-03-31',
            '2026-04-30', // clamped
          ]),
        );
      },
    );

    test(
      'F02.6-4: Monthly bill on day 31 in leap year February clamps to 29',
      () {
        final bill = Bill(
          id: 'bill-leap',
          name: 'Cloud Subscription',
          amount: const Money(1500),
          recurrence: BillRecurrence.monthly,
          firstDueDate: const LocalDate(2024, 1, 31),
          isActive: true,
        );

        final occurrences = generateBillOccurrences(
          [bill],
          const LocalDate(2024, 2, 1),
          const LocalDate(2024, 2, 29),
        );

        expect(
          occurrences.map((o) => o.dueDate.toIsoString()).toList(),
          equals(['2024-02-29']),
        );
      },
    );

    test(
      'F02.6-5: Yearly bill generates once every year on due month and day',
      () {
        final bill = Bill(
          id: 'bill-yearly',
          name: 'Domain Renewal',
          amount: const Money(2000),
          recurrence: BillRecurrence.yearly,
          firstDueDate: const LocalDate(2025, 7, 10),
          isActive: true,
        );

        final occurrences = generateBillOccurrences(
          [bill],
          const LocalDate(2026, 1, 1),
          const LocalDate(2028, 12, 31),
        );

        expect(
          occurrences.map((o) => o.dueDate.toIsoString()).toList(),
          equals(['2026-07-10', '2027-07-10', '2028-07-10']),
        );
      },
    );

    test(
      'F02.6-6: Bill occurrences are NOT generated before firstDueDate even if range starts earlier',
      () {
        final bill = Bill(
          id: 'bill-future',
          name: 'Car Insurance',
          amount: const Money(12000),
          recurrence: BillRecurrence.monthly,
          firstDueDate: const LocalDate(2026, 5, 1),
          isActive: true,
        );

        final occurrences = generateBillOccurrences(
          [bill],
          const LocalDate(2026, 1, 1),
          const LocalDate(2026, 6, 30),
        );

        expect(
          occurrences.map((o) => o.dueDate.toIsoString()).toList(),
          equals(['2026-05-01', '2026-06-01']),
        );
      },
    );

    test(
      'F02.6-7: Inactive bills (isActive == false) produce 0 occurrences',
      () {
        final bill = Bill(
          id: 'bill-inactive',
          name: 'Cancelled Gym',
          amount: const Money(5000),
          recurrence: BillRecurrence.monthly,
          firstDueDate: const LocalDate(2026, 1, 1),
          isActive: false,
        );

        final occurrences = generateBillOccurrences(
          [bill],
          const LocalDate(2026, 1, 1),
          const LocalDate(2026, 12, 31),
        );

        expect(occurrences, isEmpty);
      },
    );

    test('F02.6-8: Multiple bills are sorted chronologically by dueDate', () {
      final b1 = Bill(
        id: 'b1',
        name: 'Mid month',
        amount: const Money(3000),
        recurrence: BillRecurrence.monthly,
        firstDueDate: const LocalDate(2026, 10, 15),
        isActive: true,
      );
      final b2 = Bill(
        id: 'b2',
        name: 'Early month',
        amount: const Money(2000),
        recurrence: BillRecurrence.monthly,
        firstDueDate: const LocalDate(2026, 10, 3),
        isActive: true,
      );
      final b3 = Bill(
        id: 'b3',
        name: 'Weekly',
        amount: const Money(1000),
        recurrence: BillRecurrence.weekly,
        firstDueDate: const LocalDate(2026, 10, 7),
        isActive: true,
      );

      final occurrences = generateBillOccurrences(
        [b1, b2, b3],
        const LocalDate(2026, 10, 1),
        const LocalDate(2026, 10, 20),
      );

      final dates = occurrences.map((o) => o.dueDate.toIsoString()).toList();
      expect(
        dates,
        equals(['2026-10-03', '2026-10-07', '2026-10-14', '2026-10-15']),
      );
    });
  });
}
