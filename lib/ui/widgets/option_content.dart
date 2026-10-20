import 'package:flutter/material.dart';

import '../../logic/study_session.dart';

/// The text and optional picture of one card face.
class OptionContent extends StatelessWidget {
  const OptionContent({
    super.key,
    required this.option,
    this.textStyle,
    this.imageHeight = 100,
    this.textAlign = TextAlign.center,
  });

  final AnswerOption option;
  final TextStyle? textStyle;
  final double imageHeight;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final image = option.imageBytes;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (image != null)
          Padding(
            padding: EdgeInsets.only(bottom: option.text.isEmpty ? 0 : 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                image,
                height: imageHeight,
                fit: BoxFit.contain,
                gaplessPlayback: true,
              ),
            ),
          ),
        if (option.text.isNotEmpty)
          Text(option.text, textAlign: textAlign, style: textStyle),
      ],
    );
  }
}
