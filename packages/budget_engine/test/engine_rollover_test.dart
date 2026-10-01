import 'package:budget_engine/budget_engine.dart';
import 'package:test/test.dart';

import 'helpers/test_factories.dart';

void main() {
  group('Rollover Modes (Tomorrow boost & Save it)', () {
    test(
      'T02-13: Tomorrow: ngày 1 allowance \$60, tiêu \$10 -> ngày 2 allowance = base + \$50',
      () {
        // Pool $1,800.00, 30 days (April 2026), base = $60.00 / day
        final config = testBudgetConfig(
          incomeMode: IncomeMode.fixed,
          payFrequency: PayFrequency.monthly,
          payAnchorDate: const LocalDate(2026, 4, 1),
          incomePerPaycheck: const Money(300000),
          rolloverMode: RolloverMode.tomorrow,
        );

        final bill = Bill(
          id: 'b-rent',
          name: 'Rent',
          amount: const Money(120000),
          recurrence: BillRecurrence.monthly,
          firstDueDate: const LocalDate(2026, 4, 5),
          isActive: true,
        );

        final expenseDay1 = Expense(
          id: 'exp-d1',
          amount: const Money(1000), // $10.00
          spentOn: const LocalDate(2026, 4, 1),
        );

        final input = testEngineInput(
          config: config,
          bills: [bill],
          expenses: [expenseDay1],
        );

        // Ngày 2: base ($60.00) + carry (allowance $60 - spent $10 = +$50.00) = $110.00
        final snapDay2 = computeSnapshot(input, const LocalDate(2026, 4, 2));

        expect(
          snapDay2.dailyAllowanceToday,
          equals(const Money(11000)),
        ); // $110.00
        expect(snapDay2.safeToday, equals(const Money(11000)));
      },
    );

    test(
      'T02-14: Tomorrow: ngày 1 tiêu vượt \$30 -> ngày 2.. giảm đều; tổng bất biến',
      () {
        final config = testBudgetConfig(
          incomeMode: IncomeMode.fixed,
          payFrequency: PayFrequency.monthly,
          payAnchorDate: const LocalDate(2026, 4, 1),
          incomePerPaycheck: const Money(300000),
          rolloverMode: RolloverMode.tomorrow,
        );

        final bill = Bill(
          id: 'b-rent',
          name: 'Rent',
          amount: const Money(120000),
          recurrence: BillRecurrence.monthly,
          firstDueDate: const LocalDate(2026, 4, 5),
          isActive: true,
        );

        // Ngày 1 tiêu $90 (vượt $30 so với base allowance $60)
        final expenseDay1 = Expense(
          id: 'exp-over-30',
          amount: const Money(9000), // $90.00
          spentOn: const LocalDate(2026, 4, 1),
        );

        final input = testEngineInput(
          config: config,
          bills: [bill],
          expenses: [expenseDay1],
        );

        // Ngày 1
        final snapDay1 = computeSnapshot(input, const LocalDate(2026, 4, 1));
        expect(snapDay1.dailyAllowanceToday, equals(const Money(6000)));
        expect(snapDay1.safeToday, equals(const Money(-3000))); // -$30.00

        // Ngày 2: $30 deficit chia đều cho 29 ngày còn lại ($3000 ~/ 29 = 103 cents, remainder 13)
        // 13 ngày đầu bị trừ 104 cents ($1.04) -> base mới = 6000 - 104 = 5896 cents ($58.96)
        final snapDay2 = computeSnapshot(input, const LocalDate(2026, 4, 2));
        final expectedDay2Allowance =
            const Money(6000) - const Money(3000).divideEvenly(29)[0];
        expect(snapDay2.dailyAllowanceToday, equals(expectedDay2Allowance));
        expect(snapDay2.dailyAllowanceToday, equals(const Money(5896)));

        // Kiểm tra tổng bất biến bảo toàn qua toàn bộ kỳ khi người dùng tiêu đúng hạn mức đã điều chỉnh
        var sumAllowances = const Money(0);
        final currentExpenses = [expenseDay1];

        for (var day = 2; day <= 30; day++) {
          final today = LocalDate(2026, 4, day);
          final loopInput = testEngineInput(
            config: config,
            bills: [bill],
            expenses: currentExpenses,
          );
          final snap = computeSnapshot(loopInput, today);
          sumAllowances += snap.dailyAllowanceToday;

          // Tiêu đúng hạn mức ngày hôm đó (carry = 0 cho ngày kế tiếp)
          currentExpenses.add(
            Expense(
              id: 'exp-$day',
              amount: snap.dailyAllowanceToday,
              spentOn: today,
            ),
          );
        }
        // Total spent Day 1 ($90) + sum of allowances Days 2..30 ($1,710) == Pool ($1,800)
        expect(sumAllowances + const Money(9000), equals(const Money(180000)));
      },
    );

    test(
      'T02-15: Save: ngày 1 dư \$15, có goal -> goalSaved +\$15; ngày 2 allowance không cộng \$15',
      () {
        final config = testBudgetConfig(
          incomeMode: IncomeMode.fixed,
          payFrequency: PayFrequency.monthly,
          payAnchorDate: const LocalDate(2026, 4, 1),
          incomePerPaycheck: const Money(300000),
          rolloverMode: RolloverMode.save,
        );

        final bill = Bill(
          id: 'b-rent',
          name: 'Rent',
          amount: const Money(120000),
          recurrence: BillRecurrence.monthly,
          firstDueDate: const LocalDate(2026, 4, 5),
          isActive: true,
        );

        final goal = Goal(
          id: 'goal-macbook',
          name: 'MacBook',
          targetAmount: const Money(200000),
          perPaycheckAmount: const Money(0),
          createdOn: const LocalDate(2026, 4, 1),
          isActive: true,
        );

        // Ngày 1 tiêu $45 (allowance $60, dư $15)
        final expenseDay1 = Expense(
          id: 'exp-d1',
          amount: const Money(4500), // $45.00
          spentOn: const LocalDate(2026, 4, 1),
        );

        final input = testEngineInput(
          config: config,
          bills: [bill],
          goal: goal,
          expenses: [expenseDay1],
        );

        final snapDay2 = computeSnapshot(input, const LocalDate(2026, 4, 2));

        // Thặng dư $15 được cộng vào goalSaved
        expect(snapDay2.goalProgress, isNotNull);
        expect(snapDay2.goalProgress!.savedAmount, equals(const Money(1500)));

        // Ngày 2 allowance giữ nguyên baseline sạch $60.00 (không cộng $15)
        // Pool còn lại: 1800 - 60 (45 tiêu + 15 lưu) = 1740. 1740 / 29 = $60.00
        expect(snapDay2.dailyAllowanceToday, equals(const Money(6000)));
      },
    );

    test('T02-16: Save khi không có goal -> giống Spread', () {
      final configSaveNoGoal = testBudgetConfig(
        incomeMode: IncomeMode.fixed,
        payFrequency: PayFrequency.monthly,
        payAnchorDate: const LocalDate(2026, 4, 1),
        incomePerPaycheck: const Money(300000),
        rolloverMode: RolloverMode.save,
      );

      final configSpread = testBudgetConfig(
        incomeMode: IncomeMode.fixed,
        payFrequency: PayFrequency.monthly,
        payAnchorDate: const LocalDate(2026, 4, 1),
        incomePerPaycheck: const Money(300000),
        rolloverMode: RolloverMode.spread,
      );

      final bill = Bill(
        id: 'b-rent',
        name: 'Rent',
        amount: const Money(120000),
        recurrence: BillRecurrence.monthly,
        firstDueDate: const LocalDate(2026, 4, 5),
        isActive: true,
      );

      final expenseDay1 = Expense(
        id: 'exp-d1',
        amount: const Money(4500),
        spentOn: const LocalDate(2026, 4, 1),
      );

      final inputSave = testEngineInput(
        config: configSaveNoGoal,
        bills: [bill],
        expenses: [expenseDay1],
        goal: null, // Không có goal
      );

      final inputSpread = testEngineInput(
        config: configSpread,
        bills: [bill],
        expenses: [expenseDay1],
      );

      final snapSave = computeSnapshot(inputSave, const LocalDate(2026, 4, 2));
      final snapSpread = computeSnapshot(
        inputSpread,
        const LocalDate(2026, 4, 2),
      );

      expect(
        snapSave.dailyAllowanceToday,
        equals(snapSpread.dailyAllowanceToday),
      );
      expect(snapSave.safeToday, equals(snapSpread.safeToday));
    });
  });
}
