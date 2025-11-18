import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';

/// Utility class for haptic feedback that respects user settings
class HapticUtils {
  /// Light impact haptic (for taps, selections)
  static void lightImpact(BuildContext context) {
    final provider = Provider.of<AppStateProvider>(context, listen: false);
    if (provider.hapticsEnabled) {
      HapticFeedback.lightImpact();
    }
  }

  /// Medium impact haptic (for confirmations, deletions)
  static void mediumImpact(BuildContext context) {
    final provider = Provider.of<AppStateProvider>(context, listen: false);
    if (provider.hapticsEnabled) {
      HapticFeedback.mediumImpact();
    }
  }

  /// Heavy impact haptic (for achievements, level ups)
  static void heavyImpact(BuildContext context) {
    final provider = Provider.of<AppStateProvider>(context, listen: false);
    if (provider.hapticsEnabled) {
      HapticFeedback.heavyImpact();
    }
  }

  /// Selection click (for sliders, pickers)
  static void selectionClick(BuildContext context) {
    final provider = Provider.of<AppStateProvider>(context, listen: false);
    if (provider.hapticsEnabled) {
      HapticFeedback.selectionClick();
    }
  }

  /// Vibrate pattern (for errors)
  static void vibrate(BuildContext context) {
    final provider = Provider.of<AppStateProvider>(context, listen: false);
    if (provider.hapticsEnabled) {
      HapticFeedback.vibrate();
    }
  }
}
