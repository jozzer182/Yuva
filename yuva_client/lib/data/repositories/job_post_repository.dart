import '../models/job_models.dart';

/// Abstraction for job posts in the client marketplace.
/// Future implementations can plug HTTP/Firebase instead of local memory.
abstract class JobPostRepository {
  Future<List<JobPost>> getJobPostsForClient(String userId);
  Future<JobPost?> getJobPostById(String id);
  Future<JobPost> createJobPost(JobPost post);
  Future<JobPost> updateJobPost(JobPost post);
  
  /// Deletes a job post. Only allowed if job.canClientModify is true.
  /// Throws [JobNotModifiableException] if the job cannot be deleted.
  Future<void> deleteJob(String jobId);
  
  Future<JobPost> invitePro({
    required String jobPostId,
    required String proId,
  });
  Future<JobPost> hireProposal({
    required String jobPostId,
    required String proposalId,
    required String proId,
  });
  Future<JobPost> updateStatus({
    required String jobPostId,
    required JobPostStatus status,
  });
}

/// Exception thrown when trying to modify a job that is no longer modifiable.
class JobNotModifiableException implements Exception {
  final String message;
  const JobNotModifiableException([this.message = 'This job can no longer be modified.']);
  
  @override
  String toString() => message;
}
