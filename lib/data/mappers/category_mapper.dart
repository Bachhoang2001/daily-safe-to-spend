import 'package:safe_to_spend/data/db/app_database.dart';
import 'package:safe_to_spend/domain/models/category_model.dart';

/// Extension methods for converting between [CategoryData] and [CategoryModel].
extension CategoryMapper on CategoryData {
  /// Converts Drift database row [CategoryData] to domain [CategoryModel].
  CategoryModel toDomain() {
    return CategoryModel(
      id: id,
      nameKey: nameKey,
      customName: customName,
      icon: icon,
      color: color,
      sortOrder: sortOrder,
      isDefault: isDefault,
    );
  }
}
