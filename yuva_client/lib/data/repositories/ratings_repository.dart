import '../models/rating.dart';

/// Abstraction for ratings data access. Implementations can be swapped
/// for real backends in future phases.
abstract class RatingsRepository {
  Future<List<Rating>> getRatingsForUser(String userId);
  Future<Rating?> getRatingForBooking(String bookingId);
  Future<Rating?> getRatingForJob(String jobPostId);
  Future<Rating> submitRating(Rating rating);
}
