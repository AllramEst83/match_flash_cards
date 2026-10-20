import 'package:flutter/material.dart';

import '../data/deck_repository.dart';
import '../data/settings_controller.dart';
import '../l10n/app_localizations.dart';
import '../models/deck.dart';
import 'deck_editor_screen.dart';
import 'palette.dart';
import 'settings_screen.dart';
import 'widgets/color_card.dart';
import 'widgets/star_row.dart';
import 'widgets/text_prompt.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.repository,
    required this.settings,
  });

  final DeckRepository repository;
  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myDecks),
        actions: [
          IconButton(
            tooltip: l10n.settings,
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => SettingsScreen(settings: settings),
              ),
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: repository,
        builder: (context, _) {
          final decks = repository.decks;
          if (decks.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  l10n.noDecks,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
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
        label: Text(l10n.newDeck),
      ),
    );
  }

  Future<void> _createDeck(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final name = await promptForText(
      context,
      title: l10n.nameYourDeck,
      hint: l10n.deckNameHint,
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
    final l10n = AppLocalizations.of(context);
    final color = colorForId(deck.id);
    return ColorCard(
      color: color,
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
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              Text(
                l10n.cardCount(deck.cards.length),
                style: const TextStyle(color: inkSoft, fontSize: 15),
              ),
              const SizedBox(width: 12),
              StarRow(stars: deck.bestStars),
              if (deck.bestPoints > 0) Text(
                  ' ${l10n.bestPoints(deck.bestPoints)}',
                  style: const TextStyle(color: inkSoft, fontSize: 15),
                ),
            ],
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _onMenu(context, value),
          itemBuilder: (context) => [
            PopupMenuItem(value: 'rename', child: Text(l10n.rename)),
            PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
          ],
        ),
        onTap: () => openDeck(context, repository, deck.id),
      ),
    );
  }

  Future<void> _onMenu(BuildContext context, String value) async {
    final l10n = AppLocalizations.of(context);
    if (value == 'rename') {
      final name = await promptForText(
        context,
        title: l10n.renameDeck,
        initial: deck.name,
      );
      if (name != null) repository.renameDeck(deck.id, name);
    } else {
      final sure = await confirm(
        context,
        title: l10n.deleteDeckTitle(deck.name),
        message: l10n.deleteDeckMessage,
        confirmLabel: l10n.delete,
        cancelLabel: l10n.keep,
      );
      if (sure) repository.deleteDeck(deck.id);
    }
  }
}
