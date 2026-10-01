import 'package:budget_engine/budget_engine.dart';

/// Contract for managing recurring bills and scheduled fixed commitments.
///
/// Bills are recurring expenses (weekly, biweekly, monthly, yearly) whose future
/// occurrences are projected by the budget engine to reserve funds before computing
/// the safe-to-spend allowance.
///
/// All read operations only return active records (`isActive == true` and `deleted_at IS NULL`).
abstract class IBillRepository {
  /// Emits the list of all active recurring bills whenever any bill changes.
  ///
  /// Bills are sorted by `firstDueDate` ascending, then `name` ascending.
  Stream<List<Bill>> watchActive();

  /// Retrieves all active recurring bills asynchronously.
  ///
  /// Bills are sorted by `firstDueDate` ascending, then `name` ascending.
  Future<List<Bill>> getActive();

  /// Retrieves a bill by its unique [id] if it is active and not soft-deleted.
  Future<Bill?> getById(String id);

  /// Inserts a new recurring [bill].
  ///
  /// Automatically generates a UUID v4 if [Bill.id] is empty, sets audit timestamps
  /// to now, and attaches the local device identifier.
  Future<void> addBill(Bill bill);

  /// Updates an existing [bill] record and advances its `updatedAt` audit timestamp.
  Future<void> updateBill(Bill bill);

  /// Soft deletes a bill identified by [id] by setting its `deleted_at` timestamp.
  Future<void> softDelete(String id);

  /// Restores a previously soft-deleted bill identified by [id].
  Future<void> restore(String id);
}
