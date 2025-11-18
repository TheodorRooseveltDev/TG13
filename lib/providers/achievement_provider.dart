import 'package:flutter/foundation.dart';
import '../data/models/achievement_model.dart';
import '../data/database/local_storage.dart';

/// Provider for managing achievements (100% offline)
class AchievementProvider extends ChangeNotifier {
  final LocalStorage _storage = LocalStorage.instance;

  List<AchievementModel> _achievements = [];
  bool _isLoading = false;
  String? _error;

  List<AchievementModel> get achievements => _achievements;
  List<AchievementModel> get unlockedAchievements => 
      _achievements.where((a) => a.isUnlocked).toList();
  List<AchievementModel> get lockedAchievements => 
      _achievements.where((a) => !a.isUnlocked).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAchievements() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _achievements = await _storage.getAchievements();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> unlockAchievement(String id) async {
    try {
      final achievement = _achievements.firstWhere((a) => a.id == id);
      if (!achievement.isUnlocked) {
        final updated = achievement.copyWith(
          isUnlocked: true,
          progress: 1.0,
          unlockedAt: DateTime.now(),
        );
        await _storage.updateAchievement(updated);
        await _storage.addXP(achievement.xpReward);
        await loadAchievements();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateProgress(String id, double progress) async {
    try {
      final achievement = _achievements.firstWhere((a) => a.id == id);
      if (progress >= 1.0 && !achievement.isUnlocked) {
        await unlockAchievement(id);
      } else {
        final updated = achievement.copyWith(progress: progress);
        await _storage.updateAchievement(updated);
        await loadAchievements();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  int get totalUnlocked => unlockedAchievements.length;
  int get totalAchievements => _achievements.length;
  double get completionPercentage => 
      totalAchievements > 0 ? (totalUnlocked / totalAchievements) * 100 : 0.0;
}
