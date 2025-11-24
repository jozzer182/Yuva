import '../repositories/worker_reviews_repository.dart';
import '../models/worker_review.dart';

/// Dummy implementation with data aligned to yuva_client
/// Reviews correspond to ClientReview in yuva_client
class DummyWorkerReviewsRepository implements WorkerReviewsRepository {
  final List<WorkerReview> _reviews = [
    // Aligned with yuva_client: review_office_1 for active_job_office
    WorkerReview(
      id: 'review_office_1',
      activeJobId: 'active_job_office',
      clientDisplayName: 'Cliente Demo',
      rating: 5.0,
      comment: 'Excelente trabajo, muy profesional y puntual',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];

  @override
  Future<List<WorkerReview>> getMyReviews() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_reviews);
  }

  @override
  Future<double> getAverageRating() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_reviews.isEmpty) return 0.0;
    final sum = _reviews.fold<double>(0.0, (sum, review) => sum + review.rating);
    return sum / _reviews.length;
  }
}