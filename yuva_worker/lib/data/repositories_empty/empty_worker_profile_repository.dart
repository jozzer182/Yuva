import '../models/worker_profile.dart';
import '../repositories/worker_profile_repository.dart';

/// Empty implementation that returns default/empty profile when dummy mode is OFF
class EmptyWorkerProfileRepository implements WorkerProfileRepository {
  @override
  Future<WorkerProfile> getCurrentWorker() async {
    // Return minimal profile - actual data comes from WorkerUser
    return const WorkerProfile(
      id: 'empty',
      displayName: 'Profesional',
      areaBaseLabel: 'No especificado',
      offeredServiceTypeIds: [],
      baseHourlyRate: 0,
      ratingAverage: 0.0,
      ratingCount: 0,
    );
  }

  @override
  Future<void> updateWorkerProfile(WorkerProfile updated) async {
    // No-op in empty mode
  }
}

