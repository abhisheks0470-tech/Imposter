import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hindi_imposter/localization/app_language.dart';
import 'package:hindi_imposter/main.dart';
import 'package:hindi_imposter/models/game_setup_data.dart';
import 'package:hindi_imposter/screens/discussion_screen.dart';
import 'package:hindi_imposter/screens/game_setup_screen.dart';
import 'package:hindi_imposter/screens/home_screen.dart';
import 'package:hindi_imposter/screens/how_to_play_screen.dart';
import 'package:hindi_imposter/screens/player_name_screen.dart';
import 'package:hindi_imposter/screens/player_reveal_screen.dart';
import 'package:hindi_imposter/screens/result_screen.dart';
import 'package:hindi_imposter/screens/voting_screen.dart';

void main() {
  testWidgets('Home actions open How to Play and Game Setup', (tester) async {
    _usePhoneViewport(tester);
    await _pumpAppPastSplash(tester);

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Start Game'), findsOneWidget);
    expect(find.text('How to Play'), findsOneWidget);

    await tester.tap(find.text('How to Play'));
    await tester.pumpAndSettle();
    expect(find.byType(HowToPlayScreen), findsOneWidget);
    expect(find.text('कैसे खेलें?'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('header_back_button')).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start Game'));
    await tester.pumpAndSettle();
    expect(find.byType(GameSetupScreen), findsOneWidget);
  });

  testWidgets('Setup controls update and open Player Name screen', (
    tester,
  ) async {
    _usePhoneViewport(tester);
    await _pumpAppPastSplash(tester);
    await tester.tap(find.text('Start Game'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('players_increase')));
    await tester.pump();
    expect(find.text('5'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('imposters_increase')));
    await tester.pump();
    expect(find.text('2'), findsWidgets);

    await tester.tap(
      find.byKey(const ValueKey('choice_CategoryOption.animals')),
    );
    await tester.pump();
    expect(find.text('जानवर'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey('choice_AppLanguage.english')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('choice_AppLanguage.english')));
    await tester.pumpAndSettle();
    expect(find.text('Game Setup'), findsWidgets);
    expect(find.text('Next: Add Player Names'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('word_image_switch')));
    await tester.pump();

    await tester.tap(find.text('Next: Add Player Names'));
    await tester.pumpAndSettle();
    expect(find.byType(PlayerNameScreen), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(5));
  });

  testWidgets('Player names default and open private reveal', (tester) async {
    _usePhoneViewport(tester);
    await tester.pumpWidget(
      _testApp(
        PlayerNameScreen(
          setupData: _setup(language: AppLanguage.hindi, playersCount: 4),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('use_default_names')));
    await tester.pump();
    expect(find.text('प्लेयर 1'), findsWidgets);
    expect(find.text('प्लेयर 4'), findsWidgets);

    await tester.enterText(find.byKey(const ValueKey('player_name_1')), 'Asha');
    await tester.tap(find.text('अगला: शब्द बाँटें'));
    await tester.pumpAndSettle();

    expect(find.byType(PlayerRevealScreen), findsOneWidget);
    expect(find.text('फोन सिर्फ इसी खिलाड़ी को दें'), findsOneWidget);
    expect(find.byKey(const ValueKey('tap_to_reveal_button')), findsOneWidget);
  });

  testWidgets('Normal reveal hides word before next player prompt', (
    tester,
  ) async {
    _usePhoneViewport(tester);
    await tester.pumpWidget(
      _testApp(
        PlayerRevealScreen(
          revealData: PlayerRevealData(
            setup: _setup(imposterCount: 0, playersCount: 2),
            playerNames: const ['प्लेयर 1', 'प्लेयर 2'],
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('tap_to_reveal_button')));
    await tester.pumpAndSettle();
    expect(find.text('आपका शब्द'), findsWidgets);
    expect(find.text('समझ गया'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('got_it_button')));
    await tester.pumpAndSettle();
    expect(find.text('फोन पास करें'), findsOneWidget);
    expect(find.text('आपका शब्द'), findsNothing);
  });

  testWidgets('Imposter reveal never shows secret word', (tester) async {
    _usePhoneViewport(tester);
    await tester.pumpWidget(
      _testApp(
        PlayerRevealScreen(
          revealData: PlayerRevealData(
            setup: _setup(imposterCount: 2, playersCount: 2),
            playerNames: const ['प्लेयर 1', 'प्लेयर 2'],
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('tap_to_reveal_button')));
    await tester.pumpAndSettle();

    expect(find.text('आप इम्पोस्टर हैं'), findsWidgets);
    expect(find.text('समझ गया'), findsOneWidget);
    for (final word in ['समोसा', 'पिज़्ज़ा', 'आइसक्रीम', 'चाय', 'बर्गर']) {
      expect(find.text(word), findsNothing);
    }
  });

  testWidgets('Last player opens Discussion and Discussion opens Voting', (
    tester,
  ) async {
    _usePhoneViewport(tester);
    await tester.pumpWidget(
      _testApp(
        PlayerRevealScreen(
          revealData: PlayerRevealData(
            setup: _setup(imposterCount: 0, playersCount: 2),
            playerNames: const ['प्लेयर 1', 'प्लेयर 2'],
          ),
        ),
      ),
    );

    for (var i = 0; i < 2; i++) {
      await tester.tap(find.byKey(const ValueKey('tap_to_reveal_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('got_it_button')));
      await tester.pumpAndSettle();
      if (i == 0) {
        await tester.tap(find.byKey(const ValueKey('next_player_button')));
        await tester.pumpAndSettle();
      }
    }

    await tester.tap(find.byKey(const ValueKey('start_discussion_button')));
    await tester.pumpAndSettle();
    expect(find.byType(DiscussionScreen), findsOneWidget);
    expect(find.text('चर्चा का समय'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('start_voting_button')));
    await tester.pumpAndSettle();
    expect(find.byType(VotingScreen), findsOneWidget);
    expect(find.text('वोटिंग शुरू करें'), findsOneWidget);
  });

  testWidgets('Voting validates selection and opens Result', (tester) async {
    _usePhoneViewport(tester);
    await tester.pumpWidget(
      _testApp(VotingScreen(discussionData: _discussion())),
    );

    await tester.tap(find.byKey(const ValueKey('see_result_button')));
    await tester.pump();
    expect(find.text('पहले एक खिलाड़ी चुनें'), findsOneWidget);

    await tester.pumpWidget(
      _testApp(VotingScreen(discussionData: _discussion())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('player_vote_card_1')));
    await tester.pumpAndSettle();
    expect(find.text('आपने Ravi को चुना है'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('see_result_button')));
    await tester.pumpAndSettle();
    expect(find.byType(ResultScreen), findsOneWidget);
    expect(find.text('इम्पोस्टर पकड़ा गया!'), findsOneWidget);
    expect(find.textContaining('Ravi'), findsWidgets);
    expect(find.text('समोसा'), findsOneWidget);
  });

  testWidgets('Result shows wrong vote and final action buttons work', (
    tester,
  ) async {
    _usePhoneViewport(tester);
    await tester.pumpWidget(
      _testApp(
        ResultScreen(
          resultData: VotingResultData(
            discussionData: _discussion(),
            selectedPlayerIndex: 0,
          ),
        ),
      ),
    );

    expect(find.text('गलत अंदाज़ा!'), findsOneWidget);
    expect(find.textContaining('Ravi'), findsWidgets);
    expect(find.text('समोसा'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('play_again_button')));
    await tester.pumpAndSettle();
    expect(find.byType(PlayerNameScreen), findsOneWidget);

    await tester.pumpWidget(
      _testApp(
        ResultScreen(
          resultData: VotingResultData(
            discussionData: _discussion(),
            selectedPlayerIndex: 0,
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(const ValueKey('change_setup_button')));
    await tester.pumpAndSettle();
    expect(find.byType(GameSetupScreen), findsOneWidget);

    await tester.pumpWidget(
      _testApp(
        ResultScreen(
          resultData: VotingResultData(
            discussionData: _discussion(),
            selectedPlayerIndex: 0,
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(const ValueKey('home_button')));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}

void _usePhoneViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> _pumpAppPastSplash(WidgetTester tester) async {
  await tester.pumpWidget(const HindiImposterApp());
  await tester.pump(const Duration(milliseconds: 1200));
  await tester.pumpAndSettle();
}

Widget _testApp(Widget child) {
  return AppLanguageScope(
    controller: AppLanguageController(),
    child: MaterialApp(key: UniqueKey(), home: child),
  );
}

GameSetupData _setup({
  AppLanguage language = AppLanguage.hindi,
  int playersCount = 3,
  int imposterCount = 1,
  bool wordImageEnabled = true,
}) {
  return GameSetupData(
    playersCount: playersCount,
    imposterCount: imposterCount,
    category: CategoryOption.food,
    language: language,
    wordImageEnabled: wordImageEnabled,
  );
}

DiscussionData _discussion() {
  return DiscussionData(
    setup: _setup(playersCount: 3),
    playerNames: const ['Asha', 'Ravi', 'Neha'],
    imposterIndexes: const {1},
    secretWord: const SecretWordData(hindi: 'समोसा', english: 'Samosa'),
  );
}
