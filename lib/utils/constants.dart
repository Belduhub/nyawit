import 'package:flutter/material.dart';

class AppColors {
  // New Design Colors - Light Theme with Green Accent
  static const Color background = Color(0xFFF9FAFB); // Light gray background
  static const Color backgroundLight = Color(0xFFF9FAFB); // Same as background
  static const Color backgroundAlt = Color(0xFFF4FBF4); // Light green tint
  static const Color primaryGreen = Color(0xFF006C49); // Dark green
  static const Color accentGreen = Color(0xFF10B981); // Bright green
  static const Color cardBackground = Colors.white;
  static const Color border = Color(0xFFBBCABF); // Light border
  static const Color borderColor = Color(0xFFBBCABF); // Same as border
  
  // Text Colors
  static const Color textPrimary = Color(0xFF3C4A42); // Dark gray
  static const Color textSecondary = Color(0xFF555F70); // Medium gray
  static const Color textPlaceholder = Color(0xFF6B7280); // Placeholder gray
  static const Color textOnGreen = Colors.white;
  
  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFFFC107);
  static const Color danger = Color(0xFFE53935);
  
  // Budget indicator colors (keep existing)
  static const Color budgetSafe = Color(0xFF10B981);
  static const Color budgetWarning = Color(0xFFFFC107);
  static const Color budgetDanger = Color(0xFFE53935);
  
  // Legacy dark theme colors (for backward compatibility)
  static const Color primaryDark = Color.fromARGB(255, 18, 32, 47);
  static const Color accentBlue = Color(0xFF2196F3);
  static const Color accentRed = Color(0xFFE53935);
  static const Color accentYellow = Color(0xFFFFC107);
}

class AppTextStyles {
  static const String fontFamily = 'Manrope';
  
  // Large title (40px, weight 800)
  static const TextStyle largeTitle = TextStyle(
    fontSize: 40,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryGreen,
    height: 1.20,
    letterSpacing: -0.80,
  );
  
  // App title (28px, weight 800)
  static const TextStyle appTitle = TextStyle(
    fontSize: 28,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryGreen,
    height: 1.29,
  );
  
  // Heading 1 (24px, weight 700)
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.33,
  );
  
  // Heading 2 (20px, weight 600)
  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.40,
  );
  
  // Heading 3 (16px, weight 600)
  static const TextStyle heading3 = TextStyle(
    fontSize: 16,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.50,
  );
  
  // Body Large (16px, weight 400)
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  
  // Body Medium (14px, weight 400)
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.43,
  );
  
  // Body Small (12px, weight 600)
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.33,
    letterSpacing: 0.60,
  );
  
  // Button Text (20px, weight 600)
  static const TextStyle buttonText = TextStyle(
    fontSize: 20,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.40,
  );
  
  // Label Text (12px, weight 600, uppercase)
  static const TextStyle labelText = TextStyle(
    fontSize: 12,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.33,
    letterSpacing: 0.60,
  );
  
  // Balance Amount (40px, weight 800, white)
  static const TextStyle balanceAmount = TextStyle(
    fontSize: 40,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    height: 1.20,
    letterSpacing: -0.80,
  );
}

class AppConstants {
  static const String appName = 'Nyawit';
  static const String appVersion = '1.0.0';
  
  // Developer Info
  static const String developer1Name = 'Danang Adiwibowo';
  static const String developer1NIM = '123230143';
  static const String developer2Name = 'Gorga Doli L';
  static const String developer2NIM = '123230147';
  
  // Testing constants
  static const int loadTestCount = 1000;
  static const int stressTestCount = 20000;
  
  // Budget thresholds
  static const double budgetWarningThreshold = 0.75; // 75%
  static const double budgetDangerThreshold = 0.90; // 90%
}
