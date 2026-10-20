import 'package:flutter/material.dart';

/// Swaps its child with a "fade through": the old child fades out first and
/// only then the new one fades in, so two versions are never on screen over
/// each other (which is what makes a plain cross-fade look smudged).
class FadeThrough extends StatelessWidget {
  const FadeThrough({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 380),
    this.alignment = Alignment.center,
    this.scale = 0.97,
  });

  /// Give this a key that changes whenever the content should swap.
  final Widget child;
  final Duration duration;
  final Alignment alignment;

  /// How small the child is when fully faded out.
  final double scale;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: const Interval(0.45, 1, curve: Curves.easeOutCubic),
      switchOutCurve: const Interval(0.55, 1, curve: Curves.easeIn),
      layoutBuilder: (current, previous) =>
          Stack(alignment: alignment, children: [...previous, ?current]),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween(begin: scale, end: 1.0).animate(animation),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
