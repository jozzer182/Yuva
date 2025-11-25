import '../models/worker_job.dart';
import '../repositories/worker_job_feed_repository.dart';

/// Empty implementation that returns empty lists when dummy mode is OFF
class EmptyWorkerJobFeedRepository implements WorkerJobFeedRepository {
  @override
  Future<List<WorkerJobSummary>> getRecommendedJobs() async {
    return [];
  }

  @override
  Future<List<WorkerJobSummary>> getInvitedJobs() async {
    return [];
  }

  @override
  Future<WorkerJobDetail> getJobDetail(String jobId) async {
    throw StateError('Job not found');
  }
}

