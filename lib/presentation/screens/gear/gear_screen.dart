import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../providers/gear_provider.dart';
import '../../../data/models/gear_model.dart';
import '../../../app/routes.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/screen_background.dart';
import 'package:animate_do/animate_do.dart';

class GearScreen extends StatefulWidget {
  const GearScreen({super.key});

  @override
  State<GearScreen> createState() => _GearScreenState();
}

class _GearScreenState extends State<GearScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  final List<String> _categories = [
    'All',
    'Rod',
    'Reel',
    'Lure',
    'Line',
    'Tackle',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<GearModel> _filterGear(List<GearModel> allGear, String category) {
    List<GearModel> filtered = allGear;

    // Filter by category
    if (category != 'All') {
      filtered = filtered.where((g) => g.category == category).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((g) {
        return g.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            g.brand.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            g.condition.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Sort: used items first, then by name
    filtered.sort((a, b) {
      if (a.usedOnLastCatch != b.usedOnLastCatch) {
        return a.usedOnLastCatch ? -1 : 1;
      }
      return a.name.compareTo(b.name);
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: ScreenBackground(
        child: Column(
          children: [
            // Combined Header Section (extends to top)
            _buildHeaderSection(),

            // Gear List
            Expanded(
              child: SafeArea(
                top: false,
                child: Consumer<GearProvider>(
                  builder: (context, gearProvider, child) {
                    final currentCategory = _categories[_tabController.index];
                    final filteredGear = _filterGear(gearProvider.gear, currentCategory);

                    if (gearProvider.gear.isEmpty) {
                      return EmptyStateWidget(
                        imagePath: 'assets/empty-states/no-catches.png', // Reuse
                        title: 'No Gear Yet',
                        message: 'Start building your tackle box!\nAdd your rods, reels, and favorite lures.',
                        buttonText: 'Add First Gear',
                        onButtonPressed: () {
                          Navigator.pushNamed(context, '/add-gear');
                        },
                      );
                    }

                    if (filteredGear.isEmpty) {
                      return NoSearchResults(
                        searchQuery: _searchQuery,
                      );
                    }

                    return _buildGearList(filteredGear);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-gear');
        },
        backgroundColor: AppColors.deepNavy,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 1, // Gear is the second tab (index 1)
        onTap: (index) {
          if (index != 1) {
            final routes = [
              AppRoutes.home,     // 0 - Home
              AppRoutes.gear,     // 1 - Gear (current)
              AppRoutes.addCatch, // 2 - Center button (Add Catch)
              AppRoutes.planner,  // 3 - Trips
              AppRoutes.stats,    // 4 - Stats
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

  Widget _buildHeaderSection() {
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Gear',
                      style: AppTextStyles.headline2.copyWith(color: AppColors.deepNavy),
                    ),
                    const SizedBox(height: 4),
                    Consumer<GearProvider>(
                      builder: (context, gearProvider, child) {
                        final totalGear = gearProvider.gear.length;
                        final used = gearProvider.gear.where((g) => g.usedOnLastCatch).length;
                        return Text(
                          '$totalGear items • $used recently used',
                          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                        );
                      },
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.deepNavy.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.inventory_2_outlined,
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
                hintText: 'Search gear...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
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
          
          // Category Tabs
          SizedBox(
            height: 50,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: AppColors.deepNavy,
              indicatorWeight: 3,
              labelColor: AppColors.deepNavy,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: AppTextStyles.button.copyWith(fontSize: 14),
              unselectedLabelStyle: AppTextStyles.bodyMedium.copyWith(fontSize: 14),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              tabs: _categories.map((category) {
                return Tab(
                  child: Consumer<GearProvider>(
                    builder: (context, gearProvider, child) {
                      final count = category == 'All'
                          ? gearProvider.gear.length
                          : gearProvider.gear.where((g) => g.category == category).length;
                      return Text('$category ($count)');
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGearList(List<GearModel> gear) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: gear.length,
      itemBuilder: (context, index) {
        return FadeInUp(
          duration: const Duration(milliseconds: 300),
          delay: Duration(milliseconds: index * 50),
          child: _buildGearCard(gear[index]),
        );
      },
    );
  }

  Widget _buildGearCard(GearModel gear) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/gear-detail',
          arguments: gear,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon/Photo
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _getCategoryColor(gear.category).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _buildCategoryIcon(gear.category),
            ),
            const SizedBox(width: 16),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          gear.name,
                          style: AppTextStyles.headline5.copyWith(color: AppColors.deepNavy),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (gear.usedOnLastCatch)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.deepNavy.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'USED',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.deepNavy,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (gear.brand.isNotEmpty)
                    Text(
                      '${gear.brand} • ${gear.condition}',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildCategoryChip(gear.category),
                      if (gear.price != null && gear.price! > 0) ...[
                        const SizedBox(width: 8),
                        Text(
                          '\$${gear.price!.toStringAsFixed(2)}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.sunsetOrange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Arrow
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(String category) {
    IconData icon;
    switch (category) {
      case 'Rod':
        icon = Icons.straighten;
        break;
      case 'Reel':
        icon = Icons.album;
        break;
      case 'Lure':
        icon = Icons.opacity;
        break;
      case 'Line':
        icon = Icons.linear_scale;
        break;
      case 'Tackle':
        icon = Icons.hardware;
        break;
      default:
        icon = Icons.category;
    }

    return Icon(
      icon,
      color: _getCategoryColor(category),
      size: 30,
    );
  }

  Widget _buildCategoryChip(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getCategoryColor(category).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        category,
        style: AppTextStyles.caption.copyWith(
          color: _getCategoryColor(category),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Rod':
        return const Color(0xFF795548); // Brown
      case 'Reel':
        return const Color(0xFF607D8B); // Blue Grey
      case 'Lure':
        return AppColors.sunsetOrange;
      case 'Line':
        return AppColors.deepNavy;
      case 'Tackle':
        return const Color(0xFF9C27B0); // Purple
      default:
        return AppColors.textSecondary;
    }
  }
}
