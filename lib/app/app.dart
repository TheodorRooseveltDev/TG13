import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:big_boss_fishing/core/theme/app_theme.dart';
import 'package:big_boss_fishing/providers/catch_provider.dart';
import 'package:big_boss_fishing/providers/spot_provider.dart';
import 'package:big_boss_fishing/providers/trip_provider.dart';
import 'package:big_boss_fishing/providers/gear_provider.dart';
import 'package:big_boss_fishing/providers/achievement_provider.dart';
import 'package:big_boss_fishing/providers/app_state_provider.dart';
import 'package:big_boss_fishing/app/routes.dart';

/// Main Big Boss Fishing App
class BigBossFishingApp extends StatelessWidget {
  const BigBossFishingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()..loadAppState()),
        ChangeNotifierProvider(create: (_) => CatchProvider()..loadCatches()),
        ChangeNotifierProvider(create: (_) => SpotProvider()..loadSpots()),
        ChangeNotifierProvider(create: (_) => TripProvider()..loadTrips()),
        ChangeNotifierProvider(create: (_) => GearProvider()..loadGear()),
        ChangeNotifierProvider(create: (_) => AchievementProvider()..loadAchievements()),
      ],
      child: MaterialApp(
        title: 'Big Boss Fishing',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
