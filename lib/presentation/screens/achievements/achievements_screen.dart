import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:big_boss_fishing/core/theme/app_colors.dart';
import 'package:big_boss_fishing/core/theme/text_styles.dart';
import 'package:big_boss_fishing/providers/achievement_provider.dart';
import 'package:big_boss_fishing/data/models/achievement_model.dart';
import 'package:big_boss_fishing/presentation/widgets/screen_background.dart';

/// Achievements Screen - Shows all achievements (locked and unlocked)
class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  String _filter = 'all'; // 'all', 'unlocked', 'locked'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Achievements',
          style: AppTextStyles.headline2.copyWith(
            color: AppColors.textLight,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.deepNavy,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textLight),
      ),
      body: ScreenBackground(
        child: Consumer<AchievementProvider>(
          builder: (context, achievementProvider, child) {
          if (achievementProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.deepNavy),
              ),
            );
          }

          final allAchievements = achievementProvider.achievements;
          final unlockedAchievements = achievementProvider.unlockedAchievements;
          final lockedAchievements = achievementProvider.lockedAchievements;

          // Filter achievements based on selected filter
          final displayAchievements = _filter == 'all'
              ? allAchievements
              : _filter == 'unlocked'
                  ? unlockedAchievements
                  : lockedAchievements;

          return Column(
            children: [
              // Stats header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      '${unlockedAchievements.length}/${allAchievements.length}',
                      style: AppTextStyles.display1.copyWith(
                        fontSize: 48,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Achievements Unlocked',
                      style: AppTextStyles.subtitle1.copyWith(
                        color: AppColors.textLight.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: allAchievements.isNotEmpty
                            ? unlockedAchievements.length / allAchievements.length
                            : 0,
                        minHeight: 12,
                        backgroundColor: AppColors.textLight.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.bossAqua,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Filter tabs
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      isSelected: _filter == 'all',
                      onTap: () => setState(() => _filter = 'all'),
                    ),
                    const SizedBox(width: 12),
                    _FilterChip(
                      label: 'Unlocked',
                      isSelected: _filter == 'unlocked',
                      onTap: () => setState(() => _filter = 'unlocked'),
                    ),
                    const SizedBox(width: 12),
                    _FilterChip(
                      label: 'Locked',
                      isSelected: _filter == 'locked',
                      onTap: () => setState(() => _filter = 'locked'),
                    ),
                  ],
                ),
              ),

              // Achievements list
              Expanded(
                child: displayAchievements.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/achivments-badges/trophy-hunter.png',
                              width: 120,
                              height: 120,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No achievements here yet!',
                              style: AppTextStyles.subtitle1.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: displayAchievements.length,
                        itemBuilder: (context, index) {
                          final achievement = displayAchievements[index];
                          return FadeInUp(
                            delay: Duration(milliseconds: 50 * index),
                            duration: const Duration(milliseconds: 400),
                            child: _AchievementCard(
                              achievement: achievement,
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
        ),
      ),
    );
  }
}

/// Filter chip widget
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.deepNavy : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.deepNavy : AppColors.textSecondary,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyBold.copyWith(
            color: isSelected ? AppColors.textLight : AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

/// Achievement card widget
class _AchievementCard extends StatelessWidget {
  final AchievementModel achievement;

  const _AchievementCard({
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = !achievement.isUnlocked;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isLocked ? null : AppColors.cardGradient,
        color: isLocked ? AppColors.cardBackground : null,
        borderRadius: BorderRadius.circular(16),
        border: isLocked
            ? Border.all(
                color: AppColors.textSecondary.withOpacity(0.2),
                width: 1,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isLocked ? 0.03 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Badge icon
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: isLocked
                  ? AppColors.backgroundDark.withOpacity(0.3)
                  : AppColors.deepNavy.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: isLocked
                  ? Border.all(
                      color: AppColors.textSecondary.withOpacity(0.2),
                      width: 2,
                    )
                  : null,
            ),
            child: achievement.badgeImage.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      achievement.badgeImage,
                      fit: BoxFit.cover,
                      opacity: isLocked
                          ? const AlwaysStoppedAnimation(0.4)
                          : const AlwaysStoppedAnimation(1.0),
                    ),
                  )
                : Icon(
                    isLocked ? Icons.lock_outline : Icons.emoji_events,
                    color: isLocked
                        ? AppColors.textSecondary.withOpacity(0.3)
                        : AppColors.deepNavy,
                    size: 36,
                  ),
          ),
          const SizedBox(width: 16),

          // Achievement info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.name,
                  style: AppTextStyles.bodyBold.copyWith(
                    fontSize: 16,
                    color: isLocked
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  achievement.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: isLocked
                          ? AppColors.textSecondary.withOpacity(0.5)
                          : AppColors.bossAqua,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+${achievement.xpReward} XP',
                      style: AppTextStyles.caption.copyWith(
                        color: isLocked
                            ? AppColors.textSecondary
                            : AppColors.deepNavy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (!isLocked && achievement.unlockedAt != null) ...[
                      const Spacer(),
                      Icon(
                        Icons.check_circle,
                        size: 20,
                        color: AppColors.deepNavy,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
