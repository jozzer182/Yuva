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
