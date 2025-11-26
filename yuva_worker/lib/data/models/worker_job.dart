import 'package:equatable/equatable.dart';
import 'shared_types.dart';

/// Feed-friendly summary of a job post, as seen by a professional
class WorkerJobSummary extends Equatable {
  final String id;
  final String titleKey;
  final String? customTitle;
  final String serviceTypeNameKey;
  final String areaLabel;
  final JobFrequency frequency;
  final JobBudgetType budgetType;
  final double? hourlyRateFrom;
  final double? hourlyRateTo;
  final double? fixedBudget;
  final DateTime? preferredStartDate;
  final JobPostStatus status;
  final bool isInvited;

  const WorkerJobSummary({
    required this.id,
    required this.titleKey,
    this.customTitle,
    required this.serviceTypeNameKey,
    required this.areaLabel,
    required this.frequency,
    required this.budgetType,
    this.hourlyRateFrom,
    this.hourlyRateTo,
    this.fixedBudget,
    this.preferredStartDate,
    this.status = JobPostStatus.open,
    this.isInvited = false,
  });

  /// Creates a WorkerJobSummary from a Firestore document map.
  /// [workerId] is used to determine if the worker was invited.
  factory WorkerJobSummary.fromMap(Map<String, dynamic> map, String docId, {String? workerId}) {
    final invitedProIds = List<String>.from(map['invitedProIds'] ?? []);
    return WorkerJobSummary(
      id: docId,
      titleKey: map['titleKey'] as String? ?? '',
      customTitle: map['customTitle'] as String?,
      serviceTypeNameKey: map['serviceTypeId'] as String? ?? '',
      areaLabel: map['areaLabel'] as String? ?? '',
      frequency: JobFrequency.values.firstWhere(
        (e) => e.name == (map['frequency'] as String? ?? 'once'),
        orElse: () => JobFrequency.once,
      ),
      budgetType: JobBudgetType.values.firstWhere(
        (e) => e.name == (map['budgetType'] as String? ?? 'hourly'),
        orElse: () => JobBudgetType.hourly,
      ),
      hourlyRateFrom: (map['hourlyRateFrom'] as num?)?.toDouble(),
      hourlyRateTo: (map['hourlyRateTo'] as num?)?.toDouble(),
      fixedBudget: (map['fixedBudget'] as num?)?.toDouble(),
      preferredStartDate: map['preferredStartDate'] != null
          ? (map['preferredStartDate'] as dynamic).toDate()
          : null,
      status: JobPostStatus.values.firstWhere(
        (e) => e.name == (map['status'] as String? ?? 'open'),
        orElse: () => JobPostStatus.open,
      ),
      isInvited: workerId != null && invitedProIds.contains(workerId),
    );
  }

  @override
  List<Object?> get props => [
        id,
        titleKey,
        customTitle,
        serviceTypeNameKey,
        areaLabel,
        frequency,
        budgetType,
        hourlyRateFrom,
        hourlyRateTo,
        fixedBudget,
        preferredStartDate,
        status,
        isInvited,
      ];
}

/// Detailed view of a job from worker perspective
class WorkerJobDetail extends Equatable {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final String? customTitle;
  final String? customDescription;
  final String serviceTypeNameKey;
  final PropertyDetails propertyDetails;
  final JobBudgetType budgetType;
  final double? hourlyRateFrom;
  final double? hourlyRateTo;
  final double? fixedBudget;
  final String areaLabel;
  final JobFrequency frequency;
  final DateTime? preferredStartDate;
  final JobPostStatus status;
  final bool isInvited;
  final DateTime createdAt;

  const WorkerJobDetail({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    this.customTitle,
    this.customDescription,
    required this.serviceTypeNameKey,
    required this.propertyDetails,
    required this.budgetType,
    this.hourlyRateFrom,
    this.hourlyRateTo,
    this.fixedBudget,
    required this.areaLabel,
    required this.frequency,
    this.preferredStartDate,
    this.status = JobPostStatus.open,
    this.isInvited = false,
    required this.createdAt,
  });

  /// Creates a WorkerJobDetail from a Firestore document map.
  /// [workerId] is used to determine if the worker was invited.
  factory WorkerJobDetail.fromMap(Map<String, dynamic> map, String docId, {String? workerId}) {
    final invitedProIds = List<String>.from(map['invitedProIds'] ?? []);
    return WorkerJobDetail(
      id: docId,
      titleKey: map['titleKey'] as String? ?? '',
      descriptionKey: map['descriptionKey'] as String? ?? '',
      customTitle: map['customTitle'] as String?,
      customDescription: map['customDescription'] as String?,
      serviceTypeNameKey: map['serviceTypeId'] as String? ?? '',
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
      frequency: JobFrequency.values.firstWhere(
        (e) => e.name == (map['frequency'] as String? ?? 'once'),
        orElse: () => JobFrequency.once,
      ),
      preferredStartDate: map['preferredStartDate'] != null
          ? (map['preferredStartDate'] as dynamic).toDate()
          : null,
      status: JobPostStatus.values.firstWhere(
        (e) => e.name == (map['status'] as String? ?? 'open'),
        orElse: () => JobPostStatus.open,
      ),
      isInvited: workerId != null && invitedProIds.contains(workerId),
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        titleKey,
        descriptionKey,
        customTitle,
        customDescription,
        serviceTypeNameKey,
        propertyDetails,
        budgetType,
        hourlyRateFrom,
        hourlyRateTo,
        fixedBudget,
        areaLabel,
        frequency,
        preferredStartDate,
        status,
        isInvited,
        createdAt,
      ];
}
