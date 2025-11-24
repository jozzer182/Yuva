import '../models/worker_profile.dart';

/// Repository interface for worker profile
abstract class WorkerProfileRepository {
  /// Get the current authenticated worker's profile
  Future<WorkerProfile> getCurrentWorker();

  /// Update worker profile
  Future<void> updateWorkerProfile(WorkerProfile updated);
}
