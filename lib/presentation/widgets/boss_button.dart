import 'package:flutter/material.dart';
import 'package:big_boss_fishing/core/theme/app_colors.dart';
import 'package:big_boss_fishing/core/theme/text_styles.dart';
import 'package:big_boss_fishing/core/utils/haptic_utils.dart';

/// BossButton - Primary gradient button with shadow and haptic feedback
class BossButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final String? iconPath; // Custom asset path
  final bool isSecondary;
  final double? width;
  final double height;

  const BossButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.iconPath,
    this.isSecondary = false,
    this.width,
    this.height = 56.0,
  });

  @override
  State<BossButton> createState() => _BossButtonState();
}

class _BossButtonState extends State<BossButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.isDisabled && !widget.isLoading) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (!widget.isDisabled && !widget.isLoading) {
      _controller.reverse();
    }
  }

  void _onTapCancel() {
    if (!widget.isDisabled && !widget.isLoading) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.isDisabled || widget.isLoading;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: isDisabled ? null : () {
        HapticUtils.lightImpact(context);
        widget.onPressed();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: isDisabled
                ? LinearGradient(
                    colors: [
                      AppColors.textSecondary.withOpacity(0.5),
                      AppColors.textSecondary.withOpacity(0.3),
                    ],
                  )
                : widget.isSecondary
                    ? AppColors.secondaryGradient
                    : AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isDisabled
                ? []
                : [
                    BoxShadow(
                      color: widget.isSecondary
                          ? AppColors.accentOrange.withOpacity(0.3)
                          : AppColors.deepNavy.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.textLight,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            color: AppColors.textLight,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (widget.iconPath != null) ...[
                          Image.asset(
                            widget.iconPath!,
                            width: 20,
                            height: 20,
                            color: AppColors.textLight,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.text,
                          style: AppTextStyles.button.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// BossOutlineButton - Secondary outline button
class BossOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final String? iconPath; // Custom asset path
  final double? width;
  final double height;

  const BossOutlineButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.iconPath,
    this.width,
    this.height = 56.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.deepNavy,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: AppColors.deepNavy,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                ],
                if (iconPath != null) ...[
                  Image.asset(
                    iconPath!,
                    width: 20,
                    height: 20,
                    color: AppColors.deepNavy,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.deepNavy,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// BossIconButton - Circular icon button with gradient background
class BossIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final bool isSecondary;

  const BossIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 48.0,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: isSecondary
            ? AppColors.secondaryGradient
            : AppColors.primaryGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: isSecondary
                ? AppColors.accentOrange.withOpacity(0.3)
                : AppColors.deepNavy.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Center(
            child: Icon(
              icon,
              color: AppColors.textLight,
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
