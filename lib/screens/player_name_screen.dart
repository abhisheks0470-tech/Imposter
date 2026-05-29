import 'package:flutter/material.dart';

import '../localization/app_language.dart';
import '../models/game_setup_data.dart';
import '../theme/neon_theme.dart';
import '../theme/premium_assets.dart';
import '../widgets/neon_widgets.dart';
import 'player_reveal_screen.dart';

class PlayerNameScreen extends StatefulWidget {
  const PlayerNameScreen({required this.setupData, super.key});

  final GameSetupData setupData;

  @override
  State<PlayerNameScreen> createState() => _PlayerNameScreenState();
}

class _PlayerNameScreenState extends State<PlayerNameScreen> {
  late final List<TextEditingController> _controllers;

  AppLanguage get _language => widget.setupData.language;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.setupData.playersCount,
      (_) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NeonScaffold(
      child: Column(
        children: [
          NeonHeader(
            language: _language,
            onBack: () => Navigator.of(context).pop(),
            title: nt(_language, hi: 'प्लेयर नाम', en: 'Player Names'),
          ),
          SizedBox(height: sh(context, 14)),
          StepperPills(language: _language, current: 2),
          SizedBox(height: sh(context, 16)),
          Row(
            children: [
              Image.asset(
                PremiumAssets.mascotClipboard,
                height: sh(context, 190).clamp(76, 112),
                fit: BoxFit.contain,
              ),
              SizedBox(width: sw(context, 18)),
              Expanded(
                child: Text(
                  nt(
                    _language,
                    hi: 'खिलाड़ियों के नाम जोड़ें',
                    en: 'Add player names',
                  ),
                  style: NeonTheme.heading(context, _language, size: 72),
                ),
              ),
            ],
          ),
          SizedBox(height: sh(context, 12)),
          Row(
            children: [
              Expanded(
                child: NeonButton(
                  key: const ValueKey('use_default_names'),
                  label: nt(_language, hi: 'डिफॉल्ट नाम', en: 'Default Names'),
                  language: _language,
                  icon: Icons.auto_fix_high_rounded,
                  variant: NeonButtonVariant.purple,
                  height: sh(context, 104).clamp(58, 64),
                  onTap: _fillDefaultNames,
                ),
              ),
              SizedBox(width: sw(context, 14)),
              NeonCard(
                padding: EdgeInsets.symmetric(
                  horizontal: sw(context, 22),
                  vertical: sh(context, 12),
                ),
                borderColor: NeonTheme.neonBlue,
                child: Text(
                  '${_controllers.length}',
                  style: NeonTheme.title(
                    context,
                    AppLanguage.english,
                    size: 34,
                    color: NeonTheme.gold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: sh(context, 16)),
          Expanded(
            child: ListView.separated(
              physics: _controllers.length <= 6
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              itemCount: _controllers.length,
              separatorBuilder: (_, index) => SizedBox(height: sh(context, 12)),
              itemBuilder: (context, index) {
                return _NameField(
                  key: ValueKey('name_row_$index'),
                  language: _language,
                  index: index,
                  controller: _controllers[index],
                  hint: _defaultName(index),
                );
              },
            ),
          ),
          SizedBox(height: sh(context, 14)),
          NeonButton(
            label: nt(
              _language,
              hi: 'अगला: शब्द बाँटें',
              en: 'Next: Reveal Words',
            ),
            language: _language,
            icon: Icons.visibility_rounded,
            onTap: _startReveal,
          ),
        ],
      ),
    );
  }

  String _defaultName(int index) {
    return nt(_language, hi: 'प्लेयर ${index + 1}', en: 'Player ${index + 1}');
  }

  void _fillDefaultNames() {
    setState(() {
      for (var i = 0; i < _controllers.length; i++) {
        _controllers[i].text = _defaultName(i);
      }
    });
  }

  void _startReveal() {
    final names = <String>[];
    for (var i = 0; i < _controllers.length; i++) {
      final name = _controllers[i].text.trim();
      names.add(name.isEmpty ? _defaultName(i) : name);
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PlayerRevealScreen(
          revealData: PlayerRevealData(
            setup: widget.setupData,
            playerNames: names,
          ),
        ),
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({
    required this.language,
    required this.index,
    required this.controller,
    required this.hint,
    super.key,
  });

  final AppLanguage language;
  final int index;
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      padding: EdgeInsets.symmetric(
        horizontal: sw(context, 22),
        vertical: sh(context, 14),
      ),
      child: Row(
        children: [
          _Avatar(index: index),
          SizedBox(width: sw(context, 18)),
          Expanded(
            child: TextField(
              key: ValueKey('player_name_$index'),
              controller: controller,
              style: NeonTheme.body(
                context,
                language,
                size: 40,
                color: NeonTheme.textWhite,
                weight: FontWeight.w900,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: NeonTheme.body(
                  context,
                  language,
                  size: 40,
                  color: NeonTheme.textMuted,
                ),
              ),
            ),
          ),
          Image.asset(
            PremiumAssets.iconPencil,
            width: sp(context, 50),
            height: sp(context, 50),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = [
      NeonTheme.neonPink,
      NeonTheme.neonBlue,
      NeonTheme.gold,
      NeonTheme.green,
      NeonTheme.neonPurple,
      NeonTheme.orange,
    ];
    final color = colors[index % colors.length];
    return Container(
      width: sp(context, 72),
      height: sp(context, 72),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, NeonTheme.cardDarker]),
        border: Border.all(color: color, width: 2),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.48), blurRadius: 14),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(sp(context, 12)),
        child: Image.asset(PremiumAssets.iconPlayers, fit: BoxFit.contain),
      ),
    );
  }
}
