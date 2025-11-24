import 'package:equatable/equatable.dart';

/// Enums shared with yuva_client for compatibility

enum PropertyType { apartment, house, smallOffice }

extension PropertyTypeLabel on PropertyType {
  String get labelKey {
    switch (this) {
      case PropertyType.apartment:
        return 'propertyApartment';
      case PropertyType.house:
        return 'propertyHouse';
      case PropertyType.smallOffice:
        return 'propertySmallOffice';
    }
  }
}

enum BookingSizeCategory { small, medium, large }

extension SizeCategoryLabel on BookingSizeCategory {
  String get labelKey {
    switch (this) {
      case BookingSizeCategory.small:
        return 'sizeSmall';
      case BookingSizeCategory.medium:
        return 'sizeMedium';
      case BookingSizeCategory.large:
        return 'sizeLarge';
    }
  }
}

enum JobFrequency { once, weekly, biweekly, monthly }

extension JobFrequencyLabel on JobFrequency {
  String get labelKey {
    switch (this) {
      case JobFrequency.once:
        return 'frequencyOnce';
      case JobFrequency.weekly:
        return 'frequencyWeekly';
      case JobFrequency.biweekly:
        return 'frequencyBiweekly';
      case JobFrequency.monthly:
        return 'frequencyMonthly';
    }
  }
}

/// Budget modality for a job post.
enum JobBudgetType { hourly, fixed }

/// Lifecycle states for a job post in the marketplace flow.
enum JobPostStatus { draft, open, underReview, hired, inProgress, completed, cancelled }

/// Property details for jobs
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

  @override
  List<Object?> get props => [type, sizeCategory, bedrooms, bathrooms];
}
