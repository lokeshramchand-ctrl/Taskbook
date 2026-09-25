import 'package:flutter/material.dart';

/// Semantic colors that sit alongside [ColorScheme] for states Material 3
/// doesn't name out of the box (success, warning). Everything else in the
/// app should read colors off `Theme.of(context).colorScheme`, not from
/// here or from raw [Colors].
class AppColors {
  AppColors._();

  /// Brand seed — matches the app icon and web manifest theme color.
  static const Color brandSeed = Color(0xFF4338CA);

  static const Color successLight = Color(0xFF15803D);
  static const Color successDark = Color(0xFF4ADE80);

  static Color success(Brightness brightness) =>
      brightness == Brightness.dark ? successDark : successLight;

  /// Builds a full [ColorScheme] from the brand seed, with neutrals tinted
  /// toward the brand hue rather than default Material cool gray, and a
  /// slightly warmer near-black in dark mode to match the launcher icon's
  /// adaptive background.
  static ColorScheme scheme(Brightness brightness) {
    final base = ColorScheme.fromSeed(
      seedColor: brandSeed,
      brightness: brightness,
    );
    if (brightness == Brightness.dark) {
      return base.copyWith(
        surface: const Color(0xFF14131A),
        surfaceContainerLowest: const Color(0xFF0E0D12),
        surfaceContainerLow: const Color(0xFF18171F),
        surfaceContainer: const Color(0xFF1C1B24),
        surfaceContainerHigh: const Color(0xFF232130),
        surfaceContainerHighest: const Color(0xFF2A2838),
      );
    }
    return base.copyWith(
      surface: const Color(0xFFFAF9FC),
      surfaceContainerLowest: const Color(0xFFFFFFFF),
      surfaceContainerLow: const Color(0xFFF5F3F9),
      surfaceContainer: const Color(0xFFEFEDF6),
      surfaceContainerHigh: const Color(0xFFE9E6F2),
      surfaceContainerHighest: const Color(0xFFE3DFEE),
    );
  }
}
