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
    // Filter to only show active proposals (exclude withdrawn/rejected)
    return _store.proposals
        .where((proposal) => 
            proposal.jobPostId == jobPostId && 
            proposal.status.isActiveForClient)
        .toList(growable: false);
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
  Future<Proposal> updateProposalStatus({
    required String jobPostId,
    required String proposalId,
    required ProposalStatus status,
  }) async {
    await Future.delayed(_latency);
    final index = _store.proposals.indexWhere(
      (element) => element.id == proposalId && element.jobPostId == jobPostId,
    );
    if (index == -1) {
      throw StateError('Proposal $proposalId not found');
    }
    
    final current = _store.proposals[index];
    
    // Validate status transition
    if (!_canTransitionTo(current.status, status)) {
      throw StateError('Cannot change proposal status from ${current.status.name} to ${status.name}');
    }
    
    final updated = current.copyWith(status: status);
    _store.proposals[index] = updated;
    return updated;
  }
  
  /// Validates if a status transition is allowed
  bool _canTransitionTo(ProposalStatus currentStatus, ProposalStatus newStatus) {
    // Terminal states - no transitions allowed
    if (currentStatus == ProposalStatus.hired || currentStatus == ProposalStatus.withdrawn) {
      return false;
    }
    
    // From rejected, only allow if going back to shortlisted (undo reject)
    if (currentStatus == ProposalStatus.rejected) {
      return newStatus == ProposalStatus.shortlisted;
    }
    
    // From submitted, can go to shortlisted, rejected, or hired
    if (currentStatus == ProposalStatus.submitted) {
      return [ProposalStatus.shortlisted, ProposalStatus.rejected, ProposalStatus.hired].contains(newStatus);
    }
    
    // From shortlisted, can go to rejected or hired
    if (currentStatus == ProposalStatus.shortlisted) {
      return [ProposalStatus.rejected, ProposalStatus.hired].contains(newStatus);
    }
    
    return false;
  }
}
