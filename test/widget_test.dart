import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:match_flash_cards/app.dart';
import 'package:match_flash_cards/data/deck_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<DeckRepository> _repository() async {
  SharedPreferences.setMockInitialValues({});
  return DeckRepository(await SharedPreferences.getInstance());
}

void main() {
  testWidgets('shows the sample deck on first launch', (tester) async {
    final repository = await _repository();
    await tester.pumpWidget(MatchFlashCardsApp(repository: repository));

    expect(find.text('My Decks'), findsOneWidget);
    expect(find.text('Animals'), findsOneWidget);
    expect(find.text('4 cards'), findsOneWidget);
  });

  testWidgets('study button needs two cards', (tester) async {
    final repository = await _repository();
    final deck = repository.addDeck('Tiny');
    repository.addCard(deck.id, word: 'Sun', description: 'Shines in the sky');
    await tester.pumpWidget(MatchFlashCardsApp(repository: repository));

    await tester.tap(find.text('Tiny'));
    await tester.pumpAndSettle();

    expect(find.text('Add 1 more card to start playing!'), findsOneWidget);
    final study = tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Study'));
    expect(study.onPressed, isNull);
  });

  testWidgets('plays a full round and records the result', (tester) async {
    final repository = await _repository();
    final deck = repository.addDeck('Pair');
    repository.addCard(deck.id, word: 'Sun', description: 'Shines in the sky');
    repository.addCard(deck.id, word: 'Moon', description: 'Glows at night');
    await tester.pumpWidget(MatchFlashCardsApp(repository: repository));

    await tester.tap(find.text('Pair'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Study'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Words'));
    await tester.tap(find.text('Play!'));
    await tester.pumpAndSettle();

    final cards = repository.deckById(deck.id)!.cards;
    for (var i = 0; i < 2; i++) {
      final prompt = tester
          .widgetList<Text>(find.byType(Text))
          .map((t) => t.data)
          .firstWhere((text) => cards.any((c) => c.word == text));
      final answer = cards.firstWhere((c) => c.word == prompt).description;
      await tester.tap(find.text(answer));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
    }

    expect(find.text('Play again'), findsOneWidget);
    expect(find.text('20 points'), findsOneWidget);
    expect(repository.deckById(deck.id)!.bestStars, 3);
    // Let the celebration animation finish.
    await tester.pump(const Duration(seconds: 4));
  });
}
