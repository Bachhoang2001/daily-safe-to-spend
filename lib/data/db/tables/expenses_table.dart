import 'package:drift/drift.dart';
import 'package:safe_to_spend/data/db/tables/common_sync_table.dart';

/// Table storing day-to-day expenditure records.
@DataClassName('ExpenseData')
class ExpensesTable extends CommonSyncTable {
  @override
  String get tableName => 'expenses';

  /// Logical foreign key reference to the parent budget profile.
  TextColumn get profileId => text()();

  /// Spent amount in integer cents.
  IntColumn get amountCents => integer()();

  /// Date the expense occurred formatted as ISO string 'YYYY-MM-DD'.
  TextColumn get spentOn => text()();

  /// Optional foreign key to categories table.
  TextColumn get categoryId => text().nullable()();

  /// Optional note or merchant description.
  TextColumn get note => text().nullable()();

  /// Source of the expense record ('manual', 'widget').
  TextColumn get source => text().withDefault(const Constant('manual'))();

  /// Currency code of the transaction (defaults to 'USD').
  TextColumn get currency => text().withDefault(const Constant('USD'))();
}
