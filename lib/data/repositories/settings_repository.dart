import 'package:drift/drift.dart';
import 'package:safe_to_spend/core/time/clock.dart';
import 'package:safe_to_spend/data/db/app_database.dart';
import 'package:safe_to_spend/domain/repositories/i_settings_repository.dart';

/// SQLite implementation of [ISettingsRepository] using Drift.
class SettingsRepository implements ISettingsRepository {
  /// Creates a [SettingsRepository].
  SettingsRepository({required this._db, required this._clock});

  final AppDatabase _db;
  final Clock _clock;

  @override
  Future<String?> getString(String key) async {
    final row = await (_db.select(
      _db.appSettingsTable,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  @override
  Future<void> setString(String key, String value) async {
    final now = _clock.now().millisecondsSinceEpoch;

    await _db
        .into(_db.appSettingsTable)
        .insertOnConflictUpdate(
          AppSettingsTableCompanion(
            key: Value(key),
            value: Value(value),
            updatedAt: Value(now),
          ),
        );
  }

  @override
  Stream<String?> watchString(String key) {
    return (_db.select(_db.appSettingsTable)..where((t) => t.key.equals(key)))
        .watchSingleOrNull()
        .map((row) => row?.value);
  }

  @override
  Future<void> remove(String key) async {
    await (_db.delete(
      _db.appSettingsTable,
    )..where((t) => t.key.equals(key))).go();
  }

  @override
  Future<bool?> getBool(String key) async {
    final value = await getString(key);
    if (value == null) return null;
    return value.toLowerCase() == 'true';
  }

  @override
  Future<void> setBool(String key, bool value) async {
    await setString(key, value.toString());
  }
}
