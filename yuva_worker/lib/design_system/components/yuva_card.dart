import 'package:flutter/material.dart';
import '../colors.dart';

/// Clay-style card with soft shadows and elevated appearance.
/// Adds a subtle press animation when [onTap] is provided.
class YuvaCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool elevated;
  final bool pressEffect;

  const YuvaCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.elevated = true,
    this.pressEffect = true,
  });

  @override
  State<YuvaCard> createState() => _YuvaCardState();
}

class _YuvaCardState extends State<YuvaCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedScale(
      scale: _pressed && widget.pressEffect ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? YuvaColors.darkSurface : YuvaColors.surfaceWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: widget.elevated
              ? [
                  BoxShadow(
                    color: isDark ? Colors.black26 : YuvaColors.shadowLight,
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: isDark ? Colors.white.withValues(alpha: 0.05) : YuvaColors.highlightWhite,
                    offset: const Offset(0, -2),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ]
              : null,
          border: !widget.elevated
              ? Border.all(
                  color:
                      isDark ? Colors.white.withValues(alpha: 0.1) : YuvaColors.textTertiary.withValues(alpha: 0.2),
                  width: 1,
                )
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: widget.onTap != null ? (_) => _setPressed(true) : null,
            onTapCancel: widget.onTap != null ? () => _setPressed(false) : null,
            onTapUp: widget.onTap != null ? (_) => _setPressed(false) : null,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: widget.padding ?? const EdgeInsets.all(16),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }

  void _setPressed(bool value) {
    if (widget.pressEffect && _pressed != value) {
      setState(() {
        _pressed = value;
      });
    }
  }
}
