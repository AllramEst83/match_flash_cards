import 'package:flutter/material.dart';

import '../data/deck_repository.dart';
import '../models/study_mode.dart';
import 'palette.dart';
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
    final deck = widget.repository.deckById(widget.deckId);
    if (deck == null) return const Scaffold();
    final total = deck.cards.length;
    final lengths = <int?>[null, for (final n in [5, 10]) if (n < total) n];

    return Scaffold(
      appBar: AppBar(title: Text(deck.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'What do you want to see?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          for (final mode in StudyMode.values)
            _ModeTile(
              icon: _icons[mode]!,
              color: playfulColor(mode.index * 2 + 1),
              mode: mode,
              selected: _mode == mode,
              onTap: () => setState(() => _mode = mode),
            ),
          if (lengths.length > 1) ...[
            const SizedBox(height: 24),
            Text(
              'How many cards?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                for (final length in lengths)
                  ChoiceChip(
                    label: Text(
                      length == null ? 'All $total' : '$length',
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
            label: const Text('Play!'),
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
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final StudyMode mode;
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
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: color,
          child: Icon(icon, size: 32, color: Colors.white),
        ),
        title: Text(
          mode.label,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(mode.hint),
        trailing: selected
            ? Icon(Icons.check_circle_rounded, color: color, size: 30)
            : null,
        onTap: onTap,
      ),
    );
  }
}
