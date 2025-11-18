import 'package:flutter/material.dart';
import 'dart:ui';

/// Reusable screen background with blurred underwater image
class ScreenBackground extends StatelessWidget {
  final Widget child;
  final double opacity;
  final double blurAmount;

  const ScreenBackground({
    super.key,
    required this.child,
    this.opacity = 0.3,
    this.blurAmount = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            'assets/screen-bg.png',
            fit: BoxFit.cover,
          ),
        ),
        
        // Blur effect
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: blurAmount,
              sigmaY: blurAmount,
            ),
            child: Container(
              color: Colors.black.withOpacity(opacity),
            ),
          ),
        ),
        
        // Content on top
        child,
      ],
    );
  }
}
