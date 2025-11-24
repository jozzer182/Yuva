import '../models/service_category.dart';
import '../repositories/category_repository.dart';

/// Dummy implementation of CategoryRepository
class DummyCategoryRepository implements CategoryRepository {
  @override
  Future<List<ServiceCategory>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      ServiceCategory(
        id: 'onetime',
        nameKey: 'categoryOnetime',
        icon: 'cleaning_services',
        color: '7DCFCF',
      ),
      ServiceCategory(
        id: 'weekly',
        nameKey: 'categoryWeekly',
        icon: 'event_repeat',
        color: 'FFD97D',
      ),
      ServiceCategory(
        id: 'deep',
        nameKey: 'categoryDeep',
        icon: 'auto_awesome',
        color: '68D391',
      ),
      ServiceCategory(
        id: 'moving',
        nameKey: 'categoryMoving',
        icon: 'moving',
        color: '63B3ED',
      ),
    ];
  }
}
