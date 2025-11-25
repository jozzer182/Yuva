import '../models/worker_review.dart';
import '../repositories/worker_reviews_repository.dart';

/// Empty implementation that returns empty lists and zero rating when dummy mode is OFF
class EmptyWorkerReviewsRepository implements WorkerReviewsRepository {
  @override
  Future<List<WorkerReview>> getMyReviews() async {
    return [];
  }

  @override
  Future<double> getAverageRating() async {
    return 0.0;
  }
}

