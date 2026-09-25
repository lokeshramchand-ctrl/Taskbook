import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_spacing.dart';

/// A small dot-and-label pill showing whether an issue is open or closed.
class StatusChip extends StatelessWidget {
  final bool isOpen;

  const StatusChip({super.key, required this.isOpen});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color =
        isOpen ? scheme.primary : AppColors.success(Theme.of(context).brightness);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadii.xs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.xs + 2),
          Text(
            isOpen ? 'Open' : 'Closed',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  letterSpacing: 0.2,
                ),
          ),
        ],
      ),
    );
  }
}
