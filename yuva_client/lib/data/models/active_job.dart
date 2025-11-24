import 'package:equatable/equatable.dart';
import 'booking_request.dart';

/// Estados de un trabajo activo desde la perspectiva del cliente
/// Alineado con WorkerActiveJobStatus en yuva_worker
enum ClientActiveJobStatus { upcoming, inProgress, completed, cancelled }

extension ClientActiveJobStatusLabel on ClientActiveJobStatus {
  String get labelKey {
    switch (this) {
      case ClientActiveJobStatus.upcoming:
        return 'activeJobStatusUpcoming';
      case ClientActiveJobStatus.inProgress:
        return 'activeJobStatusInProgress';
      case ClientActiveJobStatus.completed:
        return 'activeJobStatusCompleted';
      case ClientActiveJobStatus.cancelled:
        return 'activeJobStatusCancelled';
    }
  }
}

/// Trabajo activo/contrato desde la perspectiva del cliente
/// Alineado con WorkerActiveJob en yuva_worker
class ClientActiveJob extends Equatable {
  final String id;
  final String jobPostId;
  final String proposalId;
  final String workerId;
  final String workerDisplayName;
  final String jobTitleKey;
  final String? customTitle;
  final String areaLabel;
  final DateTime scheduledDateTime;
  final double agreedPrice;
  final BookingFrequency frequency;
  final ClientActiveJobStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;

  const ClientActiveJob({
    required this.id,
    required this.jobPostId,
    required this.proposalId,
    required this.workerId,
    required this.workerDisplayName,
    required this.jobTitleKey,
    this.customTitle,
    required this.areaLabel,
    required this.scheduledDateTime,
    required this.agreedPrice,
    required this.frequency,
    this.status = ClientActiveJobStatus.upcoming,
    required this.createdAt,
    this.completedAt,
  });

  ClientActiveJob copyWith({
    String? id,
    String? jobPostId,
    String? proposalId,
    String? workerId,
    String? workerDisplayName,
    String? jobTitleKey,
    String? customTitle,
    String? areaLabel,
    DateTime? scheduledDateTime,
    double? agreedPrice,
    BookingFrequency? frequency,
    ClientActiveJobStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return ClientActiveJob(
      id: id ?? this.id,
      jobPostId: jobPostId ?? this.jobPostId,
      proposalId: proposalId ?? this.proposalId,
      workerId: workerId ?? this.workerId,
      workerDisplayName: workerDisplayName ?? this.workerDisplayName,
      jobTitleKey: jobTitleKey ?? this.jobTitleKey,
      customTitle: customTitle ?? this.customTitle,
      areaLabel: areaLabel ?? this.areaLabel,
      scheduledDateTime: scheduledDateTime ?? this.scheduledDateTime,
      agreedPrice: agreedPrice ?? this.agreedPrice,
      frequency: frequency ?? this.frequency,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        jobPostId,
        proposalId,
        workerId,
        workerDisplayName,
        jobTitleKey,
        customTitle,
        areaLabel,
        scheduledDateTime,
        agreedPrice,
        frequency,
        status,
        createdAt,
        completedAt,
      ];
}

