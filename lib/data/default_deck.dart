import '../models/deck.dart';
import '../models/flash_card.dart';
import '../models/ids.dart';

/// The deck a fresh install starts with. Replace or delete this file to
/// change the starter content (see DeckRepository._load).
Deck defaultDeck() {
  const cards = [
    (
      'grundämne',
      'ett ämne som består av en enda sorts atom ( ex guld, svavel, syre)',
    ),
    (
      'metaller',
      'en stor grupp av grundämnen som leder värme och el och blänker. '
          'De flesta grundämnena är metaller',
    ),
    ('lösning', 'en blandning där man inte kan se olika beståndsdelar.'),
    (
      'rent ämne',
      'är ett ämne som innehåller bara en sorts kemiskt ämne. '
          'ex guld, destillerat vatten',
    ),
    (
      'materia',
      'är något som man kan väga. Allt som går att väga är alltså materia.',
    ),
    ('material', 'är något som vi kan tillverka saker av.'),
    ('halvmetaller', 'ämne som liknar både metall och icke-metall'),
    (
      'kemisk förening eller förening',
      'ett ämne som består av minst två sorters atomer ( ex vatten)',
    ),
    ('blandning', 'när det finns fler en ett ämne blandat i något'),
    ('icke-metaller', 'grundämne som inte har metalliska egenskaper'),
  ];
  return Deck(
    id: newId(),
    name: 'Materia och material',
    cards: [
      for (final (word, description) in cards)
        FlashCard(id: newId(), word: word, description: description),
    ],
  );
}
