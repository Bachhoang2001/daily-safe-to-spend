import 'package:budget_engine/budget_engine.dart';

/// Contract for daily expense tracking and transaction history data access.
///
/// Implementations provide reactive querying and persistence for user expenses.
/// All monetary values are maintained in integer cents via [Money].
///
/// ### Soft-Delete Semantics:
/// - Default query methods (`watchRange`, `getRange`, `getById`) automatically filter out
///   soft-deleted records (`deleted_at IS NULL`).
/// - [softDelete] sets `deleted_at` to the current timestamp instead of removing the row.
/// - [restore] clears `deleted_at` to support immediate undo functionality in the UI.
abstract class IExpenseRepository {
  /// Emits the list of active expenses falling within `[from, to]` inclusive.
  ///
  /// Results are sorted by `spentOn` descending, then `createdAt` descending.
  /// Re-emits whenever matching expense records are inserted, updated, or soft-deleted.
  Stream<List<Expense>> watchRange({
    required LocalDate from,
    required LocalDate to,
  });

  /// Retrieves active expenses falling within `[from, to]` inclusive.
  ///
  /// Results are sorted by `spentOn` descending, then `createdAt` descending.
  Future<List<Expense>> getRange({
    required LocalDate from,
    required LocalDate to,
  });

  /// Retrieves an active expense by its unique [id].
  ///
  /// Returns `null` if no record exists or if the record has been soft-deleted.
  Future<Expense?> getById(String id);

  /// Inserts a new [expense] record.
  ///
  /// Automatically generates a UUID v4 if [Expense.id] is empty, sets `createdAt`
  /// and `updatedAt` to now, and attaches the local device identifier.
  Future<void> addExpense(Expense expense);

  /// Updates an existing [expense] record.
  ///
  /// Updates mutable fields (`amount`, `spentOn`, `categoryId`, `note`) and
  /// advances the `updatedAt` audit timestamp.
  Future<void> updateExpense(Expense expense);

  /// Soft deletes the expense identified by [id] by setting its `deleted_at` timestamp.
  ///
  /// Once soft-deleted, the record is excluded from all default queries.
  Future<void> softDelete(String id);

  /// Restores a previously soft-deleted expense identified by [id].
  ///
  /// Resets `deleted_at` to `null` and advances `updatedAt`, allowing the user
  /// to undo an accidental deletion immediately from a snackbar.
  Future<void> restore(String id);
}
