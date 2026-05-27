import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../localization/app_language.dart';
import '../models/game_setup_data.dart';
import '../theme/app_colors.dart';
import '../widgets/app_background.dart';
import 'result_screen.dart';

class VotingScreen extends StatefulWidget {
  const VotingScreen({required this.discussionData, super.key});

  final DiscussionData discussionData;

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  int? _selectedIndex;

  DiscussionData get _data => widget.discussionData;
  AppLanguage get _language => _data.setup.language;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: AppBackground()),
          Positioned.fill(
            child: CustomPaint(painter: const _VotingGlowPainter()),
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
                          _InstructionCard(language: _language),
                          const SizedBox(height: 18),
                          ...List.generate(_data.playerNames.length, (index) {
                            final isSelected = _selectedIndex == index;
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: index == _data.playerNames.length - 1
                                    ? 0
                                    : 12,
                              ),
                              child: _PlayerVoteCard(
                                key: ValueKey('player_vote_card_$index'),
                                language: _language,
                                index: index,
                                playerName: _data.playerNames[index],
                                isSelected: isSelected,
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = index;
                                  });
                                },
                              ),
                            );
                          }),
                          if (_selectedIndex != null) ...[
                            const SizedBox(height: 16),
                            _SelectedSummary(
                              language: _language,
                              playerName: _data.playerNames[_selectedIndex!],
                            ),
                          ],
                          const SizedBox(height: 24),
                          _PrimaryActionButton(
                            key: const ValueKey('see_result_button'),
                            language: _language,
                            onTap: _handleSeeResult,
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

  void _handleSeeResult() {
    final selectedIndex = _selectedIndex;
    if (selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _t(
              _language,
              hi: 'पहले एक खिलाड़ी चुनें',
              en: 'Please select a player first',
            ),
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF2B075A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.neonPink, width: 1.4),
          ),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ResultScreen(
          resultData: VotingResultData(
            discussionData: _data,
            selectedPlayerIndex: selectedIndex,
          ),
        ),
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
                Icons.how_to_vote_rounded,
                color: AppColors.startYellow,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                _t(language, hi: 'वोट', en: 'Vote'),
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
          width: 112,
          height: 112,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [Color(0xFF4B0AA0), Color(0xFF09001D)],
            ),
            border: Border.all(color: AppColors.startYellow, width: 3),
            boxShadow: const [
              BoxShadow(color: AppColors.startGlow, blurRadius: 24),
              BoxShadow(color: AppColors.purpleShadow, blurRadius: 22),
            ],
          ),
          child: const Icon(
            Icons.how_to_vote_rounded,
            color: Colors.white,
            size: 58,
          ),
        ),
        const SizedBox(height: 16),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Stack(
            children: [
              Text(
                _t(language, hi: 'वोटिंग', en: 'Voting'),
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
                _t(language, hi: 'वोटिंग', en: 'Voting'),
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
          _t(language, hi: 'आपको किस पर शक है?', en: 'Who do you suspect?'),
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
  const _InstructionCard({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _neonCardDecoration(
        borderColor: AppColors.taglineCyan,
        glowColor: const Color(0x8839D9FF),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              gradient: const LinearGradient(
                colors: [AppColors.cyanGlow, Color(0xFF15002D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: const [
                BoxShadow(color: Color(0x8839D9FF), blurRadius: 18),
              ],
            ),
            child: const Icon(
              Icons.psychology_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              _t(
                language,
                hi: 'सभी खिलाड़ी चर्चा के बाद उस खिलाड़ी को चुनें जो आपको इम्पोस्टर लगता है।',
                en: 'After discussion, choose the player you think is the imposter.',
              ),
              style: const TextStyle(
                color: Color(0xFFEFE8FF),
                fontSize: 18,
                height: 1.32,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerVoteCard extends StatelessWidget {
  const _PlayerVoteCard({
    required this.language,
    required this.index,
    required this.playerName,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final AppLanguage language;
  final int index;
  final String playerName;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? AppColors.startYellow
        : AppColors.purpleBorder;
    final glowColor = isSelected ? AppColors.startGlow : AppColors.purpleShadow;
    final playerLabel = _t(
      language,
      hi: 'खिलाड़ी ${index + 1} — $playerName',
      en: 'Player ${index + 1} — $playerName',
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          constraints: const BoxConstraints(minHeight: 76),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: _neonCardDecoration(
            borderColor: borderColor,
            glowColor: glowColor,
            isSelected: isSelected,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isSelected
                        ? const [AppColors.startYellow, AppColors.startOrange]
                        : const [Color(0xFF4A13A6), Color(0xFF16002F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.startBorder
                        : AppColors.purpleBorder,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: glowColor.withValues(alpha: 0.55),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF4A1600) : Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  playerLabel,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected ? AppColors.startYellow : Colors.white,
                    fontSize: 20,
                    height: 1.1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                isSelected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: isSelected
                    ? AppColors.startYellow
                    : const Color(0xFFB99BFF),
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedSummary extends StatelessWidget {
  const _SelectedSummary({required this.language, required this.playerName});

  final AppLanguage language;
  final String playerName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xAA080019),
        border: Border.all(color: AppColors.startYellow, width: 1.6),
        boxShadow: const [
          BoxShadow(color: AppColors.startGlow, blurRadius: 14),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_rounded,
            color: AppColors.startYellow,
            size: 25,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _t(
                language,
                hi: 'आपने $playerName को चुना है',
                en: 'You selected $playerName',
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800,
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
    required this.language,
    required this.onTap,
    super.key,
  });

  final AppLanguage language;
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
              const Icon(
                Icons.visibility_rounded,
                color: Color(0xFF4A1600),
                size: 32,
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  _t(language, hi: 'रिजल्ट देखें', en: 'See Result'),
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

class _VotingGlowPainter extends CustomPainter {
  const _VotingGlowPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.24);
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.startGlow.withValues(alpha: 0.26),
          AppColors.backgroundPurple.withValues(alpha: 0.16),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: size.width * 0.7));
    canvas.drawCircle(center, size.width * 0.7, glowPaint);

    final rayPaint = Paint()
      ..color = AppColors.purpleBorder.withValues(alpha: 0.16)
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

BoxDecoration _neonCardDecoration({
  Color borderColor = AppColors.purpleBorder,
  Color glowColor = AppColors.purpleShadow,
  bool isSelected = false,
}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(24),
    gradient: LinearGradient(
      colors: isSelected
          ? const [Color(0xF02B1048), Color(0xF213002B)]
          : const [Color(0xF0180038), Color(0xEE060016)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    border: Border.all(color: borderColor, width: isSelected ? 2.4 : 1.8),
    boxShadow: [
      BoxShadow(color: glowColor.withValues(alpha: 0.58), blurRadius: 18),
      const BoxShadow(
        color: Color(0xAA000000),
        blurRadius: 16,
        offset: Offset(0, 8),
      ),
    ],
  );
}

String _t(AppLanguage language, {required String hi, required String en}) {
  return language == AppLanguage.hindi ? hi : en;
}
