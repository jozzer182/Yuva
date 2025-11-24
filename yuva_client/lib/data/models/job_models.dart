import 'package:equatable/equatable.dart';

import 'booking_request.dart';

/// Budget modality for a job post.
enum JobBudgetType { hourly, fixed }

extension JobBudgetTypeLabel on JobBudgetType {
  String get labelKey {
    switch (this) {
      case JobBudgetType.hourly:
        return 'budgetHourly';
      case JobBudgetType.fixed:
        return 'budgetFixed';
    }
  }
}

/// Lifecycle states for a job post in the marketplace flow.
enum JobPostStatus { draft, open, underReview, hired, inProgress, completed, cancelled }

extension JobPostStatusLabel on JobPostStatus {
  String get labelKey {
    switch (this) {
      case JobPostStatus.draft:
        return 'jobStatusDraft';
      case JobPostStatus.open:
        return 'jobStatusOpen';
      case JobPostStatus.underReview:
        return 'jobStatusUnderReview';
      case JobPostStatus.hired:
        return 'jobStatusHired';
      case JobPostStatus.inProgress:
        return 'jobStatusInProgress';
      case JobPostStatus.completed:
        return 'jobStatusCompleted';
      case JobPostStatus.cancelled:
        return 'jobStatusCancelled';
    }
  }
}

/// Proposal lifecycle states.
enum ProposalStatus { submitted, shortlisted, rejected, hired }

extension ProposalStatusLabel on ProposalStatus {
  String get labelKey {
    switch (this) {
      case ProposalStatus.submitted:
        return 'proposalSubmitted';
      case ProposalStatus.shortlisted:
        return 'proposalShortlisted';
      case ProposalStatus.rejected:
        return 'proposalRejected';
      case ProposalStatus.hired:
        return 'proposalHired';
    }
  }
}

/// Property details reused from the original booking flow.
/// Naming of enums keeps compatibility with the booking flow; a future cleanup can
/// rename them to a more generic property domain.
class PropertyDetails extends Equatable {
  final PropertyType type;
  final BookingSizeCategory sizeCategory;
  final int bedrooms;
  final int bathrooms;

  const PropertyDetails({
    required this.type,
    required this.sizeCategory,
    required this.bedrooms,
    required this.bathrooms,
  });

  PropertyDetails copyWith({
    PropertyType? type,
    BookingSizeCategory? sizeCategory,
    int? bedrooms,
    int? bathrooms,
  }) {
    return PropertyDetails(
      type: type ?? this.type,
      sizeCategory: sizeCategory ?? this.sizeCategory,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
    );
  }

  @override
  List<Object?> get props => [type, sizeCategory, bedrooms, bathrooms];
}

/// Represents a job posted by the client (Upwork-style).
class JobPost extends Equatable {
  final String id;
  final String userId;
  final String titleKey;
  final String descriptionKey;
  final String? customTitle;
  final String? customDescription;
  final String serviceTypeId;
  final PropertyDetails propertyDetails;
  final JobBudgetType budgetType;
  final double? hourlyRateFrom;
  final double? hourlyRateTo;
  final double? fixedBudget;
  final String areaLabel;
  final BookingFrequency frequency;
  final DateTime? preferredStartDate;
  final JobPostStatus status;
  final List<String> invitedProIds;
  final List<String> proposalIds;
  final String? hiredProposalId;
  final String? hiredProId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const JobPost({
    required this.id,
    required this.userId,
    required this.titleKey,
    required this.descriptionKey,
    this.customTitle,
    this.customDescription,
    required this.serviceTypeId,
    required this.propertyDetails,
    required this.budgetType,
    this.hourlyRateFrom,
    this.hourlyRateTo,
    this.fixedBudget,
    required this.areaLabel,
    required this.frequency,
    this.preferredStartDate,
    this.status = JobPostStatus.open,
    this.invitedProIds = const [],
    this.proposalIds = const [],
    this.hiredProposalId,
    this.hiredProId,
    required this.createdAt,
    this.updatedAt,
  });

  JobPost copyWith({
    String? id,
    String? userId,
    String? titleKey,
    String? descriptionKey,
    String? customTitle,
    String? customDescription,
    String? serviceTypeId,
    PropertyDetails? propertyDetails,
    JobBudgetType? budgetType,
    double? hourlyRateFrom,
    double? hourlyRateTo,
    double? fixedBudget,
    String? areaLabel,
    BookingFrequency? frequency,
    DateTime? preferredStartDate,
    JobPostStatus? status,
    List<String>? invitedProIds,
    List<String>? proposalIds,
    String? hiredProposalId,
    String? hiredProId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JobPost(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      titleKey: titleKey ?? this.titleKey,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      customTitle: customTitle ?? this.customTitle,
      customDescription: customDescription ?? this.customDescription,
      serviceTypeId: serviceTypeId ?? this.serviceTypeId,
      propertyDetails: propertyDetails ?? this.propertyDetails,
      budgetType: budgetType ?? this.budgetType,
      hourlyRateFrom: hourlyRateFrom ?? this.hourlyRateFrom,
      hourlyRateTo: hourlyRateTo ?? this.hourlyRateTo,
      fixedBudget: fixedBudget ?? this.fixedBudget,
      areaLabel: areaLabel ?? this.areaLabel,
      frequency: frequency ?? this.frequency,
      preferredStartDate: preferredStartDate ?? this.preferredStartDate,
      status: status ?? this.status,
      invitedProIds: invitedProIds ?? this.invitedProIds,
      proposalIds: proposalIds ?? this.proposalIds,
      hiredProposalId: hiredProposalId ?? this.hiredProposalId,
      hiredProId: hiredProId ?? this.hiredProId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        titleKey,
        descriptionKey,
        customTitle,
        customDescription,
        serviceTypeId,
        propertyDetails,
        budgetType,
        hourlyRateFrom,
        hourlyRateTo,
        fixedBudget,
        areaLabel,
        frequency,
        preferredStartDate,
        status,
        invitedProIds,
        proposalIds,
        hiredProposalId,
        hiredProId,
        createdAt,
        updatedAt,
      ];
}

/// A proposal submitted by a professional to a job post.
class Proposal extends Equatable {
  final String id;
  final String jobPostId;
  final String proId;
  final double? proposedHourlyRate;
  final double? proposedFixedPrice;
  final String coverLetterKey;
  final ProposalStatus status;
  final DateTime createdAt;
  /// Agreed price when proposal is hired (computed from proposed rate/price)
  final double? agreedPrice;

  const Proposal({
    required this.id,
    required this.jobPostId,
    required this.proId,
    this.proposedHourlyRate,
    this.proposedFixedPrice,
    required this.coverLetterKey,
    this.status = ProposalStatus.submitted,
    required this.createdAt,
    this.agreedPrice,
  });

  Proposal copyWith({
    String? id,
    String? jobPostId,
    String? proId,
    double? proposedHourlyRate,
    double? proposedFixedPrice,
    String? coverLetterKey,
    ProposalStatus? status,
    DateTime? createdAt,
    double? agreedPrice,
  }) {
    return Proposal(
      id: id ?? this.id,
      jobPostId: jobPostId ?? this.jobPostId,
      proId: proId ?? this.proId,
      proposedHourlyRate: proposedHourlyRate ?? this.proposedHourlyRate,
      proposedFixedPrice: proposedFixedPrice ?? this.proposedFixedPrice,
      coverLetterKey: coverLetterKey ?? this.coverLetterKey,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      agreedPrice: agreedPrice ?? this.agreedPrice,
    );
  }

  @override
  List<Object?> get props => [
        id,
        jobPostId,
        proId,
        proposedHourlyRate,
        proposedFixedPrice,
        coverLetterKey,
        status,
        createdAt,
        agreedPrice,
      ];
}

/// Minimal worker profile representation on the client side.
class ProSummary extends Equatable {
  final String id;
  final String displayName;
  final double ratingAverage;
  final int ratingCount;
  final String areaLabel;
  final List<String> offeredServiceTypeIds;
  final String? avatarInitials;

  const ProSummary({
    required this.id,
    required this.displayName,
    required this.ratingAverage,
    required this.ratingCount,
    required this.areaLabel,
    required this.offeredServiceTypeIds,
    this.avatarInitials,
  });

  @override
  List<Object?> get props => [
        id,
        displayName,
        ratingAverage,
        ratingCount,
        areaLabel,
        offeredServiceTypeIds,
        avatarInitials,
      ];
}
