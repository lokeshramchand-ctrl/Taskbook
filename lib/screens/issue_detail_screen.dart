import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/issue.dart';
import '../services/github_service.dart';
import '../widgets/checkbox_body_view.dart';
import '../widgets/status_chip.dart';

/// Shows one issue's title and body, with GitHub task-list checkboxes
/// rendered as real checkboxes. Tapping a checkbox updates the issue body on
/// GitHub directly - GitHub remains the only source of truth, there is no
/// local task state.
class IssueDetailScreen extends StatefulWidget {
  final int issueNumber;

  const IssueDetailScreen({super.key, required this.issueNumber});

  @override
  State<IssueDetailScreen> createState() => _IssueDetailScreenState();
}

class _IssueDetailScreenState extends State<IssueDetailScreen> {
  Issue? _issue;
  String? _error;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final issue = await GithubService.instance.fetchIssue(widget.issueNumber);
      setState(() {
        _issue = issue;
        _loading = false;
      });
    } on GithubApiException catch (e) {
      setState(() {
        _error = e.message;
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _error = "Couldn't reach GitHub. Try again.";
        _loading = false;
      });
    }
  }

  Future<void> _toggleLine(int lineIndex, bool checked) async {
    final issue = _issue;
    if (issue == null || _saving) return;

    final lines = issue.body.split('\n');
    final line = lines[lineIndex];
    final updatedLine = checked
        ? line.replaceFirst('[ ]', '[x]')
        : line.replaceFirst(RegExp(r'\[x\]', caseSensitive: false), '[ ]');
    lines[lineIndex] = updatedLine;
    final newBody = lines.join('\n');

    setState(() {
      _issue = Issue(
        number: issue.number,
        title: issue.title,
        body: newBody,
        isOpen: issue.isOpen,
        htmlUrl: issue.htmlUrl,
      );
      _saving = true;
    });

    try {
      final updated =
          await GithubService.instance.updateIssueBody(issue.number, newBody);
      if (mounted) setState(() => _issue = updated);
    } on GithubApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Couldn't create the issue. Try again.")),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _openOnGithub() async {
    final url = _issue?.htmlUrl;
    if (url == null || url.isEmpty) return;
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final issue = _issue;
    return Scaffold(
      appBar: AppBar(title: Text(issue?.title ?? 'Issue')),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(_error!))
                : issue == null
                    ? const SizedBox.shrink()
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  issue.title,
                                  style:
                                      Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                              const SizedBox(width: 8),
                              StatusChip(isOpen: issue.isOpen),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: CheckboxBodyView(
                                body: issue.body,
                                onToggle: _toggleLine,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 52,
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.open_in_new),
                              label: const Text('Open on GitHub'),
                              onPressed: _openOnGithub,
                            ),
                          ),
                        ],
                      ),
      ),
    );
  }
}
