import 'dart:math';
import 'dart:typed_data';

import '../models/flash_card.dart';
import '../models/study_mode.dart';

enum CardSide { word, description }

extension CardSideOpposite on CardSide {
  CardSide get opposite =>
      this == CardSide.word ? CardSide.description : CardSide.word;
}

/// One face of a card, shown either as a prompt or as an answer tile.
class AnswerOption {
  const AnswerOption(this.card, this.side);

  final FlashCard card;
  final CardSide side;

  String get text => side == CardSide.word ? card.word : card.description;

  Uint8List? get imageBytes =>
      side == CardSide.description ? card.imageBytes : null;

  /// Identifies what the kid sees, so cards that look identical collapse.
  String get key => side == CardSide.word
      ? 'w:${card.word.trim().toLowerCase()}'
      : 'd:${card.description.trim().toLowerCase()}|${card.imageBase64?.hashCode}';
}

class Question {
  const Question({
    required this.number,
    required this.card,
    required this.promptSide,
    required this.options,
  });

  final int number;
  final FlashCard card;
  final CardSide promptSide;
  final List<AnswerOption> options;

  AnswerOption get prompt => AnswerOption(card, promptSide);
}

class AnswerResult {
  const AnswerResult({
    required this.correct,
    this.points = 0,
    this.streakBonus = 0,
    this.streak = 0,
  });

  final bool correct;
  final int points;
  final int streakBonus;
  final int streak;
}

class RoundResult {
  const RoundResult({
    required this.stars,
    required this.points,
    required this.bestStreak,
    required this.firstTryCorrect,
    required this.total,
  });

  final int stars;
  final int points;
  final int bestStreak;
  final int firstTryCorrect;
  final int total;
}

class _Entry {
  _Entry(this.card, {this.isRetry = false});

  final FlashCard card;
  final bool isRetry;
  int wrongTaps = 0;
}

/// A single study round. Pure Dart so it can be tested with a seeded [Random].
class StudySession {
  StudySession({
    required List<FlashCard> cards,
    required this.mode,
    int? count,
    Random? random,
  })  : assert(cards.length >= 2, 'A round needs at least two cards'),
        _allCards = List.of(cards),
        _random = random ?? Random() {
    final shuffled = List.of(cards)..shuffle(_random);
    final picked = count == null ? shuffled : shuffled.take(count).toList();
    total = picked.length;
    _queue = [for (final card in picked) _Entry(card)];
    _buildQuestion();
  }

  static const maxOptions = 4;

  final StudyMode mode;
  final List<FlashCard> _allCards;
  final Random _random;

  late final int total;
  late List<_Entry> _queue;
  Question? _current;
  int _questionNumber = 0;
  bool _resolved = false;
  int _completed = 0;
  int _firstTryCorrect = 0;

  int points = 0;
  int streak = 0;
  int bestStreak = 0;

  bool get isFinished => _queue.isEmpty;

  Question get current => _current!;

  double get progress => total == 0 ? 1 : _completed / total;

  RoundResult get result {
    final ratio = total == 0 ? 1.0 : _firstTryCorrect / total;
    final stars = ratio >= 0.9 ? 3 : (ratio >= 0.6 ? 2 : 1);
    return RoundResult(
      stars: stars,
      points: points,
      bestStreak: bestStreak,
      firstTryCorrect: _firstTryCorrect,
      total: total,
    );
  }

  AnswerResult answer(AnswerOption option) {
    assert(!isFinished && !_resolved, 'Call advance() before answering again');
    final entry = _queue.first;

    if (option.card.id != entry.card.id) {
      entry.wrongTaps++;
      streak = 0;
      if (entry.wrongTaps == 1 && !entry.isRetry) _requeue(entry.card);
      return const AnswerResult(correct: false);
    }

    final firstTry = entry.wrongTaps == 0 && !entry.isRetry;
    final gained = entry.isRetry
        ? 2
        : switch (entry.wrongTaps) {
            0 => 10,
            1 => 5,
            _ => 2,
          };

    var bonus = 0;
    if (firstTry) {
      _firstTryCorrect++;
      streak++;
      if (streak > bestStreak) bestStreak = streak;
      bonus = switch (streak) {
        3 => 5,
        5 => 10,
        10 => 20,
        _ => 0,
      };
    }
    if (!entry.isRetry) _completed++;

    points += gained + bonus;
    _resolved = true;
    return AnswerResult(
      correct: true,
      points: gained + bonus,
      streakBonus: bonus,
      streak: streak,
    );
  }

  /// Moves on after a correct answer.
  void advance() {
    assert(_resolved, 'Answer the current question first');
    _queue.removeAt(0);
    _resolved = false;
    _buildQuestion();
  }

  /// Puts a missed card back later in the round, never straight away unless
  /// it is the only card left.
  void _requeue(FlashCard card) {
    final earliest = min(2, _queue.length);
    final index = earliest + _random.nextInt(_queue.length - earliest + 1);
    _queue.insert(index, _Entry(card, isRetry: true));
  }

  void _buildQuestion() {
    if (_queue.isEmpty) {
      _current = null;
      return;
    }
    final card = _queue.first.card;
    final promptSide = switch (mode) {
      StudyMode.words => CardSide.word,
      StudyMode.descriptions => CardSide.description,
      StudyMode.mix =>
        _random.nextBool() ? CardSide.word : CardSide.description,
    };
    _current = Question(
      number: ++_questionNumber,
      card: card,
      promptSide: promptSide,
      options: _buildOptions(card, promptSide.opposite),
    );
  }

  List<AnswerOption> _buildOptions(FlashCard card, CardSide answerSide) {
    final correct = AnswerOption(card, answerSide);
    final seen = {correct.key};
    final options = [correct];
    final others = _allCards.where((c) => c.id != card.id).toList()
      ..shuffle(_random);
    for (final other in others) {
      if (options.length >= maxOptions) break;
      final option = AnswerOption(other, answerSide);
      if (seen.add(option.key)) options.add(option);
    }
    return options..shuffle(_random);
  }
}
