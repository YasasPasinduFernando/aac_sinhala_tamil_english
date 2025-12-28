import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/theme/app_theme.dart';
import 'services/ads_service.dart';
import 'services/offline_service.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdsService.initialize();
  await OfflineService().initialize();
  runApp(const AACApp());
}

class AACApp extends StatefulWidget {
  const AACApp({Key? key}) : super(key: key);

  @override
  State<AACApp> createState() => _AACAppState();
}

class _AACAppState extends State<AACApp> {
  bool _isGirl = true;

  @override
  void initState() {
    super.initState();
    _loadGenderPreference();
  }

  Future<void> _loadGenderPreference() async {
    final gender = await StorageService.getGender();
    if (mounted) {
      setState(() {
        _isGirl = gender == 'girl';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AAC Sinhala Tamil English',
      theme: AppTheme.getThemeData(_isGirl),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
