import 'dart:math';

import '../models/booking_request.dart';
import '../models/cleaning_service_type.dart';
import '../repositories/booking_repository.dart';
import '../services/booking_price_calculator.dart';

/// Dummy in-memory implementation of [BookingRepository].
/// Replace with a Firebase/HTTP-backed repository in future phases.
class DummyBookingRepository implements BookingRepository {
  DummyBookingRepository({BookingPriceCalculator? calculator})
      : _priceCalculator = calculator ?? const BookingPriceCalculator() {
    _seedInitialBookings();
  }

  static const _latency = Duration(milliseconds: 550);
  final BookingPriceCalculator _priceCalculator;

  final List<CleaningServiceType> _serviceTypes = [
    const CleaningServiceType(
      id: 'standard',
      titleKey: 'serviceStandard',
      descriptionKey: 'serviceStandardDesc',
      iconName: 'cleaning_services',
      baseRate: 22,
    ),
    const CleaningServiceType(
      id: 'deep',
      titleKey: 'serviceDeepClean',
      descriptionKey: 'serviceDeepCleanDesc',
      iconName: 'auto_awesome',
      baseRate: 32,
    ),
    const CleaningServiceType(
      id: 'moveout',
      titleKey: 'serviceMoveOut',
      descriptionKey: 'serviceMoveOutDesc',
      iconName: 'moving',
      baseRate: 34,
    ),
    const CleaningServiceType(
      id: 'office',
      titleKey: 'serviceOffice',
      descriptionKey: 'serviceOfficeDesc',
      iconName: 'domain',
      baseRate: 29,
    ),
  ];

  final List<BookingRequest> _bookings = [];

  @override
  Future<List<CleaningServiceType>> getServiceTypes() async {
    await Future.delayed(_latency);
    return _serviceTypes;
  }

  @override
  Future<List<BookingRequest>> getBookings() async {
    await Future.delayed(_latency);
    return List.unmodifiable(_bookings);
  }

  @override
  Future<BookingRequest?> getBookingById(String id) async {
    await Future.delayed(_latency);
    try {
      return _bookings.firstWhere((booking) => booking.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<BookingRequest> createBooking(BookingRequest request) async {
    await Future.delayed(_latency);
    final booking = request.id.isEmpty ? request.copyWith(id: _generateId()) : request;
    _bookings.insert(0, booking);
    return booking;
  }

  @override
  Future<BookingRequest> updateBookingStatus(String id, BookingStatus status) async {
    await Future.delayed(_latency);
    final index = _bookings.indexWhere((booking) => booking.id == id);
    if (index == -1) {
      throw StateError('Booking $id not found');
    }
    final updated = _bookings[index].copyWith(status: status);
    _bookings[index] = updated;
    return updated;
  }

  @override
  Future<BookingRequest> updateBookingHasRating(String id, bool hasRating) async {
    await Future.delayed(_latency);
    final index = _bookings.indexWhere((booking) => booking.id == id);
    if (index == -1) {
      throw StateError('Booking $id not found');
    }
    final updated = _bookings[index].copyWith(hasRating: hasRating);
    _bookings[index] = updated;
    return updated;
  }

  void _seedInitialBookings() {
    final now = DateTime.now();
    final standard = _serviceTypes.first;
    final deepClean = _serviceTypes[1];

    final nextVisit = BookingRequest(
      id: 'bk_nextVisit',
      userId: 'demo-user',
      serviceTypeId: standard.id,
      propertyType: PropertyType.apartment,
      sizeCategory: BookingSizeCategory.medium,
      bedrooms: 2,
      bathrooms: 1,
      frequency: BookingFrequency.once,
      dateTime: DateTime(now.year, now.month, now.day + 2, 10, 0),
      durationHours: 3,
      addressSummary: 'Cra. 10 #22-45, Apartamento 301',
      notes: 'Edificio con portero, dejar en recepci\u00f3n si llegas antes.',
      estimatedPrice: _priceCalculator.estimatePrice(
        serviceType: standard,
        sizeCategory: BookingSizeCategory.medium,
        frequency: BookingFrequency.once,
        durationHours: 3,
      ),
      status: BookingStatus.pending,
    );

    final lastWeek = BookingRequest(
      id: 'bk_lastWeek',
      userId: 'demo-user',
      serviceTypeId: deepClean.id,
      propertyType: PropertyType.house,
      sizeCategory: BookingSizeCategory.large,
      bedrooms: 4,
      bathrooms: 3,
      frequency: BookingFrequency.monthly,
      dateTime: now.subtract(const Duration(days: 5)),
      durationHours: 5,
      addressSummary: 'Calle 8 #120, Casa esquinera',
      notes: 'Hay mascotas amigables.',
      estimatedPrice: _priceCalculator.estimatePrice(
        serviceType: deepClean,
        sizeCategory: BookingSizeCategory.large,
        frequency: BookingFrequency.monthly,
        durationHours: 5,
      ),
      status: BookingStatus.completed,
      hasRating: true,
    );

    _bookings
      ..add(nextVisit)
      ..add(lastWeek);
  }

  String _generateId() {
    final random = Random();
    return 'bk_${DateTime.now().millisecondsSinceEpoch}_${random.nextInt(9999)}';
  }
}
