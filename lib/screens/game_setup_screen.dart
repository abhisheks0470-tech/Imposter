import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../localization/app_language.dart';
import '../models/game_setup_data.dart';
import '../navigation/safe_navigation.dart';
import '../theme/neon_theme.dart';
import '../theme/premium_assets.dart';
import '../widgets/neon_widgets.dart';
import 'player_name_screen.dart';

class GameSetupScreen extends StatefulWidget {
  const GameSetupScreen({super.key});

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  static const _minPlayers = 3;
  static const _maxPlayers = 12;

  int _players = 4;
  int _imposters = 1;
  CategoryOption _category = CategoryOption.custom;
  bool _wordImageEnabled = true;

  int get _maxImposters => math.max(1, _players - 1);

  @override
  Widget build(BuildContext context) {
    final language = AppLanguageScope.of(context).language;
    return NeonScaffold(
      child: Column(
        children: [
          NeonHeader(
            language: language,
            onBack: () => safeBackOrHome(context),
            title: nt(language, hi: 'गेम सेटअप', en: 'Game Setup'),
          ),
          SizedBox(height: sh(context, 18)),
          StepperPills(language: language, current: 1),
          SizedBox(height: sh(context, 8)),
          SizedBox(
            height: sh(context, 150).clamp(48, 82),
            child: Image.asset(
              PremiumAssets.mascotDetective,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: sh(context, 8)),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _CounterCard(
                    title: nt(language, hi: 'प्लेयर्स', en: 'Players'),
                    subtitle: nt(
                      language,
                      hi: 'कुल कितने खिलाड़ी?',
                      en: 'How many players?',
                    ),
                    value: _players,
                    icon: Icons.groups_rounded,
                    decreaseKey: const ValueKey('players_decrease'),
                    increaseKey: const ValueKey('players_increase'),
                    canDecrease: _players > _minPlayers,
                    canIncrease: _players < _maxPlayers,
                    onDecrease: () {
                      setState(() {
                        _players--;
                        if (_imposters >= _players) {
                          _imposters = _players - 1;
                        }
                      });
                    },
                    onIncrease: () => setState(() => _players++),
                    language: language,
                  ),
                  SizedBox(height: sh(context, 10)),
                  _CounterCard(
                    title: nt(language, hi: 'इम्पोस्टर', en: 'Imposter'),
                    subtitle: nt(
                      language,
                      hi: 'कितने इम्पोस्टर?',
                      en: 'How many imposters?',
                    ),
                    value: _imposters,
                    icon: Icons.masks_rounded,
                    decreaseKey: const ValueKey('imposters_decrease'),
                    increaseKey: const ValueKey('imposters_increase'),
                    canDecrease: _imposters > 1,
                    canIncrease: _imposters < _maxImposters,
                    onDecrease: () => setState(() => _imposters--),
                    onIncrease: () => setState(() => _imposters++),
                    language: language,
                  ),
                  SizedBox(height: sh(context, 10)),
                  _CategoryStrip(
                    language: language,
                    selected: _category,
                    onChanged: (category) =>
                        setState(() => _category = category),
                  ),
                  SizedBox(height: sh(context, 14)),
                  _OptionRow(
                    language: language,
                    wordImageEnabled: _wordImageEnabled,
                    onWordImageChanged: (value) =>
                        setState(() => _wordImageEnabled = value),
                  ),
                ],
              ),
            ),
          ),
          NeonButton(
            label: nt(
              language,
              hi: 'अगला: खिलाड़ियों के नाम जोड़ें',
              en: 'Next: Add Player Names',
            ),
            language: language,
            icon: Icons.sports_esports_rounded,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => PlayerNameScreen(
                    setupData: GameSetupData(
                      playersCount: _players,
                      imposterCount: _imposters,
                      category: _category,
                      language: language,
                      wordImageEnabled: _wordImageEnabled,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CounterCard extends StatelessWidget {
  const _CounterCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.icon,
    required this.decreaseKey,
    required this.increaseKey,
    required this.canDecrease,
    required this.canIncrease,
    required this.onDecrease,
    required this.onIncrease,
    required this.language,
  });

  final String title;
  final String subtitle;
  final int value;
  final IconData icon;
  final Key decreaseKey;
  final Key increaseKey;
  final bool canDecrease;
  final bool canIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      padding: EdgeInsets.symmetric(
        horizontal: sw(context, 26),
        vertical: sh(context, 14),
      ),
      child: Row(
        children: [
          Icon(icon, color: NeonTheme.gold, size: sp(context, 58)),
          SizedBox(width: sw(context, 22)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: NeonTheme.title(context, language, size: 42),
                ),
                Text(
                  subtitle,
                  style: NeonTheme.body(context, language, size: 28),
                ),
              ],
            ),
          ),
          _CountButton(
            key: decreaseKey,
            icon: Icons.remove_rounded,
            enabled: canDecrease,
            onTap: onDecrease,
          ),
          SizedBox(
            width: sw(context, 92),
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: NeonTheme.heading(
                context,
                AppLanguage.english,
                size: 72,
                color: NeonTheme.textWhite,
              ),
            ),
          ),
          _CountButton(
            key: increaseKey,
            icon: Icons.add_rounded,
            enabled: canIncrease,
            onTap: onIncrease,
          ),
        ],
      ),
    );
  }
}

class _CountButton extends StatelessWidget {
  const _CountButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return NeonIconButton(
      icon: icon,
      size: sp(context, 76),
      onTap: enabled ? onTap : () {},
    );
  }
}

class _CategoryStrip extends StatelessWidget {
  const _CategoryStrip({
    required this.language,
    required this.selected,
    required this.onChanged,
  });

  final AppLanguage language;
  final CategoryOption selected;
  final ValueChanged<CategoryOption> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gapX = sw(context, 12);
        final gapY = sh(context, 10);
        final cardSize = (constraints.maxWidth - gapX * 2) / 3;
        final titleHeight = sp(context, 46);
        final totalHeight = titleHeight + sh(context, 10) + cardSize * 2 + gapY;
        return SizedBox(
          height: totalHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: titleHeight,
                child: Text(
                  nt(language, hi: 'कैटेगरी', en: 'Category'),
                  style: NeonTheme.title(context, language, size: 34),
                ),
              ),
              SizedBox(height: sh(context, 10)),
              Expanded(
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: gapX,
                  mainAxisSpacing: gapY,
                  childAspectRatio: 1,
                  children: [
                    for (final category in CategoryOption.values)
                      CategoryCard(
                        key: ValueKey('choice_$category'),
                        language: language,
                        label: categoryLabel(category, language),
                        icon: categoryIcon(category),
                        assetPath: categoryAsset(category),
                        selected: selected == category,
                        onTap: () => onChanged(category),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.language,
    required this.wordImageEnabled,
    required this.onWordImageChanged,
  });

  final AppLanguage language;
  final bool wordImageEnabled;
  final ValueChanged<bool> onWordImageChanged;

  @override
  Widget build(BuildContext context) {
    final controller = AppLanguageScope.of(context);
    return Row(
      children: [
        Expanded(
          child: NeonCard(
            padding: EdgeInsets.all(sp(context, 22)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nt(language, hi: 'भाषा', en: 'Language'),
                  style: NeonTheme.title(context, language, size: 36),
                ),
                SizedBox(height: sh(context, 12)),
                Row(
                  children: [
                    Expanded(
                      child: _ChoiceButton(
                        key: const ValueKey('choice_AppLanguage.hindi'),
                        label: 'Hindi',
                        active: language == AppLanguage.hindi,
                        onTap: () => controller.setLanguage(AppLanguage.hindi),
                      ),
                    ),
                    SizedBox(width: sw(context, 10)),
                    Expanded(
                      child: _ChoiceButton(
                        key: const ValueKey('choice_AppLanguage.english'),
                        label: 'English',
                        active: language == AppLanguage.english,
                        onTap: () =>
                            controller.setLanguage(AppLanguage.english),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: sw(context, 14)),
        Expanded(
          child: NeonCard(
            padding: EdgeInsets.all(sp(context, 22)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nt(language, hi: 'वर्ड इमेज', en: 'Word Image'),
                  style: NeonTheme.title(context, language, size: 36),
                ),
                SizedBox(height: sh(context, 12)),
                Row(
                  children: [
                    Switch(
                      key: const ValueKey('word_image_switch'),
                      value: wordImageEnabled,
                      activeThumbColor: NeonTheme.gold,
                      activeTrackColor: NeonTheme.green,
                      inactiveThumbColor: NeonTheme.textMuted,
                      inactiveTrackColor: NeonTheme.bgPurple,
                      onChanged: onWordImageChanged,
                    ),
                    SizedBox(width: sw(context, 8)),
                    Expanded(
                      child: Text(
                        wordImageEnabled
                            ? nt(language, hi: 'चालू', en: 'On')
                            : nt(language, hi: 'बंद', en: 'Off'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: NeonTheme.body(
                          context,
                          language,
                          size: 30,
                          color: wordImageEnabled
                              ? NeonTheme.green
                              : NeonTheme.textMuted,
                          weight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.active,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      selected: active,
      onTap: onTap,
      borderColor: active ? NeonTheme.gold : NeonTheme.neonPurple,
      padding: EdgeInsets.symmetric(vertical: sh(context, 12)),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: NeonTheme.body(
          context,
          AppLanguage.english,
          size: 30,
          color: active ? NeonTheme.gold : NeonTheme.textWhite,
          weight: FontWeight.w900,
        ),
      ),
    );
  }
}

String categoryLabel(CategoryOption category, AppLanguage language) {
  return switch (category) {
    CategoryOption.food => nt(language, hi: 'खाना', en: 'Food'),
    CategoryOption.animals => nt(language, hi: 'जानवर', en: 'Animals'),
    CategoryOption.places => nt(language, hi: 'जगहें', en: 'Places'),
    CategoryOption.movies => nt(language, hi: 'फिल्में', en: 'Movies'),
    CategoryOption.objects => nt(language, hi: 'चीजें', en: 'Objects'),
    CategoryOption.custom => nt(language, hi: 'मिक्स', en: 'Mixed'),
  };
}

IconData categoryIcon(CategoryOption category) {
  return switch (category) {
    CategoryOption.food => Icons.restaurant_rounded,
    CategoryOption.animals => Icons.pets_rounded,
    CategoryOption.places => Icons.location_city_rounded,
    CategoryOption.movies => Icons.movie_rounded,
    CategoryOption.objects => Icons.widgets_rounded,
    CategoryOption.custom => Icons.shuffle_rounded,
  };
}

String categoryAsset(CategoryOption category) {
  return switch (category) {
    CategoryOption.food => PremiumAssets.categoryFood,
    CategoryOption.animals => PremiumAssets.categoryAnimals,
    CategoryOption.places => PremiumAssets.categoryPlaces,
    CategoryOption.movies => PremiumAssets.categoryMovies,
    CategoryOption.objects => PremiumAssets.categoryObjects,
    CategoryOption.custom => PremiumAssets.categoryCustom,
  };
}
