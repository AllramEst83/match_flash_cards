import 'package:flutter/material.dart';

import '../data/settings_controller.dart';
import '../l10n/app_localizations.dart';
import 'palette.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.settings});

  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final current = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.language, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          _LanguageTile(
            label: l10n.languageEnglish,
            flag: '🇬🇧',
            color: playfulColor(1),
            selected: current == 'en',
            onTap: () => settings.setLocale(const Locale('en')),
          ),
          _LanguageTile(
            label: l10n.languageSwedish,
            flag: '🇸🇪',
            color: playfulColor(3),
            selected: current == 'sv',
            onTap: () => settings.setLocale(const Locale('sv')),
          ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.label,
    required this.flag,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String flag;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: color.withValues(alpha: selected ? 0.22 : 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selected ? color : Colors.transparent,
          width: 3,
        ),
      ),
      child: ListTile(
        minVerticalPadding: 16,
        leading: Text(flag, style: const TextStyle(fontSize: 36)),
        title: Text(label, style: Theme.of(context).textTheme.titleLarge),
        trailing: selected
            ? Icon(Icons.check_circle_rounded, color: color, size: 30)
            : null,
        onTap: onTap,
      ),
    );
  }
}
