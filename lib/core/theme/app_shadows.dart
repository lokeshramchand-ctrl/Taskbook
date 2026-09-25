import 'package:flutter/material.dart';

/// Shadows tinted with the surrounding color scheme instead of flat black,
/// so elevation reads as a soft glow rather than a generic drop-shadow.
class AppShadows {
  AppShadows._();

  static List<BoxShadow> soft(ColorScheme scheme) => [
        BoxShadow(
          color: scheme.shadow.withValues(alpha: 0.08),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> brand(ColorScheme scheme, {double alpha = 0.25}) => [
        BoxShadow(
          color: scheme.primary.withValues(alpha: alpha),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ];
}
