import 'package:flutter/material.dart';

import '../localization/app_language.dart';
import '../navigation/safe_navigation.dart';
import '../theme/neon_theme.dart';
import '../theme/premium_assets.dart';
import '../widgets/neon_widgets.dart';
import 'game_setup_screen.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final language = AppLanguageScope.of(context).language;
    return NeonScaffold(
      child: Column(
        children: [
          NeonHeader(
            language: language,
            onBack: () => safeBackOrHome(context),
            title: nt(language, hi: 'हिंदी IMPOSTER', en: 'Hindi Imposter'),
          ),
          SizedBox(height: sh(context, 18)),
          Text(
            nt(language, hi: 'कैसे खेलें?', en: 'How to Play?'),
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
            nt(
              language,
              hi: 'शब्द बताओ, इम्पोस्टर पहचानो!',
              en: 'Give hints, find the imposter!',
            ),
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
              children: [
                _RuleCard(
                  language: language,
                  number: '1',
                  title: nt(
                    language,
                    hi: 'सबको शब्द मिलेगा',
                    en: 'Everyone gets a word',
                  ),
                  body: nt(
                    language,
                    hi: 'सभी खिलाड़ियों को एक जैसा शब्द मिलता है।',
                    en: 'All normal players get the same word.',
                  ),
                  icon: Icons.style_rounded,
                  color: NeonTheme.gold,
                ),
                _RuleCard(
                  language: language,
                  number: '2',
                  title: nt(
                    language,
                    hi: 'एक इम्पोस्टर होगा',
                    en: 'One player is imposter',
                  ),
                  body: nt(
                    language,
                    hi: 'इम्पोस्टर को कोई शब्द नहीं मिलेगा।',
                    en: 'The imposter will not get any word.',
                  ),
                  icon: Icons.masks_rounded,
                  color: NeonTheme.neonPink,
                ),
                _RuleCard(
                  language: language,
                  number: '3',
                  title: nt(language, hi: 'संकेत दो', en: 'Give hints'),
                  body: nt(
                    language,
                    hi: 'शब्द का संकेत दो, नाम मत बोलो।',
                    en: 'Give hints, but do not say the word.',
                  ),
                  icon: Icons.chat_bubble_rounded,
                  color: NeonTheme.neonBlue,
                ),
                _RuleCard(
                  language: language,
                  number: '4',
                  title: nt(language, hi: 'वोट करो', en: 'Vote'),
                  body: nt(
                    language,
                    hi: 'जिस पर शक हो उसे वोट करो।',
                    en: 'Vote for the player you suspect.',
                  ),
                  icon: Icons.how_to_vote_rounded,
                  color: NeonTheme.green,
                ),
              ],
            ),
          ),
          NeonButton(
            label: nt(language, hi: 'आगे बढ़ें', en: 'Continue'),
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
    required this.language,
    required this.number,
    required this.title,
    required this.body,
    required this.icon,
    required this.color,
  });

  final AppLanguage language;
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
          Text(title, style: NeonTheme.title(context, language, size: 38)),
          SizedBox(height: sh(context, 8)),
          Text(
            body,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: NeonTheme.body(context, language, size: 29),
          ),
        ],
      ),
    );
  }
}
