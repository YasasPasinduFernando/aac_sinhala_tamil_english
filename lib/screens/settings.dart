import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  final String language;
  final bool isGirl;

  const SettingsScreen({
    Key? key,
    required this.language,
    required this.isGirl,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late PageController _pageController;
  late int currentCategoryIndex;
  List<String> favoriteCategoryKeys = [];

  final Map<String, Map<String, String>> categoryMap = {
    'body_parts': {
      'si': 'ශරීරයේ දෙ',
      'ta': 'உடல் பாகங்கள்',
      'en': 'Body Parts',
      'emoji': '👤'
    },
    'animals': {
      'si': 'සතුන්',
      'ta': 'விலங்குகள்',
      'en': 'Animals',
      'emoji': '🐶'
    },
    'fruits_vegetables': {
      'si': 'ඉතුරු දරුවන්',
      'ta': 'பழங்கள்',
      'en': 'Fruits',
      'emoji': '🍎'
    },
    'food': {'si': 'කෑම', 'ta': 'உணவு', 'en': 'Food', 'emoji': '🍽️'},
    'household': {
      'si': 'ගෙදර දේ',
      'ta': 'வீட்டுப் பொருட்கள்',
      'en': 'Household',
      'emoji': '🏠'
    },
    'colors': {'si': 'වර්ණ', 'ta': 'நிறங்கள்', 'en': 'Colors', 'emoji': '🎨'},
    'numbers': {'si': 'අංක', 'ta': 'எண்கள்', 'en': 'Numbers', 'emoji': '🔢'},
    'feelings': {
      'si': 'සිතුවම්',
      'ta': 'உணர்வுகள்',
      'en': 'Feelings',
      'emoji': '😊'
    },
    'actions': {
      'si': 'ක්‍රීඩා හා ක්‍රියාකාරකම්',
      'ta': 'செயல்கள්',
      'en': 'Actions',
      'emoji': '⚽'
    },
    'sounds_music': {
      'si': 'ගිණුම් සැකසීම්',
      'ta': 'இசை & ஒலிகள்',
      'en': 'Music & Sounds',
      'emoji': '🎵'
    },
    'family_words': {
      'si': 'පවුල',
      'ta': 'குடும்பம்',
      'en': 'Family',
      'emoji': '👨‍👩‍👧‍👦'
    },
    'places': {'si': 'ස්ථාන', 'ta': 'இடங்கள்', 'en': 'Places', 'emoji': '🌍'},
    'needs': {'si': 'අවශ්‍යතා', 'ta': 'தேவைகள்', 'en': 'Needs', 'emoji': '🙏'},
    'sentences': {
      'si': 'වාක්‍ය',
      'ta': 'வாக்கியங்கள்',
      'en': 'Sentences',
      'emoji': '💬'
    },
  };

  @override
  void initState() {
    super.initState();
    currentCategoryIndex = 0;
    final initialPage = 1000000;
    _pageController = PageController(initialPage: initialPage);
    _loadFavoriteCategories();

    // Hide system navigation bar
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.top],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    // Don't restore - let HomeScreen control the system UI
    // Just hide the nav again when returning
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.top],
    );
    super.dispose();
  }

  Future<void> _loadFavoriteCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final savedFavorites = prefs.getStringList('favoriteCategories') ?? [];

    if (mounted) {
      setState(() {
        favoriteCategoryKeys = savedFavorites;
      });
    }
  }

  Future<void> _saveFavoriteCategories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favoriteCategories', favoriteCategoryKeys);
  }

  void _toggleCategory(String categoryKey) {
    setState(() {
      if (favoriteCategoryKeys.contains(categoryKey)) {
        favoriteCategoryKeys.remove(categoryKey);
      } else {
        favoriteCategoryKeys.add(categoryKey);
      }
    });
    _saveFavoriteCategories();
  }

  String _getCategoryName(String key) {
    final categoryData = categoryMap[key];
    if (categoryData == null) return key;

    if (widget.language == 'ta-IN') {
      return categoryData['ta'] ?? key;
    } else if (widget.language == 'en-US') {
      return categoryData['en'] ?? key;
    }
    return categoryData['si'] ?? key;
  }

  String _getCategoryEmoji(String key) {
    return categoryMap[key]?['emoji'] ?? '📂';
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.getThemeColors(widget.isGirl);
    final categoryKeys = categoryMap.keys.toList();

    return Theme(
      data: AppTheme.getThemeData(widget.isGirl),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.language == 'si-LK'
                ? '⚙️ සැකසුම්'
                : widget.language == 'ta-IN'
                    ? '⚙️ அமைப்புகள்'
                    : '⚙️ Settings',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: colors['primary'],
          elevation: 0,
        ),
        backgroundColor: colors['background'],
        body: Column(
          children: [
            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors['primary']!.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: colors['primary']!, width: 2),
              ),
              child: Text(
                widget.language == 'si-LK'
                    ? '✓ ඔබගේ ප්‍රියතම වර්ගීකරණ තෝරන්න'
                    : widget.language == 'ta-IN'
                        ? '✓ உங்கள் விருப்பமான வகைகளைத் தேர்ந்தெடுக்கவும்'
                        : '✓ Select your favorite categories',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colors['primary'],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Selected Count
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                widget.language == 'si-LK'
                    ? '${favoriteCategoryKeys.length} තෝරා ඇත'
                    : widget.language == 'ta-IN'
                        ? '${favoriteCategoryKeys.length} தேர்ந்தெடுக்கப்பட்டுள்ளன'
                        : '${favoriteCategoryKeys.length} selected',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colors['textColor'],
                ),
              ),
            ),
            // PageView for category selection
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    int calculatedIndex = index % categoryKeys.length;
                    if (calculatedIndex < 0) {
                      calculatedIndex += categoryKeys.length;
                    }
                    currentCategoryIndex = calculatedIndex;
                  });
                },
                itemBuilder: (context, index) {
                  int categoryIndex = index % categoryKeys.length;
                  if (categoryIndex < 0) {
                    categoryIndex += categoryKeys.length;
                  }

                  final categoryKey = categoryKeys[categoryIndex];
                  final isFavorite = favoriteCategoryKeys.contains(categoryKey);

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Large Category Card
                          GestureDetector(
                            onTap: () => _toggleCategory(categoryKey),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                gradient: isFavorite
                                    ? LinearGradient(
                                        colors: [
                                          colors['gradient1']!,
                                          colors['gradient2']!,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : LinearGradient(
                                        colors: [
                                          Colors.grey.shade300,
                                          Colors.grey.shade200,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: (isFavorite
                                            ? colors['primary']
                                            : Colors.grey)!
                                        .withOpacity(0.4),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(40),
                              child: Column(
                                children: [
                                  // Emoji
                                  Text(
                                    _getCategoryEmoji(categoryKey),
                                    style: const TextStyle(fontSize: 80),
                                  ),
                                  const SizedBox(height: 20),
                                  // Category Name
                                  Text(
                                    _getCategoryName(categoryKey),
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: isFavorite
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 30),
                                  // Favorite Button
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isFavorite
                                          ? Colors.white
                                          : Colors.grey.shade400,
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      isFavorite
                                          ? '❤️ ප්‍රිය'
                                          : '🤍 ප්‍රිය නොවේ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isFavorite
                                            ? colors['primary']
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Swipe Instructions
                          Text(
                            widget.language == 'si-LK'
                                ? '← තුඩු දී ස්විප් කරන්න →'
                                : widget.language == 'ta-IN'
                                    ? '← ஸ்வைப் செய்யவும் →'
                                    : '← Swipe to browse →',
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: colors['textColor']!.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.pink.shade200,
                Colors.pink.shade300,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Back Button
                GestureDetector(
                  onTap: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                // Home Button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.6),
                          blurRadius: 20,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
                // Next Button
                GestureDetector(
                  onTap: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
