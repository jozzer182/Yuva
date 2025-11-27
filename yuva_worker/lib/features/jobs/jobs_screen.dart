import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuva_worker/l10n/app_localizations.dart';
import '../../utils/money_formatter.dart';
import '../../core/providers.dart';
import '../../data/models/shared_types.dart';
import '../../data/models/worker_job.dart';
import '../../data/models/worker_proposal.dart';
import '../../design_system/colors.dart';
import '../../design_system/components/yuva_card.dart';
import '../../design_system/components/yuva_chip.dart';
import '../../design_system/typography.dart';
import 'job_detail_screen.dart';
import 'proposal_detail_screen.dart';

/// Jobs screen with tabs for new jobs and invitations
class JobsScreen extends ConsumerStatefulWidget {
  const JobsScreen({super.key});

  @override
  ConsumerState<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends ConsumerState<JobsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<WorkerJobSummary>? _newJobs;
  List<WorkerJobSummary>? _invitedJobs;
  List<WorkerProposal>? _myProposals;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadJobs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadJobs() async {
    setState(() => _isLoading = true);
    final jobRepo = ref.read(workerJobFeedRepositoryProvider);
    final proposalRepo = ref.read(workerProposalsRepositoryProvider);
    
    // Load jobs and proposals separately to handle errors gracefully
    List<WorkerJobSummary> recommended = [];
    List<WorkerJobSummary> invited = [];
    List<WorkerProposal> proposals = [];
    
    try {
      recommended = await jobRepo.getRecommendedJobs();
    } catch (e) {
      debugPrint('Error loading recommended jobs: $e');
    }
    
    try {
      invited = await jobRepo.getInvitedJobs();
    } catch (e) {
      debugPrint('Error loading invited jobs: $e');
    }
    
    try {
      proposals = await proposalRepo.getMyProposals();
    } catch (e) {
      // This may fail if Firestore index is not created yet
      debugPrint('Error loading proposals: $e');
    }

    if (mounted) {
      setState(() {
        _newJobs = recommended;
        _invitedJobs = invited;
        _myProposals = proposals;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Listen for dummy mode changes and reload jobs
    ref.listen(appSettingsProvider.select((s) => s.isDummyMode), (previous, next) {
      if (previous != next) {
        _loadJobs();
      }
    });

    return Scaffold(
      backgroundColor: isDark ? YuvaColors.darkBackground : YuvaColors.backgroundLight,
      appBar: AppBar(
        title: Text(l10n.jobs),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.newJobs),
            Tab(text: l10n.invitations),
            Tab(text: l10n.sentProposals),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _JobsList(
                  jobs: _newJobs ?? [],
                  proposedJobIds: _getProposedJobIds(),
                  onRefresh: _loadJobs,
                ),
                _JobsList(
                  jobs: _invitedJobs ?? [],
                  proposedJobIds: _getProposedJobIds(),
                  onRefresh: _loadJobs,
                ),
                _ProposalsList(proposals: _myProposals ?? [], onRefresh: _loadJobs),
              ],
            ),
    );
  }

  /// Returns a set of job IDs for which the worker has active proposals
  Set<String> _getProposedJobIds() {
    return (_myProposals ?? [])
        .where((p) => p.status != WorkerProposalStatus.withdrawn && p.status != WorkerProposalStatus.rejected)
        .map((p) => p.jobPostId)
        .toSet();
  }
}

class _JobsList extends StatelessWidget {
  final List<WorkerJobSummary> jobs;
  final Set<String> proposedJobIds;
  final Future<void> Function() onRefresh;

  const _JobsList({
    required this.jobs,
    required this.proposedJobIds,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(
              l10n.noJobsAvailable,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noJobsDescription,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: .center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];
          final hasProposal = proposedJobIds.contains(job.id);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _JobCard(job: job, hasActiveProposal: hasProposal),
          );
        },
      ),
    );
  }
}

class _JobCard extends ConsumerWidget {
  final WorkerJobSummary job;
  final bool hasActiveProposal;

  const _JobCard({required this.job, this.hasActiveProposal = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String getBudgetText() {
      if (job.budgetType == JobBudgetType.fixed) {
        return l10n.fixedBudget('\$${formatAmount(job.fixedBudget ?? 0, context)}');
      } else {
        return l10n.hourlyRange(
          '\$${formatAmount(job.hourlyRateFrom ?? 0, context)}',
          '\$${formatAmount(job.hourlyRateTo ?? 0, context)}',
        );
      }
    }

    return YuvaCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => JobDetailScreen(jobId: job.id),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  job.customTitle ?? _getJobTitle(l10n, job.titleKey),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: isDark ? Colors.white : YuvaColors.textPrimary,
                  ),
                ),
              ),
              if (hasActiveProposal)
                YuvaChip(
                  label: l10n.proposalSent,
                  chipStyle: YuvaChipStyle.primary,
                  icon: Icons.check_circle_outline,
                )
              else if (job.isInvited)
                YuvaChip(
                  label: l10n.invitation,
                  chipStyle: YuvaChipStyle.accent,
                  icon: Icons.mail,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.location_on, 
                size: 16, 
                color: isDark ? Colors.white70 : YuvaColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                job.areaLabel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDark ? Colors.white70 : YuvaColors.textSecondary,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.repeat, 
                size: 16, 
                color: isDark ? Colors.white70 : YuvaColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                _getFrequency(l10n, job.frequency),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDark ? Colors.white70 : YuvaColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            getBudgetText(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal,
                  fontWeight: FontWeight.w600,
                ),
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
}

/// List of worker's sent proposals
class _ProposalsList extends StatelessWidget {
  final List<WorkerProposal> proposals;
  final Future<void> Function() onRefresh;

  const _ProposalsList({required this.proposals, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (proposals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.send_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noProposalsSent,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noProposalsSentDescription,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: proposals.length,
        itemBuilder: (context, index) {
          final proposal = proposals[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ProposalCard(
              proposal: proposal,
              proposalNumber: index + 1,
              onRefresh: onRefresh,
            ),
          );
        },
      ),
    );
  }
}

/// Card displaying a sent proposal
class _ProposalCard extends ConsumerWidget {
  final WorkerProposal proposal;
  final int proposalNumber;
  final Future<void> Function() onRefresh;

  const _ProposalCard({
    required this.proposal,
    required this.proposalNumber,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canModify = proposal.status.canModify;

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
            builder: (context) => ProposalDetailScreen(
              proposal: proposal,
              proposalNumber: proposalNumber,
            ),
          ),
        );
        // Refresh if proposal was withdrawn
        if (result == true) {
          onRefresh();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.proposalForJob(proposalNumber.toString()),
                  style: YuvaTypography.subtitle(),
                ),
              ),
              YuvaChip(
                label: getStatusLabel(),
                chipStyle: getStatusStyle(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            getAmountText(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal,
                  fontWeight: FontWeight.w600,
                ),
          ),
          if (proposal.coverLetterKey.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              proposal.coverLetterKey,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? Colors.white70 : YuvaColors.textSecondary,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (canModify) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _showWithdrawDialog(context, ref, l10n),
                  icon: const Icon(Icons.cancel_outlined, size: 18),
                  label: Text(l10n.withdrawProposal),
                  style: TextButton.styleFrom(
                    foregroundColor: YuvaColors.error,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _showWithdrawDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.withdrawProposalTitle),
        content: Text(l10n.withdrawProposalConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: YuvaColors.error),
            child: Text(l10n.withdraw),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(workerProposalsRepositoryProvider).withdrawProposal(
          proposal.id,
          proposal.jobPostId,
        );
        await onRefresh();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.proposalWithdrawnSuccess),
              backgroundColor: YuvaColors.success,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.proposalWithdrawError),
              backgroundColor: YuvaColors.error,
            ),
          );
        }
      }
    }
  }
}
