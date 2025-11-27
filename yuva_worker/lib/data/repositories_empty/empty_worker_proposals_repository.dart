import '../models/worker_proposal.dart';
import '../repositories/worker_proposals_repository.dart';

/// Empty implementation that returns empty lists when dummy mode is OFF
class EmptyWorkerProposalsRepository implements WorkerProposalsRepository {
  @override
  Future<List<WorkerProposal>> getMyProposals({WorkerProposalFilter? filter}) async {
    return [];
  }

  @override
  Future<WorkerProposal?> getProposalForJob(String jobPostId) async {
    return null;
  }

  @override
  Future<WorkerProposal> createDraftProposal(String jobPostId) async {
    throw UnimplementedError('Proposals not available in empty mode');
  }

  @override
  Future<WorkerProposal> updateProposal(WorkerProposal proposal) async {
    throw UnimplementedError('Proposals not available in empty mode');
  }

  @override
  Future<WorkerProposal> submitProposal(String proposalId) async {
    throw UnimplementedError('Proposals not available in empty mode');
  }

  @override
  Future<void> deleteDraft(String proposalId) async {
    // No-op
  }

  @override
  Future<void> withdrawProposal(String proposalId, String jobPostId) async {
    throw UnimplementedError('Proposals not available in empty mode');
  }
}

