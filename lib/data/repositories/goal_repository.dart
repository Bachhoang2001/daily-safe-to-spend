import 'package:budget_engine/budget_engine.dart';
import 'package:drift/drift.dart';
import 'package:safe_to_spend/core/ids/device_id_provider.dart';
import 'package:safe_to_spend/core/ids/uuid_generator.dart';
import 'package:safe_to_spend/core/time/clock.dart';
import 'package:safe_to_spend/data/db/app_database.dart';
import 'package:safe_to_spend/data/mappers/goal_mapper.dart';
import 'package:safe_to_spend/domain/repositories/i_goal_repository.dart';

/// SQLite implementation of [IGoalRepository] using Drift.
class GoalRepository implements IGoalRepository {
  /// Creates a [GoalRepository].
  GoalRepository({
    required this._db,
    required this._clock,
    required this._uuid,
    required this._deviceIdProvider,
  });

  final AppDatabase _db;
  final Clock _clock;
  final UuidGenerator _uuid;
  final DeviceIdProvider _deviceIdProvider;

  @override
  Stream<Goal?> watchActiveGoal() {
    return (_db.select(_db.goalsTable)
          ..where((t) => t.deletedAt.isNull() & t.isActive.equals(true))
          ..limit(1))
        .watchSingleOrNull()
        .map((row) => row?.toDomain());
  }

  @override
  Future<Goal?> getActiveGoal() async {
    final row =
        await (_db.select(_db.goalsTable)
              ..where((t) => t.deletedAt.isNull() & t.isActive.equals(true))
              ..limit(1))
            .getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Future<void> saveGoal(Goal goal) async {
    final now = _clock.now().millisecondsSinceEpoch;
    final deviceId = await _deviceIdProvider.getDeviceId();
    final goalId = goal.id.isNotEmpty ? goal.id : _uuid.generate();

    final companion = GoalsTableCompanion(
      id: Value(goalId),
      createdAt: Value(now),
      updatedAt: Value(now),
      deviceId: Value(deviceId),
      profileId: const Value('default-profile'),
      name: Value(goal.name),
      targetAmountCents: Value(goal.targetAmount.cents),
      targetDate: Value(goal.targetDate?.toIsoString()),
      perPaycheckCents: Value(goal.perPaycheckAmount.cents),
      createdOn: Value(goal.createdOn.toIsoString()),
      isActive: Value(goal.isActive),
    );

    final existing = await (_db.select(
      _db.goalsTable,
    )..where((t) => t.id.equals(goalId))).getSingleOrNull();

    if (existing != null) {
      await (_db.update(_db.goalsTable)..where((t) => t.id.equals(goalId)))
          .write(companion.copyWith(createdAt: const Value.absent()));
    } else {
      await _db.into(_db.goalsTable).insert(companion);
    }
  }

  @override
  Future<void> softDeleteGoal(String id) async {
    final now = _clock.now().millisecondsSinceEpoch;

    await (_db.update(_db.goalsTable)..where((t) => t.id.equals(id))).write(
      GoalsTableCompanion(
        deletedAt: Value(now),
        updatedAt: Value(now),
        isActive: const Value(false),
      ),
    );
  }

  @override
  Stream<List<GoalContribution>> watchContributions(String goalId) {
    return (_db.select(_db.goalContributionsTable)
          ..where((t) => t.deletedAt.isNull() & t.goalId.equals(goalId))
          ..orderBy([(t) => OrderingTerm.desc(t.onDate)]))
        .watch()
        .map((rows) => rows.map((r) => r.toDomain()).toList());
  }

  @override
  Future<List<GoalContribution>> getContributions(String goalId) async {
    final rows =
        await (_db.select(_db.goalContributionsTable)
              ..where((t) => t.deletedAt.isNull() & t.goalId.equals(goalId))
              ..orderBy([(t) => OrderingTerm.desc(t.onDate)]))
            .get();

    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<void> addContribution(GoalContribution contribution) async {
    final now = _clock.now().millisecondsSinceEpoch;
    final deviceId = await _deviceIdProvider.getDeviceId();
    final id = contribution.id.isNotEmpty ? contribution.id : _uuid.generate();

    await _db
        .into(_db.goalContributionsTable)
        .insert(
          GoalContributionsTableCompanion(
            id: Value(id),
            createdAt: Value(now),
            updatedAt: Value(now),
            deviceId: Value(deviceId),
            goalId: Value(contribution.goalId),
            amountCents: Value(contribution.amount.cents),
            onDate: Value(contribution.onDate.toIsoString()),
            source: Value(contribution.source),
          ),
        );
  }

  @override
  Future<void> softDeleteContribution(String id) async {
    final now = _clock.now().millisecondsSinceEpoch;

    await (_db.update(
      _db.goalContributionsTable,
    )..where((t) => t.id.equals(id))).write(
      GoalContributionsTableCompanion(
        deletedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  @override
  Future<void> restoreContribution(String id) async {
    final now = _clock.now().millisecondsSinceEpoch;

    await (_db.update(
      _db.goalContributionsTable,
    )..where((t) => t.id.equals(id))).write(
      GoalContributionsTableCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(now),
      ),
    );
  }
}
