import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../localization/app_language.dart';
import '../models/game_setup_data.dart';
import '../theme/neon_theme.dart';
import '../theme/premium_assets.dart';
import '../widgets/neon_widgets.dart';
import 'discussion_screen.dart';

enum _RevealPhase { prompt, revealed, transition, complete }

class PlayerRevealScreen extends StatefulWidget {
  const PlayerRevealScreen({required this.revealData, super.key});

  final PlayerRevealData revealData;

  @override
  State<PlayerRevealScreen> createState() => _PlayerRevealScreenState();
}

class _PlayerRevealScreenState extends State<PlayerRevealScreen> {
  late final Set<int> _imposterIndexes;
  late final _SecretWord _secretWord;

  int _currentIndex = 0;
  _RevealPhase _phase = _RevealPhase.prompt;

  GameSetupData get _setup => widget.revealData.setup;
  AppLanguage get _language => _setup.language;
  List<String> get _players => widget.revealData.playerNames;
  String get _currentPlayer => _players[_currentIndex];
  bool get _isLastPlayer => _currentIndex == _players.length - 1;
  bool get _currentIsImposter => _imposterIndexes.contains(_currentIndex);

  @override
  void initState() {
    super.initState();
    final random = math.Random();
    final indexes = List.generate(_players.length, (index) => index)
      ..shuffle(random);
    _imposterIndexes = indexes.take(_setup.imposterCount).toSet();
    final words = _wordsForCategory(_setup.category);
    _secretWord = words[random.nextInt(words.length)];
  }

  @override
  Widget build(BuildContext context) {
    return NeonScaffold(
      child: Column(
        children: [
          NeonHeader(
            language: _language,
            title: _topTitle,
            onBack: () => Navigator.of(context).pop(),
            onHelp: () => _showHelpDialog(context),
            onSettings: () => _showSettingsDialog(context),
          ),
          SizedBox(height: sh(context, 18)),
          _Progress(
            language: _language,
            current: _currentIndex + 1,
            total: _players.length,
          ),
          SizedBox(height: sh(context, 20)),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: switch (_phase) {
                _RevealPhase.prompt => _Prompt(
                  key: const ValueKey('prompt'),
                  language: _language,
                  playerName: _currentPlayer,
                  onReveal: () =>
                      setState(() => _phase = _RevealPhase.revealed),
                ),
                _RevealPhase.revealed => _Reveal(
                  key: const ValueKey('revealed'),
                  language: _language,
                  isImposter: _currentIsImposter,
                  word: _secretWord,
                  category: _setup.category,
                  showWordImage: _setup.wordImageEnabled,
                  onHide: _handleGotIt,
                ),
                _RevealPhase.transition => _Transition(
                  key: const ValueKey('transition'),
                  language: _language,
                  nextPlayer: _players[_currentIndex + 1],
                  onNext: _openNextPlayerPrompt,
                ),
                _RevealPhase.complete => _Complete(
                  key: const ValueKey('complete'),
                  language: _language,
                  onStartDiscussion: _openDiscussion,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }

  String get _topTitle {
    if (_phase == _RevealPhase.transition &&
        _currentIndex + 1 < _players.length) {
      return _players[_currentIndex + 1];
    }
    if (_phase == _RevealPhase.complete) {
      return nt(_language, hi: 'सब तैयार', en: 'Ready');
    }
    return _currentPlayer;
  }

  void _handleGotIt() {
    setState(() {
      _phase = _isLastPlayer ? _RevealPhase.complete : _RevealPhase.transition;
    });
  }

  void _openNextPlayerPrompt() {
    setState(() {
      _currentIndex++;
      _phase = _RevealPhase.prompt;
    });
  }

  void _openDiscussion() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DiscussionScreen(
          discussionData: DiscussionData(
            setup: _setup,
            playerNames: _players,
            imposterIndexes: _imposterIndexes,
            secretWord: SecretWordData(
              hindi: _secretWord.hindi,
              english: _secretWord.english,
            ),
          ),
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    _showNeonDialog(
      context,
      title: nt(_language, hi: 'कैसे खेलें?', en: 'How to Play?'),
      message: nt(
        _language,
        hi: 'हर खिलाड़ी अपना शब्द या रोल अकेले देखे। संकेत दें, नाम मत बोलें।',
        en: 'Each player privately checks their word or role. Give hints, but do not say the name.',
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    _showNeonDialog(
      context,
      title: nt(_language, hi: 'सेटिंग', en: 'Settings'),
      message: nt(
        _language,
        hi: 'सेटिंग जल्द उपलब्ध होंगी।',
        en: 'Settings will be available later.',
      ),
    );
  }
}

class _Prompt extends StatelessWidget {
  const _Prompt({
    required this.language,
    required this.playerName,
    required this.onReveal,
    super.key,
  });

  final AppLanguage language;
  final String playerName;
  final VoidCallback onReveal;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _HeroTitle(
          language: language,
          title: nt(language, hi: 'गुप्त रिवील', en: 'Private Reveal'),
          subtitle: nt(
            language,
            hi: 'फोन सिर्फ इसी खिलाड़ी को दें',
            en: 'Give the phone only to this player',
          ),
        ),
        RevealCard(
          language: language,
          label: nt(language, hi: 'अब बारी है', en: 'Now it is'),
          value: playerName,
          icon: Icons.visibility_off_rounded,
          visualAsset: PremiumAssets.iconLock,
          showVisual: true,
        ),
        NeonButton(
          key: const ValueKey('tap_to_reveal_button'),
          label: nt(language, hi: 'देखें', en: 'Tap to Reveal'),
          language: language,
          icon: Icons.visibility_rounded,
          onTap: onReveal,
        ),
      ],
    );
  }
}

class _Reveal extends StatelessWidget {
  const _Reveal({
    required this.language,
    required this.isImposter,
    required this.word,
    required this.category,
    required this.showWordImage,
    required this.onHide,
    super.key,
  });

  final AppLanguage language;
  final bool isImposter;
  final _SecretWord word;
  final CategoryOption category;
  final bool showWordImage;
  final VoidCallback onHide;

  @override
  Widget build(BuildContext context) {
    final danger = isImposter;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _HeroTitle(
          language: language,
          title: isImposter
              ? nt(language, hi: 'आप इम्पोस्टर हैं', en: 'You are the Imposter')
              : nt(language, hi: 'आपका शब्द', en: 'Your Word'),
          subtitle: nt(
            language,
            hi: 'किसी को मत दिखाइए',
            en: 'Do not show anyone',
          ),
          danger: danger,
        ),
        RevealCard(
          language: language,
          label: isImposter
              ? nt(language, hi: 'आपका गुप्त रोल है', en: 'Your secret role is')
              : nt(
                  language,
                  hi: 'आपका गुप्त शब्द है',
                  en: 'Your secret word is',
                ),
          value: isImposter
              ? nt(language, hi: 'इम्पोस्टर', en: 'Imposter')
              : word.label(language),
          icon: isImposter ? Icons.question_mark_rounded : word.icon,
          danger: danger,
          showVisual: isImposter || showWordImage,
          visualAsset: isImposter
              ? PremiumAssets.mascotShhh
              : _categoryAsset(category),
        ),
        if (isImposter)
          _InfoStack(
            language: language,
            danger: true,
            lines: [
              nt(
                language,
                hi: 'आपको कोई शब्द नहीं मिलेगा',
                en: 'You will not get any word',
              ),
              nt(
                language,
                hi: 'दूसरों के संकेत सुनकर शब्द पहचानना है',
                en: "Listen to others' hints and guess the word",
              ),
              nt(
                language,
                hi: 'अपना रोल किसी को मत बताइए',
                en: 'Do not tell anyone your role',
              ),
            ],
          )
        else
          _InfoStack(
            language: language,
            lines: [
              nt(
                language,
                hi: 'इस शब्द का संकेत देना है, नाम नहीं बोलना है',
                en: 'Give hints, but do not say the name',
              ),
              nt(
                language,
                hi: 'फोन छुपाकर रखें, दूसरों को स्क्रीन न दिखाएँ',
                en: 'Keep the phone hidden from others',
              ),
            ],
          ),
        NeonButton(
          key: const ValueKey('got_it_button'),
          label: nt(language, hi: 'समझ गया', en: 'Got it'),
          language: language,
          icon: Icons.visibility_off_rounded,
          variant: NeonButtonVariant.purple,
          onTap: onHide,
        ),
      ],
    );
  }
}

class _Transition extends StatelessWidget {
  const _Transition({
    required this.language,
    required this.nextPlayer,
    required this.onNext,
    super.key,
  });

  final AppLanguage language;
  final String nextPlayer;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _HeroTitle(
          language: language,
          title: nt(language, hi: 'फोन पास करें', en: 'Pass the Phone'),
          subtitle: nt(
            language,
            hi: 'पिछला सीक्रेट छुप गया',
            en: 'Previous secret is hidden',
          ),
        ),
        RevealCard(
          language: language,
          label: nt(language, hi: 'अगला खिलाड़ी', en: 'Next Player'),
          value: nextPlayer,
          icon: Icons.person_rounded,
          visualAsset: PremiumAssets.iconUnlock,
          showVisual: true,
        ),
        NeonButton(
          key: const ValueKey('next_player_button'),
          label: nt(language, hi: 'अगला खिलाड़ी', en: 'Next Player'),
          language: language,
          icon: Icons.arrow_forward_rounded,
          onTap: onNext,
        ),
      ],
    );
  }
}

class _Complete extends StatelessWidget {
  const _Complete({
    required this.language,
    required this.onStartDiscussion,
    super.key,
  });

  final AppLanguage language;
  final VoidCallback onStartDiscussion;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _HeroTitle(
          language: language,
          title: nt(language, hi: 'सभी तैयार', en: 'All Ready'),
          subtitle: nt(
            language,
            hi: 'अब चर्चा शुरू करें',
            en: 'Start the discussion now',
          ),
        ),
        RevealCard(
          language: language,
          label: nt(language, hi: 'रिवील पूरा हुआ', en: 'Reveal Complete'),
          value: nt(language, hi: 'चर्चा', en: 'Discuss'),
          icon: Icons.forum_rounded,
          visualAsset: PremiumAssets.iconCheck,
          showVisual: true,
        ),
        NeonButton(
          key: const ValueKey('start_discussion_button'),
          label: nt(language, hi: 'चर्चा शुरू करें', en: 'Start Discussion'),
          language: language,
          icon: Icons.forum_rounded,
          onTap: onStartDiscussion,
        ),
      ],
    );
  }
}

class _HeroTitle extends StatelessWidget {
  const _HeroTitle({
    required this.language,
    required this.title,
    required this.subtitle,
    this.danger = false,
  });

  final AppLanguage language;
  final String title;
  final String subtitle;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: NeonTheme.heading(
            context,
            language,
            size: 74,
            color: danger ? NeonTheme.dangerRed : NeonTheme.textWhite,
          ),
        ),
        SizedBox(height: sh(context, 8)),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: NeonTheme.body(
            context,
            language,
            size: 31,
            color: danger ? NeonTheme.neonPink : NeonTheme.textMuted,
            weight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _InfoStack extends StatelessWidget {
  const _InfoStack({
    required this.language,
    required this.lines,
    this.danger = false,
  });

  final AppLanguage language;
  final List<String> lines;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < lines.length; i++) ...[
          NeonCard(
            borderColor: danger ? NeonTheme.dangerRed : NeonTheme.green,
            padding: EdgeInsets.symmetric(
              horizontal: sw(context, 22),
              vertical: sh(context, 12),
            ),
            child: Row(
              children: [
                Icon(
                  danger ? Icons.warning_rounded : Icons.lightbulb_rounded,
                  color: danger ? NeonTheme.dangerRed : NeonTheme.green,
                  size: sp(context, 38),
                ),
                SizedBox(width: sw(context, 16)),
                Expanded(
                  child: Text(
                    lines[i],
                    style: NeonTheme.body(
                      context,
                      language,
                      size: 25,
                      color: NeonTheme.textWhite,
                      weight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (i < lines.length - 1) SizedBox(height: sh(context, 8)),
        ],
      ],
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({
    required this.language,
    required this.current,
    required this.total,
  });

  final AppLanguage language;
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      padding: EdgeInsets.symmetric(
        horizontal: sw(context, 26),
        vertical: sh(context, 12),
      ),
      borderColor: NeonTheme.neonPurple,
      child: Row(
        children: [
          Text(
            '$current / $total ${nt(language, hi: 'खिलाड़ी', en: 'Players')}',
            style: NeonTheme.body(
              context,
              language,
              size: 27,
              color: NeonTheme.gold,
              weight: FontWeight.w900,
            ),
          ),
          SizedBox(width: sw(context, 22)),
          Expanded(
            child: Row(
              children: [
                for (var i = 0; i < total; i++)
                  Expanded(
                    child: Container(
                      height: 8,
                      margin: EdgeInsets.symmetric(horizontal: sw(context, 4)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: i + 1 == current
                            ? NeonTheme.gold
                            : NeonTheme.neonPurple.withValues(alpha: 0.35),
                        boxShadow: i + 1 == current
                            ? const [
                                BoxShadow(color: NeonTheme.gold, blurRadius: 8),
                              ]
                            : null,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _showNeonDialog(
  BuildContext context, {
  required String title,
  required String message,
}) {
  showDialog<void>(
    context: context,
    builder: (context) {
      final language = AppLanguageScope.of(context).language;
      return AlertDialog(
        backgroundColor: NeonTheme.cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: NeonTheme.neonPurple, width: 2),
        ),
        title: Text(title, style: NeonTheme.title(context, language, size: 36)),
        content: Text(
          message,
          style: NeonTheme.body(context, language, size: 26),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              nt(language, hi: 'ठीक है', en: 'OK'),
              style: NeonTheme.body(
                context,
                language,
                size: 26,
                color: NeonTheme.gold,
                weight: FontWeight.w900,
              ),
            ),
          ),
        ],
      );
    },
  );
}

class _SecretWord {
  const _SecretWord({
    required this.hindi,
    required this.english,
    required this.icon,
  });

  final String hindi;
  final String english;
  final IconData icon;

  String label(AppLanguage language) =>
      language == AppLanguage.hindi ? hindi : english;
}

List<_SecretWord> _wordsForCategory(CategoryOption category) {
  return switch (category) {
    CategoryOption.food => const [
      _SecretWord(
        hindi: 'समोसा',
        english: 'Samosa',
        icon: Icons.restaurant_rounded,
      ),
      _SecretWord(
        hindi: 'पिज़्ज़ा',
        english: 'Pizza',
        icon: Icons.local_pizza_rounded,
      ),
      _SecretWord(
        hindi: 'आइसक्रीम',
        english: 'Ice Cream',
        icon: Icons.icecream_rounded,
      ),
      _SecretWord(hindi: 'चाय', english: 'Tea', icon: Icons.local_cafe_rounded),
      _SecretWord(
        hindi: 'बर्गर',
        english: 'Burger',
        icon: Icons.lunch_dining_rounded,
      ),
    ],
    CategoryOption.animals => const [
      _SecretWord(hindi: 'शेर', english: 'Lion', icon: Icons.pets_rounded),
      _SecretWord(hindi: 'हाथी', english: 'Elephant', icon: Icons.pets_rounded),
      _SecretWord(hindi: 'बिल्ली', english: 'Cat', icon: Icons.pets_rounded),
      _SecretWord(hindi: 'कुत्ता', english: 'Dog', icon: Icons.pets_rounded),
      _SecretWord(hindi: 'बंदर', english: 'Monkey', icon: Icons.pets_rounded),
    ],
    CategoryOption.places => const [
      _SecretWord(
        hindi: 'स्कूल',
        english: 'School',
        icon: Icons.school_rounded,
      ),
      _SecretWord(
        hindi: 'मंदिर',
        english: 'Temple',
        icon: Icons.temple_hindu_rounded,
      ),
      _SecretWord(hindi: 'पार्क', english: 'Park', icon: Icons.park_rounded),
      _SecretWord(hindi: 'होटल', english: 'Hotel', icon: Icons.hotel_rounded),
      _SecretWord(
        hindi: 'रेलवे स्टेशन',
        english: 'Railway Station',
        icon: Icons.train_rounded,
      ),
    ],
    CategoryOption.movies => const [
      _SecretWord(hindi: 'हीरो', english: 'Hero', icon: Icons.movie_rounded),
      _SecretWord(
        hindi: 'विलेन',
        english: 'Villain',
        icon: Icons.theater_comedy_rounded,
      ),
      _SecretWord(
        hindi: 'सिनेमा',
        english: 'Cinema',
        icon: Icons.local_movies_rounded,
      ),
      _SecretWord(
        hindi: 'टिकट',
        english: 'Ticket',
        icon: Icons.confirmation_number_rounded,
      ),
      _SecretWord(
        hindi: 'गाना',
        english: 'Song',
        icon: Icons.music_note_rounded,
      ),
    ],
    CategoryOption.objects => const [
      _SecretWord(
        hindi: 'मोबाइल',
        english: 'Mobile',
        icon: Icons.phone_android_rounded,
      ),
      _SecretWord(hindi: 'कुर्सी', english: 'Chair', icon: Icons.chair_rounded),
      _SecretWord(
        hindi: 'किताब',
        english: 'Book',
        icon: Icons.menu_book_rounded,
      ),
      _SecretWord(hindi: 'घड़ी', english: 'Watch', icon: Icons.watch_rounded),
      _SecretWord(hindi: 'बैग', english: 'Bag', icon: Icons.backpack_rounded),
    ],
    CategoryOption.custom => const [
      _SecretWord(hindi: 'दोस्त', english: 'Friend', icon: Icons.group_rounded),
      _SecretWord(
        hindi: 'खेल',
        english: 'Game',
        icon: Icons.sports_esports_rounded,
      ),
      _SecretWord(
        hindi: 'रहस्य',
        english: 'Mystery',
        icon: Icons.question_mark_rounded,
      ),
      _SecretWord(hindi: 'सवाल', english: 'Question', icon: Icons.help_rounded),
      _SecretWord(
        hindi: 'जवाब',
        english: 'Answer',
        icon: Icons.check_circle_rounded,
      ),
    ],
  };
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
