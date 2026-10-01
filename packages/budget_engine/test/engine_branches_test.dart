import 'package:budget_engine/budget_engine.dart';
import 'package:test/test.dart';

import 'helpers/test_factories.dart';

void main() {
  group('Engine deep branch coverage', () {
    test('Goal reserve across weekly, biweekly and semimonthly frequencies', () {
      // 1. Weekly frequency
      final weeklyConfig = testBudgetConfig(
        incomeMode: IncomeMode.fixed,
        payFrequency: PayFrequency.weekly,
        payAnchorDate: const LocalDate(2026, 1, 1), // Thursday
        incomePerPaycheck: const Money(50000), // $500.00
      );

      final goal = Goal(
        id: 'g-weekly',
        name: 'Weekly Goal',
        targetAmount: const Money(100000),
        perPaycheckAmount: const Money(5000),
        createdOn: const LocalDate(2026, 1, 1),
      );

      // 3 weeks later (2026-01-22)
      final snapWeekly = computeSnapshot(
        testEngineInput(config: weeklyConfig, goal: goal),
        const LocalDate(2026, 1, 22),
      );
      expect(snapWeekly.goalProgress, isNotNull);
      // 4 periods started: 01-01, 01-08, 01-15, 01-22 -> 4 * 5000 = 20000
      expect(snapWeekly.goalProgress!.savedAmount, equals(const Money(20000)));

      // 2. Biweekly frequency
      final biweeklyConfig = testBudgetConfig(
        incomeMode: IncomeMode.fixed,
        payFrequency: PayFrequency.biweekly,
        payAnchorDate: const LocalDate(2026, 1, 1),
        incomePerPaycheck: const Money(100000),
      );

      // 4 weeks later (2026-01-29) -> 3 periods (01-01, 01-15, 01-29)
      final snapBiweekly = computeSnapshot(
        testEngineInput(config: biweeklyConfig, goal: goal),
        const LocalDate(2026, 1, 29),
      );
      expect(
        snapBiweekly.goalProgress!.savedAmount,
        equals(const Money(15000)),
      );

      // 3. Semimonthly frequency
      final semimonthlyConfig = testBudgetConfig(
        incomeMode: IncomeMode.fixed,
        payFrequency: PayFrequency.semimonthly,
        payAnchorDate: const LocalDate(2026, 1, 1),
        incomePerPaycheck: const Money(120000),
      );

      // March 16 (started Jan 1) -> Jan (2) + Feb (2) + Mar 1 (1) + Mar 16 (1) = 6 periods
      final snapSemimonthly = computeSnapshot(
        testEngineInput(config: semimonthlyConfig, goal: goal),
        const LocalDate(2026, 3, 16),
      );
      expect(
        snapSemimonthly.goalProgress!.savedAmount,
        equals(const Money(30000)),
      );
    });

    test('Fixed mode last day with negative nextPeriodBaseForecast pool', () {
      final config = testBudgetConfig(
        incomeMode: IncomeMode.fixed,
        payFrequency: PayFrequency.monthly,
        payAnchorDate: const LocalDate(2026, 4, 1),
        incomePerPaycheck: const Money(100000), // $1,000.00
      );

      // Large recurring bill in next period exceeding income
      final hugeBill = Bill(
        id: 'b-huge',
        name: 'Huge',
        amount: const Money(150000), // $1,500.00 > $1,000.00
        recurrence: BillRecurrence.monthly,
        firstDueDate: const LocalDate(2026, 4, 5),
      );

      final input = testEngineInput(config: config, bills: [hugeBill]);

      // Last day of period (April 30) -> evaluates nextPeriodBaseForecast
      final snapshot = computeSnapshot(input, const LocalDate(2026, 4, 30));
      // nextPool <= 0 -> tomorrowForecast returns Money.zero
      expect(snapshot.tomorrowForecast, equals(const Money(0)));
    });

    test(
      'Irregular mode with contributions, past bills and negative balance',
      () {
        final config = testBudgetConfig(
          incomeMode: IncomeMode.irregular,
          startingBalance: const Money(10000), // $100.00
          trackingStartDate: const LocalDate(2026, 1, 1),
          safetyHorizonDays: 14,
          bufferPercent: 10,
        );

        // Past contribution on Jan 3, and today's contribution on Jan 5
        final contribPast = GoalContribution(
          id: 'c-past',
          goalId: 'g1',
          amount: const Money(2000), // $20.00
          onDate: const LocalDate(2026, 1, 3),
        );
        final contribToday = GoalContribution(
          id: 'c-today',
          goalId: 'g1',
          amount: const Money(3000), // $30.00
          onDate: const LocalDate(2026, 1, 5),
        );

        // Past expense on Jan 2
        final expPast = Expense(
          id: 'e-past',
          amount: const Money(1000), // $10.00
          spentOn: const LocalDate(2026, 1, 2),
        );

        // Past bill on Jan 4
        final billPast = Bill(
          id: 'b-past',
          name: 'Past Bill',
          amount: const Money(5000), // $50.00
          recurrence: BillRecurrence.monthly,
          firstDueDate: const LocalDate(2026, 1, 4),
        );

        final input = testEngineInput(
          config: config,
          expenses: [expPast],
          contributions: [contribPast, contribToday],
          bills: [billPast],
        );

        final snapshot = computeSnapshot(input, const LocalDate(2026, 1, 5));

        // Balance = 100 - 10 (exp) - 20 (contrib) - 50 (bill) = $20.00
        // Buffer = 10% of 20 = $2.00
        // Spendable = $20 - $0 (no bills in window) - $2 = $18.00
        // Allowance = 1800 ~/ 14 = 128 cents
        // safeToday = 129 - 0 (spent today) - 3000 (contrib today) = -2871 cents
        expect(snapshot.safeToday, equals(const Money(-2871)));
        expect(snapshot.status, equals(BudgetStatus.over));
      },
    );

    test('Irregular mode with negative balanceToday (buffer = zero)', () {
      final config = testBudgetConfig(
        incomeMode: IncomeMode.irregular,
        startingBalance: const Money(1000), // $10.00
        trackingStartDate: const LocalDate(2026, 1, 1),
        safetyHorizonDays: 14,
        bufferPercent: 10,
      );

      // Large past expense making balance negative
      final bigPastExpense = Expense(
        id: 'e-big',
        amount: const Money(5000), // $50.00
        spentOn: const LocalDate(2026, 1, 2),
      );

      final input = testEngineInput(config: config, expenses: [bigPastExpense]);
      final snapshot = computeSnapshot(input, const LocalDate(2026, 1, 5));

      expect(snapshot.shortfall, isTrue);
      expect(snapshot.dailyAllowanceToday, equals(const Money(0)));
      expect(snapshot.tomorrowForecast, equals(const Money(0)));
      expect(snapshot.status, equals(BudgetStatus.over));
    });

    test('Save mode where poolRemaining drops to zero', () {
      final config = testBudgetConfig(
        incomeMode: IncomeMode.fixed,
        payFrequency: PayFrequency.monthly,
        payAnchorDate: const LocalDate(2026, 4, 1),
        incomePerPaycheck: const Money(30000), // $300.00 pool
        rolloverMode: RolloverMode.save,
      );

      final goal = Goal(
        id: 'g-save',
        name: 'Goal',
        targetAmount: const Money(100000),
        perPaycheckAmount: const Money(0),
        createdOn: const LocalDate(2026, 4, 1),
      );

      // Massive overspending on Day 1 that eats the entire pool
      final massiveExpense = Expense(
        id: 'e-massive',
        amount: const Money(50000), // $500.00 > $300.00
        spentOn: const LocalDate(2026, 4, 1),
      );

      final input = testEngineInput(
        config: config,
        goal: goal,
        expenses: [massiveExpense],
      );

      final snapshot = computeSnapshot(input, const LocalDate(2026, 4, 2));

      // poolRemaining <= 0 -> dailyAllowanceToday = 0, tomorrowForecast = 0
      expect(snapshot.dailyAllowanceToday, equals(const Money(0)));
      expect(snapshot.tomorrowForecast, equals(const Money(0)));
    });

    test('Tomorrow mode massive overspending drops baseSchedule to zero', () {
      final config = testBudgetConfig(
        incomeMode: IncomeMode.fixed,
        payFrequency: PayFrequency.monthly,
        payAnchorDate: const LocalDate(2026, 4, 1),
        incomePerPaycheck: const Money(
          30000,
        ), // $300.00 pool / 30 days = $10/day
        rolloverMode: RolloverMode.tomorrow,
      );

      // Massive overspending on Day 1: $600.00 (deficit $590.00 across 29 days is ~$20.34/day reduction)
      final massiveExpense = Expense(
        id: 'e-massive',
        amount: const Money(60000),
        spentOn: const LocalDate(2026, 4, 1),
      );

      final input = testEngineInput(config: config, expenses: [massiveExpense]);
      final snapshot = computeSnapshot(input, const LocalDate(2026, 4, 2));

      // 1000 - 2035 < 0 -> clamped to 0
      expect(snapshot.dailyAllowanceToday, equals(const Money(0)));
      expect(snapshot.tomorrowForecast, equals(const Money(0)));
    });

    test('Bill occurrences month 12 rollover and yearly occurrences', () {
      final monthlyBill = Bill(
        id: 'b-month',
        name: 'Monthly Sub',
        amount: const Money(1000),
        recurrence: BillRecurrence.monthly,
        firstDueDate: const LocalDate(2025, 11, 15),
      );

      final yearlyBill = Bill(
        id: 'b-year',
        name: 'Yearly Insurance',
        amount: const Money(12000),
        recurrence: BillRecurrence.yearly,
        firstDueDate: const LocalDate(2025, 6, 20),
      );

      // Search across year boundary: 2025-11-01 to 2026-02-28
      final occurrences = generateBillOccurrences(
        [monthlyBill, yearlyBill],
        const LocalDate(2025, 11, 1),
        const LocalDate(2026, 2, 28),
      );

      // Monthly occurrences: Nov 15, Dec 15, Jan 15, Feb 15
      final monthlyOccs = occurrences
          .where((o) => o.billId == 'b-month')
          .toList();
      expect(monthlyOccs.length, equals(4));
      expect(monthlyOccs[0].dueDate, equals(const LocalDate(2025, 11, 15)));
      expect(monthlyOccs[1].dueDate, equals(const LocalDate(2025, 12, 15)));
      expect(monthlyOccs[2].dueDate, equals(const LocalDate(2026, 1, 15)));
      expect(monthlyOccs[3].dueDate, equals(const LocalDate(2026, 2, 15)));
    });
  });
}
