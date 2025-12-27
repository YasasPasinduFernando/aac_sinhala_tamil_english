import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/app_theme.dart';
import '../data/word_data.dart';

class FavouriteScreen extends StatefulWidget {
  final String language;
  final Function(String) onWordSelected;
  final Function(String) onSpeak;
  final bool isGirl;

  const FavouriteScreen({
    Key? key,
    required this.language,
    required this.onWordSelected,
    required this.onSpeak,
    required this.isGirl,
  }) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  late PageController _pageController;
  late int currentCategoryIndex;
  List<String> favoriteCategoryKeys = [];
  bool _isProcessingTap = false;

  // Prevent multiple rapid taps from being processed
  Future<void> _processWordTap(String text) async {
    if (_isProcessingTap) return;

    _isProcessingTap = true;
    try {
      widget.onWordSelected(text);
      widget.onSpeak(text);
    } finally {
      // Reset after a short delay
      await Future.delayed(const Duration(milliseconds: 300));
      _isProcessingTap = false;
    }
  }

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
      'ta': 'வீட්టுப் பொருட்கள්',
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
      'ta': 'இசை & ஒலிகள්',
      'en': 'Music & Sounds',
      'emoji': '🎵'
    },
    'family_words': {
      'si': 'පවුල',
      'ta': 'குடும்பம்',
      'en': 'Family',
      'emoji': '👨‍👩‍👧‍👦'
    },
    'places': {'si': 'ස්ථාන', 'ta': 'இடங்கள්', 'en': 'Places', 'emoji': '🌍'},
    'needs': {'si': 'අවශ්‍යතා', 'ta': 'தேவைகள்', 'en': 'Needs', 'emoji': '🙏'},
    'sentences': {
      'si': 'වාක්‍ය',
      'ta': 'வாக්கியங்கள්',
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
        favoriteCategoryKeys = savedFavorites.isNotEmpty
            ? savedFavorites
            : categoryMap.keys.toList(); // Default to all if empty
      });
    }
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

  String _getText(Map<String, dynamic> item) {
    switch (widget.language) {
      case 'si-LK':
        return item['si'] ?? '';
      case 'ta-IN':
        return item['ta'] ?? '';
      case 'en-US':
        return item['en'] ?? '';
      default:
        return item['si'] ?? '';
    }
  }

  String _getActionText(Map<String, dynamic> action) {
    switch (widget.language) {
      case 'si-LK':
        return action['si'] ?? '';
      case 'ta-IN':
        return action['ta'] ?? '';
      case 'en-US':
        return action['en'] ?? '';
      default:
        return action['si'] ?? '';
    }
  }

  void _showActionsBottomSheet(
      BuildContext context, String itemText, List<dynamic> actions) {
    final colors = AppTheme.getThemeColors(widget.isGirl);

    showModalBottomSheet(
      context: context,
      backgroundColor: colors['background'],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colors['background']!,
                colors['accent']!.withOpacity(0.2),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  itemText,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colors['textColor'],
                  ),
                ),
              ),
              const Divider(),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: actions.length,
                  itemBuilder: (context, index) {
                    final action = actions[index] as Map<String, dynamic>;
                    final actionText = _getActionText(action);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            _processWordTap(actionText);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colors['primary']!,
                                  colors['accent']!,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  action['emoji'] ?? '✓',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    actionText,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: colors['buttonText'],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> _getCategoryWords(String categoryKey) {
    final items = wordData[categoryKey];
    return items != null
        ? items.cast<Map<String, dynamic>>()
        : <Map<String, dynamic>>[];
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.getThemeColors(widget.isGirl);

    if (favoriteCategoryKeys.isEmpty) {
      return Theme(
        data: AppTheme.getThemeData(widget.isGirl),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.language == 'si-LK'
                  ? '❤️ ප්‍රිය'
                  : widget.language == 'ta-IN'
                      ? '❤️ விருப்பமான'
                      : '❤️ Favorites',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: colors['primary'],
          ),
          backgroundColor: colors['background'],
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '📭',
                  style: const TextStyle(fontSize: 80),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.language == 'si-LK'
                      ? 'ප්‍රිය වර්ගයන් තෝරා ගැනීමට සැකසුම් වෙත යන්න'
                      : widget.language == 'ta-IN'
                          ? 'விருப்பமான வகைகளைத் தேர்ந்தெடுக்க அமைப்புகளுக்குச் செல்லவும்'
                          : 'Go to settings to select your favorite categories',
                  style: TextStyle(
                    fontSize: 18,
                    color: colors['textColor'],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppTheme.getGradient(widget.isGirl),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      widget.language == 'si-LK'
                          ? 'ගෙදරට යාමට'
                          : widget.language == 'ta-IN'
                              ? 'வீட்டுக்குத் திரும்பவும்'
                              : 'Go Home',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Theme(
      data: AppTheme.getThemeData(widget.isGirl),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.language == 'si-LK'
                ? '❤️ ප්‍රිය'
                : widget.language == 'ta-IN'
                    ? '❤️ விருப්பமான'
                    : '❤️ Favorites',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: colors['primary'],
          elevation: 0,
        ),
        backgroundColor: colors['background'],
        body: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              int calculatedIndex = index % favoriteCategoryKeys.length;
              if (calculatedIndex < 0) {
                calculatedIndex += favoriteCategoryKeys.length;
              }
              currentCategoryIndex = calculatedIndex;
            });
          },
          itemBuilder: (context, index) {
            int categoryIndex = index % favoriteCategoryKeys.length;
            if (categoryIndex < 0) {
              categoryIndex += favoriteCategoryKeys.length;
            }

            final categoryKey = favoriteCategoryKeys[categoryIndex];
            final categoryName = _getCategoryName(categoryKey);
            final categoryEmoji = _getCategoryEmoji(categoryKey);
            final words = _getCategoryWords(categoryKey);

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Category Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppTheme.getGradient(widget.isGirl),
                    ),
                    child: Column(
                      children: [
                        Text(
                          categoryEmoji,
                          style: const TextStyle(fontSize: 60),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          categoryName,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  // Words Grid
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: words.length,
                      itemBuilder: (context, index) {
                        final word = words[index];
                        final text = _getText(word);
                        final emoji = word['emoji'] ?? '';

                        return GestureDetector(
                          onTap: () {
                            _processWordTap(text);
                          },
                          onLongPress: word['actions'] != null &&
                                  (word['actions'] as List).isNotEmpty
                              ? () => _showActionsBottomSheet(
                                  context, text, word['actions'] as List)
                              : null,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colors['gradient1']!.withOpacity(0.8),
                                  colors['gradient2']!.withOpacity(0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: colors['primary']!.withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  emoji,
                                  style: const TextStyle(fontSize: 40),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    text,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.volume_up,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
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
                // Previous Category Button
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
                // Next Category Button
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
