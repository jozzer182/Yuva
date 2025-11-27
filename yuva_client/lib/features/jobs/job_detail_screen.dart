import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers.dart';
import '../../utils/money_formatter.dart';
import '../../data/models/booking_request.dart';
import '../../data/models/job_models.dart';
import '../../data/models/rating.dart';
import '../../data/repositories/job_post_repository.dart';
import '../../design_system/colors.dart';
import '../../design_system/components/avatar_picker.dart';
import '../../design_system/components/yuva_button.dart';
import '../../design_system/components/yuva_card.dart';
import '../../design_system/components/yuva_chip.dart';
import '../../design_system/components/yuva_scaffold.dart';
import '../../design_system/typography.dart';
import '../../l10n/app_localizations.dart';
import '../ratings/rate_job_screen.dart';
import '../ratings/ratings_providers.dart';
import 'edit_job_screen.dart';
import 'job_providers.dart';
import 'proposal_detail_screen.dart';

class JobDetailScreen extends ConsumerStatefulWidget {
  final String jobId;

  const JobDetailScreen({super.key, required this.jobId});

  @override
  ConsumerState<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends ConsumerState<JobDetailScreen> {
  Future<void> _onRefresh() async {
    // Invalidate providers to force re-fetch from repositories
    ref.invalidate(jobPostProvider(widget.jobId));
    ref.invalidate(proposalsForJobProvider(widget.jobId));
    ref.invalidate(proSummariesProvider);
    ref.invalidate(jobRatingProvider(widget.jobId));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final jobAsync = ref.watch(jobPostProvider(widget.jobId));
    final proposalsAsync = ref.watch(proposalsForJobProvider(widget.jobId));
    final prosAsync = ref.watch(proSummariesProvider);
    final ratingAsync = ref.watch(jobRatingProvider(widget.jobId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return YuvaScaffold(
      useGradientBackground: true,
      appBar: AppBar(
        title: Text(l10n.jobDetailTitle, style: YuvaTypography.subtitle()),
        actions: [
          jobAsync.whenOrNull(
            data: (job) {
              if (job == null || !job.canClientModify) return null;
              return PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'edit') {
                    _navigateToEdit(context, job);
                  } else if (value == 'delete') {
                    _showDeleteConfirmation(context, ref, l10n, job);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        const Icon(Icons.edit_outlined),
                        const SizedBox(width: 8),
                        Text(l10n.editJob),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: Colors.red.shade400),
                        const SizedBox(width: 8),
                        Text(l10n.deleteJob, style: TextStyle(color: Colors.red.shade400)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ) ?? const SizedBox.shrink(),
        ],
      ),
      body: SafeArea(
        child: jobAsync.when(
          data: (job) {
            if (job == null) {
              return Center(child: Text(l10n.jobNotFound));
            }
            // Handle proposals error gracefully - show empty list if query fails
            // (e.g., missing Firestore index)
            final proposals = proposalsAsync.valueOrNull ?? [];
            final pros = prosAsync.valueOrNull ?? [];
            final rating = ratingAsync.valueOrNull;
            
            // Show loading only if job data is still loading
            if (proposalsAsync.isLoading && proposals.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            
            return _buildContent(context, l10n, job, proposals, pros, rating, isDark, ref);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text(error.toString())),
        ),
      ),
    );
  }

  void _navigateToEdit(BuildContext context, JobPost job) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => EditJobScreen(job: job)),
    );
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    JobPost job,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteJobTitle),
        content: Text(l10n.deleteJobConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(jobPostRepositoryProvider).deleteJob(job.id);
        ref.invalidate(jobPostsProvider);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.jobDeletedSuccess)),
          );
          Navigator.of(context).pop();
        }
      } on JobNotModifiableException {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.jobCannotBeModified)),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }
    }
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

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
                    Text(_budgetCopy(context, l10n, job), style: YuvaTypography.body()),
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

    // Use denormalized worker info from proposal if ProSummary not available
    final workerName = pro?.displayName ?? proposal.workerDisplayName ?? l10n.proDeleted;
    final workerInitials = pro?.avatarInitials 
        ?? proposal.workerAvatarInitials 
        ?? (workerName != l10n.proDeleted ? workerName.characters.take(2).toString().toUpperCase() : '?');
    final hasProInfo = pro != null;

    return YuvaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Use Consumer to fetch worker avatar if not in proposal
              Consumer(
                builder: (context, ref, _) {
                  // First try proposal's denormalized avatarId
                  String? avatarId = proposal.workerAvatarId;
                  
                  // If not available, fetch from worker's profile
                  if (avatarId == null && proposal.proId.isNotEmpty) {
                    final asyncAvatarId = ref.watch(workerAvatarIdProvider(proposal.proId));
                    avatarId = asyncAvatarId.valueOrNull;
                  }
                  
                  return AvatarDisplay(
                    avatarId: avatarId,
                    fallbackInitial: workerInitials,
                    size: 40,
                  );
                },
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(workerName, style: YuvaTypography.subtitle()),
                    const SizedBox(height: 2),
                    Text(
                      hasProInfo
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
                    ? l10n.perHour('\$${formatAmount(proposal.proposedHourlyRate!, context)}')
                    : l10n.fixedPriceLabel(formatAmount(proposal.proposedFixedPrice ?? 0, context)),
                style: YuvaTypography.body(),
              ),
              const Spacer(),
              Text(date, style: YuvaTypography.caption()),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.start,
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
              if (_canModifyProposal(proposal, job)) ...[
                if (proposal.status == ProposalStatus.submitted)
                  TextButton(
                    onPressed: () => _updateProposalStatus(ref, job, proposal, ProposalStatus.shortlisted, context, l10n),
                    child: Text(l10n.shortlistAction),
                  ),
                TextButton(
                  onPressed: () => _confirmReject(ref, job, proposal, context, l10n),
                  child: Text(l10n.rejectAction, style: TextStyle(color: YuvaColors.error)),
                ),
              ],
              if (_canHire(proposal, job))
                YuvaButton(
                  text: l10n.hireAction,
                  buttonStyle: YuvaButtonStyle.primary,
                  onPressed: () => _confirmHire(
                    ref, 
                    job, 
                    proposal, 
                    pro?.displayName ?? proposal.workerDisplayName ?? '', 
                    proposal.workerAvatarId,
                    context, 
                    l10n,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Check if proposal can be modified (preselect/reject)
  bool _canModifyProposal(Proposal proposal, JobPost job) {
    // Can't modify if job is already hired or cancelled
    if (job.status == JobPostStatus.hired || 
        job.status == JobPostStatus.cancelled ||
        job.status == JobPostStatus.completed) {
      return false;
    }
    // Can only modify submitted or shortlisted proposals
    return proposal.status == ProposalStatus.submitted || 
           proposal.status == ProposalStatus.shortlisted;
  }

  /// Check if proposal can be hired
  bool _canHire(Proposal proposal, JobPost job) {
    // Can't hire if job already has a hired worker
    if (job.hiredProId != null) return false;
    // Can only hire from open or under review jobs
    if (job.status != JobPostStatus.open && job.status != JobPostStatus.underReview) {
      return false;
    }
    // Can only hire submitted or shortlisted proposals
    return proposal.status == ProposalStatus.submitted || 
           proposal.status == ProposalStatus.shortlisted;
  }

  Future<void> _updateProposalStatus(
    WidgetRef ref, 
    JobPost job,
    Proposal proposal,
    ProposalStatus status,
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    try {
      await ref.read(proposalRepositoryProvider).updateProposalStatus(
        jobPostId: widget.jobId,
        proposalId: proposal.id,
        status: status,
      );
      
      // Send notification to worker
      if (status == ProposalStatus.shortlisted) {
        await ref.read(notificationServiceProvider).notifyWorkerShortlisted(
          workerId: proposal.proId,
          jobPostId: job.id,
          jobTitle: job.customTitle ?? job.titleKey,
        );
      } else if (status == ProposalStatus.rejected) {
        await ref.read(notificationServiceProvider).notifyWorkerRejected(
          workerId: proposal.proId,
          jobPostId: job.id,
          jobTitle: job.customTitle ?? job.titleKey,
        );
      }
      
      ref.invalidate(proposalsForJobProvider(widget.jobId));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(status == ProposalStatus.shortlisted 
              ? l10n.proposalShortlistedSuccess 
              : l10n.proposalRejectedSuccess),
          backgroundColor: YuvaColors.success,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.proposalUpdateError),
          backgroundColor: YuvaColors.error,
        ),
      );
    }
  }

  Future<void> _confirmReject(
    WidgetRef ref,
    JobPost job,
    Proposal proposal,
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.rejectProposalTitle),
        content: Text(l10n.rejectProposalConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.reject, style: TextStyle(color: YuvaColors.error)),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      await _updateProposalStatus(ref, job, proposal, ProposalStatus.rejected, context, l10n);
    }
  }

  Future<void> _confirmHire(
    WidgetRef ref,
    JobPost job,
    Proposal proposal,
    String proName,
    String? workerAvatarId,
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.hireProposalTitle),
        content: Text(l10n.hireProposalConfirmation(proName.isNotEmpty ? proName : 'este profesional')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: YuvaColors.primaryTeal,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.hireAction),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      try {
        // 1. Hire the proposal
        await ref.read(jobPostRepositoryProvider).hireProposal(
              jobPostId: job.id,
              proposalId: proposal.id,
              proId: proposal.proId,
            );
        
        // 2. Create conversation between client and worker
        final currentUser = ref.read(currentUserProvider);
        if (currentUser != null) {
          await ref.read(clientConversationsRepositoryProvider).createConversation(
            clientId: currentUser.id,
            workerId: proposal.proId,
            jobPostId: job.id,
            workerDisplayName: proName.isNotEmpty ? proName : 'Profesional',
            workerAvatarId: workerAvatarId,
            clientDisplayName: currentUser.name,
          );
          
          // 3. Send notification to the hired worker
          debugPrint('📢 Sending hire notification to worker: ${proposal.proId}');
          debugPrint('📢 Job: ${job.id}, Title: ${job.customTitle ?? job.titleKey}');
          try {
            await ref.read(notificationServiceProvider).notifyWorkerHired(
              workerId: proposal.proId,
              jobPostId: job.id,
              jobTitle: job.customTitle ?? job.titleKey,
              clientName: currentUser.name,
            );
            debugPrint('📢 Hire notification sent successfully');
          } catch (e) {
            debugPrint('❌ Error sending hire notification: $e');
          }
        }
        
        ref.invalidate(jobPostsProvider);
        ref.invalidate(jobPostProvider(job.id));
        ref.invalidate(proposalsForJobProvider(job.id));
        
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.hireSuccessMessage),
            backgroundColor: YuvaColors.success,
          ),
        );
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.hireError),
            backgroundColor: YuvaColors.error,
          ),
        );
      }
    }
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

  String _budgetCopy(BuildContext context, AppLocalizations l10n, JobPost job) {
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
      case ProposalStatus.withdrawn:
        return l10n.proposalWithdrawn;
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
