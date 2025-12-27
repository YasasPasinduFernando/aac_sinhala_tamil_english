import 'package:flutter/material.dart';

/// Stable emoji rendering using Noto Color Emoji font
///
/// This widget solves the Android emoji flickering issue by using
/// the Noto Color Emoji font from Google Fonts, which provides
/// consistent, reliable emoji rendering across all Android devices.
class EmojiText extends StatelessWidget {
  final String emoji;
  final double fontSize;
  final TextAlign? textAlign;
  final int maxLines;

  const EmojiText(
    this.emoji, {
    Key? key,
    this.fontSize = 50,
    this.textAlign,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      emoji,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: 'NotoColorEmoji', // Use Noto Color Emoji font
        height: 1.2,
        letterSpacing: 0,
      ),
      textAlign: textAlign ?? TextAlign.center,
      maxLines: maxLines,
      overflow: TextOverflow.visible,
    );
  }
}
