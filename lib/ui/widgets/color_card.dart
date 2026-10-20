import 'package:flutter/material.dart';

import '../palette.dart';

/// The list-row card used across the app: a solid pale tint of [color] with a
/// border in the vivid color, so dark text on it stays readable. Changes of
/// [selected] fade and grow instead of snapping.
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
    final radius = BorderRadius.circular(16);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      margin: margin,
      decoration: BoxDecoration(
        color: tintOf(color, selected ? 0.26 : 0.16),
        borderRadius: radius,
        border: Border.all(color: color, width: selected ? 3 : 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}
