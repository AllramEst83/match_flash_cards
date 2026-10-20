import 'package:flutter/material.dart';

/// Bright colors that all keep white text readable.
const playfulColors = [
  Color(0xFFE94F6C), // pink
  Color(0xFF2E86DE), // blue
  Color(0xFF3F51B5), // indigo
  Color(0xFFE0701A), // orange
  Color(0xFF8E5CF7), // purple
  Color(0xFF0097A7), // teal
];

Color playfulColor(int index) => playfulColors[index % playfulColors.length];

/// A stable color for an id, so a deck or card keeps its color.
Color colorForId(String id) =>
    playfulColor(id.codeUnits.fold(0, (sum, unit) => sum + unit));
