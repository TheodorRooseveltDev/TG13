import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:big_boss_fishing/core/theme/app_colors.dart';
import 'package:big_boss_fishing/core/theme/text_styles.dart';
import 'package:big_boss_fishing/core/constants/app_constants.dart';
import 'package:big_boss_fishing/providers/app_state_provider.dart';
import 'package:big_boss_fishing/providers/catch_provider.dart';
import 'package:big_boss_fishing/providers/spot_provider.dart';
import 'package:big_boss_fishing/providers/gear_provider.dart';
import 'package:big_boss_fishing/providers/trip_provider.dart';
import 'package:big_boss_fishing/presentation/screens/webview/webview_screen.dart';
import 'package:big_boss_fishing/app/routes.dart';

/// Settings Screen - User preferences and app configuration
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: AppTextStyles.heading5.copyWith(
            color: AppColors.textLight,
          ),
        ),
        backgroundColor: AppColors.deepNavy,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textLight),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildProfileSection(),
          const SizedBox(height: 24),
          _buildPreferencesSection(),
          const SizedBox(height: 24),
          _buildNotificationsSection(),
          const SizedBox(height: 24),
          _buildDataSection(),
          const SizedBox(height: 24),
          _buildAboutSection(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Consumer<AppStateProvider>(
      builder: (context, appStateProvider, _) {
        final level = appStateProvider.getUserLevel();
        final currentXP = appStateProvider.getCurrentLevelXP();
        final nextLevelXP = appStateProvider.getNextLevelXP();

        return FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
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
                // Avatar
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.deepNavy,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.textLight,
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    size: 48,
                    color: AppColors.deepNavy,
                  ),
                ),
                const SizedBox(height: 16),
                // Name
                Text(
                  'Captain',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 4),
                // Level
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.deepNavy,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'LEVEL $level',
                    style: AppTextStyles.buttonSmall.copyWith(
                      color: AppColors.deepNavy,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // XP Progress
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'XP: $currentXP',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textLight.withOpacity(0.8),
                          ),
                        ),
                        Text(
                          'Next: $nextLevelXP',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textLight.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: nextLevelXP > 0 ? currentXP / nextLevelXP : 0,
                        minHeight: 12,
                        backgroundColor: AppColors.textLight.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.deepNavy),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPreferencesSection() {
    return FadeInUp(
      delay: const Duration(milliseconds: 200),
      duration: const Duration(milliseconds: 600),
      child: _SettingsSection(
        title: 'PREFERENCES',
        icon: Icons.tune_rounded,
        children: [
          Consumer<AppStateProvider>(
            builder: (context, appStateProvider, _) {
              return _SettingsTile(
                icon: Icons.straighten_rounded,
                title: 'Units System',
                subtitle: appStateProvider.unitsSystem == AppConstants.unitsImperial
                    ? 'Imperial (lbs, inches)'
                    : 'Metric (kg, cm)',
                trailing: Switch(
                  value: appStateProvider.unitsSystem == AppConstants.unitsMetric,
                  onChanged: (value) {
                    appStateProvider.setUnitsSystem(
                      value ? AppConstants.unitsMetric : AppConstants.unitsImperial,
                    );
                  },
                  activeColor: AppColors.deepNavy,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection() {
    return FadeInUp(
      delay: const Duration(milliseconds: 400),
      duration: const Duration(milliseconds: 600),
      child: _SettingsSection(
        title: 'NOTIFICATIONS & FEEDBACK',
        icon: Icons.notifications_rounded,
        children: [
          Consumer<AppStateProvider>(
            builder: (context, appStateProvider, _) {
              return _SettingsTile(
                icon: Icons.volume_up_rounded,
                title: 'Sound Effects',
                subtitle: 'Play sounds for actions',
                trailing: Switch(
                  value: appStateProvider.soundEnabled,
                  onChanged: (value) {
                    appStateProvider.setSoundEnabled(value);
                  },
                  activeColor: AppColors.deepNavy,
                ),
              );
            },
          ),
          Consumer<AppStateProvider>(
            builder: (context, appStateProvider, _) {
              return _SettingsTile(
                icon: Icons.vibration_rounded,
                title: 'Haptic Feedback',
                subtitle: 'Vibrate on interactions',
                trailing: Switch(
                  value: appStateProvider.hapticsEnabled,
                  onChanged: (value) {
                    appStateProvider.setHapticsEnabled(value);
                  },
                  activeColor: AppColors.deepNavy,
                ),
              );
            },
          ),
          Consumer<AppStateProvider>(
            builder: (context, appStateProvider, _) {
              return _SettingsTile(
                icon: Icons.notification_important_rounded,
                title: 'Push Notifications',
                subtitle: 'Trip reminders & achievements',
                trailing: Switch(
                  value: appStateProvider.notificationsEnabled,
                  onChanged: (value) {
                    appStateProvider.setNotificationsEnabled(value);
                  },
                  activeColor: AppColors.deepNavy,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDataSection() {
    return FadeInUp(
      delay: const Duration(milliseconds: 600),
      duration: const Duration(milliseconds: 600),
      child: _SettingsSection(
        title: 'DATA MANAGEMENT',
        icon: Icons.storage_rounded,
        children: [
          _SettingsTile(
            icon: Icons.delete_forever_rounded,
            title: 'Clear All Data',
            subtitle: 'Delete everything (cannot be undone)',
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.error,
            ),
            onTap: _showClearDataDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return FadeInUp(
      delay: const Duration(milliseconds: 800),
      duration: const Duration(milliseconds: 600),
      child: _SettingsSection(
        title: 'ABOUT',
        icon: Icons.info_rounded,
        children: [
          _SettingsTile(
            icon: Icons.info_outline_rounded,
            title: 'App Version',
            subtitle: '1.0.0',
            trailing: const SizedBox(),
          ),
          _SettingsTile(
            icon: Icons.article_rounded,
            title: 'Privacy Policy',
            subtitle: 'View our privacy policy',
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const WebViewScreen(
                    url: 'https://bigbosfishing.com/privacy-policy',
                    title: 'Privacy Policy',
                  ),
                ),
              );
            },
          ),
          _SettingsTile(
            icon: Icons.description_rounded,
            title: 'Terms of Service',
            subtitle: 'View terms and conditions',
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const WebViewScreen(
                    url: 'https://bigbosfishing.com/terms-and-conditions',
                    title: 'Terms of Service',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showClearDataDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Clear All Data?',
          style: AppTextStyles.heading5.copyWith(
            color: AppColors.error,
          ),
        ),
        content: Text(
          'This will permanently delete ALL your catches, spots, gear, and trips. This action cannot be undone!\n\nAre you absolutely sure?',
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
              'DELETE ALL',
              style: AppTextStyles.buttonSmall.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _clearAllData();
    }
  }

  Future<void> _clearAllData() async {
    try {
      final catchProvider = context.read<CatchProvider>();
      final spotProvider = context.read<SpotProvider>();
      final gearProvider = context.read<GearProvider>();
      final tripProvider = context.read<TripProvider>();
      final appStateProvider = context.read<AppStateProvider>();

      // Clear all data
      for (var catch_ in catchProvider.catches.toList()) {
        await catchProvider.deleteCatch(catch_.id);
      }
      for (var spot in spotProvider.spots.toList()) {
        await spotProvider.deleteSpot(spot.id);
      }
      for (var gear in gearProvider.gear.toList()) {
        await gearProvider.deleteGear(gear.id);
      }
      for (var trip in tripProvider.trips.toList()) {
        await tripProvider.deleteTrip(trip.id);
      }

      // Reset app state
      await appStateProvider.resetAppState();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'All data cleared',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textLight,
              ),
            ),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 2),
          ),
        );
        
        // Navigate to onboarding after a short delay
        await Future.delayed(const Duration(seconds: 2));
        
        if (mounted) {
          // Navigate to onboarding and remove all previous routes
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.onboarding,
            (route) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error clearing data: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppColors.deepNavy,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.overline.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: AppColors.cardGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppColors.deepNavy,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyBold,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}
