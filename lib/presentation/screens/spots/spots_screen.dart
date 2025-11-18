import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:big_boss_fishing/core/theme/app_colors.dart';
import 'package:big_boss_fishing/core/theme/text_styles.dart';
import 'package:big_boss_fishing/core/utils/date_formatter.dart';
import 'package:big_boss_fishing/providers/spot_provider.dart';
import 'package:big_boss_fishing/providers/catch_provider.dart';
import 'package:big_boss_fishing/data/models/spot_model.dart';
import 'package:big_boss_fishing/presentation/widgets/empty_state.dart';
import 'package:big_boss_fishing/presentation/widgets/app_bottom_nav.dart';
import 'package:big_boss_fishing/presentation/widgets/screen_background.dart';
import 'package:big_boss_fishing/app/routes.dart';

/// Spots Screen - Grid view of saved fishing spots
class SpotsScreen extends StatefulWidget {
  const SpotsScreen({super.key});

  @override
  State<SpotsScreen> createState() => _SpotsScreenState();
}

class _SpotsScreenState extends State<SpotsScreen> {
  String _searchQuery = '';
  String _filterWaterType = 'All';

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
                child: _buildSpotsList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 3,
        onTap: (index) {
          if (index != 3) {
            // Navigate to other tabs
            final routes = [
              AppRoutes.home,
              AppRoutes.catchLog,
              AppRoutes.home, // Center button
              AppRoutes.spots,
              AppRoutes.stats,
            ];
            Navigator.of(context).pushReplacementNamed(routes[index]);
          }
        },
      ),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
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
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fishing Spots',
                  style: AppTextStyles.headline2.copyWith(
                    color: AppColors.deepNavy,
                  ),
                ),
                const SizedBox(height: 4),
                Consumer<SpotProvider>(
                  builder: (context, provider, _) {
                    return Text(
                      '${provider.spots.length} spots saved',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.deepNavy.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.map_rounded,
              color: AppColors.deepNavy,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    final waterTypes = ['All', 'Lake', 'River', 'Ocean', 'Pond', 'Stream'];
    
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
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fishing Spots',
                        style: AppTextStyles.headline2.copyWith(
                          color: AppColors.deepNavy,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Consumer<SpotProvider>(
                        builder: (context, provider, _) {
                          return Text(
                            '${provider.spots.length} spots saved',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.deepNavy.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.map_rounded,
                    color: AppColors.deepNavy,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search spots...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textSecondary,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          
          // Filter Chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              itemCount: waterTypes.length,
              itemBuilder: (context, index) {
                final type = waterTypes[index];
                final isSelected = _filterWaterType == type;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _filterWaterType = type;
                      });
                    },
                    labelStyle: AppTextStyles.buttonSmall.copyWith(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                    backgroundColor: Colors.grey[200],
                    selectedColor: AppColors.deepNavy,
                    checkmarkColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpotsList() {
    return Consumer2<SpotProvider, CatchProvider>(
      builder: (context, spotProvider, catchProvider, _) {
        final spots = _getFilteredSpots(spotProvider.spots);

        if (spots.isEmpty) {
          if (_searchQuery.isNotEmpty) {
            return NoSearchResults(
              searchQuery: _searchQuery,
            );
          }
          return EmptyStateWidget.noSpots(
            onAddSpot: () {
              Navigator.of(context).pushNamed(AppRoutes.addSpot);
            },
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemCount: spots.length,
          itemBuilder: (context, index) {
            final spot = spots[index];
            final catchesAtSpot = catchProvider.catches
                .where((c) => c.location == spot.name)
                .length;

            return FadeInUp(
              duration: const Duration(milliseconds: 400),
              delay: Duration(milliseconds: index * 50),
              child: _SpotCard(
                spot: spot,
                catchCount: catchesAtSpot,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.spotDetail,
                    arguments: spot,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  List<SpotModel> _getFilteredSpots(List<SpotModel> spots) {
    return spots.where((spot) {
      // Filter by water type
      if (_filterWaterType != 'All' && spot.waterType != _filterWaterType) {
        return false;
      }

      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return spot.name.toLowerCase().contains(query) ||
            spot.waterType.toLowerCase().contains(query) ||
            spot.depthNotes.toLowerCase().contains(query) ||
            spot.accessNotes.toLowerCase().contains(query);
      }

      return true;
    }).toList();
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pushNamed(AppRoutes.addSpot);
      },
      backgroundColor: AppColors.deepNavy,
      elevation: 8,
      child: const Icon(
        Icons.add_location_rounded,
        color: AppColors.deepNavy,
        size: 32,
      ),
    );
  }
}

class _SpotCard extends StatelessWidget {
  final SpotModel spot;
  final int catchCount;
  final VoidCallback onTap;

  const _SpotCard({
    required this.spot,
    required this.catchCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image or gradient
              if (spot.photoPath != null)
                Image.asset(
                  spot.photoPath!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildGradientBackground();
                  },
                )
              else
                _buildGradientBackground(),

              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Water type badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getWaterTypeColor().withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        spot.waterType.toUpperCase(),
                        style: AppTextStyles.overline.copyWith(
                          color: AppColors.textLight,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Spot name
                    Text(
                      spot.name,
                      style: AppTextStyles.cardTitle.copyWith(
                        color: AppColors.textLight,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Catch count
                    Row(
                      children: [
                        Icon(
                          Icons.emoji_nature_rounded,
                          size: 16,
                          color: AppColors.deepNavy,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$catchCount ${catchCount == 1 ? 'catch' : 'catches'}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textLight.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Last visited
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color: AppColors.textLight.withOpacity(0.7),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Added ${DateFormatter.formatRelative(spot.createdAt)}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textLight.withOpacity(0.7),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getWaterTypeColor(),
            _getWaterTypeColor().withOpacity(0.6),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          _getWaterTypeIcon(),
          size: 60,
          color: AppColors.textLight.withOpacity(0.3),
        ),
      ),
    );
  }

  Color _getWaterTypeColor() {
    switch (spot.waterType.toLowerCase()) {
      case 'lake':
        return const Color(0xFF2196F3);
      case 'river':
        return const Color(0xFF00BCD4);
      case 'ocean':
        return const Color(0xFF0D47A1);
      case 'pond':
        return const Color(0xFF4CAF50);
      case 'stream':
        return const Color(0xFF03A9F4);
      default:
        return AppColors.deepNavy;
    }
  }

  IconData _getWaterTypeIcon() {
    switch (spot.waterType.toLowerCase()) {
      case 'lake':
        return Icons.water_rounded;
      case 'river':
        return Icons.waves_rounded;
      case 'ocean':
        return Icons.sailing_rounded;
      case 'pond':
        return Icons.water_drop_rounded;
      case 'stream':
        return Icons.water_rounded;
      default:
        return Icons.location_on_rounded;
    }
  }
}
