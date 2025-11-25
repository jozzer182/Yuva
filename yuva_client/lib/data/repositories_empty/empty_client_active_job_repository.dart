import '../repositories/client_active_job_repository.dart';
import '../models/active_job.dart';

/// Empty implementation of ClientActiveJobRepository for when dummy mode is OFF.
/// Returns empty lists and null values.
class EmptyClientActiveJobRepository implements ClientActiveJobRepository {
  @override
  Future<List<ClientActiveJob>> getActiveJobsForClient(String userId) async {
    return const [];
  }

  @override
  Future<ClientActiveJob?> getActiveJobById(String id) async {
    return null;
  }

  @override
  Future<ClientActiveJob?> getActiveJobByJobPostId(String jobPostId) async {
    return null;
  }

  @override
  Future<ClientActiveJob> updateActiveJobStatus(
    String activeJobId,
    ClientActiveJobStatus status,
  ) async {
    // In empty mode, throw an error since there are no active jobs
    throw StateError('No active jobs in empty mode');
  }
}
