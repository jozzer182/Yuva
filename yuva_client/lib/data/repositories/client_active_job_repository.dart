import '../models/active_job.dart';

abstract class ClientActiveJobRepository {
  Future<List<ClientActiveJob>> getActiveJobsForClient(String userId);
  Future<ClientActiveJob?> getActiveJobById(String id);
  Future<ClientActiveJob?> getActiveJobByJobPostId(String jobPostId);
  Future<ClientActiveJob> updateActiveJobStatus(String activeJobId, ClientActiveJobStatus status);
}

