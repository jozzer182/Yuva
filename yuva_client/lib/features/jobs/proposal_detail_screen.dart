import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yuva/utils/money_formatter.dart';

import '../../core/providers.dart';
import '../../data/models/job_models.dart';
import '../../design_system/colors.dart';
import '../../design_system/components/avatar_picker.dart';
import '../../design_system/components/yuva_button.dart';
import '../../design_system/components/yuva_card.dart';
import '../../design_system/components/yuva_scaffold.dart';
import '../../design_system/typography.dart';
import '../../l10n/app_localizations.dart';
import 'job_providers.dart';

class ProposalDetailScreen extends ConsumerWidget {
  final JobPost job;
  final Proposal proposal;
  final ProSummary? pro;

  const ProposalDetailScreen({
    super.key,
    required this.job,
    required this.proposal,
    required this.pro,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();

    return YuvaScaffold(
      useGradientBackground: true,
      appBar: AppBar(
        title: Text(l10n.proposalDetailTitle, style: YuvaTypography.subtitle()),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              YuvaCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_resolveJobTitle(l10n, job), style: YuvaTypography.subtitle()),
                    const SizedBox(height: 6),
                    Text(job.areaLabel, style: YuvaTypography.body(color: YuvaColors.textSecondary)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: YuvaColors.primaryTeal),
                        const SizedBox(width: 6),
                        Text(
                          job.preferredStartDate != null
                              ? DateFormat.yMMMd(locale).add_Hm().format(job.preferredStartDate!)
                              : l10n.jobToBeScheduled,
                          style: YuvaTypography.bodySmall(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.monetization_on_outlined, size: 16, color: YuvaColors.primaryTeal),
                        const SizedBox(width: 6),
                        Text(_budgetCopy(l10n, job, proposal, context), style: YuvaTypography.body()),
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
                    Row(
                      children: [
                        // Use Consumer to fetch worker avatar if not in proposal
                        Consumer(
                          builder: (context, ref, _) {
                            String? avatarId = proposal.workerAvatarId;
                            
                            // If not available, fetch from worker's profile
                            if (avatarId == null && proposal.proId.isNotEmpty) {
                              final asyncAvatarId = ref.watch(workerAvatarIdProvider(proposal.proId));
                              avatarId = asyncAvatarId.valueOrNull;
                            }
                            
                            return AvatarDisplay(
                              avatarId: avatarId,
                              fallbackInitial: pro?.avatarInitials ?? proposal.workerAvatarInitials ?? pro?.displayName.characters.take(2).toString() ?? '?',
                              size: 40,
                            );
                          },
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(pro?.displayName ?? proposal.workerDisplayName ?? l10n.proDeleted, style: YuvaTypography.subtitle()),
                            const SizedBox(height: 4),
                            if (pro != null)
                              Text(
                                '${pro!.ratingAverage.toStringAsFixed(1)} (${pro!.ratingCount}) · ${pro!.areaLabel}',
                                style: YuvaTypography.caption(color: YuvaColors.textSecondary),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(_coverLetter(l10n, proposal.coverLetterKey), style: YuvaTypography.body()),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.schedule_rounded, size: 16, color: YuvaColors.primaryTeal),
                        const SizedBox(width: 6),
                        Text(
                          DateFormat.yMMMd(locale).format(proposal.createdAt),
                          style: YuvaTypography.caption(color: YuvaColors.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: YuvaButton(
                            text: l10n.rejectAction,
                            buttonStyle: YuvaButtonStyle.secondary,
                            onPressed: () => _confirmReject(ref, context, l10n),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: YuvaButton(
                            text: l10n.hireAction,
                            onPressed: () => _confirmHire(ref, proposal.proId, pro?.displayName ?? proposal.workerDisplayName ?? '', context, l10n),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmReject(
    WidgetRef ref,
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
      try {
        await ref.read(proposalRepositoryProvider).updateProposalStatus(
          jobPostId: job.id,
          proposalId: proposal.id,
          status: ProposalStatus.rejected,
        );
        
        // Send notification to worker
        await ref.read(notificationServiceProvider).notifyWorkerRejected(
          workerId: proposal.proId,
          jobPostId: job.id,
          jobTitle: job.customTitle ?? job.titleKey,
        );
        
        ref.invalidate(proposalsForJobProvider(job.id));
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.proposalRejectedSuccess),
            backgroundColor: YuvaColors.success,
          ),
        );
        Navigator.of(context).pop();
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
  }

  Future<void> _confirmHire(
    WidgetRef ref,
    String proId,
    String proName,
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
              proId: proId,
            );
        
        // 2. Create conversation between client and worker
        final currentUser = ref.read(currentUserProvider);
        if (currentUser != null) {
          await ref.read(clientConversationsRepositoryProvider).createConversation(
            clientId: currentUser.id,
            workerId: proId,
            jobPostId: job.id,
            workerDisplayName: proName.isNotEmpty ? proName : 'Profesional',
            workerAvatarId: proposal.workerAvatarId,
            clientDisplayName: currentUser.name,
          );
          
          // 3. Send notification to the hired worker
          await ref.read(notificationServiceProvider).notifyWorkerHired(
            workerId: proId,
            jobPostId: job.id,
            jobTitle: job.customTitle ?? job.titleKey,
            clientName: currentUser.name,
          );
        }
        
        ref.invalidate(jobPostProvider(job.id));
        ref.invalidate(jobPostsProvider);
        ref.invalidate(proposalsForJobProvider(job.id));
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.hireSuccessMessage),
            backgroundColor: YuvaColors.success,
          ),
        );
        Navigator.of(context).pop();
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

  String _budgetCopy(AppLocalizations l10n, JobPost job, Proposal proposal, BuildContext context) {
    if (proposal.proposedHourlyRate != null) {
      return l10n.perHour('\$${formatAmount(proposal.proposedHourlyRate!, context)}');
    }
    if (proposal.proposedFixedPrice != null) {
      return l10n.fixedPriceLabel(formatAmount(proposal.proposedFixedPrice!, context));
    }
    return l10n.budgetCopyFallback;
  }

  String _resolveJobTitle(AppLocalizations l10n, JobPost job) {
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
}
