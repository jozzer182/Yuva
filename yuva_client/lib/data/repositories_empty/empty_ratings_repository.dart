import '../models/rating.dart';
import '../repositories/ratings_repository.dart';

/// Empty implementation of RatingsRepository for when dummy mode is OFF.
/// Returns empty lists and null values.
class EmptyRatingsRepository implements RatingsRepository {
  @override
  Future<List<Rating>> getRatingsForUser(String userId) async {
    return const [];
  }

  @override
  Future<Rating?> getRatingForBooking(String bookingId) async {
    return null;
  }

  @override
  Future<Rating?> getRatingForJob(String jobPostId) async {
    return null;
  }

  @override
  Future<Rating> submitRating(Rating rating) async {
    // In empty mode, just return the rating as-is (no persistence)
    return rating.copyWith(
      id: rating.id.isEmpty ? 'empty_${DateTime.now().millisecondsSinceEpoch}' : rating.id,
    );
  }
}
