/// Job & Proposal Lifecycle Contract
///
/// This file defines the canonical lifecycle states and helper functions
/// that ensure consistency between yuva_client and yuva_worker.
///
/// IMPORTANT: Both apps must follow this contract for proper synchronization.

import '../data/models/job_models.dart';

/// ============================================================================
/// CANONICAL STATUS ENUMS
/// ============================================================================

/// Job Post Status - Same in both apps
/// States: draft, open, underReview, hired, inProgress, completed, cancelled
///
/// Mapping:
/// - draft: Job is being created (client side only, not visible to workers)
/// - open: Job is published and accepting proposals
/// - underReview: Client is reviewing proposals
/// - hired: A proposal has been accepted, job becomes active
/// - inProgress: Active job is being worked on
/// - completed: Job is finished
/// - cancelled: Job was cancelled

/// Proposal Status - Canonical states
/// States: draft, submitted, shortlisted, rejected, hired
///
/// Mapping between apps:
/// - yuva_client: ProposalStatus (submitted, shortlisted, rejected, hired) - NO draft
/// - yuva_worker: WorkerProposalStatus (draft, submitted, shortlisted, rejected, hired)
///
/// Note: draft exists only on worker side (before submission)

/// Active Job Status - Worker perspective
/// States: upcoming, inProgress, completed, cancelled
///
/// Mapping to JobPostStatus:
/// - upcoming → JobPostStatus.hired
/// - inProgress → JobPostStatus.inProgress
/// - completed → JobPostStatus.completed
/// - cancelled → JobPostStatus.cancelled

/// ============================================================================
/// HELPER FUNCTIONS
/// ============================================================================

/// Returns true if a job is open for new proposals
bool isJobOpenForProposals(JobPostStatus status) {
  return status == JobPostStatus.open || status == JobPostStatus.underReview;
}

/// Returns true if a worker can send a proposal for this job
/// 
/// A worker can send a proposal if:
/// - Job is open or under review
/// - Worker hasn't already submitted a proposal (myProposalStatus == null)
/// - Or worker's proposal was rejected (can resubmit)
bool canSendProposal(JobPostStatus jobStatus, ProposalStatus? myProposalStatus) {
  if (!isJobOpenForProposals(jobStatus)) {
    return false;
  }
  
  // If no proposal exists, can send
  if (myProposalStatus == null) {
    return true;
  }
  
  // Can resubmit if previously rejected
  if (myProposalStatus == ProposalStatus.rejected) {
    return true;
  }
  
  // Cannot send if already submitted, shortlisted, or hired
  return false;
}

/// Returns true if a job is ready for rating
/// 
/// A job is ready for rating when it's completed
bool isJobReadyForRating(JobPostStatus status) {
  return status == JobPostStatus.completed;
}

/// Returns true if a job can be marked as completed
/// 
/// A job can be completed if it's in progress or hired
bool canMarkJobCompleted(JobPostStatus status) {
  return status == JobPostStatus.inProgress || status == JobPostStatus.hired;
}

/// Returns true if a proposal can be hired
/// 
/// A proposal can be hired if the job is open or under review
bool canHireProposal(JobPostStatus jobStatus) {
  return jobStatus == JobPostStatus.open || jobStatus == JobPostStatus.underReview;
}

/// Maps ProposalStatus to a display-friendly label key
String getProposalStatusLabelKey(ProposalStatus status) {
  switch (status) {
    case ProposalStatus.submitted:
      return 'proposalSubmitted';
    case ProposalStatus.shortlisted:
      return 'proposalShortlisted';
    case ProposalStatus.rejected:
      return 'proposalRejected';
    case ProposalStatus.hired:
      return 'proposalHired';
  }
}

