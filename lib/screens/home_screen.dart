import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/storage_service.dart';
import '../services/ads_service.dart';
import '../services/offline_service.dart';
import '../widgets/banner_ad_widget.dart';
import '../data/word_data.dart';
import '../utils/gender_selection_util.dart';
import 'category_screen.dart';
import 'favourite_screen.dart';
import 'settings.dart';
import 'theme/app_theme.dart';
import 'theme/custom_card_widget.dart';
import 'theme/animated_category_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  final FlutterTts flutterTts = FlutterTts();
  String selectedLanguage = 'si-LK';
  List<String> sentence = [];
  bool isPremium = false;
  bool isGirl = true;
  late ScrollController _scrollController;
  bool _showSentencePanel = true;
  bool _isInitialized = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController = ScrollController(keepScrollOffset: false);
    _scrollController.addListener(_onScroll);
    _initialize();

    // Hide system navigation bar
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.top],
    );
  }

  Future<void> _initialize() async {
    await Future.wait([
      _initTts(),
      _checkPremiumStatus(),
      _loadGenderPreference(),
    ]);
    if (mounted) {
      setState(() => _isInitialized = true);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    flutterTts.stop();

    // Restore system UI when leaving screen
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: SystemUiOverlay.values,
    );

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Hide system nav again when returning to home screen
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky,
        overlays: [SystemUiOverlay.top],
      );

      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() {});
        }
      });
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
    try {
      final prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          isGirl = prefs.getBool('isGirl') ?? true;
        });
      }
    } catch (e) {
      debugPrint('Error loading gender preference: $e');
    }
  }

  Future<void> _checkPremiumStatus() async {
    try {
      final premium = await StorageService.isPremium();
      if (mounted) {
        setState(() => isPremium = premium);
      }
    } catch (e) {
      debugPrint('Error checking premium status: $e');
    }
  }

  Future<void> _initTts() async {
    try {
      await flutterTts.setLanguage(selectedLanguage);
      await flutterTts.setSpeechRate(0.4);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);
    } catch (e) {
      debugPrint('Error initializing TTS: $e');
    }
  }

  Future<void> _speak(String text) async {
    try {
      await flutterTts.setLanguage(selectedLanguage);
      await flutterTts.speak(text);
    } catch (e) {
      debugPrint('Error speaking: $e');
    }
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
    showGenderSelectionPopup(
      context,
      onGenderChanged: (gender) {
        if (mounted) {
          setState(() => isGirl = gender);
        }
      },
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
      {'name': 'පළතුරු', 'emoji': '🍎', 'desc': 'ඩෝඩම්, තලමුඩු, ඇට...'},
      {'name': 'කෑම', 'emoji': '🍽️', 'desc': 'බත්, පාන්, දුඩ්ඩු...'},
      {'name': 'ගෙදර දේ', 'emoji': '🏠', 'desc': 'පොත, මේස, අඩ්ඩ...'},
      {'name': 'වර්ණ', 'emoji': '🎨', 'desc': 'රතු, නිල්, කහ...'},
      {'name': 'අංක', 'emoji': '🔢', 'desc': '1, 2, 3, 4, 5...'},
      {'name': 'සිතුවම්', 'emoji': '😊', 'desc': 'සතුට, කරුණ, බිය...'},
      {'name': 'ක්‍රියාකාරකම්', 'emoji': '⚽', 'desc': 'දිවීම, ගමනය, නැටීම...'},
      {
        'name': 'සංගීතය සහ ශබ්ද',
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
        .map((cat) =>
            {'name': cat['name'], 'emoji': cat['emoji'], 'desc': cat['desc']})
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final colors = AppTheme.getThemeColors(isGirl);

    if (!_isInitialized) {
      return Theme(
        data: AppTheme.getThemeData(isGirl),
        child: Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(colors['primary']!),
            ),
          ),
        ),
      );
    }

    return Theme(
      data: AppTheme.getThemeData(isGirl),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('🎉 AAC - කතා කරමු'),
          centerTitle: true,
          actions: [
            RepaintBoundary(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FavouriteScreen(
                            language: selectedLanguage,
                            onWordSelected: _addToSentence,
                            onSpeak: _speak,
                            isGirl: isGirl,
                          ),
                        ),
                      ).then((_) {
                        if (mounted) {
                          setState(() => _showSentencePanel = true);
                        }
                      });
                    },
                    child: const Text(
                      '❤️',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
              ),
            ),
            RepaintBoundary(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsScreen(
                            language: selectedLanguage,
                            isGirl: isGirl,
                          ),
                        ),
                      ).then((_) {
                        if (mounted) {
                          setState(() {});
                        }
                      });
                    },
                    child: const Text(
                      '⚙️',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
              ),
            ),
            RepaintBoundary(
              child: Padding(
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
                      PopupMenuItem(value: 'si-LK', child: Text('🇱🇰 සිංහල')),
                      PopupMenuItem(value: 'ta-IN', child: Text('🇮🇳 தமிழ்')),
                      PopupMenuItem(
                          value: 'en-US', child: Text('🇺🇸 English')),
                    ],
                  ),
                ),
              ),
            ),
            RepaintBoundary(
              child: Padding(
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
                if (!isOnline)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade700,
                      border: Border(
                        bottom:
                            BorderSide(color: Colors.orange.shade900, width: 2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.wifi_off,
                            color: Colors.white, size: 18),
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
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _showSentencePanel ? null : 0,
                  child: _showSentencePanel
                      ? RepaintBoundary(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: AppTheme.getGradient(isGirl),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.chat_bubble,
                                        color: Colors.white, size: 24),
                                    SizedBox(width: 8),
                                    Text(
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
                                              onTap: () => _speak(entry.value),
                                              onLongPress: () {
                                                setState(() => sentence
                                                    .removeAt(entry.key));
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() =>
                                                            sentence.removeAt(
                                                                entry.key));
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2),
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
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                Expanded(
                  child: CustomScrollView(
                    controller: _scrollController,
                    cacheExtent: 1000,
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
                              return RepaintBoundary(
                                key: ValueKey(
                                    'card_${category['emoji']}_$index'),
                                child: AnimatedCategoryCard(
                                  key: ValueKey('${category['name']}_$index'),
                                  categoryName: category['name'],
                                  emoji: category['emoji'],
                                  description: category['desc'],
                                  onTap: () => _openCategory(category['name']),
                                  isGirl: isGirl,
                                  index: index,
                                ),
                              );
                            },
                            childCount: _categories.length,
                            addAutomaticKeepAlives: true,
                            addRepaintBoundaries: false,
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
        bottomNavigationBar: null,
      ),
    );
  }

  void _openCategory(String categoryName) {
    debugPrint(
        '🔍 Opening category: $categoryName, Language: $selectedLanguage');

    // Prepare all categories with their data
    const categoryKeyMap = {
      // Sinhala
      'ශරීරයේ දෙ': 'body_parts',
      'සතුන්': 'animals',
      'පළතුරු': 'fruits_vegetables',
      'කෑම': 'food',
      'ගෙදර දේ': 'household',
      'වර්ණ': 'colors',
      'අංක': 'numbers',
      'සිතුවම්': 'feelings',
      'ක්‍රියාකාරකම්': 'actions',
      'සංගීතය සහ ශබ්ද': 'sounds_music',
      'පවුල': 'family_words',
      'ස්ථාන': 'places',
      'අවශ්‍යතා': 'needs',
      'වාක්‍ය': 'sentences',
      // Tamil
      'உடல் பாகங்கள்': 'body_parts',
      'விலங்குகள்': 'animals',
      'பழங்கள்': 'fruits_vegetables',
      'உணவு': 'food',
      'வீட்டுப் பொருட்கள்': 'household',
      'நிறங்கள்': 'colors',
      'எண்கள்': 'numbers',
      'உணர்வுகள்': 'feelings',
      'செயல்கள்': 'actions',
      'இசை & ஒலிகள்': 'sounds_music',
      'குடும்பம்': 'family_words',
      'இடங்கள்': 'places',
      'தேவைகள்': 'needs',
      'வாக்கியங்கள்': 'sentences',
      // English
      'Body Parts': 'body_parts',
      'Animals': 'animals',
      'Fruits': 'fruits_vegetables',
      'Food': 'food',
      'Household': 'household',
      'Colors': 'colors',
      'Numbers': 'numbers',
      'Feelings': 'feelings',
      'Actions': 'actions',
      'Music & Sounds': 'sounds_music',
      'Family': 'family_words',
      'Places': 'places',
      'Needs': 'needs',
      'Sentences': 'sentences',
    };

    // Get the data key for this category
    final categoryKey = categoryKeyMap[categoryName];
    debugPrint('📚 Category key: $categoryKey');
    if (categoryKey == null) {
      debugPrint(
          '❌ Category key is null! Available categories: ${categoryKeyMap.keys.toList()}');
      return;
    }

    // Build all categories data in order
    final allCategoriesData = _categories.map((category) {
      final key = categoryKeyMap[category['name']];
      final items = key != null
          ? (wordData[key]?.cast<Map<String, dynamic>>() ??
              <Map<String, dynamic>>[])
          : <Map<String, dynamic>>[];

      return {
        'name': category['name'],
        'emoji': category['emoji'],
        'items': items,
      };
    }).toList();

    debugPrint(
        '📋 All categories: ${allCategoriesData.map((c) => c['name']).toList()}');

    // Find the index of the selected category in the built data
    final initialIndex =
        allCategoriesData.indexWhere((cat) => cat['name'] == categoryName);

    debugPrint(
        '✅ Initial index for "$categoryName": $initialIndex (out of ${allCategoriesData.length})');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryScreen(
          allCategories: allCategoriesData,
          initialCategoryIndex: initialIndex,
          language: selectedLanguage,
          onWordSelected: _addToSentence,
          onSpeak: _speak,
          isGirl: isGirl,
        ),
      ),
    ).then((_) {
      if (mounted) {
        setState(() => _showSentencePanel = true);
      }
    });
  }
}
