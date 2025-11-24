import 'package:flutter/material.dart';
import '../colors.dart';

/// Puffy icon container with clay style - perfect for service icons
class YuvaIconContainer extends StatelessWidget {
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;

  const YuvaIconContainer({
    super.key,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = backgroundColor ??
        (isDark ? YuvaColors.darkSurface : YuvaColors.surfaceCream);
    final iColor = iconColor ??
        (isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(size * 0.3),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black38 : YuvaColors.shadowLight,
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : YuvaColors.highlightWhite,
            offset: const Offset(0, -2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          color: iColor,
          size: size * 0.5,
        ),
      ),
    );
  }
}
