import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aac_sinhala_tamil_english/screens/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    test('returns girl colors when isGirl is true', () {
      final colors = AppTheme.getThemeColors(true);
      expect(colors['primary'], equals(const Color(0xFFFF69B4)));
    });

    test('returns boy colors when isGirl is false', () {
      final colors = AppTheme.getThemeColors(false);
      expect(colors['primary'], equals(const Color(0xFF00A8E8)));
    });

    test('builds ThemeData with expected app bar color', () {
      final theme = AppTheme.getThemeData(true);
      expect(theme.appBarTheme.backgroundColor, equals(const Color(0xFFFF69B4)));
    });
  });
}
