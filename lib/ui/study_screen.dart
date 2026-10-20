import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/deck_repository.dart';
import '../l10n/app_localizations.dart';
import '../logic/study_session.dart';
import '../models/study_mode.dart';
import 'deck_editor_screen.dart';
import 'palette.dart';
import 'results_view.dart';
import 'widgets/answer_tile.dart';
import 'widgets/option_content.dart';
import 'widgets/text_prompt.dart';

/// A matching round. There is deliberately nothing here that edits cards.
class StudyScreen extends StatefulWidget {
  const StudyScreen({
    super.key,
    required this.repository,
    required this.deckId,
    required this.mode,
    this.count,
    this.onlyTricky = false,
  });

  final DeckRepository repository;
  final String deckId;
  final StudyMode mode;
  final int? count;
  final bool onlyTricky;

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  final _random = Random();
  late StudySession _session;
  final _wrong = <String>{};
  String? _correct;
  String? _message;
  bool _messageIsCorrect = true;
  bool _locked = false;
  bool _newBest = false;
  late bool _onlyTricky = widget.onlyTricky;

  @override
  void initState() {
    super.initState();
    _startRound();
  }

  void _startRound() {
    final deck = widget.repository.deckById(widget.deckId)!;
    _session = StudySession(
      cards: deck.cards,
      mode: widget.mode,
      count: widget.count,
      onlyTricky: _onlyTricky,
    );
    _wrong.clear();
    _correct = null;
    _message = null;
    _locked = false;
    _newBest = false;
  }

  Future<void> _onTap(AnswerOption option) async {
    if (_locked || _wrong.contains(option.key)) return;
    final l10n = AppLocalizations.of(context);
    final result = _session.answer(option);

    if (!result.correct) {
      HapticFeedback.heavyImpact();
      setState(() {
        _wrong.add(option.key);
        _message = l10n.tryAgain;
        _messageIsCorrect = false;
      });
      return;
    }

    final cheers = [
      l10n.cheer1,
      l10n.cheer2,
      l10n.cheer3,
      l10n.cheer4,
      l10n.cheer5,
      l10n.cheer6,
    ];
    HapticFeedback.mediumImpact();
    setState(() {
      _locked = true;
      _messageIsCorrect = true;
      _correct = option.key;
      _message = result.streakBonus > 0
          ? l10n.streakBonus(result.streak, result.streakBonus)
          : cheers[_random.nextInt(cheers.length)];
    });
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    _session.advance();
    if (_session.isFinished) {
      final round = _session.result;
      widget.repository.recordCardOutcomes(widget.deckId, _session.outcomes);
      _newBest = widget.repository.recordResult(
        widget.deckId,
        stars: round.stars,
        points: round.points,
      );
    }
    setState(() {
      _locked = false;
      _correct = null;
      _message = null;
      _wrong.clear();
    });
  }

  Future<void> _confirmQuit() async {
    final l10n = AppLocalizations.of(context);
    final quit = await confirm(
      context,
      title: l10n.stopTitle,
      message: l10n.stopMessage,
      confirmLabel: l10n.stop,
      cancelLabel: l10n.keepPlaying,
    );
    if (quit && mounted) Navigator.of(context).pop();
  }

  void _backToDeck() => Navigator.of(context).popUntil(
        (route) => route.settings.name == DeckEditorScreen.routeName,
      );

  @override
  Widget build(BuildContext context) {
    final deck = widget.repository.deckById(widget.deckId)!;
    if (_session.isFinished) {
      return Scaffold(
        body: SafeArea(
          child: ResultsView(
            deckName: deck.name,
            result: _session.result,
            newBest: _newBest,
            trickyLeft: deck.trickyCount,
            onPlayAgain: () => setState(() {
              _onlyTricky = false;
              _startRound();
            }),
            onPracticeTricky: () => setState(() {
              _onlyTricky = true;
              _startRound();
            }),
            onBackToDeck: _backToDeck,
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmQuit();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _Header(session: _session, onClose: _confirmQuit),
              Expanded(child: _buildQuestion(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion(BuildContext context) {
    final question = _session.current;
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, animation) => SlideTransition(
              position: Tween(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: Card(
              key: ValueKey(question.number),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 160),
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF6C40F5), Color(0xFFD81B60)],
                  ),
                ),
                child: OptionContent(
                  option: question.prompt,
                  imageHeight: 140,
                  textStyle: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: CurvedAnimation(
                    parent: animation,
                    curve: Curves.elasticOut,
                  ),
                  child: child,
                ),
                child: _feedback(theme),
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              const gap = 12.0;
              final wide = constraints.maxWidth >= 600;
              final width =
                  wide ? (constraints.maxWidth - gap) / 2 : constraints.maxWidth;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final (index, option) in question.options.indexed)
                    SizedBox(
                      width: width,
                      child: AnswerTile(
                        key: ValueKey('${question.number}-${option.key}'),
                        option: option,
                        color: playfulColor(index),
                        state: _tileState(option),
                        onTap: () => _onTap(option),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  /// The line under the question: neutral hint, or a green/red verdict.
  Widget _feedback(ThemeData theme) {
    final message = _message;
    if (message == null) {
      return Text(
        AppLocalizations.of(context).whichMatches,
        key: const ValueKey('hint'),
        style:
            theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      );
    }
    final color =
        _messageIsCorrect ? Colors.green.shade800 : Colors.red.shade800;
    return Container(
      key: ValueKey('$message-$_messageIsCorrect-${_wrong.length}'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        message,
        style: theme.textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  TileState _tileState(AnswerOption option) {
    if (option.key == _correct) return TileState.correct;
    if (_wrong.contains(option.key)) return TileState.wrong;
    return TileState.idle;
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.session, required this.onClose});

  final StudySession session;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            tooltip: AppLocalizations.of(context).stopTooltip,
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: session.progress),
                duration: const Duration(milliseconds: 400),
                builder: (context, value, _) => LinearProgressIndicator(
                  value: value,
                  minHeight: 14,
                  color: const Color(0xFFC2410C),
                  backgroundColor: const Color(0xFFF5E1D8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          if (session.streak >= 2)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                '🔥${session.streak}',
                style: theme.textTheme.titleLarge,
              ),
            ),
          Chip(
            avatar: Icon(Icons.star_rounded, color: Colors.amber.shade800),
            label: Text(
              '${session.points}',
              style: theme.textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
