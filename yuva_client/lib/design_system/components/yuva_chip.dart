import 'package:flutter/material.dart';
import '../colors.dart';
import '../typography.dart';

/// Clay-style chip for categories and filters
class YuvaChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? icon;

  const YuvaChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isSelected
        ? (isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal)
        : (isDark ? YuvaColors.darkSurface : YuvaColors.surfaceCream);

    final textColor = isSelected
        ? Colors.white
        : (isDark ? Colors.white70 : YuvaColors.textPrimary);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal)
                        .withValues(alpha: 0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ]
              : [
                  BoxShadow(
                    color: isDark
                        ? Colors.black26
                        : YuvaColors.shadowLight.withValues(alpha: 0.5),
                    offset: const Offset(0, 2),
                    blurRadius: 6,
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: textColor),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: YuvaTypography.bodySmall(color: textColor).copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
