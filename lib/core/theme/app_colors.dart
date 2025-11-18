import 'package:flutter/material.dart';

/// Big Boss Fishing Color Palette
/// Bold, masculine, rugged design aesthetic
class AppColors {
  // Primary Colors
  static const Color deepNavy = Color(0xFF0D2B5E);
  static const Color bossAqua = Color(0xFF2DFCFF);
  static const Color metalSilver = Color(0xFFC7C7C7);
  static const Color sunsetOrange = Color(0xFFFF8A3B);
  static const Color darkNavy = Color(0xFF051529);
  static const Color white = Color(0xFFFFFFFF);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE91E63);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);
  
  // Text Colors
  static const Color textPrimary = deepNavy;
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = white;
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = darkNavy;
  static const Color cardBackground = white;
  
  // Border Colors
  static const Color borderPrimary = deepNavy;
  static const Color borderSecondary = metalSilver;
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [deepNavy, darkNavy],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient aquaGradient = LinearGradient(
    colors: [bossAqua, Color(0xFF1AB8BB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [sunsetOrange, Color(0xFFFF6B35)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient silverGradient = LinearGradient(
    colors: [metalSilver, Color(0xFFE0E0E0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient darkGradient = LinearGradient(
    colors: [darkNavy, Color(0xFF000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // Additional gradients for widgets
  static const LinearGradient secondaryGradient = sunsetGradient;
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFAFAFA), white],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Accent colors (aliases for convenience)
  static const Color accentAqua = bossAqua;
  static const Color accentOrange = sunsetOrange;
  
  // Overlay Colors
  static Color overlayLight = Colors.black.withOpacity(0.15);
  static Color overlayDark = Colors.black.withOpacity(0.5);
  static Color overlayExtraLight = Colors.black.withOpacity(0.05);
  
  // Shadow Colors
  static Color shadowPrimary = deepNavy.withOpacity(0.3);
  static Color shadowSecondary = deepNavy.withOpacity(0.4);
  static Color shadowLight = Colors.black.withOpacity(0.1);
  
  // Ripple Effect Color
  static Color rippleColor = bossAqua.withOpacity(0.3);
  
  // Water Type Colors
  static const Color freshwater = Color(0xFF4A90E2);
  static const Color saltwater = Color(0xFF0077BE);
  static const Color brackish = Color(0xFF5DADE2);
  
  // Weather Colors
  static const Color sunny = Color(0xFFFDB813);
  static const Color cloudy = Color(0xFF9E9E9E);
  static const Color rainy = Color(0xFF607D8B);
  static const Color stormy = Color(0xFF455A64);
  
  // Achievement Tiers
  static const Color bronze = Color(0xFFCD7F32);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color gold = Color(0xFFFFD700);
  static const Color platinum = Color(0xFFE5E4E2);
  
  // Chart Colors
  static const List<Color> chartColors = [
    bossAqua,
    sunsetOrange,
    success,
    Color(0xFF9C27B0),
    Color(0xFFFF5722),
    Color(0xFF00BCD4),
    Color(0xFFCDDC39),
    Color(0xFFE91E63),
  ];
}
