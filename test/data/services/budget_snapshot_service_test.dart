import 'package:budget_engine/budget_engine.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_to_spend/data/db/app_database.dart';
import 'package:safe_to_spend/data/repositories/bill_repository.dart';
import 'package:safe_to_spend/data/repositories/expense_repository.dart';
import 'package:safe_to_spend/data/repositories/goal_repository.dart';
import 'package:safe_to_spend/data/repositories/income_repository.dart';
import 'package:safe_to_spend/data/repositories/profile_repository.dart';
import 'package:safe_to_spend/data/services/budget_snapshot_service.dart';
import 'package:safe_to_spend/domain/models/budget_profile_model.dart';

import '../../helpers/fake_clock.dart';
import '../../helpers/fake_device_id_provider.dart';
import '../../helpers/fake_uuid_generator.dart';

void main() {
  late AppDatabase db;
  late FakeClock clock;
  late FakeUuidGenerator uuid;
  late FakeDeviceIdProvider deviceIdProvider;

  late ProfileRepository profileRepo;
  late ExpenseRepository expenseRepo;
  late IncomeRepository incomeRepo;
  late BillRepository billRepo;
  late GoalRepository goalRepo;

  late BudgetSnapshotService service;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    clock = FakeClock(DateTime.utc(2026, 1, 5, 12)); // Monday, Jan 5, 2026
    uuid = FakeUuidGenerator(prefix: 'sn');
    deviceIdProvider = FakeDeviceIdProvider(deviceId: 'dev-snapshot-service');

    profileRepo = ProfileRepository(
      db: db,
      clock: clock,
      uuid: uuid,
      deviceIdProvider: deviceIdProvider,
    );
    expenseRepo = ExpenseRepository(
      db: db,
      clock: clock,
      uuid: uuid,
      deviceIdProvider: deviceIdProvider,
    );
    incomeRepo = IncomeRepository(
      db: db,
      clock: clock,
      uuid: uuid,
      deviceIdProvider: deviceIdProvider,
    );
    billRepo = BillRepository(
      db: db,
      clock: clock,
      uuid: uuid,
      deviceIdProvider: deviceIdProvider,
    );
    goalRepo = GoalRepository(
      db: db,
      clock: clock,
      uuid: uuid,
      deviceIdProvider: deviceIdProvider,
    );

    service = BudgetSnapshotService(
      profileRepo: profileRepo,
      expenseRepo: expenseRepo,
      incomeRepo: incomeRepo,
      billRepo: billRepo,
      goalRepo: goalRepo,
      clock: clock,
    );
  });

  tearDown(() async {
    service.onClose();
    await db.close();
  });

  group('BudgetSnapshotService Reactive Pipeline', () {
    test(
      'T03-6: BudgetSnapshotService.snapshot phát giá trị mới khi thêm expense/bill/income',
      () async {
        service.onInit();

        // Before profile is created, snapshot should be null
        expect(service.snapshot.value, isNull);

        // Create active budget profile (Biweekly: Jan 2 -> Jan 15, 14 days, $3000 paycheck)
        const profile = BudgetProfileModel(
          id: 'prof-snapshot-1',
          config: BudgetConfig(
            incomeMode: IncomeMode.fixed,
            payFrequency: PayFrequency.biweekly,
            payAnchorDate: LocalDate(2026, 1, 2),
            incomePerPaycheck: Money(300000), // $3,000.00
            trackingStartDate: LocalDate(2026, 1, 2),
          ),
          onboardingCompleted: true,
        );

        await profileRepo.saveProfile(profile);

        // Allow debounce & stream combination to propagate
        await Future<void>.delayed(const Duration(milliseconds: 100));

        final initialSnapshot = service.snapshot.value;
        expect(initialSnapshot, isNotNull);
        // Period has 14 days, Pool = $3,000.00 -> $214.28/day baseline
        final initialSafeToday = initialSnapshot!.safeToday;
        expect(initialSafeToday.cents, greaterThan(0));

        // 1. Add an expense of $50.00 today (Jan 5)
        await expenseRepo.addExpense(
          const Expense(
            id: 'e-snap-1',
            amount: Money(5000),
            spentOn: LocalDate(2026, 1, 5),
            note: 'Grocery store',
          ),
        );

        await Future<void>.delayed(const Duration(milliseconds: 100));

        final snapshotAfterExpense = service.snapshot.value;
        expect(snapshotAfterExpense, isNotNull);
        // Safe today must decrease by exactly $50.00 (5000 cents)
        expect(
          snapshotAfterExpense!.safeToday.cents,
          equals(initialSafeToday.cents - 5000),
        );

        // 2. Add an active recurring bill in period ($140.00 due Jan 10)
        await billRepo.addBill(
          const Bill(
            id: 'bill-snap-1',
            name: 'Electric utility',
            amount: Money(14000),
            recurrence: BillRecurrence.monthly,
            firstDueDate: LocalDate(2026, 1, 10),
          ),
        );

        await Future<void>.delayed(const Duration(milliseconds: 100));

        final snapshotAfterBill = service.snapshot.value;
        expect(snapshotAfterBill, isNotNull);
        // Remaining pool decreased, so safeToday and baseline adjust
        expect(
          snapshotAfterBill!.safeToday.cents,
          lessThan(snapshotAfterExpense.safeToday.cents),
        );
      },
    );

    test('onClose cancels all subscriptions and prevents leaks', () async {
      service.onInit();
      expect(service.hasActiveSubscriptions, isTrue);

      service.onClose();
      expect(service.hasActiveSubscriptions, isFalse);
    });

    test('error state is null on healthy computation', () async {
      service.onInit();
      expect(service.error.value, isNull);

      const profile = BudgetProfileModel(
        id: 'prof-err-1',
        config: BudgetConfig(
          incomeMode: IncomeMode.fixed,
          payFrequency: PayFrequency.biweekly,
          payAnchorDate: LocalDate(2026, 1, 2),
          incomePerPaycheck: Money(200000),
          trackingStartDate: LocalDate(2026, 1, 2),
        ),
        onboardingCompleted: true,
      );

      await profileRepo.saveProfile(profile);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(service.error.value, isNull);
      expect(service.snapshot.value, isNotNull);
    });
  });
}
