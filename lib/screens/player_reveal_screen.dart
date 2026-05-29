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
    final random = math.Random(
      DateTime.now().microsecondsSinceEpoch ^
          Object.hashAll(widget.revealData.playerNames) ^
          widget.revealData.setup.playersCount ^
          widget.revealData.setup.imposterCount ^
          widget.revealData.setup.category.index,
    );
    final indexes = List.generate(_players.length, (index) => index)
      ..shuffle(random);
    _imposterIndexes = indexes.take(_setup.imposterCount).toSet();
    _secretWord = _pickSecretWord(_setup.category, random);
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
          SizedBox(height: sh(context, 12)),
          _Progress(
            language: _language,
            current: _currentIndex + 1,
            total: _players.length,
          ),
          SizedBox(height: sh(context, 18)),
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
              imageAsset: _secretWord.imageAsset,
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
        SizedBox(height: sh(context, 22)),
        _HeroTitle(
          language: language,
          title: nt(language, hi: 'गुप्त रिवील', en: 'Private Reveal'),
          subtitle: nt(
            language,
            hi: 'फोन सिर्फ इसी खिलाड़ी को दें',
            en: 'Give the phone only to this player',
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: sh(context, 570).clamp(235, 315),
          child: RevealCard(
            language: language,
            label: nt(language, hi: 'अब बारी है', en: 'Now it is'),
            value: playerName,
            icon: Icons.visibility_off_rounded,
            visualAsset: PremiumAssets.iconLock,
            showVisual: true,
          ),
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
        SizedBox(height: sh(context, 20)),
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
        SizedBox(
          width: double.infinity,
          height: sh(context, 610).clamp(245, 330),
          child: RevealCard(
            language: language,
            label: isImposter
                ? nt(
                    language,
                    hi: 'आपका गुप्त रोल है',
                    en: 'Your secret role is',
                  )
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
                : word.imageAsset,
          ),
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
          variant: isImposter
              ? NeonButtonVariant.danger
              : NeonButtonVariant.success,
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
        SizedBox(height: sh(context, 24)),
        _HeroTitle(
          language: language,
          title: nt(language, hi: 'फोन पास करें', en: 'Pass the Phone'),
          subtitle: nt(
            language,
            hi: 'पिछला सीक्रेट छुप गया',
            en: 'Previous secret is hidden',
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: sh(context, 570).clamp(235, 315),
          child: RevealCard(
            language: language,
            label: nt(language, hi: 'अगला खिलाड़ी', en: 'Next Player'),
            value: nextPlayer,
            icon: Icons.person_rounded,
            visualAsset: PremiumAssets.iconUnlock,
            showVisual: true,
          ),
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
        SizedBox(height: sh(context, 24)),
        _HeroTitle(
          language: language,
          title: nt(language, hi: 'सभी तैयार', en: 'All Ready'),
          subtitle: nt(
            language,
            hi: 'अब चर्चा शुरू करें',
            en: 'Start the discussion now',
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: sh(context, 570).clamp(235, 315),
          child: RevealCard(
            language: language,
            label: nt(language, hi: 'रिवील पूरा हुआ', en: 'Reveal Complete'),
            value: nt(language, hi: 'चर्चा', en: 'Discuss'),
            icon: Icons.forum_rounded,
            visualAsset: PremiumAssets.iconCheck,
            showVisual: true,
          ),
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
            size: 82,
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
            size: 35,
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
                      size: 30,
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
              size: 31,
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
    required this.imageAsset,
  });

  final String hindi;
  final String english;
  final IconData icon;
  final String imageAsset;

  String label(AppLanguage language) =>
      language == AppLanguage.hindi ? hindi : english;
}

final Map<CategoryOption, String> _lastWordByCategory = {};

_SecretWord _pickSecretWord(CategoryOption category, math.Random random) {
  final words = _wordsForCategory(category);
  final lastWord = _lastWordByCategory[category];
  final availableWords = words.length > 1
      ? words.where((word) => word.hindi != lastWord).toList()
      : words;
  final selected = availableWords[random.nextInt(availableWords.length)];
  _lastWordByCategory[category] = selected.hindi;
  return selected;
}

List<_SecretWord> _wordList(
  CategoryOption category,
  IconData icon,
  List<(String, String)> entries,
) {
  return [
    for (final entry in entries)
      _SecretWord(
        hindi: entry.$1,
        english: entry.$2,
        icon: icon,
        imageAsset:
            'assets/imposter/words/${_categoryKey(category)}/${_wordAssetKey(entry.$2)}.webp',
      ),
  ];
}

List<_SecretWord> _wordsForCategory(CategoryOption category) {
  return switch (category) {
    CategoryOption.food => _wordList(category, Icons.restaurant_rounded, const [
      ('समोसा', 'Savory Pastry'),
      ('पिज़्ज़ा', 'Pizza'),
      ('आइसक्रीम', 'Ice Cream'),
      ('चाय', 'Tea'),
      ('बर्गर', 'Burger'),
      ('पानीपुरी', 'Crispy Water Snack'),
      ('डोसा', 'Rice Crepe'),
      ('इडली', 'Steamed Rice Cake'),
      ('वड़ा पाव', 'Potato Burger'),
      ('पाव भाजी', 'Vegetable Bread Curry'),
      ('बिरयानी', 'Spiced Rice'),
      ('पुलाव', 'Rice Pilaf'),
      ('दाल', 'Lentil Soup'),
      ('रोटी', 'Flatbread'),
      ('पराठा', 'Stuffed Flatbread'),
      ('नान', 'Leavened Flatbread'),
      ('छोले', 'Chickpea Curry'),
      ('राजमा', 'Kidney Bean Curry'),
      ('कढ़ी', 'Yogurt Curry'),
      ('खिचड़ी', 'Lentil Rice'),
      ('जलेबी', 'Syrup Spiral Sweet'),
      ('गुलाब जामुन', 'Milk Dumpling Dessert'),
      ('रसगुल्ला', 'Cheese Ball Dessert'),
      ('लड्डू', 'Sweet Ball'),
      ('कचौड़ी', 'Stuffed Fried Pastry'),
      ('ढोकला', 'Steamed Gram Cake'),
      ('उपमा', 'Savory Semolina'),
      ('पोहा', 'Flattened Rice'),
      ('मोमोज', 'Dumplings'),
      ('नूडल्स', 'Noodles'),
      ('पास्ता', 'Pasta'),
      ('सैंडविच', 'Sandwich'),
      ('ऑमलेट', 'Omelette'),
      ('सलाद', 'Salad'),
      ('सूप', 'Soup'),
      ('कॉफी', 'Coffee'),
      ('लस्सी', 'Yogurt Drink'),
      ('नींबू पानी', 'Lemonade'),
      ('चॉकलेट', 'Chocolate'),
      ('केक', 'Cake'),
      ('कुकीज़', 'Cookies'),
      ('पॉपकॉर्न', 'Popcorn'),
      ('फ्रेंच फ्राइज', 'French Fries'),
      ('पनीर टिक्का', 'Grilled Cottage Cheese'),
      ('मटर पनीर', 'Pea Cottage Cheese Curry'),
      ('मसाला डोसा', 'Spiced Rice Crepe'),
      ('कुल्फी', 'Frozen Milk Dessert'),
      ('फलूदा', 'Sweet Noodle Drink'),
      ('हलवा', 'Sweet Pudding'),
      ('सेवईं', 'Sweet Vermicelli'),
      ('मैगी', 'Instant Noodles'),
      ('टमाटर', 'Tomato'),
      ('टाको', 'Taco'),
    ]),
    CategoryOption.animals => _wordList(category, Icons.pets_rounded, const [
      ('शेर', 'Lion'),
      ('हाथी', 'Elephant'),
      ('बिल्ली', 'Cat'),
      ('कुत्ता', 'Dog'),
      ('बंदर', 'Monkey'),
      ('बाघ', 'Tiger'),
      ('चीता', 'Cheetah'),
      ('तेंदुआ', 'Leopard'),
      ('भालू', 'Bear'),
      ('भेड़िया', 'Wolf'),
      ('लोमड़ी', 'Fox'),
      ('हिरण', 'Deer'),
      ('घोड़ा', 'Horse'),
      ('गाय', 'Cow'),
      ('भैंस', 'Buffalo'),
      ('बकरी', 'Goat'),
      ('भेड़', 'Sheep'),
      ('ऊंट', 'Camel'),
      ('गधा', 'Donkey'),
      ('खरगोश', 'Rabbit'),
      ('चूहा', 'Mouse'),
      ('गिलहरी', 'Squirrel'),
      ('सांप', 'Snake'),
      ('मगरमच्छ', 'Crocodile'),
      ('कछुआ', 'Turtle'),
      ('मेंढक', 'Frog'),
      ('मछली', 'Fish'),
      ('डॉल्फिन', 'Dolphin'),
      ('व्हेल', 'Whale'),
      ('शार्क', 'Shark'),
      ('ऑक्टोपस', 'Octopus'),
      ('केकड़ा', 'Crab'),
      ('समुद्री कछुआ', 'Tortoise'),
      ('तोता', 'Parrot'),
      ('कबूतर', 'Pigeon'),
      ('कौआ', 'Crow'),
      ('मोर', 'Peacock'),
      ('बतख', 'Duck'),
      ('मुर्गी', 'Hen'),
      ('चील', 'Eagle'),
      ('उल्लू', 'Owl'),
      ('पेंगुइन', 'Penguin'),
      ('जिराफ', 'Giraffe'),
      ('ज़ेब्रा', 'Zebra'),
      ('गैंडा', 'Rhino'),
      ('दरियाई घोड़ा', 'Hippo'),
      ('कंगारू', 'Kangaroo'),
      ('पांडा', 'Panda'),
      ('कोआला', 'Koala'),
      ('गोरिल्ला', 'Gorilla'),
      ('चींटी', 'Ant'),
      ('तितली', 'Butterfly'),
    ]),
    CategoryOption.places =>
      _wordList(category, Icons.location_city_rounded, const [
        ('स्कूल', 'School'),
        ('मंदिर', 'Temple'),
        ('पार्क', 'Park'),
        ('होटल', 'Hotel'),
        ('रेलवे स्टेशन', 'Railway Station'),
        ('बस स्टैंड', 'Bus Stand'),
        ('एयरपोर्ट', 'Airport'),
        ('अस्पताल', 'Hospital'),
        ('बैंक', 'Bank'),
        ('बाजार', 'Market'),
        ('मॉल', 'Mall'),
        ('सिनेमा हॉल', 'Cinema Hall'),
        ('रेस्टोरेंट', 'Restaurant'),
        ('कैफे', 'Cafe'),
        ('लाइब्रेरी', 'Library'),
        ('कॉलेज', 'College'),
        ('ऑफिस', 'Office'),
        ('घर', 'Home'),
        ('छत', 'Terrace'),
        ('रसोई', 'Kitchen'),
        ('बेडरूम', 'Bedroom'),
        ('बाथरूम', 'Bathroom'),
        ('गार्डन', 'Garden'),
        ('जिम', 'Gym'),
        ('स्टेडियम', 'Stadium'),
        ('स्विमिंग पूल', 'Swimming Pool'),
        ('समुद्र तट', 'Beach'),
        ('पहाड़', 'Mountain'),
        ('जंगल', 'Forest'),
        ('रेगिस्तान', 'Desert'),
        ('झील', 'Lake'),
        ('नदी', 'River'),
        ('पुल', 'Bridge'),
        ('किला', 'Fort'),
        ('महल', 'Palace'),
        ('म्यूजियम', 'Museum'),
        ('चिड़ियाघर', 'Zoo'),
        ('पुलिस स्टेशन', 'Police Station'),
        ('पोस्ट ऑफिस', 'Post Office'),
        ('फार्म हाउस', 'Farm House'),
        ('गांव', 'Village'),
        ('शहर', 'City'),
        ('फैक्ट्री', 'Factory'),
        ('वर्कशॉप', 'Workshop'),
        ('क्लासरूम', 'Classroom'),
        ('लैब', 'Lab'),
        ('क्लिनिक', 'Clinic'),
        ('दुकान', 'Shop'),
        ('मेट्रो स्टेशन', 'Metro Station'),
        ('पेट्रोल पंप', 'Petrol Pump'),
        ('मंदिर गली', 'Temple Street'),
        ('खेल मैदान', 'Playground'),
      ]),
    CategoryOption.movies => _wordList(category, Icons.movie_rounded, const [
      ('हीरो', 'Hero'),
      ('विलेन', 'Villain'),
      ('सिनेमा', 'Cinema'),
      ('टिकट', 'Ticket'),
      ('गाना', 'Song'),
      ('डायरेक्टर', 'Director'),
      ('एक्टर', 'Actor'),
      ('एक्ट्रेस', 'Actress'),
      ('कैमरा', 'Camera'),
      ('स्क्रिप्ट', 'Script'),
      ('डायलॉग', 'Dialogue'),
      ('क्लाइमैक्स', 'Climax'),
      ('ट्रेलर', 'Trailer'),
      ('पोस्टर', 'Poster'),
      ('पॉपकॉर्न', 'Popcorn'),
      ('इंटरवल', 'Interval'),
      ('सीट', 'Seat'),
      ('स्क्रीन', 'Screen'),
      ('लाइट', 'Light'),
      ('माइक', 'Mic'),
      ('स्टूडियो', 'Studio'),
      ('सेट', 'Set'),
      ('कॉस्ट्यूम', 'Costume'),
      ('मेकअप', 'Makeup'),
      ('डांस', 'Dance'),
      ('एक्शन', 'Action'),
      ('कॉमेडी', 'Comedy'),
      ('रोमांस', 'Romance'),
      ('हॉरर', 'Horror'),
      ('थ्रिलर', 'Thriller'),
      ('ड्रामा', 'Drama'),
      ('सस्पेंस', 'Suspense'),
      ('म्यूजिक', 'Music'),
      ('फाइट सीन', 'Fight Scene'),
      ('कार चेज', 'Car Chase'),
      ('हीरोइन', 'Heroine'),
      ('साइडकिक', 'Sidekick'),
      ('कॉमेडियन', 'Comedian'),
      ('प्रोड्यूसर', 'Producer'),
      ('एडिटर', 'Editor'),
      ('ऑडिशन', 'Audition'),
      ('रीमेक', 'Remake'),
      ('सीक्वल', 'Sequel'),
      ('ब्लॉकबस्टर', 'Blockbuster'),
      ('फ्लॉप', 'Flop'),
      ('अवार्ड', 'Award'),
      ('रेड कार्पेट', 'Red Carpet'),
      ('फिल्म फेस्टिवल', 'Film Festival'),
      ('डबिंग', 'Dubbing'),
      ('सबटाइटल', 'Subtitle'),
      ('बैकग्राउंड म्यूजिक', 'Background Music'),
      ('क्लैप बोर्ड', 'Clapboard'),
    ]),
    CategoryOption.objects => _wordList(category, Icons.widgets_rounded, const [
      ('मोबाइल', 'Mobile'),
      ('कुर्सी', 'Chair'),
      ('किताब', 'Book'),
      ('घड़ी', 'Watch'),
      ('बैग', 'Bag'),
      ('पेन', 'Pen'),
      ('पेंसिल', 'Pencil'),
      ('रबर', 'Eraser'),
      ('कॉपी', 'Notebook'),
      ('लैपटॉप', 'Laptop'),
      ('कंप्यूटर', 'Computer'),
      ('कीबोर्ड', 'Keyboard'),
      ('माउस', 'Mouse'),
      ('चार्जर', 'Charger'),
      ('हेडफोन', 'Headphones'),
      ('स्पीकर', 'Speaker'),
      ('टीवी', 'TV'),
      ('रिमोट', 'Remote'),
      ('पंखा', 'Fan'),
      ('बल्ब', 'Bulb'),
      ('दरवाज़ा', 'Door'),
      ('खिड़की', 'Window'),
      ('टेबल', 'Table'),
      ('बोतल', 'Bottle'),
      ('गिलास', 'Glass'),
      ('प्लेट', 'Plate'),
      ('चम्मच', 'Spoon'),
      ('कांटा', 'Fork'),
      ('चाकू', 'Knife'),
      ('जूते', 'Shoes'),
      ('चप्पल', 'Slippers'),
      ('टोपी', 'Cap'),
      ('चश्मा', 'Glasses'),
      ('छाता', 'Umbrella'),
      ('ताला', 'Lock'),
      ('चाबी', 'Key'),
      ('कंघी', 'Comb'),
      ('आईना', 'Mirror'),
      ('तकिया', 'Pillow'),
      ('कंबल', 'Blanket'),
      ('साबुन', 'Soap'),
      ('ब्रश', 'Brush'),
      ('टूथपेस्ट', 'Toothpaste'),
      ('कैंची', 'Scissors'),
      ('रस्सी', 'Rope'),
      ('बाल्टी', 'Bucket'),
      ('झाड़ू', 'Broom'),
      ('कैमरा', 'Camera'),
      ('वॉलेट', 'Wallet'),
      ('सूटकेस', 'Suitcase'),
      ('कैलेंडर', 'Calendar'),
      ('टॉर्च', 'Torch'),
    ]),
    CategoryOption.custom =>
      _wordList(category, Icons.extension_rounded, const [
        ('दोस्त', 'Friend'),
        ('खेल', 'Game'),
        ('रहस्य', 'Mystery'),
        ('सवाल', 'Question'),
        ('जवाब', 'Answer'),
        ('पार्टी', 'Party'),
        ('हंसी', 'Laughter'),
        ('झूठ', 'Lie'),
        ('सच', 'Truth'),
        ('प्लान', 'Plan'),
        ('टीम', 'Team'),
        ('चैलेंज', 'Challenge'),
        ('इनाम', 'Prize'),
        ('हार', 'Defeat'),
        ('जीत', 'Win'),
        ('मिशन', 'Mission'),
        ('कोड', 'Code'),
        ('पासवर्ड', 'Password'),
        ('क्लू', 'Clue'),
        ('जासूस', 'Detective'),
        ('सीक्रेट', 'Secret'),
        ('सरप्राइज', 'Surprise'),
        ('मस्ती', 'Fun'),
        ('डर', 'Fear'),
        ('हिम्मत', 'Courage'),
        ('याद', 'Memory'),
        ('सपना', 'Dream'),
        ('कहानी', 'Story'),
        ('मैसेज', 'Message'),
        ('कॉल', 'Call'),
        ('फोटो', 'Photo'),
        ('वीडियो', 'Video'),
        ('म्यूजिक', 'Music'),
        ('डांस', 'Dance'),
        ('हॉबी', 'Hobby'),
        ('टैलेंट', 'Talent'),
        ('नियम', 'Rule'),
        ('टाइम', 'Time'),
        ('नक्शा', 'Map'),
        ('रास्ता', 'Path'),
        ('मौसम', 'Weather'),
        ('बारिश', 'Rain'),
        ('धूप', 'Sunshine'),
        ('रात', 'Night'),
        ('सुबह', 'Morning'),
        ('शाम', 'Evening'),
        ('त्योहार', 'Festival'),
        ('यात्रा', 'Trip'),
        ('गिफ्ट', 'Gift'),
        ('मुकाबला', 'Contest'),
        ('मजाक', 'Joke'),
        ('पहेली', 'Puzzle'),
      ]),
  };
}

String _categoryKey(CategoryOption category) {
  return switch (category) {
    CategoryOption.food => 'food',
    CategoryOption.animals => 'animals',
    CategoryOption.places => 'places',
    CategoryOption.movies => 'movies',
    CategoryOption.objects => 'objects',
    CategoryOption.custom => 'custom',
  };
}

String _wordAssetKey(String english) {
  final lower = english.toLowerCase();
  final normalized = lower.replaceAll(RegExp(r'[^a-z0-9]+'), '_');
  return normalized.replaceAll(RegExp(r'^_+|_+$'), '');
}
