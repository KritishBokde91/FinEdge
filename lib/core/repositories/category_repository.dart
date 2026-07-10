import 'package:drift/drift.dart';
import '../database/drift_database.dart';
import '../database/daos/app_daos.dart';

/// Seed descriptor for category profiles.
class DefaultCategoryData {
  final String name;
  final String colorHex;
  final bool isIncome;

  const DefaultCategoryData({
    required this.name,
    required this.colorHex,
    required this.isIncome,
  });

  static const List<DefaultCategoryData> all = [
    DefaultCategoryData(name: 'Salary', colorHex: '#4CAF50', isIncome: true),
    DefaultCategoryData(name: 'Food', colorHex: '#FF9800', isIncome: false),
    DefaultCategoryData(name: 'Shopping', colorHex: '#E91E63', isIncome: false),
    DefaultCategoryData(name: 'Transport', colorHex: '#03A9F4', isIncome: false),
    DefaultCategoryData(name: 'Bills', colorHex: '#9C27B0', isIncome: false),
    DefaultCategoryData(name: 'Entertainment', colorHex: '#FF5722', isIncome: false),
    DefaultCategoryData(name: 'Cash', colorHex: '#795548', isIncome: false),
    DefaultCategoryData(name: 'Investment', colorHex: '#3F51B5', isIncome: false),
    DefaultCategoryData(name: 'Other', colorHex: '#9E9E9E', isIncome: false),
  ];
}

/// Repository managing system categories.
///
/// Ported from CategoryRepository.kt.
class CategoryRepository {
  final CategoryDao _dao;
  final AppDatabase _db;

  const CategoryRepository(this._dao, this._db);

  Future<List<CategoriesTableData>> getCategories() => _dao.getAllCategories();

  /// Creates a new custom category.
  Future<int> createCategory({
    required String name,
    required String color,
    bool isIncome = false,
  }) {
    final entry = CategoriesTableCompanion(
      name: Value(name),
      color: Value(color),
      isIncome: Value(isIncome),
      isSystem: const Value(false),
      displayOrder: const Value(999),
    );
    return _dao.insertCategory(entry);
  }

  /// Deletes category if it is not marked as system protected.
  Future<bool> deleteCategory(int id) async {
    final query = _db.select(_db.categoriesTable)..where((t) => t.id.equals(id));
    final existing = await query.getSingleOrNull();

    if (existing != null && !existing.isSystem) {
      await (_db.delete(_db.categoriesTable)..where((t) => t.id.equals(id))).go();
      return true;
    }
    return false;
  }

  /// Seeds all default categories if table is currently empty.
  Future<void> initializeDefaultCategories() async {
    final countQuery = _db.select(_db.categoriesTable);
    final existing = await countQuery.get();

    if (existing.isEmpty) {
      await _db.transaction(() async {
        for (int i = 0; i < DefaultCategoryData.all.length; i++) {
          final seed = DefaultCategoryData.all[i];
          await _dao.insertCategory(
            CategoriesTableCompanion(
              name: Value(seed.name),
              color: Value(seed.colorHex),
              isIncome: Value(seed.isIncome),
              isSystem: const Value(true),
              displayOrder: Value(i + 1),
            ),
          );
        }
      });
    }
  }
}
