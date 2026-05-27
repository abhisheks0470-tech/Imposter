import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../localization/app_language.dart';
import '../models/game_setup_data.dart';
import '../theme/app_colors.dart';
import '../widgets/app_background.dart';
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
    final accentColor = _isCorrect
        ? const Color(0xFF45F75D)
        : AppColors.neonPink;
    final imposterNames = _realImposterNames();

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: AppBackground()),
          Positioned.fill(
            child: CustomPaint(
              painter: _ResultGlowPainter(isCorrect: _isCorrect),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontalPadding = constraints.maxWidth < 380
                    ? 16.0
                    : 22.0;

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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _TopBar(
                            language: _language,
                            onBack: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(height: 26),
                          _HeroHeader(
                            language: _language,
                            isCorrect: _isCorrect,
                            accentColor: accentColor,
                          ),
                          const SizedBox(height: 24),
                          _MainResultCard(
                            language: _language,
                            isCorrect: _isCorrect,
                            accentColor: accentColor,
                          ),
                          const SizedBox(height: 16),
                          _InfoCard(
                            label: _t(
                              _language,
                              hi: 'आपकी पसंद',
                              en: 'Your Vote',
                            ),
                            value: resultData.selectedPlayerName,
                            icon: Icons.how_to_vote_rounded,
                            accentColor: accentColor,
                          ),
                          const SizedBox(height: 12),
                          _InfoCard(
                            label: _t(
                              _language,
                              hi: 'असली इम्पोस्टर',
                              en: 'Real Imposter',
                            ),
                            value: imposterNames.join(', '),
                            icon: Icons.masks_rounded,
                            accentColor: AppColors.neonPink,
                          ),
                          const SizedBox(height: 12),
                          _SecretWordCard(
                            language: _language,
                            setup: _setup,
                            word: _data.secretWord.label(_language),
                          ),
                          const SizedBox(height: 24),
                          _PrimaryActionButton(
                            key: const ValueKey('play_again_button'),
                            label: _t(
                              _language,
                              hi: 'फिर से खेलें',
                              en: 'Play Again',
                            ),
                            icon: Icons.replay_rounded,
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute<void>(
                                  builder: (_) =>
                                      PlayerNameScreen(setupData: _setup),
                                ),
                                (route) => false,
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _SecondaryActionButton(
                                  key: const ValueKey('change_setup_button'),
                                  label: _t(
                                    _language,
                                    hi: 'सेटअप बदलें',
                                    en: 'Change Setup',
                                  ),
                                  icon: Icons.tune_rounded,
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
                              const SizedBox(width: 12),
                              Expanded(
                                child: _SecondaryActionButton(
                                  key: const ValueKey('home_button'),
                                  label: _t(_language, hi: 'होम', en: 'Home'),
                                  icon: Icons.home_rounded,
                                  onTap: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute<void>(
                                        builder: (_) => const HomeScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                ),
                              ),
                            ],
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

  List<String> _realImposterNames() {
    final sortedIndexes = _data.imposterIndexes.toList()..sort();
    return [
      for (final index in sortedIndexes)
        if (index >= 0 && index < _data.playerNames.length)
          _data.playerNames[index],
    ];
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.language, required this.onBack});

  final AppLanguage language;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _RoundBackButton(onTap: onBack),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [Color(0xCC26005D), Color(0xAA14002F)],
            ),
            border: Border.all(color: AppColors.purpleBorder, width: 1.8),
            boxShadow: const [
              BoxShadow(color: AppColors.purpleShadow, blurRadius: 16),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.emoji_events_rounded,
                color: AppColors.startYellow,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                _t(language, hi: 'रिजल्ट', en: 'Result'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
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
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              colors: [Color(0xFF2B075A), Color(0xFF130029)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: AppColors.purpleBorder, width: 2),
            boxShadow: const [
              BoxShadow(color: AppColors.purpleShadow, blurRadius: 18),
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

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({
    required this.language,
    required this.isCorrect,
    required this.accentColor,
  });

  final AppLanguage language;
  final bool isCorrect;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 118,
          height: 118,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                accentColor.withValues(alpha: 0.55),
                const Color(0xFF09001D),
              ],
            ),
            border: Border.all(color: accentColor, width: 3),
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.55),
                blurRadius: 28,
              ),
              const BoxShadow(color: AppColors.purpleShadow, blurRadius: 22),
            ],
          ),
          child: Icon(
            isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: Colors.white,
            size: 68,
          ),
        ),
        const SizedBox(height: 16),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Stack(
            children: [
              Text(
                _t(language, hi: 'रिजल्ट', en: 'Result'),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 6
                    ..color = AppColors.blackOutline,
                ),
              ),
              Text(
                _t(language, hi: 'रिजल्ट', en: 'Result'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  shadows: [
                    Shadow(color: AppColors.purpleShadow, blurRadius: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isCorrect
              ? _t(language, hi: 'सही पकड़ा!', en: 'Caught Correctly!')
              : _t(language, hi: 'गलत अंदाज़ा!', en: 'Wrong Guess!'),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: accentColor,
            fontSize: 25,
            fontWeight: FontWeight.w900,
            shadows: [
              Shadow(
                color: accentColor.withValues(alpha: 0.55),
                blurRadius: 14,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MainResultCard extends StatelessWidget {
  const _MainResultCard({
    required this.language,
    required this.isCorrect,
    required this.accentColor,
  });

  final AppLanguage language;
  final bool isCorrect;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: _neonCardDecoration(
        borderColor: accentColor,
        glowColor: accentColor,
      ),
      child: Column(
        children: [
          Icon(
            isCorrect ? Icons.verified_rounded : Icons.warning_rounded,
            color: accentColor,
            size: 58,
          ),
          const SizedBox(height: 14),
          Text(
            isCorrect
                ? _t(
                    language,
                    hi: 'आपने सही इम्पोस्टर चुना',
                    en: 'You selected the correct imposter',
                  )
                : _t(
                    language,
                    hi: 'यह खिलाड़ी इम्पोस्टर नहीं था',
                    en: 'This player was not the imposter',
                  ),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              height: 1.18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _neonCardDecoration(
        borderColor: accentColor,
        glowColor: accentColor,
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              gradient: LinearGradient(
                colors: [
                  accentColor.withValues(alpha: 0.95),
                  const Color(0xFF15002D),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.45),
                  blurRadius: 18,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFFDCC9FF),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    height: 1.1,
                    fontWeight: FontWeight.w900,
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

class _SecretWordCard extends StatelessWidget {
  const _SecretWordCard({
    required this.language,
    required this.setup,
    required this.word,
  });

  final AppLanguage language;
  final GameSetupData setup;
  final String word;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _neonCardDecoration(
        borderColor: AppColors.startYellow,
        glowColor: AppColors.startGlow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.lock_open_rounded,
                color: AppColors.startYellow,
                size: 28,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  _t(language, hi: 'गुप्त शब्द', en: 'Secret Word'),
                  style: const TextStyle(
                    color: Color(0xFFDCC9FF),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              word,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.startYellow,
                fontSize: 42,
                fontWeight: FontWeight.w900,
                shadows: [Shadow(color: AppColors.startGlow, blurRadius: 18)],
              ),
            ),
          ),
          if (setup.wordImageEnabled) ...[
            const SizedBox(height: 16),
            Container(
              width: 124,
              height: 104,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const RadialGradient(
                  colors: [Color(0xFF36136C), Color(0xFF090018)],
                ),
                border: Border.all(color: AppColors.startYellow, width: 2),
                boxShadow: const [
                  BoxShadow(color: AppColors.startGlow, blurRadius: 18),
                ],
              ),
              child: Icon(
                _categoryIcon(setup.category),
                color: AppColors.startYellow,
                size: 58,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Ink(
          height: 66,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              colors: [
                AppColors.startYellow,
                AppColors.startOrange,
                AppColors.startPink,
              ],
            ),
            border: Border.all(color: AppColors.startBorder, width: 2.4),
            boxShadow: const [
              BoxShadow(
                color: AppColors.startGlow,
                blurRadius: 24,
                offset: Offset(0, 5),
              ),
              BoxShadow(
                color: Color(0xAA000000),
                blurRadius: 0,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: const Color(0xFF4A1600), size: 32),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF5A1800),
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecondaryActionButton extends StatelessWidget {
  const _SecondaryActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          height: 60,
          decoration: _neonCardDecoration(
            borderColor: AppColors.purpleBorder,
            glowColor: AppColors.purpleShadow,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.taglineCyan, size: 25),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultGlowPainter extends CustomPainter {
  const _ResultGlowPainter({required this.isCorrect});

  final bool isCorrect;

  @override
  void paint(Canvas canvas, Size size) {
    final accent = isCorrect ? const Color(0xFF45F75D) : AppColors.neonPink;
    final center = Offset(size.width * 0.5, size.height * 0.25);
    final glowPaint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              accent.withValues(alpha: 0.24),
              AppColors.backgroundPurple.withValues(alpha: 0.16),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(center: center, radius: size.width * 0.72),
          );
    canvas.drawCircle(center, size.width * 0.72, glowPaint);

    final rayPaint = Paint()
      ..color = accent.withValues(alpha: 0.15)
      ..strokeWidth = 2;
    for (var i = 0; i < 18; i++) {
      final angle = (math.pi * 2 / 18) * i;
      canvas.drawLine(
        center,
        Offset(
          center.dx + math.cos(angle) * size.width,
          center.dy + math.sin(angle) * size.width,
        ),
        rayPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ResultGlowPainter oldDelegate) {
    return oldDelegate.isCorrect != isCorrect;
  }
}

BoxDecoration _neonCardDecoration({
  Color borderColor = AppColors.purpleBorder,
  Color glowColor = AppColors.purpleShadow,
}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(24),
    gradient: const LinearGradient(
      colors: [Color(0xF0180038), Color(0xEE060016)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    border: Border.all(color: borderColor, width: 1.8),
    boxShadow: [
      BoxShadow(color: glowColor.withValues(alpha: 0.48), blurRadius: 18),
      const BoxShadow(
        color: Color(0xAA000000),
        blurRadius: 16,
        offset: Offset(0, 8),
      ),
    ],
  );
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

String _t(AppLanguage language, {required String hi, required String en}) {
  return language == AppLanguage.hindi ? hi : en;
}
