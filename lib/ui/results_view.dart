import 'dart:math';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../logic/study_session.dart';
import 'widgets/confetti.dart';
import 'widgets/star_row.dart';

class ResultsView extends StatelessWidget {
  const ResultsView({
    super.key,
    required this.deckName,
    required this.result,
    required this.newBest,
    required this.trickyLeft,
    required this.onPlayAgain,
    required this.onPracticeTricky,
    required this.onBackToDeck,
  });

  final String deckName;
  final RoundResult result;
  final bool newBest;
  final int trickyLeft;
  final VoidCallback onPlayAgain;
  final VoidCallback onPracticeTricky;
  final VoidCallback onBackToDeck;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final messages = {
      3: [l10n.resultPerfect1, l10n.resultPerfect2, l10n.resultPerfect3],
      2: [l10n.resultGood1, l10n.resultGood2, l10n.resultGood3],
      1: [l10n.resultTry1, l10n.resultTry2],
    };
    final options = messages[result.stars]!;
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
                      backgroundColor: const Color(0xFFFFF0B3),
                      side: const BorderSide(
                        color: Color(0xFF9A6200),
                        width: 2,
                      ),
                      avatar: const Icon(
                        Icons.emoji_events_rounded,
                        color: Color(0xFF9A6200),
                      ),
                      label: Text(
                        l10n.newBest,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                Text(
                  l10n.pointsTotal(result.points),
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.firstTryScore(result.firstTryCorrect, result.total),
                  style: theme.textTheme.titleMedium,
                ),
                if (result.bestStreak >= 2)
                  Text(
                    l10n.bestStreak(result.bestStreak),
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
                  label: Text(l10n.playAgain),
                ),
                if (trickyLeft >= 2) ...[
                  const SizedBox(height: 12),
                  FilledButton.tonalIcon(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(260, 56),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: onPracticeTricky,
                    icon: const Icon(Icons.fitness_center_rounded),
                    label: Text(l10n.practiceTricky(trickyLeft)),
                  ),
                ],
                const SizedBox(height: 12),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(260, 56),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: onBackToDeck,
                  child: Text(l10n.backToDeck(deckName)),
                ),
              ],
            ),
          ),
        ),
        if (result.stars == 3 || newBest)
          const Positioned.fill(child: Confetti()),
      ],
    );
  }
}
