import 'dart:math';

import 'package:flutter/material.dart';

/// A short burst of falling paper bits for celebrations.
class Confetti extends StatefulWidget {
  const Confetti({super.key});

  @override
  State<Confetti> createState() => _ConfettiState();
}

class _Piece {
  _Piece(Random random)
      : x = random.nextDouble(),
        delay = random.nextDouble() * 0.4,
        speed = 0.6 + random.nextDouble() * 0.5,
        spin = random.nextDouble() * 6,
        size = 6 + random.nextDouble() * 8,
        color = Colors.primaries[random.nextInt(Colors.primaries.length)];

  final double x;
  final double delay;
  final double speed;
  final double spin;
  final double size;
  final Color color;
}

class _ConfettiState extends State<Confetti>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..forward();

  late final List<_Piece> _pieces = () {
    final random = Random();
    return [for (var i = 0; i < 60; i++) _Piece(random)];
  }();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          size: Size.infinite,
          painter: _ConfettiPainter(_pieces, _controller.value),
        ),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.pieces, this.progress);

  final List<_Piece> pieces;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    for (final piece in pieces) {
      final t = ((progress - piece.delay) / (1 - piece.delay)).clamp(0.0, 1.0);
      if (t == 0 || t == 1) continue;
      final y = -20 + (size.height + 40) * t * piece.speed;
      final x = piece.x * size.width + sin(t * 8 + piece.spin) * 20;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(t * piece.spin * 3);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: piece.size,
          height: piece.size * 0.6,
        ),
        Paint()..color = piece.color.withValues(alpha: 1 - t * 0.5),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
