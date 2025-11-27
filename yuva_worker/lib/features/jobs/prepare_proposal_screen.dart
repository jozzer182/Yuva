import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuva_worker/l10n/app_localizations.dart';
import '../../utils/money_formatter.dart';
import '../../core/providers.dart';
import '../../data/models/shared_types.dart';
import '../../data/models/worker_job.dart';
import '../../data/models/worker_proposal.dart';
import '../../data/repositories_firestore/firestore_worker_proposals_repository.dart';
import '../../design_system/colors.dart';
import '../../design_system/components/yuva_button.dart';
import '../../design_system/components/yuva_card.dart';
import '../../design_system/typography.dart';

/// Screen for workers to prepare and submit a proposal for a job.
/// Can also be used to edit an existing proposal.
class PrepareProposalScreen extends ConsumerStatefulWidget {
  final WorkerJobDetail job;
  /// If provided, the screen will be in edit mode
  final WorkerProposal? existingProposal;

  const PrepareProposalScreen({
    super.key,
    required this.job,
    this.existingProposal,
  });

  bool get isEditMode => existingProposal != null;

  @override
  ConsumerState<PrepareProposalScreen> createState() => _PrepareProposalScreenState();
}

class _PrepareProposalScreenState extends ConsumerState<PrepareProposalScreen> {
  late TextEditingController _amountController;
  late TextEditingController _messageController;
  late TextEditingController _hoursController;

  late JobBudgetType _selectedBudgetType;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    
    final existing = widget.existingProposal;
    
    if (existing != null) {
      // Edit mode - pre-fill with existing proposal data
      _selectedBudgetType = existing.budgetType;
      if (_selectedBudgetType == JobBudgetType.fixed) {
        _amountController = TextEditingController(
          text: existing.proposedFixedPrice?.toStringAsFixed(0) ?? '',
        );
      } else {
        _amountController = TextEditingController(
          text: existing.proposedHourlyRate?.toStringAsFixed(0) ?? '',
        );
      }
      _messageController = TextEditingController(text: existing.coverLetterKey);
      _hoursController = TextEditingController(
        text: existing.estimatedHours?.toString() ?? '4',
      );
    } else {
      // New proposal - pre-fill with job's suggested budget
      _selectedBudgetType = widget.job.budgetType;
      if (_selectedBudgetType == JobBudgetType.fixed) {
        _amountController = TextEditingController(
          text: widget.job.fixedBudget?.toStringAsFixed(0) ?? '',
        );
      } else {
        _amountController = TextEditingController(
          text: widget.job.hourlyRateFrom?.toStringAsFixed(0) ?? '',
        );
      }
      _messageController = TextEditingController();
      _hoursController = TextEditingController(text: '4');
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _messageController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? YuvaColors.darkBackground : YuvaColors.backgroundLight,
      appBar: AppBar(
        title: Text(widget.isEditMode ? l10n.editProposal : l10n.prepareProposal),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job summary card
            YuvaCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.job.customTitle ?? l10n.jobDetailTitle,
                    style: YuvaTypography.subtitle(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: YuvaColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        widget.job.areaLabel,
                        style: YuvaTypography.caption(color: YuvaColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.attach_money, size: 16, color: YuvaColors.primaryTeal),
                      const SizedBox(width: 4),
                      Text(
                        _getClientBudgetText(l10n),
                        style: YuvaTypography.caption(color: YuvaColors.primaryTeal),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Budget type selector
            Text(l10n.proposalBudgetType, style: YuvaTypography.subtitle()),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: [
                ChoiceChip(
                  label: Text(l10n.budgetHourly),
                  selected: _selectedBudgetType == JobBudgetType.hourly,
                  onSelected: (_) => setState(() => _selectedBudgetType = JobBudgetType.hourly),
                ),
                ChoiceChip(
                  label: Text(l10n.budgetFixed),
                  selected: _selectedBudgetType == JobBudgetType.fixed,
                  onSelected: (_) => setState(() => _selectedBudgetType = JobBudgetType.fixed),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Amount input
            Text(
              _selectedBudgetType == JobBudgetType.hourly
                  ? l10n.proposalHourlyRate
                  : l10n.proposalFixedPrice,
              style: YuvaTypography.subtitle(),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: '\$ ',
                hintText: _selectedBudgetType == JobBudgetType.hourly
                    ? l10n.proposalHourlyRateHint
                    : l10n.proposalFixedPriceHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Estimated hours (for hourly)
            if (_selectedBudgetType == JobBudgetType.hourly) ...[
              Text(l10n.proposalEstimatedHours, style: YuvaTypography.subtitle()),
              const SizedBox(height: 8),
              TextField(
                controller: _hoursController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: l10n.proposalEstimatedHoursHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Message to client
            Text(l10n.proposalMessage, style: YuvaTypography.subtitle()),
            const SizedBox(height: 8),
            TextField(
              controller: _messageController,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: l10n.proposalMessageHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Total estimate display
            if (_selectedBudgetType == JobBudgetType.hourly) ...[
              YuvaCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.proposalTotalEstimate, style: YuvaTypography.body()),
                    Text(
                      _calculateTotal(),
                      style: YuvaTypography.subtitle().copyWith(
                        color: YuvaColors.primaryTeal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Submit/Update button
            SizedBox(
              width: double.infinity,
              child: YuvaButton(
                text: widget.isEditMode ? l10n.updateProposal : l10n.submitProposal,
                onPressed: _isSubmitting ? null : _submitProposal,
                isLoading: _isSubmitting,
                icon: widget.isEditMode ? Icons.save : Icons.send,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getClientBudgetText(AppLocalizations l10n) {
    if (widget.job.budgetType == JobBudgetType.fixed) {
      return l10n.clientBudgetFixed('\$${formatAmount(widget.job.fixedBudget ?? 0, context)}');
    } else {
      return l10n.clientBudgetHourly(
        '\$${formatAmount(widget.job.hourlyRateFrom ?? 0, context)}',
        '\$${formatAmount(widget.job.hourlyRateTo ?? 0, context)}',
      );
    }
  }

  String _calculateTotal() {
    final rate = double.tryParse(_amountController.text) ?? 0;
    final hours = int.tryParse(_hoursController.text) ?? 0;
    final total = rate * hours;
    return '\$${formatAmount(total, context)}';
  }

  Future<void> _submitProposal() async {
    final l10n = AppLocalizations.of(context)!;
    
    // Validate amount
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.proposalAmountRequired),
          backgroundColor: YuvaColors.error,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final repo = ref.read(workerProposalsRepositoryProvider);
      
      if (widget.isEditMode) {
        // Update existing proposal
        await _updateExistingProposal(repo, amount);
      } else {
        // Create new proposal
        final proposal = await _createNewProposal(repo, amount);
        
        // Send notification to client about new proposal
        if (proposal != null && widget.job.clientId.isNotEmpty) {
          final workerUser = ref.read(workerUserProvider);
          debugPrint('📢 Sending notification to client: ${widget.job.clientId}');
          debugPrint('📢 Job: ${widget.job.id}, Proposal: ${proposal.id}');
          await ref.read(workerNotificationServiceProvider).notifyClientNewProposal(
            clientId: widget.job.clientId,
            jobPostId: widget.job.id,
            proposalId: proposal.id,
            jobTitle: widget.job.customTitle ?? widget.job.titleKey,
            workerName: workerUser?.displayName ?? 'Un profesional',
          );
          debugPrint('📢 Notification sent successfully');
        } else {
          debugPrint('⚠️ Cannot send notification - proposal: $proposal, clientId: "${widget.job.clientId}"');
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.isEditMode 
                ? l10n.proposalUpdatedSuccess 
                : l10n.proposalSubmittedSuccess),
            backgroundColor: YuvaColors.success,
          ),
        );
        Navigator.of(context).pop(true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.proposalSubmitError),
            backgroundColor: YuvaColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<WorkerProposal?> _createNewProposal(dynamic repo, double amount) async {
    // Check if using Firestore repository with createAndSubmitProposal
    if (repo is FirestoreWorkerProposalsRepository) {
      return await repo.createAndSubmitProposal(
        jobPostId: widget.job.id,
        budgetType: _selectedBudgetType,
        proposedHourlyRate: _selectedBudgetType == JobBudgetType.hourly ? amount : null,
        proposedFixedPrice: _selectedBudgetType == JobBudgetType.fixed ? amount : null,
        estimatedHours: _selectedBudgetType == JobBudgetType.hourly
            ? int.tryParse(_hoursController.text)
            : null,
        message: _messageController.text.trim(),
      );
    } else {
      // Dummy mode - create draft and submit
      final draft = await repo.createDraftProposal(widget.job.id);
      final updated = draft.copyWith(
        proposedHourlyRate: _selectedBudgetType == JobBudgetType.hourly ? amount : null,
        proposedFixedPrice: _selectedBudgetType == JobBudgetType.fixed ? amount : null,
        budgetType: _selectedBudgetType,
        estimatedHours: _selectedBudgetType == JobBudgetType.hourly
            ? int.tryParse(_hoursController.text)
            : null,
        coverLetterKey: _messageController.text.trim(),
      );
      await repo.updateProposal(updated);
      return await repo.submitProposal(draft.id);
    }
  }

  Future<void> _updateExistingProposal(dynamic repo, double amount) async {
    final existing = widget.existingProposal!;
    
    if (repo is FirestoreWorkerProposalsRepository) {
      await repo.updateProposalFields(
        jobPostId: existing.jobPostId,
        proposalId: existing.id,
        proposedHourlyRate: _selectedBudgetType == JobBudgetType.hourly ? amount : null,
        proposedFixedPrice: _selectedBudgetType == JobBudgetType.fixed ? amount : null,
        budgetType: _selectedBudgetType,
        estimatedHours: _selectedBudgetType == JobBudgetType.hourly
            ? int.tryParse(_hoursController.text)
            : null,
        message: _messageController.text.trim(),
      );
    } else {
      // Dummy mode
      final updated = existing.copyWith(
        proposedHourlyRate: _selectedBudgetType == JobBudgetType.hourly ? amount : null,
        proposedFixedPrice: _selectedBudgetType == JobBudgetType.fixed ? amount : null,
        budgetType: _selectedBudgetType,
        estimatedHours: _selectedBudgetType == JobBudgetType.hourly
            ? int.tryParse(_hoursController.text)
            : null,
        coverLetterKey: _messageController.text.trim(),
      );
      await repo.updateProposal(updated);
    }
  }
}
