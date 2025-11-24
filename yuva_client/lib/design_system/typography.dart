import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography system for yuva app
/// Uses a modern, legible sans-serif font with various scales
class YuvaTypography {
  YuvaTypography._();

  // Base font family (using Nunito for friendly, rounded feel)
  static TextStyle get _baseTextStyle => GoogleFonts.nunito();

  // Hero / Display
  static TextStyle hero({Color? color}) => _baseTextStyle.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        height: 1.2,
        color: color,
        letterSpacing: -0.5,
      );

  // Title / H1
  static TextStyle title({Color? color}) => _baseTextStyle.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: color,
        letterSpacing: -0.3,
      );

  // Section Title / H2
  static TextStyle sectionTitle({Color? color}) => _baseTextStyle.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.4,
        color: color,
        letterSpacing: -0.2,
      );

  // Subtitle / H3
  static TextStyle subtitle({Color? color}) => _baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.5,
        color: color,
      );

  // Body Text
  static TextStyle body({Color? color}) => _baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color,
      );

  // Body Small
  static TextStyle bodySmall({Color? color}) => _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color,
      );

  // Caption
  static TextStyle caption({Color? color}) => _baseTextStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: color,
      );

  // Overline
  static TextStyle overline({Color? color}) => _baseTextStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: color,
        letterSpacing: 1.0,
      ).apply(fontFeatures: const [FontFeature.enable('smcp')]);

  // Button Text
  static TextStyle button({Color? color}) => _baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: color,
        letterSpacing: 0.2,
      );
}
