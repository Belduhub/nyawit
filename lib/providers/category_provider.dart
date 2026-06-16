import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/category_model.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _incomeCategories = [];
  List<Category> _expenseCategories = [];
  bool _isLoading = false;

  List<Category> get incomeCategories => _incomeCategories;
  List<Category> get expenseCategories => _expenseCategories;
  bool get isLoading => _isLoading;

  final DatabaseService _dbHelper = DatabaseService.instance;

  // Load categories for a user
  Future<void> loadCategories(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _incomeCategories = await _dbHelper.getCategoriesByUser(userId, 'income');
      _expenseCategories = await _dbHelper.getCategoriesByUser(userId, 'expense');
    } catch (e) {
      print('Error loading categories: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add new custom category (for "Lainnya" feature)
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

      await _dbHelper.createCategory(category);
      await loadCategories(userId);
      return true;
    } catch (e) {
      print('Error adding custom category: $e');
      return false;
    }
  }

  // Get category by ID
  Category? getCategoryById(int id) {
    try {
      return [..._incomeCategories, ..._expenseCategories]
          .firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }
}
