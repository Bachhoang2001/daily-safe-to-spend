import 'package:drift/drift.dart';
import 'package:safe_to_spend/data/db/tables/common_sync_table.dart';

/// Table storing recurring bills and payment schedules.
@DataClassName('BillData')
class BillsTable extends CommonSyncTable {
  @override
  String get tableName => 'bills';

  /// Logical foreign key reference to the parent budget profile.
  TextColumn get profileId => text()();

  /// User-defined bill name (e.g. 'Internet', 'Rent').
  TextColumn get name => text()();

  /// Due amount in integer cents.
  IntColumn get amountCents => integer()();

  /// Recurrence cycle ('weekly', 'biweekly', 'monthly', 'yearly').
  TextColumn get recurrence => text()();

  /// First due date formatted as ISO string 'YYYY-MM-DD'.
  TextColumn get firstDueDate => text()();

  /// Number of days before due date to trigger notification reminder.
  IntColumn get remindDaysBefore => integer().withDefault(const Constant(1))();

  /// Whether the bill is currently active.
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
