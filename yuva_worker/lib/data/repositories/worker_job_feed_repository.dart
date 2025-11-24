import '../models/worker_job.dart';

/// Repository interface for worker job feed
abstract class WorkerJobFeedRepository {
  /// Get recommended jobs based on worker profile
  Future<List<WorkerJobSummary>> getRecommendedJobs();

  /// Get jobs where this worker was explicitly invited
  Future<List<WorkerJobSummary>> getInvitedJobs();

  /// Get detailed information about a specific job
  Future<WorkerJobDetail> getJobDetail(String jobId);
}
