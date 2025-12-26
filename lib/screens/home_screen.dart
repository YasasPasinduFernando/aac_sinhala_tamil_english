import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../data/word_data.dart';
import '../services/storage_service.dart';
import 'category_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterTts flutterTts = FlutterTts();
  String selectedLanguage = 'en-US';
  List<String> sentence = [];
  bool _speakerPressed = false;
  String userName = '';

  @override
  void initState() {
    super.initState();
    flutterTts.setSpeechRate(0.5);
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final lang = await StorageService.getSelectedLanguage();
    final last = await StorageService.getLastSentence();
    final name = await StorageService.getUserName();
    setState(() {
      selectedLanguage = lang;
      sentence = last.isEmpty ? [] : last.split('|');
      userName = name.isEmpty ? 'Supun' : name;
    });
  }

  void _speak(String text) async {
    await flutterTts.setLanguage(selectedLanguage);
    await flutterTts.speak(text);
  }

  String _categoryLabel(String key) {
    final parts = key.split('|').map((s) => s.trim()).toList();
    if (selectedLanguage == 'si-LK' && parts.length > 1) return parts[1];
    if (selectedLanguage == 'ta-IN' && parts.length > 2) return parts[2];
    return parts[0];
  }

  String _getTextForItem(Map<String, dynamic> item) {
    switch (selectedLanguage) {
      case 'si-LK':
        return item['si'] ?? '';
      case 'ta-IN':
        return item['ta'] ?? '';
      default:
        return item['en'] ?? '';
    }
  }

  void _addToSentence(String word) async {
    setState(() => sentence.add(word));
    await StorageService.saveLastSentence(sentence.join('|'));
  }

  void _clearSentence() async {
    setState(() => sentence.clear());
    await StorageService.saveLastSentence('');
  }

  void _changeLanguage(String lang) async {
    setState(() => selectedLanguage = lang);
    await StorageService.saveSelectedLanguage(lang);
  }

  @override
  Widget build(BuildContext context) {
    final categoryKeys = categories.keys.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(140),
        child: SafeArea(
          child: Container(
            height: 140,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(35)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'AAC Helper',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: _changeLanguage,
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                            value: 'si-LK', child: Text('සිංහල')),
                        const PopupMenuItem(
                            value: 'ta-IN', child: Text('தமிழ்')),
                        const PopupMenuItem(
                            value: 'en-US', child: Text('English')),
                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          selectedLanguage == 'si-LK'
                              ? 'සිංහල'
                              : selectedLanguage == 'ta-IN'
                                  ? 'தமிழ்'
                                  : 'EN',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTapDown: (_) => setState(() => _speakerPressed = true),
                      onTapUp: (_) {
                        setState(() => _speakerPressed = false);
                        _speak('Hello $userName');
                      },
                      onTapCancel: () =>
                          setState(() => _speakerPressed = false),
                      child: AnimatedScale(
                        scale: _speakerPressed ? 0.90 : 1.0,
                        duration: const Duration(milliseconds: 100),
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.volume_up,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ස්ලාවු $userName!',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'කතා කරමු',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: sentence.isEmpty
                        ? Center(
                            child: Text(
                              'ඔබගේ වචන',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[400],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => Chip(
                              label: Text(
                                sentence[index],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onDeleted: () {
                                setState(() => sentence.removeAt(index));
                                StorageService.saveLastSentence(
                                    sentence.join('|'));
                              },
                            ),
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemCount: sentence.length,
                          ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (sentence.isNotEmpty) _speak(sentence.join(' '));
                  },
                  icon: const Icon(Icons.volume_up, color: Color(0xFF00BCD4)),
                  tooltip: 'කතා කරන්න',
                ),
                IconButton(
                  onPressed: _clearSentence,
                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                  tooltip: 'පිරිසිදු කරන්න',
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.95,
              ),
              itemCount: categoryKeys.length,
              itemBuilder: (context, index) {
                final key = categoryKeys[index];
                final cat = categories[key]!;
                final color = cat['color'] as Color? ?? Colors.blue;
                final icon = cat['icon'] as IconData? ?? Icons.category;

                return GestureDetector(
                  onTap: () {
                    final items =
                        List<Map<String, dynamic>>.from(cat['items'] ?? []);
                    final actions = cat['actions'] != null
                        ? List<Map<String, dynamic>>.from(cat['actions'])
                        : null;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryScreen(
                          category: _categoryLabel(key),
                          items: items,
                          actions: actions,
                          color: color,
                          language: selectedLanguage,
                          onWordSelected: (word) {
                            final text = _getTextForItem(
                              {'en': word, 'si': word, 'ta': word},
                            );
                            _addToSentence(text);
                          },
                          onSpeak: (word) => _speak(word),
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    shadowColor: color.withOpacity(0.3),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color, color.withOpacity(0.6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              icon,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              _categoryLabel(key),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFB6C1), Color(0xFFFFC0CB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navButton(Icons.home, 'ගෙ', Colors.white, () {}),
            _navButton(
                Icons.history, 'ඉතිහාසය', const Color(0xFFFF1744), () {}),
            _navButton(
                Icons.favorite, 'ප්‍රිය', const Color(0xFFE91E63), () {}),
            _navButton(Icons.settings, 'සැකසුම්', Colors.blue, () {}),
          ],
        ),
      ),
    );
  }

  Widget _navButton(
      IconData icon, String label, Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
