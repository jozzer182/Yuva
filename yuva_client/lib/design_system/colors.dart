import 'package:flutter/material.dart';

/// Color palette inspired by the yuva app icon
/// - Primary: Soft aqua/teal (house body)
/// - Accent: Warm pastel yellow/gold (roof, broom, spray)
/// - Backgrounds: Soft warm gradients and neutrals
class YuvaColors {
  YuvaColors._();

  // Primary Colors (Teal/Aqua)
  static const Color primaryTeal = Color(0xFF7DCFCF);
  static const Color primaryTealLight = Color(0xFFA8E6E6);
  static const Color primaryTealDark = Color(0xFF4FA6A6);
  
  // Accent Colors (Warm Gold/Yellow)
  static const Color accentGold = Color(0xFFFFD97D);
  static const Color accentGoldLight = Color(0xFFFFE7A8);
  static const Color accentGoldDark = Color(0xFFD4B05C);
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFFFFBF5);
  static const Color backgroundWarm = Color(0xFFFFF9EE);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceCream = Color(0xFFFFFAF0);
  
  // Neutral Colors
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textTertiary = Color(0xFFA0AEC0);
  
  // Semantic Colors
  static const Color success = Color(0xFF68D391);
  static const Color warning = Color(0xFFFBD38D);
  static const Color error = Color(0xFFFC8181);
  static const Color info = Color(0xFF63B3ED);
  
  // Shadow Colors (for claymorphism)
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowDark = Color(0x33000000);
  static const Color highlightWhite = Color(0x66FFFFFF);
  
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF1A202C);
  static const Color darkSurface = Color(0xFF2D3748);
  static const Color darkPrimaryTeal = Color(0xFF5FA9A9);
  static const Color darkAccentGold = Color(0xFFD4B974);
}
