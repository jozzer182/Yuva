import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers.dart';
import '../../data/models/booking_request.dart';
import '../../data/models/job_models.dart';
import '../../data/repositories/job_post_repository.dart';
import '../../design_system/colors.dart';
import '../../design_system/components/yuva_button.dart';
import '../../design_system/components/yuva_card.dart';
import '../../design_system/components/yuva_chip.dart';
import '../../design_system/components/yuva_scaffold.dart';
import '../../design_system/typography.dart';
import '../../l10n/app_localizations.dart';
import '../bookings/booking_providers.dart';
import 'job_providers.dart';

/// Screen for editing an existing job post.
/// Only accessible when job.canClientModify is true.
class EditJobScreen extends ConsumerStatefulWidget {
  final JobPost job;

  const EditJobScreen({super.key, required this.job});

  @override
  ConsumerState<EditJobScreen> createState() => _EditJobScreenState();
}

class _EditJobScreenState extends ConsumerState<EditJobScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _areaController;
  late TextEditingController _hourlyFromController;
  late TextEditingController _hourlyToController;
  late TextEditingController _fixedBudgetController;

  late String _serviceTypeId;
  late PropertyType _propertyType;
  late BookingSizeCategory _sizeCategory;
  late int _bedrooms;
  late int _bathrooms;
  late JobBudgetType _budgetType;
  late BookingFrequency _frequency;
  late DateTime _preferredDate;

  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final job = widget.job;
    _titleController = TextEditingController(text: job.customTitle ?? '');
    _descriptionController = TextEditingController(text: job.customDescription ?? '');
    _areaController = TextEditingController(text: job.areaLabel);
    _hourlyFromController = TextEditingController(
      text: job.hourlyRateFrom?.toStringAsFixed(0) ?? '',
    );
    _hourlyToController = TextEditingController(
      text: job.hourlyRateTo?.toStringAsFixed(0) ?? '',
    );
    _fixedBudgetController = TextEditingController(
      text: job.fixedBudget?.toStringAsFixed(0) ?? '',
    );

    _serviceTypeId = job.serviceTypeId;
    _propertyType = job.propertyDetails.type;
    _sizeCategory = job.propertyDetails.sizeCategory;
    _bedrooms = job.propertyDetails.bedrooms;
    _bathrooms = job.propertyDetails.bathrooms;
    _budgetType = job.budgetType;
    _frequency = job.frequency;
    _preferredDate = job.preferredStartDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _areaController.dispose();
    _hourlyFromController.dispose();
    _hourlyToController.dispose();
    _fixedBudgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final serviceTypesAsync = ref.watch(serviceTypesProvider);

    return YuvaScaffold(
      useGradientBackground: true,
      appBar: AppBar(
        title: Text(l10n.editJobTitle, style: YuvaTypography.subtitle()),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title & Description
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: l10n.jobTitleLabel,
                        hintText: l10n.jobTitleHint,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: l10n.jobDescriptionLabel,
                        hintText: l10n.jobDescriptionHint,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Service Type
                    Text(l10n.chooseServiceHint, style: YuvaTypography.subtitle()),
                    const SizedBox(height: 12),
                    serviceTypesAsync.when(
                      data: (types) => Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: types.map((type) {
                          final isSelected = _serviceTypeId == type.id;
                          return YuvaChip(
                            label: _localizeService(l10n, type.titleKey),
                            isSelected: isSelected,
                            onTap: () => setState(() => _serviceTypeId = type.id),
                          );
                        }).toList(),
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (e, _) => Text(e.toString()),
                    ),
                    const SizedBox(height: 18),

                    // Property Type
                    Text(l10n.jobPropertyTitle, style: YuvaTypography.subtitle()),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      children: PropertyType.values.map((type) {
                        final isSelected = type == _propertyType;
                        return ChoiceChip(
                          label: Text(_localizeProperty(l10n, type)),
                          selected: isSelected,
                          onSelected: (_) => setState(() => _propertyType = type),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),

                    // Size Category
                    Text(l10n.jobSizeTitle, style: YuvaTypography.subtitle()),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      children: BookingSizeCategory.values.map((size) {
                        final isSelected = size == _sizeCategory;
                        return YuvaChip(
                          label: _localizeSize(l10n, size),
                          isSelected: isSelected,
                          onTap: () => setState(() => _sizeCategory = size),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),

                    // Bedrooms & Bathrooms
                    Row(
                      children: [
                        Expanded(
                          child: _buildCounter(
                            l10n.bedrooms,
                            _bedrooms,
                            (v) => setState(() => _bedrooms = v.clamp(0, 10)),
                            isDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildCounter(
                            l10n.bathrooms,
                            _bathrooms,
                            (v) => setState(() => _bathrooms = v.clamp(0, 10)),
                            isDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Budget Type
                    Text(l10n.jobBudgetTitle, style: YuvaTypography.subtitle()),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: JobBudgetType.values.map((type) {
                        final isSelected = type == _budgetType;
                        return YuvaChip(
                          label: _localizeBudgetType(l10n, type),
                          isSelected: isSelected,
                          onTap: () => setState(() => _budgetType = type),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    if (_budgetType == JobBudgetType.hourly) ...[
                      Text(l10n.jobHourlyRangeLabel, style: YuvaTypography.body()),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _hourlyFromController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(labelText: l10n.budgetFrom),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _hourlyToController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(labelText: l10n.budgetTo),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      TextField(
                        controller: _fixedBudgetController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: l10n.budgetFixedLabel),
                      ),
                    ],
                    const SizedBox(height: 18),

                    // Frequency
                    Text(l10n.jobFrequencyTitle, style: YuvaTypography.subtitle()),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: BookingFrequency.values.map((freq) {
                        final isSelected = freq == _frequency;
                        return YuvaChip(
                          label: _localizeFrequency(l10n, freq),
                          isSelected: isSelected,
                          onTap: () => setState(() => _frequency = freq),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),

                    // Area / Location
                    TextField(
                      controller: _areaController,
                      decoration: InputDecoration(
                        labelText: l10n.jobAreaLabel,
                        hintText: l10n.jobAreaHint,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Preferred Date
                    Text(l10n.jobPreferredDate, style: YuvaTypography.subtitle()),
                    const SizedBox(height: 8),
                    YuvaCard(
                      onTap: () => _pickDate(context),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: isDark
                                ? YuvaColors.darkSurface
                                : YuvaColors.surfaceCream,
                            child: const Icon(
                              Icons.event_available_rounded,
                              color: YuvaColors.primaryTeal,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat.yMMMd(
                                    Localizations.localeOf(context).toString(),
                                  ).add_Hm().format(_preferredDate),
                                  style: YuvaTypography.subtitle(),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.jobPreferredDateHint,
                                  style: YuvaTypography.caption(
                                    color: YuvaColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: YuvaButton(
                text: l10n.saveChanges,
                onPressed: _submitting ? null : () => _save(l10n),
                isLoading: _submitting,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _preferredDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 120)),
    );
    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_preferredDate),
    );
    if (pickedTime == null || !mounted) return;

    setState(() {
      _preferredDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> _save(AppLocalizations l10n) async {
    setState(() => _submitting = true);

    try {
      final updatedJob = widget.job.copyWith(
        customTitle: _titleController.text.trim().isEmpty
            ? null
            : _titleController.text.trim(),
        customDescription: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        serviceTypeId: _serviceTypeId,
        propertyDetails: PropertyDetails(
          type: _propertyType,
          sizeCategory: _sizeCategory,
          bedrooms: _bedrooms,
          bathrooms: _bathrooms,
        ),
        budgetType: _budgetType,
        hourlyRateFrom: _budgetType == JobBudgetType.hourly
            ? double.tryParse(_hourlyFromController.text)
            : null,
        hourlyRateTo: _budgetType == JobBudgetType.hourly
            ? double.tryParse(_hourlyToController.text)
            : null,
        fixedBudget: _budgetType == JobBudgetType.fixed
            ? double.tryParse(_fixedBudgetController.text)
            : null,
        areaLabel: _areaController.text.trim(),
        frequency: _frequency,
        preferredStartDate: _preferredDate,
      );

      await ref.read(jobPostRepositoryProvider).updateJobPost(updatedJob);
      ref.invalidate(jobPostsProvider);
      ref.invalidate(jobPostProvider(widget.job.id));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.jobUpdatedSuccess)),
        );
        Navigator.of(context).pop();
      }
    } on JobNotModifiableException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.jobCannotBeModified)),
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
        setState(() => _submitting = false);
      }
    }
  }

  Widget _buildCounter(
    String label,
    int value,
    ValueChanged<int> onChanged,
    bool isDark,
  ) {
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
