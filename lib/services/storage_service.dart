import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyIsRegistered = 'is_registered';
  static const String _keyIsPremium = 'is_premium';
  static const String _keyName = 'user_name';
  static const String _keyGender = 'user_gender';

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
    required String gender,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsRegistered, true);
    await prefs.setBool(_keyIsPremium, true);
    await prefs.setString(_keyName, name);
    await prefs.setString(_keyGender, gender);
  }

  static Future<String?> getGender() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyGender);
  }
}
