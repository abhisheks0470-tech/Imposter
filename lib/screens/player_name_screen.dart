import 'package:flutter/material.dart';

import '../localization/app_language.dart';
import '../models/game_setup_data.dart';
import 'player_reveal_screen.dart';
import '../theme/app_colors.dart';
import '../widgets/app_background.dart';

class PlayerNameScreen extends StatefulWidget {
  const PlayerNameScreen({required this.setupData, super.key});

  final GameSetupData setupData;

  @override
  State<PlayerNameScreen> createState() => _PlayerNameScreenState();
}

class _PlayerNameScreenState extends State<PlayerNameScreen> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  AppLanguage get _language => widget.setupData.language;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.setupData.playersCount,
      (_) => TextEditingController(),
    );
    _focusNodes = List.generate(
      widget.setupData.playersCount,
      (_) => FocusNode(),
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const Positioned.fill(child: AppBackground()),
          Positioned.fill(
            child: CustomPaint(painter: const _NameGlowPainter()),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final horizontalPadding = width < 380 ? 16.0 : 24.0;

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        14,
                        horizontalPadding,
                        24 + MediaQuery.viewInsetsOf(context).bottom,
                      ),
                      child: Column(
                        children: [
                          _NameHeader(language: _language),
                          const SizedBox(height: 22),
                          _NameHero(language: _language),
                          const SizedBox(height: 20),
                          _QuickModeCard(
                            language: _language,
                            onUseDefaults: _fillDefaultNames,
                          ),
                          const SizedBox(height: 14),
                          for (var i = 0; i < _controllers.length; i++) ...[
                            _PlayerNameField(
                              index: i,
                              controller: _controllers[i],
                              focusNode: _focusNodes[i],
                              hintText: _defaultName(i),
                            ),
                            const SizedBox(height: 12),
                          ],
                          const SizedBox(height: 12),
                          _StartRevealButton(
                            label: _t(
                              _language,
                              hi: 'रिवील शुरू करें',
                              en: 'Start Reveal',
                            ),
                            onTap: _startReveal,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _defaultName(int index) {
    return _t(_language, hi: 'प्लेयर ${index + 1}', en: 'Player ${index + 1}');
  }

  void _fillDefaultNames() {
    setState(() {
      for (var i = 0; i < _controllers.length; i++) {
        _controllers[i].text = _defaultName(i);
      }
    });
  }

  void _startReveal() {
    final names = <String>[];
    for (var i = 0; i < _controllers.length; i++) {
      final name = _controllers[i].text.trim();
      names.add(name.isEmpty ? _defaultName(i) : name);
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PlayerRevealScreen(
          revealData: PlayerRevealData(
            setup: widget.setupData,
            playerNames: names,
          ),
        ),
      ),
    );
  }
}

String _t(AppLanguage language, {required String hi, required String en}) {
  return AppStrings.pick(language, hi: hi, en: en);
}

class _NameHeader extends StatelessWidget {
  const _NameHeader({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _RoundBackButton(onTap: () => Navigator.of(context).pop()),
        const SizedBox(width: 18),
        Expanded(
          child: _StepIndicator(
            currentStep: 2,
            labels: [
              _t(language, hi: 'सेटअप', en: 'Setup'),
              _t(language, hi: 'खिलाड़ी', en: 'Players'),
              _t(language, hi: 'खेल शुरू', en: 'Start'),
            ],
          ),
        ),
      ],
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep, required this.labels});

  final int currentStep;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            left: 44,
            right: 44,
            top: 24,
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF2AD843),
                    AppColors.hindiGold,
                    Color(0xFF56138E),
                  ],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < labels.length; i++)
                _StepDot(
                  number: i + 1,
                  label: labels[i],
                  active: i + 1 == currentStep,
                  complete: i + 1 < currentStep,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.number,
    required this.label,
    required this.active,
    required this.complete,
  });

  final int number;
  final String label;
  final bool active;
  final bool complete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: active
                    ? const RadialGradient(
                        colors: [Color(0xFFFFEE5D), Color(0xFFFF8D00)],
                      )
                    : complete
                    ? const RadialGradient(
                        colors: [Color(0xFF55F04A), Color(0xFF108A22)],
                      )
                    : const RadialGradient(
                        colors: [Color(0xFF3F145D), Color(0xFF130526)],
                      ),
                border: Border.all(
                  color: active || complete
                      ? AppColors.hindiGold
                      : AppColors.purpleBorder,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: active || complete
                        ? const Color(0xCCFFCE00)
                        : AppColors.purpleShadow,
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '$number',
                  style: TextStyle(
                    color: active ? const Color(0xFF200018) : Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            if (complete)
              const Positioned(
                right: -2,
                bottom: -2,
                child: Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF72FF72),
                  size: 22,
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: active ? AppColors.hindiGold : const Color(0xFFC8B4E8),
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _NameHero extends StatelessWidget {
  const _NameHero({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomPaint(
          painter: const _ClipboardSpyPainter(),
          size: const Size(126, 146),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Stack(
                  children: [
                    Text(
                      _t(language, hi: 'प्लेयर नाम', en: 'Player Names'),
                      style: TextStyle(
                        fontSize: 43,
                        fontWeight: FontWeight.w900,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 6
                          ..color = const Color(0xFF1A0025),
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Colors.white,
                          Color(0xFFE9E2FF),
                          AppColors.hindiGold,
                        ],
                      ).createShader(bounds),
                      child: Text(
                        _t(language, hi: 'प्लेयर नाम', en: 'Player Names'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 43,
                          fontWeight: FontWeight.w900,
                          shadows: [
                            Shadow(
                              color: Color(0xAA000000),
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _t(
                  language,
                  hi: 'सभी खिलाड़ियों के नाम जोड़ें',
                  en: 'Add names for all players',
                ),
                style: const TextStyle(
                  color: Color(0xFFD3B7F3),
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickModeCard extends StatelessWidget {
  const _QuickModeCard({required this.language, required this.onUseDefaults});

  final AppLanguage language;
  final VoidCallback onUseDefaults;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xD50A092A),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF65309C), width: 1.8),
        boxShadow: const [
          BoxShadow(color: Color(0x66000000), offset: Offset(0, 8)),
          BoxShadow(color: Color(0x665A15B8), blurRadius: 18),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _PurpleActionButton(
              key: const ValueKey('use_default_names'),
              icon: Icons.casino_rounded,
              label: _t(
                language,
                hi: 'डिफॉल्ट नाम इस्तेमाल करें',
                en: 'Use Default Names',
              ),
              onTap: onUseDefaults,
            ),
          ),
        ],
      ),
    );
  }
}

class _PurpleActionButton extends StatelessWidget {
  const _PurpleActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFFC335FF), Color(0xFF6711B5)],
            ),
            border: Border.all(color: const Color(0xFFEA78FF), width: 2),
            boxShadow: const [
              BoxShadow(color: Color(0xAAAB2AFF), blurRadius: 14),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 30),
              const SizedBox(width: 10),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayerNameField extends StatelessWidget {
  const _PlayerNameField({
    required this.index,
    required this.controller,
    required this.focusNode,
    required this.hintText,
  });

  final int index;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xD50A092A),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF65309C), width: 1.8),
        boxShadow: const [
          BoxShadow(color: Color(0x66000000), offset: Offset(0, 7)),
          BoxShadow(color: Color(0x664C18A6), blurRadius: 16),
        ],
      ),
      child: Row(
        children: [
          _IndexBadge(number: index + 1),
          const SizedBox(width: 12),
          _AvatarDisc(index: index),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              key: ValueKey('player_name_${index + 1}'),
              controller: controller,
              focusNode: focusNode,
              textInputAction: TextInputAction.next,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w900,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.45),
                  fontWeight: FontWeight.w800,
                ),
                filled: true,
                fillColor: const Color(0xBB050019),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(
                    color: Color(0xFF63309B),
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(
                    color: AppColors.magentaGlow,
                    width: 2.4,
                  ),
                ),
              ),
              onSubmitted: (_) => FocusScope.of(context).nextFocus(),
            ),
          ),
          const SizedBox(width: 10),
          Material(
            color: Colors.transparent,
            child: InkWell(
              key: ValueKey('edit_player_${index + 1}'),
              borderRadius: BorderRadius.circular(14),
              onTap: () => focusNode.requestFocus(),
              child: Ink(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFC335FF), Color(0xFF6711B5)],
                  ),
                  border: Border.all(color: const Color(0xFFEA78FF), width: 2),
                  boxShadow: const [
                    BoxShadow(color: Color(0xAA922AFF), blurRadius: 12),
                  ],
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  color: Colors.white,
                  size: 29,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IndexBadge extends StatelessWidget {
  const _IndexBadge({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFF4E1B90), Color(0xFF14002E)],
        ),
        border: Border.all(color: AppColors.purpleBorder, width: 2),
        boxShadow: const [
          BoxShadow(color: AppColors.purpleShadow, blurRadius: 12),
        ],
      ),
      child: Center(
        child: Text(
          '$number',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _AvatarDisc extends StatelessWidget {
  const _AvatarDisc({required this.index});

  final int index;

  static const _colors = [
    [Color(0xFFFF2DAE), Color(0xFF18001F)],
    [Color(0xFFFF1D77), Color(0xFF4E0628)],
    [Color(0xFF00D7FF), Color(0xFF06225C)],
    [Color(0xFFFFD13D), Color(0xFF511500)],
    [Color(0xFF52F04B), Color(0xFF073B10)],
    [Color(0xFFE954FF), Color(0xFF27003D)],
  ];

  @override
  Widget build(BuildContext context) {
    final colors = _colors[index % _colors.length];

    return CustomPaint(
      painter: _AvatarPainter(colors: colors),
      size: const Size(62, 62),
    );
  }
}

class _StartRevealButton extends StatefulWidget {
  const _StartRevealButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_StartRevealButton> createState() => _StartRevealButtonState();
}

class _StartRevealButtonState extends State<_StartRevealButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 90),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: widget.onTap,
            child: Ink(
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFFF04A),
                    Color(0xFFFFBB1A),
                    Color(0xFFFF8D00),
                  ],
                ),
                border: Border.all(color: AppColors.startBorder, width: 2.5),
                boxShadow: const [
                  BoxShadow(color: Color(0xCCFF9D00), blurRadius: 20),
                  BoxShadow(color: Color(0x99000000), offset: Offset(0, 8)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.visibility_rounded,
                    color: Color(0xFF4A0030),
                    size: 36,
                  ),
                  const SizedBox(width: 14),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.label,
                        style: const TextStyle(
                          color: Color(0xFF6A2100),
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFF6A2100),
                    size: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundBackButton extends StatelessWidget {
  const _RoundBackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Ink(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [Color(0xFF6B21D7), Color(0xFF190038)],
            ),
            border: Border.all(color: const Color(0xFFB52DFF), width: 2),
            boxShadow: const [
              BoxShadow(color: Color(0xCC8424FF), blurRadius: 16),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 34,
          ),
        ),
      ),
    );
  }
}

class _NameGlowPainter extends CustomPainter {
  const _NameGlowPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final glow = Paint()
      ..color = const Color(0x332E0C90)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22);
    canvas.drawCircle(Offset(size.width * 0.22, size.height * 0.22), 82, glow);
    canvas.drawCircle(Offset(size.width * 0.83, size.height * 0.42), 95, glow);

    final markStyle = TextStyle(
      color: const Color(0xFF6D20C4).withValues(alpha: 0.16),
      fontSize: 52,
      fontWeight: FontWeight.w900,
    );
    for (final point in [
      const Offset(0.08, 0.18),
      const Offset(0.61, 0.12),
      const Offset(0.89, 0.2),
      const Offset(0.91, 0.34),
    ]) {
      final painter = TextPainter(
        text: TextSpan(text: '?', style: markStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(
        canvas,
        Offset(point.dx * size.width, point.dy * size.height),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ClipboardSpyPainter extends CustomPainter {
  const _ClipboardSpyPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final hoodPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF5B18B9), Color(0xFF110020)],
      ).createShader(Offset.zero & size);
    final outline = Paint()
      ..color = AppColors.blackOutline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeJoin = StrokeJoin.round;

    final hood = Path()
      ..moveTo(size.width * 0.14, size.height * 0.9)
      ..quadraticBezierTo(
        size.width * 0.08,
        size.height * 0.2,
        size.width * 0.5,
        size.height * 0.06,
      )
      ..quadraticBezierTo(
        size.width * 0.88,
        size.height * 0.22,
        size.width * 0.78,
        size.height * 0.9,
      )
      ..close();
    canvas.drawPath(hood, outline);
    canvas.drawPath(hood, hoodPaint);

    final faceCenter = Offset(size.width * 0.48, size.height * 0.33);
    canvas.drawCircle(
      faceCenter,
      size.width * 0.21,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(faceCenter, size.width * 0.21, outline);
    final eyePaint = Paint()..color = AppColors.blackOutline;
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.34, size.height * 0.29)
        ..quadraticBezierTo(
          size.width * 0.45,
          size.height * 0.35,
          size.width * 0.5,
          size.height * 0.28,
        )
        ..quadraticBezierTo(
          size.width * 0.41,
          size.height * 0.26,
          size.width * 0.34,
          size.height * 0.29,
        ),
      eyePaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.63, size.height * 0.29)
        ..quadraticBezierTo(
          size.width * 0.53,
          size.height * 0.35,
          size.width * 0.48,
          size.height * 0.28,
        )
        ..quadraticBezierTo(
          size.width * 0.57,
          size.height * 0.26,
          size.width * 0.63,
          size.height * 0.29,
        ),
      eyePaint,
    );

    final board = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.24,
        size.height * 0.5,
        size.width * 0.34,
        size.height * 0.32,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(board, Paint()..color = const Color(0xFF6A321A));
    canvas.drawRRect(board, outline);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.31,
          size.height * 0.47,
          size.width * 0.2,
          size.height * 0.08,
        ),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFFC9A26F),
    );

    final pencil = Paint()
      ..color = AppColors.hindiGold
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.73, size.height * 0.46),
      Offset(size.width * 0.72, size.height * 0.72),
      pencil,
    );
    canvas.drawLine(
      Offset(size.width * 0.73, size.height * 0.46),
      Offset(size.width * 0.72, size.height * 0.72),
      outline..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AvatarPainter extends CustomPainter {
  const _AvatarPainter({required this.colors});

  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawCircle(
      rect.center,
      size.width / 2,
      Paint()..shader = RadialGradient(colors: colors).createShader(rect),
    );
    canvas.drawCircle(
      rect.center,
      size.width / 2 - 1,
      Paint()
        ..color = colors.first
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawCircle(
      rect.center,
      size.width * 0.29,
      Paint()..color = const Color(0xFF07001D),
    );

    final eyePaint = Paint()
      ..color = Colors.white
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.41, size.height * 0.47),
        width: size.width * 0.18,
        height: size.height * 0.09,
      ),
      eyePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.59, size.height * 0.47),
        width: size.width * 0.18,
        height: size.height * 0.09,
      ),
      eyePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _AvatarPainter oldDelegate) {
    return oldDelegate.colors != colors;
  }
}
