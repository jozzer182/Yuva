import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuva/core/providers.dart';
import 'package:yuva/data/models/booking_request.dart';
import 'package:yuva/data/models/cleaning_service_type.dart';

import 'booking_flow/booking_flow_state.dart';

final bookingDraftProvider =
    StateNotifierProvider.autoDispose<BookingDraftController, BookingDraft>((ref) {
  final calculator = ref.read(bookingPriceCalculatorProvider);
  return BookingDraftController(calculator);
});

final serviceTypesProvider = FutureProvider<List<CleaningServiceType>>((ref) async {
  final repository = ref.read(bookingRepositoryProvider);
  return repository.getServiceTypes();
});

final bookingsProvider = FutureProvider<List<BookingRequest>>((ref) async {
  final repository = ref.read(bookingRepositoryProvider);
  return repository.getBookings();
});
