import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../localization/app_language.dart';
import '../models/game_setup_data.dart';
import '../theme/app_colors.dart';
import '../widgets/app_background.dart';
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
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: AppBackground()),
          Positioned.fill(
            child: CustomPaint(painter: const _RevealGlowPainter()),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final horizontalPadding = width < 380 ? 16.0 : 24.0;

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        14,
                        horizontalPadding,
                        24,
                      ),
                      child: Column(
                        children: [
                          _TopBar(
                            language: _language,
                            playerName: _topPlayerName,
                            onBack: () => Navigator.of(context).pop(),
                            onHelp: () => _showHelpDialog(context),
                            onSettings: () => _showSettingsDialog(context),
                          ),
                          const SizedBox(height: 24),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            child: switch (_phase) {
                              _RevealPhase.prompt => _PromptContent(
                                key: const ValueKey('prompt'),
                                language: _language,
                                playerName: _currentPlayer,
                                currentIndex: _currentIndex,
                                totalPlayers: _players.length,
                                onReveal: () {
                                  setState(() {
                                    _phase = _RevealPhase.revealed;
                                  });
                                },
                              ),
                              _RevealPhase.revealed => _RevealedContent(
                                key: const ValueKey('revealed'),
                                language: _language,
                                playerName: _currentPlayer,
                                currentIndex: _currentIndex,
                                totalPlayers: _players.length,
                                isImposter: _currentIsImposter,
                                word: _secretWord,
                                showWordImage: _setup.wordImageEnabled,
                                onGotIt: _handleGotIt,
                              ),
                              _RevealPhase.transition => _TransitionContent(
                                key: const ValueKey('transition'),
                                language: _language,
                                nextPlayerName: _players[_currentIndex + 1],
                                currentIndex: _currentIndex,
                                totalPlayers: _players.length,
                                onNextPlayer: _openNextPlayerPrompt,
                              ),
                              _RevealPhase.complete => _CompleteContent(
                                key: const ValueKey('complete'),
                                language: _language,
                                totalPlayers: _players.length,
                                onStartDiscussion: _openDiscussion,
                              ),
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String get _topPlayerName {
    if (_phase == _RevealPhase.transition &&
        _currentIndex + 1 < _players.length) {
      return _players[_currentIndex + 1];
    }
    if (_phase == _RevealPhase.complete) {
      return _t(_language, hi: 'तैयार', en: 'Ready');
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
    showDialog<void>(
      context: context,
      builder: (context) => _NeonDialog(
        title: _t(_language, hi: 'कैसे खेलें?', en: 'How to Play?'),
        message: _t(
          _language,
          hi: 'हर खिलाड़ी अपना शब्द या रोल अकेले देखे। इम्पोस्टर को शब्द नहीं मिलेगा। संकेत दें, नाम मत बोलें।',
          en: 'Each player privately checks their word or role. Imposters do not get the word. Give hints, but do not say the name.',
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => _NeonDialog(
        title: _t(_language, hi: 'विकल्प', en: 'Settings'),
        message: _t(
          _language,
          hi: 'विकल्प जल्द उपलब्ध होंगे।',
          en: 'Settings will be available later.',
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.language,
    required this.playerName,
    required this.onBack,
    required this.onHelp,
    required this.onSettings,
  });

  final AppLanguage language;
  final String playerName;
  final VoidCallback onBack;
  final VoidCallback onHelp;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _RoundBackButton(onTap: onBack),
        const SizedBox(width: 14),
        const _PlayerAvatar(),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            playerName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        _TopIconButton(
          icon: Icons.help_rounded,
          label: _t(language, hi: 'कैसे खेलें?', en: 'How to Play?'),
          onTap: onHelp,
        ),
        const SizedBox(width: 8),
        _TopIconButton(
          icon: Icons.settings_rounded,
          label: _t(language, hi: 'विकल्प', en: 'Settings'),
          onTap: onSettings,
        ),
      ],
    );
  }
}

class _PromptContent extends StatelessWidget {
  const _PromptContent({
    required this.language,
    required this.playerName,
    required this.currentIndex,
    required this.totalPlayers,
    required this.onReveal,
    super.key,
  });

  final AppLanguage language;
  final String playerName;
  final int currentIndex;
  final int totalPlayers;
  final VoidCallback onReveal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MainHeading(
          title: _t(language, hi: 'प्राइवेट रिवील', en: 'Private Reveal'),
          subtitle: _t(
            language,
            hi: 'फोन सिर्फ इसी खिलाड़ी को दें',
            en: 'Give the phone only to this player',
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: _cardDecoration(),
          child: Column(
            children: [
              const _SpyVisual(size: 150),
              const SizedBox(height: 22),
              Text(
                playerName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.hindiGold,
                  fontSize: 42,
                  height: 1,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                _t(
                  language,
                  hi: 'तैयार हों, फिर अपना सीक्रेट देखें।',
                  en: 'Get ready, then reveal your secret.',
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.78),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        _PrimaryNeonButton(
          key: const ValueKey('tap_to_reveal_button'),
          label: _t(language, hi: 'देखें', en: 'Tap to Reveal'),
          icon: Icons.visibility_rounded,
          onTap: onReveal,
        ),
        const SizedBox(height: 20),
        _ProgressFooter(
          language: language,
          currentIndex: currentIndex,
          totalPlayers: totalPlayers,
        ),
      ],
    );
  }
}

class _RevealedContent extends StatelessWidget {
  const _RevealedContent({
    required this.language,
    required this.playerName,
    required this.currentIndex,
    required this.totalPlayers,
    required this.isImposter,
    required this.word,
    required this.showWordImage,
    required this.onGotIt,
    super.key,
  });

  final AppLanguage language;
  final String playerName;
  final int currentIndex;
  final int totalPlayers;
  final bool isImposter;
  final _SecretWord word;
  final bool showWordImage;
  final VoidCallback onGotIt;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MainHeading(
          title: isImposter
              ? _t(language, hi: 'आप इम्पोस्टर हैं', en: 'You are the Imposter')
              : _t(language, hi: 'आपका शब्द', en: 'Your Word'),
          subtitle: _t(
            language,
            hi: 'किसी को मत दिखाइए',
            en: 'Do not show anyone',
          ),
        ),
        const SizedBox(height: 22),
        if (isImposter) ...[
          _ImposterSecretCard(language: language),
          const SizedBox(height: 16),
          _ImposterInfoCards(language: language),
        ] else ...[
          _WordSecretCard(
            language: language,
            word: word,
            showWordImage: showWordImage,
          ),
          const SizedBox(height: 16),
          _PrivacyWarning(language: language),
          const SizedBox(height: 16),
          _PhoneWarning(language: language),
        ],
        const SizedBox(height: 22),
        _PrimaryNeonButton(
          key: const ValueKey('got_it_button'),
          label: _t(language, hi: 'समझ गया', en: 'Got it'),
          icon: Icons.visibility_off_rounded,
          onTap: onGotIt,
        ),
        const SizedBox(height: 20),
        _ProgressFooter(
          language: language,
          currentIndex: currentIndex,
          totalPlayers: totalPlayers,
        ),
      ],
    );
  }
}

class _TransitionContent extends StatelessWidget {
  const _TransitionContent({
    required this.language,
    required this.nextPlayerName,
    required this.currentIndex,
    required this.totalPlayers,
    required this.onNextPlayer,
    super.key,
  });

  final AppLanguage language;
  final String nextPlayerName;
  final int currentIndex;
  final int totalPlayers;
  final VoidCallback onNextPlayer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MainHeading(
          title: _t(language, hi: 'सीक्रेट छुप गया', en: 'Secret Hidden'),
          subtitle: _t(
            language,
            hi: 'फोन अगले खिलाड़ी को दें',
            en: 'Pass the phone to the next player',
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: _cardDecoration(),
          child: Column(
            children: [
              const Icon(
                Icons.lock_rounded,
                color: AppColors.hindiGold,
                size: 74,
              ),
              const SizedBox(height: 18),
              Text(
                nextPlayerName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        _SecondaryNeonButton(
          key: const ValueKey('next_player_button'),
          label: _t(language, hi: 'अगला खिलाड़ी', en: 'Next Player'),
          onTap: onNextPlayer,
        ),
        const SizedBox(height: 20),
        _ProgressFooter(
          language: language,
          currentIndex: currentIndex,
          totalPlayers: totalPlayers,
        ),
      ],
    );
  }
}

class _CompleteContent extends StatelessWidget {
  const _CompleteContent({
    required this.language,
    required this.totalPlayers,
    required this.onStartDiscussion,
    super.key,
  });

  final AppLanguage language;
  final int totalPlayers;
  final VoidCallback onStartDiscussion;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MainHeading(
          title: _t(language, hi: 'सब तैयार हैं', en: 'Everyone is Ready'),
          subtitle: _t(
            language,
            hi: 'सभी खिलाड़ी तैयार हैं',
            en: 'All players are ready',
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: _cardDecoration(borderColor: AppColors.cyanGlow),
          child: Column(
            children: [
              const Icon(
                Icons.forum_rounded,
                color: AppColors.taglineCyan,
                size: 86,
              ),
              const SizedBox(height: 18),
              Text(
                _t(
                  language,
                  hi: 'अब चर्चा करके इम्पोस्टर पहचानें।',
                  en: 'Discuss and find the imposter.',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        _PrimaryNeonButton(
          key: const ValueKey('start_discussion_button'),
          label: _t(language, hi: 'चर्चा शुरू करें', en: 'Start Discussion'),
          icon: Icons.forum_rounded,
          onTap: onStartDiscussion,
        ),
        const SizedBox(height: 20),
        _ProgressFooter(
          language: language,
          currentIndex: totalPlayers - 1,
          totalPlayers: totalPlayers,
        ),
      ],
    );
  }
}

class _MainHeading extends StatelessWidget {
  const _MainHeading({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Stack(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 6
                    ..color = const Color(0xFF16001F),
                ),
              ),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Colors.white,
                    Color(0xFFF5F0FF),
                    AppColors.hindiGold,
                  ],
                ).createShader(bounds),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    shadows: [
                      Shadow(color: Color(0xAA000000), offset: Offset(0, 4)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFD8B8FF),
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _WordSecretCard extends StatelessWidget {
  const _WordSecretCard({
    required this.language,
    required this.word,
    required this.showWordImage,
  });

  final AppLanguage language;
  final _SecretWord word;
  final bool showWordImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(borderColor: AppColors.magentaGlow),
      child: Column(
        children: [
          const Icon(
            Icons.verified_user_rounded,
            color: Colors.white,
            size: 46,
          ),
          const SizedBox(height: 14),
          Text(
            _t(language, hi: 'आपका गुप्त शब्द है', en: 'Your secret word is'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFDDB6FF),
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            word.label(language),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.hindiGold,
              fontSize: 56,
              height: 1,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(color: Color(0xAA000000), offset: Offset(0, 5)),
                Shadow(color: Color(0xAAFF9D00), blurRadius: 16),
              ],
            ),
          ),
          if (showWordImage) ...[
            const SizedBox(height: 22),
            _WordVisual(icon: word.icon, danger: false),
          ],
        ],
      ),
    );
  }
}

class _ImposterSecretCard extends StatelessWidget {
  const _ImposterSecretCard({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
      decoration: _cardDecoration(borderColor: AppColors.neonPink),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(painter: const _DangerRaysPainter()),
          ),
          Column(
            children: [
              const Icon(
                Icons.theater_comedy_rounded,
                color: AppColors.neonPink,
                size: 44,
              ),
              const SizedBox(height: 8),
              const _HoodedMysteryVisual(),
              const SizedBox(height: 18),
              Text(
                _t(
                  language,
                  hi: 'आपका गुप्त रोल है',
                  en: 'Your secret role is',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFFFA3F4),
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _t(language, hi: 'इम्पोस्टर', en: 'Imposter'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.neonPink,
                  fontSize: 56,
                  height: 1,
                  fontWeight: FontWeight.w900,
                  shadows: [
                    Shadow(color: Color(0xAA000000), offset: Offset(0, 5)),
                    Shadow(color: AppColors.neonPink, blurRadius: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImposterInfoCards extends StatelessWidget {
  const _ImposterInfoCards({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ImposterInfoCard(
          icon: Icons.hearing_rounded,
          text: _t(
            language,
            hi: 'दूसरों के संकेत सुनकर शब्द पहचानना है',
            en: 'Listen to others’ hints and guess the word',
          ),
        ),
        const SizedBox(height: 12),
        _ImposterInfoCard(
          icon: Icons.lock_rounded,
          text: _t(
            language,
            hi: 'आपको कोई शब्द नहीं मिलेगा',
            en: 'You will not get any word',
          ),
        ),
        const SizedBox(height: 12),
        _ImposterInfoCard(
          icon: Icons.warning_rounded,
          text: _t(
            language,
            hi: 'अपना रोल किसी को मत बताइए',
            en: 'Do not tell anyone your role',
          ),
        ),
      ],
    );
  }
}

class _ImposterInfoCard extends StatelessWidget {
  const _ImposterInfoCard({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: const Color(0xCC170014),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neonPink, width: 1.7),
        boxShadow: const [BoxShadow(color: Color(0x88FF1E7D), blurRadius: 12)],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.neonPink, size: 34),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                height: 1.2,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WordVisual extends StatelessWidget {
  const _WordVisual({required this.icon, required this.danger});

  final IconData icon;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 154,
      height: 112,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: RadialGradient(
          colors: danger
              ? const [Color(0xFFFF2CA9), Color(0xFF21001E)]
              : const [Color(0xFFFFB323), Color(0xFF3A1300)],
        ),
        border: Border.all(
          color: danger ? AppColors.neonPink : AppColors.hindiGold,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: danger ? AppColors.neonPink : const Color(0xCCFF9D00),
            blurRadius: 24,
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 70),
    );
  }
}

class _HoodedMysteryVisual extends StatelessWidget {
  const _HoodedMysteryVisual();

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(
      size: Size(210, 190),
      painter: _HoodedMysteryPainter(),
    );
  }
}

class _DangerRaysPainter extends CustomPainter {
  const _DangerRaysPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.45);
    final rayPaint = Paint()..color = const Color(0x26FF1E7D);
    for (var i = 0; i < 20; i++) {
      final angle = -math.pi + (math.pi * 2 / 20) * i;
      final left =
          center +
          Offset(math.cos(angle - 0.025), math.sin(angle - 0.025)) * 24;
      final right =
          center +
          Offset(math.cos(angle + 0.025), math.sin(angle + 0.025)) * 24;
      final tip =
          center + Offset(math.cos(angle), math.sin(angle)) * size.height;
      canvas.drawPath(
        Path()
          ..moveTo(left.dx, left.dy)
          ..lineTo(tip.dx, tip.dy)
          ..lineTo(right.dx, right.dy)
          ..close(),
        rayPaint,
      );
    }

    final questionStyle = TextStyle(
      color: AppColors.neonPink.withValues(alpha: 0.34),
      fontSize: 42,
      fontWeight: FontWeight.w900,
    );
    for (final point in [
      const Offset(0.16, 0.22),
      const Offset(0.78, 0.2),
      const Offset(0.23, 0.52),
      const Offset(0.83, 0.55),
    ]) {
      final painter = TextPainter(
        text: TextSpan(text: '?', style: questionStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(
        canvas,
        Offset(point.dx * size.width, point.dy * size.height),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HoodedMysteryPainter extends CustomPainter {
  const _HoodedMysteryPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final glowPaint = Paint()
      ..color = AppColors.neonPink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);
    final outline = Paint()
      ..color = AppColors.blackOutline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeJoin = StrokeJoin.round;
    final hoodPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(0, -0.35),
        colors: [Color(0xFF2B0220), Color(0xFF08000B), Color(0xFF000004)],
      ).createShader(rect);

    final hood = Path()
      ..moveTo(size.width * 0.12, size.height * 0.92)
      ..cubicTo(
        size.width * 0.18,
        size.height * 0.26,
        size.width * 0.33,
        size.height * 0.06,
        size.width * 0.5,
        size.height * 0.04,
      )
      ..cubicTo(
        size.width * 0.67,
        size.height * 0.06,
        size.width * 0.82,
        size.height * 0.26,
        size.width * 0.88,
        size.height * 0.92,
      )
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.78,
        size.width * 0.12,
        size.height * 0.92,
      )
      ..close();

    canvas.drawPath(hood, glowPaint);
    canvas.drawPath(hood, hoodPaint);
    canvas.drawPath(hood, outline);
    canvas.drawPath(
      hood,
      Paint()
        ..color = AppColors.neonPink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    final face = Path()
      ..moveTo(size.width * 0.3, size.height * 0.76)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.28,
        size.width * 0.7,
        size.height * 0.76,
      )
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.88,
        size.width * 0.3,
        size.height * 0.76,
      )
      ..close();
    canvas.drawPath(face, Paint()..color = const Color(0xFF050008));

    final qPainter = TextPainter(
      text: const TextSpan(
        text: '?',
        style: TextStyle(
          color: Colors.white,
          fontSize: 82,
          fontWeight: FontWeight.w900,
          shadows: [
            Shadow(color: AppColors.neonPink, blurRadius: 8),
            Shadow(color: AppColors.neonPink, blurRadius: 20),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    qPainter.paint(
      canvas,
      Offset((size.width - qPainter.width) / 2, size.height * 0.31),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PrivacyWarning extends StatelessWidget {
  const _PrivacyWarning({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xCC001814),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF12A33A), width: 2),
        boxShadow: const [BoxShadow(color: Color(0xAA0AD947), blurRadius: 12)],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lightbulb_rounded,
            color: Color(0xFFD8FF00),
            size: 42,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              _t(
                language,
                hi: 'इस शब्द का संकेत देना है, नाम नहीं बोलना है।',
                en: 'Give hints about this word, but do not say the name.',
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                height: 1.25,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoneWarning extends StatelessWidget {
  const _PhoneWarning({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: const Color(0xB016003A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.purpleBorder, width: 1.6),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lock_rounded,
            color: AppColors.purpleBorder,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _t(
                language,
                hi: 'फोन छुपाकर रखें, दूसरों को स्क्रीन न दिखाएं।',
                en: 'Keep the phone hidden. Do not show the screen to others.',
              ),
              style: const TextStyle(
                color: Color(0xFFD8B8FF),
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressFooter extends StatelessWidget {
  const _ProgressFooter({
    required this.language,
    required this.currentIndex,
    required this.totalPlayers,
  });

  final AppLanguage language;
  final int currentIndex;
  final int totalPlayers;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xB016003A),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.purpleBorder, width: 1.6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${currentIndex + 1} / $totalPlayers ${_t(language, hi: 'खिलाड़ी', en: 'Players')}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 18),
          for (var i = 0; i < totalPlayers; i++)
            Container(
              width: i == currentIndex ? 14 : 12,
              height: i == currentIndex ? 14 : 12,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == currentIndex
                    ? AppColors.hindiGold
                    : const Color(0xFF38115B),
                boxShadow: i == currentIndex
                    ? const [
                        BoxShadow(color: AppColors.hindiGold, blurRadius: 10),
                      ]
                    : null,
              ),
            ),
        ],
      ),
    );
  }
}

class _PrimaryNeonButton extends StatefulWidget {
  const _PrimaryNeonButton({
    required this.label,
    required this.icon,
    required this.onTap,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  State<_PrimaryNeonButton> createState() => _PrimaryNeonButtonState();
}

class _PrimaryNeonButtonState extends State<_PrimaryNeonButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 90),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: widget.onTap,
            child: Ink(
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFFC335FF), Color(0xFF6711B5)],
                ),
                border: Border.all(color: const Color(0xFFEA78FF), width: 2.4),
                boxShadow: const [
                  BoxShadow(color: Color(0xCCB92DFF), blurRadius: 20),
                  BoxShadow(color: Color(0x99000000), offset: Offset(0, 8)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.icon, color: Colors.white, size: 38),
                  const SizedBox(width: 14),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 31,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryNeonButton extends StatelessWidget {
  const _SecondaryNeonButton({
    required this.label,
    required this.onTap,
    super.key,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: const Color(0xCC12002B),
            border: Border.all(color: AppColors.purpleBorder, width: 1.8),
            boxShadow: const [
              BoxShadow(color: AppColors.purpleShadow, blurRadius: 13),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.keyboard_double_arrow_right_rounded,
                color: Color(0xFFC46DFF),
                size: 34,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.keyboard_double_arrow_left_rounded,
                color: Color(0xFFC46DFF),
                size: 34,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopIconButton extends StatelessWidget {
  const _TopIconButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Ink(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: const Color(0xCC11002D),
                border: Border.all(color: AppColors.purpleBorder, width: 1.8),
              ),
              child: Icon(icon, color: Colors.white, size: 31),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 58,
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundBackButton extends StatelessWidget {
  const _RoundBackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Ink(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [Color(0xFF6B21D7), Color(0xFF190038)],
            ),
            border: Border.all(color: const Color(0xFFB52DFF), width: 2),
            boxShadow: const [
              BoxShadow(color: Color(0xCC8424FF), blurRadius: 16),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 34,
          ),
        ),
      ),
    );
  }
}

class _PlayerAvatar extends StatelessWidget {
  const _PlayerAvatar();

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(size: Size(58, 58), painter: _AvatarPainter());
  }
}

class _SpyVisual extends StatelessWidget {
  const _SpyVisual({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(size, size), painter: const _SpyPainter());
  }
}

class _NeonDialog extends StatelessWidget {
  const _NeonDialog({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF100027),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(color: AppColors.purpleBorder, width: 2),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(
          color: Color(0xFFD8B8FF),
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'OK',
            style: TextStyle(
              color: AppColors.hindiGold,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

BoxDecoration _cardDecoration({Color borderColor = AppColors.purpleBorder}) {
  return BoxDecoration(
    color: const Color(0xD50A092A),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: borderColor, width: 2),
    boxShadow: const [
      BoxShadow(color: Color(0x66000000), offset: Offset(0, 8)),
      BoxShadow(color: AppColors.purpleShadow, blurRadius: 22),
    ],
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

  String label(AppLanguage language) {
    return language == AppLanguage.hindi ? hindi : english;
  }
}

List<_SecretWord> _wordsForCategory(CategoryOption category) {
  return switch (category) {
    CategoryOption.food => const [
      _SecretWord(
        hindi: 'समोसा',
        english: 'Samosa',
        icon: Icons.fastfood_rounded,
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
      _SecretWord(
        hindi: 'हाथी',
        english: 'Elephant',
        icon: Icons.cruelty_free_rounded,
      ),
      _SecretWord(hindi: 'बिल्ली', english: 'Cat', icon: Icons.pets_rounded),
      _SecretWord(hindi: 'कुत्ता', english: 'Dog', icon: Icons.pets_rounded),
      _SecretWord(
        hindi: 'बंदर',
        english: 'Monkey',
        icon: Icons.emoji_nature_rounded,
      ),
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
      _SecretWord(
        hindi: 'हीरो',
        english: 'Hero',
        icon: Icons.movie_filter_rounded,
      ),
      _SecretWord(
        hindi: 'विलेन',
        english: 'Villain',
        icon: Icons.theater_comedy_rounded,
      ),
      _SecretWord(
        hindi: 'सिनेमा',
        english: 'Cinema',
        icon: Icons.movie_rounded,
      ),
      _SecretWord(
        hindi: 'टिकट',
        english: 'Ticket',
        icon: Icons.local_activity_rounded,
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

String _t(AppLanguage language, {required String hi, required String en}) {
  return AppStrings.pick(language, hi: hi, en: en);
}

class _RevealGlowPainter extends CustomPainter {
  const _RevealGlowPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final glow = Paint()
      ..color = const Color(0x332E0C90)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22);
    canvas.drawCircle(Offset(size.width * 0.25, size.height * 0.22), 90, glow);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.46), 105, glow);

    final markStyle = TextStyle(
      color: const Color(0xFF6D20C4).withValues(alpha: 0.16),
      fontSize: 56,
      fontWeight: FontWeight.w900,
    );
    for (final point in [
      const Offset(0.08, 0.18),
      const Offset(0.86, 0.2),
      const Offset(0.14, 0.72),
      const Offset(0.78, 0.78),
    ]) {
      final painter = TextPainter(
        text: TextSpan(text: '?', style: markStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(
        canvas,
        Offset(point.dx * size.width, point.dy * size.height),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AvatarPainter extends CustomPainter {
  const _AvatarPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawCircle(
      rect.center,
      size.width / 2,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFF8C24FF), Color(0xFF12001F)],
        ).createShader(rect),
    );
    canvas.drawCircle(
      rect.center,
      size.width / 2 - 1,
      Paint()
        ..color = AppColors.hindiGold
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    canvas.drawCircle(
      rect.center,
      size.width * 0.29,
      Paint()..color = Colors.white,
    );
    final eyePaint = Paint()..color = AppColors.blackOutline;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.41, size.height * 0.47),
        width: size.width * 0.17,
        height: size.height * 0.09,
      ),
      eyePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.59, size.height * 0.47),
        width: size.width * 0.17,
        height: size.height * 0.09,
      ),
      eyePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SpyPainter extends CustomPainter {
  const _SpyPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final hoodPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFF6B21D7), Color(0xFF090015)],
      ).createShader(rect);
    final outline = Paint()
      ..color = AppColors.blackOutline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeJoin = StrokeJoin.round;

    final hood = Path()
      ..moveTo(size.width * 0.17, size.height * 0.92)
      ..quadraticBezierTo(
        size.width * 0.08,
        size.height * 0.2,
        size.width * 0.5,
        size.height * 0.06,
      )
      ..quadraticBezierTo(
        size.width * 0.9,
        size.height * 0.2,
        size.width * 0.83,
        size.height * 0.92,
      )
      ..close();
    canvas.drawPath(hood, outline);
    canvas.drawPath(hood, hoodPaint);

    final faceCenter = Offset(size.width * 0.5, size.height * 0.38);
    canvas.drawCircle(
      faceCenter,
      size.width * 0.24,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(faceCenter, size.width * 0.24, outline);
    final eyePaint = Paint()..color = AppColors.blackOutline;
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.32, size.height * 0.34)
        ..quadraticBezierTo(
          size.width * 0.45,
          size.height * 0.43,
          size.width * 0.51,
          size.height * 0.33,
        )
        ..quadraticBezierTo(
          size.width * 0.42,
          size.height * 0.3,
          size.width * 0.32,
          size.height * 0.34,
        ),
      eyePaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.68, size.height * 0.34)
        ..quadraticBezierTo(
          size.width * 0.55,
          size.height * 0.43,
          size.width * 0.49,
          size.height * 0.33,
        )
        ..quadraticBezierTo(
          size.width * 0.58,
          size.height * 0.3,
          size.width * 0.68,
          size.height * 0.34,
        ),
      eyePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.47),
      Offset(size.width * 0.5, size.height * 0.7),
      Paint()
        ..color = Colors.white
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.47),
      Offset(size.width * 0.5, size.height * 0.7),
      outline..strokeWidth = 4,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
