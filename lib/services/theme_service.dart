import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _darkModeKey = 'is_dark_mode';
  static const String _primaryColorKey = 'primary_color';

  // Available color themes
  static const Map<String, String> colorThemes = {
    'blue': 'නිල් පාට (Blue)',
    'pink': 'රෝස පාට (Pink)',
    'green': 'කොළ පාට (Green)',
    'purple': 'දම්වලු පාට (Purple)',
    'orange': 'තෙල්ලු පාට (Orange)',
    'teal': 'තිරු පාට (Teal)',
  };

  static Color _getColorFromString(String colorName) {
    switch (colorName) {
      case 'pink':
        return Colors.pink;
      case 'green':
        return Colors.green;
      case 'purple':
        return Colors.purple;
      case 'orange':
        return Colors.orange;
      case 'teal':
        return Colors.teal;
      default:
        return Colors.blue;
    }
  }

  static Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }

  static Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, isDark);
  }

  static Future<String> getPrimaryColor() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_primaryColorKey) ?? 'blue';
  }

  static Future<void> setPrimaryColor(String colorName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_primaryColorKey, colorName);
  }

  static Future<ThemeData> buildLightTheme() async {
    final colorName = await getPrimaryColor();
    final primaryColor = _getColorFromString(colorName);

    return ThemeData(
      primarySwatch: _getMaterialColorFromColor(primaryColor),
      brightness: Brightness.light,
      fontFamily: 'Noto Sans',
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  static Future<ThemeData> buildDarkTheme() async {
    final colorName = await getPrimaryColor();
    final primaryColor = _getColorFromColor(colorName);

    return ThemeData(
      primarySwatch: _getMaterialColorFromColor(primaryColor),
      brightness: Brightness.dark,
      fontFamily: 'Noto Sans',
      scaffoldBackgroundColor: Colors.grey[900],
      cardColor: Colors.grey[850],
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  static Color _getColorFromColor(String colorName) {
    return _getColorFromString(colorName);
  }

  static MaterialColor _getMaterialColorFromColor(Color color) {
    if (color == Colors.pink) return Colors.pink;
    if (color == Colors.green) return Colors.green;
    if (color == Colors.purple) return Colors.purple;
    if (color == Colors.orange) return Colors.orange;
    if (color == Colors.teal) return Colors.teal;
    return Colors.blue;
  }
}
