import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../providers/trip_provider.dart';
import '../../../data/models/trip_model.dart';
import '../../../app/routes.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/screen_background.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  String _selectedFilter = 'All';
  String _searchQuery = '';

  final List<String> _filters = ['All', 'Upcoming', 'Completed', 'Cancelled'];

  List<TripModel> _filterTrips(List<TripModel> allTrips) {
    List<TripModel> filtered = allTrips;

    // Filter by status
    if (_selectedFilter != 'All') {
      if (_selectedFilter == 'Upcoming') {
        filtered = filtered.where((t) => !t.isCompleted && t.dateTime.isAfter(DateTime.now())).toList();
      } else if (_selectedFilter == 'Completed') {
        filtered = filtered.where((t) => t.isCompleted).toList();
      } else if (_selectedFilter == 'Cancelled') {
        // We don't have a cancelled status, so just filter out completed upcoming trips
        filtered = filtered.where((t) => !t.isCompleted && t.dateTime.isBefore(DateTime.now())).toList();
      }
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((t) {
        return t.destination.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            t.notes.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Sort: upcoming first, then by date
    filtered.sort((a, b) {
      if (!a.isCompleted && a.isFuture && (b.isCompleted || !b.isFuture)) return -1;
      if ((a.isCompleted || !a.isFuture) && !b.isCompleted && b.isFuture) return 1;
      return b.dateTime.compareTo(a.dateTime); // Most recent first
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
            // Combined Header Section
            _buildHeaderSection(),

            // Trip List
            Expanded(
              child: SafeArea(
                top: false,
                child: Consumer<TripProvider>(
                  builder: (context, tripProvider, child) {
                    final filteredTrips = _filterTrips(tripProvider.trips);

                  if (tripProvider.trips.isEmpty) {
                    return EmptyStateWidget.noTrips(
                      onAddTrip: () {
                        Navigator.pushNamed(context, '/add-trip');
                      },
                    );
                  }

                  if (filteredTrips.isEmpty) {
                    return NoSearchResults(searchQuery: _searchQuery);
                  }

                    return _buildTripList(filteredTrips);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-trip');
        },
        backgroundColor: AppColors.deepNavy,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 3, // Trips is the fourth tab (index 3)
        onTap: (index) {
          if (index != 3) {
            final routes = [
              AppRoutes.home,     // 0 - Home
              AppRoutes.gear,     // 1 - Gear
              AppRoutes.addCatch, // 2 - Center button (Add Catch)
              AppRoutes.planner,  // 3 - Trips (current)
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Trip Planner',
                style: AppTextStyles.headline2.copyWith(color: AppColors.deepNavy),
              ),
              const SizedBox(height: 4),
              Consumer<TripProvider>(
                builder: (context, tripProvider, child) {
                  final upcoming = tripProvider.trips.where((t) => !t.isCompleted && t.dateTime.isAfter(DateTime.now())).length;
                  return Text(
                    '$upcoming upcoming • ${tripProvider.trips.length} total',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                  );
                },
              ),
            ],
          ),
          // Calendar icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.deepNavy.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.calendar_month,
              color: AppColors.deepNavy,
              size: 24,
            ),
          ),
        ],
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
                      'Trip Planner',
                      style: AppTextStyles.headline2.copyWith(color: AppColors.deepNavy),
                    ),
                    const SizedBox(height: 4),
                    Consumer<TripProvider>(
                      builder: (context, tripProvider, child) {
                        final upcoming = tripProvider.trips.where((t) => !t.isCompleted && t.dateTime.isAfter(DateTime.now())).length;
                        return Text(
                          '$upcoming upcoming • ${tripProvider.trips.length} total',
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
                    Icons.calendar_month,
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
                hintText: 'Search trips...',
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
          
          // Filter Chips
          Container(
            height: 50,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    selectedColor: AppColors.deepNavy,
                    backgroundColor: Colors.grey[200],
                    labelStyle: AppTextStyles.bodyMedium.copyWith(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
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

  Widget _buildTripList(List<TripModel> trips) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        return FadeInUp(
          duration: const Duration(milliseconds: 300),
          delay: Duration(milliseconds: index * 50),
          child: _buildTripCard(trips[index]),
        );
      },
    );
  }

  Widget _buildTripCard(TripModel trip) {
    final bool isUpcoming = !trip.isCompleted && trip.dateTime.isAfter(DateTime.now());
    final bool isPast = trip.dateTime.isBefore(DateTime.now());

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/trip-detail',
          arguments: trip,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isUpcoming
              ? Border.all(color: AppColors.deepNavy, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Date badge
              _buildDateBadge(trip.dateTime, isUpcoming),
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
                            trip.destination,
                            style: AppTextStyles.headline5.copyWith(color: AppColors.deepNavy),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _buildStatusChip(trip.isCompleted, isUpcoming, isPast),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.water, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          trip.waterType,
                          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                        ),
                        if (trip.gearChecklist.isNotEmpty) ...[
                          const SizedBox(width: 12),
                          const Icon(Icons.check_box, size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            '${trip.gearChecklist.length} gear items',
                            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ],
                    ),
                    if (trip.targetSpecies.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.phishing, size: 14, color: AppColors.textPrimary),
                            const SizedBox(width: 4),
                            Text(
                              trip.targetSpecies,
                              style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Arrow
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateBadge(DateTime date, bool isUpcoming) {
    final now = DateTime.now();
    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;

    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: isUpcoming
            ? AppColors.deepNavy.withOpacity(0.1)
            : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: isUpcoming
            ? Border.all(color: AppColors.deepNavy, width: 2)
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('MMM').format(date),
            style: AppTextStyles.caption.copyWith(
              color: isUpcoming ? AppColors.deepNavy : AppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${date.day}',
            style: AppTextStyles.headline3.copyWith(
              color: isUpcoming ? AppColors.deepNavy : AppColors.textPrimary,
            ),
          ),
          if (isToday)
            Text(
              'TODAY',
              style: AppTextStyles.overline.copyWith(
                color: AppColors.deepNavy,
                fontSize: 8,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(bool isCompleted, bool isUpcoming, bool isPast) {
    Color color;
    String label;
    
    if (isCompleted) {
      color = AppColors.success;
      label = 'DONE';
    } else if (isUpcoming) {
      color = AppColors.deepNavy;
      label = 'UPCOMING';
    } else if (isPast) {
      color = AppColors.textSecondary;
      label = 'PAST';
    } else {
      color = AppColors.textSecondary;
      label = 'PLANNED';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
