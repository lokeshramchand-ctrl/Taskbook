import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../models/issue.dart';
import 'status_chip.dart';
import 'task_progress_bar.dart';

/// A single row in the issues list: status glyph, issue number, title,
/// checklist progress (when the body has one) and an open/closed chip.
class IssueListTile extends StatelessWidget {
  final Issue issue;
  final VoidCallback onTap;

  const IssueListTile({super.key, required this.issue, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final counts = TaskCounts.fromBody(issue.body);
    final doneColor = AppColors.success(Theme.of(context).brightness);

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md + 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    issue.isOpen
                        ? Icons.radio_button_unchecked_rounded
                        : Icons.check_circle_rounded,
                    size: 22,
                    color: issue.isOpen ? scheme.outline : doneColor,
                  ),
                  const SizedBox(width: AppSpacing.md + 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '#${issue.number}',
                          style: AppTypography.numeric(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          issue.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: issue.isOpen
                              ? Theme.of(context).textTheme.titleMedium
                              : Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: scheme.onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  StatusChip(isOpen: issue.isOpen),
                ],
              ),
              if (counts.hasTasks) ...[
                const SizedBox(height: AppSpacing.sm + 2),
                Padding(
                  padding: const EdgeInsets.only(left: 22 + AppSpacing.md + 2),
                  child: TaskProgressBar(counts: counts),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
