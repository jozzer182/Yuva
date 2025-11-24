import 'package:equatable/equatable.dart';

class WorkerReview extends Equatable {
  final String id;
  final String activeJobId;
  final String clientDisplayName;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const WorkerReview({
    required this.id,
    required this.activeJobId,
    required this.clientDisplayName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, activeJobId, clientDisplayName, rating, comment, createdAt];
}