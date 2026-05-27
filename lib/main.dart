import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'localization/app_language.dart';
import 'screens/home_screen.dart';
import 'theme/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: AppColors.backgroundDeep,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const HindiImposterApp());
}

class HindiImposterApp extends StatefulWidget {
  const HindiImposterApp({super.key});

  @override
  State<HindiImposterApp> createState() => _HindiImposterAppState();
}

class _HindiImposterAppState extends State<HindiImposterApp> {
  final AppLanguageController _languageController = AppLanguageController();

  @override
  Widget build(BuildContext context) {
    return AppLanguageScope(
      controller: _languageController,
      child: MaterialApp(
        title: 'Hindi Imposter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.backgroundDeep,
          fontFamily: 'Roboto',
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
