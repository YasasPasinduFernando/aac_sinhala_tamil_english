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
import 'donation_screen.dart';
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
  List<Map<String, String>> sentence = [];
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

  void _addToSentence(String word, {String emoji = ''}) {
    setState(() => sentence.add({'word': word, 'emoji': emoji}));
  }

  void _speakSentence() {
    if (sentence.isNotEmpty) {
      final words = sentence.map((item) => item['word']).join(' ');
      _speak(words);
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
      language: selectedLanguage,
    );
  }

  String _getLanguageFlag() {
    switch (selectedLanguage) {
      case 'si-LK':
        return '🇱🇰';
      case 'ta-IN':
        return '🔱';
      case 'en-US':
        return 'uk';
      default:
        return '🌍';
    }
  }

  String _getLanguageText() {
    switch (selectedLanguage) {
      case 'si-LK':
        return 'සිංහල';
      case 'ta-IN':
        return 'தமிழ்';
      case 'en-US':
        return 'English';
      default:
        return 'Language';
    }
  }

  String _getHeaderTitle() {
    switch (selectedLanguage) {
      case 'si-LK':
        return 'කතා කරමු';
      case 'ta-IN':
        return 'பேச வேண்டும்';
      case 'en-US':
        return 'Let\'s Talk';
      default:
        return 'Talk';
    }
  }

  String _getGenderText() {
    switch (selectedLanguage) {
      case 'si-LK':
        return '👧 ගැහැණු / 👦 පුරුষ';
      case 'ta-IN':
        return '👧 பெண் / 👦 ஆண்';
      case 'en-US':
        return '👧 Girl / 👦 Boy';
      default:
        return 'Gender';
    }
  }

  void _showLanguageSelector() {
    final colors = AppTheme.getThemeColors(isGirl);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colors['background']!,
              colors['accent']!.withOpacity(0.3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: colors['textColor']!.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '🌍 භාෂාව තෝරන්න',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colors['textColor'],
                ),
              ),
              const SizedBox(height: 24),
              _buildLanguageOption('si-LK', '🇱🇰', 'සිංහල', colors),
              _buildLanguageOption('ta-IN', '🔱', 'தமிழ்', colors),
              _buildLanguageOption('en-US', '🇺🇸', 'English', colors),
              const SizedBox(height: 30),
              _buildDonateButton(colors),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
      String code, String flag, String name, Map<String, Color> colors) {
    final isSelected = selectedLanguage == code;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GestureDetector(
        onTap: () {
          setState(() => selectedLanguage = code);
          _initTts();
          Navigator.pop(context);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            gradient: isSelected ? AppTheme.getGradient(isGirl) : null,
            color: isSelected ? null : colors['background']!.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : colors['primary']!.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: colors['primary']!.withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              Text(
                flag,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 16),
              Text(
                name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : colors['textColor'],
                ),
              ),
              const Spacer(),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 28,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDonateButton(Map<String, Color> colors) {
    final String donateText = selectedLanguage == 'si-LK'
        ? '🙏❤️ අපට ඩොනේට් කරන්න'
        : selectedLanguage == 'ta-IN'
            ? '🙏❤️ எங்களுக்கு நன்கொடை'
            : '🙏❤️ Support Us';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DonationScreen(
                language: selectedLanguage,
                isGirl: isGirl,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            gradient: AppTheme.getGradient(isGirl),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: colors['primary']!.withOpacity(0.4),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                donateText,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors['textColor'],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '❤️',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
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
      {'name': 'සිතුවිලි', 'emoji': '😊', 'desc': 'සතුට, කරුණ, බිය...'},
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
          body: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.getGradient(isGirl),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '🎉',
                    style: const TextStyle(fontSize: 80),
                  ),
                  const SizedBox(height: 20),
                  CircularProgressIndicator(
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 5,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Loading...',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Theme(
      data: AppTheme.getThemeData(isGirl),
      child: Scaffold(
        body: StreamBuilder<bool>(
          stream: OfflineService().getConnectivityStream(),
          initialData: OfflineService().isOnline,
          builder: (context, snapshot) {
            final isOnline = snapshot.data ?? true;

            return Column(
              children: [
                // Beautiful Header with Gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: AppTheme.getGradient(isGirl),
                    boxShadow: [
                      BoxShadow(
                        color: colors['primary']!.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          // App Logo
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Text(
                              '💬',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Title
                          Expanded(
                            child: Text(
                              _getHeaderTitle(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          // Action Buttons
                          _buildHeaderButton('❤️', () {
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
                          }),
                          const SizedBox(width: 4),
                          _buildHeaderButton('⚙️', () {
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
                          }),
                          const SizedBox(width: 4),
                          _buildHeaderButton(
                              _getLanguageFlag(), _showLanguageSelector),
                          const SizedBox(width: 4),
                          _buildHeaderButton(
                              isGirl ? '👧' : '👦', _changeGender),
                        ],
                      ),
                    ),
                  ),
                ),

                // Offline Banner
                if (!isOnline)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.shade400,
                          Colors.orange.shade600,
                        ],
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
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Sentence Panel
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _showSentencePanel ? null : 0,
                  child: _showSentencePanel
                      ? RepaintBoundary(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  colors['accent']!.withOpacity(0.1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: colors['primary']!.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        gradient: AppTheme.getGradient(isGirl),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.chat_bubble,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        selectedLanguage == 'si-LK'
                                            ? '📢 කතාව'
                                            : selectedLanguage == 'ta-IN'
                                                ? '📢 செய்தி'
                                                : '📢 Message',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: colors['textColor'],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  height: 60,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color:
                                          colors['primary']!.withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: sentence.isEmpty
                                      ? Center(
                                          child: Text(
                                            selectedLanguage == 'si-LK'
                                                ? '✏️ වචන තෝරන්න...'
                                                : selectedLanguage == 'ta-IN'
                                                    ? '✏️ சொற்களை தேர்ந்தெடுக்கவும்...'
                                                    : '✏️ Select words...',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: colors['textColor']!
                                                  .withOpacity(0.5),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      : SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: sentence
                                                .asMap()
                                                .entries
                                                .map((entry) {
                                              final wordData = entry.value;
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 6),
                                                child: GestureDetector(
                                                  onTap: () => _speak(
                                                      wordData['word'] ?? ''),
                                                  onLongPress: () {
                                                    setState(() => sentence
                                                        .removeAt(entry.key));
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 10,
                                                      vertical: 6,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      gradient:
                                                          AppTheme.getGradient(
                                                              isGirl),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                              colors['primary']!
                                                                  .withOpacity(
                                                                      0.2),
                                                          blurRadius: 3,
                                                          offset: const Offset(
                                                              0, 1),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          wordData['emoji'] ??
                                                              '📝',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 4),
                                                        Text(
                                                          wordData['word'] ??
                                                              '',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 4),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() =>
                                                                sentence.removeAt(
                                                                    entry.key));
                                                          },
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(1),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.3),
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: const Icon(
                                                              Icons.close,
                                                              size: 12,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildActionButton(
                                        icon: Icons.volume_up,
                                        label: selectedLanguage == 'si-LK'
                                            ? 'කියන්න'
                                            : selectedLanguage == 'ta-IN'
                                                ? 'பேசு'
                                                : 'Speak',
                                        onPressed: sentence.isEmpty
                                            ? null
                                            : _speakSentence,
                                        colors: colors,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _buildActionButton(
                                        icon: Icons.delete_outline,
                                        label: selectedLanguage == 'si-LK'
                                            ? 'මකන්න'
                                            : selectedLanguage == 'ta-IN'
                                                ? 'நீக்கு'
                                                : 'Clear',
                                        onPressed: _clearSentence,
                                        colors: colors,
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

                // Categories Section
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colors['background']!,
                          colors['accent']!.withOpacity(0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: CustomScrollView(
                      controller: _scrollController,
                      cacheExtent: 1000,
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          sliver: SliverToBoxAdapter(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    colors['primary']!.withOpacity(0.1),
                                    colors['accent']!.withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: colors['primary']!.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      gradient: AppTheme.getGradient(isGirl),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text('📚',
                                        style: TextStyle(fontSize: 20)),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    selectedLanguage == 'si-LK'
                                        ? 'වර්ගීකරණ තෝරන්න'
                                        : selectedLanguage == 'ta-IN'
                                            ? 'வகைகளை தேர்ந்தெடுக்கவும்'
                                            : 'Choose Categories',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: colors['textColor'],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.all(16),
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
                                    onTap: () =>
                                        _openCategory(category['name']),
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
                        const SliverPadding(
                            padding: EdgeInsets.only(bottom: 20)),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderButton(String emoji, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required Map<String, Color> colors,
  }) {
    final isDisabled = onPressed == null;

    return GestureDetector(
      onTap: onPressed,
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isDisabled
                ? LinearGradient(
                    colors: [
                      Colors.grey.shade400,
                      Colors.grey.shade500,
                    ],
                  )
                : AppTheme.getGradient(isGirl),
            borderRadius: BorderRadius.circular(16),
            boxShadow: isDisabled
                ? []
                : [
                    BoxShadow(
                      color: colors['primary']!.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openCategory(String categoryName) {
    debugPrint(
        '🔍 Opening category: $categoryName, Language: $selectedLanguage');

    const categoryKeyMap = {
      // Sinhala
      'ශරීරයේ දෙ': 'body_parts',
      'සතුන්': 'animals',
      'පළතුරු': 'fruits_vegetables',
      'කෑම': 'food',
      'ගෙදර දේ': 'household',
      'වර්ණ': 'colors',
      'අංක': 'numbers',
      'සිතුවිලි': 'feelings',
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

    final categoryKey = categoryKeyMap[categoryName];
    debugPrint('📚 Category key: $categoryKey');
    if (categoryKey == null) {
      debugPrint(
          '❌ Category key is null! Available categories: ${categoryKeyMap.keys.toList()}');
      return;
    }

    final allCategoriesData = _categories.map((category) {
      final key = categoryKeyMap[category['name']];
      debugPrint('   Processing category "${category['name']}" -> key: $key');
      final items = key != null
          ? (wordData[key]?.cast<Map<String, dynamic>>() ??
              <Map<String, dynamic>>[])
          : <Map<String, dynamic>>[];
      debugPrint('      Found ${items.length} items for key "$key"');

      return {
        'name': category['name'],
        'emoji': category['emoji'],
        'items': items,
      };
    }).toList();

    debugPrint(
        '📋 All categories: ${allCategoriesData.map((c) => c['name']).toList()}');

    var initialIndex =
        allCategoriesData.indexWhere((cat) => cat['name'] == categoryName);

    debugPrint(
        '✅ Initial index for "$categoryName": $initialIndex (out of ${allCategoriesData.length})');

    // If category not found, default to 0
    if (initialIndex < 0) {
      debugPrint(
          '⚠️ Category "$categoryName" not found in list! Defaulting to index 0');
      initialIndex = 0;
    }

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

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isGirl;
  final double fontSize;

  const GradientButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.isGirl,
    this.fontSize = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: AppTheme.getGradient(isGirl),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
