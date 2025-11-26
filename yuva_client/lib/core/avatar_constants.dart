/// Avatar constants and utilities for static avatar selection.
/// 
/// Avatars are bundled as local assets and referenced by ID.
/// The ID is stored in Firestore to persist user's avatar choice.
class AvatarConstants {
  AvatarConstants._();

  /// List of all available avatar IDs
  static const List<String> avatarIds = [
    'A1', 'A2',
    'B1', 'B2',
    'C1', 'C2',
    'D1', 'D2',
    'E1', 'E2',
    'F1', 'F2',
    'G1', 'G2',
    'H1', 'H2',
    'I1', 'I2',
    'J1', 'J2',
    'K1', 'K2',
  ];

  /// Get the asset path for a given avatar ID
  static String getAssetPath(String avatarId) {
    return 'assets/avatars/$avatarId.png';
  }

  /// Check if an avatar ID is valid
  static bool isValidAvatarId(String? avatarId) {
    if (avatarId == null) return false;
    return avatarIds.contains(avatarId);
  }

  /// Get a default avatar ID (first in the list)
  static String get defaultAvatarId => avatarIds.first;
}
