import 'flash_card.dart';

class Deck {
  const Deck({
    required this.id,
    required this.name,
    this.cards = const [],
    this.bestStars = 0,
    this.bestPoints = 0,
  });

  factory Deck.fromJson(Map<String, dynamic> json) => Deck(
        id: json['id'] as String,
        name: json['name'] as String,
        cards: [
          for (final card in json['cards'] as List<dynamic>)
            FlashCard.fromJson(card as Map<String, dynamic>),
        ],
        bestStars: json['bestStars'] as int? ?? 0,
        bestPoints: json['bestPoints'] as int? ?? 0,
      );

  final String id;
  final String name;
  final List<FlashCard> cards;
  final int bestStars;
  final int bestPoints;

  int get trickyCount => cards.where((c) => c.isTricky).length;

  Deck copyWith({
    String? name,
    List<FlashCard>? cards,
    int? bestStars,
    int? bestPoints,
  }) =>
      Deck(
        id: id,
        name: name ?? this.name,
        cards: cards ?? this.cards,
        bestStars: bestStars ?? this.bestStars,
        bestPoints: bestPoints ?? this.bestPoints,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'cards': [for (final card in cards) card.toJson()],
        'bestStars': bestStars,
        'bestPoints': bestPoints,
      };
}
