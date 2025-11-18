import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:big_boss_fishing/core/theme/app_colors.dart';
import 'package:big_boss_fishing/core/theme/text_styles.dart';
import 'package:big_boss_fishing/core/utils/date_formatter.dart';
import 'package:big_boss_fishing/core/utils/size_calculator.dart';
import 'package:big_boss_fishing/providers/spot_provider.dart';
import 'package:big_boss_fishing/providers/catch_provider.dart';
import 'package:big_boss_fishing/providers/app_state_provider.dart';
import 'package:big_boss_fishing/data/models/spot_model.dart';
import 'package:big_boss_fishing/data/models/catch_model.dart';
import 'package:big_boss_fishing/presentation/widgets/boss_button.dart';
import 'package:big_boss_fishing/app/routes.dart';

/// Spot Detail Screen - Shows full details of a fishing spot
class SpotDetailScreen extends StatelessWidget {
  final SpotModel spot;

  const SpotDetailScreen({
    super.key,
    required this.spot,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildMainInfoCard(context),
              const SizedBox(height: 16),
              _buildDetailsGrid(context),
              const SizedBox(height: 16),
              _buildCommonFishCard(context),
              const SizedBox(height: 16),
              _buildNotesCard(context),
              const SizedBox(height: 16),
              _buildCatchHistorySection(context),
              const SizedBox(height: 24),
              _buildActionButtons(context),
              const SizedBox(height: 32),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.deepNavy,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textLight,
          ),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.share_rounded,
              color: AppColors.textLight,
            ),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Share functionality coming soon!')),
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          spot.name,
          style: AppTextStyles.heading5.copyWith(
            color: AppColors.textLight,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.7),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (spot.photoPath != null)
              Image.asset(
                spot.photoPath!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPhotoPlaceholder();
                },
              )
            else
              _buildPhotoPlaceholder(),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Container(
      color: AppColors.deepNavy,
      child: Center(
        child: Icon(
          _getWaterTypeIcon(),
          size: 120,
          color: _getWaterTypeColor().withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildMainInfoCard(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatColumn(
              icon: Icons.water_rounded,
              label: 'TYPE',
              value: spot.waterType,
              color: _getWaterTypeColor(),
            ),
            Container(
              width: 1,
              height: 60,
              color: AppColors.borderSecondary,
            ),
            _StatColumn(
              icon: Icons.wb_twilight_rounded,
              label: 'BEST TIME',
              value: spot.bestTime,
              color: AppColors.accentOrange,
            ),
            Container(
              width: 1,
              height: 60,
              color: AppColors.borderSecondary,
            ),
            _StatColumn(
              icon: Icons.star_rounded,
              label: 'RATING',
              value: '${spot.rating}/5',
              color: AppColors.accentOrange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FadeInUp(
        delay: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 600),
        child: Row(
          children: [
            Expanded(
              child: _DetailCard(
                icon: Icons.calendar_today_rounded,
                label: 'ADDED',
                value: DateFormatter.smartDate(spot.createdAt),
                color: AppColors.deepNavy,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _DetailCard(
                icon: Icons.access_time_rounded,
                label: 'LAST VISIT',
                value: spot.lastVisited != null
                    ? DateFormatter.formatRelative(spot.lastVisited!)
                    : 'Never',
                color: AppColors.accentOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommonFishCard(BuildContext context) {
    if (spot.commonFish.isEmpty) return const SizedBox.shrink();

    return FadeInUp(
      delay: const Duration(milliseconds: 400),
      duration: const Duration(milliseconds: 600),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
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
                  Icons.emoji_nature_rounded,
                  color: AppColors.deepNavy,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'COMMON FISH SPECIES',
                  style: AppTextStyles.overline.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: spot.commonFish.map((fish) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.deepNavy.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.deepNavy.withOpacity(0.5),
                    ),
                  ),
                  child: Text(
                    fish,
                    style: AppTextStyles.buttonSmall.copyWith(
                      color: AppColors.deepNavy,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard(BuildContext context) {
    final hasDepthNotes = spot.depthNotes.isNotEmpty;
    final hasAccessNotes = spot.accessNotes.isNotEmpty;

    if (!hasDepthNotes && !hasAccessNotes) {
      return const SizedBox.shrink();
    }

    return FadeInUp(
      delay: const Duration(milliseconds: 600),
      duration: const Duration(milliseconds: 600),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
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
            if (hasDepthNotes) ...[
              Row(
                children: [
                  Icon(
                    Icons.straighten_rounded,
                    color: AppColors.deepNavy,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'DEPTH & STRUCTURE',
                    style: AppTextStyles.overline.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                spot.depthNotes,
                style: AppTextStyles.bodyMedium.copyWith(
                  height: 1.6,
                ),
              ),
            ],
            if (hasDepthNotes && hasAccessNotes) ...[
              const SizedBox(height: 20),
              Divider(color: AppColors.borderSecondary),
              const SizedBox(height: 20),
            ],
            if (hasAccessNotes) ...[
              Row(
                children: [
                  Icon(
                    Icons.directions_rounded,
                    color: AppColors.accentOrange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'ACCESS & DIRECTIONS',
                    style: AppTextStyles.overline.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                spot.accessNotes,
                style: AppTextStyles.bodyMedium.copyWith(
                  height: 1.6,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCatchHistorySection(BuildContext context) {
    return Consumer<CatchProvider>(
      builder: (context, catchProvider, _) {
        final catchesAtSpot = catchProvider.catches
            .where((c) => c.location == spot.name)
            .toList()
          ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

        return FadeInUp(
          delay: const Duration(milliseconds: 800),
          duration: const Duration(milliseconds: 600),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
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
                      Icons.history_rounded,
                      color: AppColors.deepNavy,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'CATCH HISTORY',
                        style: AppTextStyles.overline.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.deepNavy.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${catchesAtSpot.length}',
                        style: AppTextStyles.bodyBold.copyWith(
                          color: AppColors.deepNavy,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (catchesAtSpot.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        'No catches logged at this spot yet',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                  )
                else
                  Column(
                    children: catchesAtSpot.take(5).map((catchModel) {
                      return _CatchHistoryItem(catchModel: catchModel);
                    }).toList(),
                  ),
                if (catchesAtSpot.length > 5) ...[
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Navigate to catch log filtered by this spot
                        Navigator.of(context).pushNamed(AppRoutes.catchLog);
                      },
                      child: Text(
                        'View all ${catchesAtSpot.length} catches',
                        style: AppTextStyles.buttonSmall.copyWith(
                          color: AppColors.deepNavy,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: BossOutlineButton(
              text: 'EDIT',
              iconPath: 'assets/action-icons/edit.png',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit functionality coming soon!')),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: BossButton(
              text: 'DELETE',
              iconPath: 'assets/action-icons/delete.png',
              isSecondary: true,
              onPressed: () => _showDeleteConfirmation(context),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Spot?',
          style: AppTextStyles.heading5,
        ),
        content: Text(
          'This action cannot be undone. All data for this fishing spot will be permanently deleted.',
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

    if (confirmed == true && context.mounted) {
      final spotProvider = context.read<SpotProvider>();
      await spotProvider.deleteSpot(spot.id);

      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Spot deleted',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textLight,
              ),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
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

class _StatColumn extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatColumn({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTextStyles.overline.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyBold.copyWith(
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _DetailCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _DetailCard({
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
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.overline.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.bodyBoldMedium,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _CatchHistoryItem extends StatelessWidget {
  final CatchModel catchModel;

  const _CatchHistoryItem({
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
                Icons.emoji_nature_rounded,
                color: AppColors.deepNavy,
                size: 20,
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
                      DateFormatter.formatRelative(catchModel.dateTime),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                SizeCalculator.formatWeight(catchModel.weight, unitsSystem),
                style: AppTextStyles.bodyBoldMedium.copyWith(
                  color: AppColors.accentOrange,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
