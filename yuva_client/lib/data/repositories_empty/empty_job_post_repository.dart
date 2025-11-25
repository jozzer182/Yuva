import '../models/job_models.dart';
import '../repositories/job_post_repository.dart';

/// Empty implementation that returns empty lists when dummy mode is OFF
class EmptyJobPostRepository implements JobPostRepository {
  @override
  Future<List<JobPost>> getJobPostsForClient(String userId) async {
    return [];
  }

  @override
  Future<JobPost?> getJobPostById(String id) async {
    return null;
  }

  @override
  Future<JobPost> createJobPost(JobPost post) async {
    throw UnimplementedError('Job posts not available in empty mode');
  }

  @override
  Future<JobPost> updateJobPost(JobPost post) async {
    throw UnimplementedError('Job posts not available in empty mode');
  }

  @override
  Future<JobPost> invitePro({required String jobPostId, required String proId}) async {
    throw UnimplementedError('Job posts not available in empty mode');
  }

  @override
  Future<JobPost> hireProposal({
    required String jobPostId,
    required String proposalId,
    required String proId,
  }) async {
    throw UnimplementedError('Job posts not available in empty mode');
  }

  @override
  Future<JobPost> updateStatus({
    required String jobPostId,
    required JobPostStatus status,
  }) async {
    throw UnimplementedError('Job posts not available in empty mode');
  }
}

