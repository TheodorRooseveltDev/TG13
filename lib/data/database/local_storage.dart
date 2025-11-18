import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/catch_model.dart';
import '../models/spot_model.dart';
import '../models/trip_model.dart';
import '../models/gear_model.dart';
import '../models/achievement_model.dart';

/// Local Storage Manager - Pure Offline Storage
/// Uses local JSON files + SharedPreferences
/// NO DATABASE, NO INTERNET, 100% OFFLINE
class LocalStorage {
  static LocalStorage? _instance;
  static LocalStorage get instance {
    _instance ??= LocalStorage._();
    return _instance!;
  }

  LocalStorage._();

  // File names for local JSON storage
  static const String _catchesFile = 'catches.json';
  static const String _spotsFile = 'spots.json';
  static const String _tripsFile = 'trips.json';
  static const String _gearFile = 'gear.json';
  static const String _achievementsFile = 'achievements.json';

  // Get local directory path
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Get file reference
  Future<File> _getFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  // CATCHES STORAGE
  Future<List<CatchModel>> getCatches() async {
    try {
      final file = await _getFile(_catchesFile);
      if (!await file.exists()) return [];
      
      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.map((json) => CatchModel.fromJson(json)).toList();
    } catch (e) {
      print('Error loading catches: $e');
      return [];
    }
  }

  Future<void> saveCatches(List<CatchModel> catches) async {
    try {
      final file = await _getFile(_catchesFile);
      final jsonList = catches.map((c) => c.toJson()).toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      print('Error saving catches: $e');
    }
  }

  Future<void> addCatch(CatchModel catchModel) async {
    final catches = await getCatches();
    catches.insert(0, catchModel); // Add to beginning
    await saveCatches(catches);
  }

  Future<void> updateCatch(CatchModel catchModel) async {
    final catches = await getCatches();
    final index = catches.indexWhere((c) => c.id == catchModel.id);
    if (index != -1) {
      catches[index] = catchModel;
      await saveCatches(catches);
    }
  }

  Future<void> deleteCatch(String id) async {
    final catches = await getCatches();
    catches.removeWhere((c) => c.id == id);
    await saveCatches(catches);
  }

  // SPOTS STORAGE
  Future<List<SpotModel>> getSpots() async {
    try {
      final file = await _getFile(_spotsFile);
      if (!await file.exists()) return [];
      
      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.map((json) => SpotModel.fromJson(json)).toList();
    } catch (e) {
      print('Error loading spots: $e');
      return [];
    }
  }

  Future<void> saveSpots(List<SpotModel> spots) async {
    try {
      final file = await _getFile(_spotsFile);
      final jsonList = spots.map((s) => s.toJson()).toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      print('Error saving spots: $e');
    }
  }

  Future<void> addSpot(SpotModel spot) async {
    final spots = await getSpots();
    spots.add(spot);
    await saveSpots(spots);
  }

  Future<void> updateSpot(SpotModel spot) async {
    final spots = await getSpots();
    final index = spots.indexWhere((s) => s.id == spot.id);
    if (index != -1) {
      spots[index] = spot;
      await saveSpots(spots);
    }
  }

  Future<void> deleteSpot(String id) async {
    final spots = await getSpots();
    spots.removeWhere((s) => s.id == id);
    await saveSpots(spots);
  }

  // TRIPS STORAGE
  Future<List<TripModel>> getTrips() async {
    try {
      final file = await _getFile(_tripsFile);
      if (!await file.exists()) return [];
      
      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.map((json) => TripModel.fromJson(json)).toList();
    } catch (e) {
      print('Error loading trips: $e');
      return [];
    }
  }

  Future<void> saveTrips(List<TripModel> trips) async {
    try {
      final file = await _getFile(_tripsFile);
      final jsonList = trips.map((t) => t.toJson()).toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      print('Error saving trips: $e');
    }
  }

  Future<void> addTrip(TripModel trip) async {
    final trips = await getTrips();
    trips.add(trip);
    await saveTrips(trips);
  }

  Future<void> updateTrip(TripModel trip) async {
    final trips = await getTrips();
    final index = trips.indexWhere((t) => t.id == trip.id);
    if (index != -1) {
      trips[index] = trip;
      await saveTrips(trips);
    }
  }

  Future<void> deleteTrip(String id) async {
    final trips = await getTrips();
    trips.removeWhere((t) => t.id == id);
    await saveTrips(trips);
  }

  // GEAR STORAGE
  Future<List<GearModel>> getGear() async {
    try {
      final file = await _getFile(_gearFile);
      if (!await file.exists()) return [];
      
      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.map((json) => GearModel.fromJson(json)).toList();
    } catch (e) {
      print('Error loading gear: $e');
      return [];
    }
  }

  Future<void> saveGear(List<GearModel> gear) async {
    try {
      final file = await _getFile(_gearFile);
      final jsonList = gear.map((g) => g.toJson()).toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      print('Error saving gear: $e');
    }
  }

  Future<void> addGear(GearModel gearItem) async {
    final gear = await getGear();
    gear.add(gearItem);
    await saveGear(gear);
  }

  Future<void> updateGear(GearModel gearItem) async {
    final gear = await getGear();
    final index = gear.indexWhere((g) => g.id == gearItem.id);
    if (index != -1) {
      gear[index] = gearItem;
      await saveGear(gear);
    }
  }

  Future<void> deleteGear(String id) async {
    final gear = await getGear();
    gear.removeWhere((g) => g.id == id);
    await saveGear(gear);
  }

  // ACHIEVEMENTS STORAGE
  Future<List<AchievementModel>> getAchievements() async {
    try {
      final file = await _getFile(_achievementsFile);
      if (!await file.exists()) {
        // Initialize with default achievements
        final defaults = AchievementModel.getDefaultAchievements();
        await saveAchievements(defaults);
        return defaults;
      }
      
      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.map((json) => AchievementModel.fromJson(json)).toList();
    } catch (e) {
      print('Error loading achievements: $e');
      return AchievementModel.getDefaultAchievements();
    }
  }

  Future<void> saveAchievements(List<AchievementModel> achievements) async {
    try {
      final file = await _getFile(_achievementsFile);
      final jsonList = achievements.map((a) => a.toJson()).toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      print('Error saving achievements: $e');
    }
  }

  Future<void> updateAchievement(AchievementModel achievement) async {
    final achievements = await getAchievements();
    final index = achievements.indexWhere((a) => a.id == achievement.id);
    if (index != -1) {
      achievements[index] = achievement;
      await saveAchievements(achievements);
    }
  }

  // USER STATS (XP, Rank, etc.) - Using SharedPreferences
  Future<Map<String, dynamic>> getUserStats() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'xp': prefs.getInt('user_xp') ?? 0,
      'rank': prefs.getString('user_rank') ?? 'Rookie Angler',
      'totalCatches': prefs.getInt('total_catches') ?? 0,
      'catchStreak': prefs.getInt('catch_streak') ?? 0,
      'lastLoginDate': prefs.getString('last_login_date') ?? '',
    };
  }

  Future<void> saveUserStats(Map<String, dynamic> stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_xp', stats['xp'] ?? 0);
    await prefs.setString('user_rank', stats['rank'] ?? 'Rookie Angler');
    await prefs.setInt('total_catches', stats['totalCatches'] ?? 0);
    await prefs.setInt('catch_streak', stats['catchStreak'] ?? 0);
    await prefs.setString('last_login_date', stats['lastLoginDate'] ?? '');
  }

  Future<void> addXP(int xp) async {
    final stats = await getUserStats();
    final currentXP = stats['xp'] as int;
    stats['xp'] = currentXP + xp;
    await saveUserStats(stats);
  }

  Future<void> incrementCatchStreak() async {
    final stats = await getUserStats();
    final streak = stats['catchStreak'] as int;
    stats['catchStreak'] = streak + 1;
    await saveUserStats(stats);
  }

  // APP SETTINGS - Using SharedPreferences
  Future<Map<String, dynamic>> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'firstLaunch': prefs.getBool('first_launch') ?? true,
      'unitsSystem': prefs.getString('units_system') ?? 'imperial',
      'soundEnabled': prefs.getBool('sound_enabled') ?? true,
      'hapticEnabled': prefs.getBool('haptic_enabled') ?? true,
      'notificationsEnabled': prefs.getBool('notifications_enabled') ?? true,
      'themeMode': prefs.getString('theme_mode') ?? 'light',
    };
  }

  Future<void> saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    }
  }

  Future<void> setFirstLaunchComplete() async {
    await saveSetting('first_launch', false);
  }

  // EXPORT ALL DATA (for backup)
  Future<Map<String, dynamic>> exportAllData() async {
    final catches = await getCatches();
    final spots = await getSpots();
    final trips = await getTrips();
    final gear = await getGear();
    final achievements = await getAchievements();
    final stats = await getUserStats();
    final settings = await getSettings();

    return {
      'catches': catches.map((c) => c.toJson()).toList(),
      'spots': spots.map((s) => s.toJson()).toList(),
      'trips': trips.map((t) => t.toJson()).toList(),
      'gear': gear.map((g) => g.toJson()).toList(),
      'achievements': achievements.map((a) => a.toJson()).toList(),
      'stats': stats,
      'settings': settings,
      'exportDate': DateTime.now().toIso8601String(),
      'appVersion': '1.0.0',
    };
  }

  // CLEAR ALL DATA (for reset)
  Future<void> clearAllData() async {
    await saveCatches([]);
    await saveSpots([]);
    await saveTrips([]);
    await saveGear([]);
    
    // Reset achievements to defaults
    final defaults = AchievementModel.getDefaultAchievements();
    await saveAchievements(defaults);
    
    // Reset stats
    await saveUserStats({
      'xp': 0,
      'rank': 'Rookie Angler',
      'totalCatches': 0,
      'catchStreak': 0,
      'lastLoginDate': '',
    });
    
    // Keep settings but reset first launch
    await saveSetting('first_launch', true);
  }
}
