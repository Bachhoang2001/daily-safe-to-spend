import 'package:budget_engine/budget_engine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_to_spend/core/time/local_date_timezone.dart';
import 'package:safe_to_spend/data/db/app_database.dart';
import 'package:safe_to_spend/data/mappers/bill_mapper.dart';
import 'package:safe_to_spend/data/mappers/category_mapper.dart';
import 'package:safe_to_spend/data/mappers/expense_mapper.dart';
import 'package:safe_to_spend/data/mappers/goal_mapper.dart';
import 'package:safe_to_spend/data/mappers/income_mapper.dart';
import 'package:safe_to_spend/data/mappers/profile_mapper.dart';

void main() {
  group('Data Parsing Resilience (Abnormal Data & Edge Cases)', () {
    test(
      'LocalDateFromDateTime handles corrupt/invalid timezone gracefully without crash',
      () {
        final utcNow = DateTime.utc(2026, 10, 2, 14, 30);
        final date = LocalDateFromDateTime.fromDateTime(
          utcNow,
          'Invalid/Non_Existent_Timezone',
        );
        expect(date, equals(const LocalDate(2026, 10, 2)));
      },
    );

    test(
      'ProfileMapper safely handles corrupt strings, unknown enums, and extreme values',
      () {
        const corruptRow = BudgetProfileData(
          id: 'prof-corrupt-1',
          createdAt: 0,
          updatedAt: 0,
          deviceId: 'dev-1',
          currency: '', // empty currency
          incomeMode: 'unknown_mode', // corrupt enum
          payFrequency: 'invalid_frequency', // corrupt enum
          payAnchorDate: 'not-a-date', // malformed date
          incomePerPaycheckCents: -5000, // negative cents
          firstPeriodBalanceCents: 999999999999, // huge cents
          startingBalanceCents: 0,
          trackingStartDate: 'bad-date', // malformed date
          safetyHorizonDays: -5, // negative days
          bufferPercent: -10, // negative percent
          rolloverMode: 'alien_mode', // corrupt enum
          timezone: '', // empty timezone
          weekStart: 99, // invalid week day
          onboardingCompleted: true,
        );

        final domain = corruptRow.toDomain();

        expect(domain.id, equals('prof-corrupt-1'));
        expect(domain.config.currency, equals('USD'));
        expect(domain.config.incomeMode, equals(IncomeMode.fixed));
        expect(domain.config.payFrequency, isNull);
        expect(domain.config.payAnchorDate, isNull);
        expect(domain.config.incomePerPaycheck?.cents, equals(-5000));
        expect(domain.config.firstPeriodBalance?.cents, equals(999999999999));
        expect(
          domain.config.trackingStartDate,
          equals(const LocalDate(2026, 1, 1)),
        );
        expect(domain.config.safetyHorizonDays, equals(14));
        expect(domain.config.bufferPercent, equals(0));
        expect(domain.config.rolloverMode, equals(RolloverMode.spread));
        expect(domain.timezone, equals('UTC'));
        expect(domain.weekStart, equals(1));
      },
    );

    test('ExpenseMapper safely handles corrupt dates and empty currency', () {
      const expenseRow = ExpenseData(
        id: 'exp-corrupt',
        createdAt: 0,
        updatedAt: 0,
        deviceId: 'dev-1',
        profileId: 'prof-1',
        amountCents: -12345,
        spentOn: 'invalid-date-format',
        source: 'manual',
        currency: '',
      );

      final domain = expenseRow.toDomain();
      expect(domain.id, equals('exp-corrupt'));
      expect(domain.amount.cents, equals(-12345));
      expect(domain.amount.currency, equals('USD'));
      expect(domain.spentOn, equals(const LocalDate(2026, 1, 1)));
    });

    test('IncomeMapper safely handles corrupt dates and empty currency', () {
      const incomeRow = IncomeEntryData(
        id: 'inc-corrupt',
        createdAt: 0,
        updatedAt: 0,
        deviceId: 'dev-1',
        profileId: 'prof-1',
        amountCents: 1000000000,
        receivedOn: 'corrupt-date',
      );

      final domain = incomeRow.toDomain('');
      expect(domain.id, equals('inc-corrupt'));
      expect(domain.amount.cents, equals(1000000000));
      expect(domain.amount.currency, equals('USD'));
      expect(domain.receivedOn, equals(const LocalDate(2026, 1, 1)));
    });

    test(
      'BillMapper safely handles corrupt enums, negative remind days, and corrupt dates',
      () {
        const billRow = BillData(
          id: 'bill-corrupt',
          createdAt: 0,
          updatedAt: 0,
          deviceId: 'dev-1',
          profileId: 'prof-1',
          name: 'Weird Bill',
          amountCents: 5000,
          recurrence: 'every_millennium', // unknown enum
          firstDueDate: 'never-due',
          remindDaysBefore: -3,
          isActive: true,
        );

        final domain = billRow.toDomain();
        expect(domain.id, equals('bill-corrupt'));
        expect(domain.recurrence, equals(BillRecurrence.monthly));
        expect(domain.firstDueDate, equals(const LocalDate(2026, 1, 1)));
        expect(domain.remindDaysBefore, equals(1));
      },
    );

    test('GoalMapper safely handles corrupt dates and large amounts', () {
      const goalRow = GoalData(
        id: 'g-corrupt',
        createdAt: 0,
        updatedAt: 0,
        deviceId: 'dev-1',
        profileId: 'prof-1',
        name: 'New Car',
        targetAmountCents: 500000000,
        targetDate: 'corrupt-target-date',
        perPaycheckCents: 10000,
        createdOn: 'corrupt-created-date',
        isActive: true,
      );

      final domain = goalRow.toDomain();
      expect(domain.id, equals('g-corrupt'));
      expect(domain.targetDate, isNull);
      expect(domain.createdOn, equals(const LocalDate(2026, 1, 1)));

      const contributionRow = GoalContributionData(
        id: 'gc-corrupt',
        createdAt: 0,
        updatedAt: 0,
        deviceId: 'dev-1',
        goalId: 'g-corrupt',
        amountCents: 25000,
        onDate: 'bad-contrib-date',
        source: 'manual',
      );

      final contribDomain = contributionRow.toDomain();
      expect(contribDomain.onDate, equals(const LocalDate(2026, 1, 1)));
    });

    test('CategoryMapper properly maps all attributes', () {
      const catRow = CategoryData(
        id: 'cat-1',
        createdAt: 0,
        updatedAt: 0,
        deviceId: 'dev-1',
        nameKey: 'category_food_drink',
        icon: 'restaurant',
        color: '#FF8A65',
        sortOrder: 1,
        isDefault: true,
      );

      final domain = catRow.toDomain();
      expect(domain.id, equals('cat-1'));
      expect(domain.nameKey, equals('category_food_drink'));
      expect(domain.isDefault, isTrue);
    });
  });
}
