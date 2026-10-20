import 'package:flutter/material.dart';

class StarRow extends StatelessWidget {
  const StarRow({
    super.key,
    required this.stars,
    this.size = 20,
    this.animate = false,
  });

  final int stars;
  final double size;

  /// Pops the earned stars in one after another.
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 3; i++) _star(i < stars, i),
      ],
    );
  }

  Widget _star(bool filled, int index) {
    final icon = Icon(
      filled ? Icons.star_rounded : Icons.star_outline_rounded,
      size: size,
      color: filled ? Colors.amber : Colors.grey,
    );
    if (!animate || !filled) return icon;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + index * 350),
      curve: Curves.elasticOut,
      builder: (context, value, child) =>
          Transform.scale(scale: value, child: child),
      child: icon,
    );
  }
}
