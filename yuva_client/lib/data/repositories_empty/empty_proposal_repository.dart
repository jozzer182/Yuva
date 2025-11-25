import '../models/job_models.dart';
import '../repositories/proposal_repository.dart';

/// Empty implementation that returns empty lists when dummy mode is OFF
class EmptyProposalRepository implements ProposalRepository {
  @override
  Future<List<Proposal>> getProposalsForJob(String jobPostId) async {
    return [];
  }

  @override
  Future<Proposal> submitProposal(Proposal proposal) async {
    throw UnimplementedError('Proposals not available in empty mode');
  }

  @override
  Future<Proposal> updateProposalStatus(String proposalId, ProposalStatus status) async {
    throw UnimplementedError('Proposals not available in empty mode');
  }
}

