import 'package:flutter/material.dart';

final RegExp _taskLine = RegExp(r'^(\s*[-*]\s+)\[( |x|X)\](\s.*)?$');

/// Renders an issue body as plain text, except GitHub task-list lines
/// ("- [ ] ..." / "- [x] ...") which become real checkboxes. Nothing else
/// about the Markdown is reinterpreted - GitHub remains the source of truth
/// for how the body actually renders on github.com.
class CheckboxBodyView extends StatelessWidget {
  final String body;
  final void Function(int lineIndex, bool checked)? onToggle;

  const CheckboxBodyView({super.key, required this.body, this.onToggle});

  @override
  Widget build(BuildContext context) {
    final lines = body.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < lines.length; i++) _buildLine(context, i, lines[i]),
      ],
    );
  }

  Widget _buildLine(BuildContext context, int index, String line) {
    final match = _taskLine.firstMatch(line);
    if (match == null) {
      if (line.trim().isEmpty) return const SizedBox(height: 8);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text(line, style: Theme.of(context).textTheme.bodyLarge),
      );
    }

    final checked = match.group(2)?.toLowerCase() == 'x';
    final label = (match.group(3) ?? '').trim();
    final interactive = onToggle != null;
    final scheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: CheckboxListTile(
        value: checked,
        onChanged: interactive
            ? (value) => onToggle!(index, value ?? false)
            : null,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        dense: true,
        title: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                decoration: checked ? TextDecoration.lineThrough : null,
                color: checked ? scheme.onSurfaceVariant : scheme.onSurface,
              ),
          child: Text(label),
        ),
      ),
    );
  }
}
