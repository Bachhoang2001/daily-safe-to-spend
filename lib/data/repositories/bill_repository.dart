import 'package:budget_engine/budget_engine.dart';
import 'package:drift/drift.dart';
import 'package:safe_to_spend/core/ids/device_id_provider.dart';
import 'package:safe_to_spend/core/ids/uuid_generator.dart';
import 'package:safe_to_spend/core/time/clock.dart';
import 'package:safe_to_spend/data/db/app_database.dart';
import 'package:safe_to_spend/data/mappers/bill_mapper.dart';
import 'package:safe_to_spend/domain/repositories/i_bill_repository.dart';

/// SQLite implementation of [IBillRepository] using Drift.
class BillRepository implements IBillRepository {
  /// Creates a [BillRepository].
  BillRepository({
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
  Stream<List<Bill>> watchActive() {
    return (_db.select(_db.billsTable)
          ..where((t) => t.deletedAt.isNull() & t.isActive.equals(true))
          ..orderBy([
            (t) => OrderingTerm.asc(t.firstDueDate),
            (t) => OrderingTerm.asc(t.name),
          ]))
        .watch()
        .map((rows) => rows.map((r) => r.toDomain()).toList());
  }

  @override
  Future<List<Bill>> getActive() async {
    final rows =
        await (_db.select(_db.billsTable)
              ..where((t) => t.deletedAt.isNull() & t.isActive.equals(true))
              ..orderBy([
                (t) => OrderingTerm.asc(t.firstDueDate),
                (t) => OrderingTerm.asc(t.name),
              ]))
            .get();

    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<Bill?> getById(String id) async {
    final row = await (_db.select(
      _db.billsTable,
    )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Future<void> addBill(Bill bill) async {
    final now = _clock.now().millisecondsSinceEpoch;
    final deviceId = await _deviceIdProvider.getDeviceId();
    final id = bill.id.isNotEmpty ? bill.id : _uuid.generate();

    await _db
        .into(_db.billsTable)
        .insert(
          BillsTableCompanion(
            id: Value(id),
            createdAt: Value(now),
            updatedAt: Value(now),
            deviceId: Value(deviceId),
            profileId: const Value('default-profile'),
            name: Value(bill.name),
            amountCents: Value(bill.amount.cents),
            recurrence: Value(bill.recurrence.name),
            firstDueDate: Value(bill.firstDueDate.toIsoString()),
            remindDaysBefore: Value(bill.remindDaysBefore),
            isActive: Value(bill.isActive),
          ),
        );
  }

  @override
  Future<void> updateBill(Bill bill) async {
    final now = _clock.now().millisecondsSinceEpoch;

    await (_db.update(
      _db.billsTable,
    )..where((t) => t.id.equals(bill.id))).write(
      BillsTableCompanion(
        name: Value(bill.name),
        amountCents: Value(bill.amount.cents),
        recurrence: Value(bill.recurrence.name),
        firstDueDate: Value(bill.firstDueDate.toIsoString()),
        remindDaysBefore: Value(bill.remindDaysBefore),
        isActive: Value(bill.isActive),
        updatedAt: Value(now),
      ),
    );
  }

  @override
  Future<void> softDelete(String id) async {
    final now = _clock.now().millisecondsSinceEpoch;

    await (_db.update(_db.billsTable)..where((t) => t.id.equals(id))).write(
      BillsTableCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }

  @override
  Future<void> restore(String id) async {
    final now = _clock.now().millisecondsSinceEpoch;

    await (_db.update(_db.billsTable)..where((t) => t.id.equals(id))).write(
      BillsTableCompanion(deletedAt: const Value(null), updatedAt: Value(now)),
    );
  }
}
