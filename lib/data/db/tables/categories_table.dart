import 'package:drift/drift.dart';
import 'package:safe_to_spend/data/db/tables/common_sync_table.dart';

/// Table storing transaction categories (both system seeded and custom).
@DataClassName('CategoryData')
class CategoriesTable extends CommonSyncTable {
  @override
  String get tableName => 'categories';

  /// Localization key for system default categories (e.g. 'category_food_drink').
  TextColumn get nameKey => text()();

  /// User-defined custom display name (for user created categories).
  TextColumn get customName => text().nullable()();

  /// Icon identifier string.
  TextColumn get icon => text()();

  /// Hex color code string (e.g. '#FF8A65').
  TextColumn get color => text()();

  /// Sorting index for UI presentation.
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  /// Whether this category belongs to system seeded defaults.
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
}
