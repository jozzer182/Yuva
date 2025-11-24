import '../models/worker_active_job.dart';

abstract class WorkerActiveJobsRepository {
  Future<List<WorkerActiveJob>> getMyActiveJobs();
  Future<WorkerActiveJob?> getActiveJobById(String id);
  Future<WorkerActiveJob?> getActiveJobByProposalId(String proposalId);
}
