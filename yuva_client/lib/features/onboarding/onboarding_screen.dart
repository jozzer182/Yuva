import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/components/yuva_button.dart';
import '../../core/responsive.dart';
import 'package:yuva/l10n/app_localizations.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
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
                : [YuvaColors.backgroundWarm, YuvaColors.primaryTealLight.withValues(alpha: 0.1)],
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
                          'Saltar',
                          style: YuvaTypography.body(
                            color: isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      children: [
                        _buildPage(
                          context,
                          title: l10n.onboardingTitle1,
                          description: l10n.onboardingDesc1,
                          icon: Icons.auto_awesome_rounded,
                          color: YuvaColors.primaryTealLight,
                        ),
                        _buildPage(
                          context,
                          title: l10n.onboardingTitle2,
                          description: l10n.onboardingDesc2,
                          icon: Icons.access_time_rounded,
                          color: YuvaColors.accentGold,
                        ),
                        _buildPage(
                          context,
                          title: l10n.onboardingTitle3,
                          description: l10n.onboardingDesc3,
                          icon: Icons.cleaning_services_rounded,
                          color: YuvaColors.primaryTealLight,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: ResponsiveUtils.padding(context),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            3,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentPage == index ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _currentPage == index
                                    ? (isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal)
                                    : (isDark ? Colors.white24 : YuvaColors.textTertiary),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: YuvaButton(
                            text: _currentPage == 2 ? l10n.getStarted : l10n.next,
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

  Widget _buildPage(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 60,
              color: color,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            title,
            style: YuvaTypography.title(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: YuvaTypography.body(color: YuvaColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
