import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_radii.dart';
import '../core/theme/app_spacing.dart';
import '../services/github_service.dart';
import '../shared/widgets/loading_button.dart';
import '../shared/widgets/responsive_content.dart';

/// A very simple Markdown writing screen. Enter always inserts a newline;
/// creating the issue is a dedicated button (and Cmd/Ctrl+Enter on desktop).
class CreateIssueScreen extends StatefulWidget {
  const CreateIssueScreen({super.key});

  @override
  State<CreateIssueScreen> createState() => _CreateIssueScreenState();
}

class _CreateIssueScreenState extends State<CreateIssueScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController(
    text: '- [ ] ',
  );
  bool _creating = false;
  String? _error;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() => _error = 'Give it a title first.');
      return;
    }
    setState(() {
      _creating = true;
      _error = null;
    });
    try {
      final issue = await GithubService.instance.createIssue(
        title: title,
        body: _bodyController.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Issue created.')),
      );
      Navigator.of(context).pop(issue);
    } on GithubApiException catch (e) {
      setState(() {
        _creating = false;
        _error = e.message;
      });
    } catch (_) {
      setState(() {
        _creating = false;
        _error = "Couldn't create the issue. Try again.";
      });
    }
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.enter &&
        (HardwareKeyboard.instance.isMetaPressed ||
            HardwareKeyboard.instance.isControlPressed)) {
      if (!_creating) _create();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('New issue')),
      body: SafeArea(
        child: Center(
          child: ResponsiveContent(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _titleController,
                    textCapitalization: TextCapitalization.sentences,
                    style: Theme.of(context).textTheme.titleMedium,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: _error == null
                        ? const SizedBox.shrink()
                        : Container(
                            key: ValueKey(_error),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md + 2,
                              vertical: AppSpacing.sm + 2,
                            ),
                            margin: const EdgeInsets.only(bottom: AppSpacing.md),
                            decoration: BoxDecoration(
                              color: scheme.errorContainer.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(AppRadii.sm),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline_rounded,
                                  size: 18,
                                  color: scheme.error,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    _error!,
                                    style: TextStyle(color: scheme.error),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                  Expanded(
                    child: Focus(
                      onKeyEvent: _handleKey,
                      child: TextField(
                        controller: _bodyController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        textCapitalization: TextCapitalization.sentences,
                        style: Theme.of(context).textTheme.bodyLarge,
                        decoration: const InputDecoration(
                          hintText: '- [ ] Task one\n- [ ] Task two',
                          alignLabelWithHint: true,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  LoadingButton(
                    onPressed: _create,
                    loading: _creating,
                    label: const Text('Create issue'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
