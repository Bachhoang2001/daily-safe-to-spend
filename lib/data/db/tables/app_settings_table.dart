import 'package:drift/drift.dart';

/// Table storing persistent application configuration key-value pairs.
@DataClassName('AppSettingData')
class AppSettingsTable extends Table {
  @override
  String get tableName => 'app_settings';

  /// Primary key setting identifier.
  TextColumn get key => text()();

  /// Arbitrary string or JSON serialized value.
  TextColumn get value => text()();

  /// Timestamp of the last update in epoch milliseconds (UTC).
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {key};
}
