import 'package:equatable/equatable.dart';

/// Local-only rating model for Phase 3.
/// Backend implementations can map this DTO to remote payloads later on.
class Rating extends Equatable {
  final String id;
  final String? bookingId;
  final String? jobPostId;
  final String? proId;
  final String userId;
  final int ratingValue; // 1-5
  final String? comment;
  final DateTime createdAt;

  const Rating({
    required this.id,
    this.bookingId,
    this.jobPostId,
    this.proId,
    required this.userId,
    required this.ratingValue,
    this.comment,
    required this.createdAt,
  });

  Rating copyWith({
    String? id,
    String? bookingId,
    String? jobPostId,
    String? proId,
    String? userId,
    int? ratingValue,
    String? comment,
    DateTime? createdAt,
  }) {
    return Rating(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      jobPostId: jobPostId ?? this.jobPostId,
      proId: proId ?? this.proId,
      userId: userId ?? this.userId,
      ratingValue: ratingValue ?? this.ratingValue,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, bookingId, jobPostId, proId, userId, ratingValue, comment, createdAt];
}
