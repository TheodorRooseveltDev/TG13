import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../presentation/widgets/xp_bar.dart';
import '../../presentation/widgets/level_up_dialog.dart';
import '../../providers/app_state_provider.dart';
import 'size_calculator.dart';

/// Utility class for showing XP gain animations
class XPAnimationUtils {
  /// Show XP gain popup overlay with level-up detection
  static Future<void> showXPGainPopup(
    BuildContext context, {
    required int xpGained,
    required String reason,
    bool showLevelUpDialog = true,
  }) async {
    if (!context.mounted) return;
    
    final appStateProvider = Provider.of<AppStateProvider>(context, listen: false);
    
    // Get level before adding XP
    final levelBefore = SizeCalculator.getLevelFromXP(appStateProvider.userXP);
    
    // Light haptic feedback for XP gain
    HapticFeedback.lightImpact();
    
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.15,
        left: 0,
        right: 0,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: XPGainPopup(
              xpGained: xpGained,
              reason: reason,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Auto-remove after animation completes (1.5 seconds)
    Future.delayed(const Duration(milliseconds: 1600), () {
      overlayEntry.remove();
    });
    
    // Wait for XP popup to finish
    await Future.delayed(const Duration(milliseconds: 1700));
    
    // Check level after adding XP (only if showLevelUpDialog is true)
    if (showLevelUpDialog && context.mounted) {
      final levelAfter = SizeCalculator.getLevelFromXP(appStateProvider.userXP);
      
      // Show level-up dialog if level increased
      if (levelAfter > levelBefore) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => LevelUpDialog(
            newLevel: levelAfter,
            currentXP: appStateProvider.userXP,
          ),
        );
      }
    }
  }
}
