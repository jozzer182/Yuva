import '../models/service_category.dart';

/// Abstract category repository
/// In Phase 2/3, implement with Firebase Firestore or HTTP API
abstract class CategoryRepository {
  Future<List<ServiceCategory>> getCategories();
}
