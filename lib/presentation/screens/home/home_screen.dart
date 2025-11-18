import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:big_boss_fishing/core/theme/app_colors.dart';
import 'package:big_boss_fishing/core/theme/text_styles.dart';
import 'package:big_boss_fishing/core/utils/date_formatter.dart';
import 'package:big_boss_fishing/core/utils/size_calculator.dart';
import 'package:big_boss_fishing/providers/app_state_provider.dart';
import 'package:big_boss_fishing/providers/catch_provider.dart';
import 'package:big_boss_fishing/providers/trip_provider.dart';
import 'package:big_boss_fishing/providers/achievement_provider.dart';
import 'package:big_boss_fishing/presentation/widgets/app_bottom_nav.dart';
import 'package:big_boss_fishing/presentation/widgets/xp_bar.dart';
import 'package:big_boss_fishing/presentation/widgets/screen_background.dart';
import 'package:big_boss_fishing/app/routes.dart';

/// Home Screen - Main dashboard with 2x2 grid
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;

  void _onNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });

    // Navigate based on tab
    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed(AppRoutes.gear);
        break;
      case 2:
        Navigator.of(context).pushNamed(AppRoutes.addCatch);
        break;
      case 3:
        Navigator.of(context).pushReplacementNamed(AppRoutes.planner);
        break;
      case 4:
        Navigator.of(context).pushReplacementNamed(AppRoutes.stats);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: ScreenBackground(
        child: Stack(
          children: [
          // Content with padding for header
          Column(
            children: [
              // Spacer for header
              SizedBox(height: MediaQuery.of(context).padding.top + 150),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // XP Bar
                      FadeInDown(
                        duration: const Duration(milliseconds: 600),
                        child: const XPBar(showRank: true),
                      ),

                      const SizedBox(height: 24),

                      // Dashboard Grid
                      _buildDashboardGrid(context),

                      const SizedBox(height: 24),

                      // Achievement Progress
                      FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        child: const _AchievementProgressCard(),
                      ),

                      const SizedBox(height: 16),

                      // Recent Achievements
                      FadeInUp(
                        delay: const Duration(milliseconds: 100),
                        duration: const Duration(milliseconds: 600),
                        child: const _RecentAchievementsCard(),
                      ),

                      const SizedBox(height: 16),

                      // This Week Stats
                      FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        duration: const Duration(milliseconds: 600),
                        child: const _ThisWeekStatsCard(),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Header on top
          _buildHeader(context),
        ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    
    return ClipPath(
      clipper: HeaderClipper(),
      child: Container(
        padding: EdgeInsets.only(
          top: topPadding + 20,
          left: 20,
          right: 20,
          bottom: 40,
        ),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FadeInLeft(
                  duration: const Duration(milliseconds: 600),
                  child: Text(
                    'BIG BOSS',
                    style: AppTextStyles.headline3.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
              FadeInLeft(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 600),
                child: Text(
                  DateFormatter.getGreeting(),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textLight.withOpacity(0.9),
                  ),
                ),
              ),
            ],
          ),
          FadeInRight(
            duration: const Duration(milliseconds: 600),
            child: IconButton(
              icon: Image.asset(
                'assets/action-icons/settings.png',
                width: 28,
                height: 28,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.settingsRoute);
              },
            ),
          ),
        ],
      ),
      )
    );
  }

  Widget _buildDashboardGrid(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: FadeInLeft(
                duration: const Duration(milliseconds: 600),
                child: const _LastCatchCard(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FadeInRight(
                duration: const Duration(milliseconds: 600),
                child: const _UpcomingTripsCard(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: FadeInLeft(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 600),
                child: const _WeatherCard(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FadeInRight(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 600),
                child: const _BossStatsCard(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Last Catch Card - Shows most recent catch
class _LastCatchCard extends StatelessWidget {
  const _LastCatchCard();

  @override
  Widget build(BuildContext context) {
    return Consumer2<CatchProvider, AppStateProvider>(
      builder: (context, catchProvider, appStateProvider, child) {
        final catches = catchProvider.catches;
        final lastCatch = catches.isNotEmpty ? catches.first : null;
        final unitsSystem = appStateProvider.unitsSystem;

        return GestureDetector(
          onTap: () {
            if (lastCatch != null) {
              Navigator.of(context).pushNamed(
                AppRoutes.catchLog,
                arguments: lastCatch,
              );
            } else {
              Navigator.of(context).pushNamed(AppRoutes.addCatch);
            }
          },
          child: Container(
            height: 180,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.cardGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: lastCatch != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.emoji_nature_rounded,
                            color: AppColors.deepNavy,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'LAST CATCH',
                            style: AppTextStyles.overline.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        lastCatch.species,
                        style: AppTextStyles.cardTitle.copyWith(
                          fontSize: 20,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        SizeCalculator.formatWeight(lastCatch.weight, unitsSystem),
                        style: AppTextStyles.statsMedium.copyWith(
                          fontSize: 24,
                          color: AppColors.deepNavy,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        DateFormatter.formatRelative(lastCatch.dateTime),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/empty-states/no-catches.png',
                          width: 80,
                          height: 80,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'LOG CATCH',
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}

/// Upcoming Trips Card - Shows next planned trip
class _UpcomingTripsCard extends StatelessWidget {
  const _UpcomingTripsCard();

  @override
  Widget build(BuildContext context) {
    return Consumer<TripProvider>(
      builder: (context, tripProvider, child) {
        final upcomingTrips = tripProvider.upcomingTrips;
        final nextTrip = upcomingTrips.isNotEmpty ? upcomingTrips.first : null;

        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.planner);
          },
          child: Container(
            height: 180,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.cardGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: nextTrip != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            color: AppColors.accentOrange,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'NEXT TRIP',
                            style: AppTextStyles.overline.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        nextTrip.destination,
                        style: AppTextStyles.cardTitle.copyWith(
                          fontSize: 18,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: AppColors.textSecondary,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormatter.formatDate(nextTrip.dateTime),
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_available_rounded,
                          color: AppColors.textSecondary,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'PLAN TRIP',
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}

/// Weather Card - Shows current conditions (mock data for now)
class _WeatherCard extends StatelessWidget {
  const _WeatherCard();

  @override
  Widget build(BuildContext context) {
    // Mock weather data - in production, would connect to weather service
    final temp = 72;
    final condition = 'Sunny';
    final iconPath = 'assets/weather/sunny.png';

    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.wb_sunny_rounded,
                color: AppColors.sunny,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                'WEATHER',
                style: AppTextStyles.overline.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$temp°F',
                      style: AppTextStyles.statsMedium.copyWith(
                        fontSize: 36,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      condition,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                iconPath,
                width: 60,
                height: 60,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.wb_sunny_rounded,
                    size: 60,
                    color: AppColors.sunny,
                  );
                },
              ),
            ],
          ),
          const Spacer(),
          Text(
            'GOOD FISHING',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Boss Stats Card - Shows key statistics
class _BossStatsCard extends StatelessWidget {
  const _BossStatsCard();

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppStateProvider, CatchProvider>(
      builder: (context, appState, catchProvider, child) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.stats);
          },
          child: Container(
            height: 180,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.deepNavy,
                  AppColors.deepNavy.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.deepNavy.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: AppColors.textLight,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'YOUR STATS',
                      style: AppTextStyles.overline.copyWith(
                        color: AppColors.textLight.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _StatRow(
                  label: 'Total Catches',
                  value: '${appState.totalCatches}',
                ),
                const SizedBox(height: 8),
                _StatRow(
                  label: 'Catch Streak',
                  value: '${appState.catchStreak} days',
                ),
                const SizedBox(height: 8),
                _StatRow(
                  label: 'Total XP',
                  value: SizeCalculator.formatNumber(appState.userXP),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textLight.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyBoldMedium.copyWith(
            color: AppColors.textLight,
          ),
        ),
      ],
    );
  }
}

/// Achievement Progress Card - Shows overall completion
class _AchievementProgressCard extends StatelessWidget {
  const _AchievementProgressCard();

  @override
  Widget build(BuildContext context) {
    return Consumer<AchievementProvider>(
      builder: (context, achievementProvider, child) {
        final total = achievementProvider.totalAchievements;
        final unlocked = achievementProvider.totalUnlocked;
        final percentage = achievementProvider.completionPercentage;

        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.achievements);
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.cardGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.emoji_events_rounded,
                      color: AppColors.deepNavy,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'ACHIEVEMENTS',
                      style: AppTextStyles.overline.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$unlocked/$total',
                      style: AppTextStyles.bodyBold.copyWith(
                        color: AppColors.deepNavy,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: total > 0 ? unlocked / total : 0,
                    minHeight: 12,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.deepNavy),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${percentage.toStringAsFixed(0)}% Complete',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Recent Achievements Card - Shows 2-3 most recent unlocks
class _RecentAchievementsCard extends StatelessWidget {
  const _RecentAchievementsCard();

  @override
  Widget build(BuildContext context) {
    return Consumer<AchievementProvider>(
      builder: (context, achievementProvider, child) {
        final recentUnlocked = achievementProvider.unlockedAchievements
            .where((a) => a.unlockedAt != null)
            .toList()
          ..sort((a, b) => b.unlockedAt!.compareTo(a.unlockedAt!));
        
        final displayAchievements = recentUnlocked.take(3).toList();

        if (displayAchievements.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppColors.cardGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.stars_rounded,
                    color: AppColors.deepNavy,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'RECENT ACHIEVEMENTS',
                    style: AppTextStyles.overline.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...displayAchievements.map((achievement) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.deepNavy.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: achievement.badgeImage.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                achievement.badgeImage,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              Icons.emoji_events,
                              color: AppColors.deepNavy,
                              size: 24,
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            achievement.name,
                            style: AppTextStyles.bodyBold.copyWith(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            DateFormatter.formatRelative(achievement.unlockedAt!),
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '+${achievement.xpReward} XP',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.deepNavy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        );
      },
    );
  }
}

/// This Week Stats Card - Shows weekly progress
class _ThisWeekStatsCard extends StatelessWidget {
  const _ThisWeekStatsCard();

  @override
  Widget build(BuildContext context) {
    return Consumer2<CatchProvider, AppStateProvider>(
      builder: (context, catchProvider, appStateProvider, child) {
        final now = DateTime.now();
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final startOfLastWeek = startOfWeek.subtract(const Duration(days: 7));
        final unitsSystem = appStateProvider.unitsSystem;
        
        // This week
        final thisWeekCatches = catchProvider.catches.where((c) {
          return c.dateTime.isAfter(startOfWeek);
        }).toList();
        
        // Last week
        final lastWeekCatches = catchProvider.catches.where((c) {
          return c.dateTime.isAfter(startOfLastWeek) && 
                 c.dateTime.isBefore(startOfWeek);
        }).toList();
        
        final thisWeekCount = thisWeekCatches.length;
        final lastWeekCount = lastWeekCatches.length;
        final thisWeekWeight = thisWeekCatches.fold<double>(
          0, (sum, c) => sum + c.weight
        );
        
        final difference = thisWeekCount - lastWeekCount;
        final isUp = difference > 0;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppColors.cardGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    color: AppColors.deepNavy,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'THIS WEEK',
                    style: AppTextStyles.overline.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Catches',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$thisWeekCount',
                              style: AppTextStyles.statsMedium.copyWith(
                                fontSize: 28,
                                color: AppColors.deepNavy,
                              ),
                            ),
                            if (difference != 0) ...[
                              const SizedBox(width: 8),
                              Icon(
                                isUp ? Icons.arrow_upward : Icons.arrow_downward,
                                color: isUp ? Colors.green : Colors.red,
                                size: 16,
                              ),
                              Text(
                                '${difference.abs()}',
                                style: AppTextStyles.caption.copyWith(
                                  color: isUp ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: AppColors.textSecondary.withOpacity(0.2),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Weight',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          SizeCalculator.formatWeight(thisWeekWeight, unitsSystem),
                          style: AppTextStyles.statsMedium.copyWith(
                            fontSize: 28,
                            color: AppColors.deepNavy,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (lastWeekCount > 0) ...[
                const SizedBox(height: 12),
                Text(
                  'Last week: $lastWeekCount catches',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Custom clipper for curved header
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    
    // Create a smooth curve at the bottom
    path.quadraticBezierTo(
      size.width / 2, // Control point X
      size.height,    // Control point Y
      size.width,     // End point X
      size.height - 30, // End point Y
    );
    
    path.lineTo(size.width, 0);
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
