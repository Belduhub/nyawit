import 'package:flutter/material.dart';
import '../services/database_service.dart';

class BudgetProvider with ChangeNotifier {
  double? _monthlyTarget;
  double _monthlyExpense = 0.0;
  bool _isLoading = false;

  double? get monthlyTarget => _monthlyTarget;
  double get monthlyExpense => _monthlyExpense;
  bool get isLoading => _isLoading;
  bool get hasTarget => _monthlyTarget != null && _monthlyTarget! > 0;

  final DatabaseService _dbHelper = DatabaseService.instance;

  // Load monthly budget
  Future<void> loadMonthlyBudget(int userId, int month, int year) async {
    _isLoading = true;
    notifyListeners();

    try {
      _monthlyTarget = await _dbHelper.getMonthlyBudget(userId, month, year);
      _monthlyExpense = await _dbHelper.getMonthlyExpense(userId, month, year);
    } catch (e) {
      print('Error loading monthly budget: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Set monthly target
  Future<bool> setMonthlyTarget(int userId, double target, int month, int year) async {
    try {
      await _dbHelper.setMonthlyBudget(userId, target, month, year);
      await loadMonthlyBudget(userId, month, year);
      return true;
    } catch (e) {
      print('Error setting monthly target: $e');
      return false;
    }
  }

  // Get percentage of budget used
  double getBudgetPercentage() {
    if (_monthlyTarget == null || _monthlyTarget! <= 0) return 0.0;
    return (_monthlyExpense / _monthlyTarget!) * 100;
  }
}
