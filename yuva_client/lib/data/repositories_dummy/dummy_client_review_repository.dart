import '../repositories/client_review_repository.dart';
import '../models/client_review.dart';
import 'marketplace_memory_store.dart';

class DummyClientReviewRepository implements ClientReviewRepository {
  DummyClientReviewRepository({MarketplaceMemoryStore? store})
      : _store = store ?? MarketplaceMemoryStore.instance;

  static const _latency = Duration(milliseconds: 400);
  final MarketplaceMemoryStore _store;

  @override
  Future<List<ClientReview>> getReviewsForWorker(String workerId) async {
    await Future.delayed(_latency);
    return _store.reviews
        .where((review) => review.workerId == workerId)
        .toList(growable: false);
  }

  @override
  Future<ClientReview?> getReviewForActiveJob(String activeJobId) async {
    await Future.delayed(_latency);
    try {
      return _store.reviews.firstWhere((review) => review.activeJobId == activeJobId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<ClientReview> createReview(ClientReview review) async {
    await Future.delayed(_latency);
    final resolvedId = review.id.isEmpty ? _store.generateId('review') : review.id;
    final newReview = review.copyWith(id: resolvedId);
    _store.reviews.add(newReview);
    return newReview;
  }
}

