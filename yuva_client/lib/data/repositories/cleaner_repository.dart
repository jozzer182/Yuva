import '../models/cleaner.dart';

/// Abstract cleaner repository
/// In Phase 2/3, implement with Firebase Firestore or HTTP API
abstract class CleanerRepository {
  Future<List<Cleaner>> getFeaturedCleaners();
  Future<List<Cleaner>> searchCleaners({String? query, String? categoryId});
  Future<Cleaner> getCleanerById(String id);
}
