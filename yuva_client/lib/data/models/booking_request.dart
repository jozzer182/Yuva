import 'package:equatable/equatable.dart';

/// Booking lifecycle status. Status labels are localized through l10n keys.
enum BookingStatus { pending, inProgress, completed, cancelled }

extension BookingStatusLabel on BookingStatus {
  String get labelKey {
    switch (this) {
      case BookingStatus.pending:
        return 'statusPending';
      case BookingStatus.inProgress:
        return 'statusInProgress';
      case BookingStatus.completed:
        return 'statusCompleted';
      case BookingStatus.cancelled:
        return 'statusCancelled';
    }
  }
}

/// Supported property types captured in the booking flow.
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

/// Property size categories.
enum BookingSizeCategory { small, medium, large }

extension BookingSizeCategoryLabel on BookingSizeCategory {
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

/// Booking repetition frequency.
enum BookingFrequency { once, weekly, biweekly, monthly }

extension BookingFrequencyLabel on BookingFrequency {
  String get labelKey {
    switch (this) {
      case BookingFrequency.once:
        return 'frequencyOnce';
      case BookingFrequency.weekly:
        return 'frequencyWeekly';
      case BookingFrequency.biweekly:
        return 'frequencyBiweekly';
      case BookingFrequency.monthly:
        return 'frequencyMonthly';
    }
  }
}

/// Client-side booking model used across UI and repositories.
/// Backend implementations can map this DTO directly to remote payloads.
class BookingRequest extends Equatable {
  final String id;
  final String userId;
  final String serviceTypeId;
  final PropertyType propertyType;
  final BookingSizeCategory sizeCategory;
  final int bedrooms;
  final int bathrooms;
  final BookingFrequency frequency;
  final DateTime dateTime;
  final double durationHours;
  final String addressSummary;
  final String? notes;
  final double estimatedPrice;
  final BookingStatus status;
  final bool hasRating;

  const BookingRequest({
    required this.id,
    required this.userId,
    required this.serviceTypeId,
    required this.propertyType,
    required this.sizeCategory,
    required this.bedrooms,
    required this.bathrooms,
    required this.frequency,
    required this.dateTime,
    required this.durationHours,
    required this.addressSummary,
    this.notes,
    required this.estimatedPrice,
    this.status = BookingStatus.pending,
    this.hasRating = false,
  });

  BookingRequest copyWith({
    String? id,
    String? userId,
    String? serviceTypeId,
    PropertyType? propertyType,
    BookingSizeCategory? sizeCategory,
    int? bedrooms,
    int? bathrooms,
    BookingFrequency? frequency,
    DateTime? dateTime,
    double? durationHours,
    String? addressSummary,
    String? notes,
    double? estimatedPrice,
    BookingStatus? status,
    bool? hasRating,
  }) {
    return BookingRequest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      serviceTypeId: serviceTypeId ?? this.serviceTypeId,
      propertyType: propertyType ?? this.propertyType,
      sizeCategory: sizeCategory ?? this.sizeCategory,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      frequency: frequency ?? this.frequency,
      dateTime: dateTime ?? this.dateTime,
      durationHours: durationHours ?? this.durationHours,
      addressSummary: addressSummary ?? this.addressSummary,
      notes: notes ?? this.notes,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      status: status ?? this.status,
      hasRating: hasRating ?? this.hasRating,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        serviceTypeId,
        propertyType,
        sizeCategory,
        bedrooms,
        bathrooms,
        frequency,
        dateTime,
        durationHours,
        addressSummary,
        notes,
        estimatedPrice,
        status,
        hasRating,
      ];
}
