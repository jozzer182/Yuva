import '../models/job_models.dart';
import '../repositories/pro_summary_repository.dart';
import 'marketplace_memory_store.dart';

/// Dummy implementation for professional summaries.
class DummyProSummaryRepository implements ProSummaryRepository {
  DummyProSummaryRepository({MarketplaceMemoryStore? store})
      : _store = store ?? MarketplaceMemoryStore.instance;

  static const _latency = Duration(milliseconds: 360);
  final MarketplaceMemoryStore _store;

  @override
  Future<List<ProSummary>> getPros() async {
    await Future.delayed(_latency);
    return List.unmodifiable(_store.pros);
  }

  @override
  Future<ProSummary?> getProById(String id) async {
    await Future.delayed(_latency);
    try {
      return _store.pros.firstWhere((pro) => pro.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<ProSummary>> getProsByIds(List<String> ids) async {
    await Future.delayed(_latency);
    return _store.pros.where((pro) => ids.contains(pro.id)).toList(growable: false);
  }
}
