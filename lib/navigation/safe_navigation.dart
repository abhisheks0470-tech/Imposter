import 'package:flutter/material.dart';

import '../screens/home_screen.dart';

void safeBackOrHome(BuildContext context) {
  final navigator = Navigator.of(context);
  if (navigator.canPop()) {
    navigator.pop();
    return;
  }

  navigator.pushReplacement(
    MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
  );
}
