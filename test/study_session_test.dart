import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:match_flash_cards/logic/study_session.dart';
import 'package:match_flash_cards/models/flash_card.dart';
import 'package:match_flash_cards/models/study_mode.dart';

List<FlashCard> _cards(int n) => [
      for (var i = 0; i < n; i++)
        FlashCard(id: 'id$i', word: 'word$i', description: 'desc$i'),
    ];

AnswerOption _correct(StudySession s) =>
    s.current.options.firstWhere((o) => o.card.id == s.current.card.id);

AnswerOption _wrong(StudySession s) =>
    s.current.options.firstWhere((o) => o.card.id != s.current.card.id);

void _playPerfect(StudySession s) {
  while (!s.isFinished) {
    s.answer(_correct(s));
    s.advance();
  }
}

void main() {
  group('options', () {
    test('contain the correct answer, no duplicates, up to four', () {
      final session = StudySession(cards: _cards(10), mode: StudyMode.words);
      while (!session.isFinished) {
        final options = session.current.options;
        expect(options.length, 4);
        expect(options.map((o) => o.key).toSet().length, 4);
        expect(options.where((o) => o.card.id == session.current.card.id), hasLength(1));
        session.answer(_correct(session));
        session.advance();
      }
    });

    test('use fewer options in small decks', () {
      final session = StudySession(cards: _cards(3), mode: StudyMode.words);
      expect(session.current.options.length, 3);
    });

    test('skip distractors that look identical to another option', () {
      final cards = [
        FlashCard(id: 'a', word: 'Big', description: 'Large'),
        FlashCard(id: 'b', word: 'Huge', description: 'large'),
        FlashCard(id: 'c', word: 'Tiny', description: 'Small'),
      ];
      for (var seed = 0; seed < 20; seed++) {
        final session = StudySession(
          cards: cards,
          mode: StudyMode.words,
          random: Random(seed),
        );
        final keys = session.current.options.map((o) => o.key).toList();
        expect(keys.toSet().length, keys.length);
      }
    });
  });

  group('modes', () {
    test('words mode always prompts with the word', () {
      final session = StudySession(cards: _cards(6), mode: StudyMode.words);
      while (!session.isFinished) {
        expect(session.current.promptSide, CardSide.word);
        expect(session.current.options.every((o) => o.side == CardSide.description), isTrue);
        session.answer(_correct(session));
        session.advance();
      }
    });

    test('descriptions mode always prompts with the description', () {
      final session = StudySession(cards: _cards(6), mode: StudyMode.descriptions);
      while (!session.isFinished) {
        expect(session.current.promptSide, CardSide.description);
        expect(session.current.options.every((o) => o.side == CardSide.word), isTrue);
        session.answer(_correct(session));
        session.advance();
      }
    });

    test('mix mode uses both sides', () {
      final sides = <CardSide>{};
      final session = StudySession(
        cards: _cards(20),
        mode: StudyMode.mix,
        random: Random(1),
      );
      while (!session.isFinished) {
        sides.add(session.current.promptSide);
        session.answer(_correct(session));
        session.advance();
      }
      expect(sides, {CardSide.word, CardSide.description});
    });
  });

  group('randomization', () {
    List<String> order(int seed) {
      final session = StudySession(
        cards: _cards(10),
        mode: StudyMode.words,
        random: Random(seed),
      );
      final ids = <String>[];
      while (!session.isFinished) {
        ids.add(session.current.card.id);
        session.answer(_correct(session));
        session.advance();
      }
      return ids;
    }

    test('card order differs between rounds', () {
      final orders = {for (var seed = 0; seed < 5; seed++) order(seed).join(',')};
      expect(orders.length, greaterThan(1));
    });

    test('every card is shown once in a clean round', () {
      expect(order(3).toSet().length, 10);
    });

    test('the same seed gives the same round', () {
      expect(order(7), order(7));
    });

    test('the correct answer is not always in the same slot', () {
      final slots = <int>{};
      for (var seed = 0; seed < 20; seed++) {
        final session = StudySession(
          cards: _cards(8),
          mode: StudyMode.words,
          random: Random(seed),
        );
        slots.add(session.current.options.indexOf(_correct(session)));
      }
      expect(slots.length, greaterThan(1));
    });

    test('count limits the round length', () {
      final session = StudySession(cards: _cards(10), mode: StudyMode.words, count: 5);
      var shown = 0;
      while (!session.isFinished) {
        shown++;
        session.answer(_correct(session));
        session.advance();
      }
      expect(shown, 5);
      expect(session.total, 5);
    });
  });

  group('scoring', () {
    test('perfect round gives 3 stars and streak bonuses', () {
      final session = StudySession(cards: _cards(10), mode: StudyMode.words);
      _playPerfect(session);
      // 10 x 10 points + bonuses at streak 3 (5), 5 (10) and 10 (20).
      expect(session.points, 100 + 5 + 10 + 20);
      expect(session.result.stars, 3);
      expect(session.bestStreak, 10);
      expect(session.progress, 1);
    });

    test('a second try is worth 5 and resets the streak', () {
      final session = StudySession(cards: _cards(4), mode: StudyMode.words);
      final miss = session.answer(_wrong(session));
      expect(miss.correct, isFalse);
      expect(session.streak, 0);
      final hit = session.answer(_correct(session));
      expect(hit.points, 5);
      expect(session.streak, 0);
    });

    test('stars follow the first-try ratio', () {
      final session = StudySession(cards: _cards(5), mode: StudyMode.words);
      // Miss two of five cards on the first try: 3/5 = 60% = 2 stars.
      // The first two questions are always original cards, never retries.
      var question = 0;
      while (!session.isFinished) {
        if (question < 2) session.answer(_wrong(session));
        session.answer(_correct(session));
        session.advance();
        question++;
      }
      expect(session.result.firstTryCorrect, 3);
      expect(session.result.stars, 2);
    });

    test('finishing with many misses still earns one star', () {
      final session = StudySession(cards: _cards(3), mode: StudyMode.words);
      while (!session.isFinished) {
        session.answer(_wrong(session));
        session.answer(_correct(session));
        session.advance();
      }
      expect(session.result.stars, 1);
    });
  });

  group('missed cards', () {
    test('come back later in the round', () {
      final session = StudySession(
        cards: _cards(5),
        mode: StudyMode.words,
        random: Random(2),
      );
      final missedId = session.current.card.id;
      session.answer(_wrong(session));
      session.answer(_correct(session));
      session.advance();

      var seenAgain = 0;
      var steps = 0;
      while (!session.isFinished) {
        if (session.current.card.id == missedId) seenAgain++;
        steps++;
        session.answer(_correct(session));
        session.advance();
      }
      expect(seenAgain, 1);
      expect(steps, 5); // 4 other cards + the retry
    });

    test('never repeat straight away while other cards remain', () {
      for (var seed = 0; seed < 30; seed++) {
        final session = StudySession(
          cards: _cards(6),
          mode: StudyMode.words,
          random: Random(seed),
        );
        final missedId = session.current.card.id;
        session.answer(_wrong(session));
        session.answer(_correct(session));
        session.advance();
        expect(session.current.card.id, isNot(missedId));
      }
    });

    test('a retry does not requeue again', () {
      final session = StudySession(cards: _cards(2), mode: StudyMode.words);
      // Miss card A twice: it is queued behind B exactly once.
      session.answer(_wrong(session));
      session.answer(_wrong(session));
      session.answer(_correct(session));
      session.advance();
      session.answer(_correct(session)); // B
      session.advance();
      // The retry of A can be missed without queueing it again.
      session.answer(_wrong(session));
      session.answer(_correct(session));
      session.advance();
      expect(session.isFinished, isTrue);
    });
  });

  group('spaced repetition', () {
    List<FlashCard> leveled() => [
          for (var i = 0; i < 10; i++)
            FlashCard(
              id: 'id$i',
              word: 'word$i',
              description: 'desc$i',
              level: i < 2 ? 0 : 4,
            ),
        ];

    test('tricky cards are picked more often when the round is short', () {
      var trickyPicks = 0;
      for (var seed = 0; seed < 300; seed++) {
        final session = StudySession(
          cards: leveled(),
          mode: StudyMode.words,
          count: 3,
          random: Random(seed),
        );
        if (session.current.card.level == 0) trickyPicks++;
      }
      // First card is a tricky one far more than the 20% chance by luck.
      expect(trickyPicks, greaterThan(150));
    });

    test('every card can still be picked', () {
      final seen = <String>{};
      for (var seed = 0; seed < 400; seed++) {
        seen.add(StudySession(
          cards: leveled(),
          mode: StudyMode.words,
          count: 1,
          random: Random(seed),
        ).current.card.id);
      }
      expect(seen.length, 10);
    });

    test('tricky-only rounds ask just the tricky cards', () {
      final session = StudySession(
        cards: leveled(),
        mode: StudyMode.words,
        onlyTricky: true,
      );
      expect(session.total, 2);
      expect(session.current.options.length, 4);
    });

    test('records first-try outcomes per card', () {
      final session = StudySession(cards: _cards(3), mode: StudyMode.words);
      final missed = session.current.card.id;
      session.answer(_wrong(session));
      session.answer(_correct(session));
      session.advance();
      while (!session.isFinished) {
        session.answer(_correct(session));
        session.advance();
      }
      expect(session.outcomes[missed], isFalse);
      expect(session.outcomes.values.where((ok) => ok), hasLength(2));
    });
  });
}
