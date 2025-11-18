import 'package:big_boss_fishing/core/constants/app_constants.dart';

/// Size and unit conversion utilities for Big Boss Fishing
class SizeCalculator {
  // Weight Conversions
  
  /// Convert pounds to kilograms
  static double poundsToKg(double pounds) {
    return pounds * 0.453592;
  }
  
  /// Convert kilograms to pounds
  static double kgToPounds(double kg) {
    return kg * 2.20462;
  }
  
  /// Format weight with appropriate unit
  static String formatWeight(double weight, String units) {
    if (units == AppConstants.unitsImperial) {
      return '${weight.toStringAsFixed(2)} lbs';
    } else {
      final kg = poundsToKg(weight);
      return '${kg.toStringAsFixed(2)} kg';
    }
  }
  
  /// Get weight value in preferred units
  static double getWeight(double storedWeight, String units) {
    if (units == AppConstants.unitsImperial) {
      return storedWeight;
    } else {
      return poundsToKg(storedWeight);
    }
  }
  
  /// Convert weight to storage format (always pounds)
  static double weightToStorage(double weight, String units) {
    if (units == AppConstants.unitsImperial) {
      return weight;
    } else {
      return kgToPounds(weight);
    }
  }
  
  // Length Conversions
  
  /// Convert inches to centimeters
  static double inchesToCm(double inches) {
    return inches * 2.54;
  }
  
  /// Convert centimeters to inches
  static double cmToInches(double cm) {
    return cm / 2.54;
  }
  
  /// Format length with appropriate unit
  static String formatLength(double length, String units) {
    if (units == AppConstants.unitsImperial) {
      return '${length.toStringAsFixed(1)} in';
    } else {
      final cm = inchesToCm(length);
      return '${cm.toStringAsFixed(1)} cm';
    }
  }
  
  /// Get length value in preferred units
  static double getLength(double storedLength, String units) {
    if (units == AppConstants.unitsImperial) {
      return storedLength;
    } else {
      return inchesToCm(storedLength);
    }
  }
  
  /// Convert length to storage format (always inches)
  static double lengthToStorage(double length, String units) {
    if (units == AppConstants.unitsImperial) {
      return length;
    } else {
      return cmToInches(length);
    }
  }
  
  // Fish Size Categories
  
  /// Get fish size category based on length
  static String getSizeCategory(double lengthInches) {
    if (lengthInches < 6) {
      return 'Tiny';
    } else if (lengthInches < 12) {
      return 'Small';
    } else if (lengthInches < 18) {
      return 'Medium';
    } else if (lengthInches < 24) {
      return 'Large';
    } else if (lengthInches < 36) {
      return 'Very Large';
    } else {
      return 'Trophy';
    }
  }
  
  /// Get trophy status (is this a trophy catch?)
  static bool isTrophy(double lengthInches, double weightPounds) {
    // Trophy is defined as length > 30 inches OR weight > 20 lbs
    return lengthInches >= 30 || weightPounds >= 20;
  }
  
  /// Get weight category
  static String getWeightCategory(double weightPounds) {
    if (weightPounds < 1) {
      return 'Tiny';
    } else if (weightPounds < 3) {
      return 'Small';
    } else if (weightPounds < 7) {
      return 'Medium';
    } else if (weightPounds < 15) {
      return 'Large';
    } else if (weightPounds < 25) {
      return 'Very Large';
    } else {
      return 'Trophy';
    }
  }
  
  // Temperature Conversions (for weather)
  
  /// Convert Fahrenheit to Celsius
  static double fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }
  
  /// Convert Celsius to Fahrenheit
  static double celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }
  
  /// Format temperature with unit
  static String formatTemperature(double fahrenheit, String units) {
    if (units == AppConstants.unitsImperial) {
      return '${fahrenheit.toStringAsFixed(0)}°F';
    } else {
      final celsius = fahrenheitToCelsius(fahrenheit);
      return '${celsius.toStringAsFixed(0)}°C';
    }
  }
  
  // Distance/Depth Conversions
  
  /// Convert feet to meters
  static double feetToMeters(double feet) {
    return feet * 0.3048;
  }
  
  /// Convert meters to feet
  static double metersToFeet(double meters) {
    return meters / 0.3048;
  }
  
  /// Format depth with unit
  static String formatDepth(double feet, String units) {
    if (units == AppConstants.unitsImperial) {
      return '${feet.toStringAsFixed(0)} ft';
    } else {
      final meters = feetToMeters(feet);
      return '${meters.toStringAsFixed(1)} m';
    }
  }
  
  // Statistical Calculations
  
  /// Calculate average from a list of numbers
  static double average(List<double> values) {
    if (values.isEmpty) return 0.0;
    final sum = values.reduce((a, b) => a + b);
    return sum / values.length;
  }
  
  /// Find maximum value in list
  static double max(List<double> values) {
    if (values.isEmpty) return 0.0;
    return values.reduce((a, b) => a > b ? a : b);
  }
  
  /// Find minimum value in list
  static double min(List<double> values) {
    if (values.isEmpty) return 0.0;
    return values.reduce((a, b) => a < b ? a : b);
  }
  
  /// Calculate total/sum
  static double sum(List<double> values) {
    if (values.isEmpty) return 0.0;
    return values.reduce((a, b) => a + b);
  }
  
  /// Calculate percentage
  static double percentage(double value, double total) {
    if (total == 0) return 0.0;
    return (value / total) * 100;
  }
  
  /// Format percentage
  static String formatPercentage(double percentage) {
    return '${percentage.toStringAsFixed(1)}%';
  }
  
  // Formatting Helpers
  
  /// Format number with commas (e.g., 1,234)
  static String formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
  
  /// Format decimal with specified precision
  static String formatDecimal(double value, int decimals) {
    return value.toStringAsFixed(decimals);
  }
  
  /// Round to nearest half (for ratings)
  static double roundToHalf(double value) {
    return (value * 2).round() / 2;
  }
  
  /// Clamp value between min and max
  static double clamp(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }
  
  // XP and Progress Calculations
  
  /// Calculate XP progress percentage to next rank
  static double xpProgress(int currentXP, int currentRankXP, int nextRankXP) {
    if (nextRankXP == currentRankXP) return 100.0;
    
    final xpInCurrentRank = currentXP - currentRankXP;
    final xpNeededForNextRank = nextRankXP - currentRankXP;
    
    return percentage(xpInCurrentRank.toDouble(), xpNeededForNextRank.toDouble());
  }
  
  /// Calculate achievement progress percentage
  static double achievementProgress(int current, int target) {
    if (target == 0) return 0.0;
    final progress = percentage(current.toDouble(), target.toDouble());
    return clamp(progress, 0.0, 100.0);
  }
  
  /// Get rank name from XP
  static String getRankFromXP(int xp) {
    if (xp >= AppConstants.ranks['Big Boss Fisher']!) {
      return 'Big Boss Fisher';
    } else if (xp >= AppConstants.ranks['River Chief']!) {
      return 'River Chief';
    } else if (xp >= AppConstants.ranks['Lake Master']!) {
      return 'Lake Master';
    } else if (xp >= AppConstants.ranks['Rod Commander']!) {
      return 'Rod Commander';
    } else {
      return 'Rookie Angler';
    }
  }
  
  /// Get next rank name
  static String? getNextRank(String currentRank) {
    final index = AppConstants.rankNames.indexOf(currentRank);
    if (index == -1 || index == AppConstants.rankNames.length - 1) {
      return null; // Max rank reached
    }
    return AppConstants.rankNames[index + 1];
  }
  
  /// Get XP required for rank
  static int getXPForRank(String rank) {
    return AppConstants.ranks[rank] ?? 0;
  }

  /// Get level from XP (every 100 XP = 1 level)
  static int getLevelFromXP(int xp) {
    return (xp / 100).floor() + 1;
  }

  /// Get XP required for a specific level
  static int getXPForLevel(int level) {
    if (level <= 1) return 0;
    return (level - 1) * 100;
  }
}
