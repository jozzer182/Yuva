import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yuva/data/models/booking_request.dart';
import 'package:yuva/data/models/cleaning_service_type.dart';
import 'package:yuva/data/models/rating.dart';
import 'package:yuva/design_system/colors.dart';
import 'package:yuva/design_system/components/yuva_button.dart';
import 'package:yuva/design_system/components/yuva_card.dart';
import 'package:yuva/design_system/components/yuva_scaffold.dart';
import 'package:yuva/design_system/typography.dart';
import 'package:yuva/features/bookings/booking_detail_screen.dart';
import 'package:yuva/features/bookings/booking_flow/booking_flow_screen.dart';
import 'package:yuva/features/bookings/booking_providers.dart';
import 'package:yuva/features/bookings/rate_booking_screen.dart';
import 'package:yuva/features/ratings/ratings_providers.dart';
import 'package:yuva/l10n/app_localizations.dart';

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final bookingsAsync = ref.watch(bookingsProvider);
    final serviceTypesAsync = ref.watch(serviceTypesProvider);
    final ratingsAsync = ref.watch(userRatingsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return YuvaScaffold(
      useGradientBackground: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.myBookings, style: YuvaTypography.title()),
                  YuvaButton(
                    text: l10n.newBooking,
                    icon: Icons.add_rounded,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const BookingFlowScreen()),
                      );
                    },
                    buttonStyle: YuvaButtonStyle.secondary,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                l10n.bookingSubtitle,
                style: YuvaTypography.body(color: YuvaColors.textSecondary),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: bookingsAsync.when(
                  data: (bookings) => serviceTypesAsync.when(
                    data: (types) => ratingsAsync.when(
                      data: (ratings) =>
                          _buildSections(context, l10n, bookings, types, isDark, ratings),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, _) => Center(child: Text(error.toString())),
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Center(child: Text(error.toString())),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(child: Text(error.toString())),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSections(
    BuildContext context,
    AppLocalizations l10n,
    List<BookingRequest> bookings,
    List<CleaningServiceType> serviceTypes,
    bool isDark,
    List<Rating> ratings,
  ) {
    if (bookings.isEmpty) {
      return _emptyState(context, l10n);
    }

    final ratingMap = {
      for (final rating in ratings.where((rating) => rating.bookingId != null)) rating.bookingId!: rating
    };
    final now = DateTime.now();
    final upcoming = bookings.where((b) => !b.dateTime.isBefore(now)).toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    final past = bookings.where((b) => b.dateTime.isBefore(now)).toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return ListView(
      children: [
        if (upcoming.isNotEmpty) ...[
          Text(l10n.upcomingBookings, style: YuvaTypography.sectionTitle()),
          const SizedBox(height: 12),
          ...upcoming.map(
            (booking) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _bookingCard(
                context,
                l10n,
                booking,
                serviceTypes,
                isDark,
                ratingMap[booking.id],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (past.isNotEmpty) ...[
          Text(l10n.pastBookings, style: YuvaTypography.sectionTitle()),
          const SizedBox(height: 12),
          ...past.map(
            (booking) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _bookingCard(
                context,
                l10n,
                booking,
                serviceTypes,
                isDark,
                ratingMap[booking.id],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _bookingCard(
    BuildContext context,
    AppLocalizations l10n,
    BookingRequest booking,
    List<CleaningServiceType> serviceTypes,
    bool isDark,
    Rating? rating,
  ) {
    final type = serviceTypes.firstWhere(
      (element) => element.id == booking.serviceTypeId,
      orElse: () => CleaningServiceType(
        id: 'unknown',
        titleKey: 'serviceTypeLabel',
        descriptionKey: '',
        iconName: 'cleaning_services',
        baseRate: 0,
      ),
    );
    final dateText = DateFormat.MMMd(Localizations.localeOf(context).toString()).format(booking.dateTime);
    final timeText = DateFormat.Hm().format(booking.dateTime);
    final hasRating = rating != null || booking.hasRating;

    return YuvaCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BookingDetailScreen(
              booking: booking,
              serviceType: type,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: (isDark ? YuvaColors.darkSurface : YuvaColors.surfaceCream),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _mapIcon(type.iconName),
                  color: YuvaColors.primaryTeal,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${dateText.toUpperCase()} • $timeText', style: YuvaTypography.caption()),
                    const SizedBox(height: 6),
                    Text(_localizeService(l10n, type.titleKey), style: YuvaTypography.subtitle()),
                  ],
                ),
              ),
              _statusChip(l10n, booking.status),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.attach_money_rounded, size: 18, color: YuvaColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                '\$${booking.estimatedPrice.toStringAsFixed(2)}',
                style: YuvaTypography.body(),
              ),
              const Spacer(),
              Text(
                _localizeProperty(l10n, booking.propertyType),
                style: YuvaTypography.bodySmall(color: YuvaColors.textSecondary),
              ),
            ],
          ),
          if (booking.status == BookingStatus.completed) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: (isDark ? YuvaColors.darkSurface : YuvaColors.surfaceCream).withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(
                    hasRating ? Icons.star_rounded : Icons.star_border_rounded,
                    color: hasRating ? Colors.amber.shade700 : YuvaColors.textSecondary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: hasRating
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.bookingRatedLabel(
                                  rating?.ratingValue.toString() ?? '5',
                                ),
                                style: YuvaTypography.subtitle(),
                              ),
                              if (rating?.comment != null && rating!.comment!.isNotEmpty)
                                Text(
                                  rating.comment!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: YuvaTypography.caption(color: YuvaColors.textSecondary),
                                ),
                            ],
                          )
                        : Text(
                            l10n.bookingAwaitingRating,
                            style: YuvaTypography.bodySmall(color: YuvaColors.textSecondary),
                          ),
                  ),
                  const SizedBox(width: 8),
                  YuvaButton(
                    text: hasRating ? l10n.viewRating : l10n.rateNow,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RateBookingScreen(
                            booking: booking,
                            serviceType: type,
                            existingRating: rating,
                          ),
                        ),
                      );
                    },
                    buttonStyle: hasRating ? YuvaButtonStyle.ghost : YuvaButtonStyle.secondary,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _statusChip(AppLocalizations l10n, BookingStatus status) {
    Color? bg;
    Color? text;
    switch (status) {
      case BookingStatus.pending:
        bg = YuvaColors.accentGold.withValues(alpha: 0.2);
        text = YuvaColors.accentGoldDark;
        break;
      case BookingStatus.inProgress:
        bg = YuvaColors.primaryTeal.withValues(alpha: 0.2);
        text = YuvaColors.primaryTealDark;
        break;
      case BookingStatus.completed:
        bg = YuvaColors.success.withValues(alpha: 0.2);
        text = Colors.green.shade700;
        break;
      case BookingStatus.cancelled:
        bg = YuvaColors.error.withValues(alpha: 0.18);
        text = YuvaColors.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        _localizeStatus(l10n, status),
        style: YuvaTypography.caption(color: text),
      ),
    );
  }

  Widget _emptyState(BuildContext context, AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: isDark ? YuvaColors.darkSurface.withValues(alpha: 0.5) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : YuvaColors.shadowLight,
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: (isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTealLight).withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_today_rounded,
                size: 40,
                color: isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.noBookingsYet,
              style: YuvaTypography.subtitle(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.noBookingsDescription,
              style: YuvaTypography.body(color: YuvaColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            YuvaButton(
              text: l10n.newBooking,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const BookingFlowScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
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
        return Icons.home_rounded;
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

  String _localizeProperty(AppLocalizations l10n, PropertyType type) {
    switch (type) {
      case PropertyType.apartment:
        return l10n.propertyApartment;
      case PropertyType.house:
        return l10n.propertyHouse;
      case PropertyType.smallOffice:
        return l10n.propertySmallOffice;
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
