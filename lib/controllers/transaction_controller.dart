import '../services/database_service.dart';
import '../models/transaction_model.dart' as models;

/// TransactionController - CONTROLLER layer dalam MVC
/// Mengelola business logic untuk transaksi
class TransactionController {
  final DatabaseService _dbService = DatabaseService.instance;
  
  List<models.Transaction> _transactions = [];
  double _totalIncome = 0.0;
  double _totalExpense = 0.0;
  Map<String, double> _expenseByCategory = {};
  bool _isLoading = false;

  List<models.Transaction> get transactions => _transactions;
  double get totalIncome => _totalIncome;
  double get totalExpense => _totalExpense;
  double get balance => _totalIncome - _totalExpense;
  Map<String, double> get expenseByCategory => _expenseByCategory;
  bool get isLoading => _isLoading;

  /// Load all transactions untuk user tertentu
  Future<void> loadTransactions(int userId) async {
    _isLoading = true;
    
    try {
      _transactions = await _dbService.getTransactionsByUser(userId);
      _totalIncome = await _dbService.getTotalIncome(userId);
      _totalExpense = await _dbService.getTotalExpense(userId);
      _expenseByCategory = await _dbService.getExpenseByCategory(userId);
    } catch (e) {
      print('Error loading transactions: $e');
    }
    
    _isLoading = false;
  }

  /// Add new transaction
  Future<bool> addTransaction({
    required int userId,
    required int categoryId,
    required String categoryName,
    required double amount,
    required String type,
    required DateTime date,
    String? note,
  }) async {
    try {
      final transaction = models.Transaction(
        userId: userId,
        categoryId: categoryId,
        categoryName: categoryName,
        amount: amount,
        type: type,
        date: date,
        note: note,
      );

      await _dbService.createTransaction(transaction);
      await loadTransactions(userId);
      return true;
    } catch (e) {
      print('Error adding transaction: $e');
      return false;
    }
  }

  /// Update transaction
  Future<bool> updateTransaction(models.Transaction transaction) async {
    try {
      await _dbService.updateTransaction(transaction);
      await loadTransactions(transaction.userId);
      return true;
    } catch (e) {
      print('Error updating transaction: $e');
      return false;
    }
  }

  /// Delete transaction
  Future<bool> deleteTransaction(int transactionId, int userId) async {
    try {
      await _dbService.deleteTransaction(transactionId);
      await loadTransactions(userId);
      return true;
    } catch (e) {
      print('Error deleting transaction: $e');
      return false;
    }
  }

  /// Get recent transactions
  Future<List<models.Transaction>> getRecentTransactions(int userId, int limit) async {
    try {
      return await _dbService.getRecentTransactions(userId, limit);
    } catch (e) {
      print('Error getting recent transactions: $e');
      return [];
    }
  }

  /// Clear all transactions (untuk testing)
  Future<void> clearAllTransactions(int userId) async {
    try {
      await _dbService.clearAllTransactions(userId);
      await loadTransactions(userId);
    } catch (e) {
      print('Error clearing transactions: $e');
    }
  }

  /// Bulk insert transactions (untuk load testing)
  Future<int> bulkInsertTransactions(List<models.Transaction> transactions) async {
    try {
      return await _dbService.bulkInsertTransactions(transactions);
    } catch (e) {
      print('Error bulk inserting transactions: $e');
      return 0;
    }
  }
}
