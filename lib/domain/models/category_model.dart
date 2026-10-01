import 'package:flutter/foundation.dart';

/// Domain model representing an expense category.
@immutable
class CategoryModel {
  /// Creates a [CategoryModel].
  const CategoryModel({
    required this.id,
    required this.nameKey,
    required this.icon,
    required this.color,
    this.customName,
    this.sortOrder = 0,
    this.isDefault = false,
  });

  /// Unique UUID v4 identifying this category.
  final String id;

  /// Localization key for predefined default categories (e.g. 'category_food_drink').
  final String nameKey;

  /// Optional user-defined custom name if created manually.
  final String? customName;

  /// Material icon name / identifier string.
  final String icon;

  /// Color in hex string representation (e.g. '#FF8A65').
  final String color;

  /// Display sort order index.
  final int sortOrder;

  /// Whether this category is part of the system default seeded categories.
  final bool isDefault;

  /// Creates a copy of this category with updated properties.
  CategoryModel copyWith({
    String? id,
    String? nameKey,
    String? customName,
    String? icon,
    String? color,
    int? sortOrder,
    bool? isDefault,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      nameKey: nameKey ?? this.nameKey,
      customName: customName ?? this.customName,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryModel &&
        other.id == id &&
        other.nameKey == nameKey &&
        other.customName == customName &&
        other.icon == icon &&
        other.color == color &&
        other.sortOrder == sortOrder &&
        other.isDefault == isDefault;
  }

  @override
  int get hashCode =>
      Object.hash(id, nameKey, customName, icon, color, sortOrder, isDefault);

  @override
  String toString() =>
      'CategoryModel(id: $id, nameKey: $nameKey, customName: $customName, icon: $icon, color: $color, sortOrder: $sortOrder, isDefault: $isDefault)';
}
