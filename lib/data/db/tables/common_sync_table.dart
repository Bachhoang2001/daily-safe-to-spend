import 'package:drift/drift.dart';

/// Base table defining sync and audit trail columns across all business entities.
abstract class CommonSyncTable extends Table {
  /// Unique primary key formatted as UUID v4.
  TextColumn get id => text()();

  /// Creation timestamp in epoch milliseconds (UTC).
  IntColumn get createdAt => integer()();

  /// Last modification timestamp in epoch milliseconds (UTC).
  IntColumn get updatedAt => integer()();

  /// Soft deletion timestamp in epoch milliseconds (UTC), null if record is active.
  IntColumn get deletedAt => integer().nullable()();

  /// Unique identifier of the device that created/modified this record.
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};
}
