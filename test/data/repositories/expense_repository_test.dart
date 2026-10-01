import 'package:budget_engine/budget_engine.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_to_spend/data/db/app_database.dart';
import 'package:safe_to_spend/data/repositories/expense_repository.dart';

import '../../helpers/fake_clock.dart';
import '../../helpers/fake_device_id_provider.dart';
import '../../helpers/fake_uuid_generator.dart';

void main() {
  late AppDatabase db;
  late FakeClock clock;
  late FakeUuidGenerator uuid;
  late FakeDeviceIdProvider deviceIdProvider;
  late ExpenseRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    clock = FakeClock(DateTime.utc(2026, 1, 1, 10));
    uuid = FakeUuidGenerator(prefix: 'exp');
    deviceIdProvider = FakeDeviceIdProvider(deviceId: 'device-001');
    repository = ExpenseRepository(
      db: db,
      clock: clock,
      uuid: uuid,
      deviceIdProvider: deviceIdProvider,
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('ExpenseRepository Tests', () {
    test('T03-1: Thêm expense → watchRange phát giá trị mới', () async {
      const from = LocalDate(2026, 1, 1);
      const to = LocalDate(2026, 1, 15);

      final stream = repository.watchRange(from: from, to: to);

      // Verify stream emits initial empty list
      expect(
        stream,
        emitsInOrder(<dynamic>[isEmpty, hasLength(1), hasLength(2)]),
      );

      // Add first expense in range
      await repository.addExpense(
        const Expense(
          id: 'e-1',
          amount: Money(2500),
          spentOn: LocalDate(2026, 1, 5),
          note: 'Lunch',
        ),
      );

      // Add second expense in range
      await repository.addExpense(
        const Expense(
          id: 'e-2',
          amount: Money(4000),
          spentOn: LocalDate(2026, 1, 10),
          note: 'Groceries',
        ),
      );

      // Add an expense out of range (should not trigger new event or appear in this range)
      await repository.addExpense(
        const Expense(
          id: 'e-3',
          amount: Money(9900),
          spentOn: LocalDate(2026, 1, 20),
          note: 'Out of range',
        ),
      );
    });

    test(
      'T03-2: softDelete → không xuất hiện trong query mặc định; restore → xuất hiện lại',
      () async {
        const expense = Expense(
          id: 'e-soft-1',
          amount: Money(3000),
          spentOn: LocalDate(2026, 1, 3),
          note: 'Coffee and bagel',
        );

        await repository.addExpense(expense);

        var activeExpenses = await repository.getRange(
          from: const LocalDate(2026, 1, 1),
          to: const LocalDate(2026, 1, 31),
        );
        expect(activeExpenses, hasLength(1));
        expect(activeExpenses.first.id, 'e-soft-1');

        // Soft delete expense
        clock.advance(const Duration(minutes: 30));
        await repository.softDelete('e-soft-1');

        // Query default must filter deleted_at IS NULL
        activeExpenses = await repository.getRange(
          from: const LocalDate(2026, 1, 1),
          to: const LocalDate(2026, 1, 31),
        );
        expect(activeExpenses, isEmpty);

        // Verify row still exists in database with deletedAt populated
        final rawRow = await (db.select(
          db.expensesTable,
        )..where((t) => t.id.equals('e-soft-1'))).getSingle();
        expect(rawRow.deletedAt, isNotNull);
        expect(rawRow.deletedAt, clock.now().millisecondsSinceEpoch);

        // Restore expense (for Undo action)
        clock.advance(const Duration(minutes: 1));
        await repository.restore('e-soft-1');

        activeExpenses = await repository.getRange(
          from: const LocalDate(2026, 1, 1),
          to: const LocalDate(2026, 1, 31),
        );
        expect(activeExpenses, hasLength(1));
        expect(activeExpenses.first.id, 'e-soft-1');

        final restoredRawRow = await (db.select(
          db.expensesTable,
        )..where((t) => t.id.equals('e-soft-1'))).getSingle();
        expect(restoredRawRow.deletedAt, isNull);
      },
    );

    test('T03-3: update thay đổi updated_at, giữ created_at', () async {
      final initialTime = DateTime.utc(2026, 1, 1, 10);
      clock.time = initialTime;

      const expense = Expense(
        id: 'e-upd-1',
        amount: Money(1500),
        spentOn: LocalDate(2026, 1, 2),
        note: 'Initial note',
      );

      await repository.addExpense(expense);

      final createdRaw = await (db.select(
        db.expensesTable,
      )..where((t) => t.id.equals('e-upd-1'))).getSingle();
      expect(createdRaw.createdAt, initialTime.millisecondsSinceEpoch);
      expect(createdRaw.updatedAt, initialTime.millisecondsSinceEpoch);

      // Advance clock by 2 hours
      final updatedTime = initialTime.add(const Duration(hours: 2));
      clock.time = updatedTime;

      const updatedExpense = Expense(
        id: 'e-upd-1',
        amount: Money(2000), // Adjusted amount
        spentOn: LocalDate(2026, 1, 2),
        note: 'Updated note',
      );

      await repository.updateExpense(updatedExpense);

      final updatedRaw = await (db.select(
        db.expensesTable,
      )..where((t) => t.id.equals('e-upd-1'))).getSingle();
      expect(
        updatedRaw.createdAt,
        initialTime.millisecondsSinceEpoch,
      ); // Preserved
      expect(
        updatedRaw.updatedAt,
        updatedTime.millisecondsSinceEpoch,
      ); // Changed
      expect(updatedRaw.amountCents, 2000);
      expect(updatedRaw.note, 'Updated note');
    });
  });
}
