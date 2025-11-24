import 'package:flutter/material.dart';
import 'package:yuva/design_system/colors.dart';
import 'package:yuva/design_system/components/yuva_button.dart';
import 'package:yuva/design_system/components/yuva_scaffold.dart';
import 'package:yuva/design_system/typography.dart';
import 'package:yuva/l10n/app_localizations.dart';

class BookingSuccessScreen extends StatefulWidget {
  final String bookingId;
  final String serviceTypeTitle;

  const BookingSuccessScreen({
    super.key,
    required this.bookingId,
    required this.serviceTypeTitle,
  });

  @override
  State<BookingSuccessScreen> createState() => _BookingSuccessScreenState();
}

class _BookingSuccessScreenState extends State<BookingSuccessScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.8,
      upperBound: 1.05,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return YuvaScaffold(
      useGradientBackground: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _controller,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        YuvaColors.primaryTeal,
                        YuvaColors.accentGold,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isDark ? Colors.black45 : YuvaColors.shadowLight).withValues(alpha: 0.6),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 80,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                l10n.bookingSuccessTitle,
                style: YuvaTypography.title(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.bookingSuccessSubtitle(widget.serviceTypeTitle),
                style: YuvaTypography.body(color: YuvaColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              YuvaButton(
                text: l10n.viewMyBookings,
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.settings.name == '/main' || route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
