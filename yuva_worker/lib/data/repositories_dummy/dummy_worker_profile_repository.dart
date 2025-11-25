import '../models/worker_profile.dart';
import '../models/user.dart';
import '../repositories/worker_profile_repository.dart';

/// Dummy implementation of WorkerProfileRepository
/// Builds WorkerProfile from Firebase Auth User + in-memory worker-specific fields
class DummyWorkerProfileRepository implements WorkerProfileRepository {
  // In-memory storage for worker-specific fields (not in Firebase Auth)
  String? _cachedAreaBaseLabel;
  double? _cachedBaseHourlyRate;
  List<String>? _cachedOfferedServiceTypeIds;
  
  // Function to get current User from Auth (injected via provider)
  final User? Function()? _getCurrentUser;

  DummyWorkerProfileRepository({User? Function()? getCurrentUser})
      : _getCurrentUser = getCurrentUser;

  // Simulate network delay
  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 500));

  @override
  Future<WorkerProfile> getCurrentWorker() async {
    await _delay();

    // Get current user from Firebase Auth
    final user = _getCurrentUser?.call();
    
    if (user == null) {
      // No user logged in - return default (shouldn't happen in normal flow)
      return const WorkerProfile(
        id: 'worker_guest',
        displayName: 'Profesional',
        areaBaseLabel: 'No especificado',
        offeredServiceTypeIds: [],
        baseHourlyRate: 0,
        ratingAverage: 0.0,
        ratingCount: 0,
      );
    }

    // Build WorkerProfile from Auth User + cached worker-specific fields
    return WorkerProfile(
      id: user.id,
      displayName: user.name,
      areaBaseLabel: _cachedAreaBaseLabel ?? 'No especificado',
      offeredServiceTypeIds: _cachedOfferedServiceTypeIds ?? ['standard'],
      baseHourlyRate: _cachedBaseHourlyRate ?? 0,
      ratingAverage: 0.0,
      ratingCount: 0,
    );
  }

  @override
  Future<void> updateWorkerProfile(WorkerProfile updated) async {
    await _delay();
    
    // Store worker-specific fields in memory
    _cachedAreaBaseLabel = updated.areaBaseLabel;
    _cachedBaseHourlyRate = updated.baseHourlyRate;
    _cachedOfferedServiceTypeIds = updated.offeredServiceTypeIds;
    
    // Note: displayName updates should go through Firebase Auth updateDisplayName
    // This repository only stores worker-specific fields
  }
}
