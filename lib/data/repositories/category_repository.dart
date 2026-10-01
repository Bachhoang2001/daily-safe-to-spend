import 'package:drift/drift.dart';
import 'package:safe_to_spend/core/ids/device_id_provider.dart';
import 'package:safe_to_spend/core/ids/uuid_generator.dart';
import 'package:safe_to_spend/core/time/clock.dart';
import 'package:safe_to_spend/data/db/app_database.dart';
import 'package:safe_to_spend/data/mappers/category_mapper.dart';
import 'package:safe_to_spend/domain/models/category_model.dart';
import 'package:safe_to_spend/domain/repositories/i_category_repository.dart';

/// SQLite implementation of [ICategoryRepository] using Drift.
class CategoryRepository implements ICategoryRepository {
  /// Creates a [CategoryRepository].
  CategoryRepository({
    required this._db,
    required this._clock,
    required this._uuid,
    required this._deviceIdProvider,
  });

  final AppDatabase _db;
  final Clock _clock;
  final UuidGenerator _uuid;
  final DeviceIdProvider _deviceIdProvider;

  static const List<Map<String, dynamic>> _defaultCategories = [
    {
      'key': 'category_food_drink',
      'icon': 'restaurant',
      'color': '#FF8A65',
      'sort': 1,
    },
    {
      'key': 'category_groceries',
      'icon': 'shopping_cart',
      'color': '#4DB6AC',
      'sort': 2,
    },
    {
      'key': 'category_transport',
      'icon': 'directions_car',
      'color': '#4FC3F7',
      'sort': 3,
    },
    {
      'key': 'category_shopping',
      'icon': 'shopping_bag',
      'color': '#BA68C8',
      'sort': 4,
    },
    {
      'key': 'category_fun',
      'icon': 'celebration',
      'color': '#FFD54F',
      'sort': 5,
    },
    {
      'key': 'category_bills_utilities',
      'icon': 'receipt_long',
      'color': '#90A4AE',
      'sort': 6,
    },
    {
      'key': 'category_health',
      'icon': 'favorite',
      'color': '#E57373',
      'sort': 7,
    },
    {
      'key': 'category_other',
      'icon': 'more_horiz',
      'color': '#A1887F',
      'sort': 8,
    },
  ];

  @override
  Stream<List<CategoryModel>> watchCategories() {
    return (_db.select(_db.categoriesTable)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch()
        .map((rows) => rows.map((r) => r.toDomain()).toList());
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final rows =
        await (_db.select(_db.categoriesTable)
              ..where((t) => t.deletedAt.isNull())
              ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
            .get();

    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<CategoryModel?> getById(String id) async {
    final row = await (_db.select(
      _db.categoriesTable,
    )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Future<void> addCategory(CategoryModel category) async {
    final now = _clock.now().millisecondsSinceEpoch;
    final deviceId = await _deviceIdProvider.getDeviceId();
    final id = category.id.isNotEmpty ? category.id : _uuid.generate();

    await _db
        .into(_db.categoriesTable)
        .insert(
          CategoriesTableCompanion(
            id: Value(id),
            createdAt: Value(now),
            updatedAt: Value(now),
            deviceId: Value(deviceId),
            nameKey: Value(category.nameKey),
            customName: Value(category.customName),
            icon: Value(category.icon),
            color: Value(category.color),
            sortOrder: Value(category.sortOrder),
            isDefault: Value(category.isDefault),
          ),
        );
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    final now = _clock.now().millisecondsSinceEpoch;

    await (_db.update(
      _db.categoriesTable,
    )..where((t) => t.id.equals(category.id))).write(
      CategoriesTableCompanion(
        nameKey: Value(category.nameKey),
        customName: Value(category.customName),
        icon: Value(category.icon),
        color: Value(category.color),
        sortOrder: Value(category.sortOrder),
        isDefault: Value(category.isDefault),
        updatedAt: Value(now),
      ),
    );
  }

  @override
  Future<void> softDelete(String id) async {
    final now = _clock.now().millisecondsSinceEpoch;

    await (_db.update(
      _db.categoriesTable,
    )..where((t) => t.id.equals(id))).write(
      CategoriesTableCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }

  @override
  Future<void> seedDefaultCategories() async {
    final existingDefaults = await (_db.select(
      _db.categoriesTable,
    )..where((t) => t.isDefault.equals(true))).get();

    final existingKeys = existingDefaults.map((r) => r.nameKey).toSet();

    final now = _clock.now().millisecondsSinceEpoch;
    final deviceId = await _deviceIdProvider.getDeviceId();

    for (final def in _defaultCategories) {
      final key = def['key'] as String;
      if (!existingKeys.contains(key)) {
        await _db
            .into(_db.categoriesTable)
            .insert(
              CategoriesTableCompanion(
                id: Value(_uuid.generate()),
                createdAt: Value(now),
                updatedAt: Value(now),
                deviceId: Value(deviceId),
                nameKey: Value(key),
                customName: const Value(null),
                icon: Value(def['icon'] as String),
                color: Value(def['color'] as String),
                sortOrder: Value(def['sort'] as int),
                isDefault: const Value(true),
              ),
            );
      }
    }
  }
}
