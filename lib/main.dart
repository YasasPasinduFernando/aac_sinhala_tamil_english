import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
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
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Noto Sans'),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
