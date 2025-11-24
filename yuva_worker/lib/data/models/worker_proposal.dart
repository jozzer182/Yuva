import 'package:equatable/equatable.dart';
import 'shared_types.dart';

/// Estados de una propuesta desde la perspectiva del trabajador
enum WorkerProposalStatus { draft, submitted, shortlisted, rejected, hired }

extension WorkerProposalStatusLabel on WorkerProposalStatus {
  String get labelKey {
    switch (this) {
      case WorkerProposalStatus.draft:
        return 'proposalStatusDraft';
      case WorkerProposalStatus.submitted:
        return 'proposalStatusSubmitted';
      case WorkerProposalStatus.shortlisted:
        return 'proposalStatusShortlisted';
      case WorkerProposalStatus.rejected:
        return 'proposalStatusRejected';
      case WorkerProposalStatus.hired:
        return 'proposalStatusHired';
    }
  }
}

/// Propuesta de trabajo enviada por un trabajador
class WorkerProposal extends Equatable {
  final String id;
  final String jobPostId;
  final String workerId;
  final double? proposedHourlyRate;
  final double? proposedFixedPrice;
  final JobBudgetType budgetType;
  final int? estimatedHours;
  final String coverLetterKey;
  final WorkerProposalStatus status;
  final DateTime createdAt;
  final DateTime? lastUpdatedAt;

  const WorkerProposal({
    required this.id,
    required this.jobPostId,
    required this.workerId,
    this.proposedHourlyRate,
    this.proposedFixedPrice,
    required this.budgetType,
    this.estimatedHours,
    required this.coverLetterKey,
    this.status = WorkerProposalStatus.draft,
    required this.createdAt,
    this.lastUpdatedAt,
  });

  WorkerProposal copyWith({
    String? id,
    String? jobPostId,
    String? workerId,
    double? proposedHourlyRate,
    double? proposedFixedPrice,
    JobBudgetType? budgetType,
    int? estimatedHours,
    String? coverLetterKey,
    WorkerProposalStatus? status,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
  }) {
    return WorkerProposal(
      id: id ?? this.id,
      jobPostId: jobPostId ?? this.jobPostId,
      workerId: workerId ?? this.workerId,
      proposedHourlyRate: proposedHourlyRate ?? this.proposedHourlyRate,
      proposedFixedPrice: proposedFixedPrice ?? this.proposedFixedPrice,
      budgetType: budgetType ?? this.budgetType,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      coverLetterKey: coverLetterKey ?? this.coverLetterKey,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        jobPostId,
        workerId,
        proposedHourlyRate,
        proposedFixedPrice,
        budgetType,
        estimatedHours,
        coverLetterKey,
        status,
        createdAt,
        lastUpdatedAt,
      ];
}
