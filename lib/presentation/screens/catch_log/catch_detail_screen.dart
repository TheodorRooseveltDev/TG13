import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:big_boss_fishing/core/theme/app_colors.dart';
import 'package:big_boss_fishing/core/theme/text_styles.dart';
import 'package:big_boss_fishing/core/utils/date_formatter.dart';
import 'package:big_boss_fishing/core/utils/size_calculator.dart';
import 'package:big_boss_fishing/providers/catch_provider.dart';
import 'package:big_boss_fishing/providers/app_state_provider.dart';
import 'package:big_boss_fishing/data/models/catch_model.dart';
import 'package:big_boss_fishing/presentation/widgets/boss_button.dart';

/// Catch Detail Screen - Shows full details of a catch
class CatchDetailScreen extends StatelessWidget {
  final CatchModel catchModel;

  const CatchDetailScreen({
    super.key,
    required this.catchModel,
  });

  @override
  Widget build(BuildContext context) {
    final unitsSystem = context.read<AppStateProvider>().unitsSystem;
    final isTrophy = SizeCalculator.isTrophy(catchModel.length, catchModel.weight);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // App Bar with photo
          _buildSliverAppBar(context),

          // Content
          SliverList(
            delegate: SliverChildListDelegate([
              // Trophy badge
              if (isTrophy) _buildTrophyBanner(),

              // Main info card
              _buildMainInfoCard(context, unitsSystem),

              const SizedBox(height: 16),

              // Details grid
              _buildDetailsGrid(context, unitsSystem),

              const SizedBox(height: 16),

              // Location & Weather
              _buildLocationWeatherCard(context),

              const SizedBox(height: 16),

              // Technique & Bait
              _buildTechniqueBaitCard(context),

              const SizedBox(height: 16),

              // Rating & Notes
              _buildRatingNotesCard(context),

              const SizedBox(height: 16),

              // Metadata
              _buildMetadataCard(context),

              const SizedBox(height: 24),

              // Action buttons
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
            // TODO: Implement share functionality
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Share functionality coming soon!')),
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          catchModel.species,
          style: AppTextStyles.headline5.copyWith(
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
            // Photo or placeholder
            if (catchModel.photoPath != null)
              Image.asset(
                catchModel.photoPath!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPhotoPlaceholder();
                },
              )
            else
              _buildPhotoPlaceholder(),

            // Gradient overlay
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
          Icons.emoji_nature_rounded,
          size: 120,
          color: AppColors.deepNavy.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildTrophyBanner() {
    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: AppColors.sunsetGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentOrange.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.emoji_events_rounded,
              color: AppColors.textLight,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TROPHY CATCH!',
                    style: AppTextStyles.cardTitle.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'This is a trophy-sized fish!',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textLight.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainInfoCard(BuildContext context, String unitsSystem) {
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
              icon: Icons.scale_rounded,
              label: 'WEIGHT',
              value: SizeCalculator.formatWeight(catchModel.weight, unitsSystem),
              color: AppColors.deepNavy,
            ),
            Container(
              width: 1,
              height: 60,
              color: AppColors.borderSecondary,
            ),
            _StatColumn(
              icon: Icons.straighten_rounded,
              label: 'LENGTH',
              value: SizeCalculator.formatLength(catchModel.length, unitsSystem),
              color: AppColors.accentOrange,
            ),
            Container(
              width: 1,
              height: 60,
              color: AppColors.borderSecondary,
            ),
            _StatColumn(
              icon: Icons.category_rounded,
              label: 'SIZE',
              value: SizeCalculator.getSizeCategory(catchModel.length),
              color: AppColors.success,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsGrid(BuildContext context, String unitsSystem) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FadeInUp(
        delay: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 600),
        child: Row(
          children: [
            Expanded(
              child: _DetailCard(
                icon: Icons.access_time_rounded,
                label: 'TIME',
                value: DateFormatter.timeOfDayCategory(catchModel.dateTime),
                color: AppColors.deepNavy,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _DetailCard(
                icon: Icons.calendar_today_rounded,
                label: 'DATE',
                value: DateFormatter.smartDate(catchModel.dateTime),
                color: AppColors.accentOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationWeatherCard(BuildContext context) {
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
                  Icons.location_on_rounded,
                  color: AppColors.deepNavy,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LOCATION',
                        style: AppTextStyles.overline.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        catchModel.location,
                        style: AppTextStyles.bodyBoldMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: AppColors.borderSecondary),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  _getWeatherIcon(catchModel.weather),
                  color: _getWeatherColor(catchModel.weather),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WEATHER',
                      style: AppTextStyles.overline.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      catchModel.weather,
                      style: AppTextStyles.bodyBoldMedium,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechniqueBaitCard(BuildContext context) {
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
          children: [
            _InfoRow(
              icon: Icons.settings_rounded,
              label: 'TECHNIQUE',
              value: catchModel.technique,
            ),
            const SizedBox(height: 16),
            Divider(color: AppColors.borderSecondary),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.bug_report_rounded,
              label: 'BAIT',
              value: catchModel.bait,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingNotesCard(BuildContext context) {
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
                  Icons.star_rounded,
                  color: AppColors.accentOrange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'RATING',
                  style: AppTextStyles.overline.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            RatingBarIndicator(
              rating: catchModel.rating.toDouble(),
              itemBuilder: (context, index) => const Icon(
                Icons.star_rounded,
                color: AppColors.accentOrange,
              ),
              itemCount: 5,
              itemSize: 32.0,
              direction: Axis.horizontal,
            ),
            if (catchModel.notes.isNotEmpty) ...[
              const SizedBox(height: 20),
              Divider(color: AppColors.borderSecondary),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(
                    Icons.notes_rounded,
                    color: AppColors.deepNavy,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'NOTES',
                    style: AppTextStyles.overline.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                catchModel.notes,
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

  Widget _buildMetadataCard(BuildContext context) {
    return FadeInUp(
      delay: const Duration(milliseconds: 1000),
      duration: const Duration(milliseconds: 600),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.borderSecondary,
          ),
        ),
        child: Column(
          children: [
            _MetadataRow(
              label: 'Logged',
              value: DateFormatter.formatRelative(catchModel.createdAt),
            ),
            const SizedBox(height: 8),
            _MetadataRow(
              label: 'Last Updated',
              value: DateFormatter.formatRelative(catchModel.updatedAt),
            ),
            const SizedBox(height: 8),
            _MetadataRow(
              label: 'Catch ID',
              value: catchModel.id.substring(0, 8),
            ),
          ],
        ),
      ),
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
                // TODO: Navigate to edit screen
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
          'Delete Catch?',
          style: AppTextStyles.heading5,
        ),
        content: Text(
          'This action cannot be undone. All data for this catch will be permanently deleted.',
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
      final catchProvider = context.read<CatchProvider>();
      await catchProvider.deleteCatch(catchModel.id);

      if (context.mounted) {
        Navigator.of(context).pop(); // Return to list
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Catch deleted',
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

  IconData _getWeatherIcon(String weather) {
    switch (weather.toLowerCase()) {
      case 'sunny':
        return Icons.wb_sunny_rounded;
      case 'partly cloudy':
        return Icons.wb_cloudy_rounded;
      case 'cloudy':
        return Icons.cloud_rounded;
      case 'rainy':
        return Icons.water_drop_rounded;
      case 'stormy':
        return Icons.thunderstorm_rounded;
      case 'windy':
        return Icons.air_rounded;
      case 'foggy':
        return Icons.foggy;
      case 'snowy':
        return Icons.ac_unit_rounded;
      default:
        return Icons.wb_sunny_rounded;
    }
  }

  Color _getWeatherColor(String weather) {
    switch (weather.toLowerCase()) {
      case 'sunny':
        return AppColors.sunny;
      case 'partly cloudy':
      case 'cloudy':
        return AppColors.cloudy;
      case 'rainy':
        return AppColors.rainy;
      case 'stormy':
        return AppColors.stormy;
      default:
        return AppColors.deepNavy;
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
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
                style: AppTextStyles.overline.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyles.bodyBoldMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetadataRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetadataRow({
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
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
