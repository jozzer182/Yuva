import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/models/rating.dart';

final userRatingsProvider = FutureProvider.autoDispose<List<Rating>>((ref) async {
  final ratingsRepository = ref.read(ratingsRepositoryProvider);
  final userId = ref.watch(currentUserProvider)?.id ?? 'demo-user';
  return ratingsRepository.getRatingsForUser(userId);
});

final bookingRatingProvider =
    FutureProvider.autoDispose.family<Rating?, String>((ref, bookingId) async {
  final ratingsRepository = ref.read(ratingsRepositoryProvider);
  return ratingsRepository.getRatingForBooking(bookingId);
});

final jobRatingProvider = FutureProvider.autoDispose.family<Rating?, String>((ref, jobPostId) async {
  final ratingsRepository = ref.read(ratingsRepositoryProvider);
  return ratingsRepository.getRatingForJob(jobPostId);
});
