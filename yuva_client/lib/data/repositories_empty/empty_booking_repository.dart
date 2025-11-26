import '../models/booking_request.dart';
import '../models/cleaning_service_type.dart';
import '../repositories/booking_repository.dart';

/// Empty implementation that returns empty lists when dummy mode is OFF
/// Note: Service types are static reference data and are always returned.
class EmptyBookingRepository implements BookingRepository {
  static const _serviceTypes = [
    CleaningServiceType(
      id: 'standard',
      titleKey: 'serviceStandard',
      descriptionKey: 'serviceStandardDesc',
      iconName: 'cleaning_services',
      baseRate: 22,
    ),
    CleaningServiceType(
      id: 'deep',
      titleKey: 'serviceDeepClean',
      descriptionKey: 'serviceDeepCleanDesc',
      iconName: 'auto_awesome',
      baseRate: 32,
    ),
    CleaningServiceType(
      id: 'moveout',
      titleKey: 'serviceMoveOut',
      descriptionKey: 'serviceMoveOutDesc',
      iconName: 'moving',
      baseRate: 34,
    ),
    CleaningServiceType(
      id: 'office',
      titleKey: 'serviceOffice',
      descriptionKey: 'serviceOfficeDesc',
      iconName: 'domain',
      baseRate: 29,
    ),
  ];

  @override
  Future<List<CleaningServiceType>> getServiceTypes() async {
    // Service types are static reference data, always available
    return _serviceTypes;
  }

  @override
  Future<List<BookingRequest>> getBookings() async {
    return [];
  }

  @override
  Future<BookingRequest?> getBookingById(String id) async {
    return null;
  }

  @override
  Future<BookingRequest> createBooking(BookingRequest request) async {
    throw UnimplementedError('Bookings not available in empty mode');
  }

  @override
  Future<BookingRequest> updateBookingStatus(String id, BookingStatus status) async {
    throw UnimplementedError('Bookings not available in empty mode');
  }

  @override
  Future<BookingRequest> updateBookingHasRating(String id, bool hasRating) async {
    throw UnimplementedError('Bookings not available in empty mode');
  }
}

