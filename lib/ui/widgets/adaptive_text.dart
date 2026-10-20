import 'dart:math';

import 'package:flutter/painting.dart';

/// A font size that shrinks smoothly as the text gets longer, so a one-word
/// card and a three-sentence answer both fit comfortably.
double adaptiveFontSize(
  int length, {
  required double max,
  required double min,
  int shortLength = 24,
  int longLength = 220,
}) {
  final t = ((length - shortLength) / (longLength - shortLength)).clamp(
    0.0,
    1.0,
  );
  return max + (min - max) * t;
}

/// Centered text suits a word, but sentences read better aligned to the start.
TextAlign adaptiveAlign(int length, {int centerUpTo = 60}) =>
    length <= centerUpTo ? TextAlign.center : TextAlign.start;

/// The longest text length among [lengths], 0 when empty.
int longest(Iterable<int> lengths) => lengths.fold(0, max);
