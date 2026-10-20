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
    bool onlyTricky = false,
    Random? random,
  }) : assert(cards.length >= 2, 'A round needs at least two cards'),
       _allCards = List.of(cards),
       _random = random ?? Random() {
    var pool = List.of(cards);
    if (onlyTricky) {
      final tricky = pool.where((c) => c.isTricky).toList();
      if (tricky.length >= 2) pool = tricky;
    }
    final shuffled = _weightedShuffle(pool);
    final picked = count == null ? shuffled : shuffled.take(count).toList();
    total = picked.length;
    _queue = [for (final card in picked) _Entry(card)];
    _buildQuestion();
  }

  static const maxOptions = 4;

  /// How much more likely a card is to be picked, by level. Every card can
  /// still show up, and the order is always random.
  static const levelWeights = [8, 4, 2, 1, 1];

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

  /// Per card asked this round: true when answered right on the first try.
  /// Fill-in happens as the round goes on.
  final Map<String, bool> outcomes = {};

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
    if (!entry.isRetry) {
      _completed++;
      outcomes[entry.card.id] = firstTry;
    }

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

  /// Random order where low-level cards tend to come first
  /// (weighted sampling without replacement).
  List<FlashCard> _weightedShuffle(List<FlashCard> pool) {
    final keyed = [
      for (final card in pool)
        (
          card,
          pow(_random.nextDouble(), 1 / levelWeights[card.level.clamp(0, 4)]),
        ),
    ]..sort((a, b) => b.$2.compareTo(a.$2));
    return [for (final (card, _) in keyed) card];
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
    // Wrong answers that resemble the right one (same topic, similar length)
    // are hard to dismiss at a glance. A few of the best matches are picked
    // at random, so the same card does not always get the same company.
    final others = _allCards.where((c) => c.id != card.id).toList()
      ..shuffle(_random);
    final scores = {
      for (final other in others)
        other.id: _similarity(card, other, answerSide),
    };
    others.sort((a, b) => scores[b.id]!.compareTo(scores[a.id]!));
    final pool = others.take(maxOptions).toList()..shuffle(_random);
    final rest = others.skip(pool.length);
    for (final other in [...pool, ...rest]) {
      if (options.length >= maxOptions) break;
      final option = AnswerOption(other, answerSide);
      if (seen.add(option.key)) options.add(option);
    }
    return options..shuffle(_random);
  }

  /// How alike two cards are: shared words (both sides) and answer length.
  static double _similarity(FlashCard a, FlashCard b, CardSide answerSide) {
    final wordsA = _words('${a.word} ${a.description}');
    final wordsB = _words('${b.word} ${b.description}');
    final union = wordsA.union(wordsB).length;
    final overlap = union == 0
        ? 0.0
        : wordsA.intersection(wordsB).length / union;
    int length(FlashCard c) =>
        (answerSide == CardSide.word ? c.word : c.description).length;
    final la = length(a), lb = length(b);
    final closeness = la == 0 && lb == 0
        ? 1.0
        : 1 - (la - lb).abs() / (la > lb ? la : lb);
    return overlap * 2 + closeness;
  }

  static Set<String> _words(String text) => {
    for (final w in text.toLowerCase().split(
      RegExp(r'[^\p{L}\p{N}]+', unicode: true),
    ))
      if (w.length > 3) w,
  };
}
