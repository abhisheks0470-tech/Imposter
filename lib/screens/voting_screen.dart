import 'package:flutter/material.dart';

import '../localization/app_language.dart';
import '../models/game_setup_data.dart';
import '../navigation/safe_navigation.dart';
import '../theme/neon_theme.dart';
import '../widgets/neon_widgets.dart';
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
    return NeonScaffold(
      child: Column(
        children: [
          NeonHeader(
            language: _language,
            title: nt(_language, hi: 'वोटिंग', en: 'Voting'),
            onBack: () => safeBackOrHome(context),
          ),
          SizedBox(height: sh(context, 20)),
          Text(
            nt(_language, hi: 'वोटिंग शुरू करें', en: 'Start Voting'),
            textAlign: TextAlign.center,
            style: NeonTheme.heading(context, _language, size: 84),
          ),
          Text(
            nt(
              _language,
              hi: 'जिसे इम्पोस्टर समझते हैं उसे चुनें',
              en: 'Choose who you suspect',
            ),
            textAlign: TextAlign.center,
            style: NeonTheme.body(
              context,
              _language,
              size: 34,
              color: NeonTheme.gold,
              weight: FontWeight.w900,
            ),
          ),
          SizedBox(height: sh(context, 18)),
          NeonCard(
            borderColor: NeonTheme.neonBlue,
            padding: EdgeInsets.symmetric(
              horizontal: sw(context, 22),
              vertical: sh(context, 14),
            ),
            child: Text(
              nt(
                _language,
                hi: 'सभी खिलाड़ी चर्चा के बाद उस खिलाड़ी को चुनें जो आपको इम्पोस्टर लगता है।',
                en: 'After discussion, choose the player you think is the imposter.',
              ),
              textAlign: TextAlign.center,
              style: NeonTheme.body(
                context,
                _language,
                size: 29,
                color: NeonTheme.textWhite,
              ),
            ),
          ),
          SizedBox(height: sh(context, 16)),
          Expanded(
            child: ListView.separated(
              physics: _data.playerNames.length <= 6
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              itemCount: _data.playerNames.length,
              separatorBuilder: (_, index) => SizedBox(height: sh(context, 10)),
              itemBuilder: (context, index) {
                final selected = _selectedIndex == index;
                return PlayerRow(
                  key: ValueKey('player_vote_card_$index'),
                  language: _language,
                  index: index,
                  name: _data.playerNames[index],
                  selected: selected,
                  onTap: () => setState(() => _selectedIndex = index),
                  trailing: Icon(
                    selected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: selected ? NeonTheme.gold : NeonTheme.textMuted,
                    size: sp(context, 54),
                  ),
                );
              },
            ),
          ),
          if (_selectedIndex != null) ...[
            SizedBox(height: sh(context, 10)),
            Text(
              nt(
                _language,
                hi: 'आपने ${_data.playerNames[_selectedIndex!]} को चुना है',
                en: 'You selected ${_data.playerNames[_selectedIndex!]}',
              ),
              style: NeonTheme.body(
                context,
                _language,
                size: 26,
                color: NeonTheme.gold,
                weight: FontWeight.w900,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          SizedBox(height: sh(context, 12)),
          Row(
            children: [
              Expanded(
                child: NeonButton(
                  key: const ValueKey('see_result_button'),
                  label: nt(_language, hi: 'वोट सबमिट करें', en: 'Submit Vote'),
                  language: _language,
                  onTap: _handleSubmit,
                ),
              ),
              SizedBox(width: sw(context, 14)),
              Expanded(
                child: NeonButton(
                  label: nt(_language, hi: 'फिर से सोचें', en: 'Think Again'),
                  language: _language,
                  variant: NeonButtonVariant.purple,
                  onTap: () => setState(() => _selectedIndex = null),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleSubmit() {
    final selectedIndex = _selectedIndex;
    if (selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            nt(
              _language,
              hi: 'पहले एक खिलाड़ी चुनें',
              en: 'Please select a player first',
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: NeonTheme.cardDark,
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
