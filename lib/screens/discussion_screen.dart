import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../localization/app_language.dart';
import '../models/game_setup_data.dart';
import '../theme/app_colors.dart';
import '../widgets/app_background.dart';
import 'voting_screen.dart';

class DiscussionScreen extends StatelessWidget {
  const DiscussionScreen({required this.discussionData, super.key});

  final DiscussionData discussionData;

  AppLanguage get _language => discussionData.setup.language;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: AppBackground()),
          Positioned.fill(
            child: CustomPaint(painter: const _DiscussionGlowPainter()),
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
                          _HeroHeader(language: _language),
                          const SizedBox(height: 24),
                          _InstructionCard(
                            icon: Icons.record_voice_over_rounded,
                            accentColor: AppColors.startYellow,
                            title: _t(
                              _language,
                              hi: 'संकेत दें',
                              en: 'Give Hints',
                            ),
                            message: _t(
                              _language,
                              hi: 'हर खिलाड़ी अपने शब्द के बारे में संकेत देगा, लेकिन शब्द का नाम सीधे नहीं बोलना है।',
                              en: 'Each player gives hints about their word, but no one should say the word directly.',
                            ),
                          ),
                          const SizedBox(height: 14),
                          _InstructionCard(
                            icon: Icons.hearing_rounded,
                            accentColor: AppColors.taglineCyan,
                            title: _t(
                              _language,
                              hi: 'ध्यान से सुनें',
                              en: 'Listen Closely',
                            ),
                            message: _t(
                              _language,
                              hi: 'ध्यान से सुनें और पता लगाएं कि कौन इम्पोस्टर है।',
                              en: 'Listen carefully and find out who the imposter is.',
                            ),
                          ),
                          const SizedBox(height: 14),
                          _InstructionCard(
                            icon: Icons.masks_rounded,
                            accentColor: AppColors.neonPink,
                            title: _t(
                              _language,
                              hi: 'इम्पोस्टर सावधान',
                              en: 'Imposter Alert',
                            ),
                            message: _t(
                              _language,
                              hi: 'इम्पोस्टर दूसरों के संकेत सुनकर खुद को बचाने की कोशिश करेगा।',
                              en: "The imposter will listen to others' hints and try to blend in.",
                            ),
                          ),
                          const SizedBox(height: 18),
                          _SummaryPanel(data: discussionData),
                          const SizedBox(height: 24),
                          _PrimaryActionButton(
                            key: const ValueKey('start_voting_button'),
                            label: _t(
                              _language,
                              hi: 'वोटिंग शुरू करें',
                              en: 'Start Voting',
                            ),
                            icon: Icons.how_to_vote_rounded,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => VotingScreen(
                                    discussionData: discussionData,
                                  ),
                                ),
                              );
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
                Icons.forum_rounded,
                color: AppColors.startYellow,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                _t(language, hi: 'चर्चा', en: 'Discuss'),
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
  const _HeroHeader({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 116,
          height: 116,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [Color(0xFF421091), Color(0xFF09001D)],
            ),
            border: Border.all(color: AppColors.magentaGlow, width: 3),
            boxShadow: const [
              BoxShadow(color: AppColors.purpleShadow, blurRadius: 28),
              BoxShadow(color: Color(0x88FF1E7D), blurRadius: 18),
            ],
          ),
          child: const Icon(
            Icons.question_answer_rounded,
            color: AppColors.startYellow,
            size: 60,
          ),
        ),
        const SizedBox(height: 16),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Stack(
            children: [
              Text(
                _t(language, hi: 'चर्चा का समय', en: 'Discussion Time'),
                style: TextStyle(
                  fontSize: 46,
                  fontWeight: FontWeight.w900,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 6
                    ..color = AppColors.blackOutline,
                ),
              ),
              Text(
                _t(language, hi: 'चर्चा का समय', en: 'Discussion Time'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 46,
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
          _t(
            language,
            hi: 'अब सभी खिलाड़ी संकेत देंगे',
            en: 'Now all players will give hints',
          ),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFE3CAFF),
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _InstructionCard extends StatelessWidget {
  const _InstructionCard({
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final Color accentColor;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _neonCardDecoration(
        borderColor: accentColor,
        glowColor: accentColor.withValues(alpha: 0.34),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  color: accentColor.withValues(alpha: 0.5),
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
                  title,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xFFEFE8FF),
                    fontSize: 17,
                    height: 1.32,
                    fontWeight: FontWeight.w700,
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

class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel({required this.data});

  final DiscussionData data;

  @override
  Widget build(BuildContext context) {
    final language = data.setup.language;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _neonCardDecoration(
        borderColor: AppColors.purpleBorder,
        glowColor: AppColors.purpleShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.summarize_rounded,
                color: AppColors.startYellow,
                size: 26,
              ),
              const SizedBox(width: 8),
              Text(
                _t(language, hi: 'गेम सारांश', en: 'Game Summary'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _SummaryRow(
            label: _t(language, hi: 'प्लेयर्स', en: 'Players'),
            value: '${data.playerNames.length}',
            icon: Icons.groups_rounded,
          ),
          const SizedBox(height: 10),
          _SummaryRow(
            label: _t(language, hi: 'इम्पोस्टर', en: 'Imposter'),
            value: '${data.imposterIndexes.length}',
            icon: Icons.masks_rounded,
          ),
          const SizedBox(height: 10),
          _SummaryRow(
            label: _t(language, hi: 'कैटेगरी', en: 'Category'),
            value: _categoryLabel(data.setup.category, language),
            icon: Icons.category_rounded,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xAA080019),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x885D16BE), width: 1.4),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.taglineCyan, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFFD9C5FF),
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.startYellow,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
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

class _DiscussionGlowPainter extends CustomPainter {
  const _DiscussionGlowPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.28);
    final glowPaint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              AppColors.magentaGlow.withValues(alpha: 0.26),
              AppColors.backgroundPurple.withValues(alpha: 0.14),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(center: center, radius: size.width * 0.72),
          );
    canvas.drawCircle(center, size.width * 0.72, glowPaint);

    final rayPaint = Paint()
      ..color = AppColors.purpleBorder.withValues(alpha: 0.16)
      ..strokeWidth = 2;
    for (var i = 0; i < 16; i++) {
      final angle = (math.pi * 2 / 16) * i;
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
      BoxShadow(color: glowColor.withValues(alpha: 0.55), blurRadius: 18),
      const BoxShadow(
        color: Color(0xAA000000),
        blurRadius: 16,
        offset: Offset(0, 8),
      ),
    ],
  );
}

String _categoryLabel(CategoryOption category, AppLanguage language) {
  return switch (category) {
    CategoryOption.food => _t(language, hi: 'खाना', en: 'Food'),
    CategoryOption.animals => _t(language, hi: 'जानवर', en: 'Animals'),
    CategoryOption.places => _t(language, hi: 'जगहें', en: 'Places'),
    CategoryOption.movies => _t(language, hi: 'फिल्में', en: 'Movies'),
    CategoryOption.objects => _t(language, hi: 'चीजें', en: 'Objects'),
    CategoryOption.custom => _t(language, hi: 'कस्टम', en: 'Custom'),
  };
}

String _t(AppLanguage language, {required String hi, required String en}) {
  return language == AppLanguage.hindi ? hi : en;
}
