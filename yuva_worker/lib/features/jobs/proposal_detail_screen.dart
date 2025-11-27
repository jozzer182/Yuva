import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'job_detail_screen.dart';
import 'prepare_proposal_screen.dart';

/// Screen for viewing and managing an existing proposal
class ProposalDetailScreen extends ConsumerStatefulWidget {
  final WorkerProposal proposal;
  final int proposalNumber;

  const ProposalDetailScreen({
    super.key,
    required this.proposal,
    required this.proposalNumber,
  });

  @override
  ConsumerState<ProposalDetailScreen> createState() => _ProposalDetailScreenState();
}

class _ProposalDetailScreenState extends ConsumerState<ProposalDetailScreen> {
  WorkerJobDetail? _job;
  bool _isLoadingJob = true;
  bool _isWithdrawing = false;

  @override
  void initState() {
    super.initState();
    _loadJob();
  }

  Future<void> _loadJob() async {
    final repo = ref.read(workerJobFeedRepositoryProvider);
    final job = await repo.getJobDetail(widget.proposal.jobPostId);

    if (mounted) {
      setState(() {
        _job = job;
        _isLoadingJob = false;
      });
    }
  }

  Future<void> _withdrawProposal() async {
    final l10n = AppLocalizations.of(context)!;
    
    // Confirm withdrawal
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.withdrawProposal),
        content: Text(l10n.withdrawProposalConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.withdraw, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isWithdrawing = true);

    try {
      final repo = ref.read(workerProposalsRepositoryProvider);
      await repo.withdrawProposal(widget.proposal.jobPostId, widget.proposal.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.proposalWithdrawnSuccess)),
        );
        Navigator.of(context).pop(true); // Return true to indicate refresh needed
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isWithdrawing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final proposal = widget.proposal;
    final canModify = proposal.status.canModify;

    return Scaffold(
      backgroundColor: isDark ? YuvaColors.darkBackground : YuvaColors.backgroundLight,
      appBar: AppBar(
        title: Text(l10n.proposalDetails),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Proposal status header
            YuvaCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.proposalForJob(widget.proposalNumber.toString()),
                          style: YuvaTypography.subtitle(),
                        ),
                      ),
                      YuvaChip(
                        label: _getStatusLabel(l10n, proposal.status),
                        chipStyle: _getStatusStyle(proposal.status),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Amount
                  Row(
                    children: [
                      Icon(Icons.monetization_on_outlined, 
                        color: isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal),
                      const SizedBox(width: 8),
                      Text(
                        _getAmountText(l10n, proposal),
                        style: YuvaTypography.subtitle().copyWith(
                          color: isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal,
                        ),
                      ),
                    ],
                  ),
                  
                  if (proposal.coverLetterKey.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(l10n.proposalMessage, style: YuvaTypography.caption(color: YuvaColors.textSecondary)),
                    const SizedBox(height: 4),
                    Text(proposal.coverLetterKey, style: YuvaTypography.body()),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Job details card
            if (_isLoadingJob)
              const Center(child: CircularProgressIndicator())
            else if (_job != null)
              YuvaCard(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => JobDetailScreen(jobId: widget.proposal.jobPostId),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(l10n.jobDetailTitle, style: YuvaTypography.subtitle()),
                        ),
                        Icon(Icons.chevron_right, color: YuvaColors.textSecondary),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _job!.customTitle ?? _job!.titleKey,
                      style: YuvaTypography.body(),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _job!.areaLabel,
                      style: YuvaTypography.caption(color: YuvaColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        YuvaChip(
                          label: _getPropertyType(l10n, _job!.propertyDetails.type),
                          chipStyle: YuvaChipStyle.neutral,
                        ),
                        YuvaChip(
                          label: l10n.roomsCount(_job!.propertyDetails.bedrooms, _job!.propertyDetails.bathrooms),
                          chipStyle: YuvaChipStyle.neutral,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Actions
            if (canModify && _job != null) ...[
              // Edit button
              SizedBox(
                width: double.infinity,
                child: YuvaButton(
                  text: l10n.editProposal,
                  buttonStyle: YuvaButtonStyle.primary,
                  onPressed: () async {
                    final result = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (_) => PrepareProposalScreen(
                          job: _job!,
                          existingProposal: proposal,
                        ),
                      ),
                    );
                    // Refresh if proposal was updated
                    if (result == true && mounted) {
                      Navigator.of(context).pop(true);
                    }
                  },
                  icon: Icons.edit,
                ),
              ),
              const SizedBox(height: 12),
              // Withdraw button
              SizedBox(
                width: double.infinity,
                child: YuvaButton(
                  text: l10n.withdraw,
                  buttonStyle: YuvaButtonStyle.secondary,
                  onPressed: _isWithdrawing ? null : _withdrawProposal,
                  isLoading: _isWithdrawing,
                  icon: Icons.cancel_outlined,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getAmountText(AppLocalizations l10n, WorkerProposal proposal) {
    if (proposal.proposedFixedPrice != null) {
      return l10n.fixedBudget('\$${formatAmount(proposal.proposedFixedPrice!, context)}');
    } else if (proposal.proposedHourlyRate != null) {
      return l10n.perHour('\$${formatAmount(proposal.proposedHourlyRate!, context)}');
    }
    return '';
  }

  String _getStatusLabel(AppLocalizations l10n, WorkerProposalStatus status) {
    switch (status) {
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

  YuvaChipStyle _getStatusStyle(WorkerProposalStatus status) {
    switch (status) {
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
}
