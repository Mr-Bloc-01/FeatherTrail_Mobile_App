import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headings
  static const TextStyle heading1 = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: AppColors.darkGreen,
    letterSpacing: 2.0,
    fontFamily: 'Courier',
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    fontFamily: 'Courier',
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
    fontFamily: 'Courier',
  );
  
  static const TextStyle heading4 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.darkGreen,
    letterSpacing: -0.5,
    fontFamily: 'Courier',
  );
  
  static const TextStyle heading5 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.darkGreen,
    fontFamily: 'Courier',
  );
  
  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: 'Courier',
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
    height: 1.5,
    fontFamily: 'Courier',
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
    height: 1.4,
    fontFamily: 'Courier',
  );
  
  // Button Text
  static const TextStyle buttonPrimary = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
    fontFamily: 'Courier',
  );
  
  static const TextStyle buttonSecondary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: 'Courier',
  );
  
  // Caption Text
  static const TextStyle caption = TextStyle(
    fontSize: 16,
    color: AppColors.textLightSecondary,
    fontFamily: 'Courier',
  );
  
  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    color: AppColors.darkGreen,
    letterSpacing: 1.0,
    fontFamily: 'Courier',
  );
  
  // App Bar Title
  static const TextStyle appBarTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    fontFamily: 'Courier',
  );
} 