import '../models/booking_request.dart';
import '../models/cleaning_service_type.dart';

/// Pure Dart price calculator used by UI and repositories.
/// Backends can swap the implementation while keeping this contract.
class BookingPriceCalculator {
  const BookingPriceCalculator();

  double estimatePrice({
    required CleaningServiceType serviceType,
    required BookingSizeCategory sizeCategory,
    required BookingFrequency frequency,
    required double durationHours,
  }) {
    final sizeMultiplier = switch (sizeCategory) {
      BookingSizeCategory.small => 0.9,
      BookingSizeCategory.medium => 1.0,
      BookingSizeCategory.large => 1.25,
    };

    final frequencyMultiplier = switch (frequency) {
      BookingFrequency.once => 1.0,
      BookingFrequency.weekly => 0.9,
      BookingFrequency.biweekly => 0.93,
      BookingFrequency.monthly => 0.96,
    };

    final base = serviceType.baseRate * durationHours;
    final estimated = base * sizeMultiplier * frequencyMultiplier;

    // Round to 2 decimals for currency display.
    return double.parse(estimated.toStringAsFixed(2));
  }
}
