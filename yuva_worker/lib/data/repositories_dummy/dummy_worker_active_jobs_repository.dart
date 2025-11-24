import '../repositories/worker_active_jobs_repository.dart';
import '../models/worker_active_job.dart';
import '../models/shared_types.dart';

/// Dummy implementation with data aligned to yuva_client
/// Uses consistent IDs: job_hired_house, job_completed_office, etc.
class DummyWorkerActiveJobsRepository implements WorkerActiveJobsRepository {
  final List<WorkerActiveJob> _activeJobs = [
    // Aligned with yuva_client: job_hired_house -> prop_mateo_job2
    WorkerActiveJob(
      id: 'active_job_house',
      jobPostId: 'job_hired_house',
      workerProposalId: 'prop_mateo_job2',
      clientDisplayName: 'Cliente Demo',
      jobTitleKey: 'jobTitleWeeklyHouse',
      areaLabel: 'Suba',
      scheduledDateTime: DateTime.now().add(const Duration(days: 1)),
      agreedPrice: 420, // Matches yuva_client agreedPrice
      frequency: JobFrequency.weekly,
      status: WorkerActiveJobStatus.inProgress,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    // Aligned with yuva_client: job_completed_office -> prop_camila_job3
    WorkerActiveJob(
      id: 'active_job_office',
      jobPostId: 'job_completed_office',
      workerProposalId: 'prop_camila_job3',
      clientDisplayName: 'Cliente Demo',
      jobTitleKey: 'jobTitleOfficeReset',
      areaLabel: 'Zona T',
      scheduledDateTime: DateTime.now().subtract(const Duration(days: 8)),
      agreedPrice: 320, // Matches yuva_client agreedPrice
      frequency: JobFrequency.monthly,
      status: WorkerActiveJobStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
    ),
  ];

  @override
  Future<List<WorkerActiveJob>> getMyActiveJobs() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_activeJobs);
  }

  @override
  Future<WorkerActiveJob?> getActiveJobById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _activeJobs.firstWhere((job) => job.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<WorkerActiveJob?> getActiveJobByProposalId(String proposalId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _activeJobs.firstWhere((job) => job.workerProposalId == proposalId);
    } catch (_) {
      return null;
    }
  }
}

