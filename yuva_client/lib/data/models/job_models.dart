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
enum ProposalStatus { submitted, shortlisted, rejected, hired, withdrawn }

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
      case ProposalStatus.withdrawn:
        return 'proposalWithdrawn';
    }
  }

  /// Returns true if this is an active proposal status visible to clients
  bool get isActiveForClient {
    return this == ProposalStatus.submitted || 
           this == ProposalStatus.shortlisted || 
           this == ProposalStatus.hired;
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

  /// Returns true if the client can edit or delete this job.
  /// A job is modifiable only if:
  /// - It has not been assigned to a worker (hiredProId is null/empty)
  /// - Its status is 'draft', 'open', or 'underReview'
  bool get canClientModify {
    // Job is not modifiable if a worker has been hired
    if (hiredProId != null && hiredProId!.isNotEmpty) {
      return false;
    }
    // Only allow modification for these statuses
    const modifiableStatuses = {
      JobPostStatus.draft,
      JobPostStatus.open,
      JobPostStatus.underReview,
    };
    return modifiableStatuses.contains(status);
  }

  /// Creates a JobPost from a Firestore document map.
  factory JobPost.fromMap(Map<String, dynamic> map, String docId) {
    return JobPost(
      id: docId,
      userId: map['clientId'] as String? ?? '',
      titleKey: map['titleKey'] as String? ?? '',
      descriptionKey: map['descriptionKey'] as String? ?? '',
      customTitle: map['customTitle'] as String?,
      customDescription: map['customDescription'] as String?,
      serviceTypeId: map['serviceTypeId'] as String? ?? '',
      propertyDetails: PropertyDetails(
        type: PropertyType.values.firstWhere(
          (e) => e.name == (map['propertyType'] as String? ?? 'apartment'),
          orElse: () => PropertyType.apartment,
        ),
        sizeCategory: BookingSizeCategory.values.firstWhere(
          (e) => e.name == (map['sizeCategory'] as String? ?? 'medium'),
          orElse: () => BookingSizeCategory.medium,
        ),
        bedrooms: map['bedrooms'] as int? ?? 0,
        bathrooms: map['bathrooms'] as int? ?? 0,
      ),
      budgetType: JobBudgetType.values.firstWhere(
        (e) => e.name == (map['budgetType'] as String? ?? 'hourly'),
        orElse: () => JobBudgetType.hourly,
      ),
      hourlyRateFrom: (map['hourlyRateFrom'] as num?)?.toDouble(),
      hourlyRateTo: (map['hourlyRateTo'] as num?)?.toDouble(),
      fixedBudget: (map['fixedBudget'] as num?)?.toDouble(),
      areaLabel: map['areaLabel'] as String? ?? '',
      frequency: BookingFrequency.values.firstWhere(
        (e) => e.name == (map['frequency'] as String? ?? 'once'),
        orElse: () => BookingFrequency.once,
      ),
      preferredStartDate: map['preferredStartDate'] != null
          ? (map['preferredStartDate'] as dynamic).toDate()
          : null,
      status: JobPostStatus.values.firstWhere(
        (e) => e.name == (map['status'] as String? ?? 'open'),
        orElse: () => JobPostStatus.open,
      ),
      invitedProIds: List<String>.from(map['invitedProIds'] ?? []),
      proposalIds: List<String>.from(map['proposalIds'] ?? []),
      hiredProposalId: map['hiredProposalId'] as String?,
      hiredProId: map['hiredProId'] as String?,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as dynamic).toDate()
          : null,
    );
  }

  /// Converts this JobPost to a Firestore document map.
  Map<String, dynamic> toMap() {
    return {
      'clientId': userId,
      'titleKey': titleKey,
      'descriptionKey': descriptionKey,
      'customTitle': customTitle,
      'customDescription': customDescription,
      'serviceTypeId': serviceTypeId,
      'propertyType': propertyDetails.type.name,
      'sizeCategory': propertyDetails.sizeCategory.name,
      'bedrooms': propertyDetails.bedrooms,
      'bathrooms': propertyDetails.bathrooms,
      'budgetType': budgetType.name,
      'hourlyRateFrom': hourlyRateFrom,
      'hourlyRateTo': hourlyRateTo,
      'fixedBudget': fixedBudget,
      'areaLabel': areaLabel,
      'frequency': frequency.name,
      'preferredStartDate': preferredStartDate,
      'status': status.name,
      'invitedProIds': invitedProIds,
      'proposalIds': proposalIds,
      'hiredProposalId': hiredProposalId,
      'hiredProId': hiredProId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
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
  
  /// Denormalized worker info for display (optional, populated from Firestore)
  final String? workerDisplayName;
  final String? workerAvatarInitials;
  final String? workerPhotoUrl;
  final String? workerAvatarId;

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
    this.workerDisplayName,
    this.workerAvatarInitials,
    this.workerPhotoUrl,
    this.workerAvatarId,
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
    String? workerDisplayName,
    String? workerAvatarInitials,
    String? workerPhotoUrl,
    String? workerAvatarId,
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
      workerDisplayName: workerDisplayName ?? this.workerDisplayName,
      workerAvatarInitials: workerAvatarInitials ?? this.workerAvatarInitials,
      workerPhotoUrl: workerPhotoUrl ?? this.workerPhotoUrl,
      workerAvatarId: workerAvatarId ?? this.workerAvatarId,
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
        workerDisplayName,
        workerAvatarInitials,
        workerPhotoUrl,
        workerAvatarId,
      ];

  /// Creates a Proposal from a Firestore document map.
  factory Proposal.fromMap(Map<String, dynamic> map, String docId) {
    return Proposal(
      id: docId,
      jobPostId: map['jobId'] as String? ?? '',
      proId: map['workerId'] as String? ?? '',
      proposedHourlyRate: (map['proposedHourlyRate'] as num?)?.toDouble(),
      proposedFixedPrice: (map['proposedFixedPrice'] as num?)?.toDouble(),
      coverLetterKey: map['message'] as String? ?? '',
      status: ProposalStatus.values.firstWhere(
        (e) => e.name == (map['status'] as String? ?? 'submitted'),
        orElse: () => ProposalStatus.submitted,
      ),
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
      agreedPrice: (map['agreedPrice'] as num?)?.toDouble(),
      workerDisplayName: map['workerDisplayName'] as String?,
      workerAvatarInitials: map['workerAvatarInitials'] as String?,
      workerPhotoUrl: map['workerPhotoUrl'] as String?,
      workerAvatarId: map['workerAvatarId'] as String?,
    );
  }

  /// Converts this Proposal to a Firestore document map.
  Map<String, dynamic> toMap() {
    return {
      'jobId': jobPostId,
      'workerId': proId,
      'proposedHourlyRate': proposedHourlyRate,
      'proposedFixedPrice': proposedFixedPrice,
      'message': coverLetterKey,
      'status': status.name,
      'createdAt': createdAt,
      'agreedPrice': agreedPrice,
      'workerDisplayName': workerDisplayName,
      'workerAvatarInitials': workerAvatarInitials,
      'workerPhotoUrl': workerPhotoUrl,
      'workerAvatarId': workerAvatarId,
    };
  }
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
