import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/home_screen.dart';
import 'services/ads_service.dart';
import 'services/storage_service.dart';
import 'services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdsService.initialize();
  runApp(const AACApp());
}

class AACApp extends StatefulWidget {
  const AACApp({Key? key}) : super(key: key);

  @override
  State<AACApp> createState() => _AACAppState();
}

class _AACAppState extends State<AACApp> {
  ThemeMode _themeMode = ThemeMode.light;
  late ThemeData _lightTheme;
  late ThemeData _darkTheme;
  bool _themesLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadThemes();
  }

  Future<void> _loadThemes() async {
    final isDark = await ThemeService.isDarkMode();
    final lightTheme = await ThemeService.buildLightTheme();
    final darkTheme = await ThemeService.buildDarkTheme();

    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      _lightTheme = lightTheme;
      _darkTheme = darkTheme;
      _themesLoaded = true;
    });
  }

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
    ThemeService.setDarkMode(isDark);
  }

  void _updateThemeColor(String colorName) async {
    final lightTheme = await ThemeService.buildLightTheme();
    final darkTheme = await ThemeService.buildDarkTheme();

    setState(() {
      _lightTheme = lightTheme;
      _darkTheme = darkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_themesLoaded) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('AAC කථා කරමු'),
              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'AAC Sinhala Tamil English',
      themeMode: _themeMode,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      home: SplashScreen(
        onThemeChanged: _toggleTheme,
        onColorChanged: _updateThemeColor,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
