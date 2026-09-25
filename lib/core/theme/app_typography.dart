import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The app's type scale. Manrope carries display/heading/body text with
/// intentional tracking; JetBrains Mono renders issue numbers and counts
/// with tabular figures so digits align — a small nod to the app's
/// developer-tool domain.
class AppTypography {
  AppTypography._();

  static TextTheme textTheme(ColorScheme scheme) {
    final base = GoogleFonts.manropeTextTheme();
    return base
        .copyWith(
          displayLarge: base.displayLarge?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -1.0,
            height: 1.05,
            color: scheme.onSurface,
          ),
          headlineLarge: base.headlineLarge?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            height: 1.15,
            color: scheme.onSurface,
          ),
          headlineMedium: base.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
            height: 1.2,
            color: scheme.onSurface,
          ),
          titleLarge: base.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
            height: 1.25,
            color: scheme.onSurface,
          ),
          titleMedium: base.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: scheme.onSurface,
          ),
          bodyLarge: base.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
            height: 1.45,
            color: scheme.onSurface,
          ),
          bodyMedium: base.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            height: 1.45,
            color: scheme.onSurfaceVariant,
          ),
          labelLarge: base.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
          labelMedium: base.labelMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
          labelSmall: base.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: scheme.onSurfaceVariant,
          ),
        )
        .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);
  }

  /// Tabular-figure numeric style for issue numbers, counts and progress
  /// fractions — kept separate from the main type scale since it's used
  /// sparingly, not as body text.
  static TextStyle numeric({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }
}
