/// Job & Proposal Lifecycle Contract
///
/// This file defines the canonical lifecycle states and helper functions
/// that ensure consistency between yuva_client and yuva_worker.
///
/// IMPORTANT: Both apps must follow this contract for proper synchronization.

import '../data/models/shared_types.dart';
import '../data/models/worker_proposal.dart';
import '../data/models/worker_active_job.dart';

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
bool canSendProposal(JobPostStatus jobStatus, WorkerProposalStatus? myProposalStatus) {
  if (!isJobOpenForProposals(jobStatus)) {
    return false;
  }
  
  // If no proposal exists, can send
  if (myProposalStatus == null) {
    return true;
  }
  
  // Draft proposals don't count as submitted
  if (myProposalStatus == WorkerProposalStatus.draft) {
    return true;
  }
  
  // Can resubmit if previously rejected
  if (myProposalStatus == WorkerProposalStatus.rejected) {
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

/// Maps WorkerProposalStatus to client-side ProposalStatus
/// 
/// Note: draft maps to null (not visible on client side)
ProposalStatus? mapWorkerProposalStatusToClient(WorkerProposalStatus status) {
  switch (status) {
    case WorkerProposalStatus.draft:
      return null; // Draft not visible to client
    case WorkerProposalStatus.submitted:
      return ProposalStatus.submitted;
    case WorkerProposalStatus.shortlisted:
      return ProposalStatus.shortlisted;
    case WorkerProposalStatus.rejected:
      return ProposalStatus.rejected;
    case WorkerProposalStatus.hired:
      return ProposalStatus.hired;
  }
}

/// Maps client-side ProposalStatus to WorkerProposalStatus
WorkerProposalStatus mapClientProposalStatusToWorker(ProposalStatus status) {
  switch (status) {
    case ProposalStatus.submitted:
      return WorkerProposalStatus.submitted;
    case ProposalStatus.shortlisted:
      return WorkerProposalStatus.shortlisted;
    case ProposalStatus.rejected:
      return WorkerProposalStatus.rejected;
    case ProposalStatus.hired:
      return WorkerProposalStatus.hired;
  }
}

/// Maps JobPostStatus to WorkerActiveJobStatus
WorkerActiveJobStatus? mapJobPostStatusToActiveJobStatus(JobPostStatus status) {
  switch (status) {
    case JobPostStatus.hired:
      return WorkerActiveJobStatus.upcoming;
    case JobPostStatus.inProgress:
      return WorkerActiveJobStatus.inProgress;
    case JobPostStatus.completed:
      return WorkerActiveJobStatus.completed;
    case JobPostStatus.cancelled:
      return WorkerActiveJobStatus.cancelled;
    default:
      return null; // Not an active job state
  }
}

/// ProposalStatus enum for mapping (matches yuva_client)
enum ProposalStatus {
  submitted,
  shortlisted,
  rejected,
  hired,
}

