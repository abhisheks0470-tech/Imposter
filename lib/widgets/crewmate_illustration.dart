import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CrewmateIllustration extends StatelessWidget {
  const CrewmateIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Positioned(top: h * 0.01, child: const _NeonQuestionMark(size: 92)),
            Positioned(
              top: h * 0.19,
              left: w * 0.01,
              child: const _SpeechBubble(
                text: 'संकेत',
                color: Color(0xFF2433A6),
                glow: AppColors.cyanGlow,
                angle: -0.18,
              ),
            ),
            Positioned(
              top: h * 0.17,
              right: w * 0.00,
              child: const _SpeechBubble(
                text: 'इम्पोस्टर\nकौन?',
                color: Color(0xFF6816A8),
                glow: AppColors.magentaGlow,
                angle: 0.18,
              ),
            ),
            Positioned.fill(
              top: h * 0.13,
              child: CustomPaint(painter: _HeroRaysPainter()),
            ),
            Positioned(
              top: h * 0.35,
              left: w * 0.00,
              child: _Crewmate(
                width: w * 0.32,
                bodyColor: AppColors.blueCrewmate,
                shadowColor: AppColors.blueCrewmateShadow,
                lean: -0.13,
              ),
            ),
            Positioned(
              top: h * 0.35,
              right: w * 0.00,
              child: _Crewmate(
                width: w * 0.32,
                bodyColor: AppColors.yellowCrewmate,
                shadowColor: AppColors.yellowCrewmateShadow,
                lean: 0.13,
              ),
            ),
            Positioned(
              top: h * 0.15,
              child: _Crewmate(
                width: w * 0.48,
                bodyColor: AppColors.redCrewmate,
                shadowColor: AppColors.redCrewmateShadow,
                center: true,
              ),
            ),
            Positioned(top: h * 0.29, child: const _QuietFinger()),
            Positioned(
              top: h * 0.49,
              left: 0,
              right: 0,
              child: const _TitleStack(),
            ),
            Positioned(
              top: h * 0.71,
              left: w * 0.04,
              right: w * 0.04,
              child: const _TaglinePlate(),
            ),
            Positioned(top: h * 0.81, child: const _MagnifierBadge()),
          ],
        );
      },
    );
  }
}

class _TitleStack extends StatelessWidget {
  const _TitleStack();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [_HindiTitle(), SizedBox(height: 4), _ImposterTitle()],
    );
  }
}

class _HindiTitle extends StatelessWidget {
  const _HindiTitle();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          'हिंदी',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 86,
            height: 0.9,
            fontWeight: FontWeight.w900,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 11
              ..color = const Color(0xFF170021),
          ),
        ),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.hindiGold,
              AppColors.hindiOrange,
              AppColors.hindiRedOrange,
            ],
          ).createShader(bounds),
          child: const Text(
            'हिंदी',
            textAlign: TextAlign.center,
            style: AppTextStyles.hindiTitleFill,
          ),
        ),
      ],
    );
  }
}

class _ImposterTitle extends StatelessWidget {
  const _ImposterTitle();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 7, 16, 9),
      decoration: BoxDecoration(
        color: AppColors.plate,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.purpleBorder, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0xCC000000),
            offset: Offset(0, 9),
            blurRadius: 0,
          ),
          BoxShadow(color: AppColors.purpleShadow, blurRadius: 26),
        ],
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              'IMPOSTER',
              style: TextStyle(
                fontSize: 56,
                height: 0.95,
                fontWeight: FontWeight.w900,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 8
                  ..color = AppColors.titleStrokePurple,
              ),
            ),
            const Text('IMPOSTER', style: AppTextStyles.imposterTitleFill),
          ],
        ),
      ),
    );
  }
}

class _TaglinePlate extends StatelessWidget {
  const _TaglinePlate();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.plateDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.purpleBorderDark, width: 2.5),
        boxShadow: const [
          BoxShadow(color: Color(0xAA000000), offset: Offset(0, 8)),
        ],
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: RichText(
          text: const TextSpan(
            style: AppTextStyles.tagline,
            children: [
              TextSpan(
                text: 'शब्द बताओ, ',
                style: TextStyle(color: AppColors.taglineGold),
              ),
              TextSpan(
                text: 'इम्पोस्टर पहचानो!',
                style: TextStyle(color: AppColors.taglineCyan),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpeechBubble extends StatelessWidget {
  const _SpeechBubble({
    required this.text,
    required this.color,
    required this.glow,
    required this.angle,
  });

  final String text;
  final Color color;
  final Color glow;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: CustomPaint(
        painter: _SpeechBubblePainter(color: color, glow: glow),
        child: SizedBox(
          width: 130,
          height: 86,
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: AppTextStyles.speechBubble,
            ),
          ),
        ),
      ),
    );
  }
}

class _SpeechBubblePainter extends CustomPainter {
  const _SpeechBubblePainter({required this.color, required this.glow});

  final Color color;
  final Color glow;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.18, size.height * 0.06)
      ..quadraticBezierTo(
        size.width * 0.02,
        size.height * 0.08,
        8,
        size.height * 0.28,
      )
      ..lineTo(8, size.height * 0.57)
      ..quadraticBezierTo(
        size.width * 0.08,
        size.height * 0.82,
        size.width * 0.32,
        size.height * 0.78,
      )
      ..lineTo(size.width * 0.54, size.height * 0.97)
      ..lineTo(size.width * 0.56, size.height * 0.75)
      ..lineTo(size.width * 0.78, size.height * 0.68)
      ..quadraticBezierTo(
        size.width * 0.98,
        size.height * 0.62,
        size.width * 0.94,
        size.height * 0.36,
      )
      ..quadraticBezierTo(
        size.width * 0.91,
        size.height * 0.09,
        size.width * 0.68,
        size.height * 0.05,
      )
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..color = glow
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = glow
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(covariant _SpeechBubblePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.glow != glow;
  }
}

class _Crewmate extends StatelessWidget {
  const _Crewmate({
    required this.width,
    required this.bodyColor,
    required this.shadowColor,
    this.lean = 0,
    this.center = false,
  });

  final double width;
  final Color bodyColor;
  final Color shadowColor;
  final double lean;
  final bool center;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: lean,
      child: CustomPaint(
        painter: _CrewmatePainter(
          bodyColor: bodyColor,
          shadowColor: shadowColor,
          center: center,
        ),
        size: Size(width, width * 1.5),
      ),
    );
  }
}

class _CrewmatePainter extends CustomPainter {
  const _CrewmatePainter({
    required this.bodyColor,
    required this.shadowColor,
    required this.center,
  });

  final Color bodyColor;
  final Color shadowColor;
  final bool center;

  @override
  void paint(Canvas canvas, Size size) {
    final outline = Paint()
      ..color = AppColors.blackOutline
      ..style = PaintingStyle.stroke
      ..strokeWidth = center ? 8 : 6
      ..strokeJoin = StrokeJoin.round;
    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [bodyColor.withValues(alpha: 0.96), shadowColor],
      ).createShader(Offset.zero & size);

    final body = RRect.fromRectAndCorners(
      Rect.fromLTWH(size.width * 0.16, 0, size.width * 0.68, size.height * 0.9),
      topLeft: Radius.circular(size.width * 0.34),
      topRight: Radius.circular(size.width * 0.34),
      bottomLeft: Radius.circular(size.width * 0.13),
      bottomRight: Radius.circular(size.width * 0.13),
    );
    canvas.drawRRect(body, outline);
    canvas.drawRRect(body, bodyPaint);

    final visor = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.23,
        size.height * 0.18,
        size.width * 0.54,
        size.height * 0.22,
      ),
      Radius.circular(size.width * 0.18),
    );
    canvas.drawRRect(
      visor,
      Paint()
        ..color = AppColors.visorOutline
        ..style = PaintingStyle.stroke
        ..strokeWidth = center ? 10 : 7,
    );
    canvas.drawRRect(
      visor,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.visorTop, AppColors.visorBottom],
        ).createShader(visor.outerRect),
    );
    canvas.drawOval(
      Rect.fromLTWH(
        size.width * 0.31,
        size.height * 0.21,
        size.width * 0.18,
        size.height * 0.07,
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.86),
    );

    if (!center) {
      final footPaint = Paint()..color = shadowColor;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            size.width * 0.23,
            size.height * 0.72,
            size.width * 0.22,
            size.height * 0.22,
          ),
          Radius.circular(size.width * 0.09),
        ),
        footPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            size.width * 0.55,
            size.height * 0.72,
            size.width * 0.22,
            size.height * 0.22,
          ),
          Radius.circular(size.width * 0.09),
        ),
        footPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CrewmatePainter oldDelegate) {
    return oldDelegate.bodyColor != bodyColor ||
        oldDelegate.shadowColor != shadowColor ||
        oldDelegate.center != center;
  }
}

class _QuietFinger extends StatelessWidget {
  const _QuietFinger();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const _QuietFingerPainter(),
      size: const Size(82, 150),
    );
  }
}

class _QuietFingerPainter extends CustomPainter {
  const _QuietFingerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final red = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFF4554), Color(0xFFC00018)],
      ).createShader(Offset.zero & size);
    final outline = Paint()
      ..color = AppColors.blackOutline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final finger = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.38,
        2,
        size.width * 0.25,
        size.height * 0.68,
      ),
      Radius.circular(size.width * 0.12),
    );
    canvas.drawRRect(finger, outline);
    canvas.drawRRect(finger, red);

    final palm = Path()
      ..moveTo(size.width * 0.26, size.height * 0.62)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.44,
        size.width * 0.75,
        size.height * 0.61,
      )
      ..quadraticBezierTo(
        size.width * 0.65,
        size.height * 0.92,
        size.width * 0.38,
        size.height * 0.94,
      )
      ..quadraticBezierTo(
        size.width * 0.15,
        size.height * 0.88,
        size.width * 0.26,
        size.height * 0.62,
      )
      ..close();
    canvas.drawPath(palm, outline);
    canvas.drawPath(palm, red);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NeonQuestionMark extends StatelessWidget {
  const _NeonQuestionMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      '?',
      style: TextStyle(
        color: Colors.white,
        fontSize: size,
        height: 1,
        fontWeight: FontWeight.w700,
        shadows: const [
          Shadow(color: AppColors.neonPink, blurRadius: 7),
          Shadow(color: AppColors.neonPink, blurRadius: 17),
          Shadow(color: AppColors.neonPink, blurRadius: 28),
        ],
      ),
    );
  }
}

class _MagnifierBadge extends StatelessWidget {
  const _MagnifierBadge();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: 82,
          height: 82,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [Color(0xFFFF4FF2), Color(0xFF7023FF), Color(0xFF12002F)],
            ),
            border: Border.all(color: const Color(0xFF43F4FF), width: 4),
            boxShadow: const [
              BoxShadow(color: Color(0xAA8625FF), blurRadius: 24),
              BoxShadow(color: Color(0xAA000000), offset: Offset(0, 7)),
            ],
          ),
          child: const Center(
            child: Text(
              '?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 44,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        Positioned(
          right: -19,
          bottom: -21,
          child: Transform.rotate(
            angle: -0.78,
            child: Container(
              width: 16,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFF441C9C),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.blackOutline, width: 4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroRaysPainter extends CustomPainter {
  const _HeroRaysPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.56);
    final rayPaint = Paint()..color = const Color(0x332D12A2);
    for (var i = 0; i < 18; i++) {
      final angle = -math.pi + (math.pi * 2 / 18) * i;
      final left =
          center +
          Offset(math.cos(angle - 0.035), math.sin(angle - 0.035)) * 26;
      final right =
          center +
          Offset(math.cos(angle + 0.035), math.sin(angle + 0.035)) * 26;
      final tip =
          center + Offset(math.cos(angle), math.sin(angle)) * size.height;
      canvas.drawPath(
        Path()
          ..moveTo(left.dx, left.dy)
          ..lineTo(tip.dx, tip.dy)
          ..lineTo(right.dx, right.dy)
          ..close(),
        rayPaint,
      );
    }

    canvas.drawCircle(
      center,
      size.width * 0.38,
      Paint()
        ..color = const Color(0x55120037)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
