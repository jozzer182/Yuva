import 'package:equatable/equatable.dart';

/// Review/rating given by a client to a worker after job completion
/// Aligned with WorkerReview in yuva_worker
class ClientReview extends Equatable {
  final String id;
  final String activeJobId; // References ClientActiveJob.id
  final String jobPostId; // Also reference original job post
  final String workerId;
  final String workerDisplayName;
  final double rating; // 1.0 - 5.0
  final String comment;
  final DateTime createdAt;

  const ClientReview({
    required this.id,
    required this.activeJobId,
    required this.jobPostId,
    required this.workerId,
    required this.workerDisplayName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  ClientReview copyWith({
    String? id,
    String? activeJobId,
    String? jobPostId,
    String? workerId,
    String? workerDisplayName,
    double? rating,
    String? comment,
    DateTime? createdAt,
  }) {
    return ClientReview(
      id: id ?? this.id,
      activeJobId: activeJobId ?? this.activeJobId,
      jobPostId: jobPostId ?? this.jobPostId,
      workerId: workerId ?? this.workerId,
      workerDisplayName: workerDisplayName ?? this.workerDisplayName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        activeJobId,
        jobPostId,
        workerId,
        workerDisplayName,
        rating,
        comment,
        createdAt,
      ];
}

