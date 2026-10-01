import 'package:budget_engine/budget_engine.dart';
import 'package:test/test.dart';

import 'helpers/test_factories.dart';

void main() {
  group('Irregular Income Engine', () {
    test(
      'T02-17: Irregular: startingBalance \$800, H=14, buffer 10%, bill \$140 trong cửa sổ -> allowance = (800−140−80)/14',
      () {
        final config = testBudgetConfig(
          incomeMode: IncomeMode.irregular,
          startingBalance: const Money(80000), // $800.00
          safetyHorizonDays: 14,
          bufferPercent: 10, // 10% of $800 = $80.00
          trackingStartDate: const LocalDate(2026, 10, 1),
        );

        final bill = Bill(
          id: 'bill-electric',
          name: 'Electric',
          amount: const Money(14000), // $140.00
          recurrence: BillRecurrence.monthly,
          firstDueDate: const LocalDate(2026, 10, 7), // trong cửa sổ [1..14]
          isActive: true,
        );

        final input = testEngineInput(config: config, bills: [bill]);

        final snapshot = computeSnapshot(input, const LocalDate(2026, 10, 1));

        // Balance = $800. Bills in window = $140. Buffer = $80.
        // Spendable = 800 - 140 - 80 = $580.00 (58000 cents).
        // 58000 / 14: 58000 ~/ 14 = 4142 cents, remainder 12 cents.
        // Day 1 gets 4143 cents ($41.43).
        expect(
          snapshot.dailyAllowanceToday,
          equals(const Money(58000).divideEvenly(14)[0]),
        );
        expect(snapshot.dailyAllowanceToday, equals(const Money(4143)));
        expect(snapshot.safeToday, equals(const Money(4143)));
        expect(snapshot.daysLeftInclToday, equals(14));
        expect(snapshot.periodStart, equals(const LocalDate(2026, 10, 1)));
        expect(snapshot.periodEnd, equals(const LocalDate(2026, 10, 14)));
        expect(snapshot.shortfall, isFalse);
      },
    );

    test(
      'T02-18: Irregular: nhận income \$500 hôm nay -> balance tăng ngay hôm nay',
      () {
        final config = testBudgetConfig(
          incomeMode: IncomeMode.irregular,
          startingBalance: const Money(30000), // $300.00
          safetyHorizonDays: 14,
          bufferPercent: 0,
          trackingStartDate: const LocalDate(2026, 10, 1),
        );

        // Nhận income $500 vào ngày hôm nay
        final incomeToday = IncomeEntry(
          id: 'inc-1',
          amount: const Money(50000), // $500.00
          receivedOn: const LocalDate(2026, 10, 5),
        );

        final input = testEngineInput(config: config, incomes: [incomeToday]);

        final snapshot = computeSnapshot(input, const LocalDate(2026, 10, 5));

        // Balance tại hôm nay = 300 + 500 = $800.00
        // allowance = 80000 / 14
        expect(
          snapshot.dailyAllowanceToday,
          equals(const Money(80000).divideEvenly(14)[0]),
        );
      },
    );

    test(
      'T02-19: Irregular: bill đã quá hạn được trừ khỏi balance -> đúng công thức',
      () {
        final config = testBudgetConfig(
          incomeMode: IncomeMode.irregular,
          startingBalance: const Money(100000), // $1,000.00
          safetyHorizonDays: 14,
          bufferPercent: 0,
          trackingStartDate: const LocalDate(2026, 10, 1),
        );

        // Bill đến hạn ngày 10/03 ($200)
        final billPast = Bill(
          id: 'bill-water',
          name: 'Water',
          amount: const Money(20000),
          recurrence: BillRecurrence.monthly,
          firstDueDate: const LocalDate(2026, 10, 3),
          isActive: true,
        );

        final input = testEngineInput(config: config, bills: [billPast]);

        // Hôm nay là ngày 10/10. Bill ngày 10/03 đã quá hạn, coi như đã trả và bị trừ khỏi balance
        // Balance = 1000 - 200 = $800.00.
        // Cửa sổ [10..23] không có thêm bill nào.
        // allowance = 80000 / 14
        final snapshot = computeSnapshot(input, const LocalDate(2026, 10, 10));

        expect(
          snapshot.dailyAllowanceToday,
          equals(const Money(80000).divideEvenly(14)[0]),
        );
      },
    );

    test(
      'T02-20: Irregular shortfall -> allowance 0, shortfall = true, số tiền thiếu đúng',
      () {
        final config = testBudgetConfig(
          incomeMode: IncomeMode.irregular,
          startingBalance: const Money(10000), // $100.00
          safetyHorizonDays: 14,
          bufferPercent: 0,
          trackingStartDate: const LocalDate(2026, 10, 1),
        );

        // Hóa đơn $300 trong cửa sổ trong khi số dư chỉ có $100
        final billHeavy = Bill(
          id: 'bill-rent',
          name: 'Rent',
          amount: const Money(30000), // $300.00
          recurrence: BillRecurrence.monthly,
          firstDueDate: const LocalDate(2026, 10, 5),
          isActive: true,
        );

        final expenseToday = Expense(
          id: 'e1',
          amount: const Money(2000), // $20.00
          spentOn: const LocalDate(2026, 10, 1),
        );

        final input = testEngineInput(
          config: config,
          bills: [billHeavy],
          expenses: [expenseToday],
        );

        final snapshot = computeSnapshot(input, const LocalDate(2026, 10, 1));

        // Thiếu: 100 - 300 = -$200.00
        expect(snapshot.shortfall, isTrue);
        expect(
          snapshot.shortfallAmount,
          equals(const Money(20000)),
        ); // $200.00 thiếu
        expect(snapshot.dailyAllowanceToday, equals(const Money(0)));
        expect(
          snapshot.safeToday,
          equals(const Money(-2000)),
        ); // Âm theo chi tiêu hôm nay
        expect(snapshot.status, equals(BudgetStatus.over));
      },
    );
  });
}
