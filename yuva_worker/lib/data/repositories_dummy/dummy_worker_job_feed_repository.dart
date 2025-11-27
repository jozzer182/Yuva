import '../models/shared_types.dart';
import '../models/worker_job.dart';
import '../repositories/worker_job_feed_repository.dart';

/// Dummy implementation of WorkerJobFeedRepository with Spanish-first data
class DummyWorkerJobFeedRepository implements WorkerJobFeedRepository {
  // Simulate network delay
  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 800));

  @override
  Future<List<WorkerJobSummary>> getRecommendedJobs() async {
    await _delay();

    return [
      const WorkerJobSummary(
        id: 'job_001',
        clientId: 'client_001',
        titleKey: 'jobTitleDeepCleanApt',
        serviceTypeNameKey: 'serviceDeepClean',
        areaLabel: 'Chapinero',
        frequency: JobFrequency.once,
        budgetType: JobBudgetType.hourly,
        hourlyRateFrom: 40000,
        hourlyRateTo: 60000,
        status: JobPostStatus.open,
        isInvited: false,
      ),
      const WorkerJobSummary(
        id: 'job_002',
        clientId: 'client_002',
        titleKey: 'jobTitleWeeklyHouse',
        serviceTypeNameKey: 'serviceStandard',
        areaLabel: 'Suba',
        frequency: JobFrequency.weekly,
        budgetType: JobBudgetType.fixed,
        fixedBudget: 120000,
        status: JobPostStatus.open,
        isInvited: false,
      ),
      const WorkerJobSummary(
        id: 'job_003',
        clientId: 'client_003',
        titleKey: 'jobTitleOfficeReset',
        serviceTypeNameKey: 'serviceOffice',
        areaLabel: 'Usaquén',
        frequency: JobFrequency.monthly,
        budgetType: JobBudgetType.hourly,
        hourlyRateFrom: 35000,
        hourlyRateTo: 50000,
        status: JobPostStatus.open,
        isInvited: false,
      ),
      const WorkerJobSummary(
        id: 'job_004',
        clientId: 'client_004',
        titleKey: 'jobTitlePostMoveCondo',
        serviceTypeNameKey: 'serviceMoveOut',
        areaLabel: 'Engativá',
        frequency: JobFrequency.once,
        budgetType: JobBudgetType.fixed,
        fixedBudget: 180000,
        status: JobPostStatus.open,
        isInvited: false,
      ),
      const WorkerJobSummary(
        id: 'job_005',
        clientId: 'client_005',
        titleKey: 'jobTitleBiweeklyStudio',
        serviceTypeNameKey: 'serviceStandard',
        areaLabel: 'Teusaquillo',
        frequency: JobFrequency.biweekly,
        budgetType: JobBudgetType.hourly,
        hourlyRateFrom: 30000,
        hourlyRateTo: 45000,
        status: JobPostStatus.open,
        isInvited: false,
      ),
    ];
  }

  @override
  Future<List<WorkerJobSummary>> getInvitedJobs() async {
    await _delay();

    return [
      const WorkerJobSummary(
        id: 'job_006',
        clientId: 'client_006',
        titleKey: 'jobTitleDeepCleanApt',
        serviceTypeNameKey: 'serviceDeepClean',
        areaLabel: 'Chapinero',
        frequency: JobFrequency.once,
        budgetType: JobBudgetType.hourly,
        hourlyRateFrom: 45000,
        hourlyRateTo: 65000,
        status: JobPostStatus.open,
        isInvited: true,
      ),
      const WorkerJobSummary(
        id: 'job_007',
        clientId: 'client_007',
        titleKey: 'jobTitleWeeklyHouse',
        serviceTypeNameKey: 'serviceStandard',
        areaLabel: 'Suba',
        frequency: JobFrequency.weekly,
        budgetType: JobBudgetType.fixed,
        fixedBudget: 150000,
        status: JobPostStatus.open,
        isInvited: true,
      ),
    ];
  }

  @override
  Future<WorkerJobDetail> getJobDetail(String jobId) async {
    await _delay();

    // Create a detailed version of the job
    // In a real app, this would fetch from backend
    return WorkerJobDetail(
      id: jobId,
      clientId: 'dummy_client_1',
      clientName: 'María García',
      titleKey: 'jobTitleDeepCleanApt',
      descriptionKey: 'jobDescDeepCleanApt',
      serviceTypeNameKey: 'serviceDeepClean',
      propertyDetails: const PropertyDetails(
        type: PropertyType.apartment,
        sizeCategory: BookingSizeCategory.medium,
        bedrooms: 2,
        bathrooms: 1,
      ),
      budgetType: JobBudgetType.hourly,
      hourlyRateFrom: 40000,
      hourlyRateTo: 60000,
      areaLabel: 'Chapinero',
      frequency: JobFrequency.once,
      preferredStartDate: DateTime.now().add(const Duration(days: 5)),
      status: JobPostStatus.open,
      isInvited: jobId == 'job_006' || jobId == 'job_007',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    );
  }
}
