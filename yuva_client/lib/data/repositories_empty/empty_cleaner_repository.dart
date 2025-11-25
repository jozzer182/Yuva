import '../models/cleaner.dart';
import '../repositories/cleaner_repository.dart';

/// Empty implementation that returns empty lists when dummy mode is OFF
class EmptyCleanerRepository implements CleanerRepository {
  @override
  Future<List<Cleaner>> getFeaturedCleaners() async {
    return [];
  }

  @override
  Future<List<Cleaner>> searchCleaners({String? query, String? categoryId}) async {
    return [];
  }

  @override
  Future<Cleaner> getCleanerById(String id) async {
    throw StateError('Cleaner not found');
  }
}

