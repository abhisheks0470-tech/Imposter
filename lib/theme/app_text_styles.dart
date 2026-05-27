import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static const hindiTitleFill = TextStyle(
    color: Colors.white,
    fontSize: 86,
    height: 0.9,
    fontWeight: FontWeight.w900,
    shadows: [
      Shadow(color: Color(0xAA000000), offset: Offset(0, 7), blurRadius: 1),
    ],
  );

  static const imposterTitleFill = TextStyle(
    color: AppColors.titleWhite,
    fontSize: 56,
    height: 0.95,
    fontWeight: FontWeight.w900,
    shadows: [
      Shadow(
        color: AppColors.titlePurpleShadow,
        offset: Offset(0, 5),
        blurRadius: 0,
      ),
    ],
  );

  static const tagline = TextStyle(
    fontSize: 23,
    height: 1,
    fontWeight: FontWeight.w900,
    fontFamily: 'Roboto',
  );

  static const speechBubble = TextStyle(
    color: Colors.white,
    fontSize: 24,
    height: 1.1,
    fontWeight: FontWeight.w900,
    shadows: [
      Shadow(color: Color(0xAA000000), offset: Offset(0, 2), blurRadius: 1),
    ],
  );

  static const startButton = TextStyle(
    color: Colors.white,
    fontSize: 23,
    fontWeight: FontWeight.w900,
    shadows: [
      Shadow(color: Color(0xAA000000), offset: Offset(0, 2), blurRadius: 1),
    ],
  );
}
