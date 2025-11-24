import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/booking_request.dart';
import '../../../data/models/cleaning_service_type.dart';
import '../../../data/models/job_models.dart';

/// Local draft state for the job posting wizard.
class JobPostDraft extends Equatable {
  final String title;
  final String description;
  final CleaningServiceType? serviceType;
  final PropertyType propertyType;
  final BookingSizeCategory sizeCategory;
  final int bedrooms;
  final int bathrooms;
  final JobBudgetType budgetType;
  final double? hourlyFrom;
  final double? hourlyTo;
  final double? fixedBudget;
  final String areaLabel;
  final BookingFrequency frequency;
  final DateTime preferredDate;

  const JobPostDraft({
    required this.title,
    required this.description,
    required this.serviceType,
    required this.propertyType,
    required this.sizeCategory,
    required this.bedrooms,
    required this.bathrooms,
    required this.budgetType,
    required this.hourlyFrom,
    required this.hourlyTo,
    required this.fixedBudget,
    required this.areaLabel,
    required this.frequency,
    required this.preferredDate,
  });

  factory JobPostDraft.initial() {
    final now = DateTime.now();
    return JobPostDraft(
      title: '',
      description: '',
      serviceType: null,
      propertyType: PropertyType.apartment,
      sizeCategory: BookingSizeCategory.medium,
      bedrooms: 2,
      bathrooms: 1,
      budgetType: JobBudgetType.hourly,
      hourlyFrom: 28,
      hourlyTo: 35,
      fixedBudget: null,
      areaLabel: '',
      frequency: BookingFrequency.once,
      preferredDate: DateTime(now.year, now.month, now.day + 2, 9, 0),
    );
  }

  JobPostDraft copyWith({
    String? title,
    String? description,
    CleaningServiceType? serviceType,
    PropertyType? propertyType,
    BookingSizeCategory? sizeCategory,
    int? bedrooms,
    int? bathrooms,
    JobBudgetType? budgetType,
    double? hourlyFrom,
    double? hourlyTo,
    double? fixedBudget,
    String? areaLabel,
    BookingFrequency? frequency,
    DateTime? preferredDate,
  }) {
    return JobPostDraft(
      title: title ?? this.title,
      description: description ?? this.description,
      serviceType: serviceType ?? this.serviceType,
      propertyType: propertyType ?? this.propertyType,
      sizeCategory: sizeCategory ?? this.sizeCategory,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      budgetType: budgetType ?? this.budgetType,
      hourlyFrom: hourlyFrom ?? this.hourlyFrom,
      hourlyTo: hourlyTo ?? this.hourlyTo,
      fixedBudget: fixedBudget ?? this.fixedBudget,
      areaLabel: areaLabel ?? this.areaLabel,
      frequency: frequency ?? this.frequency,
      preferredDate: preferredDate ?? this.preferredDate,
    );
  }

  JobPost toJobPost(String userId) {
    final now = DateTime.now();
    return JobPost(
      id: '',
      userId: userId,
      titleKey: title.isEmpty ? 'jobCustomTitle' : 'jobCustomFilled',
      descriptionKey: description.isEmpty ? 'jobCustomDescription' : 'jobCustomDescriptionFilled',
      customTitle: title.trim().isEmpty ? null : title.trim(),
      customDescription: description.trim().isEmpty ? null : description.trim(),
      serviceTypeId: serviceType?.id ?? 'standard',
      propertyDetails: PropertyDetails(
        type: propertyType,
        sizeCategory: sizeCategory,
        bedrooms: bedrooms,
        bathrooms: bathrooms,
      ),
      budgetType: budgetType,
      hourlyRateFrom: budgetType == JobBudgetType.hourly ? hourlyFrom : null,
      hourlyRateTo: budgetType == JobBudgetType.hourly ? hourlyTo : null,
      fixedBudget: budgetType == JobBudgetType.fixed ? fixedBudget : null,
      areaLabel: areaLabel.trim().isEmpty ? 'Zona por definir' : areaLabel.trim(),
      frequency: frequency,
      preferredStartDate: preferredDate,
      status: JobPostStatus.open,
      invitedProIds: const [],
      proposalIds: const [],
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  List<Object?> get props => [
        title,
        description,
        serviceType,
        propertyType,
        sizeCategory,
        bedrooms,
        bathrooms,
        budgetType,
        hourlyFrom,
        hourlyTo,
        fixedBudget,
        areaLabel,
        frequency,
        preferredDate,
      ];
}

class JobPostDraftController extends StateNotifier<JobPostDraft> {
  JobPostDraftController() : super(JobPostDraft.initial());

  void updateTitle(String value) => state = state.copyWith(title: value);

  void updateDescription(String value) => state = state.copyWith(description: value);

  void selectServiceType(CleaningServiceType type) => state = state.copyWith(serviceType: type);

  void selectPropertyType(PropertyType type) => state = state.copyWith(propertyType: type);

  void selectSize(BookingSizeCategory size) => state = state.copyWith(sizeCategory: size);

  void updateBedrooms(int value) => state = state.copyWith(bedrooms: value.clamp(0, 10));

  void updateBathrooms(int value) => state = state.copyWith(bathrooms: value.clamp(0, 10));

  void selectBudgetType(JobBudgetType type) => state = state.copyWith(budgetType: type);

  void updateHourlyRange({double? from, double? to}) =>
      state = state.copyWith(hourlyFrom: from ?? state.hourlyFrom, hourlyTo: to ?? state.hourlyTo);

  void updateFixedBudget(double value) => state = state.copyWith(fixedBudget: value);

  void updateArea(String value) => state = state.copyWith(areaLabel: value);

  void selectFrequency(BookingFrequency frequency) => state = state.copyWith(frequency: frequency);

  void updatePreferredDate(DateTime date) => state = state.copyWith(preferredDate: date);

  void reset() => state = JobPostDraft.initial();
}

final jobDraftProvider =
    StateNotifierProvider.autoDispose<JobPostDraftController, JobPostDraft>((ref) {
  return JobPostDraftController();
});

final prefilledJobDraftProvider =
    Provider.autoDispose.family<JobPostDraftController, CleaningServiceType?>((ref, type) {
  final controller = JobPostDraftController();
  if (type != null) {
    controller.selectServiceType(type);
  }
  return controller;
});
