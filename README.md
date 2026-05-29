# Hindi Imposter

A Flutter app for a Hindi Imposter party game.

## Current Scope

- Flutter project scaffolded for Android and iOS.
- Widget-built Hindi Imposter game flow is implemented from Home through Result.
- Includes setup, player names, private reveal, discussion, voting, and final result screens.
- Uses real Flutter widgets with separated premium image assets; no fullscreen screenshot shell is used.

## Verification

Run the usual checks before pushing:

```sh
dart format lib test
flutter pub get
flutter analyze --no-fatal-infos --no-fatal-warnings
flutter test
flutter build apk --release
```
