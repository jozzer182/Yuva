import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yuva_worker/l10n/app_localizations.dart';
import '../../utils/money_formatter.dart';
import '../../core/providers.dart';
import '../../data/models/shared_types.dart';
import '../../data/models/worker_job.dart';
import '../../data/models/worker_proposal.dart';
import '../../design_system/colors.dart';
import '../../design_system/components/yuva_button.dart';
import '../../design_system/components/yuva_card.dart';
import '../../design_system/components/yuva_chip.dart';
import '../../design_system/typography.dart';
import 'prepare_proposal_screen.dart';
import 'proposal_detail_screen.dart';

/// Job detail screen showing full information about a job
class JobDetailScreen extends ConsumerStatefulWidget {
  final String jobId;

  const JobDetailScreen({super.key, required this.jobId});

  @override
  ConsumerState<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends ConsumerState<JobDetailScreen> {
  WorkerJobDetail? _job;
  WorkerProposal? _myProposal;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final jobRepo = ref.read(workerJobFeedRepositoryProvider);
    final proposalRepo = ref.read(workerProposalsRepositoryProvider);
    
    final job = await jobRepo.getJobDetail(widget.jobId);
    
    // Check if worker already has a proposal for this job
    WorkerProposal? myProposal;
    try {
      myProposal = await proposalRepo.getProposalForJob(widget.jobId);
    } catch (e) {
      // Ignore errors fetching proposals
      debugPrint('Error fetching proposal: $e');
    }

    if (mounted) {
      setState(() {
        _job = job;
        _myProposal = myProposal;
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
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
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

                  // Show existing proposal or prepare proposal button
                  if (_myProposal != null)
                    _buildMyProposalCard(l10n)
                  else
                    SizedBox(
                      width: double.infinity,
                      child: YuvaButton(
                        text: l10n.prepareProposal,
                        onPressed: () async {
                          final result = await Navigator.of(context).push<bool>(
                            MaterialPageRoute(
                              builder: (_) => PrepareProposalScreen(job: _job!),
                            ),
                          );
                          // Reload job detail if proposal was submitted
                          if (result == true && mounted) {
                            _loadData();
                          }
                        },
                        icon: Icons.send,
                      ),
                    ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildMyProposalCard(AppLocalizations l10n) {
    final proposal = _myProposal!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    String getAmountText() {
      if (proposal.proposedFixedPrice != null) {
        return l10n.fixedBudget('\$${formatAmount(proposal.proposedFixedPrice!, context)}');
      } else if (proposal.proposedHourlyRate != null) {
        return l10n.perHour('\$${formatAmount(proposal.proposedHourlyRate!, context)}');
      }
      return '';
    }

    String getStatusLabel() {
      switch (proposal.status) {
        case WorkerProposalStatus.draft:
          return l10n.proposalStatusDraft;
        case WorkerProposalStatus.submitted:
          return l10n.proposalStatusSent;
        case WorkerProposalStatus.shortlisted:
          return l10n.proposalStatusShortlisted;
        case WorkerProposalStatus.hired:
          return l10n.proposalStatusHired;
        case WorkerProposalStatus.rejected:
          return l10n.proposalStatusRejected;
        case WorkerProposalStatus.withdrawn:
          return l10n.proposalStatusWithdrawn;
      }
    }

    YuvaChipStyle getStatusStyle() {
      switch (proposal.status) {
        case WorkerProposalStatus.hired:
          return YuvaChipStyle.primary;
        case WorkerProposalStatus.rejected:
        case WorkerProposalStatus.withdrawn:
          return YuvaChipStyle.neutral;
        case WorkerProposalStatus.shortlisted:
          return YuvaChipStyle.accent;
        case WorkerProposalStatus.draft:
        case WorkerProposalStatus.submitted:
          return YuvaChipStyle.secondary;
      }
    }

    return YuvaCard(
      onTap: () async {
        final result = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => ProposalDetailScreen(
              proposal: proposal,
              proposalNumber: 1,
            ),
          ),
        );
        // Refresh if proposal was withdrawn
        if (result == true) {
          _loadData();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(l10n.yourProposal, style: YuvaTypography.subtitle()),
              ),
              YuvaChip(
                label: getStatusLabel(),
                chipStyle: getStatusStyle(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            getAmountText(),
            style: YuvaTypography.body().copyWith(
              color: isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (proposal.coverLetterKey.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              proposal.coverLetterKey,
              style: YuvaTypography.caption(color: YuvaColors.textSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.chevron_right, color: YuvaColors.textSecondary, size: 16),
              const SizedBox(width: 4),
              Text(
                l10n.proposalDetails,
                style: YuvaTypography.caption(color: YuvaColors.primaryTeal),
              ),
            ],
          ),
        ],
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
