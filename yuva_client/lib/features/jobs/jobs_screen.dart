import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yuva/utils/money_formatter.dart';

import '../../core/responsive.dart';
import '../../data/models/booking_request.dart';
import '../../data/models/job_models.dart';
import '../../design_system/colors.dart';
import '../../design_system/components/yuva_button.dart';
import '../../design_system/components/yuva_card.dart';
import '../../design_system/components/yuva_scaffold.dart';
import '../../design_system/typography.dart';
import '../../l10n/app_localizations.dart';
import 'job_detail_screen.dart';
import 'job_providers.dart';
import 'post_job_flow/post_job_flow_screen.dart';

class JobsScreen extends ConsumerStatefulWidget {
  const JobsScreen({super.key});

  @override
  ConsumerState<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends ConsumerState<JobsScreen> {
  String? _selectedJobId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final jobsAsync = ref.watch(jobPostsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTablet = ResponsiveUtils.isTablet(context) || ResponsiveUtils.isLargeTablet(context);

    // Auto-select first job on tablet if none selected
    if (isTablet && _selectedJobId == null) {
      jobsAsync.whenData((jobs) {
        if (jobs.isNotEmpty && mounted) {
          final firstJob = jobs.first;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _selectedJobId = firstJob.id;
              });
            }
          });
        }
      });
    }

    return YuvaScaffold(
      useGradientBackground: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (isTablet) {
              return _buildTabletLayout(context, l10n, jobsAsync, isDark, ref);
            }
            return _buildPhoneLayout(context, l10n, jobsAsync, isDark, ref);
          },
        ),
      ),
    );
  }

  Widget _buildPhoneLayout(
    BuildContext context,
    AppLocalizations l10n,
    AsyncValue<List<JobPost>> jobsAsync,
    bool isDark,
    WidgetRef ref,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.myJobs, style: YuvaTypography.title()),
              YuvaButton(
                text: l10n.postJobCta,
                icon: Icons.add_rounded,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PostJobFlowScreen()),
                  );
                },
                buttonStyle: YuvaButtonStyle.secondary,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.myJobsSubtitle,
            style: YuvaTypography.body(color: YuvaColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: jobsAsync.when(
              data: (jobs) => _buildSections(context, l10n, jobs, isDark, ref, null),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text(error.toString())),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(
    BuildContext context,
    AppLocalizations l10n,
    AsyncValue<List<JobPost>> jobsAsync,
    bool isDark,
    WidgetRef ref,
  ) {
    final padding = ResponsiveUtils.horizontalPadding(context);
    final maxWidth = ResponsiveUtils.maxContentWidth(context);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding.horizontal),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Job list
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.myJobs, style: YuvaTypography.title()),
                          YuvaButton(
                            text: l10n.postJobCta,
                            icon: Icons.add_rounded,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const PostJobFlowScreen()),
                              );
                            },
                            buttonStyle: YuvaButtonStyle.secondary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.myJobsSubtitle,
                      style: YuvaTypography.body(color: YuvaColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: jobsAsync.when(
                        data: (jobs) => _buildSections(
                          context,
                          l10n,
                          jobs,
                          isDark,
                          ref,
                          _selectedJobId,
                        ),
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (error, _) => Center(child: Text(error.toString())),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Right: Job detail
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    color: isDark ? YuvaColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _selectedJobId != null
                      ? JobDetailScreen(jobId: _selectedJobId!)
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.work_outline,
                                size: 64,
                                color: YuvaColors.textSecondary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Selecciona un trabajo para ver los detalles',
                                style: YuvaTypography.body(color: YuvaColors.textSecondary),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
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
    List<JobPost> jobs,
    bool isDark,
    WidgetRef ref,
    String? selectedJobId,
  ) {
    if (jobs.isEmpty) {
      return _emptyState(context, l10n);
    }

    final open = jobs
        .where((job) => job.status == JobPostStatus.open || job.status == JobPostStatus.underReview)
        .toList()
      ..sort((a, b) => (a.preferredStartDate ?? DateTime.now())
          .compareTo(b.preferredStartDate ?? DateTime.now()));
    final active = jobs
        .where((job) =>
            job.status == JobPostStatus.hired ||
            job.status == JobPostStatus.inProgress)
        .toList()
      ..sort((a, b) => (a.preferredStartDate ?? DateTime.now())
          .compareTo(b.preferredStartDate ?? DateTime.now()));
    final completed = jobs
        .where((job) => job.status == JobPostStatus.completed || job.status == JobPostStatus.cancelled)
        .toList()
      ..sort((a, b) => (b.preferredStartDate ?? b.createdAt).compareTo(a.preferredStartDate ?? a.createdAt));

    return ListView(
      children: [
        if (open.isNotEmpty) ...[
          Text(l10n.openJobsTitle, style: YuvaTypography.sectionTitle()),
          const SizedBox(height: 12),
          ...open.map(
            (job) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _jobCard(context, l10n, job, isDark, ref, selectedJobId: selectedJobId),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (active.isNotEmpty) ...[
          Text(l10n.activeJobsTitle, style: YuvaTypography.sectionTitle()),
          const SizedBox(height: 12),
          ...active.map(
            (job) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _jobCard(context, l10n, job, isDark, ref, selectedJobId: selectedJobId),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (completed.isNotEmpty) ...[
          Text(l10n.completedJobsTitle, style: YuvaTypography.sectionTitle()),
          const SizedBox(height: 12),
          ...completed.map(
            (job) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _jobCard(context, l10n, job, isDark, ref, showRating: true, selectedJobId: selectedJobId),
            ),
          ),
        ],
      ],
    );
  }

  Widget _jobCard(
    BuildContext context,
    AppLocalizations l10n,
    JobPost job,
    bool isDark,
    WidgetRef ref, {
    bool showRating = false,
    String? selectedJobId,
  }) {
    final isSelected = selectedJobId == job.id;
    final isTablet = ResponsiveUtils.isTablet(context) || ResponsiveUtils.isLargeTablet(context);
    final locale = Localizations.localeOf(context).toString();
    final proposalCount = job.proposalIds.length;
    final statusLabel = _localizeStatus(l10n, job.status);
    final schedule = job.preferredStartDate != null
        ? DateFormat.MMMd(locale).add_Hm().format(job.preferredStartDate!)
        : l10n.jobToBeScheduled;

    return YuvaCard(
      onTap: () {
        if (isTablet) {
          setState(() {
            _selectedJobId = job.id;
          });
        } else {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => JobDetailScreen(jobId: job.id)));
        }
      },
      child: Container(
        decoration: isSelected && isTablet
            ? BoxDecoration(
                border: Border.all(color: YuvaColors.primaryTeal, width: 2),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Padding(
          padding: isSelected && isTablet ? const EdgeInsets.all(2) : EdgeInsets.zero,
          child: _buildJobCardContent(
            context,
            l10n,
            job,
            isDark,
            ref,
            statusLabel,
            proposalCount,
            schedule,
            showRating: showRating,
          ),
        ),
      ),
    );
  }

  Widget _buildJobCardContent(
    BuildContext context,
    AppLocalizations l10n,
    JobPost job,
    bool isDark,
    WidgetRef ref,
    String statusLabel,
    int proposalCount,
    String schedule, {
    bool showRating = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: (isDark ? YuvaColors.darkSurface : YuvaColors.surfaceCream),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                statusLabel,
                style: YuvaTypography.bodySmall(color: YuvaColors.textSecondary),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                const Icon(Icons.mail_outline, size: 18, color: YuvaColors.primaryTeal),
                const SizedBox(width: 6),
                Text(l10n.proposalsCount(proposalCount), style: YuvaTypography.caption()),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(_resolveTitle(l10n, job), style: YuvaTypography.subtitle()),
        const SizedBox(height: 6),
        Text(job.areaLabel, style: YuvaTypography.body(color: YuvaColors.textSecondary)),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.schedule_rounded, size: 18, color: YuvaColors.primaryTeal),
            const SizedBox(width: 6),
            Text(schedule, style: YuvaTypography.bodySmall()),
            const SizedBox(width: 12),
            Icon(Icons.repeat_rounded, size: 18, color: YuvaColors.primaryTeal),
            const SizedBox(width: 6),
            Text(_localizeFrequency(l10n, job.frequency), style: YuvaTypography.bodySmall()),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.monetization_on_outlined, size: 18, color: YuvaColors.primaryTeal),
            const SizedBox(width: 6),
            Text(_budgetCopy(l10n, job, context), style: YuvaTypography.body()),
          ],
        ),
        if (showRating) ...[
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => JobDetailScreen(jobId: job.id),
                ));
              },
              icon: const Icon(Icons.rate_review_outlined),
              label: Text(l10n.rateJobShortcut),
            ),
          ),
        ],
      ],
    );
  }

  Widget _emptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.noJobsYet, style: YuvaTypography.subtitle()),
          const SizedBox(height: 6),
          Text(
            l10n.noJobsDescription,
            style: YuvaTypography.body(color: YuvaColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          YuvaButton(
            text: l10n.postJobCta,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PostJobFlowScreen()));
            },
          ),
        ],
      ),
    );
  }

  String _budgetCopy(AppLocalizations l10n, JobPost job, BuildContext context) {
    if (job.budgetType == JobBudgetType.hourly) {
      return l10n.budgetRangeLabel(
        formatAmount(job.hourlyRateFrom ?? 0, context),
        formatAmount(job.hourlyRateTo ?? job.hourlyRateFrom ?? 0, context),
      );
    }
    return l10n.fixedPriceLabel(formatAmount(job.fixedBudget ?? 0, context));
  }

  String _localizeStatus(AppLocalizations l10n, JobPostStatus status) {
    switch (status) {
      case JobPostStatus.draft:
        return l10n.jobStatusDraft;
      case JobPostStatus.open:
        return l10n.jobStatusOpen;
      case JobPostStatus.underReview:
        return l10n.jobStatusUnderReview;
      case JobPostStatus.hired:
        return l10n.jobStatusHired;
      case JobPostStatus.inProgress:
        return l10n.jobStatusInProgress;
      case JobPostStatus.completed:
        return l10n.jobStatusCompleted;
      case JobPostStatus.cancelled:
        return l10n.jobStatusCancelled;
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

  String _resolveTitle(AppLocalizations l10n, JobPost job) {
    if (job.customTitle != null && job.customTitle!.isNotEmpty) {
      return job.customTitle!;
    }
    switch (job.titleKey) {
      case 'jobTitleDeepCleanApt':
        return l10n.jobTitleDeepCleanApt;
      case 'jobTitleWeeklyHouse':
        return l10n.jobTitleWeeklyHouse;
      case 'jobTitleOfficeReset':
        return l10n.jobTitleOfficeReset;
      default:
        return l10n.jobCustomTitle;
    }
  }
}
