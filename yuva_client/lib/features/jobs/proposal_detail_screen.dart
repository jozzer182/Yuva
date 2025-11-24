import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yuva/utils/money_formatter.dart';

import '../../core/providers.dart';
import '../../data/models/job_models.dart';
import '../../design_system/colors.dart';
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
                        CircleAvatar(
                          backgroundColor: YuvaColors.primaryTeal.withValues(alpha: 0.15),
                          child: Text(pro?.avatarInitials ?? pro?.displayName.characters.take(2).toString() ?? '?'),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(pro?.displayName ?? l10n.proDeleted, style: YuvaTypography.subtitle()),
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
                            onPressed: () => _updateStatus(ref, ProposalStatus.rejected),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: YuvaButton(
                            text: l10n.hireAction,
                            onPressed: pro == null ? null : () => _hire(ref, pro!.id, context, l10n),
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

  Future<void> _updateStatus(WidgetRef ref, ProposalStatus next) async {
    await ref.read(proposalRepositoryProvider).updateProposalStatus(proposal.id, next);
    ref.invalidate(proposalsForJobProvider(job.id));
  }

  Future<void> _hire(
    WidgetRef ref,
    String proId,
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    await ref.read(jobPostRepositoryProvider).hireProposal(
          jobPostId: job.id,
          proposalId: proposal.id,
          proId: proId,
        );
    ref.invalidate(jobPostProvider(job.id));
    ref.invalidate(jobPostsProvider);
    ref.invalidate(proposalsForJobProvider(job.id));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.hireSuccessMessage)),
    );
    Navigator.of(context).pop();
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
