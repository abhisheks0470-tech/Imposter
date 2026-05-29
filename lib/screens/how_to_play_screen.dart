import 'package:flutter/material.dart';

import '../localization/app_language.dart';
import '../theme/neon_theme.dart';
import '../theme/premium_assets.dart';
import '../widgets/neon_widgets.dart';
import 'game_setup_screen.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const language = AppLanguage.hindi;
    return NeonScaffold(
      child: Column(
        children: [
          NeonHeader(
            language: language,
            onBack: () => Navigator.of(context).pop(),
            title: 'हिंदी IMPOSTER',
          ),
          SizedBox(height: sh(context, 18)),
          Text(
            'कैसे खेलें?',
            style: NeonTheme.heading(context, language, size: 94),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: sh(context, 185).clamp(70, 110),
            child: Image.asset(
              PremiumAssets.mascotDetective,
              fit: BoxFit.contain,
            ),
          ),
          Text(
            'शब्द बताओ, इम्पोस्टर पहचानो!',
            style: NeonTheme.body(
              context,
              language,
              size: 38,
              color: NeonTheme.gold,
              weight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: sh(context, 24)),
          Expanded(
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: sw(context, 16),
              mainAxisSpacing: sh(context, 14),
              childAspectRatio: 0.82,
              children: const [
                _RuleCard(
                  number: '1',
                  title: 'सबको शब्द मिलेगा',
                  body: 'सभी खिलाड़ियों को एक जैसा शब्द मिलता है।',
                  icon: Icons.style_rounded,
                  color: NeonTheme.gold,
                ),
                _RuleCard(
                  number: '2',
                  title: 'एक इम्पोस्टर होगा',
                  body: 'इम्पोस्टर को कोई शब्द नहीं मिलेगा।',
                  icon: Icons.masks_rounded,
                  color: NeonTheme.neonPink,
                ),
                _RuleCard(
                  number: '3',
                  title: 'संकेत दो',
                  body: 'शब्द का संकेत दो, नाम मत बोलो।',
                  icon: Icons.chat_bubble_rounded,
                  color: NeonTheme.neonBlue,
                ),
                _RuleCard(
                  number: '4',
                  title: 'वोट करो',
                  body: 'जिस पर शक हो उसे वोट करो।',
                  icon: Icons.how_to_vote_rounded,
                  color: NeonTheme.green,
                ),
              ],
            ),
          ),
          NeonButton(
            label: 'आगे बढ़ें',
            language: language,
            icon: Icons.double_arrow_rounded,
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
    );
  }
}

class _RuleCard extends StatelessWidget {
  const _RuleCard({
    required this.number,
    required this.title,
    required this.body,
    required this.icon,
    required this.color,
  });

  final String number;
  final String title;
  final String body;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      borderColor: color,
      glowColor: color,
      padding: EdgeInsets.all(sp(context, 18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: sp(context, 56),
                height: sp(context, 56),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: NeonTheme.purpleGradient,
                  border: Border.all(color: color, width: 1.6),
                ),
                child: Text(
                  number,
                  style: NeonTheme.button(
                    context,
                    AppLanguage.english,
                    size: 26,
                    color: NeonTheme.textWhite,
                  ),
                ),
              ),
              const Spacer(),
              Icon(icon, color: color, size: sp(context, 52)),
            ],
          ),
          SizedBox(height: sh(context, 10)),
          Text(
            title,
            style: NeonTheme.title(context, AppLanguage.hindi, size: 38),
          ),
          SizedBox(height: sh(context, 8)),
          Text(
            body,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: NeonTheme.body(context, AppLanguage.hindi, size: 29),
          ),
        ],
      ),
    );
  }
}
