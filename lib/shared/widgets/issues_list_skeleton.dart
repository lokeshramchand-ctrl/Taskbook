import 'package:flutter/material.dart';

import '../../core/theme/app_radii.dart';
import '../../core/theme/app_spacing.dart';
import 'skeleton_box.dart';

/// Placeholder rows shaped like [IssueListTile], shown while issues load
/// instead of a bare centered spinner.
class IssuesListSkeleton extends StatelessWidget {
  const IssuesListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      itemCount: 8,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm + 2),
      itemBuilder: (context, index) => ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Row(
            children: [
              const SkeletonBox(width: 22, height: 22, radius: 11),
              const SizedBox(width: AppSpacing.md + 2),
              Expanded(
                child: SkeletonBox(
                  height: 16,
                  width: index.isEven ? 220 : 160,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const SkeletonBox(width: 56, height: 22, radius: AppRadii.xs),
            ],
          ),
        ),
      ),
    );
  }
}
