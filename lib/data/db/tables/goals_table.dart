import 'package:drift/drift.dart';
import 'package:safe_to_spend/data/db/tables/common_sync_table.dart';

/// Table storing savings goals (maximum 1 active in MVP).
@DataClassName('GoalData')
class GoalsTable extends CommonSyncTable {
  @override
  String get tableName => 'goals';

  /// Logical foreign key reference to parent budget profile.
  TextColumn get profileId => text()();

  /// Goal title (e.g. 'Emergency Fund', 'New Laptop').
  TextColumn get name => text()();

  /// Target goal amount in integer cents.
  IntColumn get targetAmountCents => integer()();

  /// Optional target completion date formatted as ISO string 'YYYY-MM-DD'.
  TextColumn get targetDate => text().nullable()();

  /// Optional planned contribution per paycheck in integer cents.
  IntColumn get perPaycheckCents => integer().nullable()();

  /// Creation business date formatted as ISO string 'YYYY-MM-DD'.
  TextColumn get createdOn => text()();

  /// Whether the goal is currently active.
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
