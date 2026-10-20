import 'package:flutter/material.dart';

import '../data/deck_repository.dart';
import '../l10n/app_localizations.dart';
import '../models/study_mode.dart';
import 'palette.dart';
import 'widgets/color_card.dart';
import 'study_screen.dart';

class StudySetupScreen extends StatefulWidget {
  const StudySetupScreen({
    super.key,
    required this.repository,
    required this.deckId,
  });

  final DeckRepository repository;
  final String deckId;

  @override
  State<StudySetupScreen> createState() => _StudySetupScreenState();
}

class _StudySetupScreenState extends State<StudySetupScreen> {
  static const _icons = {
    StudyMode.words: Icons.abc_rounded,
    StudyMode.descriptions: Icons.notes_rounded,
    StudyMode.mix: Icons.shuffle_rounded,
  };

  StudyMode _mode = StudyMode.mix;
  int? _count;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final deck = widget.repository.deckById(widget.deckId);
    if (deck == null) return const Scaffold();
    final labels = {
      StudyMode.words: (l10n.modeWords, l10n.modeWordsHint),
      StudyMode.descriptions: (l10n.modeDescriptions, l10n.modeDescriptionsHint),
      StudyMode.mix: (l10n.modeMix, l10n.modeMixHint),
    };
    final total = deck.cards.length;
    final lengths = <int?>[null, for (final n in [5, 10]) if (n < total) n];

    return Scaffold(
      appBar: AppBar(title: Text(deck.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.whatToSee,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          for (final mode in StudyMode.values)
            _ModeTile(
              icon: _icons[mode]!,
              color: playfulColor(mode.index * 2 + 1),
              label: labels[mode]!.$1,
              hint: labels[mode]!.$2,
              selected: _mode == mode,
              onTap: () => setState(() => _mode = mode),
            ),
          if (lengths.length > 1) ...[
            const SizedBox(height: 24),
            Text(
              l10n.howManyCards,
              style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                for (final length in lengths)
                  ChoiceChip(
                    label: Text(
                      length == null ? l10n.allCards(total) : '$length',
                      style: const TextStyle(fontSize: 18),
                    ),
                    selected: _count == length,
                    onSelected: (_) => setState(() => _count = length),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 32),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(72),
              textStyle: const TextStyle(fontSize: 26),
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => StudyScreen(
                  repository: widget.repository,
                  deckId: widget.deckId,
                  mode: _mode,
                  count: _count,
                ),
              ),
            ),
            icon: const Icon(Icons.rocket_launch_rounded, size: 32),
            label: Text(l10n.play),
          ),
        ],
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.hint,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String hint;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ColorCard(
      color: color,
      selected: selected,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        minVerticalPadding: 16,
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: color,
          child: Icon(icon, size: 32, color: Colors.white),
        ),
        title: Text(
          label,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(hint, style: const TextStyle(fontSize: 15)),
        trailing: selected
            ? Icon(Icons.check_circle_rounded, color: color, size: 30)
            : null,
        onTap: onTap,
      ),
    );
  }
}
