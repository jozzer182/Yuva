import 'package:flutter/material.dart';
import '../colors.dart';
import '../typography.dart';

enum YuvaChipStyle { primary, secondary, accent, neutral }

/// Small chip component for tags and labels
class YuvaChip extends StatelessWidget {
  final String label;
  final YuvaChipStyle chipStyle;
  final IconData? icon;

  const YuvaChip({
    super.key,
    required this.label,
    this.chipStyle = YuvaChipStyle.neutral,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color getBackgroundColor() {
      switch (chipStyle) {
        case YuvaChipStyle.primary:
          return isDark
              ? YuvaColors.darkPrimaryTeal.withValues(alpha: 0.2)
              : YuvaColors.primaryTealLight.withValues(alpha: 0.3);
        case YuvaChipStyle.secondary:
          return isDark
              ? YuvaColors.darkAccentGold.withValues(alpha: 0.2)
              : YuvaColors.accentGoldLight.withValues(alpha: 0.3);
        case YuvaChipStyle.accent:
          return YuvaColors.accentGold.withValues(alpha: 0.15);
        case YuvaChipStyle.neutral:
          return isDark
              ? YuvaColors.textSecondary.withValues(alpha: 0.2)
              : YuvaColors.textTertiary.withValues(alpha: 0.2);
      }
    }

    Color getTextColor() {
      switch (chipStyle) {
        case YuvaChipStyle.primary:
          return isDark ? YuvaColors.primaryTealLight : YuvaColors.primaryTealDark;
        case YuvaChipStyle.secondary:
          return isDark ? YuvaColors.accentGoldLight : YuvaColors.accentGoldDark;
        case YuvaChipStyle.accent:
          return YuvaColors.accentGoldDark;
        case YuvaChipStyle.neutral:
          return isDark ? Colors.white70 : YuvaColors.textSecondary;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: getBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: getTextColor()),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: YuvaTypography.caption(color: getTextColor()).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
