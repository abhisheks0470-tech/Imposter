import 'package:flutter/widgets.dart';

enum AppLanguage { hindi, english }

class AppLanguageController extends ChangeNotifier {
  AppLanguageController({AppLanguage initialLanguage = AppLanguage.hindi})
    : _language = initialLanguage;

  AppLanguage _language;

  AppLanguage get language => _language;
  bool get isHindi => _language == AppLanguage.hindi;

  void setLanguage(AppLanguage language) {
    if (_language == language) {
      return;
    }
    _language = language;
    notifyListeners();
  }
}

class AppLanguageScope extends InheritedNotifier<AppLanguageController> {
  const AppLanguageScope({
    required AppLanguageController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static AppLanguageController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<AppLanguageScope>();
    assert(scope != null, 'AppLanguageScope is missing from the widget tree.');
    return scope!.notifier!;
  }
}

class AppStrings {
  const AppStrings._();

  static String pick(
    AppLanguage language, {
    required String hi,
    required String en,
  }) {
    return language == AppLanguage.hindi ? hi : en;
  }
}
