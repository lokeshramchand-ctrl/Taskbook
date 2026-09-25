import 'package:flutter/material.dart';

/// A [FilledButton] or [OutlinedButton] that swaps its label for a spinner
/// while [loading] is true, instead of every screen wiring up its own
/// SizedBox + CircularProgressIndicator swap.
class LoadingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool loading;
  final Widget label;
  final IconData? icon;
  final bool outlined;

  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.loading = false,
    this.icon,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final child = AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: loading
          ? SizedBox(
              key: const ValueKey('spinner'),
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                color: outlined ? scheme.primary : scheme.onPrimary,
              ),
            )
          : Row(
              key: const ValueKey('label'),
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: 10),
                ],
                label,
              ],
            ),
    );

    final onTap = loading ? null : onPressed;
    return outlined
        ? OutlinedButton(onPressed: onTap, child: child)
        : FilledButton(onPressed: onTap, child: child);
  }
}
