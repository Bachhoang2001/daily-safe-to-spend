import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:safe_to_spend/data/db/tables/app_settings_table.dart';
import 'package:safe_to_spend/data/db/tables/bills_table.dart';
import 'package:safe_to_spend/data/db/tables/budget_profiles_table.dart';
import 'package:safe_to_spend/data/db/tables/categories_table.dart';
import 'package:safe_to_spend/data/db/tables/expenses_table.dart';
import 'package:safe_to_spend/data/db/tables/goal_contributions_table.dart';
import 'package:safe_to_spend/data/db/tables/goals_table.dart';
import 'package:safe_to_spend/data/db/tables/income_entries_table.dart';

part 'app_database.g.dart';

/// Core SQLite database powering local-first persistence via Drift.
@DriftDatabase(
  tables: [
    BudgetProfilesTable,
    IncomeEntriesTable,
    BillsTable,
    ExpensesTable,
    CategoriesTable,
    GoalsTable,
    GoalContributionsTable,
    AppSettingsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Creates an [AppDatabase] with a custom [QueryExecutor] (used in tests with in-memory DB).
  AppDatabase(super.e);

  /// Creates an [AppDatabase] with default persistent storage running on a background isolate.
  AppDatabase.defaults() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'safe_to_spend.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
