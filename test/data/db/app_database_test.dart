import 'package:budget_engine/budget_engine.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_to_spend/data/db/app_database.dart';
import 'package:safe_to_spend/data/repositories/category_repository.dart';
import 'package:safe_to_spend/data/repositories/expense_repository.dart';
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
    uuid = FakeUuidGenerator(prefix: 'test-uuid');
    deviceIdProvider = FakeDeviceIdProvider(deviceId: 'device-test-0001');
  });

  tearDown(() async {
    await db.close();
  });

  group('Database Audit & Integrity', () {
    test(
      'T03-4: Mọi bản ghi mới tự sinh UUID v4 hợp lệ và gắn đúng device_id',
      () async {
        final repo = ExpenseRepository(
          db: db,
          clock: clock,
          uuid: uuid,
          deviceIdProvider: deviceIdProvider,
        );

        const expense = Expense(
          id: '', // Empty ID tells repo to generate ID
          amount: Money(5000),
          spentOn: LocalDate(2026, 1, 5),
          note: 'Coffee test',
        );

        await repo.addExpense(expense);

        final expenses = await repo.getRange(
          from: const LocalDate(2026, 1, 1),
          to: const LocalDate(2026, 1, 31),
        );

        expect(expenses, hasLength(1));
        final saved = expenses.first;
        expect(saved.id, startsWith('test-uuid-'));

        // Check raw database row for UUID, timestamps, and device_id
        final rawRows = await db.select(db.expensesTable).get();
        expect(rawRows, hasLength(1));
        final raw = rawRows.first;
        expect(raw.id, saved.id);
        expect(raw.deviceId, 'device-test-0001');
        expect(raw.createdAt, clock.now().millisecondsSinceEpoch);
        expect(raw.updatedAt, clock.now().millisecondsSinceEpoch);
        expect(raw.deletedAt, isNull);
      },
    );

    test(
      'T03-5: Seed danh mục mặc định chạy đúng 1 lần (chạy bootstrap 2 lần không nhân đôi)',
      () async {
        final categoryRepo = CategoryRepository(
          db: db,
          clock: clock,
          uuid: uuid,
          deviceIdProvider: deviceIdProvider,
        );

        // First run of seeding
        await categoryRepo.seedDefaultCategories();
        final categoriesFirst = await categoryRepo.getCategories();
        expect(categoriesFirst, hasLength(8));

        final keysFirst = categoriesFirst
            .map((CategoryModel c) => c.nameKey)
            .toSet();
        expect(
          keysFirst,
          containsAll(<String>[
            'category_food_drink',
            'category_groceries',
            'category_transport',
            'category_shopping',
            'category_fun',
            'category_bills_utilities',
            'category_health',
            'category_other',
          ]),
        );

        // Second run of seeding (must be idempotent)
        await categoryRepo.seedDefaultCategories();
        final categoriesSecond = await categoryRepo.getCategories();
        expect(categoriesSecond, hasLength(8));
      },
    );

    test(
      'T03-7: Tiền lưu và đọc đúng cents (không sai số thập phân)',
      () async {
        final repo = ExpenseRepository(
          db: db,
          clock: clock,
          uuid: uuid,
          deviceIdProvider: deviceIdProvider,
        );

        final testAmounts = <Money>[
          const Money(0),
          const Money(1), // 1 cent = $0.01
          const Money(99), // 99 cents = $0.99
          const Money(123456), // $1,234.56
          const Money(99999999), // $999,999.99
        ];

        for (var i = 0; i < testAmounts.length; i++) {
          final amount = testAmounts[i];
          await repo.addExpense(
            Expense(
              id: 'test-exp-$i',
              amount: amount,
              spentOn: const LocalDate(2026, 1, 10),
            ),
          );
        }

        final readExpenses = await repo.getRange(
          from: const LocalDate(2026, 1, 1),
          to: const LocalDate(2026, 1, 31),
        );

        expect(readExpenses, hasLength(testAmounts.length));
        for (var i = 0; i < testAmounts.length; i++) {
          final found = readExpenses.firstWhere(
            (Expense e) => e.id == 'test-exp-$i',
          );
          expect(found.amount.cents, testAmounts[i].cents);
          expect(found.amount.currency, 'USD');
        }
      },
    );
  });
}
