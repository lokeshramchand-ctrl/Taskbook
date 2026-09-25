import 'package:flutter/material.dart';

import '../core/theme/app_spacing.dart';
import '../models/issue.dart';
import '../services/github_service.dart';
import '../shared/widgets/app_empty_state.dart';
import '../shared/widgets/app_error_state.dart';
import '../shared/widgets/issue_list_tile.dart';
import '../shared/widgets/issues_list_skeleton.dart';
import '../shared/widgets/responsive_content.dart';
import '../shared/widgets/staggered_fade_in.dart';
import 'issue_detail_screen.dart';

/// Shows every issue in the repository as a simple mobile list. Open issues
/// are active tasks, closed issues are completed tasks - straight from the
/// real GitHub issue state.
class IssuesListScreen extends StatefulWidget {
  const IssuesListScreen({super.key});

  @override
  State<IssuesListScreen> createState() => _IssuesListScreenState();
}

class _IssuesListScreenState extends State<IssuesListScreen> {
  late Future<List<Issue>> _future;

  @override
  void initState() {
    super.initState();
    _future = GithubService.instance.fetchIssues();
  }

  Future<void> _refresh() async {
    final future = GithubService.instance.fetchIssues();
    setState(() => _future = future);
    await future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All tasks')),
      body: FutureBuilder<List<Issue>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const IssuesListSkeleton();
          }
          if (snapshot.hasError) {
            return AppErrorState(
              message: snapshot.error is Exception
                  ? snapshot.error.toString()
                  : "Couldn't reach GitHub. Try again.",
              onRetry: _refresh,
            );
          }
          final issues = snapshot.data ?? const <Issue>[];
          if (issues.isEmpty) {
            return AppEmptyState(
              icon: Icons.inbox_outlined,
              title: 'No tasks yet',
              message: 'Issues you create will show up here.',
              actionLabel: 'Refresh',
              onAction: _refresh,
            );
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: Center(
              child: ResponsiveContent(
                maxWidth: 720,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  itemCount: issues.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm + 2),
                  itemBuilder: (context, index) {
                    final issue = issues[index];
                    return StaggeredFadeIn(
                      index: index,
                      child: IssueListTile(
                        issue: issue,
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  IssueDetailScreen(issueNumber: issue.number),
                            ),
                          );
                          if (mounted) _refresh();
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
