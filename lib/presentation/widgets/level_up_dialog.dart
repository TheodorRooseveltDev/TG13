import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/text_styles.dart';
import '../../core/utils/size_calculator.dart';

/// Dialog shown when user levels up with celebrations
class LevelUpDialog extends StatefulWidget {
  final int newLevel;
  final int currentXP;

  const LevelUpDialog({
    super.key,
    required this.newLevel,
    required this.currentXP,
  });

  @override
  State<LevelUpDialog> createState() => _LevelUpDialogState();
}

class _LevelUpDialogState extends State<LevelUpDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _controller.forward();
    
    // Heavy haptic feedback for level up!
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 200), () {
      HapticFeedback.heavyImpact();
    });
    
    // Auto-dismiss after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
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
    final rankTitle = SizeCalculator.getRankFromXP(widget.currentXP);
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Dark overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          
          // Celebration card
          FadeInDown(
            duration: const Duration(milliseconds: 800),
            child: ZoomIn(
              duration: const Duration(milliseconds: 800),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: AppColors.aquaGradient,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.sunsetOrange, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.sunsetOrange.withValues(alpha: 0.6),
                      blurRadius: 40,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // "LEVEL UP!" text with pulse animation
                    Pulse(
                      infinite: true,
                      duration: const Duration(seconds: 1),
                      child: Text(
                        '⚡ LEVEL UP! ⚡',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headline1.copyWith(
                          color: AppColors.sunsetOrange,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Level badge with scale animation
                    ScaleTransition(
                      scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _controller,
                          curve: Curves.elasticOut,
                        ),
                      ),
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                          border: Border.all(color: AppColors.sunsetOrange, width: 5),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.bossAqua.withValues(alpha: 0.6),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'LEVEL',
                                style: AppTextStyles.headline6.copyWith(
                                  color: Colors.white,
                                  fontSize: 14,
                                  letterSpacing: 2,
                                ),
                              ),
                              Text(
                                '${widget.newLevel}',
                                style: AppTextStyles.headline1.copyWith(
                                  color: Colors.white,
                                  fontSize: 48,
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 28),
                    
                    // Rank title
                    FadeInUp(
                      delay: const Duration(milliseconds: 400),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.deepNavy,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.bossAqua, width: 2),
                        ),
                        child: Text(
                          rankTitle,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headline3.copyWith(
                            color: AppColors.bossAqua,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Motivational text
                    FadeInUp(
                      delay: const Duration(milliseconds: 600),
                      child: Text(
                        'Keep fishing, Captain! 🎣',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 28),
                    
                    // Close button
                    FadeInUp(
                      delay: const Duration(milliseconds: 800),
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.sunsetOrange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'LET\'S GO!',
                          style: AppTextStyles.headline4.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
