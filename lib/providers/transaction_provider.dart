import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/transaction_model.dart' as models;

class TransactionProvider with ChangeNotifier {
  List<models.Transaction> _transactions = [];
  bool _isLoading = false;
  double _totalIncome = 0.0;
  double _totalExpense = 0.0;
  Map<String, double> _expenseByCategory = {};

  List<models.Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  double get totalIncome => _totalIncome;
  double get totalExpense => _totalExpense;
  double get balance => _totalIncome - _totalExpense;
  Map<String, double> get expenseByCategory => _expenseByCategory;

  final DatabaseService _dbHelper = DatabaseService.instance;

  // Load all transactions for a user
  Future<void> loadTransactions(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _transactions = await _dbHelper.getTransactionsByUser(userId);
      _totalIncome = await _dbHelper.getTotalIncome(userId);
      _totalExpense = await _dbHelper.getTotalExpense(userId);
      _expenseByCategory = await _dbHelper.getExpenseByCategory(userId);
    } catch (e) {
      print('Error loading transactions: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add new transaction
  // Add new transaction
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

      await _dbHelper.createTransaction(transaction);
      await loadTransactions(userId);
      return true;
    } catch (e) {
      print('Error adding transaction: $e');
      return false;
    }
  }

  // Update transaction
  Future<bool> updateTransaction(models.Transaction transaction) async {
    try {
      await _dbHelper.updateTransaction(transaction);
      await loadTransactions(transaction.userId);
      return true;
    } catch (e) {
      print('Error updating transaction: $e');
      return false;
    }
  }

  // Delete transaction
  Future<bool> deleteTransaction(int transactionId, int userId) async {
    try {
      await _dbHelper.deleteTransaction(transactionId);
      await loadTransactions(userId);
      return true;
    } catch (e) {
      print('Error deleting transaction: $e');
      return false;
    }
  }

  // Get recent transactions
  Future<List<models.Transaction>> getRecentTransactions(int userId, int limit) async {
    try {
      return await _dbHelper.getRecentTransactions(userId, limit);
    } catch (e) {
      print('Error getting recent transactions: $e');
      return [];
    }
  }

  // Clear all transactions (for testing)
  Future<void> clearAllTransactions(int userId) async {
    try {
      await _dbHelper.clearAllTransactions(userId);
      await loadTransactions(userId);
    } catch (e) {
      print('Error clearing transactions: $e');
    }
  }
}
