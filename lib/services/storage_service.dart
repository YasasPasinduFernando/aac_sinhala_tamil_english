import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static const String _keyIsRegistered = 'is_registered';
  static const String _keyIsPremium = 'is_premium';
  static const String _keyName = 'user_name';
  static const String _keyPhone = 'user_phone';
  static const String _keyPinnedCategories = 'pinned_categories';
  static const String _keyHiddenCategories = 'hidden_categories';
  static const String _keyCustomWords = 'custom_words';
  static const String _keyQuickAccessWords = 'quick_access_words';
  static const String _keyKidMode = 'kid_mode';

  static Future<bool> isRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsRegistered) ?? false;
  }

  static Future<bool> isPremium() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsPremium) ?? false;
  }

  static Future<void> saveUserData({
    required String name,
    required String phone,
    required bool isPremium,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsRegistered, true);
    await prefs.setBool(_keyIsPremium, isPremium);
    await prefs.setString(_keyName, name);
    await prefs.setString(_keyPhone, phone);
  }

  static Future<List<String>> getPinnedCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_keyPinnedCategories);
    if (json == null) return [];
    return List<String>.from(jsonDecode(json));
  }

  static Future<void> savePinnedCategories(List<String> categories) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPinnedCategories, jsonEncode(categories));
  }

  static Future<List<String>> getHiddenCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_keyHiddenCategories);
    if (json == null) return [];
    return List<String>.from(jsonDecode(json));
  }

  static Future<void> saveHiddenCategories(List<String> categories) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyHiddenCategories, jsonEncode(categories));
  }

  static Future<List<Map<String, dynamic>>> getCustomWords() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_keyCustomWords);
    if (json == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(json));
  }

  static Future<void> saveCustomWords(List<Map<String, dynamic>> words) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCustomWords, jsonEncode(words));
  }

  static Future<List<Map<String, dynamic>>> getQuickAccessWords() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_keyQuickAccessWords);
    if (json == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(json));
  }

  static Future<void> saveQuickAccessWords(
      List<Map<String, dynamic>> words) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyQuickAccessWords, jsonEncode(words));
  }

  static Future<bool> isKidMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyKidMode) ?? true;
  }

  static Future<void> setKidMode(bool kidMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyKidMode, kidMode);
  }
}
