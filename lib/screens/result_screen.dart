import 'package:flutter/material.dart';

import '../localization/app_language.dart';
import '../models/game_setup_data.dart';
import '../theme/neon_theme.dart';
import '../theme/premium_assets.dart';
import '../widgets/neon_widgets.dart';
import 'game_setup_screen.dart';
import 'home_screen.dart';
import 'player_name_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({required this.resultData, super.key});

  final VotingResultData resultData;

  DiscussionData get _data => resultData.discussionData;
  GameSetupData get _setup => _data.setup;
  AppLanguage get _language => _setup.language;
  bool get _isCorrect =>
      _data.imposterIndexes.contains(resultData.selectedPlayerIndex);

  @override
  Widget build(BuildContext context) {
    final imposters = _realImposterNames();
    final accent = _isCorrect ? NeonTheme.green : NeonTheme.dangerRed;
    final mainImposter = imposters.join(', ');
    return NeonScaffold(
      child: Column(
        children: [
          NeonHeader(
            language: _language,
            title: nt(_language, hi: 'रिजल्ट', en: 'Result'),
            onBack: () => Navigator.of(context).pop(),
          ),
          SizedBox(height: sh(context, 10)),
          Text(
            _isCorrect
                ? nt(
                    _language,
                    hi: 'इम्पोस्टर पकड़ा गया!',
                    en: 'Imposter Caught!',
                  )
                : nt(_language, hi: 'गलत अंदाज़ा!', en: 'Wrong Guess!'),
            textAlign: TextAlign.center,
            style: NeonTheme.heading(
              context,
              _language,
              size: 78,
              color: accent,
            ),
          ),
          SizedBox(height: sh(context, 10)),
          ResultPanel(
            language: _language,
            title: _isCorrect
                ? nt(
                    _language,
                    hi: 'आपने सही इम्पोस्टर चुना',
                    en: 'You selected the correct imposter',
                  )
                : nt(
                    _language,
                    hi: 'यह खिलाड़ी इम्पोस्टर नहीं था',
                    en: 'This player was not the imposter',
                  ),
            value:
                '${nt(_language, hi: 'आपकी पसंद', en: 'Your Vote')}: ${resultData.selectedPlayerName}',
            icon: _isCorrect ? Icons.verified_rounded : Icons.cancel_rounded,
            accent: accent,
          ),
          SizedBox(height: sh(context, 8)),
          ResultPanel(
            language: _language,
            title: nt(_language, hi: 'असली इम्पोस्टर', en: 'Real Imposter'),
            value: nt(
              _language,
              hi: 'इम्पोस्टर था $mainImposter',
              en: 'Imposter was $mainImposter',
            ),
            icon: Icons.masks_rounded,
            accent: NeonTheme.neonPink,
          ),
          SizedBox(height: sh(context, 8)),
          SizedBox(
            width: double.infinity,
            height: sh(context, 520).clamp(220, 300),
            child: RevealCard(
              language: _language,
              label: nt(_language, hi: 'गुप्त शब्द', en: 'Secret Word'),
              value: _data.secretWord.label(_language),
              icon: _categoryIcon(_setup.category),
              showVisual: _setup.wordImageEnabled,
              visualAsset: _categoryAsset(_setup.category),
            ),
          ),
          SizedBox(height: sh(context, 8)),
          Row(
            children: [
              Expanded(
                child: NeonButton(
                  key: const ValueKey('play_again_button'),
                  label: nt(_language, hi: 'फिर खेलें', en: 'Play Again'),
                  language: _language,
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute<void>(
                        builder: (_) => PlayerNameScreen(setupData: _setup),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ),
              SizedBox(width: sw(context, 12)),
              Expanded(
                child: NeonButton(
                  key: const ValueKey('change_setup_button'),
                  label: nt(_language, hi: 'नया गेम', en: 'New Game'),
                  language: _language,
                  variant: NeonButtonVariant.purple,
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute<void>(
                        builder: (_) => const GameSetupScreen(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: sh(context, 8)),
          NeonButton(
            key: const ValueKey('home_button'),
            label: nt(_language, hi: 'होम पर जाएँ', en: 'Go Home'),
            language: _language,
            variant: NeonButtonVariant.purple,
            height: sh(context, 104).clamp(58, 64),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  List<String> _realImposterNames() {
    final indexes = _data.imposterIndexes.toList()..sort();
    return [
      for (final index in indexes)
        if (index >= 0 && index < _data.playerNames.length)
          _data.playerNames[index],
    ];
  }
}

String _categoryAsset(CategoryOption category) {
  return switch (category) {
    CategoryOption.food => PremiumAssets.categoryFood,
    CategoryOption.animals => PremiumAssets.categoryAnimals,
    CategoryOption.places => PremiumAssets.categoryPlaces,
    CategoryOption.movies => PremiumAssets.categoryMovies,
    CategoryOption.objects => PremiumAssets.categoryObjects,
    CategoryOption.custom => PremiumAssets.categoryCustom,
  };
}

IconData _categoryIcon(CategoryOption category) {
  return switch (category) {
    CategoryOption.food => Icons.restaurant_rounded,
    CategoryOption.animals => Icons.pets_rounded,
    CategoryOption.places => Icons.location_city_rounded,
    CategoryOption.movies => Icons.movie_rounded,
    CategoryOption.objects => Icons.widgets_rounded,
    CategoryOption.custom => Icons.extension_rounded,
  };
}
