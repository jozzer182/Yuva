import '../models/job_models.dart';
import '../repositories/pro_summary_repository.dart';

/// Empty implementation of ProSummaryRepository for when dummy mode is OFF.
/// Returns empty lists and null values.
class EmptyProSummaryRepository implements ProSummaryRepository {
  @override
  Future<List<ProSummary>> getPros() async {
    return const [];
  }

  @override
  Future<ProSummary?> getProById(String id) async {
    return null;
  }

  @override
  Future<List<ProSummary>> getProsByIds(List<String> ids) async {
    return const [];
  }
}
