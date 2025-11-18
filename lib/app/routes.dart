import 'package:flutter/material.dart';
import 'package:big_boss_fishing/core/constants/app_constants.dart';
import 'package:big_boss_fishing/presentation/screens/splash/splash_screen.dart';
import 'package:big_boss_fishing/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:big_boss_fishing/presentation/screens/home/home_screen.dart';
import 'package:big_boss_fishing/presentation/screens/catch_log/catch_log_screen.dart';
import 'package:big_boss_fishing/presentation/screens/catch_log/add_catch_screen.dart';
import 'package:big_boss_fishing/presentation/screens/catch_log/catch_detail_screen.dart';
import 'package:big_boss_fishing/presentation/screens/spots/spots_screen.dart';
import 'package:big_boss_fishing/presentation/screens/spots/add_spot_screen.dart';
import 'package:big_boss_fishing/presentation/screens/spots/spot_detail_screen.dart';
import 'package:big_boss_fishing/presentation/screens/stats/stats_screen.dart';
import 'package:big_boss_fishing/presentation/screens/settings/settings_screen.dart';
import 'package:big_boss_fishing/presentation/screens/gear/gear_screen.dart';
import 'package:big_boss_fishing/presentation/screens/gear/add_gear_screen.dart';
import 'package:big_boss_fishing/presentation/screens/gear/gear_detail_screen.dart';
import 'package:big_boss_fishing/presentation/screens/trips/trips_screen.dart';
import 'package:big_boss_fishing/presentation/screens/trips/add_trip_screen.dart';
import 'package:big_boss_fishing/presentation/screens/trips/trip_detail_screen.dart';
import 'package:big_boss_fishing/presentation/screens/achievements/achievements_screen.dart';
import 'package:big_boss_fishing/data/models/catch_model.dart';
import 'package:big_boss_fishing/data/models/spot_model.dart';
import 'package:big_boss_fishing/data/models/gear_model.dart';
import 'package:big_boss_fishing/data/models/trip_model.dart';

/// App Routes Configuration
class AppRoutes {
  static const String splash = AppConstants.routeSplash;
  static const String onboarding = AppConstants.routeOnboarding;
  static const String home = AppConstants.routeHome;
  static const String catchLog = AppConstants.routeCatchLog;
  static const String addCatch = AppConstants.routeAddCatch;
  static const String catchDetail = '/catch-detail';
  static const String spots = AppConstants.routeSpots;
  static const String addSpot = '/add-spot';
  static const String spotDetail = '/spot-detail';
  static const String gear = AppConstants.routeGear;
  static const String addGear = '/add-gear';
  static const String gearDetail = '/gear-detail';
  static const String planner = AppConstants.routePlanner;
  static const String addTrip = '/add-trip';
  static const String tripDetail = '/trip-detail';
  static const String stats = AppConstants.routeStats;
  static const String settingsRoute = AppConstants.routeSettings;
  static const String achievements = '/achievements';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      case catchLog:
        return MaterialPageRoute(
          builder: (_) => const CatchLogScreen(),
        );
      case addCatch:
        return MaterialPageRoute(
          builder: (_) => const AddCatchScreen(),
        );
      case catchDetail:
        final catchModel = settings.arguments as CatchModel;
        return MaterialPageRoute(
          builder: (_) => CatchDetailScreen(catchModel: catchModel),
        );
      case spots:
        return MaterialPageRoute(
          builder: (_) => const SpotsScreen(),
        );
      case addSpot:
        return MaterialPageRoute(
          builder: (_) => const AddSpotScreen(),
        );
      case spotDetail:
        final spot = settings.arguments as SpotModel;
        return MaterialPageRoute(
          builder: (_) => SpotDetailScreen(spot: spot),
        );
      case gear:
        return MaterialPageRoute(
          builder: (_) => const GearScreen(),
        );
      case addGear:
        final gearToEdit = settings.arguments as GearModel?;
        return MaterialPageRoute(
          builder: (_) => AddGearScreen(gear: gearToEdit),
        );
      case gearDetail:
        final gearItem = settings.arguments as GearModel;
        return MaterialPageRoute(
          builder: (_) => GearDetailScreen(gear: gearItem),
        );
      case planner:
        return MaterialPageRoute(
          builder: (_) => const TripsScreen(),
        );
      case addTrip:
        final tripToEdit = settings.arguments as TripModel?;
        return MaterialPageRoute(
          builder: (_) => AddTripScreen(trip: tripToEdit),
        );
      case tripDetail:
        final tripItem = settings.arguments as TripModel;
        return MaterialPageRoute(
          builder: (_) => TripDetailScreen(trip: tripItem),
        );
      case stats:
        return MaterialPageRoute(
          builder: (_) => const StatsScreen(),
        );
      case settingsRoute:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );
      case achievements:
        return MaterialPageRoute(
          builder: (_) => const AchievementsScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
