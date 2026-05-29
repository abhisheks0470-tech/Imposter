import 'package:flutter/material.dart';

import '../localization/app_language.dart';
import '../theme/neon_theme.dart';
import '../theme/premium_assets.dart';
import '../widgets/neon_widgets.dart';
import 'game_setup_screen.dart';
import 'how_to_play_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const language = AppLanguage.hindi;
    return NeonScaffold(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
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
          SizedBox(height: sh(context, 18)),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _HeroLogo(language: language),
                _FeatureGrid(language: language),
                NeonButton(
                  label: 'Start Game',
                  language: AppLanguage.english,
                  icon: Icons.play_arrow_rounded,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const GameSetupScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroLogo extends StatelessWidget {
  const _HeroLogo({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: sh(context, 720).clamp(240, 370),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: sh(context, 34),
            child: Container(
              width: sw(context, 420).clamp(150, 220),
              height: sw(context, 420).clamp(150, 220),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    NeonTheme.neonPurple.withValues(alpha: 0.34),
                    Colors.transparent,
                  ],
                ),
                boxShadow: const [
                  BoxShadow(color: NeonTheme.neonPurple, blurRadius: 42),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Image.asset(
              PremiumAssets.logo,
              width: sw(context, 770).clamp(285, 430),
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            bottom: sh(context, 40),
            left: sw(context, 22),
            child: Image.asset(
              PremiumAssets.mascotShhh,
              height: sh(context, 330).clamp(120, 190),
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            bottom: 0,
            child: NeonCard(
              padding: EdgeInsets.symmetric(
                horizontal: sw(context, 44),
                vertical: sh(context, 14),
              ),
              borderColor: NeonTheme.neonPurple,
              child: Text(
                'शब्द बताओ, इम्पोस्टर पहचानो!',
                style: NeonTheme.body(
                  context,
                  language,
                  size: 38,
                  color: NeonTheme.gold,
                  weight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.groups_rounded, '3-12 खिलाड़ी'),
      (Icons.masks_rounded, 'गुप्त रोल'),
      (Icons.how_to_vote_rounded, 'वोटिंग'),
      (Icons.translate_rounded, 'Hindi / English'),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: sw(context, 18),
        mainAxisSpacing: sh(context, 14),
        childAspectRatio: 3.8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return NeonCard(
          padding: EdgeInsets.symmetric(
            horizontal: sw(context, 18),
            vertical: sh(context, 12),
          ),
          borderColor: index.isEven ? NeonTheme.neonPurple : NeonTheme.neonBlue,
          child: Row(
            children: [
              Icon(item.$1, color: NeonTheme.gold, size: sp(context, 38)),
              SizedBox(width: sw(context, 12)),
              Expanded(
                child: Text(
                  item.$2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: NeonTheme.body(
                    context,
                    language,
                    size: 31,
                    color: NeonTheme.textWhite,
                    weight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HowToPlayButton extends StatelessWidget {
  const _HowToPlayButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      onTap: onTap,
      padding: EdgeInsets.symmetric(
        horizontal: sw(context, 28),
        vertical: sh(context, 12),
      ),
      borderColor: NeonTheme.neonPink,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.menu_book_rounded,
            color: NeonTheme.gold,
            size: sp(context, 34),
          ),
          SizedBox(width: sw(context, 10)),
          Text(
            'How to Play',
            style: NeonTheme.body(
              context,
              AppLanguage.english,
              size: 31,
              color: NeonTheme.textWhite,
              weight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
