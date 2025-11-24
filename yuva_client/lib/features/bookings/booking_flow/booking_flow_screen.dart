import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yuva/core/providers.dart';
import 'package:yuva/data/models/booking_request.dart';
import 'package:yuva/data/models/cleaning_service_type.dart';
import 'package:yuva/design_system/colors.dart';
import 'package:yuva/design_system/components/yuva_button.dart';
import 'package:yuva/design_system/components/yuva_card.dart';
import 'package:yuva/design_system/components/yuva_chip.dart';
import 'package:yuva/design_system/components/yuva_scaffold.dart';
import 'package:yuva/design_system/typography.dart';
import 'package:yuva/features/bookings/booking_flow/booking_flow_state.dart';
import 'package:yuva/features/bookings/booking_providers.dart';
import 'package:yuva/features/bookings/booking_success_screen.dart';
import 'package:yuva/features/bookings/widgets/booking_summary.dart';
import 'package:yuva/l10n/app_localizations.dart';

class BookingFlowScreen extends ConsumerStatefulWidget {
  const BookingFlowScreen({super.key});

  @override
  ConsumerState<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends ConsumerState<BookingFlowScreen> {
  static const _totalSteps = 6;

  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final draft = ref.watch(bookingDraftProvider);
    final serviceTypesAsync = ref.watch(serviceTypesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return YuvaScaffold(
      useGradientBackground: true,
      appBar: AppBar(
        title: Text(
          l10n.newBooking,
          style: YuvaTypography.subtitle(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: _buildStepHeader(l10n),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildServiceTypeStep(l10n, serviceTypesAsync, draft),
                  _buildPropertyStep(l10n, draft, isDark),
                  _buildFrequencyStep(l10n, draft, isDark),
                  _buildAddressStep(l10n, draft),
                  _buildPriceStep(l10n, draft, isDark),
                  _buildSummaryStep(l10n, draft, isDark),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: _buildBottomActions(l10n, draft),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepHeader(AppLocalizations l10n) {
    final stepLabel = '${_currentStep + 1}/$_totalSteps';
    final titles = [
      l10n.stepChooseService,
      l10n.stepPropertyDetails,
      l10n.stepFrequencyDate,
      l10n.stepAddressNotes,
      l10n.stepPriceEstimate,
      l10n.stepSummary,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(stepLabel, style: YuvaTypography.caption()),
            const SizedBox(height: 6),
            Text(titles[_currentStep], style: YuvaTypography.sectionTitle()),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: YuvaColors.primaryTeal.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      YuvaColors.primaryTeal,
                      YuvaColors.accentGold,
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.progressLabel(stepLabel),
                style: YuvaTypography.bodySmall(color: YuvaColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceTypeStep(
    AppLocalizations l10n,
    AsyncValue<List<CleaningServiceType>> asyncTypes,
    BookingDraft draft,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: asyncTypes.when(
        data: (types) {
          return ListView(
            children: [
              Text(
                l10n.chooseServiceHint,
                style: YuvaTypography.body(color: YuvaColors.textSecondary),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: types.map((type) {
                  final isSelected = draft.serviceType?.id == type.id;
                  return SizedBox(
                    width: 180,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [
                                  YuvaColors.primaryTeal.withValues(alpha: 0.14),
                                  YuvaColors.accentGold.withValues(alpha: 0.08),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                      ),
                      child: YuvaCard(
                        elevated: !isSelected,
                        onTap: () {
                          ref.read(bookingDraftProvider.notifier).selectServiceType(type);
                          _nextStep();
                        },
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: YuvaColors.primaryTeal.withValues(alpha: 0.12),
                              child: Icon(
                                _mapIcon(type.iconName),
                                color: YuvaColors.primaryTealDark,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _localizeServiceTitle(l10n, type.titleKey),
                              style: YuvaTypography.subtitle(),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _localizeServiceDesc(l10n, type.descriptionKey),
                              style: YuvaTypography.bodySmall(color: YuvaColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
      ),
    );
  }

  Widget _buildPropertyStep(AppLocalizations l10n, BookingDraft draft, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        children: [
          Text(l10n.propertyTypeTitle, style: YuvaTypography.subtitle()),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: PropertyType.values.map((type) {
              return YuvaChip(
                label: _localizePropertyType(l10n, type),
                isSelected: draft.propertyType == type,
                icon: _propertyIcon(type),
                onTap: () => ref.read(bookingDraftProvider.notifier).selectPropertyType(type),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text(l10n.sizeCategoryTitle, style: YuvaTypography.subtitle()),
          const SizedBox(height: 12),
          Row(
            children: BookingSizeCategory.values.map((size) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ChoiceChip(
                    label: Text(_localizeSize(l10n, size)),
                    selected: draft.sizeCategory == size,
                    onSelected: (_) => ref.read(bookingDraftProvider.notifier).selectSize(size),
                    labelStyle: YuvaTypography.bodySmall(
                      color: draft.sizeCategory == size ? Colors.white : null,
                    ),
                    selectedColor: YuvaColors.primaryTeal,
                    backgroundColor: isDark ? YuvaColors.darkSurface : YuvaColors.surfaceCream,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildCounter(
                  label: l10n.bedrooms,
                  value: draft.bedrooms,
                  onChanged: (value) =>
                      ref.read(bookingDraftProvider.notifier).updateBedrooms(value),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCounter(
                  label: l10n.bathrooms,
                  value: draft.bathrooms,
                  onChanged: (value) =>
                      ref.read(bookingDraftProvider.notifier).updateBathrooms(value),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencyStep(AppLocalizations l10n, BookingDraft draft, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        children: [
          Text(l10n.frequencyTitle, style: YuvaTypography.subtitle()),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: BookingFrequency.values.map((frequency) {
              return YuvaChip(
                label: _localizeFrequency(l10n, frequency),
                isSelected: draft.frequency == frequency,
                onTap: () => ref.read(bookingDraftProvider.notifier).selectFrequency(frequency),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text(l10n.dateAndTime, style: YuvaTypography.subtitle()),
          const SizedBox(height: 12),
          YuvaCard(
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: draft.dateTime,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 90)),
                locale: Localizations.localeOf(context),
              );
              if (pickedDate == null) return;
              if (!mounted) return;
              final pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(draft.dateTime),
              );
              if (pickedTime == null) return;
              if (!mounted) return;

              final combined = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );
              ref.read(bookingDraftProvider.notifier).updateDateTime(combined);
            },
            child: Row(
              children: [
                Icon(Icons.calendar_month_rounded, color: YuvaColors.primaryTeal),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMEd(Localizations.localeOf(context).toString()).format(draft.dateTime),
                      style: YuvaTypography.body(),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      DateFormat.Hm().format(draft.dateTime),
                      style: YuvaTypography.caption(),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(l10n.durationHours, style: YuvaTypography.subtitle()),
          const SizedBox(height: 12),
          _buildDurationControl(draft, isDark, l10n),
        ],
      ),
    );
  }

  Widget _buildAddressStep(AppLocalizations l10n, BookingDraft draft) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        children: [
          Text(l10n.addressLabel, style: YuvaTypography.subtitle()),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: draft.addressSummary,
            decoration: InputDecoration(
              hintText: l10n.addressPlaceholder,
              fillColor: Colors.white,
              filled: true,
            ),
            onChanged: (value) => ref.read(bookingDraftProvider.notifier).updateAddress(value),
          ),
          const SizedBox(height: 16),
          Text(l10n.notesLabel, style: YuvaTypography.subtitle()),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: draft.notes,
            decoration: InputDecoration(
              hintText: l10n.notesPlaceholder,
              fillColor: Colors.white,
              filled: true,
            ),
            maxLines: 4,
            onChanged: (value) => ref.read(bookingDraftProvider.notifier).updateNotes(value),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceStep(AppLocalizations l10n, BookingDraft draft, bool isDark) {
    final price = draft.estimatedPrice;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        children: [
          Text(l10n.estimatedPriceLabel, style: YuvaTypography.subtitle()),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  YuvaColors.primaryTeal,
                  YuvaColors.primaryTealDark,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: YuvaColors.accentGold.withValues(alpha: 0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  price != null ? '\$${price.toStringAsFixed(2)}' : l10n.pricePending,
                  style: YuvaTypography.title(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.priceDisclaimer,
                  style: YuvaTypography.caption(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          YuvaCard(
            elevated: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.whatAffectsPrice, style: YuvaTypography.subtitle()),
                const SizedBox(height: 8),
                Text(
                  l10n.priceFactors,
                  style: YuvaTypography.bodySmall(
                    color: isDark ? Colors.white70 : YuvaColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStep(
    AppLocalizations l10n,
    BookingDraft draft,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        children: [
          BookingSummary(
            draft: draft,
            l10n: l10n,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(AppLocalizations l10n, BookingDraft draft) {
    final isLastStep = _currentStep == _totalSteps - 1;
    final canContinue = _canContinue(draft);

    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: YuvaButton(
              text: l10n.back,
              buttonStyle: YuvaButtonStyle.ghost,
              onPressed: _prevStep,
            ),
          ),
        if (_currentStep > 0) const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: YuvaButton(
            text: isLastStep ? l10n.confirmBooking : l10n.next,
            onPressed: !canContinue || _isSubmitting
                ? null
                : () {
                    if (isLastStep) {
                      _submitBooking(l10n, draft);
                    } else {
                      _nextStep();
                    }
                  },
            isLoading: _isSubmitting,
          ),
        ),
      ],
    );
  }

  Widget _buildCounter({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return YuvaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: YuvaTypography.body()),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _roundIconButton(
                icon: Icons.remove_rounded,
                onPressed: () => onChanged((value - 1).clamp(0, 10)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: 30,
                  child: Center(
                    child: Text('$value', style: YuvaTypography.subtitle()),
                  ),
                ),
              ),
              _roundIconButton(
                icon: Icons.add_rounded,
                onPressed: () => onChanged((value + 1).clamp(0, 10)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDurationControl(BookingDraft draft, bool isDark, AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? YuvaColors.darkSurface : YuvaColors.surfaceCream,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : YuvaColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Text(l10n.durationHours, style: YuvaTypography.body()),
          const Spacer(),
          _roundIconButton(
            icon: Icons.remove_rounded,
            onPressed: () => ref
                .read(bookingDraftProvider.notifier)
                .updateDuration(draft.durationHours - 0.5),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('${draft.durationHours.toStringAsFixed(1)} h', style: YuvaTypography.subtitle()),
          ),
          _roundIconButton(
            icon: Icons.add_rounded,
            onPressed: () => ref
                .read(bookingDraftProvider.notifier)
                .updateDuration(draft.durationHours + 0.5),
          ),
        ],
      ),
    );
  }

  Widget _roundIconButton({required IconData icon, required VoidCallback onPressed}) {
    return Material(
      color: YuvaColors.surfaceCream,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 18),
        ),
      ),
    );
  }

  bool _canContinue(BookingDraft draft) {
    if (_currentStep == 0) return draft.serviceType != null;
    if (_currentStep == 3) return draft.addressSummary.trim().isNotEmpty;
    if (_currentStep == 4) return draft.estimatedPrice != null;
    return true;
  }

  void _nextStep() {
    if (_currentStep >= _totalSteps - 1) return;
    setState(() => _currentStep++);
    _pageController.animateToPage(
      _currentStep,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  void _prevStep() {
    if (_currentStep == 0) return;
    setState(() => _currentStep--);
    _pageController.animateToPage(
      _currentStep,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _submitBooking(AppLocalizations l10n, BookingDraft draft) async {
    if (draft.serviceType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectServiceFirst)),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final user = ref.read(currentUserProvider);
      final userId = user?.id ?? 'guest';
      final bookingRequest = draft.toBookingRequest(userId: userId);
      final repository = ref.read(bookingRepositoryProvider);
      final booking = await repository.createBooking(bookingRequest);

      ref.invalidate(bookingsProvider);
      ref.read(bookingDraftProvider.notifier).reset();

      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BookingSuccessScreen(
              bookingId: booking.id,
              serviceTypeTitle: _localizeServiceTitle(
                l10n,
                draft.serviceType?.titleKey ?? '',
              ),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
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
        return Icons.home_rounded;
    }
  }

  String _localizeServiceTitle(AppLocalizations l10n, String key) {
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

  String _localizeServiceDesc(AppLocalizations l10n, String key) {
    switch (key) {
      case 'serviceStandardDesc':
        return l10n.serviceStandardDesc;
      case 'serviceDeepCleanDesc':
        return l10n.serviceDeepCleanDesc;
      case 'serviceMoveOutDesc':
        return l10n.serviceMoveOutDesc;
      case 'serviceOfficeDesc':
        return l10n.serviceOfficeDesc;
      default:
        return key;
    }
  }

  String _localizePropertyType(AppLocalizations l10n, PropertyType type) {
    switch (type) {
      case PropertyType.apartment:
        return l10n.propertyApartment;
      case PropertyType.house:
        return l10n.propertyHouse;
      case PropertyType.smallOffice:
        return l10n.propertySmallOffice;
    }
  }

  IconData _propertyIcon(PropertyType type) {
    switch (type) {
      case PropertyType.apartment:
        return Icons.apartment_rounded;
      case PropertyType.house:
        return Icons.house_rounded;
      case PropertyType.smallOffice:
        return Icons.store_mall_directory_rounded;
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
