import 'package:drift/drift.dart';
import 'package:safe_to_spend/data/db/tables/common_sync_table.dart';

/// Table storing discrete income events (used primarily in irregular income mode).
@DataClassName('IncomeEntryData')
class IncomeEntriesTable extends CommonSyncTable {
  @override
  String get tableName => 'income_entries';

  /// Logical foreign key reference to the parent budget profile.
  TextColumn get profileId => text()();

  /// Income amount in integer cents.
  IntColumn get amountCents => integer()();

  /// Date the income was received formatted as ISO string 'YYYY-MM-DD'.
  TextColumn get receivedOn => text()();

  /// Optional description or note for this income.
  TextColumn get note => text().nullable()();
}
