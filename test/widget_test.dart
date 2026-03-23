import 'package:flutter_test/flutter_test.dart';
import 'package:aac_sinhala_tamil_english/widgets/emoji_text.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('EmojiText renders with NotoColorEmoji font',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmojiText('😊', fontSize: 42),
        ),
      ),
    );

    expect(find.text('😊'), findsOneWidget);

    final textWidget = tester.widget<Text>(find.text('😊'));
    expect(textWidget.style?.fontFamily, equals('NotoColorEmoji'));
    expect(textWidget.style?.fontSize, equals(42));
  });
}
