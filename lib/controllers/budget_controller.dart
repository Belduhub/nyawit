import '../services/database_service.dart';

/// BudgetController - CONTROLLER layer dalam MVC
/// Mengelola business logic untuk budget/target bulanan
class BudgetController {
  final DatabaseService _dbService = DatabaseService.instance;
  
  double? _monthlyTarget;
  double _monthlyExpense = 0.0;
  bool _isLoading = false;

  double? get monthlyTarget => _monthlyTarget;
  double get monthlyExpense => _monthlyExpense;
  bool get isLoading => _isLoading;
  bool get hasTarget => _monthlyTarget != null && _monthlyTarget! > 0;

  /// Load monthly budget
  Future<void> loadMonthlyBudget(int userId, int month, int year) async {
    _isLoading = true;
    
    try {
      _monthlyTarget = await _dbService.getMonthlyBudget(userId, month, year);
      _monthlyExpense = await _dbService.getMonthlyExpense(userId, month, year);
    } catch (e) {
      print('Error loading monthly budget: $e');
    }
    
    _isLoading = false;
  }

  /// Set monthly target
  Future<bool> setMonthlyTarget(int userId, double target, int month, int year) async {
    try {
      await _dbService.setMonthlyBudget(userId, target, month, year);
      await loadMonthlyBudget(userId, month, year);
      return true;
    } catch (e) {
      print('Error setting monthly target: $e');
      return false;
    }
  }

  /// Get percentage of budget used
  double getBudgetPercentage() {
    if (_monthlyTarget == null || _monthlyTarget! <= 0) return 0.0;
    return (_monthlyExpense / _monthlyTarget!) * 100;
  }

  /// Get remaining budget
  double getRemainingBudget() {
    if (_monthlyTarget == null) return 0.0;
    return _monthlyTarget! - _monthlyExpense;
  }

  /// Check if over budget
  bool isOverBudget() {
    if (_monthlyTarget == null) return false;
    return _monthlyExpense > _monthlyTarget!;
  }
}
