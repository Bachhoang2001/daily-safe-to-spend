import 'package:budget_engine/budget_engine.dart';
import 'package:drift/drift.dart';
import 'package:safe_to_spend/core/ids/device_id_provider.dart';
import 'package:safe_to_spend/core/ids/uuid_generator.dart';
import 'package:safe_to_spend/core/time/clock.dart';
import 'package:safe_to_spend/data/db/app_database.dart';
import 'package:safe_to_spend/data/mappers/income_mapper.dart';
import 'package:safe_to_spend/domain/repositories/i_income_repository.dart';

/// SQLite implementation of [IIncomeRepository] using Drift.
class IncomeRepository implements IIncomeRepository {
  /// Creates an [IncomeRepository].
  IncomeRepository({
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
  Stream<List<IncomeEntry>> watchAll() {
    return (_db.select(_db.incomeEntriesTable)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm.desc(t.receivedOn),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .watch()
        .map((rows) => rows.map((r) => r.toDomain()).toList());
  }

  @override
  Future<List<IncomeEntry>> getAll() async {
    final rows =
        await (_db.select(_db.incomeEntriesTable)
              ..where((t) => t.deletedAt.isNull())
              ..orderBy([
                (t) => OrderingTerm.desc(t.receivedOn),
                (t) => OrderingTerm.desc(t.createdAt),
              ]))
            .get();

    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<IncomeEntry?> getById(String id) async {
    final row = await (_db.select(
      _db.incomeEntriesTable,
    )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Future<void> addIncome(IncomeEntry entry) async {
    final now = _clock.now().millisecondsSinceEpoch;
    final deviceId = await _deviceIdProvider.getDeviceId();
    final id = entry.id.isNotEmpty ? entry.id : _uuid.generate();

    await _db
        .into(_db.incomeEntriesTable)
        .insert(
          IncomeEntriesTableCompanion(
            id: Value(id),
            createdAt: Value(now),
            updatedAt: Value(now),
            deviceId: Value(deviceId),
            profileId: const Value('default-profile'),
            amountCents: Value(entry.amount.cents),
            receivedOn: Value(entry.receivedOn.toIsoString()),
            note: Value(entry.note),
          ),
        );
  }

  @override
  Future<void> updateIncome(IncomeEntry entry) async {
    final now = _clock.now().millisecondsSinceEpoch;

    await (_db.update(
      _db.incomeEntriesTable,
    )..where((t) => t.id.equals(entry.id))).write(
      IncomeEntriesTableCompanion(
        amountCents: Value(entry.amount.cents),
        receivedOn: Value(entry.receivedOn.toIsoString()),
        note: Value(entry.note),
        updatedAt: Value(now),
      ),
    );
  }

  @override
  Future<void> softDelete(String id) async {
    final now = _clock.now().millisecondsSinceEpoch;

    await (_db.update(
      _db.incomeEntriesTable,
    )..where((t) => t.id.equals(id))).write(
      IncomeEntriesTableCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }

  @override
  Future<void> restore(String id) async {
    final now = _clock.now().millisecondsSinceEpoch;

    await (_db.update(
      _db.incomeEntriesTable,
    )..where((t) => t.id.equals(id))).write(
      IncomeEntriesTableCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(now),
      ),
    );
  }
}
