import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../localization/app_language.dart';
import '../theme/neon_theme.dart';
import '../theme/premium_assets.dart';

class NeonScaffold extends StatelessWidget {
  const NeonScaffold({required this.child, super.key, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeonTheme.bgDark,
      body: Stack(
        children: [
          const Positioned.fill(child: _NeonBackground()),
          SafeArea(
            child: Padding(
              padding:
                  padding ??
                  EdgeInsets.fromLTRB(
                    sw(context, 42),
                    sh(context, 22),
                    sw(context, 42),
                    sh(context, 28),
                  ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _NeonBackground extends StatelessWidget {
  const _NeonBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: NeonTheme.bgGradient),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(PremiumAssets.background, fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  NeonTheme.bgDark.withValues(alpha: 0.16),
                  NeonTheme.bgPurple.withValues(alpha: 0.06),
                  NeonTheme.bgDark.withValues(alpha: 0.42),
                ],
              ),
            ),
          ),
          CustomPaint(painter: _NeonBackgroundPainter()),
        ],
      ),
    );
  }
}

class _NeonBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.32);
    final glow = Paint()
      ..shader =
          RadialGradient(
            colors: [
              NeonTheme.neonPurple.withValues(alpha: 0.3),
              NeonTheme.bgPurple.withValues(alpha: 0.16),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(center: center, radius: size.width * 0.72),
          );
    canvas.drawCircle(center, size.width * 0.72, glow);

    final linePaint = Paint()
      ..color = NeonTheme.neonPurple.withValues(alpha: 0.08)
      ..strokeWidth = 1.2;
    for (var i = 0; i < 18; i++) {
      final angle = math.pi * 2 * i / 18;
      canvas.drawLine(
        center,
        Offset(
          center.dx + math.cos(angle) * size.width,
          center.dy + math.sin(angle) * size.width,
        ),
        linePaint,
      );
    }

    final dotPaint = Paint()
      ..color = NeonTheme.neonPink.withValues(alpha: 0.55);
    for (var i = 0; i < 36; i++) {
      final x = (math.sin(i * 17.3) * 0.5 + 0.5) * size.width;
      final y = (math.cos(i * 13.1) * 0.5 + 0.5) * size.height;
      canvas.drawCircle(Offset(x, y), 1.2 + (i % 3), dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NeonHeader extends StatelessWidget {
  const NeonHeader({
    required this.language,
    super.key,
    this.title,
    this.center,
    this.onBack,
    this.onHelp,
    this.onSettings,
  });

  final AppLanguage language;
  final String? title;
  final Widget? center;
  final VoidCallback? onBack;
  final VoidCallback? onHelp;
  final VoidCallback? onSettings;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: sh(context, 102).clamp(48, 62),
      child: Row(
        children: [
          if (onBack != null)
            NeonIconButton(
              key: const ValueKey('header_back_button'),
              icon: Icons.arrow_back_rounded,
              assetPath: PremiumAssets.iconBack,
              onTap: onBack!,
            )
          else
            SizedBox(width: sw(context, 118)),
          Expanded(
            child: Center(
              child:
                  center ??
                  Text(
                    title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: NeonTheme.title(context, language, size: 42),
                  ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onHelp != null)
                NeonIconButton(
                  key: const ValueKey('header_help_button'),
                  icon: Icons.help_rounded,
                  assetPath: PremiumAssets.iconHelp,
                  onTap: onHelp!,
                ),
              if (onSettings != null) ...[
                SizedBox(width: sw(context, 16)),
                NeonIconButton(
                  key: const ValueKey('header_settings_button'),
                  icon: Icons.settings_rounded,
                  assetPath: PremiumAssets.iconSettings,
                  onTap: onSettings!,
                ),
              ],
              if (onHelp == null && onSettings == null)
                SizedBox(width: sw(context, 118)),
            ],
          ),
        ],
      ),
    );
  }
}

class NeonIconButton extends StatelessWidget {
  const NeonIconButton({
    required this.icon,
    required this.onTap,
    super.key,
    this.size,
    this.assetPath,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double? size;
  final String? assetPath;

  @override
  Widget build(BuildContext context) {
    final side = size ?? sh(context, 86).clamp(42, 56);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(side * 0.35),
        onTap: onTap,
        child: Ink(
          width: side,
          height: side,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(side * 0.35),
            gradient: NeonTheme.cardGradient,
            border: Border.all(color: NeonTheme.neonPurple, width: 1.4),
            boxShadow: [
              BoxShadow(
                color: NeonTheme.neonPurple.withValues(alpha: 0.48),
                blurRadius: 14,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(side * 0.17),
            child: assetPath == null
                ? Icon(icon, color: NeonTheme.textWhite, size: side * 0.54)
                : Image.asset(assetPath!, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}

class NeonCard extends StatelessWidget {
  const NeonCard({
    required this.child,
    super.key,
    this.padding,
    this.borderColor = NeonTheme.neonPurple,
    this.glowColor,
    this.radius,
    this.onTap,
    this.selected = false,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color borderColor;
  final Color? glowColor;
  final double? radius;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final r = radius ?? sp(context, 34);
    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: padding ?? EdgeInsets.all(sp(context, 30)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(r),
        gradient: selected
            ? const LinearGradient(
                colors: [Color(0xFF2C0E50), Color(0xFF120219)],
              )
            : NeonTheme.cardGradient,
        border: Border.all(color: borderColor, width: selected ? 2.4 : 1.4),
        boxShadow: [
          BoxShadow(
            color: (glowColor ?? borderColor).withValues(
              alpha: selected ? 0.6 : 0.32,
            ),
            blurRadius: selected ? 22 : 13,
          ),
          const BoxShadow(
            color: Color(0x99000000),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) {
      return content;
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(r),
        onTap: onTap,
        child: content,
      ),
    );
  }
}

class NeonButton extends StatelessWidget {
  const NeonButton({
    required this.label,
    required this.onTap,
    required this.language,
    super.key,
    this.icon,
    this.variant = NeonButtonVariant.primary,
    this.height,
  });

  final String label;
  final VoidCallback onTap;
  final AppLanguage language;
  final IconData? icon;
  final NeonButtonVariant variant;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final primary = variant == NeonButtonVariant.primary;
    final danger = variant == NeonButtonVariant.danger;
    final gradient = primary
        ? NeonTheme.ctaGradient
        : danger
        ? NeonTheme.dangerGradient
        : NeonTheme.purpleGradient;
    final textColor = primary ? const Color(0xFF4B1700) : NeonTheme.textWhite;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Ink(
          height: height ?? sh(context, 112).clamp(52, 64),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: gradient,
            image: DecorationImage(
              image: AssetImage(
                primary
                    ? PremiumAssets.buttonPrimary
                    : danger
                    ? PremiumAssets.buttonDanger
                    : PremiumAssets.buttonPurple,
              ),
              fit: BoxFit.fill,
              opacity: 0.9,
            ),
            border: Border.all(
              color: primary ? const Color(0xFFFFF0A0) : NeonTheme.neonPurple,
              width: 1.8,
            ),
            boxShadow: [
              BoxShadow(
                color: (primary ? NeonTheme.gold : NeonTheme.neonPurple)
                    .withValues(alpha: 0.55),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
              const BoxShadow(
                color: Color(0xCC000000),
                blurRadius: 0,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                left: 12,
                right: 12,
                top: 6,
                child: Container(
                  height: 9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: Colors.white.withValues(alpha: 0.28),
                  ),
                ),
              ),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: textColor, size: sp(context, 46)),
                      SizedBox(width: sw(context, 18)),
                    ],
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: NeonTheme.button(
                          context,
                          language,
                          color: textColor,
                          size: 42,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum NeonButtonVariant { primary, purple, danger }

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    required this.style,
    required this.gradient,
    super.key,
    this.textAlign,
  });

  final String text;
  final TextStyle style;
  final Gradient gradient;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(bounds),
      child: Text(text, textAlign: textAlign, style: style),
    );
  }
}

class PlayerRow extends StatelessWidget {
  const PlayerRow({
    required this.language,
    required this.index,
    required this.name,
    super.key,
    this.selected = false,
    this.onTap,
    this.trailing,
  });

  final AppLanguage language;
  final int index;
  final String name;
  final bool selected;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      selected: selected,
      onTap: onTap,
      borderColor: selected ? NeonTheme.gold : NeonTheme.neonPurple,
      padding: EdgeInsets.symmetric(
        horizontal: sw(context, 28),
        vertical: sh(context, 18),
      ),
      child: Row(
        children: [
          _NumberBadge(number: index + 1, selected: selected),
          SizedBox(width: sw(context, 24)),
          Expanded(
            child: Text(
              '${nt(language, hi: 'खिलाड़ी', en: 'Player')} ${index + 1} — $name',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: NeonTheme.body(
                context,
                language,
                size: 36,
                color: selected ? NeonTheme.gold : NeonTheme.textWhite,
                weight: FontWeight.w900,
              ),
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: sw(context, 14)),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class _NumberBadge extends StatelessWidget {
  const _NumberBadge({required this.number, required this.selected});

  final int number;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? NeonTheme.gold : NeonTheme.neonPurple;
    return Container(
      width: sp(context, 76),
      height: sp(context, 76),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: selected ? NeonTheme.ctaGradient : NeonTheme.purpleGradient,
        border: Border.all(color: color, width: 1.6),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.52), blurRadius: 15),
        ],
      ),
      child: Text(
        '$number',
        style: NeonTheme.button(
          context,
          AppLanguage.english,
          size: 34,
          color: selected ? const Color(0xFF4B1700) : NeonTheme.textWhite,
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    required this.language,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    super.key,
    this.assetPath,
  });

  final AppLanguage language;
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final String? assetPath;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      selected: selected,
      onTap: onTap,
      borderColor: selected ? NeonTheme.gold : NeonTheme.neonPurple,
      padding: EdgeInsets.symmetric(
        vertical: sh(context, 18),
        horizontal: sw(context, 12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: sp(context, 58),
            height: sp(context, 58),
            child: assetPath == null
                ? Icon(
                    icon,
                    color: selected ? NeonTheme.gold : NeonTheme.neonBlue,
                    size: sp(context, 54),
                  )
                : Image.asset(assetPath!, fit: BoxFit.contain),
          ),
          SizedBox(height: sh(context, 8)),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: NeonTheme.body(
              context,
              language,
              size: 27,
              color: NeonTheme.textWhite,
              weight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class RevealCard extends StatelessWidget {
  const RevealCard({
    required this.language,
    required this.label,
    required this.value,
    required this.icon,
    super.key,
    this.danger = false,
    this.showVisual = true,
    this.visualAsset,
  });

  final AppLanguage language;
  final String label;
  final String value;
  final IconData icon;
  final bool danger;
  final bool showVisual;
  final String? visualAsset;

  @override
  Widget build(BuildContext context) {
    final accent = danger ? NeonTheme.dangerRed : NeonTheme.gold;
    return NeonCard(
      borderColor: accent,
      glowColor: accent,
      padding: EdgeInsets.fromLTRB(
        sw(context, 30),
        sh(context, 28),
        sw(context, 30),
        sh(context, 30),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: NeonTheme.body(
              context,
              language,
              size: 33,
              color: NeonTheme.textMuted,
              weight: FontWeight.w900,
            ),
          ),
          SizedBox(height: sh(context, 12)),
          FittedBox(
            child: Text(
              value,
              style: NeonTheme.heading(
                context,
                language,
                size: danger ? 86 : 104,
                color: accent,
              ),
            ),
          ),
          if (showVisual) ...[
            SizedBox(height: sh(context, 18)),
            Container(
              width: sw(context, 230),
              height: sh(context, 160),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sp(context, 42)),
                gradient: RadialGradient(
                  colors: [accent.withValues(alpha: 0.3), NeonTheme.cardDarker],
                ),
                border: Border.all(color: accent, width: 1.8),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.45),
                    blurRadius: 22,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(sp(context, 18)),
                child: visualAsset == null
                    ? Icon(
                        icon,
                        color: accent,
                        size: sp(context, danger ? 94 : 86),
                      )
                    : Image.asset(visualAsset!, fit: BoxFit.contain),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ResultPanel extends StatelessWidget {
  const ResultPanel({
    required this.language,
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
    super.key,
  });

  final AppLanguage language;
  final String title;
  final String value;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      borderColor: accent,
      glowColor: accent,
      padding: EdgeInsets.symmetric(
        horizontal: sw(context, 28),
        vertical: sh(context, 20),
      ),
      child: Row(
        children: [
          Icon(icon, color: accent, size: sp(context, 58)),
          SizedBox(width: sw(context, 22)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: NeonTheme.body(
                    context,
                    language,
                    size: 26,
                    color: NeonTheme.textMuted,
                  ),
                ),
                SizedBox(height: sh(context, 4)),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: NeonTheme.title(
                    context,
                    language,
                    size: 40,
                    color: NeonTheme.textWhite,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StepperPills extends StatelessWidget {
  const StepperPills({
    required this.language,
    required this.current,
    super.key,
  });

  final AppLanguage language;
  final int current;

  @override
  Widget build(BuildContext context) {
    final labels = [
      nt(language, hi: 'सेटअप', en: 'Setup'),
      nt(language, hi: 'खिलाड़ी', en: 'Players'),
      nt(language, hi: 'खेल शुरू', en: 'Start'),
    ];
    return Row(
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          Expanded(
            child: Column(
              children: [
                Container(
                  width: sp(context, 62),
                  height: sp(context, 62),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: i + 1 <= current
                        ? NeonTheme.ctaGradient
                        : NeonTheme.cardGradient,
                    border: Border.all(
                      color: i + 1 <= current
                          ? NeonTheme.gold
                          : NeonTheme.neonPurple,
                      width: 1.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (i + 1 <= current
                                    ? NeonTheme.gold
                                    : NeonTheme.neonPurple)
                                .withValues(alpha: 0.45),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Text(
                    '${i + 1}',
                    style: NeonTheme.button(
                      context,
                      AppLanguage.english,
                      size: 30,
                      color: i + 1 <= current
                          ? const Color(0xFF4B1700)
                          : NeonTheme.textWhite,
                    ),
                  ),
                ),
                SizedBox(height: sh(context, 6)),
                Text(
                  labels[i],
                  style: NeonTheme.body(
                    context,
                    language,
                    size: 24,
                    color: i + 1 == current
                        ? NeonTheme.gold
                        : NeonTheme.textMuted,
                    weight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          if (i < labels.length - 1)
            Container(
              width: sw(context, 44),
              height: 3,
              margin: EdgeInsets.only(bottom: sh(context, 40)),
              color: NeonTheme.neonPurple.withValues(alpha: 0.65),
            ),
        ],
      ],
    );
  }
}
