import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Provides pre-built [TextStyle]s for the game UI.
///
/// Uses [GoogleFonts.roboto] when available, and gracefully falls back to the
/// system default font if the font cannot be loaded (e.g. in test environments
/// where assets or network are unavailable).
class AppTextStyles {
  AppTextStyles._();

  /// Score label style: green, bold, [fontSize] px.
  static TextStyle scoreStyle({required double fontSize}) {
    return _robotoOrFallback(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: const Color.fromARGB(255, 55, 195, 62),
    );
  }

  /// Game-over label style: red, bold, [fontSize] px.
  static TextStyle gameOverStyle({required double fontSize}) {
    return _robotoOrFallback(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: Colors.red,
    );
  }

  /// Returns a Roboto [TextStyle], falling back to the system font if
  /// google_fonts cannot resolve the typeface (e.g. in tests).
  static TextStyle _robotoOrFallback({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
  }) {
    try {
      return GoogleFonts.roboto(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
    } catch (_) {
      // Fallback when google_fonts is unavailable (e.g. in headless tests).
      return TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
    }
  }
}
