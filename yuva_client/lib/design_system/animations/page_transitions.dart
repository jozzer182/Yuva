import 'package:flutter/material.dart';

/// Custom page route with smooth slide and fade transitions
class YuvaPageRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;
  final RouteSettings? routeSettings;

  YuvaPageRoute({
    required this.builder,
    this.routeSettings,
  }) : super(settings: routeSettings);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 250);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0.03, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeOutCubic;

    final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    final offsetAnimation = animation.drive(tween);

    final fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(
      CurveTween(curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
    );
    final fadeAnimation = animation.drive(fadeTween);

    return SlideTransition(
      position: offsetAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: child,
      ),
    );
  }
}

/// Utility extension for easy navigation with yuva animations
extension NavigatorExtensions on BuildContext {
  Future<T?> pushYuva<T>(Widget screen) {
    return Navigator.of(this).push<T>(
      YuvaPageRoute<T>(builder: (_) => screen),
    );
  }
}
