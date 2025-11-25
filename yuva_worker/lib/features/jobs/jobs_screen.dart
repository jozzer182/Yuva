import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuva_worker/l10n/app_localizations.dart';
import '../../utils/money_formatter.dart';
import '../../core/providers.dart';
import '../../data/models/shared_types.dart';
import '../../data/models/worker_job.dart';
import '../../design_system/colors.dart';
import '../../design_system/components/yuva_card.dart';
import '../../design_system/components/yuva_chip.dart';
import 'job_detail_screen.dart';

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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadJobs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadJobs() async {
    setState(() => _isLoading = true);
    final repo = ref.read(workerJobFeedRepositoryProvider);
    final recommended = await repo.getRecommendedJobs();
    final invited = await repo.getInvitedJobs();

    if (mounted) {
      setState(() {
        _newJobs = recommended;
        _invitedJobs = invited;
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
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _JobsList(jobs: _newJobs ?? [], onRefresh: _loadJobs),
                _JobsList(jobs: _invitedJobs ?? [], onRefresh: _loadJobs),
              ],
            ),
    );
  }
}

class _JobsList extends StatelessWidget {
  final List<WorkerJobSummary> jobs;
  final Future<void> Function() onRefresh;

  const _JobsList({required this.jobs, required this.onRefresh});

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
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _JobCard(job: job),
          );
        },
      ),
    );
  }
}

class _JobCard extends ConsumerWidget {
  final WorkerJobSummary job;

  const _JobCard({required this.job});

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
              if (job.isInvited)
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
