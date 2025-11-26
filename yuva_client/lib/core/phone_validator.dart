/// Phone number validation utilities for Colombian numbers.
/// 
/// Colombian mobile numbers are 10 digits starting with 3.
/// This validator accepts raw 10-digit numbers and normalizes them
/// to the international format +57XXXXXXXXXX.
class PhoneValidator {
  /// Colombian country code
  static const String countryCode = '+57';
  
  /// Expected length of Colombian mobile numbers (without country code)
  static const int expectedLength = 10;
  
  /// Validates a Colombian phone number.
  /// 
  /// Returns true if the phone is exactly 10 digits and numeric only.
  /// Does not validate the starting digit (3 for mobile) to allow flexibility.
  static bool isValid(String? phone) {
    if (phone == null || phone.isEmpty) return false;
    
    // Remove any spaces, dashes, or other formatting
    final cleaned = cleanNumber(phone);
    
    // Must be exactly 10 digits
    if (cleaned.length != expectedLength) return false;
    
    // Must be all digits
    if (!RegExp(r'^\d+$').hasMatch(cleaned)) return false;
    
    return true;
  }
  
  /// Cleans a phone number by removing all non-digit characters.
  /// Also strips the +57 prefix if present.
  static String cleanNumber(String phone) {
    // Remove all non-digit characters
    var cleaned = phone.replaceAll(RegExp(r'\D'), '');
    
    // If it starts with 57 and is 12 digits, remove the country code
    if (cleaned.startsWith('57') && cleaned.length == 12) {
      cleaned = cleaned.substring(2);
    }
    
    return cleaned;
  }
  
  /// Formats a 10-digit number to international format: +57 XXX XXX XXXX
  static String formatInternational(String phone) {
    final cleaned = cleanNumber(phone);
    if (cleaned.length != expectedLength) return phone;
    
    return '$countryCode ${cleaned.substring(0, 3)} ${cleaned.substring(3, 6)} ${cleaned.substring(6)}';
  }
  
  /// Returns the full international number for Firebase: +57XXXXXXXXXX
  static String toE164(String phone) {
    final cleaned = cleanNumber(phone);
    if (cleaned.length != expectedLength) return phone;
    
    return '$countryCode$cleaned';
  }
  
  /// Masks a phone number for display: +57 *** *** 4567
  static String mask(String phone) {
    final cleaned = cleanNumber(phone);
    if (cleaned.length != expectedLength) return phone;
    
    return '$countryCode *** *** ${cleaned.substring(6)}';
  }
}
