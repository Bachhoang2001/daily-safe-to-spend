import 'package:budget_engine/budget_engine.dart';

/// Contract for managing savings goals and manual savings contributions.
///
/// In MVP, the user can have at most one active savings [Goal]. Contributions can be
/// logged manually against the goal, which are tracked and reflected in [GoalProgress].
///
/// All read operations only return non-deleted records (`deleted_at IS NULL`).
abstract class IGoalRepository {
  /// Emits the currently active savings [Goal], or `null` if no active goal exists.
  Stream<Goal?> watchActiveGoal();

  /// Retrieves the currently active savings [Goal] asynchronously.
  Future<Goal?> getActiveGoal();

  /// Persists a savings [goal].
  ///
  /// If a goal already exists, it is updated in-place with a refreshed `updatedAt`
  /// timestamp. If no goal exists, a new record is created.
  Future<void> saveGoal(Goal goal);

  /// Soft deletes the goal with the given [id] by setting its `deleted_at` timestamp.
  Future<void> softDeleteGoal(String id);

  /// Emits the list of manual contributions made towards the goal identified by [goalId].
  ///
  /// Contributions are sorted by `onDate` descending.
  Stream<List<GoalContribution>> watchContributions(String goalId);

  /// Retrieves all contributions made towards the goal identified by [goalId].
  Future<List<GoalContribution>> getContributions(String goalId);

  /// Records a manual savings [contribution] towards a goal.
  ///
  /// Automatically generates a UUID v4 if [GoalContribution.id] is empty and sets
  /// audit timestamps to now.
  Future<void> addContribution(GoalContribution contribution);

  /// Soft deletes a savings contribution by setting its `deleted_at` timestamp.
  Future<void> softDeleteContribution(String id);

  /// Restores a previously soft-deleted savings contribution.
  Future<void> restoreContribution(String id);
}
