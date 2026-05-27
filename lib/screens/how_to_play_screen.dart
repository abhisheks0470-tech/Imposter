import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'game_setup_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_background.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: AppBackground()),
          const Positioned.fill(child: _HindiLettersLayer()),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final horizontalPadding = width < 380 ? 16.0 : 24.0;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      10,
                      horizontalPadding,
                      24,
                    ),
                    child: Column(
                      children: [
                        const _IntroHeader(),
                        SizedBox(height: width < 380 ? 18 : 24),
                        const _IntroTitleBlock(),
                        SizedBox(height: width < 380 ? 18 : 24),
                        const _SpyHero(),
                        SizedBox(height: width < 380 ? 16 : 20),
                        const _RuleGrid(),
                        const SizedBox(height: 26),
                        _NextIntroButton(onTap: () => _openGameSetup(context)),
                        const SizedBox(height: 16),
                        const _PageDots(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 16),
                child: _MoreInfoButton(onTap: () => _openGameSetup(context)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void _openGameSetup(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const GameSetupScreen()));
  }
}

class _IntroHeader extends StatelessWidget {
  const _IntroHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RoundIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => Navigator.of(context).pop(),
        ),
        const Expanded(child: _MiniLogo()),
        _SkipButton(onTap: () => HowToPlayScreen._openGameSetup(context)),
      ],
    );
  }
}

class _MiniLogo extends StatelessWidget {
  const _MiniLogo();

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                height: 0.9,
                fontWeight: FontWeight.w900,
                shadows: [
                  Shadow(color: Color(0xAA000000), offset: Offset(0, 3)),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xDD10012C),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.purpleBorder, width: 1.5),
              boxShadow: const [
                BoxShadow(color: Color(0xAA284CFF), blurRadius: 16),
                BoxShadow(color: Color(0xAAFF39D7), blurRadius: 16),
              ],
            ),
            child: const Text(
              'IMPOSTER',
              style: TextStyle(
                color: AppColors.titleWhite,
                fontSize: 23,
                height: 0.9,
                fontWeight: FontWeight.w900,
                shadows: [
                  Shadow(
                    color: AppColors.titlePurpleShadow,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IntroTitleBlock extends StatelessWidget {
  const _IntroTitleBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                'कैसे खेलें?',
                style: TextStyle(
                  fontSize: 62,
                  height: 0.95,
                  fontWeight: FontWeight.w900,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 8
                    ..color = const Color(0xFF220020),
                ),
              ),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFFFFF072),
                    Color(0xFFFF9C18),
                    Color(0xFFFF72EA),
                    Color(0xFFFF34BE),
                  ],
                ).createShader(bounds),
                child: const Text(
                  'कैसे खेलें?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 62,
                    height: 0.95,
                    fontWeight: FontWeight.w900,
                    shadows: [
                      Shadow(
                        color: Color(0xCCFF25CD),
                        offset: Offset(0, 5),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: RichText(
            text: const TextSpan(
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
              children: [
                TextSpan(
                  text: 'शब्द',
                  style: TextStyle(color: AppColors.taglineGold),
                ),
                TextSpan(text: ' बताओ, '),
                TextSpan(
                  text: 'इम्पोस्टर',
                  style: TextStyle(color: AppColors.taglineCyan),
                ),
                TextSpan(text: ' पहचानो!'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 170,
          height: 2,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                AppColors.cyanGlow,
                AppColors.magentaGlow,
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SpyHero extends StatelessWidget {
  const _SpyHero();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final heroWidth = math.min(width * 0.8, 330.0);

        return SizedBox(
          height: heroWidth * 0.94,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(painter: const _HeroGlowPainter()),
              ),
              Positioned(
                top: 4,
                left: 10,
                child: const _BubbleLabel(text: 'संकेत\n...', angle: -0.18),
              ),
              Positioned(
                top: 10,
                right: 12,
                child: const _BubbleLabel(text: 'शब्द\n...', angle: 0.16),
              ),
              CustomPaint(
                painter: const _SpyPainter(),
                size: Size(heroWidth, heroWidth * 0.9),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RuleGrid extends StatelessWidget {
  const _RuleGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 340;
        final cards = const [
          _RuleCard(
            number: '1',
            title: 'सबको एक शब्द मिलेगा',
            highlightedTitle: 'शब्द',
            description: 'सभी खिलाड़ियों को\nएक जैसा शब्द मिलेगा।',
            child: _WordPreview(),
          ),
          _RuleCard(
            number: '2',
            title: 'एक खिलाड़ी\nइम्पोस्टर होगा',
            highlightedTitle: 'इम्पोस्टर',
            description:
                'इम्पोस्टर को कोई शब्द\nनहीं मिलेगा।\nवह अंदाज़े से खेलेगा!',
            child: _ImposterPreview(),
          ),
          _RuleCard(
            number: '3',
            title: 'संकेत दो,\nनाम मत बोलो',
            highlightedTitle: 'नाम मत बोलो',
            description:
                'शब्द का संकेत दो,\nलेकिन शब्द या उसके\nहिस्से का नाम मत लो।',
            child: _HintsPreview(),
          ),
          _RuleCard(
            number: '4',
            title: 'वोट करके\nइम्पोस्टर पहचानो',
            highlightedTitle: 'इम्पोस्टर',
            description:
                'चर्चा करो, सोचो और\nजिसे इम्पोस्टर समझो,\nउसे वोट करो!',
            child: _VotePreview(),
          ),
        ];

        if (isNarrow) {
          return Column(
            children: [
              for (final card in cards) ...[card, const SizedBox(height: 14)],
            ],
          );
        }

        return GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.04,
          children: cards,
        );
      },
    );
  }
}

class _RuleCard extends StatelessWidget {
  const _RuleCard({
    required this.number,
    required this.title,
    required this.highlightedTitle,
    required this.description,
    required this.child,
  });

  final String number;
  final String title;
  final String highlightedTitle;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final titleParts = title.split(highlightedTitle);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xD50A092A),
        border: Border.all(color: const Color(0xFF904BFF), width: 1.6),
        boxShadow: const [
          BoxShadow(color: Color(0xAA7F22FF), blurRadius: 12),
          BoxShadow(color: Color(0x99000000), offset: Offset(0, 6)),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 220;
          final badgeSize = compact ? 42.0 : 48.0;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NumberBadge(number: number, size: badgeSize),
              SizedBox(width: compact ? 8 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: compact ? 17 : 22,
                          height: 1.1,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Roboto',
                        ),
                        children: [
                          TextSpan(text: titleParts.first),
                          TextSpan(
                            text: highlightedTitle,
                            style: const TextStyle(
                              color: AppColors.taglineGold,
                            ),
                          ),
                          if (titleParts.length > 1)
                            TextSpan(
                              text: titleParts
                                  .sublist(1)
                                  .join(highlightedTitle),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.74),
                        fontSize: compact ? 12 : 16,
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Flexible(child: child),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NumberBadge extends StatelessWidget {
  const _NumberBadge({required this.number, required this.size});

  final String number;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFFBC42FF), Color(0xFF45138B), Color(0xFF14002E)],
        ),
        border: Border.all(color: const Color(0xFFD85DFF), width: 2),
        boxShadow: const [BoxShadow(color: Color(0xCCB02BFF), blurRadius: 16)],
      ),
      child: Center(
        child: Text(
          number,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _NextIntroButton extends StatefulWidget {
  const _NextIntroButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_NextIntroButton> createState() => _NextIntroButtonState();
}

class _NextIntroButtonState extends State<_NextIntroButton> {
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
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
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
                      Color(0xFF043AD8),
                      Color(0xFF2632D9),
                      Color(0xFF9E22FF),
                      Color(0xFFFF33D2),
                    ],
                  ),
                  border: Border.all(
                    color: const Color(0xFF58E9FF),
                    width: 2.5,
                  ),
                  boxShadow: const [
                    BoxShadow(color: Color(0xAA25DFFF), blurRadius: 22),
                    BoxShadow(color: Color(0xBBFF32E5), blurRadius: 22),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'आगे बढ़ें',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        shadows: [
                          Shadow(
                            color: Color(0xAA000000),
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(
                      Icons.keyboard_double_arrow_right_rounded,
                      color: Color(0xFFB9A0FF),
                      size: 42,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap});

  final IconData icon;
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
          child: Icon(icon, color: Colors.white, size: 34),
        ),
      ),
    );
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: const Color(0xA60A0927),
            border: Border.all(color: const Color(0xFFE936FF), width: 2),
            boxShadow: const [
              BoxShadow(color: Color(0xAA245CFF), blurRadius: 14),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'स्किप',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.keyboard_double_arrow_right_rounded,
                color: Color(0xFFB27BFF),
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < 4; i++)
          Container(
            width: i == 2 ? 15 : 13,
            height: i == 2 ? 15 : 13,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i == 2
                  ? const Color(0xFFFF2BFF)
                  : Colors.white.withValues(alpha: 0.42),
              boxShadow: i == 2
                  ? const [BoxShadow(color: Color(0xFFFF2BFF), blurRadius: 14)]
                  : null,
            ),
          ),
      ],
    );
  }
}

class _MoreInfoButton extends StatelessWidget {
  const _MoreInfoButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xB00C0627),
            border: Border.all(color: const Color(0xFF9546FF), width: 1.5),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.help_outline_rounded, color: Colors.white, size: 21),
              SizedBox(width: 8),
              Text(
                'और जानें',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WordPreview extends StatelessWidget {
  const _WordPreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [Color(0xFF08165B), Color(0xFF101064)],
            ),
            border: Border.all(color: const Color(0xFF4E8BFF), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 55,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Color(0xFF4E8BFF), width: 1.2),
                  ),
                ),
                child: const Text(
                  'शब्द',
                  style: TextStyle(
                    color: AppColors.taglineCyan,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'पहाड़',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.landscape_rounded,
                  color: Color(0xFF9CD8FF),
                  size: 32,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            5,
            (index) => Icon(
              Icons.person_rounded,
              color: index < 2
                  ? const Color(0xFF1E84FF)
                  : const Color(0xFF6C38FF),
              size: 28,
            ),
          ),
        ),
      ],
    );
  }
}

class _ImposterPreview extends StatelessWidget {
  const _ImposterPreview();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: CustomPaint(
        painter: const _ImposterPreviewPainter(),
        size: const Size(120, 78),
      ),
    );
  }
}

class _HintsPreview extends StatelessWidget {
  const _HintsPreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _SmallHintChip(text: 'ऊँचा है...', color: const Color(0xFF0E71C8)),
        const SizedBox(height: 6),
        _SmallHintChip(
          text: 'बर्फ पड़ती है...',
          color: const Color(0xFF7E12BB),
        ),
        const SizedBox(height: 6),
        _SmallHintChip(text: 'चोटी होती है...', color: const Color(0xFF9A5C03)),
      ],
    );
  }
}

class _SmallHintChip extends StatelessWidget {
  const _SmallHintChip({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: color.withValues(alpha: 1), width: 1.3),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _VotePreview extends StatelessWidget {
  const _VotePreview();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: CustomPaint(
        painter: const _VotePreviewPainter(),
        size: const Size(126, 88),
      ),
    );
  }
}

class _BubbleLabel extends StatelessWidget {
  const _BubbleLabel({required this.text, required this.angle});

  final String text;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: 108,
        height: 72,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0x77100130),
          border: Border.all(color: const Color(0xFFDB4BFF), width: 2.2),
          boxShadow: const [
            BoxShadow(color: Color(0xAAD437FF), blurRadius: 16),
          ],
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.speechBubble.copyWith(
            color: const Color(0xFFFF9AF7),
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}

class _HindiLettersLayer extends StatelessWidget {
  const _HindiLettersLayer();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: const _HindiLettersPainter(),
        size: Size.infinite,
      ),
    );
  }
}

class _HindiLettersPainter extends CustomPainter {
  const _HindiLettersPainter();

  static const _letters = [
    ('अ', Offset(0.09, 0.16), -0.22, 44.0),
    ('म', Offset(0.18, 0.21), 0.16, 38.0),
    ('क', Offset(0.86, 0.17), 0.22, 42.0),
    ('श', Offset(0.80, 0.28), -0.18, 36.0),
    ('अ', Offset(0.06, 0.36), -0.34, 34.0),
    ('?', Offset(0.28, 0.33), 0.0, 36.0),
    ('?', Offset(0.78, 0.36), 0.0, 40.0),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final item in _letters) {
      canvas.save();
      canvas.translate(item.$2.dx * size.width, item.$2.dy * size.height);
      canvas.rotate(item.$3);
      final painter = TextPainter(
        text: TextSpan(
          text: item.$1,
          style: TextStyle(
            color: const Color(0xFF7621C9).withValues(alpha: 0.2),
            fontSize: item.$4,
            fontWeight: FontWeight.w900,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, Offset.zero);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HeroGlowPainter extends CustomPainter {
  const _HeroGlowPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.58);
    canvas.drawCircle(
      center,
      size.width * 0.28,
      Paint()
        ..color = const Color(0xAA1C66FF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawCircle(
      center,
      size.width * 0.34,
      Paint()
        ..color = const Color(0xCCFF33E1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SpyPainter extends CustomPainter {
  const _SpyPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF101226), Color(0xFF03020D)],
      ).createShader(Offset.zero & size);
    final glowPaint = Paint()
      ..color = const Color(0xAAEB29FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7);

    final headCenter = Offset(size.width * 0.5, size.height * 0.28);
    canvas.drawCircle(headCenter, size.width * 0.18, glowPaint);
    canvas.drawCircle(headCenter, size.width * 0.17, bodyPaint);

    final coat = Path()
      ..moveTo(size.width * 0.27, size.height * 0.87)
      ..quadraticBezierTo(
        size.width * 0.34,
        size.height * 0.43,
        size.width * 0.5,
        size.height * 0.41,
      )
      ..quadraticBezierTo(
        size.width * 0.66,
        size.height * 0.43,
        size.width * 0.73,
        size.height * 0.87,
      )
      ..lineTo(size.width * 0.61, size.height * 0.95)
      ..lineTo(size.width * 0.5, size.height * 0.71)
      ..lineTo(size.width * 0.39, size.height * 0.95)
      ..close();
    canvas.drawPath(
      coat,
      Paint()
        ..color = const Color(0xAAFF7B23)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    canvas.drawPath(coat, bodyPaint);

    final eyePaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFFFE85B), Color(0xFFFF8018)],
      ).createShader(Rect.fromCircle(center: headCenter, radius: 60))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.36, size.height * 0.26)
        ..lineTo(size.width * 0.47, size.height * 0.29)
        ..quadraticBezierTo(
          size.width * 0.38,
          size.height * 0.34,
          size.width * 0.34,
          size.height * 0.28,
        )
        ..close(),
      eyePaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.64, size.height * 0.26)
        ..lineTo(size.width * 0.53, size.height * 0.29)
        ..quadraticBezierTo(
          size.width * 0.62,
          size.height * 0.34,
          size.width * 0.66,
          size.height * 0.28,
        )
        ..close(),
      eyePaint,
    );

    final finger = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.49,
        size.height * 0.35,
        size.width * 0.045,
        size.height * 0.22,
      ),
      Radius.circular(size.width * 0.03),
    );
    canvas.drawRRect(finger, Paint()..color = const Color(0xFF090912));
    canvas.drawRRect(
      finger,
      Paint()
        ..color = const Color(0xFFFFBB47)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final glassCenter = Offset(size.width * 0.72, size.height * 0.45);
    canvas.drawCircle(
      glassCenter,
      size.width * 0.105,
      Paint()
        ..color = const Color(0xFF051C4F)
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      glassCenter,
      size.width * 0.105,
      Paint()
        ..color = const Color(0xFF48E4FF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
    final handlePaint = Paint()
      ..color = const Color(0xFF0E0A26)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;
    canvas.drawLine(
      glassCenter + Offset(size.width * 0.06, size.height * 0.06),
      glassCenter + Offset(size.width * 0.14, size.height * 0.18),
      handlePaint,
    );
    final khPainter = TextPainter(
      text: const TextSpan(
        text: 'ख',
        style: TextStyle(
          color: Color(0xFF51F8FF),
          fontSize: 42,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    khPainter.paint(
      canvas,
      glassCenter - Offset(khPainter.width / 2, khPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ImposterPreviewPainter extends CustomPainter {
  const _ImposterPreviewPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.68, size.height * 0.43);
    final ringPaint = Paint()
      ..color = const Color(0xFFFF2CA9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(center, size.height * 0.36, ringPaint);
    canvas.drawCircle(
      center,
      size.height * 0.25,
      Paint()..color = const Color(0xFF07001D),
    );
    final qPainter = TextPainter(
      text: const TextSpan(
        text: '?',
        style: TextStyle(
          color: Color(0xFFFF73C9),
          fontSize: 42,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    qPainter.paint(
      canvas,
      center - Offset(qPainter.width / 2, qPainter.height / 2),
    );

    for (var i = 0; i < 4; i++) {
      canvas.drawCircle(
        Offset(12 + i * 22, size.height - 12),
        9,
        Paint()
          ..color = i == 3 ? const Color(0xFFFF2CA9) : const Color(0xFF1D86FF),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _VotePreviewPainter extends CustomPainter {
  const _VotePreviewPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.62, size.height * 0.52);
    final nodePaint = Paint()
      ..color = const Color(0xFF14368D)
      ..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..color = const Color(0x884F90FF)
      ..strokeWidth = 2;
    final nodes = [
      Offset(size.width * 0.18, size.height * 0.3),
      Offset(size.width * 0.9, size.height * 0.25),
      Offset(size.width * 0.86, size.height * 0.74),
      Offset(size.width * 0.25, size.height * 0.82),
    ];
    for (final node in nodes) {
      canvas.drawLine(center, node, linePaint);
      canvas.drawCircle(node, 14, nodePaint);
      canvas.drawCircle(
        node,
        14,
        Paint()
          ..color = const Color(0xFF4E8BFF)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
    canvas.drawCircle(
      center,
      28,
      Paint()
        ..color = const Color(0xFFFF2CB7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
    canvas.drawCircle(center, 22, Paint()..color = const Color(0xFF1B0431));
    canvas.drawCircle(center, 12, Paint()..color = const Color(0xFFFF4CC8));
    canvas.drawLine(
      center + const Offset(20, 20),
      center + const Offset(42, 44),
      Paint()
        ..color = const Color(0xFFB86CFF)
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 8,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
