import 'package:flutter/material.dart';

import '../palette.dart';

/// The list-row card used across the app: a solid pale tint of [color] with a
/// border in the vivid color, so dark text on it stays readable.
class ColorCard extends StatelessWidget {
  const ColorCard({
    super.key,
    required this.color,
    required this.child,
    this.margin = const EdgeInsets.only(top: 12),
    this.selected = false,
  });

  final Color color;
  final Widget child;
  final EdgeInsetsGeometry margin;

  /// Draws a stronger tint and a thicker border.
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      color: tintOf(color, selected ? 0.26 : 0.16),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color, width: selected ? 3 : 2),
      ),
      child: child,
    );
  }
}
