import 'package:flutter/material.dart';

import '../data/deck_repository.dart';
import '../models/deck.dart';
import 'deck_editor_screen.dart';
import 'palette.dart';
import 'widgets/star_row.dart';
import 'widgets/text_prompt.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.repository});

  final DeckRepository repository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Decks')),
      body: ListenableBuilder(
        listenable: repository,
        builder: (context, _) {
          final decks = repository.decks;
          if (decks.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No decks yet!\nTap "New deck" to make your first one.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            itemCount: decks.length,
            itemBuilder: (context, index) => _DeckTile(
              deck: decks[index],
              repository: repository,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createDeck(context),
        icon: const Icon(Icons.add),
        label: const Text('New deck'),
      ),
    );
  }

  Future<void> _createDeck(BuildContext context) async {
    final name = await promptForText(
      context,
      title: 'Name your deck',
      hint: 'Animals, Spelling week 3, ...',
    );
    if (name == null || !context.mounted) return;
    final deck = repository.addDeck(name);
    openDeck(context, repository, deck.id);
  }
}

void openDeck(BuildContext context, DeckRepository repository, String deckId) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      settings: const RouteSettings(name: DeckEditorScreen.routeName),
      builder: (_) => DeckEditorScreen(repository: repository, deckId: deckId),
    ),
  );
}

class _DeckTile extends StatelessWidget {
  const _DeckTile({required this.deck, required this.repository});

  final Deck deck;
  final DeckRepository repository;

  @override
  Widget build(BuildContext context) {
    final count = deck.cards.length;
    final color = colorForId(deck.id);
    return Card(
      margin: const EdgeInsets.only(top: 12),
      color: color.withValues(alpha: 0.14),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: color,
          child: const Icon(
            Icons.collections_bookmark_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: Text(
          deck.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              Text(count == 1 ? '1 card' : '$count cards'),
              const SizedBox(width: 12),
              StarRow(stars: deck.bestStars),
              if (deck.bestPoints > 0) Text(' ${deck.bestPoints} pts'),
            ],
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _onMenu(context, value),
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'rename', child: Text('Rename')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
        onTap: () => openDeck(context, repository, deck.id),
      ),
    );
  }

  Future<void> _onMenu(BuildContext context, String value) async {
    if (value == 'rename') {
      final name = await promptForText(
        context,
        title: 'Rename deck',
        initial: deck.name,
      );
      if (name != null) repository.renameDeck(deck.id, name);
    } else {
      final sure = await confirm(
        context,
        title: 'Delete "${deck.name}"?',
        message: 'All of its cards will be deleted too.',
        confirmLabel: 'Delete',
        cancelLabel: 'Keep',
      );
      if (sure) repository.deleteDeck(deck.id);
    }
  }
}
