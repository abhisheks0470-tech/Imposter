import '../localization/app_language.dart';

enum CategoryOption { food, animals, places, movies, objects, custom }

class GameSetupData {
  const GameSetupData({
    required this.playersCount,
    required this.imposterCount,
    required this.category,
    required this.language,
    required this.wordImageEnabled,
  });

  final int playersCount;
  final int imposterCount;
  final CategoryOption category;
  final AppLanguage language;
  final bool wordImageEnabled;
}

class PlayerRevealData {
  const PlayerRevealData({required this.setup, required this.playerNames});

  final GameSetupData setup;
  final List<String> playerNames;
}

class SecretWordData {
  const SecretWordData({required this.hindi, required this.english});

  final String hindi;
  final String english;

  String label(AppLanguage language) {
    return language == AppLanguage.hindi ? hindi : english;
  }
}

class DiscussionData {
  const DiscussionData({
    required this.setup,
    required this.playerNames,
    required this.imposterIndexes,
    required this.secretWord,
  });

  final GameSetupData setup;
  final List<String> playerNames;
  final Set<int> imposterIndexes;
  final SecretWordData secretWord;
}

class VotingResultData {
  const VotingResultData({
    required this.discussionData,
    required this.selectedPlayerIndex,
  });

  final DiscussionData discussionData;
  final int selectedPlayerIndex;

  String get selectedPlayerName =>
      discussionData.playerNames[selectedPlayerIndex];
}
