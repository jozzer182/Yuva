import '../models/worker_active_job.dart';
import '../repositories/worker_active_jobs_repository.dart';

/// Empty implementation that returns empty lists when dummy mode is OFF
class EmptyWorkerActiveJobsRepository implements WorkerActiveJobsRepository {
  @override
  Future<List<WorkerActiveJob>> getMyActiveJobs() async {
    return [];
  }

  @override
  Future<WorkerActiveJob?> getActiveJobById(String id) async {
    return null;
  }

  @override
  Future<WorkerActiveJob?> getActiveJobByProposalId(String proposalId) async {
    return null;
  }
}

