import 'package:drift/drift.dart';
import 'package:safe_to_spend/data/db/tables/common_sync_table.dart';

/// Table storing discrete manual contributions toward a savings goal.
@DataClassName('GoalContributionData')
class GoalContributionsTable extends CommonSyncTable {
  @override
  String get tableName => 'goal_contributions';

  /// Logical foreign key reference to parent goal.
  TextColumn get goalId => text()();

  /// Contribution amount in integer cents.
  IntColumn get amountCents => integer()();

  /// Business date on which contribution was made ('YYYY-MM-DD').
  TextColumn get onDate => text()();

  /// Origin of the contribution ('manual').
  TextColumn get source => text().withDefault(const Constant('manual'))();
}
