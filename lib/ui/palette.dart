import 'package:flutter/material.dart';

/// Vivid colors that all give white text at least 4.5:1 contrast (WCAG AA).
const playfulColors = [
  Color(0xFFD81B60), // pink
  Color(0xFF1565C0), // blue
  Color(0xFF7E3FF2), // purple
  Color(0xFFC2410C), // orange
  Color(0xFF2E7D32), // green
  Color(0xFF00796B), // teal
];

/// Text on the pale tints below: 13:1 and 8.5:1 contrast.
const ink = Color(0xFF1B1B24);
const inkSoft = Color(0xFF3A3A48);

/// A solid pale version of [color] for card backgrounds, so dark text stays
/// readable (a see-through tint turns muddy over the card surface).
Color tintOf(Color color, [double amount = 0.16]) =>
    Color.alphaBlend(color.withValues(alpha: amount), Colors.white);

Color playfulColor(int index) => playfulColors[index % playfulColors.length];

/// A stable color for an id, so a deck or card keeps its color.
Color colorForId(String id) =>
    playfulColor(id.codeUnits.fold(0, (sum, unit) => sum + unit));
