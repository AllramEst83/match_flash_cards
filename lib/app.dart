import 'package:flutter/material.dart';

import 'data/deck_repository.dart';
import 'ui/home_screen.dart';

class MatchFlashCardsApp extends StatelessWidget {
  const MatchFlashCardsApp({super.key, required this.repository});

  final DeckRepository repository;

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF7C4DFF),
      brightness: Brightness.light,
    );
    return MaterialApp(
      title: 'Match Flash Cards',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: scheme,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F1FF),
        appBarTheme: AppBarTheme(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: scheme.onPrimary,
          ),
        ),
      ),
      home: HomeScreen(repository: repository),
    );
  }
}
