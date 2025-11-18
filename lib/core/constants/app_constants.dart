/// Big Boss Fishing App Constants
class AppConstants {
  // App Info
  static const String appName = 'Big Boss Fishing';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Your Ultimate Fishing Logbook';
  
  // Database
  static const String databaseName = 'big_boss_fishing.db';
  static const int databaseVersion = 1;
  
  // Tables
  static const String tableCatches = 'catches';
  static const String tableSpots = 'spots';
  static const String tableTrips = 'trips';
  static const String tableGear = 'gear';
  static const String tableAchievements = 'achievements';
  static const String tableUserStats = 'user_stats';
  
  // SharedPreferences Keys
  static const String keyFirstLaunch = 'first_launch';
  static const String keyUserXP = 'user_xp';
  static const String keyUserRank = 'user_rank';
  static const String keyTotalCatches = 'total_catches';
  static const String keyUnitsSystem = 'units_system';
  static const String keySoundEnabled = 'sound_enabled';
  static const String keyHapticEnabled = 'haptic_enabled';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLastLoginDate = 'last_login_date';
  static const String keyCatchStreak = 'catch_streak';
  
  // Fish Species
  static const List<String> fishSpecies = [
    'Bass',
    'Trout',
    'Pike',
    'Salmon',
    'Catfish',
    'Carp',
    'Perch',
    'Walleye',
    'Cod',
    'Tuna',
    'Marlin',
    'Snapper',
  ];
  
  // Fish Icons Map (maps species to asset path)
  static const Map<String, String> fishIcons = {
    'Bass': 'assets/fish/bass-fish.png',
    'Trout': 'assets/fish/trout-fish.png',
    'Pike': 'assets/fish/pike-fish.png',
    'Salmon': 'assets/fish/salmon-fish.png',
    'Catfish': 'assets/fish/catfish-icon.png',
    'Carp': 'assets/fish/carp-fish.png',
    'Perch': 'assets/fish/perch-fish.png',
    'Walleye': 'assets/fish/walleye-fish.png',
    'Cod': 'assets/fish/cod-fish.png',
    'Tuna': 'assets/fish/tuna-fish.png',
    'Marlin': 'assets/fish/marlin-fish.png',
    'Snapper': 'assets/fish/snapper-fish.png',
  };
  
  // Water Types
  static const List<String> waterTypes = [
    'Lake',
    'River',
    'Ocean',
    'Pond',
    'Creek',
    'Reservoir',
  ];
  
  // Weather Conditions
  static const List<String> weatherConditions = [
    'Sunny',
    'Partly Cloudy',
    'Cloudy',
    'Rainy',
    'Stormy',
    'Windy',
    'Foggy',
    'Snowy',
  ];
  
  // Weather Icons Map
  static const Map<String, String> weatherIcons = {
    'Sunny': 'assets/weather/sunny.png',
    'Partly Cloudy': 'assets/weather/prtly-cloudy.png',
    'Cloudy': 'assets/weather/cloudy.png',
    'Rainy': 'assets/weather/rainy.png',
    'Stormy': 'assets/weather/stormy.png',
    'Windy': 'assets/weather/windy.png',
    'Foggy': 'assets/weather/foggy.png',
    'Snowy': 'assets/weather/snowy.png',
  };
  
  // Best Times of Day
  static const List<String> bestTimes = [
    'Early Morning',
    'Morning',
    'Midday',
    'Afternoon',
    'Evening',
    'Night',
  ];
  
  // Bait Types
  static const List<String> baitTypes = [
    'Live Bait',
    'Worms',
    'Minnows',
    'Crickets',
    'Lures',
    'Spinners',
    'Jigs',
    'Crankbaits',
    'Soft Plastics',
    'Spoons',
    'Flies',
    'Topwater',
  ];
  
  // Fishing Techniques
  static const List<String> fishingTechniques = [
    'Casting',
    'Trolling',
    'Jigging',
    'Bottom Fishing',
    'Fly Fishing',
    'Surf Fishing',
    'Ice Fishing',
    'Spin Fishing',
  ];
  
  // Gear Categories
  static const List<String> gearCategories = [
    'Rods',
    'Reels',
    'Lines',
    'Hooks',
    'Lures',
    'Baits',
    'Tools',
    'Accessories',
  ];
  
  // Navigation Icons
  static const Map<String, String> navigationIcons = {
    'home': 'assets/navigation-icons/home.png',
    'catch_log': 'assets/navigation-icons/catch-log.png',
    'spots': 'assets/navigation-icons/spots.png',
    'gear': 'assets/navigation-icons/gear.png',
    'stats': 'assets/navigation-icons/stats.png',
  };
  
  // Action Icons
  static const Map<String, String> actionIcons = {
    'add': 'assets/action-icons/add.png',
    'edit': 'assets/action-icons/edit.png',
    'delete': 'assets/action-icons/delete.png',
    'camera': 'assets/action-icons/camera.png',
    'settings': 'assets/action-icons/settings.png',
  };
  
  // Empty State Icons
  static const Map<String, String> emptyStateIcons = {
    'catches': 'assets/empty-states/no-catches.png',
    'spots': 'assets/empty-states/no-spots.png',
    'trips': 'assets/empty-states/no-trips.png',
  };
  
  // Achievement Badges
  static const Map<String, String> achievementBadges = {
    'first_catch': 'assets/achivments-badges/first-catch.png',
    'ten_catches': 'assets/achivments-badges/ten-catches.png',
    'big_boss': 'assets/achivments-badges/big-boss.png',
    'bait_master': 'assets/achivments-badges/bait-master.png',
    'catch_streak': 'assets/achivments-badges/catch-streak.png',
    'dawn_fisher': 'assets/achivments-badges/dawn-fisher.png',
    'gear_guardian': 'assets/achivments-badges/gear-guardian.png',
    'lake_master': 'assets/achivments-badges/lake-master.png',
    'night_owl': 'assets/achivments-badges/night-owl.png',
    'perfect_cast': 'assets/achivments-badges/perfect-cast.png',
    'spot_hunter': 'assets/achivments-badges/spot-hunter.png',
    'trophy_hunter': 'assets/achivments-badges/trophy-hunter.png',
  };
  
  // XP Rewards
  static const int xpAddCatch = 10;
  static const int xpAddSpot = 15;
  static const int xpCompleteTrip = 20;
  static const int xpUpdateGear = 5;
  static const int xpDailyLogin = 5;
  static const int xpCatchStreak = 5;
  static const int xpAchievementUnlock = 50;
  
  // Rank System
  static const Map<String, int> ranks = {
    'Rookie Angler': 0,
    'Rod Commander': 100,
    'Lake Master': 300,
    'River Chief': 600,
    'Big Boss Fisher': 1000,
  };
  
  static const List<String> rankNames = [
    'Rookie Angler',
    'Rod Commander',
    'Lake Master',
    'River Chief',
    'Big Boss Fisher',
  ];
  
  // Animations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  static const Duration rippleAnimationDuration = Duration(milliseconds: 600);
  
  // Pagination
  static const int itemsPerPage = 20;
  
  // Image Compression
  static const int maxImageWidth = 800;
  static const int maxImageHeight = 800;
  static const int imageQuality = 85;
  
  // Units
  static const String unitsImperial = 'imperial';
  static const String unitsMetric = 'metric';
  
  // Weight Units
  static const String weightLbs = 'lbs';
  static const String weightKg = 'kg';
  
  // Length Units
  static const String lengthInches = 'in';
  static const String lengthCm = 'cm';
  
  // Default Values
  static const String defaultWeatherCondition = 'Sunny';
  static const String defaultWaterType = 'Lake';
  static const String defaultBestTime = 'Morning';
  static const int defaultRating = 3;
  
  // Validation
  static const double minWeight = 0.1;
  static const double maxWeight = 1000.0;
  static const double minLength = 1.0;
  static const double maxLength = 200.0;
  
  // Routes
  static const String routeSplash = '/splash';
  static const String routeOnboarding = '/onboarding';
  static const String routeHome = '/home';
  static const String routeCatchLog = '/catch-log';
  static const String routeAddCatch = '/add-catch';
  static const String routeCatchDetail = '/catch-detail';
  static const String routeSpots = '/spots';
  static const String routeAddSpot = '/add-spot';
  static const String routeGear = '/gear';
  static const String routeAddGear = '/add-gear';
  static const String routePlanner = '/planner';
  static const String routeAddTrip = '/add-trip';
  static const String routeStats = '/stats';
  static const String routeSettings = '/settings';
}
