import '../repositories/client_active_job_repository.dart';
import '../models/active_job.dart';
import 'marketplace_memory_store.dart';

class DummyClientActiveJobRepository implements ClientActiveJobRepository {
  DummyClientActiveJobRepository({MarketplaceMemoryStore? store})
      : _store = store ?? MarketplaceMemoryStore.instance;

  static const _latency = Duration(milliseconds: 400);
  final MarketplaceMemoryStore _store;

  @override
  Future<List<ClientActiveJob>> getActiveJobsForClient(String userId) async {
    await Future.delayed(_latency);
    // Get active jobs for jobs posted by this user
    final userJobIds = _store.jobPosts
        .where((job) => job.userId == userId)
        .map((job) => job.id)
        .toSet();
    
    return _store.activeJobs
        .where((aj) => userJobIds.contains(aj.jobPostId))
        .toList(growable: false);
  }

  @override
  Future<ClientActiveJob?> getActiveJobById(String id) async {
    await Future.delayed(_latency);
    try {
      return _store.activeJobs.firstWhere((aj) => aj.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<ClientActiveJob?> getActiveJobByJobPostId(String jobPostId) async {
    await Future.delayed(_latency);
    try {
      return _store.activeJobs.firstWhere((aj) => aj.jobPostId == jobPostId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<ClientActiveJob> updateActiveJobStatus(
    String activeJobId,
    ClientActiveJobStatus status,
  ) async {
    await Future.delayed(_latency);
    final index = _store.activeJobs.indexWhere((aj) => aj.id == activeJobId);
    if (index == -1) {
      throw StateError('Active job $activeJobId not found');
    }

    final activeJob = _store.activeJobs[index];
    final updated = activeJob.copyWith(
      status: status,
      completedAt: status == ClientActiveJobStatus.completed ? DateTime.now() : activeJob.completedAt,
    );
    _store.activeJobs[index] = updated;
    return updated;
  }
}

