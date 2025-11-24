import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuva/data/models/booking_request.dart';
import 'package:yuva/data/models/cleaning_service_type.dart';
import 'package:yuva/data/services/booking_price_calculator.dart';

/// Local draft state for the booking wizard.
class BookingDraft extends Equatable {
  final CleaningServiceType? serviceType;
  final PropertyType propertyType;
  final BookingSizeCategory sizeCategory;
  final int bedrooms;
  final int bathrooms;
  final BookingFrequency frequency;
  final DateTime dateTime;
  final double durationHours;
  final String addressSummary;
  final String notes;
  final double? estimatedPrice;

  const BookingDraft({
    required this.serviceType,
    required this.propertyType,
    required this.sizeCategory,
    required this.bedrooms,
    required this.bathrooms,
    required this.frequency,
    required this.dateTime,
    required this.durationHours,
    required this.addressSummary,
    required this.notes,
    required this.estimatedPrice,
  });

  factory BookingDraft.initial() {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day + 1, 9, 0);
    return BookingDraft(
      serviceType: null,
      propertyType: PropertyType.apartment,
      sizeCategory: BookingSizeCategory.medium,
      bedrooms: 2,
      bathrooms: 1,
      frequency: BookingFrequency.once,
      dateTime: startDate,
      durationHours: 3,
      addressSummary: '',
      notes: '',
      estimatedPrice: null,
    );
  }

  BookingDraft copyWith({
    CleaningServiceType? serviceType,
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
  }) {
    return BookingDraft(
      serviceType: serviceType ?? this.serviceType,
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
    );
  }

  BookingRequest toBookingRequest({
    required String userId,
  }) {
    if (serviceType == null) {
      throw StateError('Service type is required before creating a booking');
    }

    return BookingRequest(
      id: '',
      userId: userId,
      serviceTypeId: serviceType!.id,
      propertyType: propertyType,
      sizeCategory: sizeCategory,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      frequency: frequency,
      dateTime: dateTime,
      durationHours: durationHours,
      addressSummary: addressSummary.trim(),
      notes: notes.trim().isEmpty ? null : notes.trim(),
      estimatedPrice: estimatedPrice ?? 0,
      status: BookingStatus.pending,
    );
  }

  @override
  List<Object?> get props => [
        serviceType,
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
      ];
}

class BookingDraftController extends StateNotifier<BookingDraft> {
  BookingDraftController(this._calculator) : super(BookingDraft.initial());

  final BookingPriceCalculator _calculator;

  void selectServiceType(CleaningServiceType serviceType) {
    state = state.copyWith(
      serviceType: serviceType,
      estimatedPrice: _recalculate(overrideService: serviceType),
    );
  }

  void selectPropertyType(PropertyType type) {
    state = state.copyWith(propertyType: type);
  }

  void selectSize(BookingSizeCategory size) {
    state = state.copyWith(
      sizeCategory: size,
      estimatedPrice: _recalculate(),
    );
  }

  void updateBedrooms(int value) {
    state = state.copyWith(bedrooms: value.clamp(0, 10));
  }

  void updateBathrooms(int value) {
    state = state.copyWith(bathrooms: value.clamp(0, 10));
  }

  void selectFrequency(BookingFrequency frequency) {
    state = state.copyWith(
      frequency: frequency,
      estimatedPrice: _recalculate(),
    );
  }

  void updateDateTime(DateTime dateTime) {
    state = state.copyWith(dateTime: dateTime);
  }

  void updateDuration(double duration) {
    final next = duration.clamp(1, 8).toDouble();
    state = state.copyWith(
      durationHours: next,
      estimatedPrice: _recalculate(overrideDuration: next),
    );
  }

  void updateAddress(String address) {
    state = state.copyWith(addressSummary: address);
  }

  void updateNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  void reset() {
    state = BookingDraft.initial();
  }

  double? _recalculate({CleaningServiceType? overrideService, double? overrideDuration}) {
    final service = overrideService ?? state.serviceType;
    if (service == null) return state.estimatedPrice;

    return _calculator.estimatePrice(
      serviceType: service,
      sizeCategory: state.sizeCategory,
      frequency: state.frequency,
      durationHours: overrideDuration ?? state.durationHours,
    );
  }
}
