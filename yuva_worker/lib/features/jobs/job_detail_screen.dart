import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yuva_worker/l10n/app_localizations.dart';
import '../../utils/money_formatter.dart';
import '../../core/providers.dart';
import '../../data/models/shared_types.dart';
import '../../data/models/worker_job.dart';
import '../../design_system/colors.dart';
import '../../design_system/components/yuva_button.dart';
import '../../design_system/components/yuva_card.dart';
import '../../design_system/components/yuva_chip.dart';

/// Job detail screen showing full information about a job
class JobDetailScreen extends ConsumerStatefulWidget {
  final String jobId;

  const JobDetailScreen({super.key, required this.jobId});

  @override
  ConsumerState<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends ConsumerState<JobDetailScreen> {
  WorkerJobDetail? _job;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJob();
  }

  Future<void> _loadJob() async {
    final repo = ref.read(workerJobFeedRepositoryProvider);
    final job = await repo.getJobDetail(widget.jobId);

    if (mounted) {
      setState(() {
        _job = job;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: YuvaColors.backgroundLight,
      appBar: AppBar(
        title: Text(l10n.jobDetailTitle),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and invitation chip
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _job!.customTitle ?? _getJobTitle(l10n, _job!.titleKey),
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      ),
                      if (_job!.isInvited)
                        YuvaChip(
                          label: l10n.invitation,
                          chipStyle: YuvaChipStyle.accent,
                          icon: Icons.mail,
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Basic info
                  _InfoRow(
                    icon: Icons.location_on,
                    label: l10n.area,
                    value: _job!.areaLabel,
                  ),
                  _InfoRow(
                    icon: Icons.repeat,
                    label: l10n.frequency,
                    value: _getFrequency(l10n, _job!.frequency),
                  ),
                  if (_job!.preferredStartDate != null)
                    _InfoRow(
                      icon: Icons.calendar_today,
                      label: l10n.preferredDate,
                      value: DateFormat.yMMMd('es').format(_job!.preferredStartDate!),
                    ),

                  const SizedBox(height: 24),

                  // Budget section
                  YuvaCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.budgetDetails,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _getBudgetText(l10n),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: YuvaColors.primaryTeal,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Property details
                  YuvaCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.propertyDetails,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _getPropertyType(l10n, _job!.propertyDetails.type),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.roomsCount(
                            _job!.propertyDetails.bedrooms,
                            _job!.propertyDetails.bathrooms,
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Description
                  YuvaCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.description,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _job!.customDescription ?? _getJobDesc(l10n, _job!.descriptionKey),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // TODO: Prepare proposal button (non-functional for now)
                  SizedBox(
                    width: double.infinity,
                    child: YuvaButton(
                      text: l10n.prepareProposal,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.proposalFeatureComingSoon),
                            backgroundColor: YuvaColors.info,
                          ),
                        );
                      },
                      icon: Icons.send,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  String _getJobTitle(AppLocalizations l10n, String key) {
    switch (key) {
      case 'jobTitleDeepCleanApt':
        return l10n.jobTitleDeepCleanApt;
      case 'jobTitleWeeklyHouse':
        return l10n.jobTitleWeeklyHouse;
      case 'jobTitleOfficeReset':
        return l10n.jobTitleOfficeReset;
      case 'jobTitlePostMoveCondo':
        return l10n.jobTitlePostMoveCondo;
      case 'jobTitleBiweeklyStudio':
        return l10n.jobTitleBiweeklyStudio;
      default:
        return key;
    }
  }

  String _getJobDesc(AppLocalizations l10n, String key) {
    switch (key) {
      case 'jobDescDeepCleanApt':
        return l10n.jobDescDeepCleanApt;
      case 'jobDescWeeklyHouse':
        return l10n.jobDescWeeklyHouse;
      case 'jobDescOfficeReset':
        return l10n.jobDescOfficeReset;
      case 'jobDescPostMoveCondo':
        return l10n.jobDescPostMoveCondo;
      case 'jobDescBiweeklyStudio':
        return l10n.jobDescBiweeklyStudio;
      default:
        return key;
    }
  }

  String _getFrequency(AppLocalizations l10n, JobFrequency frequency) {
    switch (frequency) {
      case JobFrequency.once:
        return l10n.frequencyOnce;
      case JobFrequency.weekly:
        return l10n.frequencyWeekly;
      case JobFrequency.biweekly:
        return l10n.frequencyBiweekly;
      case JobFrequency.monthly:
        return l10n.frequencyMonthly;
    }
  }

  String _getPropertyType(AppLocalizations l10n, PropertyType type) {
    switch (type) {
      case PropertyType.apartment:
        return l10n.propertyApartment;
      case PropertyType.house:
        return l10n.propertyHouse;
      case PropertyType.smallOffice:
        return l10n.propertySmallOffice;
    }
  }

    String _getBudgetText(AppLocalizations l10n) {
      if (_job!.budgetType == JobBudgetType.fixed) {
        return l10n.fixedBudget('\$${formatAmount(_job!.fixedBudget ?? 0, context)}');
      } else {
        return l10n.hourlyRange(
          '\$${formatAmount(_job!.hourlyRateFrom ?? 0, context)}',
          '\$${formatAmount(_job!.hourlyRateTo ?? 0, context)}',
        );
      }
    }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: YuvaColors.textSecondary),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
