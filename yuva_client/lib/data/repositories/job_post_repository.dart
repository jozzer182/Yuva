import '../models/job_models.dart';

/// Abstraction for job posts in the client marketplace.
/// Future implementations can plug HTTP/Firebase instead of local memory.
abstract class JobPostRepository {
  Future<List<JobPost>> getJobPostsForClient(String userId);
  Future<JobPost?> getJobPostById(String id);
  Future<JobPost> createJobPost(JobPost post);
  Future<JobPost> updateJobPost(JobPost post);
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
