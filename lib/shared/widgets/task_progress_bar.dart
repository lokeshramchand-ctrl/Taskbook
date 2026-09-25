import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

final RegExp _taskLine = RegExp(r'^\s*[-*]\s+\[( |x|X)\]');

class TaskCounts {
  final int done;
  final int total;

  const TaskCounts(this.done, this.total);

  bool get hasTasks => total > 0;
  bool get allDone => hasTasks && done == total;
  double get fraction => hasTasks ? done / total : 0;

  static TaskCounts fromBody(String body) {
    var done = 0;
    var total = 0;
    for (final line in body.split('\n')) {
      final match = _taskLine.firstMatch(line);
      if (match == null) continue;
      total++;
      if (match.group(1)?.toLowerCase() == 'x') done++;
    }
    return TaskCounts(done, total);
  }
}

/// A slim progress bar with a "n of m done" label, derived from the same
/// checklist lines [CheckboxBodyView] renders as checkboxes.
class TaskProgressBar extends StatelessWidget {
  final TaskCounts counts;

  const TaskProgressBar({super.key, required this.counts});

  @override
  Widget build(BuildContext context) {
    if (!counts.hasTasks) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    final color = counts.allDone
        ? AppColors.success(Theme.of(context).brightness)
        : scheme.primary;

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: counts.fraction),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 6,
                backgroundColor: scheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Text(
          '${counts.done}/${counts.total}',
          style: AppTypography.numeric(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
