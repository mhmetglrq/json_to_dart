import 'package:flutter/material.dart';
import 'package:json_to_dart/config/extensions/context_extensions.dart';

import '../items/app_colors.dart';

class AppTheme {
  const AppTheme._();
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.kPrimaryLight,
      scaffoldBackgroundColor: AppColors.kWhite,
      fontFamily: 'HelveticaNeue',
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: context.dynamicHeight(0.048), // Biraz küçültüldü
          decoration: TextDecoration.none,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600, // Kalınlığı hafifletildi
          height: 56 / context.dynamicHeight(0.048),
          letterSpacing: 0,
        ),
        displayMedium: TextStyle(
          fontSize: context.dynamicHeight(0.048), // Biraz küçültüldü
          decoration: TextDecoration.none,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400, // Kalınlık daha hafif
          height: 56 / context.dynamicHeight(0.048),
          letterSpacing: 0,
        ),
        displaySmall: TextStyle(
          fontSize: context.dynamicHeight(0.038), // Küçültüldü
          decoration: TextDecoration.none,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600, // Kalınlığı hafifletildi
          height: 40 / context.dynamicHeight(0.038),
          letterSpacing: 0,
        ),
        headlineLarge: TextStyle(
          fontSize: context.dynamicHeight(0.038), // Küçültüldü
          decoration: TextDecoration.none,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400, // Daha hafif
          height: 40 / context.dynamicHeight(0.038),
          letterSpacing: 0,
        ),
        headlineMedium: TextStyle(
          fontSize: context.dynamicHeight(0.024), // Biraz küçültüldü
          decoration: TextDecoration.none,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600, // Kalınlığı hafifletildi
          height: 32 / context.dynamicHeight(0.024),
          letterSpacing: 0,
        ),
        headlineSmall: TextStyle(
          fontSize: context.dynamicHeight(0.024), // Biraz küçültüldü
          decoration: TextDecoration.none,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400, // Daha hafif
          height: 32 / context.dynamicHeight(0.024),
          letterSpacing: 0,
        ),
        titleLarge: TextStyle(
          fontSize: context.dynamicHeight(0.018), // Küçültüldü
          decoration: TextDecoration.none,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600, // Kalınlığı hafifletildi
          height: 24 / context.dynamicHeight(0.018),
          letterSpacing: 0,
        ),
        titleMedium: TextStyle(
          fontSize: context.dynamicHeight(0.018), // Küçültüldü
          decoration: TextDecoration.none,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400, // Daha hafif
          height: 24 / context.dynamicHeight(0.018),
          letterSpacing: 0,
        ),
        bodyLarge: TextStyle(
          fontSize: context.dynamicHeight(0.019), // Küçültüldü
          decoration: TextDecoration.none,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600, // Kalınlığı hafifletildi
          height: 24 / context.dynamicHeight(0.019),
          letterSpacing: 0,
        ),
        bodyMedium: TextStyle(
          fontSize: context.dynamicHeight(0.019), // Küçültüldü
          decoration: TextDecoration.none,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400, // Daha hafif
          height: 24 / context.dynamicHeight(0.019),
          letterSpacing: 0,
        ),
        bodySmall: TextStyle(
          fontSize: context.dynamicHeight(0.015), // Küçültüldü
          decoration: TextDecoration.none,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
          height: 24 / context.dynamicHeight(0.015),
          letterSpacing: 0,
        ),
        labelLarge: TextStyle(
          fontSize: context.dynamicHeight(0.018), // Küçültüldü
          decoration: TextDecoration.none,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
          height: 16 / context.dynamicHeight(0.018),
          letterSpacing: 0,
        ),
        labelMedium: TextStyle(
          fontSize: context.dynamicHeight(0.015), // Küçültüldü
          decoration: TextDecoration.none,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
          height: 16 / context.dynamicHeight(0.015),
          letterSpacing: 0,
        ),
        labelSmall: TextStyle(
          fontSize: context.dynamicHeight(0.015), // Küçültüldü
          decoration: TextDecoration.none,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
          height: 16 / context.dynamicHeight(0.015),
          letterSpacing: 0,
        ),
      ),
    );
  }
}
