import 'package:flutter/material.dart';
import '../colors.dart';

/// Standard scaffold with optional warm gradient background
class YuvaScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool useGradientBackground;

  const YuvaScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.useGradientBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Container(
        decoration: useGradientBackground
            ? BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          YuvaColors.darkBackground,
                          YuvaColors.darkSurface.withValues(alpha: 0.3),
                        ]
                      : [
                          YuvaColors.backgroundWarm,
                          YuvaColors.backgroundLight,
                        ],
                  stops: const [0.0, 0.7],
                ),
              )
            : null,
        child: body,
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
