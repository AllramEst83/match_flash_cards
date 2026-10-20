import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/deck_repository.dart';
import 'data/settings_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    MatchFlashCardsApp(
      repository: DeckRepository(prefs),
      settings: SettingsController(prefs),
    ),
  );
}
