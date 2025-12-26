import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/storage_service.dart';
import '../services/ads_service.dart';
import '../widgets/banner_ad_widget.dart';
import '../data/word_data.dart';
import 'category_screen.dart';
import 'theme/app_theme.dart';
import 'theme/gender_selection_screen.dart';
import 'theme/custom_card_widget.dart';
import 'theme/animated_category_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterTts flutterTts = FlutterTts();
  String selectedLanguage = 'si-LK';
  List<String> sentence = [];
  bool isPremium = false;
  bool isGirl = true;

  @override
  void initState() {
    super.initState();
    _initTts();
    _checkPremiumStatus();
    _loadGenderPreference();
  }

  Future<void> _loadGenderPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isGirl = prefs.getBool('isGirl') ?? true;
    });
  }

  Future<void> _checkPremiumStatus() async {
    final premium = await StorageService.isPremium();
    setState(() => isPremium = premium);
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage(selectedLanguage);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage(selectedLanguage);
    await flutterTts.speak(text);
  }

  void _addToSentence(String word) {
    setState(() => sentence.add(word));
  }

  void _speakSentence() {
    if (sentence.isNotEmpty) {
      _speak(sentence.join(' '));
    }
  }

  void _clearSentence() {
    setState(() => sentence.clear());
  }

  void _changeGender() {
    showDialog(
      context: context,
      builder: (context) => GenderSelectionScreen(
        onGenderSelected: (gender) {
          setState(() => isGirl = gender);
          Navigator.pop(context);
        },
      ),
    );
  }

  String _getLanguageFlag() {
    switch (selectedLanguage) {
      case 'si-LK':
        return '🇱🇰';
      case 'ta-IN':
        return '🇮🇳';
      case 'en-US':
        return '🇺🇸';
      default:
        return '🌍';
    }
  }

  List<Map<String, dynamic>> get _categories {
    return [
      {
        'name': 'ශරීරයේ දෙ',
        'emoji': '👤',
        'description': 'බිම, පිත, ස්වර...',
      },
      {
        'name': 'සතුන්',
        'emoji': '🐶',
        'description': 'බළු, පිසි, සර්පයා...',
      },
      {
        'name': 'ඉතුරු දරුවන්',
        'emoji': '🍎',
        'description': 'පළතුරු, එළුම්කොළ...',
      },
      {
        'name': 'පරිවාරණ',
        'emoji': '🏠',
        'description': 'ගෙදර, ගිණුම, පුස්තකාලය...',
      },
      {
        'name': 'වර්ණ සහ අංක',
        'emoji': '🌈',
        'description': '1, 2, 3, රතු, නිල්...',
      },
      {
        'name': 'සිතුවම්',
        'emoji': '😊',
        'description': 'සතුට, කරුණ, බිය...',
      },
      {
        'name': 'ක්‍රීඩා හා ක්‍රියාකාරකම්',
        'emoji': '⚽',
        'description': 'ක්‍රීඩා කරන්න, දිවීමු, බිම්සීම...',
      },
      {
        'name': 'ගිණුම් සැකසීම්',
        'emoji': '🎵',
        'description': 'සංගීතය, නර්තනය, හඬ...',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.getThemeColors(isGirl);

    return Theme(
      data: AppTheme.getThemeData(isGirl),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('🎉 AAC - කතා කරමු'),
          centerTitle: true,
          actions: [
            // Language selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: PopupMenuButton<String>(
                  icon: Text(
                    _getLanguageFlag(),
                    style: const TextStyle(fontSize: 24),
                  ),
                  onSelected: (String value) {
                    setState(() => selectedLanguage = value);
                    _initTts();
                  },
                  itemBuilder: (BuildContext context) => const [
                    PopupMenuItem(
                      value: 'si-LK',
                      child: Text('🇱🇰 සිංහල'),
                    ),
                    PopupMenuItem(
                      value: 'ta-IN',
                      child: Text('🇮🇳 தமிழ்'),
                    ),
                    PopupMenuItem(
                      value: 'en-US',
                      child: Text('🇺🇸 English'),
                    ),
                  ],
                ),
              ),
            ),
            // Gender selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: GestureDetector(
                  onTap: _changeGender,
                  child: Text(
                    isGirl ? '👧' : '👦',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // 🎯 Sentence builder panel
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppTheme.getGradient(isGirl),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Row(
                    children: [
                      const Icon(
                        Icons.chat_bubble,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '📢 ඔබේ කතනය',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Sentence display
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 60),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: colors['primary']!.withValues(alpha: 0.2),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: sentence.isEmpty
                        ? Center(
                            child: Text(
                              '✏️ වචන තෝරා ගන්න...',
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    colors['textColor']!.withValues(alpha: 0.5),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : Wrap(
                            spacing: 10,
                            runSpacing: 8,
                            children: sentence.asMap().entries.map((entry) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      colors['gradient1']!,
                                      colors['gradient2']!,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: GestureDetector(
                                  onLongPress: () {
                                    setState(
                                        () => sentence.removeAt(entry.key));
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        entry.value,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        '❌',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                  const SizedBox(height: 12),
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: GradientButton(
                          text: '🔊 කියන්න',
                          onPressed: sentence.isEmpty ? () {} : _speakSentence,
                          isGirl: isGirl,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GradientButton(
                          text: '🗑️ ඉවත් කරන්න',
                          onPressed: _clearSentence,
                          isGirl: isGirl,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 📂 Categories section
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        '📚 වර්ගීකරණ තෝරන්න:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colors['textColor'],
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final category = _categories[index];
                          return AnimatedCategoryCard(
                            categoryName: category['name'],
                            emoji: category['emoji'],
                            description: category['description'],
                            onTap: () => _openCategory(category['name']),
                            isGirl: isGirl,
                            index: index,
                          );
                        },
                        childCount: _categories.length,
                      ),
                    ),
                  ),
                  const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.getGradient(isGirl),
            boxShadow: [
              BoxShadow(
                color: colors['primary']!.withValues(alpha: 0.3),
                blurRadius: 10,
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBottomNavItem(
                    icon: Icons.home,
                    label: 'ගෙදර',
                    isActive: true,
                    onTap: () {},
                  ),
                  _buildBottomNavItem(
                    icon: Icons.favorite,
                    label: 'ප්‍රිය',
                    isActive: false,
                    onTap: () {},
                  ),
                  _buildBottomNavItem(
                    icon: Icons.settings,
                    label: 'සැකසුම්',
                    isActive: false,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.white.withValues(alpha: 0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCategory(String categoryName) {
    // Map category names to wordData keys
    const categoryKeyMap = {
      'ශරීරයේ දෙ': 'body_parts',
      'සතුන්': 'animals',
      'ඉතුරු දරුවන්': 'fruits_vegatables',
      'පරිවාරණ': 'objects',
      'වර්ණ සහ අංක': 'colors_numbers',
      'සිතුවම්': 'feelings',
      'ක්‍රීඩා හා ක්‍රියාකාරකම්': 'actions',
      'ගිණුම් සැකසීම්': 'sounds_music',
    };

    final categoryKey = categoryKeyMap[categoryName];
    final items = categoryKey != null
        ? (wordData[categoryKey]?.cast<Map<String, dynamic>>() ??
            <Map<String, dynamic>>[])
        : <Map<String, dynamic>>[];

    if (items.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryScreen(
          category: categoryName,
          items: items,
          language: selectedLanguage,
          onWordSelected: _addToSentence,
          onSpeak: _speak,
          isGirl: isGirl,
        ),
      ),
    );
  }
}
