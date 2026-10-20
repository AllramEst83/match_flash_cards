import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/deck_repository.dart';
import 'data/settings_controller.dart';
import 'l10n/app_localizations.dart';
import 'ui/home_screen.dart';
import 'ui/palette.dart';

class MatchFlashCardsApp extends StatelessWidget {
  const MatchFlashCardsApp({
    super.key,
    required this.repository,
    required this.settings,
  });

  final DeckRepository repository;
  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C4DFF),
          brightness: Brightness.light,
        ).copyWith(
          // The icon's purple: more vivid than the seeded one, 5.7:1 with white.
          primary: const Color(0xFF6C40F5),
          onPrimary: Colors.white,
          // Dark text everywhere, not Material's default greys.
          onSurface: ink,
          onSurfaceVariant: inkSoft,
        );
    return ListenableBuilder(
      listenable: settings,
      builder: (context, _) => MaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        debugShowCheckedModeBanner: false,
        locale: settings.locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          colorScheme: scheme,
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF6F1FF),
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
            },
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: scheme.primary, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: scheme.primary, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: scheme.primary, width: 3),
            ),
            labelStyle: const TextStyle(color: inkSoft),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: scheme.primary,
              side: BorderSide(color: scheme.primary, width: 2),
            ),
          ),
          chipTheme: ChipThemeData(
            backgroundColor: Colors.white,
            selectedColor: tintOf(scheme.primary, 0.26),
            side: BorderSide(color: scheme.primary, width: 2),
            labelStyle: const TextStyle(color: ink),
            checkmarkColor: scheme.primary,
          ),
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
        home: HomeScreen(repository: repository, settings: settings),
      ),
    );
  }
}
