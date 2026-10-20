import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/deck.dart';
import '../models/flash_card.dart';
import '../models/ids.dart';
import 'default_deck.dart';

class DeckRepository extends ChangeNotifier {
  DeckRepository(this._prefs) {
    _load();
  }

  static const _storageKey = 'decks_v1';
  static const _seededKey = 'seeded_decks';

  final SharedPreferences _prefs;
  List<Deck> _decks = [];

  List<Deck> get decks => List.unmodifiable(_decks);

  Deck? deckById(String id) {
    for (final deck in _decks) {
      if (deck.id == id) return deck;
    }
    return null;
  }

  Deck addDeck(String name) {
    final deck = Deck(id: newId(), name: name.trim());
    _decks = [..._decks, deck];
    _commit();
    return deck;
  }

  void renameDeck(String deckId, String name) =>
      _update(deckId, (deck) => deck.copyWith(name: name.trim()));

  void deleteDeck(String deckId) {
    _decks = _decks.where((deck) => deck.id != deckId).toList();
    _commit();
  }

  void addCard(
    String deckId, {
    required String word,
    String description = '',
    String? imageBase64,
  }) {
    final card = FlashCard(
      id: newId(),
      word: word.trim(),
      description: description.trim(),
      imageBase64: imageBase64,
    );
    _update(deckId, (deck) => deck.copyWith(cards: [...deck.cards, card]));
  }

  void updateCard(String deckId, FlashCard card) => _update(
    deckId,
    (deck) => deck.copyWith(
      cards: [for (final c in deck.cards) c.id == card.id ? card : c],
    ),
  );

  void deleteCard(String deckId, String cardId) => _update(
    deckId,
    (deck) =>
        deck.copyWith(cards: deck.cards.where((c) => c.id != cardId).toList()),
  );

  /// Moves each card up a level when it was right first time, and back two
  /// levels when it was missed. [outcomes] maps card id to first-try success.
  void recordCardOutcomes(String deckId, Map<String, bool> outcomes) {
    _update(
      deckId,
      (deck) => deck.copyWith(
        cards: [
          for (final card in deck.cards)
            if (outcomes[card.id] case final firstTry?)
              card.copyWith(
                level: firstTry
                    ? (card.level + 1).clamp(0, FlashCard.maxLevel)
                    : (card.level - 2).clamp(0, FlashCard.maxLevel),
              )
            else
              card,
        ],
      ),
    );
  }

  /// Saves a finished round. Returns true when it beat an earlier best.
  bool recordResult(String deckId, {required int stars, required int points}) {
    final deck = deckById(deckId);
    if (deck == null) return false;
    final hadPlayedBefore = deck.bestStars > 0;
    final beatBest = stars > deck.bestStars || points > deck.bestPoints;
    if (beatBest) {
      _update(
        deckId,
        (d) => d.copyWith(
          bestStars: stars > d.bestStars ? stars : d.bestStars,
          bestPoints: points > d.bestPoints ? points : d.bestPoints,
        ),
      );
    }
    return hadPlayedBefore && beatBest;
  }

  void _update(String deckId, Deck Function(Deck) change) {
    _decks = [
      for (final deck in _decks) deck.id == deckId ? change(deck) : deck,
    ];
    _commit();
  }

  void _commit() {
    unawaited(
      _prefs.setString(
        _storageKey,
        jsonEncode([for (final deck in _decks) deck.toJson()]),
      ),
    );
    notifyListeners();
  }

  void _load() {
    final raw = _prefs.getString(_storageKey);
    // Decks saved before this list existed already have the first bundled one.
    final seeded =
        _prefs.getStringList(_seededKey)?.toSet() ??
        (raw == null ? <String>{} : {'materia'});
    if (raw != null) {
      try {
        _decks = [
          for (final deck in jsonDecode(raw) as List<dynamic>)
            Deck.fromJson(deck as Map<String, dynamic>),
        ];
      } on Object {
        _decks = [];
        return;
      }
    }
    final missing = [
      for (final bundled in bundledDecks)
        if (!seeded.contains(bundled.key)) bundled,
    ];
    if (raw != null && missing.isEmpty) return;
    _decks = [..._decks, for (final bundled in missing) bundled.build()];
    unawaited(
      _prefs.setStringList(_seededKey, [for (final b in bundledDecks) b.key]),
    );
    _commit();
  }
}
