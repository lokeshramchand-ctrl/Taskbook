import 'package:flutter/material.dart';

/// Constrains content to a comfortable reading width on tablets and wide
/// windows, while filling the width unchanged on phones. Defaults to
/// top-aligned, which is what scrolling content (lists, forms) wants;
/// pass [Alignment.center] for a screen whose content should stay
/// vertically centered instead.
class ResponsiveContent extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final AlignmentGeometry alignment;

  const ResponsiveContent({
    super.key,
    required this.child,
    this.maxWidth = 640,
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
