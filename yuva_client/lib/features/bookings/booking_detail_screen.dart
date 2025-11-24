import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yuva/data/models/booking_request.dart';
import 'package:yuva/data/models/cleaning_service_type.dart';
import 'package:yuva/design_system/colors.dart';
import 'package:yuva/design_system/components/yuva_card.dart';
import 'package:yuva/design_system/components/yuva_scaffold.dart';
import 'package:yuva/design_system/typography.dart';
import 'package:yuva/l10n/app_localizations.dart';

class BookingDetailScreen extends StatelessWidget {
  final BookingRequest booking;
  final CleaningServiceType? serviceType;

  const BookingDetailScreen({
    super.key,
    required this.booking,
    required this.serviceType,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateText = DateFormat.yMMMEd(Localizations.localeOf(context).toString())
        .add_Hm()
        .format(booking.dateTime);

    return YuvaScaffold(
      useGradientBackground: true,
      appBar: AppBar(
        title: Text(l10n.bookingDetailTitle, style: YuvaTypography.subtitle()),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              YuvaCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              (isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal).withValues(alpha: 0.18),
                          child: Icon(
                            _mapIcon(serviceType?.iconName ?? ''),
                            color: isDark ? Colors.white : YuvaColors.primaryTealDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                serviceType != null
                                    ? _localizeService(l10n, serviceType!.titleKey)
                                    : l10n.serviceTypeLabel,
                                style: YuvaTypography.subtitle(),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                dateText,
                                style: YuvaTypography.caption(),
                              ),
                            ],
                          ),
                        ),
                        _statusChip(l10n, booking.status, isDark),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      booking.notes ?? l10n.noNotesPlaceholder,
                      style: YuvaTypography.body(color: YuvaColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              YuvaCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow(
                      icon: Icons.repeat_rounded,
                      label: l10n.frequencyLabel,
                      value: _localizeFrequency(l10n, booking.frequency),
                    ),
                    _infoRow(
                      icon: Icons.timer_outlined,
                      label: l10n.durationLabel,
                      value: '${booking.durationHours.toStringAsFixed(1)} h',
                    ),
                    _infoRow(
                      icon: Icons.home_work_outlined,
                      label: l10n.propertyTypeTitle,
                      value:
                          '${_localizeProperty(l10n, booking.propertyType)} / ${_localizeSize(l10n, booking.sizeCategory)}',
                    ),
                    _infoRow(
                      icon: Icons.bed_rounded,
                      label: l10n.roomsLabel,
                      value: l10n.roomsCount(booking.bedrooms, booking.bathrooms),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              YuvaCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow(
                      icon: Icons.place_rounded,
                      label: l10n.addressLabel,
                      value: booking.addressSummary,
                    ),
                    _infoRow(
                      icon: Icons.attach_money_rounded,
                      label: l10n.estimatedPriceLabel,
                      value: '\$${booking.estimatedPrice.toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              YuvaCard(
                elevated: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.assignedCleanerPlaceholder, style: YuvaTypography.subtitle()),
                    const SizedBox(height: 8),
                    Text(
                      l10n.assignedCleanerHint,
                      style: YuvaTypography.bodySmall(color: YuvaColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: YuvaColors.textSecondary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: YuvaTypography.caption()),
                const SizedBox(height: 4),
                Text(value, style: YuvaTypography.body()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(AppLocalizations l10n, BookingStatus status, bool isDark) {
    Color background;
    Color textColor;
    switch (status) {
      case BookingStatus.pending:
        background = YuvaColors.accentGold.withValues(alpha: 0.2);
        textColor = YuvaColors.accentGoldDark;
        break;
      case BookingStatus.inProgress:
        background = YuvaColors.primaryTeal.withValues(alpha: 0.2);
        textColor = YuvaColors.primaryTealDark;
        break;
      case BookingStatus.completed:
        background = YuvaColors.success.withValues(alpha: 0.2);
        textColor = Colors.green.shade700;
        break;
      case BookingStatus.cancelled:
        background = YuvaColors.error.withValues(alpha: 0.18);
        textColor = YuvaColors.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        _localizeStatus(l10n, status),
        style: YuvaTypography.bodySmall(
          color: textColor,
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

  String _localizeSize(AppLocalizations l10n, BookingSizeCategory size) {
    switch (size) {
      case BookingSizeCategory.small:
        return l10n.sizeSmall;
      case BookingSizeCategory.medium:
        return l10n.sizeMedium;
      case BookingSizeCategory.large:
        return l10n.sizeLarge;
    }
  }

  String _localizeFrequency(AppLocalizations l10n, BookingFrequency frequency) {
    switch (frequency) {
      case BookingFrequency.once:
        return l10n.frequencyOnce;
      case BookingFrequency.weekly:
        return l10n.frequencyWeekly;
      case BookingFrequency.biweekly:
        return l10n.frequencyBiweekly;
      case BookingFrequency.monthly:
        return l10n.frequencyMonthly;
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
