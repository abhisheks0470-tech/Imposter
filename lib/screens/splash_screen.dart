import 'dart:async';

import 'package:flutter/material.dart';

import '../localization/app_language.dart';
import '../theme/neon_theme.dart';
import '../theme/premium_assets.dart';
import '../widgets/neon_widgets.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1100), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    const language = AppLanguage.hindi;
    return NeonScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            PremiumAssets.logo,
            width: sw(context, 760).clamp(260, 430),
            fit: BoxFit.contain,
          ),
          SizedBox(height: sh(context, 42)),
          Text(
            'लोड हो रहा है...',
            style: NeonTheme.title(context, language, size: 42),
          ),
          SizedBox(height: sh(context, 20)),
          Container(
            width: sw(context, 720).clamp(250, 380),
            height: sh(context, 26).clamp(10, 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: NeonTheme.cardDarker,
              border: Border.all(color: NeonTheme.neonPurple, width: 1.5),
              boxShadow: const [
                BoxShadow(color: NeonTheme.neonPink, blurRadius: 16),
              ],
            ),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 0.72,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: NeonTheme.ctaGradient,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
