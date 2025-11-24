import 'dart:math';

import '../models/booking_request.dart';
import '../models/job_models.dart';
import '../models/active_job.dart';
import '../models/client_review.dart';

/// Shared in-memory store so dummy repositories stay in sync.
class MarketplaceMemoryStore {
  MarketplaceMemoryStore._() {
    _seed();
  }

  static final MarketplaceMemoryStore instance = MarketplaceMemoryStore._();

  final List<JobPost> jobPosts = [];
  final List<Proposal> proposals = [];
  final List<ProSummary> pros = [];
  final List<ClientActiveJob> activeJobs = [];
  final List<ClientReview> reviews = [];

  bool _seeded = false;

  void _seed() {
    if (_seeded) return;
    _seeded = true;
    final now = DateTime.now();

    pros.addAll([
      const ProSummary(
        id: 'pro_luisa',
        displayName: 'Luisa Rincón',
        ratingAverage: 4.9,
        ratingCount: 122,
        areaLabel: 'Chapinero',
        offeredServiceTypeIds: ['standard', 'deep'],
        avatarInitials: 'LR',
      ),
      const ProSummary(
        id: 'pro_mateo',
        displayName: 'Mateo Silva',
        ratingAverage: 4.7,
        ratingCount: 98,
        areaLabel: 'Suba',
        offeredServiceTypeIds: ['standard', 'office'],
        avatarInitials: 'MS',
      ),
      const ProSummary(
        id: 'pro_camila',
        displayName: 'Camila Ortega',
        ratingAverage: 4.8,
        ratingCount: 143,
        areaLabel: 'Usaquén',
        offeredServiceTypeIds: ['deep', 'moveout'],
        avatarInitials: 'CO',
      ),
      const ProSummary(
        id: 'pro_diego',
        displayName: 'Diego R.',
        ratingAverage: 4.5,
        ratingCount: 76,
        areaLabel: 'Chía',
        offeredServiceTypeIds: ['standard', 'deep'],
        avatarInitials: 'DR',
      ),
    ]);

    jobPosts.addAll([
      JobPost(
        id: 'job_open_apartment',
        userId: 'demo-user',
        titleKey: 'jobTitleDeepCleanApt',
        descriptionKey: 'jobDescDeepCleanApt',
        serviceTypeId: 'deep',
        propertyDetails: const PropertyDetails(
          type: PropertyType.apartment,
          sizeCategory: BookingSizeCategory.medium,
          bedrooms: 2,
          bathrooms: 2,
        ),
        budgetType: JobBudgetType.hourly,
        hourlyRateFrom: 28,
        hourlyRateTo: 34,
        areaLabel: 'Chapinero',
        frequency: BookingFrequency.once,
        preferredStartDate: DateTime(now.year, now.month, now.day + 3, 9, 0),
        status: JobPostStatus.open,
        invitedProIds: const ['pro_luisa'],
        proposalIds: const ['prop_luisa_job1', 'prop_camila_job1'],
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      JobPost(
        id: 'job_hired_house',
        userId: 'demo-user',
        titleKey: 'jobTitleWeeklyHouse',
        descriptionKey: 'jobDescWeeklyHouse',
        serviceTypeId: 'standard',
        propertyDetails: const PropertyDetails(
          type: PropertyType.house,
          sizeCategory: BookingSizeCategory.large,
          bedrooms: 4,
          bathrooms: 3,
        ),
        budgetType: JobBudgetType.fixed,
        fixedBudget: 420,
        areaLabel: 'Suba',
        frequency: BookingFrequency.weekly,
        preferredStartDate: DateTime(now.year, now.month, now.day + 1, 8, 0),
        status: JobPostStatus.inProgress,
        invitedProIds: const ['pro_mateo', 'pro_luisa'],
        proposalIds: const ['prop_mateo_job2', 'prop_diego_job2'],
        hiredProposalId: 'prop_mateo_job2',
        hiredProId: 'pro_mateo',
        createdAt: now.subtract(const Duration(days: 4)),
      ),
      JobPost(
        id: 'job_completed_office',
        userId: 'demo-user',
        titleKey: 'jobTitleOfficeReset',
        descriptionKey: 'jobDescOfficeReset',
        serviceTypeId: 'office',
        propertyDetails: const PropertyDetails(
          type: PropertyType.smallOffice,
          sizeCategory: BookingSizeCategory.medium,
          bedrooms: 3,
          bathrooms: 2,
        ),
        budgetType: JobBudgetType.fixed,
        fixedBudget: 320,
        areaLabel: 'Zona T',
        frequency: BookingFrequency.monthly,
        preferredStartDate: DateTime(now.year, now.month, now.day - 8, 18, 30),
        status: JobPostStatus.completed,
        invitedProIds: const ['pro_camila'],
        proposalIds: const ['prop_camila_job3'],
        hiredProposalId: 'prop_camila_job3',
        hiredProId: 'pro_camila',
        createdAt: now.subtract(const Duration(days: 15)),
      ),
    ]);

    proposals.addAll([
      Proposal(
        id: 'prop_luisa_job1',
        jobPostId: 'job_open_apartment',
        proId: 'pro_luisa',
        proposedHourlyRate: 33,
        coverLetterKey: 'coverDetailSparkling',
        status: ProposalStatus.shortlisted,
        createdAt: now.subtract(const Duration(hours: 10)),
      ),
      Proposal(
        id: 'prop_camila_job1',
        jobPostId: 'job_open_apartment',
        proId: 'pro_camila',
        proposedHourlyRate: 30,
        coverLetterKey: 'coverExperienceDeep',
        status: ProposalStatus.submitted,
        createdAt: now.subtract(const Duration(hours: 8)),
      ),
      Proposal(
        id: 'prop_mateo_job2',
        jobPostId: 'job_hired_house',
        proId: 'pro_mateo',
        proposedFixedPrice: 420,
        coverLetterKey: 'coverWeeklyCare',
        status: ProposalStatus.hired,
        createdAt: now.subtract(const Duration(days: 2)),
        agreedPrice: 420,
      ),
      Proposal(
        id: 'prop_diego_job2',
        jobPostId: 'job_hired_house',
        proId: 'pro_diego',
        proposedFixedPrice: 390,
        coverLetterKey: 'coverFlexible',
        status: ProposalStatus.rejected,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      Proposal(
        id: 'prop_camila_job3',
        jobPostId: 'job_completed_office',
        proId: 'pro_camila',
        proposedFixedPrice: 320,
        coverLetterKey: 'coverOfficeReset',
        status: ProposalStatus.hired,
        createdAt: now.subtract(const Duration(days: 12)),
        agreedPrice: 320,
      ),
    ]);

    // Seed active jobs for hired proposals
    activeJobs.addAll([
      ClientActiveJob(
        id: 'active_job_house',
        jobPostId: 'job_hired_house',
        proposalId: 'prop_mateo_job2',
        workerId: 'pro_mateo',
        workerDisplayName: 'Mateo Silva',
        jobTitleKey: 'jobTitleWeeklyHouse',
        areaLabel: 'Suba',
        scheduledDateTime: DateTime(now.year, now.month, now.day + 1, 8, 0),
        agreedPrice: 420,
        frequency: BookingFrequency.weekly,
        status: ClientActiveJobStatus.inProgress,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      ClientActiveJob(
        id: 'active_job_office',
        jobPostId: 'job_completed_office',
        proposalId: 'prop_camila_job3',
        workerId: 'pro_camila',
        workerDisplayName: 'Camila Ortega',
        jobTitleKey: 'jobTitleOfficeReset',
        areaLabel: 'Zona T',
        scheduledDateTime: DateTime(now.year, now.month, now.day - 8, 18, 30),
        agreedPrice: 320,
        frequency: BookingFrequency.monthly,
        status: ClientActiveJobStatus.completed,
        createdAt: now.subtract(const Duration(days: 12)),
        completedAt: now.subtract(const Duration(days: 8)),
      ),
    ]);

    // Seed reviews for completed jobs
    reviews.addAll([
      ClientReview(
        id: 'review_office_1',
        activeJobId: 'active_job_office',
        jobPostId: 'job_completed_office',
        workerId: 'pro_camila',
        workerDisplayName: 'Camila Ortega',
        rating: 5.0,
        comment: 'Excelente trabajo, muy profesional y puntual',
        createdAt: now.subtract(const Duration(days: 7)),
      ),
    ]);
  }

  /// Creates an active job when a proposal is hired
  void createActiveJobFromHiredProposal({
    required JobPost job,
    required Proposal proposal,
    required double agreedPrice,
  }) {
    // Check if active job already exists
    final existingIndex = activeJobs.indexWhere((aj) => aj.jobPostId == job.id);
    
    final pro = pros.firstWhere((p) => p.id == proposal.proId);
    
    final activeJob = ClientActiveJob(
      id: existingIndex >= 0 ? activeJobs[existingIndex].id : generateId('active_job'),
      jobPostId: job.id,
      proposalId: proposal.id,
      workerId: proposal.proId,
      workerDisplayName: pro.displayName,
      jobTitleKey: job.titleKey,
      customTitle: job.customTitle,
      areaLabel: job.areaLabel,
      scheduledDateTime: job.preferredStartDate ?? DateTime.now().add(const Duration(days: 1)),
      agreedPrice: agreedPrice,
      frequency: job.frequency,
      status: ClientActiveJobStatus.upcoming,
      createdAt: DateTime.now(),
    );

    if (existingIndex >= 0) {
      activeJobs[existingIndex] = activeJob;
    } else {
      activeJobs.add(activeJob);
    }
  }

  String generateId(String prefix) {
    final random = Random();
    return '${prefix}_${DateTime.now().millisecondsSinceEpoch}_${random.nextInt(9999)}';
  }
}
