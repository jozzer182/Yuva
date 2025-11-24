import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

/// Theme configurations for yuva app
class YuvaTheme {
  YuvaTheme._();

  /// Light theme
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: YuvaColors.primaryTeal,
          onPrimary: Colors.white,
          secondary: YuvaColors.accentGold,
          onSecondary: YuvaColors.textPrimary,
          surface: YuvaColors.surfaceWhite,
          onSurface: YuvaColors.textPrimary,
          error: YuvaColors.error,
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: YuvaColors.backgroundLight,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: YuvaColors.textPrimary),
        ),
        cardTheme: CardThemeData(
          color: YuvaColors.surfaceWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: YuvaColors.surfaceCream,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: YuvaColors.primaryTeal, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        textTheme: TextTheme(
          displayLarge: YuvaTypography.hero(color: YuvaColors.textPrimary),
          displayMedium: YuvaTypography.title(color: YuvaColors.textPrimary),
          displaySmall: YuvaTypography.sectionTitle(color: YuvaColors.textPrimary),
          headlineMedium: YuvaTypography.subtitle(color: YuvaColors.textPrimary),
          bodyLarge: YuvaTypography.body(color: YuvaColors.textPrimary),
          bodyMedium: YuvaTypography.bodySmall(color: YuvaColors.textPrimary),
          bodySmall: YuvaTypography.caption(color: YuvaColors.textSecondary),
          labelLarge: YuvaTypography.button(color: Colors.white),
        ),
      );

  /// Dark theme
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: YuvaColors.darkPrimaryTeal,
          onPrimary: Colors.white,
          secondary: YuvaColors.darkAccentGold,
          onSecondary: YuvaColors.textPrimary,
          surface: YuvaColors.darkSurface,
          onSurface: Colors.white,
          error: YuvaColors.error,
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: YuvaColors.darkBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        cardTheme: CardThemeData(
          color: YuvaColors.darkSurface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: YuvaColors.darkBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: YuvaColors.darkPrimaryTeal, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        textTheme: TextTheme(
          displayLarge: YuvaTypography.hero(color: Colors.white),
          displayMedium: YuvaTypography.title(color: Colors.white),
          displaySmall: YuvaTypography.sectionTitle(color: Colors.white),
          headlineMedium: YuvaTypography.subtitle(color: Colors.white),
          bodyLarge: YuvaTypography.body(color: Colors.white),
          bodyMedium: YuvaTypography.bodySmall(color: Colors.white70),
          bodySmall: YuvaTypography.caption(color: Colors.white60),
          labelLarge: YuvaTypography.button(color: Colors.white),
        ),
      );
}
