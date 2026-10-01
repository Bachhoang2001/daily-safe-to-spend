import 'package:safe_to_spend/domain/models/category_model.dart';

/// Contract for managing expense categories and default bootstrap seeding.
///
/// Categories allow categorizing expenses for visual classification and analytics.
/// Includes 8 system-default categories seeded on first launch, plus user-defined
/// custom categories.
///
/// All read operations only return non-deleted records (`deleted_at IS NULL`).
abstract class ICategoryRepository {
  /// Emits all active categories sorted by [CategoryModel.sortOrder] ascending.
  Stream<List<CategoryModel>> watchCategories();

  /// Retrieves all active categories sorted by [CategoryModel.sortOrder] ascending.
  Future<List<CategoryModel>> getCategories();

  /// Retrieves a category by its unique [id] if active and not soft-deleted.
  Future<CategoryModel?> getById(String id);

  /// Inserts a new custom [category].
  ///
  /// Sets `isDefault` to `false`, attaches audit timestamps and device identifier.
  Future<void> addCategory(CategoryModel category);

  /// Updates an existing [category] and advances its `updatedAt` audit timestamp.
  Future<void> updateCategory(CategoryModel category);

  /// Soft deletes a custom category identified by [id].
  Future<void> softDelete(String id);

  /// Seeds the 8 default system categories idempotently.
  ///
  /// If default categories already exist, this method completes safely without
  /// duplicating records (safe to call on every app bootstrap).
  Future<void> seedDefaultCategories();
}
