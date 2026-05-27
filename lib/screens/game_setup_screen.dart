import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../localization/app_language.dart';
import '../models/game_setup_data.dart';
import 'player_name_screen.dart';
import '../theme/app_colors.dart';
import '../widgets/app_background.dart';

class GameSetupScreen extends StatefulWidget {
  const GameSetupScreen({super.key});

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  static const int _minPlayers = 3;
  static const int _maxPlayers = 12;
  static const int _minImposters = 1;

  int _players = 4;
  int _imposters = 1;
  CategoryOption _category = CategoryOption.food;
  bool _wordImageEnabled = true;

  int get _maxImposters => math.max(_minImposters, _players - 1);

  @override
  Widget build(BuildContext context) {
    final language = AppLanguageScope.of(context).language;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: AppBackground()),
          Positioned.fill(
            child: CustomPaint(painter: const _SetupGlowPainter()),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final horizontalPadding = width < 380 ? 16.0 : 24.0;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      14,
                      horizontalPadding,
                      24,
                    ),
                    child: Column(
                      children: [
                        _SetupHeader(language: language),
                        const SizedBox(height: 24),
                        _SetupHero(language: language),
                        const SizedBox(height: 22),
                        _CounterSection(
                          decreaseKey: const ValueKey('players_decrease'),
                          increaseKey: const ValueKey('players_increase'),
                          icon: Icons.groups_rounded,
                          iconGradient: const [
                            Color(0xFFFF4DA7),
                            Color(0xFF8015B5),
                          ],
                          title: _t(language, hi: 'प्लेयर्स', en: 'Players'),
                          subtitle: _t(
                            language,
                            hi: 'कुल कितने खिलाड़ी खेलेंगे?',
                            en: 'How many players will play?',
                          ),
                          value: _players,
                          helper:
                              '$_minPlayers - $_maxPlayers ${_t(language, hi: 'प्लेयर्स', en: 'players')}',
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
                          onIncrease: () {
                            setState(() {
                              _players++;
                            });
                          },
                        ),
                        const SizedBox(height: 14),
                        _CounterSection(
                          decreaseKey: const ValueKey('imposters_decrease'),
                          increaseKey: const ValueKey('imposters_increase'),
                          icon: Icons.theater_comedy_rounded,
                          iconGradient: const [
                            Color(0xFFFF2A8F),
                            Color(0xFF7B0B78),
                          ],
                          title: _t(language, hi: 'इम्पोस्टर', en: 'Imposter'),
                          subtitle: _t(
                            language,
                            hi: 'कितने इम्पोस्टर होंगे?',
                            en: 'How many imposters?',
                          ),
                          value: _imposters,
                          helper:
                              '$_minImposters - $_maxImposters ${_t(language, hi: 'इम्पोस्टर', en: 'imposters')}',
                          canDecrease: _imposters > _minImposters,
                          canIncrease: _imposters < _maxImposters,
                          onDecrease: () {
                            setState(() {
                              _imposters--;
                            });
                          },
                          onIncrease: () {
                            setState(() {
                              _imposters++;
                            });
                          },
                        ),
                        const SizedBox(height: 14),
                        _ChoiceSection<CategoryOption>(
                          icon: Icons.category_rounded,
                          iconGradient: const [
                            Color(0xFF52F25E),
                            Color(0xFF086F1A),
                          ],
                          title: _t(language, hi: 'कैटेगरी', en: 'Category'),
                          subtitle: _t(
                            language,
                            hi: 'किस टॉपिक पर खेलना है?',
                            en: 'Choose a topic to play.',
                          ),
                          values: CategoryOption.values,
                          selectedValue: _category,
                          labelBuilder: (value) =>
                              _categoryLabel(value, language),
                          onSelected: (value) {
                            setState(() {
                              _category = value;
                            });
                          },
                        ),
                        const SizedBox(height: 14),
                        _ChoiceSection<AppLanguage>(
                          icon: Icons.translate_rounded,
                          iconGradient: const [
                            Color(0xFF20C8FF),
                            Color(0xFF1542B8),
                          ],
                          title: _t(language, hi: 'भाषा', en: 'Language'),
                          subtitle: _t(
                            language,
                            hi: 'किस भाषा में खेलना है?',
                            en: 'Choose game language.',
                          ),
                          values: AppLanguage.values,
                          selectedValue: language,
                          labelBuilder: (value) =>
                              value == AppLanguage.hindi ? 'Hindi' : 'English',
                          onSelected: (value) {
                            AppLanguageScope.of(context).setLanguage(value);
                          },
                        ),
                        const SizedBox(height: 14),
                        _SwitchSection(
                          icon: Icons.image_rounded,
                          iconGradient: const [
                            Color(0xFF25F0CF),
                            Color(0xFF066C88),
                          ],
                          title: _t(
                            language,
                            hi: 'वर्ड इमेज',
                            en: 'Word Image',
                          ),
                          subtitle: _t(
                            language,
                            hi: 'क्या शब्द के साथ तस्वीर दिखानी है?',
                            en: 'Show an image with the word?',
                          ),
                          value: _wordImageEnabled,
                          switchKey: const ValueKey('word_image_switch'),
                          onChanged: (value) {
                            setState(() {
                              _wordImageEnabled = value;
                            });
                          },
                          language: language,
                        ),
                        const SizedBox(height: 24),
                        _SetupCtaButton(
                          label: _t(language, hi: 'आगे बढ़ें', en: 'Next'),
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

String _t(AppLanguage language, {required String hi, required String en}) {
  return AppStrings.pick(language, hi: hi, en: en);
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

class _SetupHeader extends StatelessWidget {
  const _SetupHeader({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _RoundBackButton(onTap: () => Navigator.of(context).pop()),
        const SizedBox(width: 18),
        Expanded(
          child: _StepIndicator(
            currentStep: 1,
            labels: [
              _t(language, hi: 'सेटअप', en: 'Setup'),
              _t(language, hi: 'खिलाड़ी', en: 'Players'),
              _t(language, hi: 'खेल शुरू', en: 'Start'),
            ],
          ),
        ),
      ],
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep, required this.labels});

  final int currentStep;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 74,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            left: 44,
            right: 44,
            top: 24,
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFF56138E),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < labels.length; i++)
                _StepDot(
                  number: i + 1,
                  label: labels[i],
                  active: i + 1 == currentStep,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.number,
    required this.label,
    required this.active,
  });

  final int number;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: active
                ? const RadialGradient(
                    colors: [Color(0xFFFFEE5D), Color(0xFFFF8D00)],
                  )
                : const RadialGradient(
                    colors: [Color(0xFF3F145D), Color(0xFF130526)],
                  ),
            border: Border.all(
              color: active ? AppColors.hindiGold : AppColors.purpleBorder,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: active
                    ? const Color(0xCCFF9D00)
                    : AppColors.purpleShadow,
                blurRadius: 16,
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$number',
              style: TextStyle(
                color: active ? const Color(0xFF200018) : Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: active ? AppColors.hindiGold : const Color(0xFFC8B4E8),
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _SetupHero extends StatelessWidget {
  const _SetupHero({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomPaint(
          painter: const _SetupSpyPainter(),
          size: const Size(122, 132),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Stack(
                  children: [
                    Text(
                      _t(language, hi: 'गेम सेटअप', en: 'Game Setup'),
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 6
                          ..color = const Color(0xFF1A0025),
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Colors.white,
                          Color(0xFFE9E2FF),
                          AppColors.hindiGold,
                        ],
                      ).createShader(bounds),
                      child: Text(
                        _t(language, hi: 'गेम सेटअप', en: 'Game Setup'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          shadows: [
                            Shadow(
                              color: Color(0xAA000000),
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                _t(
                  language,
                  hi: 'अपना गेम तैयार करें',
                  en: 'Prepare your game',
                ),
                style: const TextStyle(
                  color: Color(0xFFD3B7F3),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CounterSection extends StatelessWidget {
  const _CounterSection({
    required this.decreaseKey,
    required this.increaseKey,
    required this.icon,
    required this.iconGradient,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.helper,
    required this.canDecrease,
    required this.canIncrease,
    required this.onDecrease,
    required this.onIncrease,
  });

  final Key decreaseKey;
  final Key increaseKey;
  final IconData icon;
  final List<Color> iconGradient;
  final String title;
  final String subtitle;
  final int value;
  final String helper;
  final bool canDecrease;
  final bool canIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return _SetupCard(
      icon: icon,
      iconGradient: iconGradient,
      title: title,
      subtitle: subtitle,
      trailing: _CounterControl(
        value: value,
        helper: helper,
        canDecrease: canDecrease,
        canIncrease: canIncrease,
        decreaseKey: decreaseKey,
        increaseKey: increaseKey,
        onDecrease: onDecrease,
        onIncrease: onIncrease,
      ),
    );
  }
}

class _ChoiceSection<T> extends StatelessWidget {
  const _ChoiceSection({
    required this.icon,
    required this.iconGradient,
    required this.title,
    required this.subtitle,
    required this.values,
    required this.selectedValue,
    required this.labelBuilder,
    required this.onSelected,
  });

  final IconData icon;
  final List<Color> iconGradient;
  final String title;
  final String subtitle;
  final List<T> values;
  final T selectedValue;
  final String Function(T value) labelBuilder;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return _SetupCard(
      icon: icon,
      iconGradient: iconGradient,
      title: title,
      subtitle: subtitle,
      trailing: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.end,
        children: [
          for (final value in values)
            _NeonChoiceChip(
              key: ValueKey('choice_${value.toString()}'),
              label: labelBuilder(value),
              selected: value == selectedValue,
              onTap: () => onSelected(value),
            ),
        ],
      ),
    );
  }
}

class _SwitchSection extends StatelessWidget {
  const _SwitchSection({
    required this.icon,
    required this.iconGradient,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.switchKey,
    required this.onChanged,
    required this.language,
  });

  final IconData icon;
  final List<Color> iconGradient;
  final String title;
  final String subtitle;
  final bool value;
  final Key switchKey;
  final ValueChanged<bool> onChanged;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return _SetupCard(
      icon: icon,
      iconGradient: iconGradient,
      title: title,
      subtitle: subtitle,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _NeonSwitch(key: switchKey, value: value, onChanged: onChanged),
          const SizedBox(width: 12),
          Text(
            value
                ? _t(language, hi: 'ऑन', en: 'On')
                : _t(language, hi: 'ऑफ', en: 'Off'),
            style: const TextStyle(
              color: AppColors.hindiGold,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _SetupCard extends StatelessWidget {
  const _SetupCard({
    required this.icon,
    required this.iconGradient,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final IconData icon;
  final List<Color> iconGradient;
  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xD50A092A),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF65309C), width: 1.8),
        boxShadow: const [
          BoxShadow(color: Color(0x66000000), offset: Offset(0, 8)),
          BoxShadow(color: Color(0x665A15B8), blurRadius: 18),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = constraints.maxWidth < 430;

          final label = Row(
            children: [
              _SectionIcon(icon: icon, gradient: iconGradient),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        height: 1,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFFC7A8E7),
                        fontSize: 15,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );

          if (stacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                label,
                const SizedBox(height: 14),
                Align(alignment: Alignment.centerRight, child: trailing),
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: label),
              const SizedBox(width: 14),
              Flexible(
                child: Align(alignment: Alignment.centerRight, child: trailing),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionIcon extends StatelessWidget {
  const _SectionIcon({required this.icon, required this.gradient});

  final IconData icon;
  final List<Color> gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.26),
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(color: Color(0xAA000000), offset: Offset(0, 5)),
          BoxShadow(color: Color(0xAAFF2DAE), blurRadius: 13),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 40),
    );
  }
}

class _CounterControl extends StatelessWidget {
  const _CounterControl({
    required this.value,
    required this.helper,
    required this.canDecrease,
    required this.canIncrease,
    required this.decreaseKey,
    required this.increaseKey,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int value;
  final String helper;
  final bool canDecrease;
  final bool canIncrease;
  final Key decreaseKey;
  final Key increaseKey;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CounterButton(
              key: decreaseKey,
              icon: Icons.remove_rounded,
              enabled: canDecrease,
              onTap: onDecrease,
            ),
            SizedBox(
              width: 72,
              child: Text(
                '$value',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            _CounterButton(
              key: increaseKey,
              icon: Icons.add_rounded,
              enabled: canIncrease,
              onTap: onIncrease,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          helper,
          style: const TextStyle(
            color: Color(0xFFC7A8E7),
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: enabled ? onTap : null,
        child: Ink(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: enabled
                  ? const [Color(0xFFB642FF), Color(0xFF5411A4)]
                  : const [Color(0xFF332047), Color(0xFF1B1225)],
            ),
            border: Border.all(
              color: enabled
                  ? const Color(0xFFC96DFF)
                  : const Color(0xFF4A335E),
              width: 2,
            ),
            boxShadow: enabled
                ? const [BoxShadow(color: Color(0xAA922AFF), blurRadius: 14)]
                : null,
          ),
          child: Icon(
            icon,
            color: enabled
                ? Colors.white
                : Colors.white.withValues(alpha: 0.35),
            size: 34,
          ),
        ),
      ),
    );
  }
}

class _NeonChoiceChip extends StatelessWidget {
  const _NeonChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: selected
                ? const LinearGradient(
                    colors: [Color(0xFFFFE22A), Color(0xFFFFA000)],
                  )
                : const LinearGradient(
                    colors: [Color(0xFF130031), Color(0xFF09001B)],
                  ),
            border: Border.all(
              color: selected ? AppColors.startBorder : AppColors.purpleBorder,
              width: 1.8,
            ),
            boxShadow: selected
                ? const [BoxShadow(color: Color(0xCCFFB000), blurRadius: 15)]
                : const [
                    BoxShadow(color: AppColors.purpleShadow, blurRadius: 9),
                  ],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? const Color(0xFF2C0014) : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _NeonSwitch extends StatelessWidget {
  const _NeonSwitch({required this.value, required this.onChanged, super.key});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 82,
          height: 44,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: LinearGradient(
              colors: value
                  ? const [Color(0xFF29D94E), Color(0xFF0AA12B)]
                  : const [Color(0xFF32124E), Color(0xFF160727)],
            ),
            border: Border.all(
              color: value ? const Color(0xFF70FF89) : AppColors.purpleBorder,
              width: 2,
            ),
            boxShadow: const [
              BoxShadow(color: Color(0xAA31F262), blurRadius: 12),
            ],
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 180),
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF0ECFA),
                boxShadow: [
                  BoxShadow(color: Color(0x88000000), offset: Offset(0, 3)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SetupCtaButton extends StatefulWidget {
  const _SetupCtaButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_SetupCtaButton> createState() => _SetupCtaButtonState();
}

class _SetupCtaButtonState extends State<_SetupCtaButton> {
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
                  colors: [
                    Color(0xFFFFF04A),
                    Color(0xFFFFBB1A),
                    Color(0xFFFF8D00),
                  ],
                ),
                border: Border.all(color: AppColors.startBorder, width: 2.5),
                boxShadow: const [
                  BoxShadow(color: Color(0xCCFF9D00), blurRadius: 20),
                  BoxShadow(color: Color(0x99000000), offset: Offset(0, 8)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.sports_esports_rounded,
                    color: Color(0xFF4A0030),
                    size: 38,
                  ),
                  const SizedBox(width: 14),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.label,
                        style: const TextStyle(
                          color: Color(0xFF6A2100),
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFF6A2100),
                    size: 30,
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

class _SetupGlowPainter extends CustomPainter {
  const _SetupGlowPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final glow = Paint()
      ..color = const Color(0x332E0C90)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22);
    canvas.drawCircle(Offset(size.width * 0.22, size.height * 0.22), 82, glow);
    canvas.drawCircle(Offset(size.width * 0.83, size.height * 0.42), 95, glow);

    final markStyle = TextStyle(
      color: const Color(0xFF6D20C4).withValues(alpha: 0.18),
      fontSize: 52,
      fontWeight: FontWeight.w900,
    );
    for (final point in [
      const Offset(0.08, 0.16),
      const Offset(0.58, 0.13),
      const Offset(0.88, 0.2),
      const Offset(0.93, 0.34),
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

class _SetupSpyPainter extends CustomPainter {
  const _SetupSpyPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final hoodPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF5B18B9), Color(0xFF110020)],
      ).createShader(Offset.zero & size);
    final outline = Paint()
      ..color = AppColors.blackOutline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeJoin = StrokeJoin.round;

    final hood = Path()
      ..moveTo(size.width * 0.14, size.height * 0.92)
      ..quadraticBezierTo(
        size.width * 0.08,
        size.height * 0.2,
        size.width * 0.5,
        size.height * 0.06,
      )
      ..quadraticBezierTo(
        size.width * 0.88,
        size.height * 0.22,
        size.width * 0.8,
        size.height * 0.9,
      )
      ..close();
    canvas.drawPath(hood, outline);
    canvas.drawPath(hood, hoodPaint);

    final faceCenter = Offset(size.width * 0.5, size.height * 0.36);
    canvas.drawCircle(
      faceCenter,
      size.width * 0.22,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(faceCenter, size.width * 0.22, outline);
    final eyePaint = Paint()..color = AppColors.blackOutline;
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.35, size.height * 0.31)
        ..quadraticBezierTo(
          size.width * 0.46,
          size.height * 0.37,
          size.width * 0.51,
          size.height * 0.3,
        )
        ..quadraticBezierTo(
          size.width * 0.42,
          size.height * 0.27,
          size.width * 0.35,
          size.height * 0.31,
        ),
      eyePaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.65, size.height * 0.31)
        ..quadraticBezierTo(
          size.width * 0.54,
          size.height * 0.37,
          size.width * 0.49,
          size.height * 0.3,
        )
        ..quadraticBezierTo(
          size.width * 0.58,
          size.height * 0.27,
          size.width * 0.65,
          size.height * 0.31,
        ),
      eyePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.49, size.height * 0.43),
      Offset(size.width * 0.45, size.height * 0.5),
      outline,
    );

    final glassCenter = Offset(size.width * 0.79, size.height * 0.41);
    canvas.drawCircle(
      glassCenter,
      size.width * 0.13,
      Paint()..color = const Color(0xFF005AAE),
    );
    canvas.drawCircle(
      glassCenter,
      size.width * 0.13,
      Paint()
        ..color = AppColors.hindiGold
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );
    canvas.drawLine(
      glassCenter + const Offset(-3, 16),
      Offset(size.width * 0.67, size.height * 0.76),
      Paint()
        ..color = const Color(0xFFFFB000)
        ..strokeWidth = 7
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
