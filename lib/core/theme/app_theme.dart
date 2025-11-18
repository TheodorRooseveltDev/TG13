import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'text_styles.dart';

/// Big Boss Fishing Theme Configuration
/// Bold, masculine, rugged design theme
class AppTheme {
  // Light Theme (Primary Theme)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.deepNavy,
        secondary: AppColors.bossAqua,
        tertiary: AppColors.sunsetOrange,
        surface: AppColors.white,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSecondary: AppColors.deepNavy,
        onSurface: AppColors.textPrimary,
        onError: AppColors.white,
      ),
      
      // Scaffold Background
      scaffoldBackgroundColor: AppColors.backgroundLight,
      
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.deepNavy,
        foregroundColor: AppColors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: AppTextStyles.headline4,
        iconTheme: IconThemeData(
          color: AppColors.white,
          size: 28,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: AppColors.deepNavy,
            width: 3,
          ),
        ),
        margin: const EdgeInsets.all(8),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.bossAqua,
          foregroundColor: AppColors.deepNavy,
          disabledBackgroundColor: AppColors.metalSilver,
          disabledForegroundColor: AppColors.textSecondary,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: const BorderSide(
              color: AppColors.deepNavy,
              width: 2,
            ),
          ),
          textStyle: AppTextStyles.buttonMedium,
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.deepNavy,
          side: const BorderSide(
            color: AppColors.deepNavy,
            width: 2,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: AppTextStyles.buttonMedium,
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.deepNavy,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: AppTextStyles.buttonSmall,
        ),
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.bossAqua,
        foregroundColor: AppColors.deepNavy,
        elevation: 8,
        shape: CircleBorder(
          side: BorderSide(
            color: AppColors.deepNavy,
            width: 3,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.deepNavy,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.borderSecondary,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.bossAqua,
            width: 3,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 3,
          ),
        ),
        labelStyle: AppTextStyles.inputLabel,
        hintStyle: AppTextStyles.inputHint,
        errorStyle: AppTextStyles.error,
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.deepNavy,
        selectedItemColor: AppColors.bossAqua,
        unselectedItemColor: AppColors.metalSilver,
        type: BottomNavigationBarType.fixed,
        elevation: 16,
        selectedLabelStyle: AppTextStyles.captionBold,
        unselectedLabelStyle: AppTextStyles.caption,
        showUnselectedLabels: true,
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.white,
        selectedColor: AppColors.bossAqua,
        disabledColor: AppColors.backgroundLight,
        labelStyle: AppTextStyles.labelSmall,
        side: const BorderSide(
          color: AppColors.deepNavy,
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      
      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.white,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: AppColors.deepNavy,
            width: 3,
          ),
        ),
        titleTextStyle: AppTextStyles.headline5,
        contentTextStyle: AppTextStyles.bodyMedium,
      ),
      
      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.bossAqua,
        linearTrackColor: AppColors.backgroundLight,
        circularTrackColor: AppColors.backgroundLight,
      ),
      
      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.bossAqua,
        inactiveTrackColor: AppColors.backgroundLight,
        thumbColor: AppColors.deepNavy,
        overlayColor: AppColors.rippleColor,
        valueIndicatorColor: AppColors.deepNavy,
        valueIndicatorTextStyle: AppTextStyles.caption.copyWith(
          color: AppColors.white,
        ),
        trackHeight: 6,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
      ),
      
      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.bossAqua;
          }
          return AppColors.metalSilver;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.bossAqua.withOpacity(0.5);
          }
          return AppColors.backgroundLight;
        }),
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.borderSecondary,
        thickness: 2,
        space: 16,
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.deepNavy,
        size: 24,
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.display1,
        displayMedium: AppTextStyles.display2,
        displaySmall: AppTextStyles.headline1,
        headlineLarge: AppTextStyles.headline2,
        headlineMedium: AppTextStyles.headline3,
        headlineSmall: AppTextStyles.headline4,
        titleLarge: AppTextStyles.headline5,
        titleMedium: AppTextStyles.headline6,
        titleSmall: AppTextStyles.subtitle1,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.buttonMedium,
        labelMedium: AppTextStyles.buttonSmall,
        labelSmall: AppTextStyles.label,
      ),
      
      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.deepNavy,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  // Dark Theme (Optional alternative theme)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.bossAqua,
        secondary: AppColors.sunsetOrange,
        tertiary: AppColors.metalSilver,
        surface: AppColors.darkNavy,
        error: AppColors.error,
        onPrimary: AppColors.deepNavy,
        onSecondary: AppColors.white,
        onSurface: AppColors.white,
        onError: AppColors.white,
      ),
      
      // Scaffold Background
      scaffoldBackgroundColor: AppColors.backgroundDark,
      
      // Card Theme
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.deepNavy,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: AppColors.bossAqua,
            width: 3,
          ),
        ),
        margin: const EdgeInsets.all(8),
      ),
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.display1,
        displayMedium: AppTextStyles.display2.copyWith(color: AppColors.white),
        displaySmall: AppTextStyles.headline1,
        headlineLarge: AppTextStyles.headline2.copyWith(color: AppColors.white),
        headlineMedium: AppTextStyles.headline3.copyWith(color: AppColors.white),
        headlineSmall: AppTextStyles.headline4.copyWith(color: AppColors.white),
        titleLarge: AppTextStyles.headline5.copyWith(color: AppColors.white),
        titleMedium: AppTextStyles.headline6.copyWith(color: AppColors.white),
        titleSmall: AppTextStyles.subtitle1.copyWith(color: AppColors.white),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.white),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.metalSilver),
        labelLarge: AppTextStyles.buttonMedium,
        labelMedium: AppTextStyles.buttonSmall,
        labelSmall: AppTextStyles.label.copyWith(color: AppColors.white),
      ),
    );
  }
  
  // Box Shadow Styles
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: AppColors.shadowPrimary,
      offset: const Offset(4, 8),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];
  
  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: AppColors.shadowSecondary,
      offset: const Offset(0, 4),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];
  
  static List<BoxShadow> get lightShadow => [
    BoxShadow(
      color: AppColors.shadowLight,
      offset: const Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];
  
  // Border Styles
  static BoxBorder get boldBorder => Border.all(
    color: AppColors.deepNavy,
    width: 3,
  );
  
  static BoxBorder get mediumBorder => Border.all(
    color: AppColors.deepNavy,
    width: 2,
  );
  
  static BoxBorder get lightBorder => Border.all(
    color: AppColors.borderSecondary,
    width: 1,
  );
}
