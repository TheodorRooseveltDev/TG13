import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:big_boss_fishing/core/theme/app_colors.dart';
import 'package:big_boss_fishing/core/theme/text_styles.dart';
import 'package:big_boss_fishing/core/utils/date_formatter.dart';
import 'package:big_boss_fishing/core/utils/size_calculator.dart';
import 'package:big_boss_fishing/providers/catch_provider.dart';
import 'package:big_boss_fishing/providers/app_state_provider.dart';
import 'package:big_boss_fishing/data/models/catch_model.dart';
import 'package:big_boss_fishing/presentation/widgets/empty_state.dart';
import 'package:big_boss_fishing/presentation/widgets/boss_button.dart';
import 'package:big_boss_fishing/presentation/widgets/screen_background.dart';
import 'package:big_boss_fishing/app/routes.dart';

/// Catch Log Screen - List of all catches with filters and sort
class CatchLogScreen extends StatefulWidget {
  const CatchLogScreen({super.key});

  @override
  State<CatchLogScreen> createState() => _CatchLogScreenState();
}

class _CatchLogScreenState extends State<CatchLogScreen> {
  String _sortBy = 'date'; // date, weight, length, species
  bool _sortDescending = true;
  String _filterSpecies = 'All';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'CATCH LOG',
          style: AppTextStyles.headline5.copyWith(
            color: AppColors.textLight,
          ),
        ),
        backgroundColor: AppColors.deepNavy,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: _showFilterSheet,
          ),
          IconButton(
            icon: const Icon(Icons.sort_rounded),
            onPressed: _showSortSheet,
          ),
        ],
      ),
      body: ScreenBackground(
        child: Column(
          children: [
            // Search bar
            _buildSearchBar(),

            // Stats summary
            _buildStatsSummary(),

            // Catches list
            Expanded(
              child: _buildCatchesList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FadeInUp(
        duration: const Duration(milliseconds: 600),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.addCatch);
          },
          backgroundColor: AppColors.deepNavy,
          child: const Icon(Icons.add_rounded, color: AppColors.textLight, size: 32),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.cardBackground,
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search by species, location...',
          hintStyle: AppTextStyles.inputHint,
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
          filled: true,
          fillColor: AppColors.backgroundLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildStatsSummary() {
    return Consumer2<CatchProvider, AppStateProvider>(
      builder: (context, catchProvider, appStateProvider, child) {
        final unitsSystem = appStateProvider.unitsSystem;
        final catches = _getFilteredAndSortedCatches(catchProvider.catches);
        final totalWeight = catches.fold<double>(
          0,
          (sum, c) => sum + c.weight,
        );
        final avgWeight = catches.isEmpty ? 0.0 : totalWeight / catches.length;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: AppColors.cardBackground,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                label: 'Total',
                value: '${catches.length}',
                icon: Icons.emoji_nature_rounded,
              ),
              _StatItem(
                label: 'Total Weight',
                value: SizeCalculator.formatWeight(totalWeight, unitsSystem),
                icon: Icons.scale_rounded,
              ),
              _StatItem(
                label: 'Average',
                value: SizeCalculator.formatWeight(avgWeight, unitsSystem),
                icon: Icons.analytics_rounded,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCatchesList() {
    return Consumer<CatchProvider>(
      builder: (context, catchProvider, child) {
        if (catchProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.deepNavy),
            ),
          );
        }

        final catches = _getFilteredAndSortedCatches(catchProvider.catches);

        if (catches.isEmpty && _searchQuery.isNotEmpty) {
          return NoSearchResults(searchQuery: _searchQuery);
        }

        if (catches.isEmpty) {
          return EmptyStateWidget.noCatches(
            onAddCatch: () {
              Navigator.of(context).pushNamed(AppRoutes.addCatch);
            },
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: catches.length,
          itemBuilder: (context, index) {
            final catchModel = catches[index];
            return FadeInUp(
              duration: const Duration(milliseconds: 400),
              delay: Duration(milliseconds: index * 50),
              child: _CatchListItem(
                catchModel: catchModel,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.catchDetail,
                    arguments: catchModel,
                  );
                },
                onDelete: () async {
                  final confirmed = await _showDeleteConfirmation(context);
                  if (confirmed == true && mounted) {
                    await catchProvider.deleteCatch(catchModel.id);
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  List<CatchModel> _getFilteredAndSortedCatches(List<CatchModel> catches) {
    // Filter
    var filtered = catches.where((c) {
      if (_filterSpecies != 'All' && c.species != _filterSpecies) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return c.species.toLowerCase().contains(query) ||
            c.location.toLowerCase().contains(query) ||
            c.bait.toLowerCase().contains(query);
      }
      return true;
    }).toList();

    // Sort
    filtered.sort((a, b) {
      int comparison;
      switch (_sortBy) {
        case 'weight':
          comparison = a.weight.compareTo(b.weight);
          break;
        case 'length':
          comparison = a.length.compareTo(b.length);
          break;
        case 'species':
          comparison = a.species.compareTo(b.species);
          break;
        case 'date':
        default:
          comparison = a.dateTime.compareTo(b.dateTime);
      }
      return _sortDescending ? -comparison : comparison;
    });

    return filtered;
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FILTER BY SPECIES',
                    style: AppTextStyles.heading5,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['All', 'Bass', 'Trout', 'Pike', 'Catfish', 'Salmon', 'Other']
                        .map((species) => FilterChip(
                              label: Text(
                                species,
                                style: TextStyle(
                                  color: _filterSpecies == species
                                      ? AppColors.textLight
                                      : AppColors.textPrimary,
                                ),
                              ),
                              selected: _filterSpecies == species,
                              onSelected: (selected) {
                                setModalState(() {
                                  _filterSpecies = species;
                                });
                                setState(() {
                                  _filterSpecies = species;
                                });
                              },
                              selectedColor: AppColors.deepNavy,
                              backgroundColor: AppColors.backgroundLight,
                              checkmarkColor: AppColors.textLight,
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  BossButton(
                    text: 'APPLY',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    width: double.infinity,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SORT BY',
                style: AppTextStyles.heading5,
              ),
              const SizedBox(height: 16),
              _SortOption(
                label: 'Date',
                value: 'date',
                isSelected: _sortBy == 'date',
                onTap: () {
                  setState(() {
                    _sortBy = 'date';
                  });
                  Navigator.of(context).pop();
                },
              ),
              _SortOption(
                label: 'Weight',
                value: 'weight',
                isSelected: _sortBy == 'weight',
                onTap: () {
                  setState(() {
                    _sortBy = 'weight';
                  });
                  Navigator.of(context).pop();
                },
              ),
              _SortOption(
                label: 'Length',
                value: 'length',
                isSelected: _sortBy == 'length',
                onTap: () {
                  setState(() {
                    _sortBy = 'length';
                  });
                  Navigator.of(context).pop();
                },
              ),
              _SortOption(
                label: 'Species',
                value: 'species',
                isSelected: _sortBy == 'species',
                onTap: () {
                  setState(() {
                    _sortBy = 'species';
                  });
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: Text(
                  'Descending',
                  style: AppTextStyles.bodyMedium,
                ),
                value: _sortDescending,
                onChanged: (value) {
                  setState(() {
                    _sortDescending = value;
                  });
                  Navigator.of(context).pop();
                },
                activeColor: AppColors.deepNavy,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Catch?',
          style: AppTextStyles.heading5,
        ),
        content: Text(
          'This action cannot be undone.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'CANCEL',
              style: AppTextStyles.buttonSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'DELETE',
              style: AppTextStyles.buttonSmall.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.deepNavy,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyBoldMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _SortOption extends StatelessWidget {
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortOption({
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        label,
        style: AppTextStyles.bodyMedium,
      ),
      trailing: isSelected
          ? const Icon(Icons.check_rounded, color: AppColors.deepNavy)
          : null,
      onTap: onTap,
    );
  }
}

class _CatchListItem extends StatelessWidget {
  final CatchModel catchModel;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _CatchListItem({
    required this.catchModel,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final unitsSystem = context.read<AppStateProvider>().unitsSystem;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onDelete(),
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.textLight,
              icon: Icons.delete_rounded,
              label: 'Delete',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
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
            child: Row(
              children: [
                // Fish icon or photo
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: catchModel.photoPath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(catchModel.photoPath!),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.emoji_nature_rounded,
                                color: AppColors.deepNavy,
                                size: 32,
                              );
                            },
                          ),
                        )
                      : const Icon(
                          Icons.emoji_nature_rounded,
                          color: AppColors.deepNavy,
                          size: 32,
                        ),
                ),
                const SizedBox(width: 16),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        catchModel.species,
                        style: AppTextStyles.cardTitle.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.scale_rounded,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            SizeCalculator.formatWeight(catchModel.weight, unitsSystem),
                            style: AppTextStyles.caption,
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.straighten_rounded,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            SizeCalculator.formatLength(catchModel.length, unitsSystem),
                            style: AppTextStyles.caption,
                          ),
                        ],
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
                // Trophy badge if applicable
                if (SizeCalculator.isTrophy(catchModel.length, catchModel.weight))
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.sunsetGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.emoji_events_rounded,
                          color: AppColors.textLight,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'TROPHY',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
