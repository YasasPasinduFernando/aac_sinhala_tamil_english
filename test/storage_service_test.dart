import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aac_sinhala_tamil_english/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('StorageService', () {
    test('defaults to not registered and not premium', () async {
      expect(await StorageService.isRegistered(), isFalse);
      expect(await StorageService.isPremium(), isFalse);
      expect(await StorageService.getGender(), isNull);
    });

    test('saveUserData persists registration, premium, and gender', () async {
      await StorageService.saveUserData(name: 'Test Child', gender: 'girl');

      expect(await StorageService.isRegistered(), isTrue);
      expect(await StorageService.isPremium(), isTrue);
      expect(await StorageService.getGender(), equals('girl'));
    });
  });
}
