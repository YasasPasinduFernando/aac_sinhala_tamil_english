import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/storage_service.dart';
import '../services/ads_service.dart';
import '../services/offline_service.dart';
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

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final FlutterTts flutterTts = FlutterTts();
  String selectedLanguage = 'si-LK';
  List<String> sentence = [];
  bool isPremium = false;
  bool isGirl = true;
  late ScrollController _scrollController;
  bool _showSentencePanel = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController = ScrollController(keepScrollOffset: false);
    _scrollController.addListener(_onScroll);
    _initTts();
    _checkPremiumStatus();
    _loadGenderPreference();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App එක unlock/resume වූ විට UI refresh කරන්න
      setState(() {});
    }
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_showSentencePanel) {
        setState(() => _showSentencePanel = false);
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_showSentencePanel) {
        setState(() => _showSentencePanel = true);
      }
    }
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
    const siCategories = [
      {'name': 'ශරීරයේ දෙ', 'emoji': '👤', 'desc': 'හස, පා, මුහුණ...'},
      {'name': 'සතුන්', 'emoji': '🐶', 'desc': 'බඩවුන්, බිතුන්, පූසා...'},
      {'name': 'ඉතුරු දරුවන්', 'emoji': '🍎', 'desc': 'පළතුරු, එළුම්කොළ...'},
      {'name': 'කෑම', 'emoji': '🍽️', 'desc': 'බත්, පාන්, දුඩ්ඩු...'},
      {'name': 'ගෙදර දේ', 'emoji': '🏠', 'desc': 'පොත, මේස, අඩ්ඩ...'},
      {'name': 'වර්ණ', 'emoji': '🎨', 'desc': 'රතු, නිල්, කහ...'},
      {'name': 'අංක', 'emoji': '🔢', 'desc': '1, 2, 3, 4, 5...'},
      {'name': 'සිතුවම්', 'emoji': '😊', 'desc': 'සතුට, කරුණ, බිය...'},
      {
        'name': 'ක්‍රීඩා හා ක්‍රියාකාරකම්',
        'emoji': '⚽',
        'desc': 'දිවීම, ගමනය, නැටීම...'
      },
      {
        'name': 'ගිණුම් සැකසීම්',
        'emoji': '🎵',
        'desc': 'සංගීතය, නර්තනය, හඬ...'
      },
      {
        'name': 'පවුල',
        'emoji': '👨‍👩‍👧‍👦',
        'desc': 'අම්මා, තාත්තා, අක්කා...'
      },
      {'name': 'ස්ථාන', 'emoji': '🌍', 'desc': 'ගෙදර, පාසල, උද්‍යානය...'},
      {'name': 'අවශ්‍යතා', 'emoji': '🙏', 'desc': 'කන්න, බොන්න, නිදා ගන්න...'},
      {'name': 'වාක්‍ය', 'emoji': '💬', 'desc': 'ස්තුතිය, කාටවත් නැහැ...'},
    ];

    const taCategories = [
      {'name': 'உடல் பாகங்கள்', 'emoji': '👤', 'desc': 'கை, கால், முகம்...'},
      {'name': 'விலங்குகள்', 'emoji': '🐶', 'desc': 'பசு, நாய், பூனை...'},
      {'name': 'பழங்கள்', 'emoji': '🍎', 'desc': 'ஆப்பிள், ஆரஞ்சு...'},
      {'name': 'உணவு', 'emoji': '🍽️', 'desc': 'சோறு, கொதி, பதம்...'},
      {
        'name': 'வீட்டுப் பொருட்கள்',
        'emoji': '🏠',
        'desc': 'புத்தகம், மேஜ், படுக்கை...'
      },
      {'name': 'நிறங்கள்', 'emoji': '🎨', 'desc': 'சிவப்பு, நீலம், மஞ்சள்...'},
      {'name': 'எண்கள்', 'emoji': '🔢', 'desc': '1, 2, 3, 4, 5...'},
      {'name': 'உணர்வுகள்', 'emoji': '😊', 'desc': 'மகிழ்ச்சி, சோகம், பயம்...'},
      {'name': 'செயல்கள்', 'emoji': '⚽', 'desc': 'ஓடுதல், நடத்தல்...'},
      {'name': 'இசை & ஒலிகள்', 'emoji': '🎵', 'desc': 'இசை, நாட்டம், மணி...'},
      {
        'name': 'குடும்பம்',
        'emoji': '👨‍👩‍👧‍👦',
        'desc': 'அம்மா, அப்பா, அக்கா...'
      },
      {'name': 'இடங்கள்', 'emoji': '🌍', 'desc': 'வீடு, பள்ளி, பூங்கா...'},
      {'name': 'தேவைகள்', 'emoji': '🙏', 'desc': 'சாப்பிட, குடிக்க...'},
      {'name': 'வாக்கியங்கள்', 'emoji': '💬', 'desc': 'நன்றி, மன்னிக்கவும்...'},
    ];

    const enCategories = [
      {'name': 'Body Parts', 'emoji': '👤', 'desc': 'Hand, Leg, Face...'},
      {'name': 'Animals', 'emoji': '🐶', 'desc': 'Cow, Dog, Cat...'},
      {'name': 'Fruits', 'emoji': '🍎', 'desc': 'Apple, Orange...'},
      {'name': 'Food', 'emoji': '🍽️', 'desc': 'Rice, Bread, Egg...'},
      {'name': 'Household', 'emoji': '🏠', 'desc': 'Book, Table, Bed...'},
      {'name': 'Colors', 'emoji': '🎨', 'desc': 'Red, Blue, Yellow...'},
      {'name': 'Numbers', 'emoji': '🔢', 'desc': '1, 2, 3, 4, 5...'},
      {'name': 'Feelings', 'emoji': '😊', 'desc': 'Happy, Sad, Scared...'},
      {'name': 'Actions', 'emoji': '⚽', 'desc': 'Running, Walking...'},
      {'name': 'Music & Sounds', 'emoji': '🎵', 'desc': 'Music, Dancing...'},
      {'name': 'Family', 'emoji': '👨‍👩‍👧‍👦', 'desc': 'Mother, Father...'},
      {'name': 'Places', 'emoji': '🌍', 'desc': 'Home, School...'},
      {'name': 'Needs', 'emoji': '🙏', 'desc': 'Eat, Drink...'},
      {'name': 'Sentences', 'emoji': '💬', 'desc': 'Thank you...'},
    ];

    final categories = selectedLanguage == 'ta-IN'
        ? taCategories
        : selectedLanguage == 'en-US'
            ? enCategories
            : siCategories;
    return categories
        .map((cat) => {
              'name': cat['name'],
              'emoji': cat['emoji'],
              'desc': cat['desc']
            })
        .toList();
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
        body: StreamBuilder<bool>(
          stream: OfflineService().getConnectivityStream(),
          initialData: OfflineService().isOnline,
          builder: (context, snapshot) {
            final isOnline = snapshot.data ?? true;

            return Column(
              children: [
                // Offline indicator banner
                if (!isOnline)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade700,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.orange.shade900,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.wifi_off,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          selectedLanguage == 'si-LK'
                              ? '📡 ඉන්ටර්නෙට් සම්බන්ධතාවය නැත'
                              : selectedLanguage == 'ta-IN'
                                  ? '📡 இணையம் இணைக்கப்படவில்லை'
                                  : '📡 No Internet Connection',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                // 🎯 Sentence builder panel (animated)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _showSentencePanel ? null : 0,
                  child: _showSentencePanel
                      ? Container(
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
                                constraints:
                                    const BoxConstraints(minHeight: 60),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colors['primary']!
                                          .withValues(alpha: 0.2),
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
                                            color: colors['textColor']!
                                                .withValues(alpha: 0.5),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                    : Wrap(
                                        spacing: 10,
                                        runSpacing: 8,
                                        children: sentence
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          return GestureDetector(
                                            // වචනය click කරන විට කියවීම
                                            onTap: () => _speak(entry.value),
                                            // Long press කරන විට ඉවත් කරීම
                                            onLongPress: () {
                                              setState(() => sentence
                                                  .removeAt(entry.key));
                                            },
                                            child: Container(
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
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    entry.value,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  // Close icon - click කරන විට ඉවත් වේ
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() => sentence
                                                          .removeAt(entry.key));
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.all(2),
                                                      child: const Icon(
                                                        Icons.close,
                                                        size: 16,
                                                        color: Colors.white,
                                                      ),
                                                    ),
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
                                      onPressed: sentence.isEmpty
                                          ? () {}
                                          : _speakSentence,
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
                        )
                      : const SizedBox.shrink(),
                ),
                // 📂 Categories section
                Expanded(
                  child: CustomScrollView(
                    controller: _scrollController,
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
                                description: category['desc'],
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
            );
          },
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
      'ඉතුරු දරුවන්': 'fruits_vegetables',
      'කෑම': 'food',
      'ගෙදර දේ': 'household',
      'වර්ණ': 'colors',
      'අංක': 'numbers',
      'වර්ණ සහ අංක': 'colors_numbers',
      'සිතුවම්': 'feelings',
      'ක්‍රීඩා හා ක්‍රියාකාරකම්': 'actions',
      'ගිණුම් සැකසීම්': 'sounds_music',
      'පවුල': 'family_words',
      'ස්ථාන': 'places',
      'අවශ්‍යතා': 'needs',
      'වාක්‍ය': 'sentences',
      // Tamil names
      'உடல் பாகங்கள்': 'body_parts',
      'விலங்குகள்': 'animals',
      'பழங்கள்': 'fruits_vegatables',
      'உணவு': 'food',
      'வீட்டுப் பொருட்கள்': 'household',
      'நிறங்கள்': 'colors',
      'எண்கள்': 'numbers',
      'நிறங்கள் & எண்கள்': 'colors_numbers',
      'உணர்வுகள்': 'feelings',
      'செயல்கள்': 'actions',
      'இசை & ஒலிகள்': 'sounds_music',
      'குடும்பம்': 'family_words',
      'இடங்கள்': 'places',
      'தேவைகள்': 'needs',
      'வாக்கியங்கள்': 'sentences',
      // English names
      'Body Parts': 'body_parts',
      'Animals': 'animals',
      'Fruits': 'fruits_vegatables',
      'Food': 'food',
      'Household': 'household',
      'Colors': 'colors',
      'Numbers': 'numbers',
      'Colors & Numbers': 'colors_numbers',
      'Feelings': 'feelings',
      'Actions': 'actions',
      'Music & Sounds': 'sounds_music',
      'Family': 'family_words',
      'Places': 'places',
      'Needs': 'needs',
      'Sentences': 'sentences',
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
    ).then((_) {
      // Show sentence panel when returning from category
      setState(() => _showSentencePanel = true);
    });
  }
}