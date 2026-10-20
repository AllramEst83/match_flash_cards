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
  });

  final AnswerOption option;
  final Color color;
  final TileState state;
  final VoidCallback onTap;

  @override
  State<AnswerTile> createState() => _AnswerTileState();
}

class _AnswerTileState extends State<AnswerTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (widget.state) {
      TileState.idle => (widget.color, Colors.white),
      TileState.wrong => (Colors.grey.shade300, Colors.grey.shade600),
      TileState.correct => (Colors.green.shade400, Colors.white),
    };

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return switch (widget.state) {
          TileState.wrong => Transform.translate(
              offset: Offset(sin(t * pi * 4) * 8 * (1 - t), 0),
              child: child,
            ),
          TileState.correct => Transform.scale(
              scale: 1 + 0.08 * sin(t * pi),
              child: child,
            ),
          TileState.idle => child!,
        };
      },
      child: Material(
        color: background,
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
              textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
