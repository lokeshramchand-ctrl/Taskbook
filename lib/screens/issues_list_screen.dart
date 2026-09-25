import 'package:flutter/material.dart';

import '../models/issue.dart';
import '../services/github_service.dart';
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
              child: Text(
                snapshot.error is Exception
                    ? snapshot.error.toString()
                    : "Couldn't reach GitHub. Try again.",
              ),
            );
          }
          final issues = snapshot.data ?? const <Issue>[];
          if (issues.isEmpty) {
            return const Center(child: Text('No tasks yet.'));
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              itemCount: issues.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final issue = issues[index];
                return ListTile(
                  leading: Icon(
                    issue.isOpen
                        ? Icons.check_box_outline_blank
                        : Icons.check_box,
                    color: issue.isOpen
                        ? Theme.of(context).colorScheme.outline
                        : Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    issue.title,
                    style: issue.isOpen
                        ? null
                        : const TextStyle(
                            decoration: TextDecoration.lineThrough),
                  ),
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            IssueDetailScreen(issueNumber: issue.number),
                      ),
                    );
                    if (mounted) _refresh();
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
