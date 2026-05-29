import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../localization/app_language.dart';

double sw(BuildContext context, double value) {
  return value * MediaQuery.sizeOf(context).width / 1080;
}

double sh(BuildContext context, double value) {
  return value * MediaQuery.sizeOf(context).height / 1920;
}

double sp(BuildContext context, double value) {
  final size = MediaQuery.sizeOf(context);
  final factor = math.min(size.width / 1080, size.height / 1920);
  return value * factor.clamp(0.58, 1.05);
}

class NeonTheme {
  const NeonTheme._();

  static const bgDark = Color(0xFF050014);
  static const bgPurple = Color(0xFF12002E);
  static const bgViolet = Color(0xFF230049);
  static const cardDark = Color(0xFF120822);
  static const cardDarker = Color(0xFF080014);
  static const neonPurple = Color(0xFF9D22FF);
  static const neonPink = Color(0xFFFF2D9D);
  static const neonBlue = Color(0xFF00D8FF);
  static const gold = Color(0xFFFFD21F);
  static const orange = Color(0xFFFF8A00);
  static const green = Color(0xFF22D957);
  static const dangerRed = Color(0xFFFF225C);
  static const textWhite = Color(0xFFFFFFFF);
  static const textMuted = Color(0xFFC9B8E8);
  static const black = Color(0xFF020007);

  static const radiusSmall = 14.0;
  static const radius = 22.0;
  static const radiusLarge = 34.0;

  static const bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [bgDark, bgPurple, bgDark],
  );

  static const cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xF21D0B3A), Color(0xF2090316)],
  );

  static const purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB43CFF), Color(0xFF6312D0)],
  );

  static const ctaGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gold, orange],
  );

  static const dangerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [dangerRed, neonPink],
  );

  static const successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [green, gold],
  );

  static TextStyle heading(
    BuildContext context,
    AppLanguage language, {
    double size = 92,
    Color color = textWhite,
  }) {
    return (language == AppLanguage.hindi
            ? GoogleFonts.baloo2()
            : GoogleFonts.poppins())
        .copyWith(
          color: color,
          fontSize: sp(context, size),
          fontWeight: FontWeight.w900,
          height: 0.95,
          letterSpacing: 0,
          shadows: const [
            Shadow(color: neonPurple, blurRadius: 18),
            Shadow(
              color: Color(0x99000000),
              offset: Offset(0, 4),
              blurRadius: 0,
            ),
          ],
        );
  }

  static TextStyle title(
    BuildContext context,
    AppLanguage language, {
    double size = 54,
    Color color = textWhite,
  }) {
    return (language == AppLanguage.hindi
            ? GoogleFonts.baloo2()
            : GoogleFonts.poppins())
        .copyWith(
          color: color,
          fontSize: sp(context, size),
          fontWeight: FontWeight.w900,
          height: 1,
          letterSpacing: 0,
        );
  }

  static TextStyle body(
    BuildContext context,
    AppLanguage language, {
    double size = 34,
    Color color = textMuted,
    FontWeight weight = FontWeight.w700,
  }) {
    return (language == AppLanguage.hindi
            ? GoogleFonts.notoSansDevanagari()
            : GoogleFonts.poppins())
        .copyWith(
          color: color,
          fontSize: sp(context, size),
          fontWeight: weight,
          height: 1.25,
          letterSpacing: 0,
        );
  }

  static TextStyle button(
    BuildContext context,
    AppLanguage language, {
    double size = 42,
    Color color = const Color(0xFF4C1900),
  }) {
    return (language == AppLanguage.hindi
            ? GoogleFonts.baloo2()
            : GoogleFonts.poppins())
        .copyWith(
          color: color,
          fontSize: sp(context, size),
          fontWeight: FontWeight.w900,
          height: 1,
          letterSpacing: 0,
        );
  }
}

String nt(AppLanguage language, {required String hi, required String en}) {
  return language == AppLanguage.hindi ? hi : en;
}
