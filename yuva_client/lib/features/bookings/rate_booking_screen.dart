import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers.dart';
import '../../data/models/booking_request.dart';
import '../../data/models/cleaning_service_type.dart';
import '../../data/models/rating.dart';
import '../../design_system/colors.dart';
import '../../design_system/components/yuva_button.dart';
import '../../design_system/components/yuva_card.dart';
import '../../design_system/components/yuva_scaffold.dart';
import '../../design_system/typography.dart';
import '../../l10n/app_localizations.dart';
import '../bookings/booking_providers.dart';
import '../ratings/ratings_providers.dart';

class RateBookingScreen extends ConsumerStatefulWidget {
  final BookingRequest booking;
  final CleaningServiceType? serviceType;
  final Rating? existingRating;

  const RateBookingScreen({
    super.key,
    required this.booking,
    this.serviceType,
    this.existingRating,
  });

  @override
  ConsumerState<RateBookingScreen> createState() => _RateBookingScreenState();
}

class _RateBookingScreenState extends ConsumerState<RateBookingScreen> {
  late int _selectedStars;
  late TextEditingController _commentController;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _selectedStars = widget.existingRating?.ratingValue ?? 5;
    _commentController = TextEditingController(text: widget.existingRating?.comment ?? '');
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateText = DateFormat.yMMMEd(Localizations.localeOf(context).toString())
        .add_Hm()
        .format(widget.booking.dateTime);

    return YuvaScaffold(
      useGradientBackground: true,
      appBar: AppBar(
        title: Text(l10n.rateServiceTitle, style: YuvaTypography.subtitle()),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              YuvaCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          (isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal).withValues(alpha: 0.16),
                      child: Icon(
                        _mapIcon(widget.serviceType?.iconName ?? ''),
                        color: YuvaColors.primaryTealDark,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.serviceType != null
                                ? _localizeService(l10n, widget.serviceType!.titleKey)
                                : l10n.serviceTypeLabel,
                            style: YuvaTypography.subtitle(),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dateText,
                            style: YuvaTypography.caption(color: YuvaColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: (isDark ? YuvaColors.darkSurface : YuvaColors.surfaceCream),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.booking.status == BookingStatus.completed
                            ? l10n.statusCompleted
                            : _localizeStatus(l10n, widget.booking.status),
                        style: YuvaTypography.bodySmall(color: YuvaColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text(l10n.ratingPromptTitle, style: YuvaTypography.title()),
              const SizedBox(height: 6),
              Text(
                l10n.ratingPromptSubtitle,
                style: YuvaTypography.body(color: YuvaColors.textSecondary),
              ),
              const SizedBox(height: 16),
              Center(
                child: Wrap(
                  spacing: 12,
                  children: List.generate(
                    5,
                    (index) {
                      final starValue = index + 1;
                      final isSelected = starValue <= _selectedStars;
                      return _ClayStar(
                        value: starValue,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            _selectedStars = starValue;
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: l10n.ratingOptionalComment,
                  hintText: l10n.ratingCommentHint,
                ),
              ),
              const SizedBox(height: 20),
              YuvaButton(
                text: widget.existingRating == null ? l10n.submitRating : l10n.updateRating,
                isLoading: _submitting,
                onPressed: _submitting ? null : () => _submit(context, l10n),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context, AppLocalizations l10n) async {
    if (_selectedStars == 0) return;
    setState(() {
      _submitting = true;
    });

    final userId = ref.read(currentUserProvider)?.id ?? widget.booking.userId;
    final rating = Rating(
      id: widget.existingRating?.id ?? '',
      bookingId: widget.booking.id,
      userId: userId,
      ratingValue: _selectedStars,
      comment: _commentController.text.trim().isEmpty ? null : _commentController.text.trim(),
      createdAt: DateTime.now(),
    );

    try {
      await ref.read(ratingsRepositoryProvider).submitRating(rating);
      await ref.read(bookingRepositoryProvider).updateBookingHasRating(widget.booking.id, true);
      ref.invalidate(bookingsProvider);
      ref.invalidate(userRatingsProvider);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.ratingSuccess),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.genericError),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

  IconData _mapIcon(String iconName) {
    switch (iconName) {
      case 'cleaning_services':
        return Icons.cleaning_services_rounded;
      case 'auto_awesome':
        return Icons.auto_awesome_rounded;
      case 'moving':
        return Icons.moving_rounded;
      case 'domain':
        return Icons.domain_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  String _localizeService(AppLocalizations l10n, String key) {
    switch (key) {
      case 'serviceStandard':
        return l10n.serviceStandard;
      case 'serviceDeepClean':
        return l10n.serviceDeepClean;
      case 'serviceMoveOut':
        return l10n.serviceMoveOut;
      case 'serviceOffice':
        return l10n.serviceOffice;
      default:
        return key;
    }
  }

  String _localizeStatus(AppLocalizations l10n, BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return l10n.statusPending;
      case BookingStatus.inProgress:
        return l10n.statusInProgress;
      case BookingStatus.completed:
        return l10n.statusCompleted;
      case BookingStatus.cancelled:
        return l10n.statusCancelled;
    }
  }
}

class _ClayStar extends StatefulWidget {
  final int value;
  final bool isSelected;
  final VoidCallback onTap;

  const _ClayStar({
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ClayStar> createState() => _ClayStarState();
}

class _ClayStarState extends State<_ClayStar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _scale = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.value = 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        _controller.forward(from: 0).whenComplete(() => _controller.value = 1);
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? (isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal).withValues(alpha: 0.15)
                : (isDark ? YuvaColors.darkSurface : YuvaColors.surfaceCream),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: isDark ? 0.04 : 0.5),
                blurRadius: 6,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Icon(
            widget.isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
            size: 32,
            color: widget.isSelected ? Colors.amber.shade700 : YuvaColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
