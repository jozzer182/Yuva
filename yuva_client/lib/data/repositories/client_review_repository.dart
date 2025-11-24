import '../models/client_review.dart';

abstract class ClientReviewRepository {
  Future<List<ClientReview>> getReviewsForWorker(String workerId);
  Future<ClientReview?> getReviewForActiveJob(String activeJobId);
  Future<ClientReview> createReview(ClientReview review);
}

