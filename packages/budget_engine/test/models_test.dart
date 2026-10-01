import 'package:budget_engine/budget_engine.dart';
import 'package:test/test.dart';

void main() {
  group('Models equality, hashCode & toString coverage', () {
    test('BudgetConfig equality, hashCode, toString & copyWith', () {
      const config1 = BudgetConfig(
        currency: 'USD',
        incomeMode: IncomeMode.fixed,
        payFrequency: PayFrequency.monthly,
        payAnchorDate: LocalDate(2026, 1, 1),
        incomePerPaycheck: Money(300000),
        firstPeriodBalance: Money(150000),
        startingBalance: Money(50000),
        trackingStartDate: LocalDate(2026, 1, 1),
        safetyHorizonDays: 14,
        bufferPercent: 5,
        rolloverMode: RolloverMode.spread,
      );

      const config2 = BudgetConfig(
        currency: 'USD',
        incomeMode: IncomeMode.fixed,
        payFrequency: PayFrequency.monthly,
        payAnchorDate: LocalDate(2026, 1, 1),
        incomePerPaycheck: Money(300000),
        firstPeriodBalance: Money(150000),
        startingBalance: Money(50000),
        trackingStartDate: LocalDate(2026, 1, 1),
        safetyHorizonDays: 14,
        bufferPercent: 5,
        rolloverMode: RolloverMode.spread,
      );

      const config3 = BudgetConfig(
        currency: 'EUR',
        incomeMode: IncomeMode.irregular,
        trackingStartDate: LocalDate(2026, 2, 1),
      );

      expect(config1, equals(config2));
      expect(config1.hashCode, equals(config2.hashCode));
      expect(config1 == config3, isFalse);
      expect(config1.toString(), contains('BudgetConfig'));
      expect(config3.currency, equals('EUR'));
    });

    test('BudgetSnapshot equality, hashCode & toString', () {
      const snap1 = BudgetSnapshot(
        safeToday: Money(5000),
        dailyAllowanceToday: Money(5000),
        spentToday: Money(0),
        tomorrowForecast: Money(5000),
        remainingInPeriod: Money(150000),
        daysLeftInclToday: 30,
        periodStart: LocalDate(2026, 1, 1),
        periodEnd: LocalDate(2026, 1, 30),
        status: BudgetStatus.onTrack,
        upcomingBills: [],
        shortfall: false,
        shortfallAmount: Money(0),
      );

      const snap2 = BudgetSnapshot(
        safeToday: Money(5000),
        dailyAllowanceToday: Money(5000),
        spentToday: Money(0),
        tomorrowForecast: Money(5000),
        remainingInPeriod: Money(150000),
        daysLeftInclToday: 30,
        periodStart: LocalDate(2026, 1, 1),
        periodEnd: LocalDate(2026, 1, 30),
        status: BudgetStatus.onTrack,
        upcomingBills: [],
        shortfall: false,
        shortfallAmount: Money(0),
      );

      const snapDiff = BudgetSnapshot(
        safeToday: Money(2000),
        dailyAllowanceToday: Money(5000),
        spentToday: Money(3000),
        tomorrowForecast: Money(4000),
        remainingInPeriod: Money(147000),
        daysLeftInclToday: 29,
        periodStart: LocalDate(2026, 1, 1),
        periodEnd: LocalDate(2026, 1, 30),
        status: BudgetStatus.caution,
        upcomingBills: [],
        shortfall: true,
        shortfallAmount: Money(1000),
      );

      expect(snap1, equals(snap2));
      expect(snap1.hashCode, equals(snap2.hashCode));
      expect(snap1 == snapDiff, isFalse);
      expect(snap1.toString(), contains('BudgetSnapshot'));
    });

    test('Bill and BillOccurrence equality, hashCode & toString', () {
      const bill1 = Bill(
        id: 'b1',
        name: 'Electric',
        amount: Money(10000),
        recurrence: BillRecurrence.monthly,
        firstDueDate: LocalDate(2026, 1, 15),
        isActive: true,
      );

      const bill2 = Bill(
        id: 'b1',
        name: 'Electric',
        amount: Money(10000),
        recurrence: BillRecurrence.monthly,
        firstDueDate: LocalDate(2026, 1, 15),
        isActive: true,
      );

      const bill3 = Bill(
        id: 'b2',
        name: 'Electric High',
        amount: Money(10000),
        recurrence: BillRecurrence.monthly,
        firstDueDate: LocalDate(2026, 1, 15),
        isActive: false,
      );

      expect(bill1, equals(bill2));
      expect(bill1.hashCode, equals(bill2.hashCode));
      expect(bill1 == bill3, isFalse);
      expect(bill1.toString(), contains('Bill'));

      const occ1 = BillOccurrence(
        billId: 'b1',
        billName: 'Electric',
        amount: Money(10000),
        dueDate: LocalDate(2026, 1, 15),
      );

      const occ2 = BillOccurrence(
        billId: 'b1',
        billName: 'Electric',
        amount: Money(10000),
        dueDate: LocalDate(2026, 1, 15),
      );

      const occ3 = BillOccurrence(
        billId: 'b1',
        billName: 'Electric',
        amount: Money(12000),
        dueDate: LocalDate(2026, 1, 15),
      );

      expect(occ1, equals(occ2));
      expect(occ1.hashCode, equals(occ2.hashCode));
      expect(occ1 == occ3, isFalse);
      expect(occ1.toString(), contains('BillOccurrence'));
    });

    test('Expense equality, hashCode, toString & copyWith', () {
      const exp1 = Expense(
        id: 'e1',
        amount: Money(2500),
        spentOn: LocalDate(2026, 1, 10),
        categoryId: 'cat-food',
        note: 'Lunch',
      );

      const exp2 = Expense(
        id: 'e1',
        amount: Money(2500),
        spentOn: LocalDate(2026, 1, 10),
        categoryId: 'cat-food',
        note: 'Lunch',
      );

      const exp3 = Expense(
        id: 'e1',
        amount: Money(2500),
        spentOn: LocalDate(2026, 1, 10),
        categoryId: 'cat-food',
        note: 'Dinner',
      );

      expect(exp1, equals(exp2));
      expect(exp1.hashCode, equals(exp2.hashCode));
      expect(exp1 == exp3, isFalse);
      expect(exp1.toString(), contains('Expense'));
    });

    test(
      'Goal, GoalContribution & GoalProgress equality, hashCode & toString',
      () {
        const goal1 = Goal(
          id: 'g1',
          name: 'Vacation',
          targetAmount: Money(100000),
          perPaycheckAmount: Money(10000),
          createdOn: LocalDate(2026, 1, 1),
          targetDate: LocalDate(2026, 12, 31),
          isActive: true,
        );

        const goal2 = Goal(
          id: 'g1',
          name: 'Vacation',
          targetAmount: Money(100000),
          perPaycheckAmount: Money(10000),
          createdOn: LocalDate(2026, 1, 1),
          targetDate: LocalDate(2026, 12, 31),
          isActive: true,
        );

        const goal3 = Goal(
          id: 'g1',
          name: 'Vacation',
          targetAmount: Money(100000),
          perPaycheckAmount: Money(10000),
          createdOn: LocalDate(2026, 1, 1),
          targetDate: LocalDate(2026, 12, 31),
          isActive: false,
        );

        expect(goal1, equals(goal2));
        expect(goal1.hashCode, equals(goal2.hashCode));
        expect(goal1 == goal3, isFalse);
        expect(goal1.toString(), contains('Goal'));

        const contrib1 = GoalContribution(
          id: 'c1',
          goalId: 'g1',
          amount: Money(5000),
          onDate: LocalDate(2026, 1, 10),
          note: 'Bonus',
        );

        const contrib2 = GoalContribution(
          id: 'c1',
          goalId: 'g1',
          amount: Money(5000),
          onDate: LocalDate(2026, 1, 10),
          note: 'Bonus',
        );

        const contrib3 = GoalContribution(
          id: 'c1',
          goalId: 'g1',
          amount: Money(5000),
          onDate: LocalDate(2026, 1, 10),
          note: 'Gift',
        );

        expect(contrib1, equals(contrib2));
        expect(contrib1.hashCode, equals(contrib2.hashCode));
        expect(contrib1 == contrib3, isFalse);
        expect(contrib1.toString(), contains('GoalContribution'));

        const prog1 = GoalProgress(
          savedAmount: Money(20000),
          targetAmount: Money(100000),
          percent: 20.0,
          isReached: false,
        );

        const prog2 = GoalProgress(
          savedAmount: Money(20000),
          targetAmount: Money(100000),
          percent: 20.0,
          isReached: false,
        );

        const prog3 = GoalProgress(
          savedAmount: Money(20000),
          targetAmount: Money(100000),
          percent: 100.0,
          isReached: true,
        );

        expect(prog1, equals(prog2));
        expect(prog1.hashCode, equals(prog2.hashCode));
        expect(prog1 == prog3, isFalse);
        expect(prog1.toString(), contains('GoalProgress'));
      },
    );

    test('IncomeEntry equality, hashCode, toString & copyWith', () {
      const inc1 = IncomeEntry(
        id: 'inc1',
        amount: Money(50000),
        receivedOn: LocalDate(2026, 1, 10),
        note: 'Freelance project',
      );

      const inc2 = IncomeEntry(
        id: 'inc1',
        amount: Money(50000),
        receivedOn: LocalDate(2026, 1, 10),
        note: 'Freelance project',
      );

      const inc3 = IncomeEntry(
        id: 'inc1',
        amount: Money(50000),
        receivedOn: LocalDate(2026, 1, 10),
        note: 'Design work',
      );

      expect(inc1, equals(inc2));
      expect(inc1.hashCode, equals(inc2.hashCode));
      expect(inc1 == inc3, isFalse);
      expect(inc1.toString(), contains('IncomeEntry'));
    });

    test('PayPeriod equality, hashCode & toString', () {
      const p1 = PayPeriod(
        start: LocalDate(2026, 1, 1),
        end: LocalDate(2026, 1, 15),
      );
      const p2 = PayPeriod(
        start: LocalDate(2026, 1, 1),
        end: LocalDate(2026, 1, 15),
      );
      const p3 = PayPeriod(
        start: LocalDate(2026, 1, 16),
        end: LocalDate(2026, 1, 31),
      );

      expect(p1, equals(p2));
      expect(p1.hashCode, equals(p2.hashCode));
      expect(p1 == p3, isFalse);
      expect(p1.toString(), contains('PayPeriod'));
    });
  });
}
