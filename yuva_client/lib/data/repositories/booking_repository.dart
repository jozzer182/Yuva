import '../models/booking_request.dart';
import '../models/cleaning_service_type.dart';

/// Abstraction for booking data access.
/// Dummy implementations live in `repositories_dummy`, future backends can
/// provide Firebase/REST implementations without touching the UI.
abstract class BookingRepository {
  Future<List<CleaningServiceType>> getServiceTypes();
  Future<List<BookingRequest>> getBookings();
  Future<BookingRequest?> getBookingById(String id);
  Future<BookingRequest> createBooking(BookingRequest request);
  Future<BookingRequest> updateBookingStatus(String id, BookingStatus status);
  Future<BookingRequest> updateBookingHasRating(String id, bool hasRating);
}
