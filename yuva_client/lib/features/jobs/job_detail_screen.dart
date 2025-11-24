import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers.dart';
import '../../data/models/booking_request.dart';
import '../../data/models/job_models.dart';
import '../../data/models/rating.dart';
import '../../design_system/colors.dart';
import '../../design_system/components/yuva_button.dart';
import '../../design_system/components/yuva_card.dart';
import '../../design_system/components/yuva_chip.dart';
import '../../design_system/components/yuva_scaffold.dart';
import '../../design_system/typography.dart';
import '../../l10n/app_localizations.dart';
import '../ratings/rate_job_screen.dart';
import '../ratings/ratings_providers.dart';
import 'job_providers.dart';
import 'proposal_detail_screen.dart';

class JobDetailScreen extends ConsumerWidget {
  final String jobId;

  const JobDetailScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final jobAsync = ref.watch(jobPostProvider(jobId));
    final proposalsAsync = ref.watch(proposalsForJobProvider(jobId));
    final prosAsync = ref.watch(proSummariesProvider);
    final ratingAsync = ref.watch(jobRatingProvider(jobId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return YuvaScaffold(
      useGradientBackground: true,
      appBar: AppBar(
        title: Text(l10n.jobDetailTitle, style: YuvaTypography.subtitle()),
      ),
      body: SafeArea(
        child: jobAsync.when(
          data: (job) {
            if (job == null) {
              return Center(child: Text(l10n.jobNotFound));
            }
            return proposalsAsync.when(
              data: (proposals) => prosAsync.when(
                data: (pros) => ratingAsync.when(
                  data: (rating) =>
                      _buildContent(context, l10n, job, proposals, pros, rating, isDark, ref),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text(e.toString())),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text(e.toString())),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text(error.toString())),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppLocalizations l10n,
    JobPost job,
    List<Proposal> proposals,
    List<ProSummary> pros,
    Rating? rating,
    bool isDark,
    WidgetRef ref,
  ) {
    final locale = Localizations.localeOf(context).toString();
    final prosById = {for (final pro in pros) pro.id: pro};
    final invited = pros.where((pro) => job.invitedProIds.contains(pro.id)).toList();
    final hired = job.hiredProId != null ? prosById[job.hiredProId] : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YuvaCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _resolveTitle(l10n, job),
                        style: YuvaTypography.subtitle(),
                      ),
                    ),
                    YuvaChip(
                      label: _localizeStatus(l10n, job.status),
                      isSelected: true,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _resolveDescription(l10n, job),
                  style: YuvaTypography.body(color: YuvaColors.textSecondary),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.place_outlined, color: YuvaColors.primaryTeal),
                    const SizedBox(width: 6),
                    Text(job.areaLabel, style: YuvaTypography.body()),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.schedule_rounded, color: YuvaColors.primaryTeal),
                    const SizedBox(width: 6),
                    Text(
                      job.preferredStartDate != null
                          ? DateFormat.yMMMd(locale).add_Hm().format(job.preferredStartDate!)
                          : l10n.jobToBeScheduled,
                      style: YuvaTypography.body(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          YuvaCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.jobPropertyTitle, style: YuvaTypography.subtitle()),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _infoChip(
                      icon: Icons.home_work_outlined,
                      label: _localizeProperty(l10n, job.propertyDetails.type),
                      isDark: isDark,
                    ),
                    _infoChip(
                      icon: Icons.aspect_ratio,
                      label: _localizeSize(l10n, job.propertyDetails.sizeCategory),
                      isDark: isDark,
                    ),
                    _infoChip(
                      icon: Icons.bed_outlined,
                      label: l10n.roomsCount(job.propertyDetails.bedrooms, job.propertyDetails.bathrooms),
                      isDark: isDark,
                    ),
                    _infoChip(
                      icon: Icons.repeat_rounded,
                      label: _localizeFrequency(l10n, job.frequency),
                      isDark: isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.monetization_on_outlined, color: YuvaColors.primaryTeal),
                    const SizedBox(width: 6),
                    Text(_budgetCopy(l10n, job), style: YuvaTypography.body()),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(l10n.invitedPros, style: YuvaTypography.sectionTitle()),
          const SizedBox(height: 8),
          if (invited.isEmpty)
            Text(l10n.noInvitedYet, style: YuvaTypography.body(color: YuvaColors.textSecondary))
          else
            Column(
              children: invited
                  .map((pro) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _proRow(pro),
                      ))
                  .toList(),
            ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.receivedProposals, style: YuvaTypography.sectionTitle()),
              YuvaChip(
                label: l10n.proposalsCount(proposals.length),
                isSelected: true,
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (proposals.isEmpty)
            Text(l10n.noProposalsYet, style: YuvaTypography.body(color: YuvaColors.textSecondary))
          else
            Column(
              children: proposals
                  .map((proposal) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _proposalCard(
                          context,
                          l10n,
                          job,
                          proposal,
                          prosById[proposal.proId],
                          isDark,
                          ref,
                        ),
                    ))
                .toList(),
            ),
          const SizedBox(height: 12),
          if ((job.status == JobPostStatus.hired ||
                  job.status == JobPostStatus.inProgress ||
                  job.status == JobPostStatus.completed) &&
              hired != null)
            rating == null
                ? YuvaButton(
                    text: l10n.rateJobCta,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RateJobScreen(job: job, pro: hired),
                        ),
                      );
                    },
                  )
                : Text(
                    l10n.ratingAlreadySent,
                    style: YuvaTypography.body(color: YuvaColors.textSecondary),
                  ),
        ],
      ),
    );
  }

  Widget _proRow(ProSummary pro) {
    return YuvaCard(
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: YuvaColors.primaryTeal.withValues(alpha: 0.15),
            child: Text(pro.avatarInitials ?? pro.displayName.characters.take(2).toString()),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pro.displayName, style: YuvaTypography.body()),
                const SizedBox(height: 2),
                Text(
                  '${pro.areaLabel} · ${pro.ratingAverage.toStringAsFixed(1)} (${pro.ratingCount})',
                  style: YuvaTypography.caption(color: YuvaColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _proposalCard(
    BuildContext context,
    AppLocalizations l10n,
    JobPost job,
    Proposal proposal,
    ProSummary? pro,
    bool isDark,
    WidgetRef ref,
  ) {
    final locale = Localizations.localeOf(context).toString();
    final date = DateFormat.yMMMd(locale).format(proposal.createdAt);
    final statusLabel = _localizeProposalStatus(l10n, proposal.status);

    return YuvaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: YuvaColors.primaryTeal.withValues(alpha: 0.12),
                child: Text(pro?.avatarInitials ?? pro?.displayName.characters.take(2).toString() ?? '?'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pro?.displayName ?? l10n.proDeleted, style: YuvaTypography.subtitle()),
                    const SizedBox(height: 2),
                    Text(
                      pro != null
                          ? '${pro.ratingAverage.toStringAsFixed(1)} (${pro.ratingCount}) · ${pro.areaLabel}'
                          : '',
                      style: YuvaTypography.caption(color: YuvaColors.textSecondary),
                    ),
                  ],
                ),
              ),
              YuvaChip(label: statusLabel, isSelected: true),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _coverLetter(l10n, proposal.coverLetterKey),
            style: YuvaTypography.body(color: YuvaColors.textSecondary),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.monetization_on_outlined, color: YuvaColors.primaryTeal),
              const SizedBox(width: 6),
              Text(
                proposal.proposedHourlyRate != null
                    ? l10n.perHour('\$${proposal.proposedHourlyRate!.toStringAsFixed(0)}')
                    : l10n.fixedPriceLabel(proposal.proposedFixedPrice?.toStringAsFixed(0) ?? '0'),
                style: YuvaTypography.body(),
              ),
              const Spacer(),
              Text(date, style: YuvaTypography.caption()),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ProposalDetailScreen(
                      job: job,
                      proposal: proposal,
                      pro: pro,
                    ),
                  ));
                },
                child: Text(l10n.viewDetails),
              ),
              if (proposal.status == ProposalStatus.submitted ||
                  proposal.status == ProposalStatus.shortlisted) ...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => _updateProposalStatus(ref, proposal.id, ProposalStatus.shortlisted),
                  child: Text(l10n.shortlistAction),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => _updateProposalStatus(ref, proposal.id, ProposalStatus.rejected),
                  child: Text(l10n.rejectAction),
                ),
              ],
              if (job.status == JobPostStatus.open || job.status == JobPostStatus.underReview)
                const Spacer(),
              if (job.status == JobPostStatus.open || job.status == JobPostStatus.underReview)
                YuvaButton(
                  text: l10n.hireAction,
                  buttonStyle: YuvaButtonStyle.primary,
                  onPressed: pro == null
                      ? null
                      : () => _hire(ref, job.id, proposal.id, pro.id, context, l10n),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _updateProposalStatus(
      WidgetRef ref, String proposalId, ProposalStatus status) async {
    await ref.read(proposalRepositoryProvider).updateProposalStatus(proposalId, status);
    ref.invalidate(proposalsForJobProvider(jobId));
  }

  Future<void> _hire(
    WidgetRef ref,
    String jobId,
    String proposalId,
    String proId,
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    await ref.read(jobPostRepositoryProvider).hireProposal(
          jobPostId: jobId,
          proposalId: proposalId,
          proId: proId,
        );
    ref.invalidate(jobPostsProvider);
    ref.invalidate(jobPostProvider(jobId));
    ref.invalidate(proposalsForJobProvider(jobId));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.hireSuccessMessage)),
    );
  }

  Widget _infoChip({required IconData icon, required String label, required bool isDark}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? YuvaColors.darkSurface : YuvaColors.surfaceCream,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: YuvaColors.primaryTeal),
          const SizedBox(width: 6),
          Text(label, style: YuvaTypography.bodySmall()),
        ],
      ),
    );
  }

  String _budgetCopy(AppLocalizations l10n, JobPost job) {
    if (job.budgetType == JobBudgetType.hourly) {
      return l10n.budgetRangeLabel(
        (job.hourlyRateFrom ?? 0).toStringAsFixed(0),
        (job.hourlyRateTo ?? job.hourlyRateFrom ?? 0).toStringAsFixed(0),
      );
    }
    return l10n.fixedPriceLabel((job.fixedBudget ?? 0).toStringAsFixed(0));
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

  String _localizeProposalStatus(AppLocalizations l10n, ProposalStatus status) {
    switch (status) {
      case ProposalStatus.submitted:
        return l10n.proposalSubmitted;
      case ProposalStatus.shortlisted:
        return l10n.proposalShortlisted;
      case ProposalStatus.rejected:
        return l10n.proposalRejected;
      case ProposalStatus.hired:
        return l10n.proposalHired;
    }
  }

  String _coverLetter(AppLocalizations l10n, String key) {
    switch (key) {
      case 'coverDetailSparkling':
        return l10n.coverDetailSparkling;
      case 'coverExperienceDeep':
        return l10n.coverExperienceDeep;
      case 'coverWeeklyCare':
        return l10n.coverWeeklyCare;
      case 'coverFlexible':
        return l10n.coverFlexible;
      case 'coverOfficeReset':
        return l10n.coverOfficeReset;
      default:
        return key;
    }
  }

  String _resolveTitle(AppLocalizations l10n, JobPost job) {
    if (job.customTitle != null && job.customTitle!.isNotEmpty) return job.customTitle!;
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

  String _resolveDescription(AppLocalizations l10n, JobPost job) {
    if (job.customDescription != null && job.customDescription!.isNotEmpty) {
      return job.customDescription!;
    }
    switch (job.descriptionKey) {
      case 'jobDescDeepCleanApt':
        return l10n.jobDescDeepCleanApt;
      case 'jobDescWeeklyHouse':
        return l10n.jobDescWeeklyHouse;
      case 'jobDescOfficeReset':
        return l10n.jobDescOfficeReset;
      default:
        return l10n.jobCustomDescription;
    }
  }
}
