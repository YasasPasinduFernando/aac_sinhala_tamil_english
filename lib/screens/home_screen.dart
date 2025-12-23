import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../services/storage_service.dart';
import '../services/theme_service.dart';
import '../widgets/banner_ad_widget.dart';
import '../data/word_data.dart';
import 'category_screen.dart';
import 'settings_screen.dart';
import 'custom_category_screen.dart';
import 'quick_access_settings_screen.dart';
import 'theme_settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const HomeScreen({Key? key, required this.onThemeChanged}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterTts flutterTts = FlutterTts();
  String selectedLanguage = 'si-LK';
  List<String> sentence = [];
  bool isPremium = false;
  bool isDarkMode = false;
  List<String> pinnedCategories = [];
  List<String> hiddenCategories = [];

  @override
  void initState() {
    super.initState();
    _initTts();
    _checkPremiumStatus();
    _loadThemePreference();
    _loadCategoryPreferences();
  }

  Future<void> _loadThemePreference() async {
    final dark = await ThemeService.isDarkMode();
    setState(() => isDarkMode = dark);
  }

  Future<void> _loadCategoryPreferences() async {
    final pinned = await StorageService.getPinnedCategories();
    final hidden = await StorageService.getHiddenCategories();
    setState(() {
      pinnedCategories = pinned;
      hiddenCategories = hidden;
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
    if (sentence.isNotEmpty) _speak(sentence.join(' '));
  }

  void _clearSentence() {
    setState(() => sentence.clear());
  }

  List<String> _getFilteredCategories() {
    final allCategories = categories.keys.toList();

    // Remove hidden categories
    final visible =
        allCategories.where((cat) => !hiddenCategories.contains(cat)).toList();

    // Sort: pinned first, then rest
    visible.sort((a, b) {
      final aPinned = pinnedCategories.contains(a);
      final bPinned = pinnedCategories.contains(b);
      if (aPinned && !bPinned) return -1;
      if (!aPinned && bPinned) return 1;
      return 0;
    });

    return visible;
  }

  @override
  Widget build(BuildContext context) {
    final visibleCategories = _getFilteredCategories();

    return Scaffold(
      appBar: AppBar(
        title: const Text('AAC - කථා කරමු'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() => isDarkMode = !isDarkMode);
              widget.onThemeChanged(isDarkMode);
            },
          ),
          IconButton(
            icon: const Icon(Icons.volunteer_activism),
            onPressed: () => _showDonationDialog(),
            tooltip: 'Donate',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (String value) {
              setState(() => selectedLanguage = value);
              _initTts();
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'si-LK', child: Text('සිංහල')),
              const PopupMenuItem(value: 'ta-IN', child: Text('දමිල්')),
              const PopupMenuItem(value: 'en-US', child: Text('English')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
              if (result == true) _loadCategoryPreferences();
            },
          ),
          IconButton(
            icon: const Icon(Icons.palette),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ThemeSettingsScreen(
                    onThemeChanged: (colorName) {
                      // Theme will be updated globally
                    },
                  ),
                ),
              );
            },
            tooltip: 'තේමා',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[850]
                : Colors.grey[200],
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: sentence.isEmpty
                        ? [
                            Text('Select words... | වචන තෝරන්න...',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[600]))
                          ]
                        : sentence
                            .map((word) => Chip(
                                  label: Text(word,
                                      style: const TextStyle(fontSize: 16)),
                                  backgroundColor: Colors.blue[100],
                                ))
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
                            foregroundColor: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: sentence.isEmpty ? null : _clearSentence,
                      icon: const Icon(Icons.clear),
                      label: const Text('Clear'),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: visibleCategories.length,
              itemBuilder: (context, index) {
                final category = visibleCategories[index];
                final categoryData = categories[category]!;
                final isPinned = pinnedCategories.contains(category);

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
                    elevation: isPinned ? 8 : 4,
                    color: categoryData['color'],
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(categoryData['icon'],
                                size: 50, color: Colors.white),
                            const SizedBox(height: 8),
                            Text(
                              category,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        if (isPinned)
                          const Positioned(
                            top: 4,
                            right: 4,
                            child: Icon(Icons.push_pin,
                                size: 20, color: Colors.white),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (!isPremium) const BannerAdWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CustomCategoryScreen(language: selectedLanguage),
            ),
          );
          _loadCategoryPreferences();
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Custom Category',
      ),
    );
  }

  void _showDonationDialog() {
    showDialog(
      context: context,
      builder: (context) => const DonationDialog(),
    );
  }
}

class DonationDialog extends StatelessWidget {
  const DonationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.volunteer_activism, color: Colors.red),
          SizedBox(width: 8),
          Text('💝 Donation Details'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('ස්තූතියි! ඔබේ දායකත්වය ළමයින්ට උදව් කරයි.',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.account_balance, 'Bank', 'Bank of Ceylon'),
            _buildDetailRow(Icons.business, 'Branch', 'Negombo'),
            _buildDetailRow(Icons.numbers, 'Account No', '87654321'),
            _buildDetailRow(
                Icons.person, 'Account Name', 'AAC Lanka Foundation'),
            const Divider(height: 24),
            _buildDetailRow(Icons.phone_android, 'eZ Cash', '0771234567'),
            _buildDetailRow(Icons.phone_android, 'mCash', '0771234567'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '💙 ඔබේ සෑම දායකත්වයක්ම ළමයින්ට නොමිලේ මෙම app එක භාවිතා කිරීමට උදව් කරයි!',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  static Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
