import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/theme/app_theme.dart';
import 'services/ads_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdsService.initialize();
  runApp(const AACApp());
}

class AACApp extends StatelessWidget {
  const AACApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AAC Sinhala Tamil English',
      theme: AppTheme.getThemeData(true),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
