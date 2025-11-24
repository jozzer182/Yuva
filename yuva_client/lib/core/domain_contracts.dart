/// Domain Contracts - Shared Vocabulary between yuva_client and yuva_worker
///
/// This file documents the shared domain model that both apps must follow
/// to ensure compatibility when a shared backend is introduced.
///
/// IMPORTANT: This vocabulary (IDs, statuses, types) is shared between
/// yuva_client and yuva_worker. A future backend must follow this contract.

/// ============================================================================
/// IDENTIFIERS - Core entity IDs used across both apps
/// ============================================================================
///
/// - jobPostId: Unique identifier for a job posting (client creates, worker views)
/// - proposalId: Unique identifier for a proposal (worker creates, client reviews)
/// - activeJobId: Unique identifier for an active job/contract (created when proposal is hired)
/// - conversationId: Unique identifier for a conversation thread between client and worker
/// - userId: Client user ID (in yuva_client)
/// - workerId/proId: Professional/worker user ID (in yuva_worker, referenced in yuva_client as proId)
///
/// These IDs should be consistent across both apps when referring to the same entity.

/// ============================================================================
/// STATUS ENUMS - Lifecycle states that must conceptually match
/// ============================================================================

/// Job Post Status (JobPostStatus in yuva_client, JobPostStatus in yuva_worker)
/// States: draft, open, underReview, hired, inProgress, completed, cancelled
///
/// - draft: Job is being created (client side only)
/// - open: Job is published and accepting proposals
/// - underReview: Client is reviewing proposals
/// - hired: A proposal has been accepted, job becomes active
/// - inProgress: Active job is being worked on
/// - completed: Job is finished
/// - cancelled: Job was cancelled

/// Proposal Status (ProposalStatus in yuva_client, WorkerProposalStatus in yuva_worker)
/// States: draft, submitted, shortlisted, rejected, hired
///
/// - draft: Proposal is being prepared (worker side only)
/// - submitted: Proposal sent to client
/// - shortlisted: Client marked proposal as candidate
/// - rejected: Client rejected the proposal
/// - hired: Proposal was accepted, becomes active job

/// Active Job Status (WorkerActiveJobStatus in yuva_worker)
/// States: upcoming, inProgress, completed, cancelled
///
/// - upcoming: Job is scheduled but not started
/// - inProgress: Job is currently being worked on
/// - completed: Job is finished
/// - cancelled: Job was cancelled

/// ============================================================================
/// NOTIFICATION TYPES - Must match conceptually between apps
/// ============================================================================
///
/// ClientNotificationType (yuva_client):
/// - newProposal: New proposal received for a job
/// - proposalStatusChange: Proposal status changed (shortlisted/rejected/hired)
/// - newMessage: New message from worker
/// - jobStatusChange: Active job status changed
/// - genericInfo: General information
///
/// WorkerNotificationType (yuva_worker):
/// - proposalStatusChange: Proposal status changed (shortlisted/rejected/hired)
/// - newMessage: New message from client
/// - jobStatusChange: Active job status changed
/// - genericInfo: General information

/// ============================================================================
/// MESSAGE SENDER TYPES - Consistent across both apps
/// ============================================================================
///
/// MessageSenderType:
/// - client: Message sent by client
/// - worker: Message sent by worker/professional
/// - system: System-generated message

/// ============================================================================
/// SHARED ENUMS - Must be identical in both apps
/// ============================================================================
///
/// - JobBudgetType: hourly, fixed
/// - JobFrequency: once, weekly, biweekly, monthly
/// - PropertyType: apartment, house, smallOffice
/// - BookingSizeCategory: small, medium, large

/// ============================================================================
/// MODEL ALIGNMENT NOTES
/// ============================================================================
///
/// JobPost (yuva_client) <-> WorkerJobSummary/WorkerJobDetail (yuva_worker)
/// - Both reference the same jobPostId
/// - Worker views are read-only summaries/details of client's JobPost
///
/// Proposal (yuva_client) <-> WorkerProposal (yuva_worker)
/// - Same proposalId, viewed from different perspectives
/// - Client sees Proposal with proId, worker sees WorkerProposal with workerId
///
/// ActiveJob (future in yuva_client) <-> WorkerActiveJob (yuva_worker)
/// - Same activeJobId when a proposal is hired
/// - Client sees their active job, worker sees their active job
///
/// ClientConversation (yuva_client) <-> WorkerConversation (yuva_worker)
/// - Same conversationId
/// - Client sees workerDisplayName, worker sees clientDisplayName
/// - Both reference relatedJobId (jobPostId or activeJobId)

