import '../models/worker_earnings_summary.dart';
import '../models/worker_active_job.dart';
import '../repositories/worker_earnings_repository.dart';

/// Empty implementation that returns zero earnings when dummy mode is OFF
class EmptyWorkerEarningsRepository implements WorkerEarningsRepository {
  @override
  Future<WorkerEarningsSummary> getEarningsSummary() async {
    return const WorkerEarningsSummary(
      totalThisWeek: 0.0,
      totalThisMonth: 0.0,
      completedJobsThisMonth: 0,
      avgEarningPerJob: 0.0,
    );
  }

  @override
  Future<List<WorkerActiveJob>> getRecentPaidJobs() async {
    return [];
  }
}
