import 'package:flutter/material.dart';

class AppTheme {
  // 🎀 ගිරු දරුවුන් සඳහා - Pink/Rose Theme
  static const girlThemeColors = {
    'primary': Color(0xFFFF69B4), // Hot Pink
    'secondary': Color(0xFFFFC0CB), // Light Pink
    'accent': Color(0xFFFFB6C1), // Light Pink Accent
    'gradient1': Color(0xFFFFB6E1), // Rose Pink
    'gradient2': Color(0xFFFF69B4), // Hot Pink
    'background': Color(0xFFFFF0F5), // Lavender Blush
    'cardColor': Color(0xFFFFDEEB), // Pink Card
    'textColor': Color(0xFF8B0043), // Deep Pink Text
  };

  // 👦 පිරිමු දරුවුන් සඳහා - Blue/Sky Theme
  static const boyThemeColors = {
    'primary': Color(0xFF00A8E8), // Sky Blue
    'secondary': Color(0xFF00D4FF), // Light Blue
    'accent': Color(0xFF00BFFF), // Deep Sky Blue
    'gradient1': Color(0xFF87CEEB), // Sky Blue
    'gradient2': Color(0xFF00A8E8), // Dodger Blue
    'background': Color(0xFFE0F7FF), // Light Blue Background
    'cardColor': Color(0xFFB3E5FC), // Blue Card
    'textColor': Color(0xFF01579B), // Dark Blue Text
  };

  // Get theme based on gender
  static Map<String, Color> getThemeColors(bool isGirl) {
    return isGirl ? girlThemeColors : boyThemeColors;
  }

  // Get gradient colors
  static LinearGradient getGradient(bool isGirl) {
    final colors = getThemeColors(isGirl);
    return LinearGradient(
      colors: [
        colors['gradient1']!,
        colors['gradient2']!,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  // Get AppBarTheme
  static AppBarTheme getAppBarTheme(bool isGirl) {
    final colors = getThemeColors(isGirl);
    return AppBarTheme(
      backgroundColor: colors['primary'],
      foregroundColor: Colors.white,
      elevation: 5,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  // Get ThemeData
  static ThemeData getThemeData(bool isGirl) {
    final colors = getThemeColors(isGirl);
    return ThemeData(
      useMaterial3: true,
      primaryColor: colors['primary'],
      secondaryHeaderColor: colors['secondary'],
      scaffoldBackgroundColor: colors['background'],
      appBarTheme: getAppBarTheme(isGirl),
      fontFamily: 'Noto Sans',
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors['primary'],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: colors['cardColor'],
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
