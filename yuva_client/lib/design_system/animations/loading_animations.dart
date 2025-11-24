import 'package:flutter/material.dart';
import '../colors.dart';

/// Animated loading indicator with yuva branding
class YuvaLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;

  const YuvaLoadingIndicator({
    super.key,
    this.size = 40,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final indicatorColor = color ??
        (isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal);

    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
      ),
    );
  }
}

/// Animated success checkmark with scale animation
class YuvaSuccessIndicator extends StatefulWidget {
  final double size;
  final Color? color;

  const YuvaSuccessIndicator({
    super.key,
    this.size = 60,
    this.color,
  });

  @override
  State<YuvaSuccessIndicator> createState() => _YuvaSuccessIndicatorState();
}

class _YuvaSuccessIndicatorState extends State<YuvaSuccessIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final successColor = widget.color ?? YuvaColors.success;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: successColor.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _checkAnimation,
            builder: (context, child) {
              return Icon(
                Icons.check_rounded,
                size: widget.size * 0.6,
                color: successColor,
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Shimmer effect for loading skeletons
class YuvaShimmer extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const YuvaShimmer({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<YuvaShimmer> createState() => _YuvaShimmerState();
}

class _YuvaShimmerState extends State<YuvaShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      Colors.white.withValues(alpha: 0.05),
                      Colors.white.withValues(alpha: 0.15),
                      Colors.white.withValues(alpha: 0.05),
                    ]
                  : [
                      Colors.black.withValues(alpha: 0.03),
                      Colors.black.withValues(alpha: 0.08),
                      Colors.black.withValues(alpha: 0.03),
                    ],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
