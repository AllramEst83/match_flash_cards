import 'dart:math';

import 'package:flutter/material.dart';

import '../../logic/study_session.dart';
import 'option_content.dart';

enum TileState { idle, wrong, correct }

class AnswerTile extends StatefulWidget {
  const AnswerTile({
    super.key,
    required this.option,
    required this.color,
    required this.state,
    required this.onTap,
    this.index = 0,
    this.fontSize = 22,
    this.textAlign = TextAlign.center,
  });

  final AnswerOption option;
  final Color color;
  final TileState state;
  final VoidCallback onTap;

  /// Position in the list, used to stagger the entrance.
  final int index;
  final double fontSize;
  final TextAlign textAlign;

  @override
  State<AnswerTile> createState() => _AnswerTileState();
}

class _AnswerTileState extends State<AnswerTile>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  );

  static const _stagger = 80;
  static const _entranceMs = 420;

  late final AnimationController _enter = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: _entranceMs + widget.index * _stagger),
  )..forward();

  late final Animation<double> _entrance = CurvedAnimation(
    parent: _enter,
    curve: Interval(
      widget.index * _stagger / (_entranceMs + widget.index * _stagger),
      1,
      curve: Curves.easeOutCubic,
    ),
  );

  @override
  void didUpdateWidget(AnswerTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state != oldWidget.state && widget.state != TileState.idle) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _enter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (widget.state) {
      TileState.idle => (widget.color, Colors.white),
      TileState.wrong => (Colors.red.shade800, Colors.white),
      TileState.correct => (Colors.green.shade800, Colors.white),
    };

    return FadeTransition(
      opacity: _entrance,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.25),
          end: Offset.zero,
        ).animate(_entrance),
        child: _animated(context, background, foreground),
      ),
    );
  }

  Widget _animated(BuildContext context, Color background, Color foreground) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return switch (widget.state) {
          // A firm side-to-side shake that dies out.
          TileState.wrong => Transform.translate(
            offset: Offset(sin(t * pi * 6) * 14 * (1 - t), 0),
            child: child,
          ),
          // Pops up with a springy overshoot, then settles.
          TileState.correct => Transform.scale(
            scale: 1 + 0.14 * sin(Curves.easeOut.transform(t) * pi),
            child: child,
          ),
          TileState.idle => child!,
        };
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: widget.state == TileState.correct
              ? [
                  BoxShadow(
                    color: Colors.green.shade600.withValues(alpha: 0.7),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ]
              : const [],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _tile(context, background, foreground),
            if (widget.state != TileState.idle)
              Positioned(
                top: -10,
                right: -6,
                child: _Badge(correct: widget.state == TileState.correct),
              ),
          ],
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, Color background, Color foreground) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: widget.onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 72),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: OptionContent(
              option: widget.option,
              imageHeight: 90,
              textAlign: widget.textAlign,
              textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: foreground,
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The check or cross that pops onto a tile that was just answered.
class _Badge extends StatelessWidget {
  const _Badge({required this.correct});

  final bool correct;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 450),
      curve: Curves.elasticOut,
      builder: (context, value, child) =>
          Transform.scale(scale: value, child: child),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: correct ? Colors.green.shade800 : Colors.red.shade800,
            width: 3,
          ),
        ),
        child: Icon(
          correct ? Icons.check_rounded : Icons.close_rounded,
          size: 28,
          color: correct ? Colors.green.shade800 : Colors.red.shade800,
        ),
      ),
    );
  }
}
