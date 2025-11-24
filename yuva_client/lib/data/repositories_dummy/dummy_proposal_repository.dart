import '../models/job_models.dart';
import '../repositories/proposal_repository.dart';
import 'marketplace_memory_store.dart';

/// Dummy in-memory implementation for proposals.
class DummyProposalRepository implements ProposalRepository {
  DummyProposalRepository({MarketplaceMemoryStore? store})
      : _store = store ?? MarketplaceMemoryStore.instance;

  static const _latency = Duration(milliseconds: 420);
  final MarketplaceMemoryStore _store;

  @override
  Future<List<Proposal>> getProposalsForJob(String jobPostId) async {
    await Future.delayed(_latency);
    return _store.proposals.where((proposal) => proposal.jobPostId == jobPostId).toList(growable: false);
  }

  @override
  Future<Proposal> submitProposal(Proposal proposal) async {
    await Future.delayed(_latency);
    final resolvedId = proposal.id.isEmpty ? _store.generateId('prop') : proposal.id;
    final normalized = proposal.copyWith(id: resolvedId, status: ProposalStatus.submitted);
    _store.proposals.insert(0, normalized);

    // Link proposal to job post.
    final jobIndex = _store.jobPosts.indexWhere((element) => element.id == proposal.jobPostId);
    if (jobIndex >= 0) {
      final job = _store.jobPosts[jobIndex];
      if (!job.proposalIds.contains(normalized.id)) {
        _store.jobPosts[jobIndex] = job.copyWith(
          proposalIds: [...job.proposalIds, normalized.id],
          status: job.status == JobPostStatus.draft ? JobPostStatus.open : job.status,
          updatedAt: DateTime.now(),
        );
      }
    }

    return normalized;
  }

  @override
  Future<Proposal> updateProposalStatus(String proposalId, ProposalStatus status) async {
    await Future.delayed(_latency);
    final index = _store.proposals.indexWhere((element) => element.id == proposalId);
    if (index == -1) {
      throw StateError('Proposal $proposalId not found');
    }
    final updated = _store.proposals[index].copyWith(status: status);
    _store.proposals[index] = updated;
    return updated;
  }
}
