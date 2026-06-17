import 'package:flutter/material.dart';
import 'constants.dart';

/// Budget Calculator - Core logic untuk White-box Testing
/// Fungsi ini menentukan status dan warna indikator budget
class BudgetCalculator {
  /// Menghitung persentase pengeluaran dari target
  static double calculatePercentage(double expense, double target) {
    if (target <= 0) return 0.0;
    return (expense / target) * 100;
  }

  /// Menentukan status budget berdasarkan persentase
  /// Returns: 'safe', 'warning', atau 'danger'
  /// Validasi boundary untuk mencegah logical flaw
  static String getBudgetStatus(double expense, double target) {
    // Sanity check: validasi input negatif dan target invalid
    if (expense < 0 || target <= 0) return 'safe';
    
    double percentage = expense / target;
    
    if (percentage < AppConstants.budgetWarningThreshold) {
      return 'safe';
    } else if (percentage < AppConstants.budgetDangerThreshold) {
      return 'warning';
    } else {
      return 'danger';
    }
  }

  /// Menentukan warna indikator berdasarkan status budget
  /// Ini adalah FUNGSI UTAMA untuk White-box Testing
  static Color getBudgetColor(double expense, double target) {
    String status = getBudgetStatus(expense, target);
    
    switch (status) {
      case 'safe':
        return AppColors.budgetSafe;
      case 'warning':
        return AppColors.budgetWarning;
      case 'danger':
        return AppColors.budgetDanger;
      default:
        return AppColors.budgetSafe;
    }
  }

  /// Mendapatkan pesan status budget
  static String getBudgetMessage(double expense, double target) {
    String status = getBudgetStatus(expense, target);
    double percentage = calculatePercentage(expense, target);
    
    switch (status) {
      case 'safe':
        return 'Pengeluaran masih aman (${percentage.toStringAsFixed(1)}%)';
      case 'warning':
        return 'Hati-hati! Pengeluaran mendekati target (${percentage.toStringAsFixed(1)}%)';
      case 'danger':
        if (percentage >= 100) {
          return 'Bahaya! Target terlampaui (${percentage.toStringAsFixed(1)}%)';
        }
        return 'Bahaya! Pengeluaran sangat tinggi (${percentage.toStringAsFixed(1)}%)';
      default:
        return 'Status tidak diketahui';
    }
  }

  /// Menghitung sisa budget
  static double getRemainingBudget(double expense, double target) {
    return target - expense;
  }

  /// Cek apakah budget sudah melebihi target
  static bool isOverBudget(double expense, double target) {
    return expense > target;
  }
}
