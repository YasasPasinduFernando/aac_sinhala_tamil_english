import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../services/storage_service.dart';
import '../services/ads_service.dart';
import '../widgets/banner_ad_widget.dart';
import '../data/word_data.dart';
import 'category_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterTts flutterTts = FlutterTts();
  String selectedLanguage = 'si-LK';
  List<String> sentence = [];
  bool isPremium = false;

  @override
  void initState() {
    super.initState();
    _initTts();
    _checkPremiumStatus();
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

  String _getLanguageName() {
    switch (selectedLanguage) {
      case 'si-LK':
        return 'සිංහල';
      case 'ta-IN':
        return 'தமிழ்';
      case 'en-US':
        return 'English';
      default:
        return 'සිංහල';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AAC - කථා කරමු'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (String value) {
              setState(() => selectedLanguage = value);
              _initTts();
            },
            itemBuilder: (BuildContext context) => const [
              PopupMenuItem(value: 'si-LK', child: Text('සිංහල')),
              PopupMenuItem(value: 'ta-IN', child: Text('தமிழ்')),
              PopupMenuItem(value: 'en-US', child: Text('English')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Sentence builder
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: sentence.isEmpty
                        ? [
                            Text(
                              'Select words... | වචන තෝරන්න...',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ]
                        : sentence
                              .map(
                                (word) => Chip(
                                  label: Text(
                                    word,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  backgroundColor: Colors.blue[100],
                                ),
                              )
                              .toList(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: sentence.isEmpty ? null : _speakSentence,
                        icon: const Icon(Icons.volume_up),
                        label: const Text('Speak | කියන්න'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: sentence.isEmpty ? null : _clearSentence,
                      icon: const Icon(Icons.clear),
                      label: const Text('Clear | මකන්න'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Categories
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories.keys.elementAt(index);
                final categoryData = categories[category]!;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryScreen(
                          category: category,
                          items: categoryData['items'],
                          color: categoryData['color'],
                          language: selectedLanguage,
                          onWordSelected: _addToSentence,
                          onSpeak: _speak,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    color: categoryData['color'],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          categoryData['icon'],
                          size: 50,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Banner Ad (only for non-premium users)
          if (!isPremium) const BannerAdWidget(),
        ],
      ),
    );
  }
}
