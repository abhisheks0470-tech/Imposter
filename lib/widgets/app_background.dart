import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.23),
          radius: 1.12,
          colors: [
            AppColors.backgroundPurple,
            AppColors.backgroundMid,
            AppColors.backgroundLow,
            AppColors.backgroundDeep,
          ],
          stops: [0, 0.38, 0.72, 1],
        ),
      ),
      child: CustomPaint(painter: _CosmicDetailsPainter()),
    );
  }
}

class _CosmicDetailsPainter extends CustomPainter {
  const _CosmicDetailsPainter();

  static const _dots = [
    Offset(0.08, 0.29),
    Offset(0.18, 0.19),
    Offset(0.28, 0.66),
    Offset(0.43, 0.18),
    Offset(0.59, 0.21),
    Offset(0.74, 0.67),
    Offset(0.91, 0.31),
    Offset(0.12, 0.78),
    Offset(0.81, 0.81),
  ];

  static const _confetti = [
    (Offset(0.06, 0.39), Color(0xFFFF2C93), -0.62),
    (Offset(0.92, 0.41), Color(0xFF25DDF0), 0.86),
    (Offset(0.14, 0.58), Color(0xFFFFD33A), -0.14),
    (Offset(0.86, 0.60), Color(0xFFFF574F), 0.42),
    (Offset(0.28, 0.35), Color(0xFF29E5B6), -0.46),
    (Offset(0.68, 0.35), Color(0xFFFFB22C), 0.38),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final starPaint = Paint()
      ..color = const Color(0xFFB62CFF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    for (final dot in _dots) {
      canvas.drawCircle(
        Offset(dot.dx * size.width, dot.dy * size.height),
        2.2,
        starPaint,
      );
    }

    final questionStyle = TextStyle(
      color: const Color(0x221B0082),
      fontSize: size.width * 0.17,
      fontWeight: FontWeight.w900,
    );
    for (final q in [
      const Offset(0.15, 0.16),
      const Offset(0.84, 0.16),
      const Offset(0.15, 0.76),
      const Offset(0.80, 0.76),
    ]) {
      final painter = TextPainter(
        text: TextSpan(text: '?', style: questionStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, Offset(q.dx * size.width, q.dy * size.height));
    }

    for (final item in _confetti) {
      final center = Offset(item.$1.dx * size.width, item.$1.dy * size.height);
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(item.$3);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(-5, -17, 10, 34),
          const Radius.circular(8),
        ),
        Paint()..color = item.$2,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
