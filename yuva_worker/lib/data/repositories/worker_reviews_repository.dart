import '../models/worker_review.dart';

abstract class WorkerReviewsRepository {
  Future<List<WorkerReview>> getMyReviews();
  Future<double> getAverageRating();
}