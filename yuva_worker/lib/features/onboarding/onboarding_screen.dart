import 'package:flutter/material.dart';
import 'package:yuva_worker/l10n/app_localizations.dart';
import '../../design_system/colors.dart';
import '../../design_system/components/yuva_button.dart';
import '../../core/responsive.dart';

/// Onboarding screen for worker app with 3 pages
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to auth
      Navigator.of(context).pushReplacementNamed('/auth');
    }
  }

  void _skip() {
    Navigator.of(context).pushReplacementNamed('/auth');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [YuvaColors.darkBackground, YuvaColors.darkSurface]
                : [YuvaColors.backgroundWarm, YuvaColors.backgroundLight],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveUtils.isTablet(context) || ResponsiveUtils.isLargeTablet(context)
                    ? 800
                    : double.infinity,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: ResponsiveUtils.horizontalPadding(context),
                      child: TextButton(
                        onPressed: _skip,
                        child: Text(
                          l10n.skip,
                          style: TextStyle(
                            color: isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      children: [
                        _OnboardingPage(
                          icon: Icons.location_on,
                          iconColor: YuvaColors.primaryTeal,
                          title: l10n.onboardingWorkerTitle1,
                          description: l10n.onboardingWorkerDesc1,
                        ),
                        _OnboardingPage(
                          icon: Icons.attach_money,
                          iconColor: YuvaColors.accentGold,
                          title: l10n.onboardingWorkerTitle2,
                          description: l10n.onboardingWorkerDesc2,
                        ),
                        _OnboardingPage(
                          icon: Icons.star,
                          iconColor: YuvaColors.primaryTeal,
                          title: l10n.onboardingWorkerTitle3,
                          description: l10n.onboardingWorkerDesc3,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: ResponsiveUtils.padding(context),
                    child: Column(
                      children: [
                        // Page indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentPage == index ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _currentPage == index
                                    ? YuvaColors.primaryTeal
                                    : YuvaColors.textTertiary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 24),
                        // Next/Get Started button
                        SizedBox(
                          width: double.infinity,
                          child: YuvaButton(
                            text: _currentPage < 2 ? l10n.next : l10n.createMyProfile,
                            onPressed: _nextPage,
                          ),
                        ),
                      ],
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

class _OnboardingPage extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  const _OnboardingPage({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: .center,
        children: [
          // Icon container with clay styling
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : YuvaColors.shadowLight,
                  offset: const Offset(0, 8),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 72,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            title,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: isDark ? Colors.white : YuvaColors.textPrimary,
                ),
            textAlign: .center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isDark ? Colors.white70 : YuvaColors.textSecondary,
                ),
            textAlign: .center,
          ),
        ],
      ),
    );
  }
}
