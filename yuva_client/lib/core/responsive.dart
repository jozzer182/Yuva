import 'package:flutter/material.dart';

/// Breakpoints para diseño responsive
class Breakpoints {
  static const double phone = 600;
  static const double tablet = 600;
  static const double largeTablet = 1024;
}

/// Utilidades para diseño responsive
class ResponsiveUtils {
  /// Verifica si el ancho actual corresponde a un teléfono
  static bool isPhone(BuildContext context) {
    return MediaQuery.of(context).size.width < Breakpoints.phone;
  }

  /// Verifica si el ancho actual corresponde a una tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= Breakpoints.tablet && width < Breakpoints.largeTablet;
  }

  /// Verifica si el ancho actual corresponde a una tablet grande o desktop
  static bool isLargeTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= Breakpoints.largeTablet;
  }

  /// Verifica si la orientación es landscape
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Obtiene el ancho de la pantalla
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Obtiene la altura de la pantalla
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Obtiene padding horizontal responsive
  static EdgeInsets horizontalPadding(BuildContext context) {
    if (isPhone(context)) {
      return const EdgeInsets.symmetric(horizontal: 16);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 24);
    } else {
      return const EdgeInsets.symmetric(horizontal: 32);
    }
  }

  /// Obtiene padding vertical responsive
  static EdgeInsets verticalPadding(BuildContext context) {
    if (isPhone(context)) {
      return const EdgeInsets.symmetric(vertical: 16);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(vertical: 24);
    } else {
      return const EdgeInsets.symmetric(vertical: 32);
    }
  }

  /// Obtiene padding general responsive
  static EdgeInsets padding(BuildContext context) {
    if (isPhone(context)) {
      return const EdgeInsets.all(16);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24);
    } else {
      return const EdgeInsets.all(32);
    }
  }

  /// Obtiene el ancho máximo para contenido centrado en tablets
  static double maxContentWidth(BuildContext context) {
    if (isPhone(context)) {
      return double.infinity;
    } else if (isTablet(context)) {
      return 1200;
    } else {
      return 1400;
    }
  }

  /// Obtiene el ancho máximo para formularios
  static double maxFormWidth(BuildContext context) {
    if (isPhone(context)) {
      return double.infinity;
    } else {
      return 600;
    }
  }
}

