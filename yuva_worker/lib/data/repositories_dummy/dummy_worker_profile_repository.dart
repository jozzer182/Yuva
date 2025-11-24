import '../models/worker_profile.dart';
import '../repositories/worker_profile_repository.dart';

/// Dummy implementation of WorkerProfileRepository
class DummyWorkerProfileRepository implements WorkerProfileRepository {
  // In-memory storage
  WorkerProfile? _currentWorker;

  // Simulate network delay
  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 500));

  @override
  Future<WorkerProfile> getCurrentWorker() async {
    await _delay();

    // Return cached or create default worker
    return _currentWorker ??
        const WorkerProfile(
          id: 'worker_001',
          displayName: 'Carlos Rodríguez',
          areaBaseLabel: 'Chapinero',
          offeredServiceTypeIds: ['standard', 'deep_clean'],
          baseHourlyRate: 45000,
          ratingAverage: 4.8,
          ratingCount: 32,
        );
  }

  @override
  Future<void> updateWorkerProfile(WorkerProfile updated) async {
    await _delay();
    _currentWorker = updated;
  }
}
