import 'package:budget_engine/budget_engine.dart';
import 'package:test/test.dart';

import 'helpers/test_factories.dart';

void main() {
  group('Fixed Engine & Spread Rollover', () {
    test(
      'T02-1: Monthly, lương \$3,000 ngày 1, bill \$1,200 ngày 5, kỳ 30 ngày, hôm nay ngày 1, chưa tiêu -> allowance = \$60.00',
      () {
        // Kỳ 30 ngày: 2026-04-01 đến 2026-04-30
        final config = testBudgetConfig(
          incomeMode: IncomeMode.fixed,
          payFrequency: PayFrequency.monthly,
          payAnchorDate: const LocalDate(2026, 4, 1),
          incomePerPaycheck: const Money(300000), // $3,000.00
          rolloverMode: RolloverMode.spread,
        );

        final bill = Bill(
          id: 'bill-rent',
          name: 'Rent',
          amount: const Money(120000), // $1,200.00
          recurrence: BillRecurrence.monthly,
          firstDueDate: const LocalDate(2026, 4, 5),
          isActive: true,
        );

        final input = testEngineInput(config: config, bills: [bill]);

        final snapshot = computeSnapshot(input, const LocalDate(2026, 4, 1));

        // Pool = $3,000 - $1,200 = $1,800.00. Total days = 30.
        // allowance = 180000 / 30 = 6000 cents ($60.00)
        expect(snapshot.dailyAllowanceToday, equals(const Money(6000)));
        expect(snapshot.spentToday, equals(const Money(0)));
        expect(snapshot.safeToday, equals(const Money(6000)));
        expect(snapshot.daysLeftInclToday, equals(30));
        expect(snapshot.status, equals(BudgetStatus.onTrack));
        expect(snapshot.remainingInPeriod, equals(const Money(180000)));
      },
    );

    test(
      'T02-2: Như T02-1, ngày 1 tiêu \$20 -> safeToday = \$40; tomorrowForecast = (1800−20)/29',
      () {
        final config = testBudgetConfig(
          incomeMode: IncomeMode.fixed,
          payFrequency: PayFrequency.monthly,
          payAnchorDate: const LocalDate(2026, 4, 1),
          incomePerPaycheck: const Money(300000),
          rolloverMode: RolloverMode.spread,
        );

        final bill = Bill(
          id: 'bill-rent',
          name: 'Rent',
          amount: const Money(120000),
          recurrence: BillRecurrence.monthly,
          firstDueDate: const LocalDate(2026, 4, 5),
          isActive: true,
        );

        final expense = Expense(
          id: 'exp-1',
          amount: const Money(2000), // $20.00
          spentOn: const LocalDate(2026, 4, 1),
        );

        final input = testEngineInput(
          config: config,
          bills: [bill],
          expenses: [expense],
        );

        final snapshot = computeSnapshot(input, const LocalDate(2026, 4, 1));

        expect(snapshot.dailyAllowanceToday, equals(const Money(6000)));
        expect(snapshot.spentToday, equals(const Money(2000)));
        expect(snapshot.safeToday, equals(const Money(4000))); // $40.00
        // tomorrowForecast: (180000 - 2000) / 29 = 178000 / 29 = 6137 cents + 1 cent remainder = 6138 cents ($61.38)
        expect(
          snapshot.tomorrowForecast,
          equals(const Money(178000).divideEvenly(29)[0]),
        );
        expect(snapshot.status, equals(BudgetStatus.onTrack));
      },
    );

    test(
      'T02-3: Spread: ngày 1 tiêu \$0, ngày 2 -> allowance ngày 2 = 1800/29 (dư được rải)',
      () {
        final config = testBudgetConfig(
          incomeMode: IncomeMode.fixed,
          payFrequency: PayFrequency.monthly,
          payAnchorDate: const LocalDate(2026, 4, 1),
          incomePerPaycheck: const Money(300000),
          rolloverMode: RolloverMode.spread,
        );

        final bill = Bill(
          id: 'bill-rent',
          name: 'Rent',
          amount: const Money(120000),
          recurrence: BillRecurrence.monthly,
          firstDueDate: const LocalDate(2026, 4, 5),
          isActive: true,
        );

        final input = testEngineInput(
          config: config,
          bills: [bill],
          expenses: const [], // Tiêu $0 ngày 1
        );

        final snapshot = computeSnapshot(input, const LocalDate(2026, 4, 2));

        // Ngày 2: 29 ngày còn lại, pool còn $1800.00
        // 180000 / 29 = 6206 cents + 1 cent remainder = 6207 cents ($62.07)
        expect(
          snapshot.dailyAllowanceToday,
          equals(const Money(180000).divideEvenly(29)[0]),
        );
        expect(snapshot.safeToday, equals(snapshot.dailyAllowanceToday));
        expect(snapshot.daysLeftInclToday, equals(29));
      },
    );

    test(
      'T02-4: Tiêu vượt: ngày 1 tiêu \$200 -> safeToday = −\$140, status over; ngày 2 allowance = 1600/29',
      () {
        final config = testBudgetConfig(
          incomeMode: IncomeMode.fixed,
          payFrequency: PayFrequency.monthly,
          payAnchorDate: const LocalDate(2026, 4, 1),
          incomePerPaycheck: const Money(300000),
          rolloverMode: RolloverMode.spread,
        );

        final bill = Bill(
          id: 'bill-rent',
          name: 'Rent',
          amount: const Money(120000),
          recurrence: BillRecurrence.monthly,
          firstDueDate: const LocalDate(2026, 4, 5),
          isActive: true,
        );

        final expense = Expense(
          id: 'exp-over',
          amount: const Money(20000), // $200.00
          spentOn: const LocalDate(2026, 4, 1),
        );

        final input = testEngineInput(
          config: config,
          bills: [bill],
          expenses: [expense],
        );

        // Kiểm tra ngày 1
        final snapDay1 = computeSnapshot(input, const LocalDate(2026, 4, 1));
        expect(snapDay1.dailyAllowanceToday, equals(const Money(6000)));
        expect(snapDay1.spentToday, equals(const Money(20000)));
        expect(snapDay1.safeToday, equals(const Money(-14000))); // -$140.00
        expect(snapDay1.status, equals(BudgetStatus.over));

        // Kiểm tra ngày 2: pool còn 1800 - 200 = $1600.00, chia cho 29 ngày
        final snapDay2 = computeSnapshot(input, const LocalDate(2026, 4, 2));
        expect(
          snapDay2.dailyAllowanceToday,
          equals(const Money(160000).divideEvenly(29)[0]),
        );
        expect(snapDay2.daysLeftInclToday, equals(29));
        expect(snapDay2.status, equals(BudgetStatus.onTrack));
      },
    );

    test('T02-9: Buffer 5% với income \$3,000 -> pool giảm \$150', () {
      final config = testBudgetConfig(
        incomeMode: IncomeMode.fixed,
        payFrequency: PayFrequency.monthly,
        payAnchorDate: const LocalDate(2026, 4, 1),
        incomePerPaycheck: const Money(300000), // $3,000.00
        bufferPercent: 5, // 5% of $3,000 = $150.00
        rolloverMode: RolloverMode.spread,
      );

      final bill = Bill(
        id: 'bill-rent',
        name: 'Rent',
        amount: const Money(120000), // $1,200.00
        recurrence: BillRecurrence.monthly,
        firstDueDate: const LocalDate(2026, 4, 5),
        isActive: true,
      );

      final input = testEngineInput(config: config, bills: [bill]);
      final snapshot = computeSnapshot(input, const LocalDate(2026, 4, 1));

      // Pool = $3,000 - $1,200 - $150 = $1,650.00
      // allowance = 165000 / 30 = 5500 cents ($55.00)
      expect(snapshot.dailyAllowanceToday, equals(const Money(5500)));
      expect(snapshot.remainingInPeriod, equals(const Money(165000)));
    });

    test(
      'T02-10: Goal perPaycheck \$200 -> pool giảm \$200; goalSaved tăng \$200 mỗi kỳ bắt đầu',
      () {
        final config = testBudgetConfig(
          incomeMode: IncomeMode.fixed,
          payFrequency: PayFrequency.monthly,
          payAnchorDate: const LocalDate(2026, 4, 1),
          incomePerPaycheck: const Money(300000),
          rolloverMode: RolloverMode.spread,
        );

        final goal = Goal(
          id: 'goal-emergency',
          name: 'Emergency Fund',
          targetAmount: const Money(100000), // $1,000.00
          perPaycheckAmount: const Money(20000), // $200.00
          createdOn: const LocalDate(2026, 4, 1),
          isActive: true,
        );

        final input = testEngineInput(config: config, goal: goal);

        final snapshot = computeSnapshot(input, const LocalDate(2026, 4, 1));

        // Pool = $3,000 - $200 = $2,800.00. 280000 / 30 = 9333 cents ($93.34)
        expect(
          snapshot.dailyAllowanceToday,
          equals(const Money(280000).divideEvenly(30)[0]),
        );
        expect(snapshot.goalProgress, isNotNull);
        expect(snapshot.goalProgress!.savedAmount, equals(const Money(20000)));
        expect(snapshot.goalProgress!.percent, equals(20.0));
        expect(snapshot.goalProgress!.isReached, isFalse);
      },
    );

    test('T02-11: Goal đạt target -> goalReserve ngừng trừ kỳ sau', () {
      final config = testBudgetConfig(
        incomeMode: IncomeMode.fixed,
        payFrequency: PayFrequency.monthly,
        payAnchorDate: const LocalDate(2026, 4, 1),
        incomePerPaycheck: const Money(300000),
      );

      final goal = Goal(
        id: 'goal-target',
        name: 'New Laptop',
        targetAmount: const Money(50000), // $500.00
        perPaycheckAmount: const Money(20000), // $200.00
        createdOn: const LocalDate(2026, 4, 1),
        isActive: true,
      );

      // Đã có contribution thủ công đạt đủ $500
      final contrib = GoalContribution(
        id: 'c1',
        goalId: 'goal-target',
        amount: const Money(50000),
        onDate: const LocalDate(2026, 4, 1),
      );

      final input = testEngineInput(
        config: config,
        goal: goal,
        contributions: [contrib],
      );

      final snapshot = computeSnapshot(input, const LocalDate(2026, 4, 1));

      expect(snapshot.goalProgress!.isReached, isTrue);
      // Khi target đã đạt, perPaycheckAmount không còn trừ thêm vào pool nữa
      // Pool = $3,000 (không trừ $200 goalReserve)
      expect(
        snapshot.dailyAllowanceToday,
        equals(const Money(300000).divideEvenly(30)[0]),
      );
    });

    test(
      'T02-12: Contribution thủ công \$50 hôm nay -> safeToday giảm \$50, spentToday không đổi',
      () {
        final config = testBudgetConfig(
          incomeMode: IncomeMode.fixed,
          payFrequency: PayFrequency.monthly,
          payAnchorDate: const LocalDate(2026, 4, 1),
          incomePerPaycheck: const Money(300000),
        );

        final goal = Goal(
          id: 'goal-vacation',
          name: 'Vacation',
          targetAmount: const Money(100000),
          perPaycheckAmount: const Money(0),
          createdOn: const LocalDate(2026, 4, 1),
          isActive: true,
        );

        final contrib = GoalContribution(
          id: 'contrib-1',
          goalId: 'goal-vacation',
          amount: const Money(5000), // $50.00
          onDate: const LocalDate(2026, 4, 1),
        );

        final expense = Expense(
          id: 'exp-lunch',
          amount: const Money(1500), // $15.00
          spentOn: const LocalDate(2026, 4, 1),
        );

        final input = testEngineInput(
          config: config,
          goal: goal,
          contributions: [contrib],
          expenses: [expense],
        );

        final snapshot = computeSnapshot(input, const LocalDate(2026, 4, 1));

        // Base allowance = 300000 / 30 = 10000 cents ($100.00)
        // spentToday = strictly sum of expenses = $15.00
        // safeToday = allowance - spentToday - contribToday = 10000 - 1500 - 5000 = 3500 cents ($35.00)
        expect(snapshot.dailyAllowanceToday, equals(const Money(10000)));
        expect(snapshot.spentToday, equals(const Money(1500)));
        expect(snapshot.safeToday, equals(const Money(3500)));
      },
    );

    test('T02-24: Status caution/onTrack/over theo ngưỡng 20%', () {
      final config = testBudgetConfig(
        incomeMode: IncomeMode.fixed,
        payFrequency: PayFrequency.monthly,
        payAnchorDate: const LocalDate(2026, 4, 1),
        incomePerPaycheck: const Money(300000),
      );

      // Daily allowance = $100.00 (10000 cents) -> 20% threshold = $20.00 (2000 cents)

      // 1. safeToday = $30.00 (>= 20%) -> onTrack
      final inOnTrack = testEngineInput(
        config: config,
        expenses: [
          Expense(
            id: 'e1',
            amount: const Money(7000),
            spentOn: const LocalDate(2026, 4, 1),
          ),
        ],
      );
      expect(
        computeSnapshot(inOnTrack, const LocalDate(2026, 4, 1)).status,
        equals(BudgetStatus.onTrack),
      );

      // 2. safeToday = $15.00 (< 20% and >= 0) -> caution
      final inCaution = testEngineInput(
        config: config,
        expenses: [
          Expense(
            id: 'e2',
            amount: const Money(8500),
            spentOn: const LocalDate(2026, 4, 1),
          ),
        ],
      );
      expect(
        computeSnapshot(inCaution, const LocalDate(2026, 4, 1)).status,
        equals(BudgetStatus.caution),
      );

      // 3. safeToday = -$5.00 (< 0) -> over
      final inOver = testEngineInput(
        config: config,
        expenses: [
          Expense(
            id: 'e3',
            amount: const Money(10500),
            spentOn: const LocalDate(2026, 4, 1),
          ),
        ],
      );
      expect(
        computeSnapshot(inOver, const LocalDate(2026, 4, 1)).status,
        equals(BudgetStatus.over),
      );

      // 4. allowance == 0, safeToday == 0 -> caution
      final inZeroAllowance = testEngineInput(
        config: testBudgetConfig(incomePerPaycheck: const Money(0)),
      );
      expect(
        computeSnapshot(inZeroAllowance, const LocalDate(2026, 1, 1)).status,
        equals(BudgetStatus.caution),
      );
    });
  });
}
