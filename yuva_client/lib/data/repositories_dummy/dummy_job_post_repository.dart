import '../models/job_models.dart';
import '../repositories/job_post_repository.dart';
import 'marketplace_memory_store.dart';

/// Dummy in-memory implementation for marketplace job posts.
class DummyJobPostRepository implements JobPostRepository {
  DummyJobPostRepository({MarketplaceMemoryStore? store})
      : _store = store ?? MarketplaceMemoryStore.instance;

  static const _latency = Duration(milliseconds: 450);
  final MarketplaceMemoryStore _store;

  @override
  Future<JobPost?> getJobPostById(String id) async {
    await Future.delayed(_latency);
    try {
      return _store.jobPosts.firstWhere((job) => job.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<JobPost>> getJobPostsForClient(String userId) async {
    await Future.delayed(_latency);
    return _store.jobPosts.where((job) => job.userId == userId).toList(growable: false);
  }

  @override
  Future<JobPost> createJobPost(JobPost post) async {
    await Future.delayed(_latency);
    final resolvedId = post.id.isEmpty ? _store.generateId('job') : post.id;
    final now = DateTime.now();
    final job = post.copyWith(
      id: resolvedId,
      createdAt: post.createdAt,
      updatedAt: now,
    );
    _store.jobPosts.insert(0, job);
    return job;
  }

  @override
  Future<JobPost> updateJobPost(JobPost post) async {
    await Future.delayed(_latency);
    final index = _store.jobPosts.indexWhere((element) => element.id == post.id);
    if (index == -1) {
      throw StateError('Job ${post.id} not found');
    }
    final updated = post.copyWith(updatedAt: DateTime.now());
    _store.jobPosts[index] = updated;
    return updated;
  }

  @override
  Future<JobPost> invitePro({required String jobPostId, required String proId}) async {
    await Future.delayed(_latency);
    final index = _store.jobPosts.indexWhere((element) => element.id == jobPostId);
    if (index == -1) {
      throw StateError('Job $jobPostId not found');
    }
    final job = _store.jobPosts[index];
    if (job.invitedProIds.contains(proId)) {
      return job;
    }
    final updated = job.copyWith(
      invitedProIds: [...job.invitedProIds, proId],
      updatedAt: DateTime.now(),
    );
    _store.jobPosts[index] = updated;
    return updated;
  }

  @override
  Future<JobPost> hireProposal({
    required String jobPostId,
    required String proposalId,
    required String proId,
  }) async {
    await Future.delayed(_latency);
    final index = _store.jobPosts.indexWhere((element) => element.id == jobPostId);
    if (index == -1) {
      throw StateError('Job $jobPostId not found');
    }

    final job = _store.jobPosts[index];
    
    // Find the hired proposal to calculate agreedPrice
    final hiredProposalIndex = _store.proposals.indexWhere((p) => p.id == proposalId);
    if (hiredProposalIndex == -1) {
      throw StateError('Proposal $proposalId not found');
    }
    
    final hiredProposal = _store.proposals[hiredProposalIndex];
    
    // Calculate agreedPrice based on proposal type
    double? agreedPrice;
    if (hiredProposal.proposedFixedPrice != null) {
      agreedPrice = hiredProposal.proposedFixedPrice;
    } else if (hiredProposal.proposedHourlyRate != null) {
      // For hourly, estimate based on job type (default 4 hours for standard, 6 for deep)
      final estimatedHours = job.serviceTypeId == 'deep' ? 6 : 4;
      agreedPrice = hiredProposal.proposedHourlyRate! * estimatedHours;
    }

    // Update proposal statuses in store and set agreedPrice
    for (var i = 0; i < _store.proposals.length; i++) {
      final proposal = _store.proposals[i];
      if (proposal.jobPostId != jobPostId) continue;
      if (proposal.id == proposalId) {
        _store.proposals[i] = proposal.copyWith(
          status: ProposalStatus.hired,
          agreedPrice: agreedPrice,
        );
      } else if (proposal.status != ProposalStatus.rejected) {
        _store.proposals[i] = proposal.copyWith(status: ProposalStatus.rejected);
      }
    }

    final updated = job.copyWith(
      status: JobPostStatus.hired,
      hiredProposalId: proposalId,
      hiredProId: proId,
      updatedAt: DateTime.now(),
    );
    _store.jobPosts[index] = updated;
    
    // Create or update active job
    _store.createActiveJobFromHiredProposal(
      job: updated,
      proposal: _store.proposals[hiredProposalIndex],
      agreedPrice: agreedPrice ?? 0,
    );
    
    return updated;
  }

  @override
  Future<JobPost> updateStatus({
    required String jobPostId,
    required JobPostStatus status,
  }) async {
    await Future.delayed(_latency);
    final index = _store.jobPosts.indexWhere((element) => element.id == jobPostId);
    if (index == -1) {
      throw StateError('Job $jobPostId not found');
    }
    final updated = _store.jobPosts[index].copyWith(status: status, updatedAt: DateTime.now());
    _store.jobPosts[index] = updated;
    return updated;
  }
}
