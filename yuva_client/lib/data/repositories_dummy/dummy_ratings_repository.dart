import 'dart:math';

import '../models/rating.dart';
import '../repositories/ratings_repository.dart';

/// In-memory implementation for Phase 3/4 UI work.
class DummyRatingsRepository implements RatingsRepository {
  DummyRatingsRepository() {
    _seedInitialRatings();
  }

  static const _latency = Duration(milliseconds: 380);
  final List<Rating> _ratings = [];

  @override
  Future<List<Rating>> getRatingsForUser(String userId) async {
    await Future.delayed(_latency);
    return _ratings.where((rating) => rating.userId == userId).toList(growable: false);
  }

  @override
  Future<Rating?> getRatingForBooking(String bookingId) async {
    await Future.delayed(_latency);
    try {
      return _ratings.firstWhere((rating) => rating.bookingId == bookingId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Rating?> getRatingForJob(String jobPostId) async {
    await Future.delayed(_latency);
    try {
      return _ratings.firstWhere((rating) => rating.jobPostId == jobPostId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Rating> submitRating(Rating rating) async {
    await Future.delayed(_latency);
    final normalized = rating.copyWith(
      id: rating.id.isEmpty ? _generateId() : rating.id,
      createdAt: rating.createdAt,
    );
    final existingIndex = _ratings.indexWhere((element) {
      final matchesBooking =
          normalized.bookingId != null && normalized.bookingId!.isNotEmpty && element.bookingId == normalized.bookingId;
      final matchesJob =
          normalized.jobPostId != null && normalized.jobPostId!.isNotEmpty && element.jobPostId == normalized.jobPostId;
      return matchesBooking || matchesJob;
    });
    if (existingIndex >= 0) {
      _ratings[existingIndex] = normalized;
    } else {
      _ratings.insert(0, normalized);
    }
    return normalized;
  }

  void _seedInitialRatings() {
    _ratings.add(
      Rating(
        id: 'rt_seed_1',
        bookingId: 'bk_lastWeek',
        userId: 'demo-user',
        ratingValue: 5,
        comment: 'La casa quedó impecable y llegaron a tiempo. ¡Gracias!',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
    );
    _ratings.add(
      Rating(
        id: 'rt_job_completed',
        jobPostId: 'job_completed_office',
        proId: 'pro_camila',
        userId: 'demo-user',
        ratingValue: 5,
        comment: 'Excelente detalle en la oficina, todo organizado.',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    );
  }

  String _generateId() {
    final random = Random();
    return 'rt_${DateTime.now().millisecondsSinceEpoch}_${random.nextInt(9999)}';
  }
}
