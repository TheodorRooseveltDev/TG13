import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import '../../data/models/achievement_model.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/text_styles.dart';

/// Dialog shown when user unlocks an achievement with animations
class AchievementUnlockDialog extends StatefulWidget {
  final AchievementModel achievement;

  const AchievementUnlockDialog({
    super.key,
    required this.achievement,
  });

  @override
  State<AchievementUnlockDialog> createState() => _AchievementUnlockDialogState();
}

class _AchievementUnlockDialogState extends State<AchievementUnlockDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _controller.forward();
    
    // Haptic feedback on unlock - use heavy impact for achievement unlocks!
    // Note: This runs before build, so context is not available yet
    // We'll trigger a heavy impact directly since achievements are always important
    HapticFeedback.heavyImpact();
    
    // Auto-dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
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
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Confetti animation (using simple animated stars instead of Lottie for now)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black54,
              ),
            ),
          ),
          
          // Achievement card
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: ZoomIn(
              duration: const Duration(milliseconds: 600),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: screenHeight * 0.8,
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.bossAqua, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.bossAqua.withValues(alpha: 0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // "Achievement Unlocked!" text
                      Pulse(
                        infinite: true,
                        duration: const Duration(seconds: 2),
                        child: Text(
                          '🏆 ACHIEVEMENT UNLOCKED! 🏆',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headline3.copyWith(
                            color: AppColors.bossAqua,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Badge image
                      ScaleTransition(
                        scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _controller,
                            curve: Curves.elasticOut,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.2),
                            border: Border.all(color: AppColors.bossAqua, width: 4),
                          ),
                          child: Image.asset(
                            widget.achievement.badgeImage,
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Achievement name
                      FadeInUp(
                        delay: const Duration(milliseconds: 300),
                        child: Text(
                          widget.achievement.name,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headline2.copyWith(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Description
                      FadeInUp(
                        delay: const Duration(milliseconds: 400),
                        child: Text(
                          widget.achievement.description,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // XP reward
                      FadeInUp(
                        delay: const Duration(milliseconds: 500),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.sunsetOrange,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.sunsetOrange.withValues(alpha: 0.5),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.stars,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '+${widget.achievement.xpReward} XP',
                                style: AppTextStyles.headline3.copyWith(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Close button
                      FadeInUp(
                        delay: const Duration(milliseconds: 600),
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'AWESOME!',
                            style: AppTextStyles.headline4.copyWith(
                              color: AppColors.bossAqua,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
