import 'package:flutter/foundation.dart';
import '../data/database/local_storage.dart';
import '../core/utils/size_calculator.dart';

/// Main app state provider (100% offline)
/// Manages user stats, XP, rank, settings
class AppStateProvider extends ChangeNotifier {
  final LocalStorage _storage = LocalStorage.instance;

  // User Stats
  int _userXP = 0;
  String _userRank = 'Rookie Angler';
  int _totalCatches = 0;
  int _catchStreak = 0;
  String _lastLoginDate = '';

  // Settings
  bool _firstLaunch = true;
  String _unitsSystem = 'imperial';
  bool _soundEnabled = true;
  bool _hapticEnabled = true;
  bool _notificationsEnabled = true;
  String _themeMode = 'light';

  bool _isLoading = false;
  String? _error;

  // Getters
  int get userXP => _userXP;
  String get userRank => _userRank;
  int get totalCatches => _totalCatches;
  int get catchStreak => _catchStreak;
  bool get firstLaunch => _firstLaunch;
  String get unitsSystem => _unitsSystem;
  bool get soundEnabled => _soundEnabled;
  bool get hapticsEnabled => _hapticEnabled;
  bool get notificationsEnabled => _notificationsEnabled;
  String get themeMode => _themeMode;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load all app state from local storage
  Future<void> loadAppState() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load user stats
      final stats = await _storage.getUserStats();
      _userXP = stats['xp'] as int;
      _userRank = stats['rank'] as String;
      _totalCatches = stats['totalCatches'] as int;
      _catchStreak = stats['catchStreak'] as int;
      _lastLoginDate = stats['lastLoginDate'] as String;

      // Update rank based on XP
      _userRank = SizeCalculator.getRankFromXP(_userXP);

      // Load settings
      final settings = await _storage.getSettings();
      _firstLaunch = settings['firstLaunch'] as bool;
      _unitsSystem = settings['unitsSystem'] as String;
      _soundEnabled = settings['soundEnabled'] as bool;
      _hapticEnabled = settings['hapticEnabled'] as bool;
      _notificationsEnabled = settings['notificationsEnabled'] as bool;
      _themeMode = settings['themeMode'] as String;

      // Check daily login
      await _checkDailyLogin();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Check and award daily login XP
  Future<void> _checkDailyLogin() async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (_lastLoginDate != today) {
      await addXP(5); // Daily login XP
      _lastLoginDate = today;
      await _saveStats();
    }
  }

  /// Add XP and update rank
  Future<void> addXP(int xp) async {
    _userXP += xp;
    _userRank = SizeCalculator.getRankFromXP(_userXP);
    await _saveStats();
    notifyListeners();
  }

  /// Increment total catches
  Future<void> incrementCatches() async {
    _totalCatches++;
    await _saveStats();
    notifyListeners();
  }

  /// Increment catch streak
  Future<void> incrementStreak() async {
    _catchStreak++;
    await _saveStats();
    notifyListeners();
  }

  /// Reset catch streak
  Future<void> resetStreak() async {
    _catchStreak = 0;
    await _saveStats();
    notifyListeners();
  }

  /// Save user stats to storage
  Future<void> _saveStats() async {
    await _storage.saveUserStats({
      'xp': _userXP,
      'rank': _userRank,
      'totalCatches': _totalCatches,
      'catchStreak': _catchStreak,
      'lastLoginDate': _lastLoginDate,
    });
  }

  /// Complete first launch
  Future<void> completeOnboarding() async {
    _firstLaunch = false;
    await _storage.setFirstLaunchComplete();
    notifyListeners();
  }

  /// Update units system
  Future<void> setUnitsSystem(String units) async {
    _unitsSystem = units;
    await _storage.saveSetting('units_system', units);
    notifyListeners();
  }

  /// Toggle sound
  Future<void> toggleSound(bool enabled) async {
    _soundEnabled = enabled;
    await _storage.saveSetting('sound_enabled', enabled);
    notifyListeners();
  }

  /// Set sound enabled
  Future<void> setSoundEnabled(bool enabled) async {
    await toggleSound(enabled);
  }

  /// Toggle haptic feedback
  Future<void> toggleHaptic(bool enabled) async {
    _hapticEnabled = enabled;
    await _storage.saveSetting('haptic_enabled', enabled);
    notifyListeners();
  }

  /// Set haptic enabled
  Future<void> setHapticsEnabled(bool enabled) async {
    await toggleHaptic(enabled);
  }

  /// Toggle notifications
  Future<void> toggleNotifications(bool enabled) async {
    _notificationsEnabled = enabled;
    await _storage.saveSetting('notifications_enabled', enabled);
    notifyListeners();
  }

  /// Set notifications enabled
  Future<void> setNotificationsEnabled(bool enabled) async {
    await toggleNotifications(enabled);
  }

  /// Set theme mode
  Future<void> setThemeMode(String mode) async {
    _themeMode = mode;
    await _storage.saveSetting('theme_mode', mode);
    notifyListeners();
  }

  /// Reset all data
  Future<void> resetAllData() async {
    await _storage.clearAllData();
    await loadAppState();
  }

  /// Reset app state (for clear all data)
  Future<void> resetAppState() async {
    _userXP = 0;
    _userRank = 'Rookie Angler';
    _totalCatches = 0;
    _catchStreak = 0;
    _lastLoginDate = '';
    _firstLaunch = true; // Reset to show onboarding again
    await _saveStats();
    notifyListeners();
  }

  /// Export all data
  Future<Map<String, dynamic>> exportData() async {
    return await _storage.exportAllData();
  }

  /// Get XP progress to next rank (returns 0.0 to 1.0 for progress bars)
  double getXPProgress() {
    final currentRankXP = SizeCalculator.getXPForRank(_userRank);
    final nextRank = SizeCalculator.getNextRank(_userRank);
    
    if (nextRank == null) return 1.0; // Max rank - 100% complete
    
    final nextRankXP = SizeCalculator.getXPForRank(nextRank);
    final progressPercentage = SizeCalculator.xpProgress(_userXP, currentRankXP, nextRankXP);
    // Convert from 0-100 percentage to 0.0-1.0 decimal
    return progressPercentage / 100.0;
  }

  /// Get next rank name
  String? getNextRank() {
    return SizeCalculator.getNextRank(_userRank);
  }

  /// Get XP needed for next rank
  int getXPNeededForNextRank() {
    final nextRank = getNextRank();
    if (nextRank == null) return 0;
    
    final nextRankXP = SizeCalculator.getXPForRank(nextRank);
    return nextRankXP - _userXP;
  }

  /// Get current user level (based on XP)
  int getUserLevel() {
    return SizeCalculator.getLevelFromXP(_userXP);
  }

  /// Get XP required for current level
  int getCurrentLevelXP() {
    final level = SizeCalculator.getLevelFromXP(_userXP);
    return SizeCalculator.getXPForLevel(level);
  }

  /// Get XP required for next level
  int getNextLevelXP() {
    final level = SizeCalculator.getLevelFromXP(_userXP);
    return SizeCalculator.getXPForLevel(level + 1);
  }
}
