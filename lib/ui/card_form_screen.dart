import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../data/deck_repository.dart';
import '../l10n/app_localizations.dart';
import '../models/flash_card.dart';

class CardFormScreen extends StatefulWidget {
  const CardFormScreen({
    super.key,
    required this.repository,
    required this.deckId,
    this.card,
  });

  final DeckRepository repository;
  final String deckId;

  /// The card being edited, or null when adding a new one.
  final FlashCard? card;

  @override
  State<CardFormScreen> createState() => _CardFormScreenState();
}

class _CardFormScreenState extends State<CardFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _word = TextEditingController(text: widget.card?.word);
  late final _description = TextEditingController(
    text: widget.card?.description,
  );
  late String? _imageBase64 = widget.card?.imageBase64;
  bool _showImageError = false;

  @override
  void dispose() {
    _word.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final editing = widget.card != null;
    final imageBytes = _imageBase64 == null
        ? null
        : base64Decode(_imageBase64!);
    return Scaffold(
      appBar: AppBar(title: Text(editing ? l10n.editCard : l10n.newCard)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _word,
              autofocus: !editing,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(fontSize: 20),
              decoration: InputDecoration(labelText: l10n.wordLabel),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? l10n.typeTheWord
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _description,
              minLines: 2,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(fontSize: 20),
              decoration: InputDecoration(labelText: l10n.descriptionLabel),
            ),
            const SizedBox(height: 16),
            if (imageBytes != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.memory(
                  imageBytes,
                  height: 180,
                  fit: BoxFit.contain,
                ),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _choosePicture,
                    icon: const Icon(Icons.add_a_photo_outlined),
                    label: Text(
                      imageBytes == null ? l10n.addPicture : l10n.changePicture,
                    ),
                  ),
                ),
                if (imageBytes != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: l10n.removePicture,
                    onPressed: () => setState(() => _imageBase64 = null),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ],
            ),
            if (_showImageError)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  l10n.needDescriptionOrPicture,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            const SizedBox(height: 24),
            FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(64),
                textStyle: const TextStyle(fontSize: 22),
              ),
              onPressed: _save,
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _choosePicture() async {
    final l10n = AppLocalizations.of(context);
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.chooseFromGallery),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l10n.takePhoto),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        maxWidth: 480,
        maxHeight: 480,
        imageQuality: 70,
      );
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      if (!mounted) return;
      setState(() {
        _imageBase64 = base64Encode(bytes);
        _showImageError = false;
      });
    } on PlatformException {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.pictureError)));
    }
  }

  void _save() {
    final hasContent =
        _description.text.trim().isNotEmpty || _imageBase64 != null;
    setState(() => _showImageError = !hasContent);
    if (!_formKey.currentState!.validate() || !hasContent) return;

    final card = widget.card;
    if (card == null) {
      widget.repository.addCard(
        widget.deckId,
        word: _word.text,
        description: _description.text,
        imageBase64: _imageBase64,
      );
    } else {
      widget.repository.updateCard(
        widget.deckId,
        card.copyWith(
          word: _word.text.trim(),
          description: _description.text.trim(),
          imageBase64: _imageBase64,
          clearImage: _imageBase64 == null,
        ),
      );
    }
    Navigator.pop(context);
  }
}
