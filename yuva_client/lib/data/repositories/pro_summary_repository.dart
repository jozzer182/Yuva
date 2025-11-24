import '../models/job_models.dart';

/// Repository for lightweight professional profiles on the client side.
abstract class ProSummaryRepository {
  Future<List<ProSummary>> getPros();
  Future<ProSummary?> getProById(String id);
  Future<List<ProSummary>> getProsByIds(List<String> ids);
}
