import 'package:flutter/material.dart';
import '../colors.dart';
import '../typography.dart';

enum YuvaButtonStyle { primary, secondary, ghost }

/// Clay-style button with soft shadows and rounded shape
class YuvaButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final YuvaButtonStyle buttonStyle;
  final bool isLoading;
  final IconData? icon;

  const YuvaButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.buttonStyle = YuvaButtonStyle.primary,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color getBackgroundColor() {
      if (onPressed == null) {
        return YuvaColors.textTertiary;
      }
      switch (buttonStyle) {
        case YuvaButtonStyle.primary:
          return isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal;
        case YuvaButtonStyle.secondary:
          return isDark ? YuvaColors.darkAccentGold : YuvaColors.accentGold;
        case YuvaButtonStyle.ghost:
          return Colors.transparent;
      }
    }

    Color getTextColor() {
      if (onPressed == null) {
        return Colors.white70;
      }
      switch (buttonStyle) {
        case YuvaButtonStyle.primary:
        case YuvaButtonStyle.secondary:
          return Colors.white;
        case YuvaButtonStyle.ghost:
          return isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal;
      }
    }

    return Container(
      decoration: buttonStyle != YuvaButtonStyle.ghost
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: onPressed != null
                  ? [
                      BoxShadow(
                        color: YuvaColors.shadowLight,
                        offset: const Offset(0, 4),
                        blurRadius: 12,
                      ),
                      BoxShadow(
                        color: YuvaColors.highlightWhite,
                        offset: const Offset(0, -2),
                        blurRadius: 6,
                      ),
                    ]
                  : null,
            )
          : null,
      child: Material(
        color: getBackgroundColor(),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: .center,
              mainAxisSize: .min,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(getTextColor()),
                    ),
                  )
                else ...[
                  if (icon != null) ...[
                    Icon(icon, color: getTextColor(), size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: YuvaTypography.button(color: getTextColor()),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
