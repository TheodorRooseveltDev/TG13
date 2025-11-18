import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Big Boss Fishing Typography System
/// Bold, masculine fonts with strong presence
class AppTextStyles {
  // Font Families
  // Note: Using system fonts for now. For production, add custom fonts in pubspec.yaml
  static const String primaryFont = 'System'; // Replace with 'Bebas Neue' for headlines
  static const String secondaryFont = 'Roboto'; // For body text
  
  // Display Styles - Extra Large Headlines
  static const TextStyle display1 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 56,
    fontWeight: FontWeight.w900,
    color: AppColors.white,
    letterSpacing: 2.5,
    height: 1.1,
  );
  
  static const TextStyle display2 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 48,
    fontWeight: FontWeight.w900,
    color: AppColors.deepNavy,
    letterSpacing: 2,
    height: 1.2,
  );
  
  // Headlines - Major Section Titles
  static const TextStyle headline1 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 40,
    fontWeight: FontWeight.w900,
    color: AppColors.white,
    letterSpacing: 2,
    height: 1.2,
  );
  
  static const TextStyle headline2 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 36,
    fontWeight: FontWeight.w900,
    color: AppColors.deepNavy,
    letterSpacing: 1.5,
    height: 1.2,
  );
  
  static const TextStyle headline3 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.deepNavy,
    letterSpacing: 1.2,
    height: 1.3,
  );
  
  static const TextStyle headline4 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.deepNavy,
    letterSpacing: 1,
    height: 1.3,
  );
  
  static const TextStyle headline5 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.deepNavy,
    letterSpacing: 0.8,
    height: 1.4,
  );
  
  static const TextStyle headline6 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.deepNavy,
    letterSpacing: 0.5,
    height: 1.4,
  );
  
  // Subtitle Styles
  static const TextStyle subtitle1 = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.3,
    height: 1.5,
  );
  
  static const TextStyle subtitle2 = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.2,
    height: 1.5,
  );
  
  // Body Text Styles
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.2,
    height: 1.6,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
    height: 1.6,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.1,
    height: 1.5,
  );
  
  // Bold Body Variants
  static const TextStyle bodyBold = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.deepNavy,
    letterSpacing: 0.2,
    height: 1.6,
  );
  
  static const TextStyle bodyBoldMedium = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.deepNavy,
    letterSpacing: 0.1,
    height: 1.6,
  );
  
  // Button Styles
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 20,
    fontWeight: FontWeight.w900,
    color: AppColors.white,
    letterSpacing: 1.5,
    height: 1.2,
  );
  
  static const TextStyle buttonMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.white,
    letterSpacing: 1.2,
    height: 1.2,
  );
  
  static const TextStyle buttonSmall = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
    letterSpacing: 0.8,
    height: 1.2,
  );
  
  // Default button style (alias for buttonMedium)
  static const TextStyle button = buttonMedium;
  
  // Convenience aliases
  static const TextStyle heading2 = headline2;
  static const TextStyle heading3 = headline3;
  static const TextStyle heading5 = headline5;
  static const TextStyle body1 = bodyLarge;
  static const TextStyle body2 = bodyMedium;
  
  // Caption & Label Styles
  static const TextStyle caption = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.3,
    height: 1.4,
  );
  
  static const TextStyle captionBold = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.3,
    height: 1.4,
  );
  
  static const TextStyle overline = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: AppColors.textSecondary,
    letterSpacing: 1.5,
    height: 1.4,
  );
  
  // Special Styles
  static const TextStyle label = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
    height: 1.3,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
    height: 1.3,
  );
  
  // Input Field Styles
  static const TextStyle inputLabel = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.deepNavy,
    letterSpacing: 0.3,
    height: 1.4,
  );
  
  static const TextStyle inputText = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.2,
    height: 1.5,
  );
  
  static const TextStyle inputHint = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.2,
    height: 1.5,
  );
  
  // Stats & Numbers - Extra Bold
  static const TextStyle statsLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 48,
    fontWeight: FontWeight.w900,
    color: AppColors.bossAqua,
    letterSpacing: 1,
    height: 1.1,
  );
  
  static const TextStyle statsMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 32,
    fontWeight: FontWeight.w900,
    color: AppColors.deepNavy,
    letterSpacing: 0.8,
    height: 1.2,
  );
  
  static const TextStyle statsSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.deepNavy,
    letterSpacing: 0.5,
    height: 1.2,
  );
  
  // Card Title Styles
  static const TextStyle cardTitle = TextStyle(
    fontFamily: primaryFont,
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.deepNavy,
    letterSpacing: 0.8,
    height: 1.3,
  );
  
  static const TextStyle cardSubtitle = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.2,
    height: 1.4,
  );
  
  // Error & Success Messages
  static const TextStyle error = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.error,
    letterSpacing: 0.2,
    height: 1.4,
  );
  
  static const TextStyle success = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.success,
    letterSpacing: 0.2,
    height: 1.4,
  );
}
