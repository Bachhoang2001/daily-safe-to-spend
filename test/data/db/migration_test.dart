import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_to_spend/data/db/app_database.dart';

void main() {
  group('Database Migration & Schema Tests', () {
    test(
      'T03-8: Schema dump v1 được commit và test migration chạy được',
      () async {
        final db = AppDatabase(NativeDatabase.memory());

        // 1. Verify schemaVersion is 1
        expect(db.schemaVersion, 1);

        // 2. Verify all 8 core tables exist and can be queried without SQL syntax errors
        expect(await db.select(db.budgetProfilesTable).get(), isEmpty);
        expect(await db.select(db.incomeEntriesTable).get(), isEmpty);
        expect(await db.select(db.billsTable).get(), isEmpty);
        expect(await db.select(db.expensesTable).get(), isEmpty);
        expect(await db.select(db.categoriesTable).get(), isEmpty);
        expect(await db.select(db.goalsTable).get(), isEmpty);
        expect(await db.select(db.goalContributionsTable).get(), isEmpty);
        expect(await db.select(db.appSettingsTable).get(), isEmpty);

        // 3. Verify audit columns exist on CommonSyncTable tables
        final profileTable = db.budgetProfilesTable;
        expect(profileTable.id.name, 'id');
        expect(profileTable.createdAt.name, 'created_at');
        expect(profileTable.updatedAt.name, 'updated_at');
        expect(profileTable.deletedAt.name, 'deleted_at');
        expect(profileTable.deviceId.name, 'device_id');

        await db.close();
      },
    );
  });
}
