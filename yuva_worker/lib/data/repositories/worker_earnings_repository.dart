import '../models/worker_earnings_summary.dart';
import '../models/worker_active_job.dart';

abstract class WorkerEarningsRepository {
  Future<WorkerEarningsSummary> getEarningsSummary();
  Future<List<WorkerActiveJob>> getRecentPaidJobs();
}