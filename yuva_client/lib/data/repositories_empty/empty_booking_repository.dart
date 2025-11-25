import '../models/booking_request.dart';
import '../models/cleaning_service_type.dart';
import '../repositories/booking_repository.dart';

/// Empty implementation that returns empty lists when dummy mode is OFF
class EmptyBookingRepository implements BookingRepository {
  @override
  Future<List<CleaningServiceType>> getServiceTypes() async {
    return [];
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

