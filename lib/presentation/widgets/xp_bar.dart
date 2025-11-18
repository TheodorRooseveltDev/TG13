import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:big_boss_fishing/core/theme/app_colors.dart';
import 'package:big_boss_fishing/core/theme/text_styles.dart';
import 'package:big_boss_fishing/providers/app_state_provider.dart';

/// XPBar - Shows current XP progress and rank
class XPBar extends StatelessWidget {
  final bool showRank;
  final bool isCompact;

  const XPBar({
    super.key,
    this.showRank = true,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final progress = appState.getXPProgress();

        if (isCompact) {
          return _buildCompactBar(progress, appState.userRank);
        }

        return _buildFullBar(progress, appState);
      },
    );
  }

  Widget _buildCompactBar(double progress, String rank) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (showRank) ...[
            Text(
              rank,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.accentAqua,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: LinearPercentIndicator(
              padding: EdgeInsets.zero,
              lineHeight: 6,
              percent: progress,
              backgroundColor: Colors.grey[300],
              progressColor: AppColors.deepNavy,
              barRadius: const Radius.circular(3),
              animation: true,
              animationDuration: 1000,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullBar(double progress, AppStateProvider appState) {
    final currentXP = appState.userXP;
    final nextLevelXP = appState.getNextLevelXP();
    final currentLevelXP = appState.getCurrentLevelXP();
    final xpInLevel = currentXP - currentLevelXP;
    final xpNeeded = nextLevelXP - currentLevelXP;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rank and XP
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (showRank)
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        appState.userRank,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'LEVEL ${appState.getUserLevel()}',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              Text(
                '$xpInLevel / $xpNeeded XP',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          LinearPercentIndicator(
            padding: EdgeInsets.zero,
            lineHeight: 12,
            percent: progress,
            backgroundColor: Colors.grey[300],
            progressColor: AppColors.deepNavy,
            barRadius: const Radius.circular(6),
            animation: true,
            animationDuration: 1000,
          ),
        ],
      ),
    );
  }
}

/// XPGainPopup - Animated popup showing XP gained
class XPGainPopup extends StatefulWidget {
  final int xpGained;
  final String reason;

  const XPGainPopup({
    super.key,
    required this.xpGained,
    required this.reason,
  });

  @override
  State<XPGainPopup> createState() => _XPGainPopupState();
}

class _XPGainPopupState extends State<XPGainPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 70,
      ),
    ]).animate(_controller);

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward().then((_) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.bossAqua.withValues(alpha: 0.5),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.star_rounded,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '+${widget.xpGained} XP',
                style: AppTextStyles.headline3.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.reason,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
