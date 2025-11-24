import '../repositories/worker_earnings_repository.dart';
import '../models/worker_earnings_summary.dart';
import '../models/worker_active_job.dart';
import 'dummy_worker_active_jobs_repository.dart';

/// Dummy implementation with earnings calculated from active jobs
/// Aligned with yuva_client active jobs and agreed prices
class DummyWorkerEarningsRepository implements WorkerEarningsRepository {
  final DummyWorkerActiveJobsRepository _activeJobsRepo = DummyWorkerActiveJobsRepository();

  @override
  Future<WorkerEarningsSummary> getEarningsSummary() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final activeJobs = await _activeJobsRepo.getMyActiveJobs();
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfMonth = DateTime(now.year, now.month, 1);

    // Filter completed jobs
    final completedJobs = activeJobs.where((job) => 
      job.status == WorkerActiveJobStatus.completed
    ).toList();

    // Calculate totals
    final completedThisMonth = completedJobs.where((job) => 
      job.createdAt.isAfter(startOfMonth)
    ).toList();

    final totalThisWeek = completedJobs
        .where((job) => job.createdAt.isAfter(startOfWeek))
        .fold<double>(0.0, (sum, job) => sum + job.agreedPrice);

    final totalThisMonth = completedThisMonth
        .fold<double>(0.0, (sum, job) => sum + job.agreedPrice);

    final avgEarningPerJob = completedThisMonth.isEmpty
        ? 0.0
        : totalThisMonth / completedThisMonth.length;

    return WorkerEarningsSummary(
      totalThisWeek: totalThisWeek,
      totalThisMonth: totalThisMonth,
      completedJobsThisMonth: completedThisMonth.length,
      avgEarningPerJob: avgEarningPerJob,
      currencyCode: 'COP',
    );
  }

  @override
  Future<List<WorkerActiveJob>> getRecentPaidJobs() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final activeJobs = await _activeJobsRepo.getMyActiveJobs();
    return activeJobs
        .where((job) => job.status == WorkerActiveJobStatus.completed)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}