import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/achievement_provider.dart';
import '../../providers/catch_provider.dart';
import '../../providers/spot_provider.dart';
import '../../providers/gear_provider.dart';
import '../../data/models/catch_model.dart';
import '../../presentation/widgets/achievement_unlock_dialog.dart';

/// Service that checks for and unlocks achievements based on user actions
class AchievementService {
  /// Check all achievement conditions after a catch is logged
  static Future<void> checkCatchAchievements(
    BuildContext context,
    CatchModel newCatch,
  ) async {
    if (!context.mounted) return;
    
    final achievementProvider = Provider.of<AchievementProvider>(context, listen: false);
    final catchProvider = Provider.of<CatchProvider>(context, listen: false);
    
    final totalCatches = catchProvider.catches.length;
    // Trophy fish: 20+ lbs OR 30+ inches
    final trophyCatches = catchProvider.catches.where((c) => c.weight >= 20 || c.length >= 30).length;
    final fiveStarCatches = catchProvider.catches.where((c) => c.rating == 5).length;
    
    // First Catch
    if (totalCatches == 1) {
      await _unlockAchievement(context, achievementProvider, 'first_catch');
    }
    
    // Ten Catches
    if (totalCatches == 10) {
      await _unlockAchievement(context, achievementProvider, 'ten_catches');
    }
    
    // Big Boss (first trophy)
    final isTrophy = newCatch.weight >= 20 || newCatch.length >= 30;
    if (isTrophy && trophyCatches == 1) {
      await _unlockAchievement(context, achievementProvider, 'big_boss');
    }
    
    // Trophy Hunter (5 trophies)
    if (trophyCatches == 5) {
      await _unlockAchievement(context, achievementProvider, 'trophy_hunter');
    }
    
    // Perfect Cast (10 five-star catches)
    if (fiveStarCatches == 10) {
      await _unlockAchievement(context, achievementProvider, 'perfect_cast');
    }
    
    // Dawn Fisher (early morning catch 5-8 AM)
    final hour = newCatch.dateTime.hour;
    if (hour >= 5 && hour < 8) {
      await _unlockAchievement(context, achievementProvider, 'dawn_fisher');
    }
    
    // Night Owl (night catch 9 PM - 5 AM)
    if (hour >= 21 || hour < 5) {
      await _unlockAchievement(context, achievementProvider, 'night_owl');
    }
    
    // Catch Streak (7 days in a row)
    if (_hasSevenDayStreak(catchProvider.catches)) {
      await _unlockAchievement(context, achievementProvider, 'catch_streak');
    }
    
    // Bait Master (10 different baits used)
    final uniqueBaits = catchProvider.catches
        .map((c) => c.bait)
        .where((b) => b.isNotEmpty)
        .toSet()
        .length;
    if (uniqueBaits >= 10) {
      await _unlockAchievement(context, achievementProvider, 'bait_master');
    }
    
    // Spot Hunter (catches at 5 different spots)
    final uniqueSpots = catchProvider.catches
        .map((c) => c.location)
        .where((s) => s.isNotEmpty)
        .toSet()
        .length;
    if (uniqueSpots >= 5) {
      await _unlockAchievement(context, achievementProvider, 'spot_hunter');
    }
  }
  
  /// Check achievements after a spot is added
  static Future<void> checkSpotAchievements(BuildContext context) async {
    if (!context.mounted) return;
    
    final achievementProvider = Provider.of<AchievementProvider>(context, listen: false);
    final spotProvider = Provider.of<SpotProvider>(context, listen: false);
    
    final totalSpots = spotProvider.spots.length;
    
    // Lake Master (10 spots discovered)
    if (totalSpots == 10) {
      await _unlockAchievement(context, achievementProvider, 'lake_master');
    }
  }
  
  /// Check achievements after gear is added
  static Future<void> checkGearAchievements(BuildContext context) async {
    if (!context.mounted) return;
    
    final achievementProvider = Provider.of<AchievementProvider>(context, listen: false);
    final gearProvider = Provider.of<GearProvider>(context, listen: false);
    
    final totalGear = gearProvider.gear.length;
    
    // Gear Guardian (20 gear items)
    if (totalGear == 20) {
      await _unlockAchievement(context, achievementProvider, 'gear_guardian');
    }
  }
  
  /// Helper to unlock achievement and show dialog
  static Future<void> _unlockAchievement(
    BuildContext context,
    AchievementProvider provider,
    String achievementId,
  ) async {
    final achievement = provider.achievements.firstWhere(
      (a) => a.id == achievementId,
      orElse: () => provider.achievements.first,
    );
    
    // Don't unlock if already unlocked
    if (achievement.isUnlocked) return;
    
    // Unlock the achievement
    await provider.unlockAchievement(achievementId);
    
    // Show unlock dialog with animation
    if (context.mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AchievementUnlockDialog(achievement: achievement),
      );
    }
  }
  
  /// Check if user has 7-day catch streak
  static bool _hasSevenDayStreak(List<CatchModel> catches) {
    if (catches.length < 7) return false;
    
    // Sort catches by date
    final sortedCatches = List<CatchModel>.from(catches)
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
    
    // Get unique catch days (ignore time)
    final catchDays = sortedCatches.map((c) {
      final date = c.dateTime;
      return DateTime(date.year, date.month, date.day);
    }).toSet().toList()
      ..sort((a, b) => b.compareTo(a));
    
    // Check for 7 consecutive days
    int streakCount = 1;
    for (int i = 0; i < catchDays.length - 1; i++) {
      final diff = catchDays[i].difference(catchDays[i + 1]).inDays;
      if (diff == 1) {
        streakCount++;
        if (streakCount >= 7) return true;
      } else {
        streakCount = 1; // Reset streak
      }
    }
    
    return false;
  }
}
