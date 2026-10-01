import 'package:budget_engine/budget_engine.dart';
import 'package:drift/drift.dart';
import 'package:safe_to_spend/core/ids/device_id_provider.dart';
import 'package:safe_to_spend/core/ids/uuid_generator.dart';
import 'package:safe_to_spend/core/time/clock.dart';
import 'package:safe_to_spend/data/db/app_database.dart';
import 'package:safe_to_spend/data/mappers/expense_mapper.dart';
import 'package:safe_to_spend/domain/repositories/i_expense_repository.dart';

/// SQLite implementation of [IExpenseRepository] using Drift.
class ExpenseRepository implements IExpenseRepository {
  /// Creates an [ExpenseRepository].
  ExpenseRepository({
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
  Stream<List<Expense>> watchRange({
    required LocalDate from,
    required LocalDate to,
  }) {
    final fromIso = from.toIsoString();
    final toIso = to.toIsoString();

    return (_db.select(_db.expensesTable)
          ..where(
            (t) =>
                t.deletedAt.isNull() &
                t.spentOn.isBiggerOrEqualValue(fromIso) &
                t.spentOn.isSmallerOrEqualValue(toIso),
          )
          ..orderBy([
            (t) => OrderingTerm.desc(t.spentOn),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .watch()
        .map((rows) => rows.map((r) => r.toDomain()).toList())
        .distinct(_listEquals);
  }

  static bool _listEquals(List<Expense> a, List<Expense> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  Future<List<Expense>> getRange({
    required LocalDate from,
    required LocalDate to,
  }) async {
    final fromIso = from.toIsoString();
    final toIso = to.toIsoString();

    final rows =
        await (_db.select(_db.expensesTable)
              ..where(
                (t) =>
                    t.deletedAt.isNull() &
                    t.spentOn.isBiggerOrEqualValue(fromIso) &
                    t.spentOn.isSmallerOrEqualValue(toIso),
              )
              ..orderBy([
                (t) => OrderingTerm.desc(t.spentOn),
                (t) => OrderingTerm.desc(t.createdAt),
              ]))
            .get();

    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<Expense?> getById(String id) async {
    final row = await (_db.select(
      _db.expensesTable,
    )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Future<void> addExpense(Expense expense) async {
    await Future<void>.delayed(Duration.zero);
    final now = _clock.now().millisecondsSinceEpoch;
    final deviceId = await _deviceIdProvider.getDeviceId();
    final id = expense.id.isNotEmpty ? expense.id : _uuid.generate();

    await _db
        .into(_db.expensesTable)
        .insert(
          ExpensesTableCompanion(
            id: Value(id),
            createdAt: Value(now),
            updatedAt: Value(now),
            deviceId: Value(deviceId),
            profileId: const Value('default-profile'),
            amountCents: Value(expense.amount.cents),
            spentOn: Value(expense.spentOn.toIsoString()),
            categoryId: Value(expense.categoryId),
            note: Value(expense.note),
            source: const Value('manual'),
            currency: Value(expense.amount.currency),
          ),
        );
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    final now = _clock.now().millisecondsSinceEpoch;

    await (_db.update(
      _db.expensesTable,
    )..where((t) => t.id.equals(expense.id))).write(
      ExpensesTableCompanion(
        amountCents: Value(expense.amount.cents),
        spentOn: Value(expense.spentOn.toIsoString()),
        categoryId: Value(expense.categoryId),
        note: Value(expense.note),
        currency: Value(expense.amount.currency),
        updatedAt: Value(now),
      ),
    );
  }

  @override
  Future<void> softDelete(String id) async {
    final now = _clock.now().millisecondsSinceEpoch;

    await (_db.update(_db.expensesTable)..where((t) => t.id.equals(id))).write(
      ExpensesTableCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }

  @override
  Future<void> restore(String id) async {
    final now = _clock.now().millisecondsSinceEpoch;

    await (_db.update(_db.expensesTable)..where((t) => t.id.equals(id))).write(
      ExpensesTableCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(now),
      ),
    );
  }
}
