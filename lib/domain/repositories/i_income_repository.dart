import 'package:budget_engine/budget_engine.dart';

/// Contract for managing irregular income entries and manual paycheck logs.
///
/// Used predominantly by the irregular income mode to record incoming cash flows
/// that dynamically replenish the safe-to-spend pool.
///
/// All read operations only return active records where `deleted_at IS NULL`.
abstract class IIncomeRepository {
  /// Emits the list of all active income entries whenever changes occur.
  ///
  /// Entries are sorted chronologically by `receivedOn` descending.
  Stream<List<IncomeEntry>> watchAll();

  /// Retrieves all active income entries asynchronously.
  ///
  /// Entries are sorted chronologically by `receivedOn` descending.
  Future<List<IncomeEntry>> getAll();

  /// Retrieves an active income entry by its unique [id].
  ///
  /// Returns `null` if the record does not exist or has been soft-deleted.
  Future<IncomeEntry?> getById(String id);

  /// Inserts a new [entry] record.
  ///
  /// Automatically generates a UUID v4 if [IncomeEntry.id] is empty, sets
  /// creation and update timestamps to now, and attaches the local device ID.
  Future<void> addIncome(IncomeEntry entry);

  /// Updates mutable fields of an existing income [entry] and advances `updatedAt`.
  Future<void> updateIncome(IncomeEntry entry);

  /// Soft deletes an income entry by setting its `deleted_at` timestamp.
  Future<void> softDelete(String id);

  /// Restores a soft-deleted income entry by clearing its `deleted_at` timestamp.
  Future<void> restore(String id);
}
