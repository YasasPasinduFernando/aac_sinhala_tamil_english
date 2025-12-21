import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyIsRegistered = 'is_registered';
  static const String _keyIsPremium = 'is_premium';
  static const String _keyName = 'user_name';
  static const String _keyPhone = 'user_phone';

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
}
