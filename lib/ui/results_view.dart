import 'dart:math';

import 'package:flutter/material.dart';

import '../logic/study_session.dart';
import 'widgets/confetti.dart';
import 'widgets/star_row.dart';

class ResultsView extends StatelessWidget {
  const ResultsView({
    super.key,
    required this.deckName,
    required this.result,
    required this.newBest,
    required this.onPlayAgain,
    required this.onBackToDeck,
  });

  final String deckName;
  final RoundResult result;
  final bool newBest;
  final VoidCallback onPlayAgain;
  final VoidCallback onBackToDeck;

  static const _messages = {
    3: ['Perfect round!', 'You are a star!', 'Wow, amazing!'],
    2: ['Great work!', 'Almost perfect!', 'Nice going!'],
    1: ['Good try! Play again to earn more stars.', 'Keep practicing!'],
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final options = _messages[result.stars]!;
    final message = options[Random().nextInt(options.length)];
    return Stack(
      children: [
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                StarRow(stars: result.stars, size: 72, animate: true),
                if (newBest)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Chip(
                      avatar: const Icon(Icons.emoji_events_rounded),
                      label: Text(
                        'New best!',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                Text('${result.points} points', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  '${result.firstTryCorrect} of ${result.total} right on the first try',
                  style: theme.textTheme.titleMedium,
                ),
                if (result.bestStreak >= 2)
                  Text(
                    'Best streak: 🔥 ${result.bestStreak}',
                    style: theme.textTheme.titleMedium,
                  ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(260, 64),
                    textStyle: const TextStyle(fontSize: 22),
                  ),
                  onPressed: onPlayAgain,
                  icon: const Icon(Icons.replay_rounded),
                  label: const Text('Play again'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(260, 56),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: onBackToDeck,
                  child: Text('Back to $deckName'),
                ),
              ],
            ),
          ),
        ),
        if (result.stars == 3 || newBest) const Positioned.fill(child: Confetti()),
      ],
    );
  }
}
