import 'package:equatable/equatable.dart';
import 'shared_types.dart';

/// Estados de un trabajo activo desde la perspectiva del trabajador
enum WorkerActiveJobStatus { upcoming, inProgress, completed, cancelled }

extension WorkerActiveJobStatusLabel on WorkerActiveJobStatus {
  String get labelKey {
    switch (this) {
      case WorkerActiveJobStatus.upcoming:
        return 'activeJobStatusUpcoming';
      case WorkerActiveJobStatus.inProgress:
        return 'activeJobStatusInProgress';
      case WorkerActiveJobStatus.completed:
        return 'activeJobStatusCompleted';
      case WorkerActiveJobStatus.cancelled:
        return 'activeJobStatusCancelled';
    }
  }
}

/// Trabajo activo/contrato donde el trabajador ha sido contratado
class WorkerActiveJob extends Equatable {
  final String id;
  final String jobPostId;
  final String workerProposalId;
  final String clientDisplayName;
  final String jobTitleKey;
  final String areaLabel;
  final DateTime scheduledDateTime;
  final double agreedPrice;
  final JobFrequency frequency;
  final WorkerActiveJobStatus status;
  final DateTime createdAt;

  const WorkerActiveJob({
    required this.id,
    required this.jobPostId,
    required this.workerProposalId,
    required this.clientDisplayName,
    required this.jobTitleKey,
    required this.areaLabel,
    required this.scheduledDateTime,
    required this.agreedPrice,
    required this.frequency,
    this.status = WorkerActiveJobStatus.upcoming,
    required this.createdAt,
  });

  WorkerActiveJob copyWith({
    String? id,
    String? jobPostId,
    String? workerProposalId,
    String? clientDisplayName,
    String? jobTitleKey,
    String? areaLabel,
    DateTime? scheduledDateTime,
    double? agreedPrice,
    JobFrequency? frequency,
    WorkerActiveJobStatus? status,
    DateTime? createdAt,
  }) {
    return WorkerActiveJob(
      id: id ?? this.id,
      jobPostId: jobPostId ?? this.jobPostId,
      workerProposalId: workerProposalId ?? this.workerProposalId,
      clientDisplayName: clientDisplayName ?? this.clientDisplayName,
      jobTitleKey: jobTitleKey ?? this.jobTitleKey,
      areaLabel: areaLabel ?? this.areaLabel,
      scheduledDateTime: scheduledDateTime ?? this.scheduledDateTime,
      agreedPrice: agreedPrice ?? this.agreedPrice,
      frequency: frequency ?? this.frequency,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        jobPostId,
        workerProposalId,
        clientDisplayName,
        jobTitleKey,
        areaLabel,
        scheduledDateTime,
        agreedPrice,
        frequency,
        status,
        createdAt,
      ];
}
