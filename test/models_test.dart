import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:match_flash_cards/data/deck_repository.dart';
import 'package:match_flash_cards/models/deck.dart';
import 'package:match_flash_cards/models/flash_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('deck JSON round trip keeps cards and pictures', () {
    final image = base64Encode([1, 2, 3, 4]);
    final deck = Deck(
      id: 'd1',
      name: 'Animals',
      bestStars: 2,
      bestPoints: 40,
      cards: [
        FlashCard(
          id: 'c1',
          word: 'Cat',
          description: 'Purrs',
          imageBase64: image,
        ),
        FlashCard(id: 'c2', word: 'Dog', description: 'Barks'),
      ],
    );

    final copy = Deck.fromJson(
      jsonDecode(jsonEncode(deck.toJson())) as Map<String, dynamic>,
    );

    expect(copy.name, 'Animals');
    expect(copy.bestStars, 2);
    expect(copy.bestPoints, 40);
    expect(copy.cards.map((c) => c.word), ['Cat', 'Dog']);
    expect(copy.cards.first.imageBytes, [1, 2, 3, 4]);
    expect(copy.cards.last.imageBytes, isNull);
  });

  group('DeckRepository', () {
    Future<DeckRepository> create([
      Map<String, Object> values = const {},
    ]) async {
      SharedPreferences.setMockInitialValues(values);
      return DeckRepository(await SharedPreferences.getInstance());
    }

    test('seeds the bundled decks on first launch only', () async {
      final repository = await create();
      expect(repository.decks.map((d) => d.name), [
        'Materia och material',
        'Vasatiden',
      ]);
      expect(repository.decks.first.cards, hasLength(10));
      expect(repository.decks.last.cards, hasLength(26));
      final prefs = await SharedPreferences.getInstance();
      final reloaded = DeckRepository(prefs);
      expect(
        reloaded.decks.map((d) => d.id),
        repository.decks.map((d) => d.id),
      );
    });

    test('adds newly bundled decks to an existing install once', () async {
      final repository = await create();
      final materia = repository.decks.first;
      // An install from before the seeded list existed: only Materia saved.
      final old = await create({
        'decks_v1': jsonEncode([materia.toJson()]),
      });
      expect(old.decks.map((d) => d.name), [
        'Materia och material',
        'Vasatiden',
      ]);
      old.deleteDeck(old.decks.last.id);
      final again = DeckRepository(await SharedPreferences.getInstance());
      expect(again.decks.map((d) => d.name), ['Materia och material']);
    });

    test('persists changes', () async {
      final repository = await create();
      final deck = repository.addDeck(' Space ');
      repository.addCard(deck.id, word: ' Moon ', description: 'Glows');

      final reloaded = DeckRepository(await SharedPreferences.getInstance());
      final saved = reloaded.deckById(deck.id)!;
      expect(saved.name, 'Space');
      expect(saved.cards.single.word, 'Moon');
    });

    test('records best results and reports new bests', () async {
      final repository = await create();
      final id = repository.decks.first.id;
      expect(repository.recordResult(id, stars: 1, points: 20), isFalse);
      expect(repository.recordResult(id, stars: 1, points: 10), isFalse);
      expect(repository.recordResult(id, stars: 2, points: 30), isTrue);
      expect(repository.deckById(id)!.bestStars, 2);
      expect(repository.deckById(id)!.bestPoints, 30);
    });

    test('levels cards up on first try and down when missed', () async {
      final repository = await create();
      final deck = repository.decks.first;
      final [a, b, ...] = deck.cards;
      repository.recordCardOutcomes(deck.id, {a.id: true, b.id: false});
      repository.recordCardOutcomes(deck.id, {a.id: true, b.id: false});
      var cards = repository.deckById(deck.id)!.cards;
      expect(cards[0].level, 2);
      expect(cards[1].level, 0);
      expect(cards[2].level, 0);

      final reloaded = DeckRepository(await SharedPreferences.getInstance());
      expect(reloaded.deckById(deck.id)!.cards[0].level, 2);
      for (var i = 0; i < 6; i++) {
        repository.recordCardOutcomes(deck.id, {a.id: true});
      }
      cards = repository.deckById(deck.id)!.cards;
      expect(cards[0].level, FlashCard.maxLevel);
    });

    test('recovers from corrupt saved data', () async {
      final repository = await create({'decks_v1': 'not json'});
      expect(repository.decks, isEmpty);
    });
  });
}
