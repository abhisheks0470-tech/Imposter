import 'package:flutter/material.dart';

import '../localization/app_language.dart';
import '../models/game_setup_data.dart';
import '../theme/neon_theme.dart';
import '../widgets/neon_widgets.dart';
import 'game_setup_screen.dart';
import 'voting_screen.dart';

class DiscussionScreen extends StatelessWidget {
  const DiscussionScreen({required this.discussionData, super.key});

  final DiscussionData discussionData;

  AppLanguage get _language => discussionData.setup.language;

  @override
  Widget build(BuildContext context) {
    return NeonScaffold(
      child: Column(
        children: [
          NeonHeader(
            language: _language,
            title: nt(_language, hi: 'चर्चा', en: 'Discussion'),
            onBack: () => Navigator.of(context).pop(),
          ),
          SizedBox(height: sh(context, 20)),
          Text(
            nt(_language, hi: 'चर्चा का समय', en: 'Discussion Time'),
            textAlign: TextAlign.center,
            style: NeonTheme.heading(context, _language, size: 84),
          ),
          Text(
            nt(
              _language,
              hi: 'अब सभी खिलाड़ी संकेत देंगे',
              en: 'Now all players will give hints',
            ),
            textAlign: TextAlign.center,
            style: NeonTheme.body(
              context,
              _language,
              size: 35,
              color: NeonTheme.gold,
              weight: FontWeight.w900,
            ),
          ),
          SizedBox(height: sh(context, 24)),
          Expanded(
            child: Column(
              children: [
                _Rule(
                  language: _language,
                  icon: Icons.record_voice_over_rounded,
                  color: NeonTheme.gold,
                  text: nt(
                    _language,
                    hi: 'हर खिलाड़ी अपने शब्द के बारे में संकेत देगा, लेकिन शब्द का नाम सीधे नहीं बोलना है।',
                    en: 'Each player gives hints about their word, but no one should say the word directly.',
                  ),
                ),
                SizedBox(height: sh(context, 12)),
                _Rule(
                  language: _language,
                  icon: Icons.hearing_rounded,
                  color: NeonTheme.neonBlue,
                  text: nt(
                    _language,
                    hi: 'ध्यान से सुनें और पता लगाएं कि कौन इम्पोस्टर है।',
                    en: 'Listen carefully and find out who the imposter is.',
                  ),
                ),
                SizedBox(height: sh(context, 12)),
                _Rule(
                  language: _language,
                  icon: Icons.masks_rounded,
                  color: NeonTheme.neonPink,
                  text: nt(
                    _language,
                    hi: 'इम्पोस्टर दूसरों के संकेत सुनकर खुद को बचाने की कोशिश करेगा।',
                    en: "The imposter will listen to others' hints and try to blend in.",
                  ),
                ),
                SizedBox(height: sh(context, 14)),
                _Summary(data: discussionData),
              ],
            ),
          ),
          NeonButton(
            key: const ValueKey('start_voting_button'),
            label: nt(_language, hi: 'वोटिंग शुरू करें', en: 'Start Voting'),
            language: _language,
            icon: Icons.how_to_vote_rounded,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => VotingScreen(discussionData: discussionData),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Rule extends StatelessWidget {
  const _Rule({
    required this.language,
    required this.icon,
    required this.color,
    required this.text,
  });

  final AppLanguage language;
  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      borderColor: color,
      padding: EdgeInsets.symmetric(
        horizontal: sw(context, 24),
        vertical: sh(context, 16),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: sp(context, 48)),
          SizedBox(width: sw(context, 20)),
          Expanded(
            child: Text(
              text,
              style: NeonTheme.body(
                context,
                language,
                size: 31,
                color: NeonTheme.textWhite,
                weight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.data});

  final DiscussionData data;

  @override
  Widget build(BuildContext context) {
    final language = data.setup.language;
    return NeonCard(
      borderColor: NeonTheme.neonPurple,
      padding: EdgeInsets.all(sp(context, 22)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Metric(
            label: nt(language, hi: 'प्लेयर्स', en: 'Players'),
            value: '${data.playerNames.length}',
            language: language,
          ),
          _Metric(
            label: nt(language, hi: 'इम्पोस्टर', en: 'Imposter'),
            value: '${data.imposterIndexes.length}',
            language: language,
          ),
          _Metric(
            label: nt(language, hi: 'कैटेगरी', en: 'Category'),
            value: categoryLabel(data.setup.category, language),
            language: language,
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    required this.language,
  });

  final String label;
  final String value;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: NeonTheme.title(
              context,
              language,
              size: 42,
              color: NeonTheme.gold,
            ),
          ),
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: NeonTheme.body(context, language, size: 22),
          ),
        ],
      ),
    );
  }
}
