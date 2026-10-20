import 'dart:convert';
import 'dart:typed_data';

class FlashCard {
  FlashCard({
    required this.id,
    required this.word,
    this.description = '',
    this.imageBase64,
  });

  factory FlashCard.fromJson(Map<String, dynamic> json) => FlashCard(
        id: json['id'] as String,
        word: json['word'] as String,
        description: json['description'] as String? ?? '',
        imageBase64: json['image'] as String?,
      );

  final String id;
  final String word;
  final String description;

  /// Optional picture, shown with the description side of the card.
  final String? imageBase64;

  Uint8List? _imageBytes;

  Uint8List? get imageBytes {
    final encoded = imageBase64;
    if (encoded == null) return null;
    return _imageBytes ??= base64Decode(encoded);
  }

  FlashCard copyWith({
    String? word,
    String? description,
    String? imageBase64,
    bool clearImage = false,
  }) =>
      FlashCard(
        id: id,
        word: word ?? this.word,
        description: description ?? this.description,
        imageBase64: clearImage ? null : (imageBase64 ?? this.imageBase64),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'word': word,
        'description': description,
        if (imageBase64 != null) 'image': imageBase64,
      };
}
