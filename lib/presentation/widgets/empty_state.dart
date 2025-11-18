import 'package:flutter/material.dart';
import 'package:big_boss_fishing/core/theme/app_colors.dart';
import 'package:big_boss_fishing/core/theme/text_styles.dart';
import 'package:big_boss_fishing/presentation/widgets/boss_button.dart';

/// EmptyStateWidget - Shows when lists are empty with image and CTA
class EmptyStateWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyStateWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.message,
    this.buttonText,
    this.onButtonPressed,
  });

  /// Empty state for no catches
  factory EmptyStateWidget.noCatches({
    required VoidCallback onAddCatch,
  }) {
    return EmptyStateWidget(
      imagePath: 'assets/empty-states/no-catches.png',
      title: 'NO CATCHES YET',
      message: 'Start logging your catches to track your fishing journey and earn XP!',
      buttonText: 'LOG YOUR FIRST CATCH',
      onButtonPressed: onAddCatch,
    );
  }

  /// Empty state for no spots
  factory EmptyStateWidget.noSpots({
    required VoidCallback onAddSpot,
  }) {
    return EmptyStateWidget(
      imagePath: 'assets/empty-states/no-spots.png',
      title: 'NO SPOTS SAVED',
      message: 'Add your favorite fishing spots to keep track of the best locations!',
      buttonText: 'ADD YOUR FIRST SPOT',
      onButtonPressed: onAddSpot,
    );
  }

  /// Empty state for no trips
  factory EmptyStateWidget.noTrips({
    required VoidCallback onAddTrip,
  }) {
    return EmptyStateWidget(
      imagePath: 'assets/empty-states/no-trips.png',
      title: 'NO TRIPS PLANNED',
      message: 'Plan your next fishing adventure and never miss the perfect conditions!',
      buttonText: 'PLAN YOUR FIRST TRIP',
      onButtonPressed: onAddTrip,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty state image
            Image.asset(
              imagePath,
              width: 200,
              height: 200,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback icon if image not found
                return Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.emoji_nature_rounded,
                    size: 100,
                    color: AppColors.textSecondary,
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            // Title
            Text(
              title,
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Message
            Text(
              message,
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // CTA Button
            if (buttonText != null && onButtonPressed != null)
              BossButton(
                text: buttonText!,
                onPressed: onButtonPressed!,
                icon: Icons.add_circle_outline_rounded,
              ),
          ],
        ),
      ),
    );
  }
}

/// NoSearchResults - Empty state for search with no results
class NoSearchResults extends StatelessWidget {
  final String searchQuery;

  const NoSearchResults({
    super.key,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 80,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 24),
            Text(
              'NO RESULTS FOUND',
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'No matches for "$searchQuery"',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Try different keywords or check your spelling',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
