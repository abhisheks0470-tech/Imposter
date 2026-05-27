import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'game_setup_screen.dart';
import 'how_to_play_screen.dart';
import '../widgets/app_background.dart';
import '../widgets/crewmate_illustration.dart';
import '../widgets/neon_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: AppBackground()),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final heroHeight = (constraints.maxHeight * 0.66).clamp(
                  500.0,
                  650.0,
                );

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width < 380 ? 18 : 24,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(height: width < 380 ? 18 : 28),
                          SizedBox(
                            width: math.min(width, 470),
                            height: heroHeight,
                            child: const CrewmateIllustration(),
                          ),
                          const SizedBox(height: 18),
                          NeonButton(
                            label: 'Start Game',
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const GameSetupScreen(),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: width < 380 ? 18 : 26),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 18, 0),
                child: _HowToPlayButton(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const HowToPlayScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HowToPlayButton extends StatelessWidget {
  const _HowToPlayButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: const Color(0xB00C0627),
            border: Border.all(color: AppColors.purpleBorder, width: 1.5),
            boxShadow: const [
              BoxShadow(color: AppColors.purpleShadow, blurRadius: 14),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.help_outline_rounded, color: Colors.white, size: 20),
              SizedBox(width: 6),
              Text(
                'How to Play',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
