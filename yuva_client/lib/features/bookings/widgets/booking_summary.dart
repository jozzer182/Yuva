import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yuva/utils/money_formatter.dart';
import 'package:yuva/data/models/booking_request.dart';
import 'package:yuva/design_system/colors.dart';
import 'package:yuva/design_system/components/yuva_card.dart';
import 'package:yuva/design_system/typography.dart';
import 'package:yuva/features/bookings/booking_flow/booking_flow_state.dart';
import 'package:yuva/l10n/app_localizations.dart';

class BookingSummary extends StatelessWidget {
  final BookingDraft draft;
  final AppLocalizations l10n;
  final bool isDark;

  const BookingSummary({
    super.key,
    required this.draft,
    required this.l10n,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final dateText = DateFormat.yMMMEd(Localizations.localeOf(context).toString())
        .add_Hm()
        .format(draft.dateTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.summaryTitle, style: YuvaTypography.subtitle()),
        const SizedBox(height: 12),
        YuvaCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoRow(
                icon: Icons.auto_awesome_rounded,
                label: l10n.serviceTypeLabel,
                value: _localizeService(l10n, draft.serviceType?.titleKey ?? ''),
              ),
              _infoRow(
                icon: Icons.home_work_outlined,
                label: l10n.propertyTypeTitle,
                value:
                    '${_localizeProperty(l10n, draft.propertyType)} / ${_localizeSize(l10n, draft.sizeCategory)}',
              ),
              _infoRow(
                icon: Icons.calendar_today_rounded,
                label: l10n.dateLabel,
                value: dateText,
              ),
              _infoRow(
                icon: Icons.repeat_rounded,
                label: l10n.frequencyLabel,
                value: _localizeFrequency(l10n, draft.frequency),
              ),
              _infoRow(
                icon: Icons.bed_rounded,
                label: l10n.roomsLabel,
                value: l10n.roomsCount(draft.bedrooms, draft.bathrooms),
              ),
              _infoRow(
                icon: Icons.timer_rounded,
                label: l10n.durationLabel,
                value: '${draft.durationHours.toStringAsFixed(1)} h',
              ),
              if (draft.addressSummary.isNotEmpty)
                _infoRow(
                  icon: Icons.place_rounded,
                  label: l10n.addressLabel,
                  value: draft.addressSummary,
                ),
              if (draft.notes.isNotEmpty)
                _infoRow(
                  icon: Icons.sticky_note_2_rounded,
                  label: l10n.notesLabel,
                  value: draft.notes,
                ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: YuvaColors.accentGold.withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.estimatedPriceLabel,
                      style: YuvaTypography.body(color: Colors.white70),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      draft.estimatedPrice != null
                          ? '\$${formatAmount(draft.estimatedPrice!, context)}'
                          : l10n.pricePending,
                      style: YuvaTypography.title(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: isDark ? Colors.white70 : YuvaColors.textSecondary),
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
}
