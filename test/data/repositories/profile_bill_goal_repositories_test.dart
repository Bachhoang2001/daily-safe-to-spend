import 'package:budget_engine/budget_engine.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_to_spend/data/db/app_database.dart';
import 'package:safe_to_spend/data/repositories/bill_repository.dart';
import 'package:safe_to_spend/data/repositories/category_repository.dart';
import 'package:safe_to_spend/data/repositories/goal_repository.dart';
import 'package:safe_to_spend/data/repositories/income_repository.dart';
import 'package:safe_to_spend/data/repositories/profile_repository.dart';
import 'package:safe_to_spend/data/repositories/settings_repository.dart';
import 'package:safe_to_spend/domain/models/budget_profile_model.dart';
import 'package:safe_to_spend/domain/models/category_model.dart';

import '../../helpers/fake_clock.dart';
import '../../helpers/fake_device_id_provider.dart';
import '../../helpers/fake_uuid_generator.dart';

void main() {
  late AppDatabase db;
  late FakeClock clock;
  late FakeUuidGenerator uuid;
  late FakeDeviceIdProvider deviceIdProvider;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    clock = FakeClock(DateTime.utc(2026, 1, 1, 12));
    uuid = FakeUuidGenerator(prefix: 'id');
    deviceIdProvider = FakeDeviceIdProvider(deviceId: 'device-test-repo');
  });

  tearDown(() async {
    await db.close();
  });

  group('ProfileRepository CRUD', () {
    test(
      'saveProfile, getActiveProfile, hasCompletedOnboarding, watchActiveProfile',
      () async {
        final repo = ProfileRepository(
          db: db,
          clock: clock,
          uuid: uuid,
          deviceIdProvider: deviceIdProvider,
        );

        expect(await repo.getActiveProfile(), isNull);
        expect(await repo.hasCompletedOnboarding(), isFalse);

        const profile = BudgetProfileModel(
          id: 'prof-1',
          config: BudgetConfig(
            incomeMode: IncomeMode.fixed,
            payFrequency: PayFrequency.biweekly,
            payAnchorDate: LocalDate(2026, 1, 2),
            incomePerPaycheck: Money(300000),
            trackingStartDate: LocalDate(2026, 1, 2),
            bufferPercent: 5,
          ),
          timezone: 'America/New_York',
          onboardingCompleted: true,
        );

        await repo.saveProfile(profile);

        final saved = await repo.getActiveProfile();
        expect(saved, isNotNull);
        expect(saved!.id, 'prof-1');
        expect(saved.config.incomeMode, IncomeMode.fixed);
        expect(saved.config.incomePerPaycheck?.cents, 300000);
        expect(saved.timezone, 'America/New_York');
        expect(await repo.hasCompletedOnboarding(), isTrue);

        final streamProfile = await repo.watchActiveProfile().first;
        expect(streamProfile?.id, 'prof-1');
      },
    );
  });

  group('IncomeRepository CRUD & Soft Delete', () {
    test(
      'addIncome, watchAll, getAll, updateIncome, softDelete, restore',
      () async {
        final repo = IncomeRepository(
          db: db,
          clock: clock,
          uuid: uuid,
          deviceIdProvider: deviceIdProvider,
        );

        const entry = IncomeEntry(
          id: 'inc-1',
          amount: Money(120000),
          receivedOn: LocalDate(2026, 1, 5),
          note: 'Freelance design gig',
        );

        await repo.addIncome(entry);
        var incomes = await repo.getAll();
        expect(incomes, hasLength(1));
        expect(incomes.first.amount.cents, 120000);

        // Update
        await repo.updateIncome(
          const IncomeEntry(
            id: 'inc-1',
            amount: Money(150000),
            receivedOn: LocalDate(2026, 1, 5),
            note: 'Freelance design gig + bonus',
          ),
        );
        incomes = await repo.getAll();
        expect(incomes.first.amount.cents, 150000);
        expect(incomes.first.note, contains('bonus'));

        // Soft delete
        await repo.softDelete('inc-1');
        expect(await repo.getAll(), isEmpty);

        // Restore
        await repo.restore('inc-1');
        expect(await repo.getAll(), hasLength(1));
      },
    );
  });

  group('BillRepository CRUD & Soft Delete', () {
    test(
      'addBill, watchActive, getActive, updateBill, softDelete, restore',
      () async {
        final repo = BillRepository(
          db: db,
          clock: clock,
          uuid: uuid,
          deviceIdProvider: deviceIdProvider,
        );

        const bill = Bill(
          id: 'bill-1',
          name: 'Internet',
          amount: Money(7500),
          recurrence: BillRecurrence.monthly,
          firstDueDate: LocalDate(2026, 1, 15),
          remindDaysBefore: 2,
        );

        await repo.addBill(bill);
        final bills = await repo.getActive();
        expect(bills, hasLength(1));
        expect(bills.first.name, 'Internet');
        expect(bills.first.amount.cents, 7500);

        // Soft delete
        await repo.softDelete('bill-1');
        expect(await repo.getActive(), isEmpty);

        // Restore
        await repo.restore('bill-1');
        expect(await repo.getActive(), hasLength(1));
      },
    );
  });

  group('GoalRepository CRUD & Contributions', () {
    test(
      'saveGoal, watchActiveGoal, addContribution, watchContributions, softDelete',
      () async {
        final repo = GoalRepository(
          db: db,
          clock: clock,
          uuid: uuid,
          deviceIdProvider: deviceIdProvider,
        );

        const goal = Goal(
          id: 'goal-1',
          name: 'Emergency Fund',
          targetAmount: Money(500000),
          targetDate: LocalDate(2026, 12, 31),
          createdOn: LocalDate(2026, 1, 1),
        );

        await repo.saveGoal(goal);
        final activeGoal = await repo.getActiveGoal();
        expect(activeGoal, isNotNull);
        expect(activeGoal!.name, 'Emergency Fund');

        const contribution = GoalContribution(
          id: 'contrib-1',
          goalId: 'goal-1',
          amount: Money(50000),
          onDate: LocalDate(2026, 1, 10),
        );

        await repo.addContribution(contribution);
        final contributions = await repo.getContributions('goal-1');
        expect(contributions, hasLength(1));
        expect(contributions.first.amount.cents, 50000);

        // Soft delete goal
        await repo.softDeleteGoal('goal-1');
        expect(await repo.getActiveGoal(), isNull);
      },
    );
  });

  group('CategoryRepository & SettingsRepository', () {
    test('CategoryRepository custom add and softDelete', () async {
      final repo = CategoryRepository(
        db: db,
        clock: clock,
        uuid: uuid,
        deviceIdProvider: deviceIdProvider,
      );

      const customCategory = CategoryModel(
        id: 'cat-custom-1',
        nameKey: '',
        customName: 'Pet Care',
        icon: 'pets',
        color: '#AB47BC',
        sortOrder: 10,
      );

      await repo.addCategory(customCategory);
      var categories = await repo.getCategories();
      expect(
        categories.any((CategoryModel c) => c.customName == 'Pet Care'),
        isTrue,
      );

      await repo.softDelete('cat-custom-1');
      categories = await repo.getCategories();
      expect(
        categories.any((CategoryModel c) => c.id == 'cat-custom-1'),
        isFalse,
      );
    });

    test(
      'SettingsRepository setString, getString, watchString, remove',
      () async {
        final repo = SettingsRepository(db: db, clock: clock);

        expect(await repo.getString('app_theme'), isNull);

        await repo.setString('app_theme', 'dark');
        expect(await repo.getString('app_theme'), 'dark');

        final streamVal = await repo.watchString('app_theme').first;
        expect(streamVal, 'dark');

        await repo.remove('app_theme');
        expect(await repo.getString('app_theme'), isNull);
      },
    );
  });
}
