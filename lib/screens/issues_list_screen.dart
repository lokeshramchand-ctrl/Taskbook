import 'package:flutter/material.dart';

import '../models/issue.dart';
import '../services/github_service.dart';
import '../widgets/status_chip.dart';
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
      appBar: AppBar(title: const Text('All Tasks')),
      body: FutureBuilder<List<Issue>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.cloud_off,
                      size: 40,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      snapshot.error is Exception
                          ? snapshot.error.toString()
                          : "Couldn't reach GitHub. Try again.",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          final issues = snapshot.data ?? const <Issue>[];
          if (issues.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 40,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No tasks yet.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              itemCount: issues.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final issue = issues[index];
                final scheme = Theme.of(context).colorScheme;
                return Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              IssueDetailScreen(issueNumber: issue.number),
                        ),
                      );
                      if (mounted) _refresh();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            issue.isOpen
                                ? Icons.radio_button_unchecked
                                : Icons.check_circle,
                            color: issue.isOpen
                                ? scheme.outline
                                : scheme.primary,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              issue.title,
                              style: issue.isOpen
                                  ? Theme.of(context).textTheme.bodyLarge
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        decoration:
                                            TextDecoration.lineThrough,
                                        color: scheme.onSurfaceVariant,
                                      ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          StatusChip(isOpen: issue.isOpen),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
