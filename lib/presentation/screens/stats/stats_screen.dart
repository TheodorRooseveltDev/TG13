import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:big_boss_fishing/core/theme/app_colors.dart';
import 'package:big_boss_fishing/core/theme/text_styles.dart';
import 'package:big_boss_fishing/core/utils/date_formatter.dart';
import 'package:big_boss_fishing/core/utils/size_calculator.dart';
import 'package:big_boss_fishing/providers/catch_provider.dart';
import 'package:big_boss_fishing/providers/spot_provider.dart';
import 'package:big_boss_fishing/providers/app_state_provider.dart';
import 'package:big_boss_fishing/data/models/catch_model.dart';
import 'package:big_boss_fishing/presentation/widgets/app_bottom_nav.dart';
import 'package:big_boss_fishing/presentation/widgets/screen_background.dart';
import 'package:big_boss_fishing/app/routes.dart';

/// Stats Screen - Comprehensive fishing statistics and analytics
class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  String _selectedTimeframe = '30 Days';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: ScreenBackground(
        child: Column(
          children: [
            _buildHeaderSection(),
            Expanded(
              child: SafeArea(
                top: false,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildOverviewCards(),
                  const SizedBox(height: 20),
                  _buildCatchTrendChart(),
                  const SizedBox(height: 20),
                  _buildSpeciesBreakdownChart(),
                  const SizedBox(height: 20),
                  _buildBestTimeChart(),
                  const SizedBox(height: 20),
                  _buildTopSpotsSection(),
                  const SizedBox(height: 20),
                  _buildBiggestCatchesSection(),
                  const SizedBox(height: 20),
                    _buildPersonalRecordsSection(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 4,
        onTap: (index) {
          if (index != 4) {
            final routes = [
              AppRoutes.home,     // 0 - Home
              AppRoutes.gear,     // 1 - Gear
              AppRoutes.addCatch, // 2 - Center button (Add Catch)
              AppRoutes.planner,  // 3 - Trips
              AppRoutes.stats,    // 4 - Stats (current)
            ];
            if (index == 2) {
              Navigator.of(context).pushNamed(routes[index]);
            } else {
              Navigator.of(context).pushReplacementNamed(routes[index]);
            }
          }
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Consumer<CatchProvider>(
            builder: (context, catchProvider, child) {
              final totalCatches = catchProvider.catches.length;
              final last30Days = catchProvider.catches
                  .where((c) => c.dateTime.isAfter(
                      DateTime.now().subtract(const Duration(days: 30))))
                  .length;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Statistics',
                    style: AppTextStyles.headline2.copyWith(color: AppColors.deepNavy),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$totalCatches total catches • $last30Days this month',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              );
            },
          ),
          // Stats icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.deepNavy.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.bar_chart_rounded,
              color: AppColors.deepNavy,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    final timeframes = ['7 Days', '30 Days', '90 Days', 'All Time'];
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top padding for status bar
          SizedBox(height: MediaQuery.of(context).padding.top),
          
          // Title and Stats
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer<CatchProvider>(
                  builder: (context, catchProvider, child) {
                    final totalCatches = catchProvider.catches.length;
                    final last30Days = catchProvider.catches
                        .where((c) => c.dateTime.isAfter(
                            DateTime.now().subtract(const Duration(days: 30))))
                        .length;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Statistics',
                          style: AppTextStyles.headline2.copyWith(color: AppColors.deepNavy),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$totalCatches total catches • $last30Days this month',
                          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    );
                  },
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.deepNavy.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.bar_chart_rounded,
                    color: AppColors.deepNavy,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          
          // Timeframe Selector
          Container(
            height: 50,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: timeframes.length,
              itemBuilder: (context, index) {
                final timeframe = timeframes[index];
                final isSelected = _selectedTimeframe == timeframe;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(timeframe),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedTimeframe = timeframe;
                      });
                    },
                    labelStyle: AppTextStyles.buttonSmall.copyWith(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                    backgroundColor: Colors.grey[200],
                    selectedColor: AppColors.deepNavy,
                    checkmarkColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    side: BorderSide.none,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCards() {
    return Consumer3<CatchProvider, SpotProvider, AppStateProvider>(
      builder: (context, catchProvider, spotProvider, appStateProvider, _) {
        final catches = _getFilteredCatches(catchProvider.catches);
        final totalCatches = catches.length;
        final totalWeight = catches.fold<double>(0, (sum, c) => sum + c.weight);
        final avgWeight = totalCatches > 0 ? (totalWeight / totalCatches).toDouble() : 0.0;
        final unitsSystem = appStateProvider.unitsSystem;

        return FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.emoji_nature_rounded,
                      label: 'Total Catches',
                      value: totalCatches.toString(),
                      color: AppColors.deepNavy,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.scale_rounded,
                      label: 'Total Weight',
                      value: SizeCalculator.formatWeight(totalWeight, unitsSystem),
                      color: AppColors.accentOrange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.trending_up_rounded,
                      label: 'Avg Weight',
                      value: SizeCalculator.formatWeight(avgWeight, unitsSystem),
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.location_on_rounded,
                      label: 'Spots Visited',
                      value: spotProvider.spots.length.toString(),
                      color: AppColors.deepNavy,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCatchTrendChart() {
    return Consumer<CatchProvider>(
      builder: (context, catchProvider, _) {
        final catches = _getFilteredCatches(catchProvider.catches);

        if (catches.isEmpty) {
          return const SizedBox.shrink();
        }

        return FadeInUp(
          delay: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 600),
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
                      Icons.show_chart_rounded,
                      color: AppColors.deepNavy,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'CATCH TREND',
                      style: AppTextStyles.cardTitle,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 200,
                  child: _buildLineChart(catches),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLineChart(List<CatchModel> catches) {
    if (catches.isEmpty) return const SizedBox();

    // Group catches by day
    final Map<String, int> catchesByDay = {};
    for (var catch_ in catches) {
      final day = DateFormatter.formatDate(catch_.dateTime);
      catchesByDay[day] = (catchesByDay[day] ?? 0) + 1;
    }

    // Get last 7 days
    final now = DateTime.now();
    final spots = <FlSpot>[];
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final day = DateFormatter.formatDate(date);
      final count = catchesByDay[day] ?? 0;
      spots.add(FlSpot(6 - i.toDouble(), count.toDouble()));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.borderSecondary.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final date = now.subtract(Duration(days: 6 - value.toInt()));
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${date.day}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: (spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 1),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: AppColors.aquaGradient,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.deepNavy,
                  strokeWidth: 2,
                  strokeColor: AppColors.textLight,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppColors.deepNavy.withOpacity(0.3),
                  AppColors.deepNavy.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeciesBreakdownChart() {
    return Consumer<CatchProvider>(
      builder: (context, catchProvider, _) {
        final catches = _getFilteredCatches(catchProvider.catches);

        if (catches.isEmpty) {
          return const SizedBox.shrink();
        }

        // Count catches by species
        final Map<String, int> speciesCount = {};
        for (var catch_ in catches) {
          speciesCount[catch_.species] = (speciesCount[catch_.species] ?? 0) + 1;
        }

        final sortedSpecies = speciesCount.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        return FadeInUp(
          delay: const Duration(milliseconds: 400),
          duration: const Duration(milliseconds: 600),
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
                      Icons.pie_chart_rounded,
                      color: AppColors.accentOrange,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'SPECIES BREAKDOWN',
                      style: AppTextStyles.cardTitle,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ...sortedSpecies.take(5).map((entry) {
                  final percentage = (entry.value / catches.length * 100).toStringAsFixed(1);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _SpeciesBar(
                      species: entry.key,
                      count: entry.value,
                      percentage: double.parse(percentage),
                      total: catches.length,
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBestTimeChart() {
    return Consumer<CatchProvider>(
      builder: (context, catchProvider, _) {
        final catches = _getFilteredCatches(catchProvider.catches);

        if (catches.isEmpty) {
          return const SizedBox.shrink();
        }

        // Count catches by time of day
        final Map<String, int> timeCount = {
          'Dawn': 0,
          'Morning': 0,
          'Afternoon': 0,
          'Evening': 0,
          'Night': 0,
        };

        for (var catch_ in catches) {
          final timeCategory = DateFormatter.timeOfDayCategory(catch_.dateTime);
          timeCount[timeCategory] = (timeCount[timeCategory] ?? 0) + 1;
        }

        return FadeInUp(
          delay: const Duration(milliseconds: 600),
          duration: const Duration(milliseconds: 600),
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
                      Icons.access_time_rounded,
                      color: AppColors.deepNavy,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'BEST FISHING TIMES',
                      style: AppTextStyles.cardTitle,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 200,
                  child: _buildBarChart(timeCount),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBarChart(Map<String, int> data) {
    final maxValue = data.values.reduce((a, b) => a > b ? a : b).toDouble();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxValue + 1,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final labels = ['Dawn', 'Morn', 'Aft', 'Eve', 'Night'];
                if (value.toInt() >= 0 && value.toInt() < labels.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      labels[value.toInt()],
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.borderSecondary.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
        ),
        barGroups: data.entries.toList().asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.value.toDouble(),
                gradient: AppColors.aquaGradient,
                width: 24,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTopSpotsSection() {
    return Consumer2<CatchProvider, SpotProvider>(
      builder: (context, catchProvider, spotProvider, _) {
        final catches = _getFilteredCatches(catchProvider.catches);

        if (catches.isEmpty) {
          return const SizedBox.shrink();
        }

        // Count catches by location
        final Map<String, int> locationCount = {};
        for (var catch_ in catches) {
          locationCount[catch_.location] = (locationCount[catch_.location] ?? 0) + 1;
        }

        final topSpots = locationCount.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        return FadeInUp(
          delay: const Duration(milliseconds: 800),
          duration: const Duration(milliseconds: 600),
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
                      Icons.location_on_rounded,
                      color: AppColors.accentOrange,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'TOP FISHING SPOTS',
                      style: AppTextStyles.cardTitle,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...topSpots.take(5).toList().asMap().entries.map((entry) {
                  final rank = entry.key + 1;
                  final spotEntry = entry.value;
                  return _TopSpotItem(
                    rank: rank,
                    location: spotEntry.key,
                    catchCount: spotEntry.value,
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBiggestCatchesSection() {
    return Consumer<CatchProvider>(
      builder: (context, catchProvider, _) {
        final catches = _getFilteredCatches(catchProvider.catches);

        if (catches.isEmpty) {
          return const SizedBox.shrink();
        }

        final sortedByWeight = catches.toList()
          ..sort((a, b) => b.weight.compareTo(a.weight));

        return FadeInUp(
          delay: const Duration(milliseconds: 1000),
          duration: const Duration(milliseconds: 600),
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
                      color: AppColors.accentOrange,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'BIGGEST CATCHES',
                      style: AppTextStyles.cardTitle,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...sortedByWeight.take(3).toList().asMap().entries.map((entry) {
                  return _BiggestCatchItem(
                    rank: entry.key + 1,
                    catchModel: entry.value,
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPersonalRecordsSection() {
    return Consumer2<CatchProvider, AppStateProvider>(
      builder: (context, catchProvider, appStateProvider, _) {
        final unitsSystem = appStateProvider.unitsSystem;
        final catches = catchProvider.catches;

        if (catches.isEmpty) {
          return const SizedBox.shrink();
        }

        final heaviest = catches.reduce((a, b) => a.weight > b.weight ? a : b);
        final longest = catches.reduce((a, b) => a.length > b.length ? a : b);
        final bestRated = catches.reduce((a, b) => a.rating > b.rating ? a : b);

        return FadeInUp(
          delay: const Duration(milliseconds: 1200),
          duration: const Duration(milliseconds: 600),
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
                      Icons.stars_rounded,
                      color: AppColors.deepNavy,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'PERSONAL RECORDS',
                      style: AppTextStyles.cardTitle,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _RecordItem(
                  icon: Icons.scale_rounded,
                  label: 'Heaviest',
                  species: heaviest.species,
                  value: SizeCalculator.formatWeight(heaviest.weight, unitsSystem),
                ),
                const SizedBox(height: 12),
                _RecordItem(
                  icon: Icons.straighten_rounded,
                  label: 'Longest',
                  species: longest.species,
                  value: SizeCalculator.formatLength(longest.length, unitsSystem),
                ),
                const SizedBox(height: 12),
                _RecordItem(
                  icon: Icons.star_rounded,
                  label: 'Best Rated',
                  species: bestRated.species,
                  value: '${bestRated.rating}/5 ⭐',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<CatchModel> _getFilteredCatches(List<CatchModel> catches) {
    final now = DateTime.now();
    DateTime cutoffDate;

    switch (_selectedTimeframe) {
      case '7 Days':
        cutoffDate = now.subtract(const Duration(days: 7));
        break;
      case '30 Days':
        cutoffDate = now.subtract(const Duration(days: 30));
        break;
      case '90 Days':
        cutoffDate = now.subtract(const Duration(days: 90));
        break;
      case 'All Time':
        return catches;
      default:
        cutoffDate = now.subtract(const Duration(days: 30));
    }

    return catches.where((c) => c.dateTime.isAfter(cutoffDate)).toList();
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.heading5.copyWith(
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SpeciesBar extends StatelessWidget {
  final String species;
  final int count;
  final double percentage;
  final int total;

  const _SpeciesBar({
    required this.species,
    required this.count,
    required this.percentage,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              species,
              style: AppTextStyles.bodyBold,
            ),
            Text(
              '$count catches ($percentage%)',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 8,
            backgroundColor: AppColors.backgroundLight,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.deepNavy),
          ),
        ),
      ],
    );
  }
}

class _TopSpotItem extends StatelessWidget {
  final int rank;
  final String location;
  final int catchCount;

  const _TopSpotItem({
    required this.rank,
    required this.location,
    required this.catchCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: rank <= 3 ? AppColors.accentOrange : AppColors.cardBackground,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: AppTextStyles.bodyBold.copyWith(
                  color: rank <= 3 ? AppColors.textLight : AppColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              location,
              style: AppTextStyles.bodyBold,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.deepNavy.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$catchCount',
              style: AppTextStyles.bodyBold.copyWith(
                color: AppColors.deepNavy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BiggestCatchItem extends StatelessWidget {
  final int rank;
  final CatchModel catchModel;

  const _BiggestCatchItem({
    required this.rank,
    required this.catchModel,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appStateProvider, child) {
        final unitsSystem = appStateProvider.unitsSystem;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                rank == 1 ? Icons.emoji_events_rounded : Icons.military_tech_rounded,
                color: rank == 1 ? AppColors.accentOrange : AppColors.deepNavy,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      catchModel.species,
                      style: AppTextStyles.bodyBold,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormatter.smartDate(catchModel.dateTime),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    SizeCalculator.formatWeight(catchModel.weight, unitsSystem),
                    style: AppTextStyles.bodyBold.copyWith(
                      color: AppColors.accentOrange,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    SizeCalculator.formatLength(catchModel.length, unitsSystem),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RecordItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String species;
  final String value;

  const _RecordItem({
    required this.icon,
    required this.label,
    required this.species,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.deepNavy,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  species,
                  style: AppTextStyles.bodyBold,
                ),
              ],
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyBold.copyWith(
              color: AppColors.accentOrange,
            ),
          ),
        ],
      ),
    );
  }
}
