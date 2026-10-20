import 'package:flutter/material.dart';

import '../data/deck_repository.dart';
import '../l10n/app_localizations.dart';
import '../models/flash_card.dart';
import 'card_form_screen.dart';
import 'palette.dart';
import 'widgets/color_card.dart';
import 'study_setup_screen.dart';
import 'widgets/text_prompt.dart';

class DeckEditorScreen extends StatelessWidget {
  const DeckEditorScreen({
    super.key,
    required this.repository,
    required this.deckId,
  });

  static const routeName = 'deck';

  final DeckRepository repository;
  final String deckId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListenableBuilder(
      listenable: repository,
      builder: (context, _) {
        final deck = repository.deckById(deckId);
        if (deck == null) return const Scaffold();
        final canStudy = deck.cards.length >= 2;
        return Scaffold(
          appBar: AppBar(
            title: Text(deck.name),
            actions: [
              IconButton(
                tooltip: l10n.renameDeck,
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final name = await promptForText(
                    context,
                    title: l10n.renameDeck,
                    initial: deck.name,
                  );
                  if (name != null) repository.renameDeck(deckId, name);
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonalIcon(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () => _openForm(context, null),
                    icon: const Icon(Icons.add_rounded),
                    label: Text(l10n.addCard),
                  ),
                ),
              ),
              Expanded(
                child: deck.cards.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            l10n.emptyDeck,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        itemCount: deck.cards.length,
                        itemBuilder: (context, index) => _CardTile(
                          card: deck.cards[index],
                          onEdit: () => _openForm(context, deck.cards[index]),
                          onDelete: () => _delete(context, deck.cards[index]),
                        ),
                      ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!canStudy)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            deck.cards.isEmpty
                                ? l10n.addTwoCards
                                : l10n.addOneMoreCard,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(64),
                            textStyle: const TextStyle(fontSize: 22),
                          ),
                          onPressed: canStudy
                              ? () => Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => StudySetupScreen(
                                        repository: repository,
                                        deckId: deckId,
                                      ),
                                    ),
                                  )
                              : null,
                          icon: const Icon(Icons.play_arrow_rounded, size: 32),
                          label: Text(l10n.study),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openForm(BuildContext context, FlashCard? card) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CardFormScreen(
          repository: repository,
          deckId: deckId,
          card: card,
        ),
      ),
    );
  }

  Future<void> _delete(BuildContext context, FlashCard card) async {
    final l10n = AppLocalizations.of(context);
    final sure = await confirm(
      context,
      title: l10n.deleteCardTitle(card.word),
      message: l10n.deleteCardMessage,
      confirmLabel: l10n.delete,
      cancelLabel: l10n.keep,
    );
    if (sure) repository.deleteCard(deckId, card.id);
  }
}

class _CardTile extends StatelessWidget {
  const _CardTile({
    required this.card,
    required this.onEdit,
    required this.onDelete,
  });

  final FlashCard card;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final image = card.imageBytes;
    final color = colorForId(card.id);
    return ColorCard(
      margin: const EdgeInsets.only(top: 8),
      color: color,
      child: ListTile(
        leading: image == null
            ? CircleAvatar(
                radius: 24,
                backgroundColor: color,
                child: Text(
                  card.word.characters.first.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(image, width: 48, height: 48, fit: BoxFit.cover),
              ),
        title: Text(
          card.word,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: ink, fontWeight: FontWeight.w700),
        ),
        subtitle: card.description.isEmpty
            ? null
            : Text(
                card.description,
                style: const TextStyle(color: inkSoft, fontSize: 15, height: 1.3),
              ),
        trailing: IconButton(
          tooltip: AppLocalizations.of(context).deleteCardTooltip,
          icon: const Icon(Icons.delete_outline, color: ink),
          onPressed: onDelete,
        ),
        onTap: onEdit,
      ),
    );
  }
}
