import '../services/database_service.dart';
import '../models/category_model.dart';

/// CategoryController - CONTROLLER layer dalam MVC
/// Mengelola business logic untuk kategori
class CategoryController {
  final DatabaseService _dbService = DatabaseService.instance;
  
  List<Category> _incomeCategories = [];
  List<Category> _expenseCategories = [];
  bool _isLoading = false;

  List<Category> get incomeCategories => _incomeCategories;
  List<Category> get expenseCategories => _expenseCategories;
  bool get isLoading => _isLoading;

  /// Load categories untuk user tertentu
  Future<void> loadCategories(int userId) async {
    _isLoading = true;
    
    try {
      _incomeCategories = await _dbService.getCategoriesByUser(userId, 'income');
      _expenseCategories = await _dbService.getCategoriesByUser(userId, 'expense');
    } catch (e) {
      print('Error loading categories: $e');
    }
    
    _isLoading = false;
  }

  /// Add custom category (untuk fitur "Lainnya")
  Future<bool> addCustomCategory({
    required String name,
    required String type,
    required int userId,
  }) async {
    try {
      final category = Category(
        name: name,
        type: type,
        isDefault: false,
        userId: userId,
      );

      await _dbService.createCategory(category);
      await loadCategories(userId);
      return true;
    } catch (e) {
      print('Error adding custom category: $e');
      return false;
    }
  }

  /// Get category by ID
  Category? getCategoryById(int id) {
    try {
      return [..._incomeCategories, ..._expenseCategories]
          .firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get all categories (income + expense)
  List<Category> getAllCategories() {
    return [..._incomeCategories, ..._expenseCategories];
  }
}
