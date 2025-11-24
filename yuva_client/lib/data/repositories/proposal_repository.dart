import '../models/job_models.dart';

/// Repository abstraction for proposals/applications to a job post.
abstract class ProposalRepository {
  Future<List<Proposal>> getProposalsForJob(String jobPostId);
  Future<Proposal> submitProposal(Proposal proposal);
  Future<Proposal> updateProposalStatus(String proposalId, ProposalStatus status);
}
