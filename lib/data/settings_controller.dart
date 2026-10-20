import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends ChangeNotifier {
  SettingsController(this._prefs)
      : _locale = switch (_prefs.getString(_localeKey)) {
          final code? => Locale(code),
          null => null,
        };

  static const _localeKey = 'locale';

  final SharedPreferences _prefs;
  Locale? _locale;

  /// The language picked in Settings, or null to follow the device language.
  Locale? get locale => _locale;

  void setLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    _prefs.setString(_localeKey, locale.languageCode);
    notifyListeners();
  }
}
