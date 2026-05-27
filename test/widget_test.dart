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
  testWidgets('Home screen renders widget-built game UI', (tester) async {
    await tester.pumpWidget(const HindiImposterApp());

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('हिंदी'), findsWidgets);
    expect(find.text('IMPOSTER'), findsWidgets);
    expect(find.text('Start Game'), findsOneWidget);
    expect(find.text('How to Play'), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
  });

  testWidgets('How to Play button opens intro screen', (tester) async {
    await tester.pumpWidget(const HindiImposterApp());

    await tester.tap(find.text('How to Play'));
    await tester.pumpAndSettle();

    expect(find.byType(HowToPlayScreen), findsOneWidget);
    expect(find.text('कैसे खेलें?'), findsWidgets);
    expect(find.text('आगे बढ़ें'), findsOneWidget);
  });

  testWidgets('Start Game opens game setup screen', (tester) async {
    await tester.pumpWidget(const HindiImposterApp());

    await tester.tap(find.text('Start Game'));
    await tester.pumpAndSettle();

    expect(find.byType(GameSetupScreen), findsOneWidget);
    expect(find.text('गेम सेटअप'), findsWidgets);
  });

  testWidgets('Intro next opens game setup screen', (tester) async {
    await tester.pumpWidget(const HindiImposterApp());

    await tester.tap(find.text('How to Play'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('आगे बढ़ें'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('आगे बढ़ें'));
    await tester.pumpAndSettle();

    expect(find.byType(GameSetupScreen), findsOneWidget);
    expect(find.text('गेम सेटअप'), findsWidgets);
    expect(find.text('प्लेयर्स'), findsOneWidget);
    expect(find.text('इम्पोस्टर'), findsOneWidget);
  });

  testWidgets('Game setup controls update and navigate to player names', (
    tester,
  ) async {
    await tester.pumpWidget(const HindiImposterApp());
    await tester.tap(find.text('How to Play'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('आगे बढ़ें'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('आगे बढ़ें'));
    await tester.pumpAndSettle();

    expect(find.text('4'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const ValueKey('players_increase')));
    await tester.tap(find.byKey(const ValueKey('players_increase')));
    await tester.pump();
    expect(find.text('5'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey('imposters_increase')),
    );
    await tester.tap(find.byKey(const ValueKey('imposters_increase')));
    await tester.pump();
    expect(find.text('2'), findsWidgets);

    await tester.ensureVisible(
      find.byKey(const ValueKey('choice_CategoryOption.animals')),
    );
    await tester.tap(
      find.byKey(const ValueKey('choice_CategoryOption.animals')),
    );
    await tester.pump();
    expect(find.text('जानवर'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey('choice_AppLanguage.english')),
    );
    await tester.tap(find.byKey(const ValueKey('choice_AppLanguage.english')));
    await tester.pumpAndSettle();
    expect(find.text('Game Setup'), findsWidgets);
    expect(find.text('Next'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const ValueKey('word_image_switch')));
    await tester.tap(find.byKey(const ValueKey('word_image_switch')));
    await tester.pump();
    expect(find.text('Off'), findsOneWidget);

    await tester.ensureVisible(find.text('Next'));
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.byType(PlayerNameScreen), findsOneWidget);
    expect(find.text('Player Names'), findsWidgets);
    expect(find.byType(TextField), findsNWidgets(5));
    expect(find.text('Start Reveal'), findsOneWidget);
  });

  testWidgets('Player name screen defaults names and opens player reveal', (
    tester,
  ) async {
    await tester.pumpWidget(const HindiImposterApp());
    await tester.tap(find.text('How to Play'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('आगे बढ़ें'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('आगे बढ़ें'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('आगे बढ़ें'));
    await tester.tap(find.text('आगे बढ़ें'));
    await tester.pumpAndSettle();

    expect(find.byType(PlayerNameScreen), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(4));

    await tester.tap(find.byKey(const ValueKey('use_default_names')));
    await tester.pump();
    expect(find.text('प्लेयर 1'), findsWidgets);
    expect(find.text('प्लेयर 4'), findsWidgets);

    await tester.enterText(find.byKey(const ValueKey('player_name_2')), 'Asha');
    await tester.ensureVisible(find.text('रिवील शुरू करें'));
    await tester.tap(find.text('रिवील शुरू करें'));
    await tester.pumpAndSettle();

    expect(find.byType(PlayerRevealScreen), findsOneWidget);
    expect(find.text('फोन सिर्फ इसी खिलाड़ी को दें'), findsOneWidget);
    expect(find.text('देखें'), findsOneWidget);
  });

  testWidgets('Last player after Got it opens discussion screen', (
    tester,
  ) async {
    await tester.pumpWidget(const HindiImposterApp());
    await tester.tap(find.text('How to Play'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('आगे बढ़ें'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('आगे बढ़ें'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('आगे बढ़ें'));
    await tester.tap(find.text('आगे बढ़ें'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('use_default_names')));
    await tester.pump();
    await tester.ensureVisible(find.text('रिवील शुरू करें'));
    await tester.tap(find.text('रिवील शुरू करें'));
    await tester.pumpAndSettle();

    for (var i = 1; i <= 4; i++) {
      expect(find.text('प्लेयर $i'), findsWidgets);
      expect(find.text('फोन सिर्फ इसी खिलाड़ी को दें'), findsOneWidget);
      await tester.ensureVisible(
        find.byKey(const ValueKey('tap_to_reveal_button')),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('tap_to_reveal_button')));
      await tester.pumpAndSettle();
      expect(find.text('समझ गया'), findsOneWidget);
      await tester.ensureVisible(find.byKey(const ValueKey('got_it_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('got_it_button')));
      await tester.pumpAndSettle();

      if (i < 4) {
        expect(find.text('फोन अगले खिलाड़ी को दें'), findsOneWidget);
        expect(find.text('अगला खिलाड़ी'), findsOneWidget);
        await tester.ensureVisible(
          find.byKey(const ValueKey('next_player_button')),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const ValueKey('next_player_button')));
        await tester.pumpAndSettle();
      } else {
        expect(find.text('सभी खिलाड़ी तैयार हैं'), findsOneWidget);
        expect(find.text('चर्चा शुरू करें'), findsOneWidget);
        await tester.ensureVisible(
          find.byKey(const ValueKey('start_discussion_button')),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const ValueKey('start_discussion_button')));
        await tester.pumpAndSettle();
      }
    }

    expect(find.byType(DiscussionScreen), findsOneWidget);
    expect(find.text('चर्चा का समय'), findsWidgets);
    expect(find.text('अब सभी खिलाड़ी संकेत देंगे'), findsOneWidget);
    expect(find.text('वोटिंग शुरू करें'), findsOneWidget);
  });

  testWidgets('Discussion screen shows English text and opens voting screen', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: DiscussionScreen(
          discussionData: DiscussionData(
            setup: const GameSetupData(
              playersCount: 3,
              imposterCount: 1,
              category: CategoryOption.food,
              language: AppLanguage.english,
              wordImageEnabled: true,
            ),
            playerNames: const ['Asha', 'Ravi', 'Neha'],
            imposterIndexes: const {1},
            secretWord: const SecretWordData(hindi: 'समोसा', english: 'Samosa'),
          ),
        ),
      ),
    );

    expect(find.text('Discussion Time'), findsWidgets);
    expect(find.text('Now all players will give hints'), findsOneWidget);
    expect(find.text('Players'), findsOneWidget);
    expect(find.text('Imposter'), findsOneWidget);
    expect(find.text('Food'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey('start_voting_button')),
    );
    await tester.tap(find.byKey(const ValueKey('start_voting_button')));
    await tester.pumpAndSettle();

    expect(find.byType(VotingScreen), findsOneWidget);
    expect(find.text('Voting'), findsWidgets);
    expect(find.text('Who do you suspect?'), findsOneWidget);
    expect(find.textContaining('Player 1'), findsOneWidget);
  });

  testWidgets('Voting screen shows players and requires a selection', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: VotingScreen(
          discussionData: DiscussionData(
            setup: const GameSetupData(
              playersCount: 3,
              imposterCount: 1,
              category: CategoryOption.food,
              language: AppLanguage.hindi,
              wordImageEnabled: true,
            ),
            playerNames: const ['Rahul', 'Priya', 'Neha'],
            imposterIndexes: const {2},
            secretWord: const SecretWordData(hindi: 'समोसा', english: 'Samosa'),
          ),
        ),
      ),
    );

    expect(find.text('वोटिंग'), findsWidgets);
    expect(find.text('आपको किस पर शक है?'), findsOneWidget);
    expect(find.textContaining('खिलाड़ी 1'), findsOneWidget);
    expect(find.textContaining('Rahul'), findsOneWidget);
    expect(find.textContaining('Priya'), findsOneWidget);
    expect(find.textContaining('Neha'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const ValueKey('see_result_button')));
    await tester.tap(find.byKey(const ValueKey('see_result_button')));
    await tester.pump();
    expect(find.text('पहले एक खिलाड़ी चुनें'), findsOneWidget);
  });

  testWidgets('Voting player card selection opens result screen with data', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: VotingScreen(
          discussionData: DiscussionData(
            setup: const GameSetupData(
              playersCount: 3,
              imposterCount: 1,
              category: CategoryOption.animals,
              language: AppLanguage.english,
              wordImageEnabled: false,
            ),
            playerNames: const ['Asha', 'Ravi', 'Neha'],
            imposterIndexes: const {1},
            secretWord: const SecretWordData(hindi: 'शेर', english: 'Lion'),
          ),
        ),
      ),
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey('player_vote_card_1')),
    );
    await tester.tap(find.byKey(const ValueKey('player_vote_card_1')));
    await tester.pumpAndSettle();

    expect(find.text('You selected Ravi'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const ValueKey('see_result_button')));
    await tester.tap(find.byKey(const ValueKey('see_result_button')));
    await tester.pumpAndSettle();

    expect(find.byType(ResultScreen), findsOneWidget);
    expect(find.text('Result'), findsWidgets);
    expect(find.text('Caught Correctly!'), findsOneWidget);
    expect(find.text('You selected the correct imposter'), findsOneWidget);
    expect(find.text('Ravi'), findsWidgets);
    expect(find.text('Lion'), findsOneWidget);
    final result = tester.widget<ResultScreen>(find.byType(ResultScreen));
    expect(result.resultData.selectedPlayerIndex, 1);
    expect(result.resultData.selectedPlayerName, 'Ravi');
    expect(result.resultData.discussionData.imposterIndexes, const {1});
  });

  testWidgets('Result screen shows wrong vote, imposters, and secret word', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        ResultScreen(
          resultData: VotingResultData(
            discussionData: DiscussionData(
              setup: const GameSetupData(
                playersCount: 4,
                imposterCount: 2,
                category: CategoryOption.food,
                language: AppLanguage.hindi,
                wordImageEnabled: true,
              ),
              playerNames: const ['Rahul', 'Priya', 'Neha', 'Asha'],
              imposterIndexes: const {1, 3},
              secretWord: const SecretWordData(
                hindi: 'समोसा',
                english: 'Samosa',
              ),
            ),
            selectedPlayerIndex: 0,
          ),
        ),
      ),
    );

    expect(find.text('रिजल्ट'), findsWidgets);
    expect(find.text('गलत अंदाज़ा!'), findsOneWidget);
    expect(find.text('यह खिलाड़ी इम्पोस्टर नहीं था'), findsOneWidget);
    expect(find.text('आपकी पसंद'), findsOneWidget);
    expect(find.text('Rahul'), findsOneWidget);
    expect(find.text('असली इम्पोस्टर'), findsOneWidget);
    expect(find.text('Priya, Asha'), findsOneWidget);
    expect(find.text('गुप्त शब्द'), findsOneWidget);
    expect(find.text('समोसा'), findsOneWidget);
  });

  testWidgets('Result action buttons navigate to fresh screens', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(_englishResultScreen()));

    await tester.ensureVisible(find.byKey(const ValueKey('play_again_button')));
    await tester.tap(find.byKey(const ValueKey('play_again_button')));
    await tester.pumpAndSettle();
    expect(find.byType(PlayerNameScreen), findsOneWidget);
    expect(find.text('Player Names'), findsWidgets);

    await tester.pumpWidget(_testApp(_englishResultScreen()));
    await tester.ensureVisible(
      find.byKey(const ValueKey('change_setup_button')),
    );
    await tester.tap(find.byKey(const ValueKey('change_setup_button')));
    await tester.pumpAndSettle();
    expect(find.byType(GameSetupScreen), findsOneWidget);
    expect(find.text('Game Setup'), findsWidgets);

    await tester.pumpWidget(_testApp(_englishResultScreen()));
    await tester.ensureVisible(find.byKey(const ValueKey('home_button')));
    await tester.tap(find.byKey(const ValueKey('home_button')));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('Discussion screen back button returns to previous route', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => DiscussionScreen(
                      discussionData: DiscussionData(
                        setup: const GameSetupData(
                          playersCount: 3,
                          imposterCount: 1,
                          category: CategoryOption.animals,
                          language: AppLanguage.hindi,
                          wordImageEnabled: true,
                        ),
                        playerNames: const ['प्लेयर 1', 'प्लेयर 2', 'प्लेयर 3'],
                        imposterIndexes: const {0},
                        secretWord: const SecretWordData(
                          hindi: 'शेर',
                          english: 'Lion',
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: const Text('open discussion'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('open discussion'));
    await tester.pumpAndSettle();
    expect(find.byType(DiscussionScreen), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_rounded).first);
    await tester.pumpAndSettle();

    expect(find.text('open discussion'), findsOneWidget);
  });

  testWidgets('Normal player reveal does not show imposter role text', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PlayerRevealScreen(
          revealData: PlayerRevealData(
            setup: const GameSetupData(
              playersCount: 2,
              imposterCount: 0,
              category: CategoryOption.food,
              language: AppLanguage.hindi,
              wordImageEnabled: true,
            ),
            playerNames: const ['प्लेयर 1', 'प्लेयर 2'],
          ),
        ),
      ),
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey('tap_to_reveal_button')),
    );
    await tester.tap(find.byKey(const ValueKey('tap_to_reveal_button')));
    await tester.pumpAndSettle();

    expect(find.text('आपका शब्द'), findsWidgets);
    expect(find.text('आप इम्पोस्टर हैं'), findsNothing);
    expect(find.text('इम्पोस्टर'), findsNothing);
  });

  testWidgets('Imposter reveal shows role and never shows secret word', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PlayerRevealScreen(
          revealData: PlayerRevealData(
            setup: const GameSetupData(
              playersCount: 2,
              imposterCount: 2,
              category: CategoryOption.food,
              language: AppLanguage.hindi,
              wordImageEnabled: true,
            ),
            playerNames: const ['प्लेयर 1', 'प्लेयर 2'],
          ),
        ),
      ),
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey('tap_to_reveal_button')),
    );
    await tester.tap(find.byKey(const ValueKey('tap_to_reveal_button')));
    await tester.pumpAndSettle();

    expect(find.text('आप इम्पोस्टर हैं'), findsWidgets);
    expect(find.text('आपका गुप्त रोल है'), findsOneWidget);
    expect(find.text('इम्पोस्टर'), findsOneWidget);
    for (final word in ['समोसा', 'पिज़्ज़ा', 'आइसक्रीम', 'चाय', 'बर्गर']) {
      expect(find.text(word), findsNothing);
    }
  });

  testWidgets('Got it hides imposter role before next player prompt', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PlayerRevealScreen(
          revealData: PlayerRevealData(
            setup: const GameSetupData(
              playersCount: 2,
              imposterCount: 2,
              category: CategoryOption.food,
              language: AppLanguage.hindi,
              wordImageEnabled: true,
            ),
            playerNames: const ['प्लेयर 1', 'प्लेयर 2'],
          ),
        ),
      ),
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey('tap_to_reveal_button')),
    );
    await tester.tap(find.byKey(const ValueKey('tap_to_reveal_button')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('got_it_button')));
    await tester.tap(find.byKey(const ValueKey('got_it_button')));
    await tester.pumpAndSettle();

    expect(find.text('फोन अगले खिलाड़ी को दें'), findsOneWidget);
    expect(find.text('प्लेयर 2'), findsWidgets);
    expect(find.text('आप इम्पोस्टर हैं'), findsNothing);
    expect(find.text('इम्पोस्टर'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('next_player_button')));
    await tester.pumpAndSettle();
    expect(find.text('फोन सिर्फ इसी खिलाड़ी को दें'), findsOneWidget);
    expect(find.text('आप इम्पोस्टर हैं'), findsNothing);
  });
}

Widget _testApp(Widget child) {
  return AppLanguageScope(
    controller: AppLanguageController(initialLanguage: AppLanguage.english),
    child: MaterialApp(key: UniqueKey(), home: child),
  );
}

ResultScreen _englishResultScreen() {
  return ResultScreen(
    resultData: VotingResultData(
      discussionData: DiscussionData(
        setup: const GameSetupData(
          playersCount: 3,
          imposterCount: 1,
          category: CategoryOption.animals,
          language: AppLanguage.english,
          wordImageEnabled: false,
        ),
        playerNames: const ['Asha', 'Ravi', 'Neha'],
        imposterIndexes: const {1},
        secretWord: const SecretWordData(hindi: 'शेर', english: 'Lion'),
      ),
      selectedPlayerIndex: 1,
    ),
  );
}
