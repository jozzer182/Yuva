import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/providers.dart';
import '../../../data/models/booking_request.dart';
import '../../../data/models/cleaning_service_type.dart';
import '../../../data/models/job_models.dart';
import '../../../design_system/colors.dart';
import '../../../design_system/components/yuva_button.dart';
import '../../../design_system/components/yuva_card.dart';
import '../../../design_system/components/yuva_chip.dart';
import '../../../design_system/components/yuva_scaffold.dart';
import '../../../design_system/typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../bookings/booking_providers.dart';
import '../job_detail_screen.dart';
import '../job_providers.dart';
import 'job_post_draft.dart';
import 'package:yuva/utils/money_formatter.dart';

class PostJobFlowScreen extends ConsumerStatefulWidget {
  final String? preselectedServiceTypeId;

  const PostJobFlowScreen({super.key, this.preselectedServiceTypeId});

  @override
  ConsumerState<PostJobFlowScreen> createState() => _PostJobFlowScreenState();
}

class _PostJobFlowScreenState extends ConsumerState<PostJobFlowScreen> {
  static const _totalSteps = 5;
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _submitting = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final draft = ref.watch(jobDraftProvider);
    final serviceTypesAsync = ref.watch(serviceTypesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return YuvaScaffold(
      useGradientBackground: true,
      appBar: AppBar(
        title: Text(l10n.postJobTitle, style: YuvaTypography.subtitle()),
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
                  _buildBasicsStep(l10n, draft, serviceTypesAsync, isDark),
                  _buildPropertyStep(l10n, draft, isDark),
                  _buildBudgetStep(l10n, draft, isDark),
                  _buildLocationStep(l10n, draft, isDark),
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
      l10n.jobStepBasics,
      l10n.jobStepProperty,
      l10n.jobStepBudget,
      l10n.jobStepLocation,
      l10n.jobStepSummary,
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

  Widget _buildBasicsStep(
    AppLocalizations l10n,
    JobPostDraft draft,
    AsyncValue<List<CleaningServiceType>> serviceTypesAsync,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: ListView(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: l10n.jobTitleLabel,
              hintText: l10n.jobTitleHint,
            ),
            onChanged: (value) => ref.read(jobDraftProvider.notifier).updateTitle(value),
          ),
          const SizedBox(height: 12),
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              labelText: l10n.jobDescriptionLabel,
              hintText: l10n.jobDescriptionHint,
            ),
            onChanged: (value) => ref.read(jobDraftProvider.notifier).updateDescription(value),
          ),
          const SizedBox(height: 18),
          Text(
            l10n.chooseServiceHint,
            style: YuvaTypography.body(color: YuvaColors.textSecondary),
          ),
          const SizedBox(height: 12),
          serviceTypesAsync.when(
            data: (types) {
              if (widget.preselectedServiceTypeId != null && draft.serviceType == null) {
                final match = types.firstWhere(
                  (element) => element.id == widget.preselectedServiceTypeId,
                  orElse: () => types.first,
                );
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref.read(jobDraftProvider.notifier).selectServiceType(match);
                });
              }
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: types.map((type) {
                  final isSelected = draft.serviceType?.id == type.id;
                  return SizedBox(
                    width: 180,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
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
                        onTap: () => ref.read(jobDraftProvider.notifier).selectServiceType(type),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: YuvaColors.primaryTeal.withValues(alpha: 0.12),
                              child: Icon(
                                _mapServiceIcon(type.iconName),
                                color: YuvaColors.primaryTealDark,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _localizeService(l10n, type.titleKey),
                              style: YuvaTypography.subtitle(),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _localizeService(l10n, type.descriptionKey),
                              style: YuvaTypography.bodySmall(color: YuvaColors.textSecondary),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text(e.toString()),
          ),
          const SizedBox(height: 12),
          if (draft.serviceType == null)
            Text(
              l10n.jobServiceRequired,
              style: YuvaTypography.caption(color: Colors.redAccent),
            ),
        ],
      ),
    );
  }

  Widget _buildPropertyStep(AppLocalizations l10n, JobPostDraft draft, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: ListView(
        children: [
          Text(l10n.jobPropertyTitle, style: YuvaTypography.subtitle()),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: PropertyType.values.map((type) {
              final isSelected = type == draft.propertyType;
              return ChoiceChip(
                label: Text(_localizeProperty(l10n, type)),
                selected: isSelected,
                onSelected: (_) => ref.read(jobDraftProvider.notifier).selectPropertyType(type),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          Text(l10n.jobSizeTitle, style: YuvaTypography.subtitle()),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: BookingSizeCategory.values.map((size) {
              final isSelected = size == draft.sizeCategory;
              return YuvaChip(
                label: _localizeSize(l10n, size),
                isSelected: isSelected,
                onTap: () => ref.read(jobDraftProvider.notifier).selectSize(size),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _buildCounter(l10n.bedrooms, draft.bedrooms, (v) => ref.read(jobDraftProvider.notifier).updateBedrooms(v), isDark)),
              const SizedBox(width: 12),
              Expanded(child: _buildCounter(l10n.bathrooms, draft.bathrooms, (v) => ref.read(jobDraftProvider.notifier).updateBathrooms(v), isDark)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetStep(AppLocalizations l10n, JobPostDraft draft, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: ListView(
        children: [
          Text(l10n.jobBudgetTitle, style: YuvaTypography.subtitle()),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: JobBudgetType.values.map((type) {
              final isSelected = type == draft.budgetType;
              return YuvaChip(
                label: _localizeBudgetType(l10n, type),
                isSelected: isSelected,
                onTap: () => ref.read(jobDraftProvider.notifier).selectBudgetType(type),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          if (draft.budgetType == JobBudgetType.hourly) ...[
            Text(l10n.jobHourlyRangeLabel, style: YuvaTypography.body()),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: l10n.budgetFrom),
                    onChanged: (value) =>
                        ref.read(jobDraftProvider.notifier).updateHourlyRange(from: double.tryParse(value)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: l10n.budgetTo),
                    onChanged: (value) =>
                        ref.read(jobDraftProvider.notifier).updateHourlyRange(to: double.tryParse(value)),
                  ),
                ),
              ],
            ),
          ] else ...[
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.budgetFixedLabel),
              onChanged: (value) =>
                  ref.read(jobDraftProvider.notifier).updateFixedBudget(double.tryParse(value) ?? 0),
            ),
          ],
          const SizedBox(height: 18),
          Text(l10n.jobFrequencyTitle, style: YuvaTypography.subtitle()),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: BookingFrequency.values.map((freq) {
              final isSelected = freq == draft.frequency;
              return YuvaChip(
                label: _localizeFrequency(l10n, freq),
                isSelected: isSelected,
                onTap: () => ref.read(jobDraftProvider.notifier).selectFrequency(freq),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationStep(AppLocalizations l10n, JobPostDraft draft, bool isDark) {
    final locale = Localizations.localeOf(context).toString();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: ListView(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: l10n.jobAreaLabel,
              hintText: l10n.jobAreaHint,
            ),
            onChanged: (value) => ref.read(jobDraftProvider.notifier).updateArea(value),
          ),
          const SizedBox(height: 14),
          Text(l10n.jobPreferredDate, style: YuvaTypography.subtitle()),
          const SizedBox(height: 8),
          YuvaCard(
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: draft.preferredDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 120)),
              );
              if (pickedDate == null) return;
              if (!mounted) return;
              final pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(draft.preferredDate),
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
              ref.read(jobDraftProvider.notifier).updatePreferredDate(combined);
            },
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: (isDark ? YuvaColors.darkSurface : YuvaColors.surfaceCream),
                  child: const Icon(Icons.event_available_rounded, color: YuvaColors.primaryTeal),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat.yMMMd(locale).add_Hm().format(draft.preferredDate),
                        style: YuvaTypography.subtitle(),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.jobPreferredDateHint,
                        style: YuvaTypography.caption(color: YuvaColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStep(AppLocalizations l10n, JobPostDraft draft, bool isDark) {
    final locale = Localizations.localeOf(context).toString();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: ListView(
        children: [
          Text(l10n.jobSummaryTitle, style: YuvaTypography.subtitle()),
          const SizedBox(height: 12),
          YuvaCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _summaryRow(Icons.title_rounded, l10n.jobTitleLabel,
                    draft.title.isEmpty ? l10n.jobTitlePlaceholder : draft.title),
                const SizedBox(height: 8),
                _summaryRow(
                  Icons.cleaning_services_rounded,
                  l10n.serviceTypeLabel,
                  draft.serviceType != null ? _localizeService(l10n, draft.serviceType!.titleKey) : l10n.chooseServiceHint,
                ),
                const SizedBox(height: 8),
                _summaryRow(
                  Icons.home_work_outlined,
                  l10n.jobPropertyTitle,
                  '${_localizeProperty(l10n, draft.propertyType)} · ${_localizeSize(l10n, draft.sizeCategory)} · ${l10n.roomsCount(draft.bedrooms, draft.bathrooms)}',
                ),
                const SizedBox(height: 8),
                _summaryRow(
                  Icons.payments_rounded,
                  l10n.jobBudgetTitle,
                  draft.budgetType == JobBudgetType.hourly
                      ? l10n.budgetRangeLabel(
                          formatAmount(draft.hourlyFrom ?? 0, context),
                          formatAmount(draft.hourlyTo ?? 0, context),
                        )
                      : l10n.fixedPriceLabel(formatAmount(draft.fixedBudget ?? 0, context)),
                ),
                const SizedBox(height: 8),
                _summaryRow(
                  Icons.schedule_rounded,
                  l10n.jobFrequencyTitle,
                  '${_localizeFrequency(l10n, draft.frequency)} · ${DateFormat.yMMMd(locale).format(draft.preferredDate)}',
                ),
                const SizedBox(height: 8),
                _summaryRow(Icons.place_rounded, l10n.jobAreaLabel,
                    draft.areaLabel.isEmpty ? l10n.jobAreaPlaceholder : draft.areaLabel),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(AppLocalizations l10n, JobPostDraft draft) {
    final isLast = _currentStep == _totalSteps - 1;
    final canContinue = _currentStep == 0 ? draft.serviceType != null : true;

    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: YuvaButton(
              text: l10n.back,
              buttonStyle: YuvaButtonStyle.secondary,
              onPressed: _previousStep,
            ),
          ),
        if (_currentStep > 0) const SizedBox(width: 12),
        Expanded(
          child: YuvaButton(
            text: isLast ? l10n.publishJob : l10n.next,
            onPressed: (!canContinue || _submitting) ? null : () => isLast ? _submit(l10n) : _nextStep(),
            isLoading: _submitting,
          ),
        ),
      ],
    );
  }

  Widget _buildCounter(String label, int value, ValueChanged<int> onChanged, bool isDark) {
    return YuvaCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: YuvaTypography.body()),
          Row(
            children: [
              IconButton(
                onPressed: () => onChanged(value - 1),
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$value', style: YuvaTypography.subtitle()),
              IconButton(
                onPressed: () => onChanged(value + 1),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: YuvaColors.primaryTeal),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: YuvaTypography.caption(color: YuvaColors.textSecondary)),
              const SizedBox(height: 4),
              Text(value, style: YuvaTypography.body()),
            ],
          ),
        ),
      ],
    );
  }

  void _nextStep() {
    if (_currentStep >= _totalSteps - 1) return;
    setState(() => _currentStep += 1);
    _pageController.nextPage(duration: const Duration(milliseconds: 220), curve: Curves.easeInOut);
  }

  void _previousStep() {
    if (_currentStep == 0) return;
    setState(() => _currentStep -= 1);
    _pageController.previousPage(duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  Future<void> _submit(AppLocalizations l10n) async {
    final draft = ref.read(jobDraftProvider);
    if (draft.serviceType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.jobServiceRequired)),
      );
      return;
    }
    setState(() => _submitting = true);
    final userId = ref.read(currentUserProvider)?.id ?? 'demo-user';
    final job = draft.toJobPost(userId);

    try {
      final created = await ref.read(jobPostRepositoryProvider).createJobPost(job);
      ref.invalidate(jobPostsProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.jobPublishedSuccess)),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => JobDetailScreen(jobId: created.id)),
      );
      ref.read(jobDraftProvider.notifier).reset();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  IconData _mapServiceIcon(String iconName) {
    switch (iconName) {
      case 'auto_awesome':
        return Icons.auto_awesome_rounded;
      case 'moving':
        return Icons.moving_rounded;
      case 'domain':
        return Icons.domain_rounded;
      default:
        return Icons.cleaning_services_rounded;
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

  String _localizeBudgetType(AppLocalizations l10n, JobBudgetType type) {
    switch (type) {
      case JobBudgetType.hourly:
        return l10n.budgetHourly;
      case JobBudgetType.fixed:
        return l10n.budgetFixed;
    }
  }

  String _localizeFrequency(AppLocalizations l10n, BookingFrequency freq) {
    switch (freq) {
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
