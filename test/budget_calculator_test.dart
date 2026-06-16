import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:nyawit/utils/budget_calculator.dart';
import 'package:nyawit/utils/constants.dart';

/// Unit Test untuk BudgetCalculator
/// Ini adalah contoh White-box Testing untuk menguji logika penentu warna budget
void main() {
  group('BudgetCalculator - White-box Testing', () {
    
    test('calculatePercentage - should calculate correct percentage', () {
      // Arrange
      double expense = 50000;
      double target = 100000;
      
      // Act
      double result = BudgetCalculator.calculatePercentage(expense, target);
      
      // Assert
      expect(result, 50.0);
    });

    test('calculatePercentage - should return 0 when target is 0', () {
      // Arrange
      double expense = 50000;
      double target = 0;
      
      // Act
      double result = BudgetCalculator.calculatePercentage(expense, target);
      
      // Assert
      expect(result, 0.0);
    });

    test('calculatePercentage - should handle over 100%', () {
      // Arrange
      double expense = 150000;
      double target = 100000;
      
      // Act
      double result = BudgetCalculator.calculatePercentage(expense, target);
      
      // Assert
      expect(result, 150.0);
    });

    // WHITE-BOX TESTING - Testing Budget Status Logic
    group('getBudgetStatus - Decision Coverage', () {
      
      test('should return "safe" when expense is less than 75% of target', () {
        // Arrange
        double expense = 50000;
        double target = 100000;
        
        // Act
        String result = BudgetCalculator.getBudgetStatus(expense, target);
        
        // Assert
        expect(result, 'safe');
      });

      test('should return "safe" at exactly 74.9% threshold', () {
        // Arrange
        double expense = 74900;
        double target = 100000;
        
        // Act
        String result = BudgetCalculator.getBudgetStatus(expense, target);
        
        // Assert
        expect(result, 'safe');
      });

      test('should return "warning" when expense is between 75% and 89.9% of target', () {
        // Arrange
        double expense = 80000;
        double target = 100000;
        
        // Act
        String result = BudgetCalculator.getBudgetStatus(expense, target);
        
        // Assert
        expect(result, 'warning');
      });

      test('should return "warning" at exactly 75% threshold', () {
        // Arrange
        double expense = 75000;
        double target = 100000;
        
        // Act
        String result = BudgetCalculator.getBudgetStatus(expense, target);
        
        // Assert
        expect(result, 'warning');
      });

      test('should return "warning" at 89.9% threshold', () {
        // Arrange
        double expense = 89900;
        double target = 100000;
        
        // Act
        String result = BudgetCalculator.getBudgetStatus(expense, target);
        
        // Assert
        expect(result, 'warning');
      });

      test('should return "danger" when expense is 90% or more of target', () {
        // Arrange
        double expense = 95000;
        double target = 100000;
        
        // Act
        String result = BudgetCalculator.getBudgetStatus(expense, target);
        
        // Assert
        expect(result, 'danger');
      });

      test('should return "danger" at exactly 90% threshold', () {
        // Arrange
        double expense = 90000;
        double target = 100000;
        
        // Act
        String result = BudgetCalculator.getBudgetStatus(expense, target);
        
        // Assert
        expect(result, 'danger');
      });

      test('should return "danger" when expense exceeds target', () {
        // Arrange
        double expense = 120000;
        double target = 100000;
        
        // Act
        String result = BudgetCalculator.getBudgetStatus(expense, target);
        
        // Assert
        expect(result, 'danger');
      });

      test('should return "safe" when target is 0 or negative', () {
        // Arrange
        double expense = 50000;
        double target = 0;
        
        // Act
        String result = BudgetCalculator.getBudgetStatus(expense, target);
        
        // Assert
        expect(result, 'safe');
      });
    });

    // WHITE-BOX TESTING - Testing Color Assignment Logic
    group('getBudgetColor - Path Coverage', () {
      
      test('should return green color when status is safe', () {
        // Arrange
        double expense = 50000;
        double target = 100000;
        
        // Act
        Color result = BudgetCalculator.getBudgetColor(expense, target);
        
        // Assert
        expect(result, AppColors.budgetSafe);
      });

      test('should return yellow color when status is warning', () {
        // Arrange
        double expense = 80000;
        double target = 100000;
        
        // Act
        Color result = BudgetCalculator.getBudgetColor(expense, target);
        
        // Assert
        expect(result, AppColors.budgetWarning);
      });

      test('should return red color when status is danger', () {
        // Arrange
        double expense = 95000;
        double target = 100000;
        
        // Act
        Color result = BudgetCalculator.getBudgetColor(expense, target);
        
        // Assert
        expect(result, AppColors.budgetDanger);
      });
    });

    // BOUNDARY VALUE TESTING
    group('getBudgetColor - Boundary Value Analysis', () {
      
      test('should return safe color just before warning threshold', () {
        // Arrange
        double expense = 74999.99;
        double target = 100000;
        
        // Act
        Color result = BudgetCalculator.getBudgetColor(expense, target);
        
        // Assert
        expect(result, AppColors.budgetSafe);
      });

      test('should return warning color at warning threshold', () {
        // Arrange
        double expense = 75000;
        double target = 100000;
        
        // Act
        Color result = BudgetCalculator.getBudgetColor(expense, target);
        
        // Assert
        expect(result, AppColors.budgetWarning);
      });

      test('should return warning color just before danger threshold', () {
        // Arrange
        double expense = 89999.99;
        double target = 100000;
        
        // Act
        Color result = BudgetCalculator.getBudgetColor(expense, target);
        
        // Assert
        expect(result, AppColors.budgetWarning);
      });

      test('should return danger color at danger threshold', () {
        // Arrange
        double expense = 90000;
        double target = 100000;
        
        // Act
        Color result = BudgetCalculator.getBudgetColor(expense, target);
        
        // Assert
        expect(result, AppColors.budgetDanger);
      });

      test('should return danger color just after danger threshold', () {
        // Arrange
        double expense = 90000.01;
        double target = 100000;
        
        // Act
        Color result = BudgetCalculator.getBudgetColor(expense, target);
        
        // Assert
        expect(result, AppColors.budgetDanger);
      });
    });

    // Additional utility tests
    group('getBudgetMessage', () {
      
      test('should return appropriate message for safe status', () {
        // Arrange
        double expense = 50000;
        double target = 100000;
        
        // Act
        String result = BudgetCalculator.getBudgetMessage(expense, target);
        
        // Assert
        expect(result, contains('aman'));
        expect(result, contains('50.0'));
      });

      test('should return appropriate message for warning status', () {
        // Arrange
        double expense = 80000;
        double target = 100000;
        
        // Act
        String result = BudgetCalculator.getBudgetMessage(expense, target);
        
        // Assert
        expect(result, contains('Hati-hati'));
        expect(result, contains('80.0'));
      });

      test('should return appropriate message for danger status', () {
        // Arrange
        double expense = 95000;
        double target = 100000;
        
        // Act
        String result = BudgetCalculator.getBudgetMessage(expense, target);
        
        // Assert
        expect(result, contains('Bahaya'));
        expect(result, contains('95.0'));
      });

      test('should return appropriate message when over budget', () {
        // Arrange
        double expense = 120000;
        double target = 100000;
        
        // Act
        String result = BudgetCalculator.getBudgetMessage(expense, target);
        
        // Assert
        expect(result, contains('terlampaui'));
        expect(result, contains('120.0'));
      });
    });

    group('getRemainingBudget', () {
      
      test('should calculate remaining budget correctly', () {
        // Arrange
        double expense = 60000;
        double target = 100000;
        
        // Act
        double result = BudgetCalculator.getRemainingBudget(expense, target);
        
        // Assert
        expect(result, 40000.0);
      });

      test('should return negative when over budget', () {
        // Arrange
        double expense = 120000;
        double target = 100000;
        
        // Act
        double result = BudgetCalculator.getRemainingBudget(expense, target);
        
        // Assert
        expect(result, -20000.0);
      });
    });

    group('isOverBudget', () {
      
      test('should return false when under budget', () {
        // Arrange
        double expense = 80000;
        double target = 100000;
        
        // Act
        bool result = BudgetCalculator.isOverBudget(expense, target);
        
        // Assert
        expect(result, false);
      });

      test('should return false when exactly at budget', () {
        // Arrange
        double expense = 100000;
        double target = 100000;
        
        // Act
        bool result = BudgetCalculator.isOverBudget(expense, target);
        
        // Assert
        expect(result, false);
      });

      test('should return true when over budget', () {
        // Arrange
        double expense = 120000;
        double target = 100000;
        
        // Act
        bool result = BudgetCalculator.isOverBudget(expense, target);
        
        // Assert
        expect(result, true);
      });
    });
  });
}
