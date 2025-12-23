import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../services/storage_service.dart';
import '../services/theme_service.dart';
import '../widgets/banner_ad_widget.dart';
import '../data/word_data.dart';
import 'category_screen.dart';
import 'settings_screen.dart';
import 'custom_category_screen.dart';
import 'quick_access_settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const HomeScreen({Key? key, required this.onThemeChanged}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  String selectedLanguage = 'si-LK';
  List<String> sentence = [];
  bool isPremium = false;
  bool isDarkMode = false;
  List<String> pinnedCategories = [];
  List<String> hiddenCategories = [];
  List<Map<String, dynamic>> quickAccessWords = [];
  bool showQuickAccess = true;
  bool isKidMode = true;
  late AnimationController _drawerController;
  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    _drawerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _initTts();
    _checkPremiumStatus();
    _loadThemePreference();
    _loadCategoryPreferences();
    _loadQuickAccessWords();
    _loadKidMode();
  }

  @override
  void dispose() {
    _drawerController.dispose();
    super.dispose();
  }

  Future<void> _loadKidMode() async {
    final kidMode = await StorageService.isKidMode();
    setState(() => isKidMode = kidMode);
  }

  Future<void> _toggleKidMode() async {
    setState(() => isKidMode = !isKidMode);
    await StorageService.setKidMode(isKidMode);
    if (isKidMode) {
      _closeDrawer();
    }
  }

  void _toggleDrawer() {
    setState(() => isDrawerOpen = !isDrawerOpen);
    if (isDrawerOpen) {
      _drawerController.forward();
    } else {
      _drawerController.reverse();
    }
  }

  void _closeDrawer() {
    setState(() => isDrawerOpen = false);
    _drawerController.reverse();
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

  Future<void> _loadQuickAccessWords() async {
    final words = await StorageService.getQuickAccessWords();
    setState(() => quickAccessWords = words);
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

  String _getWordText(Map<String, dynamic> word) {
    switch (selectedLanguage) {
      case 'si-LK':
        return word['si'] ?? '';
      case 'ta-IN':
        return word['ta'] ?? '';
      case 'en-US':
        return word['en'] ?? '';
      default:
        return word['si'] ?? '';
    }
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

  List<String> _getFilteredCategories() {
    final allCategories = categories.keys.toList();
    final visible =
        allCategories.where((cat) => !hiddenCategories.contains(cat)).toList();
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
      body: Stack(
        children: [
          // Main Content
          Column(
            children: [
              // App Bar (hidden in kid mode)
              if (!isKidMode)
                AppBar(
                  title: const Text('AAC - කථා කරමු'),
                  actions: [
                    IconButton(
                      icon:
                          Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
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
                        const PopupMenuItem(
                            value: 'si-LK', child: Text('සිංහල')),
                        const PopupMenuItem(
                            value: 'ta-IN', child: Text('දමිල්')),
                        const PopupMenuItem(
                            value: 'en-US', child: Text('English')),
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
                  ],
                ),

              // Sentence builder
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
                                      deleteIcon:
                                          const Icon(Icons.close, size: 18),
                                      onDeleted: () {
                                        setState(() => sentence.remove(word));
                                      },
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
                            icon: const Icon(Icons.volume_up, size: 28),
                            label: const Text('කියන්න',
                                style: TextStyle(fontSize: 18)),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(20),
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: sentence.isEmpty ? null : _clearSentence,
                          icon: const Icon(Icons.clear, size: 24),
                          label: const Text(''),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(20),
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Quick Access Words Section
              if (quickAccessWords.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Quick Access',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      if (!isKidMode)
                        TextButton.icon(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuickAccessSettingsScreen(
                                    language: selectedLanguage),
                              ),
                            );
                            _loadQuickAccessWords();
                          },
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text('Edit'),
                        ),
                      IconButton(
                        icon: Icon(showQuickAccess
                            ? Icons.expand_less
                            : Icons.expand_more),
                        onPressed: () =>
                            setState(() => showQuickAccess = !showQuickAccess),
                      ),
                    ],
                  ),
                ),
                if (showQuickAccess)
                  Container(
                    height: 120,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: quickAccessWords.length,
                      itemBuilder: (context, index) {
                        final word = quickAccessWords[index];
                        final text = _getWordText(word);
                        return GestureDetector(
                          onTap: () {
                            _addToSentence(text);
                            _speak(text);
                          },
                          child: Card(
                            elevation: 4,
                            margin: const EdgeInsets.only(right: 12, bottom: 8),
                            child: Container(
                              width: 100,
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(word['emoji'] ?? '⭐',
                                      style: const TextStyle(fontSize: 40)),
                                  const SizedBox(height: 4),
                                  Text(
                                    text,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                const Divider(height: 1),
              ],

              // Categories Grid
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
                            if (isPinned && !isKidMode)
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

          // Side Drawer Menu
          AnimatedBuilder(
            animation: _drawerController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(-250 * (1 - _drawerController.value), 0),
                child: child,
              );
            },
            child: Container(
              width: 250,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(2, 0),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      color: Colors.blue,
                      child: Row(
                        children: [
                          const Icon(Icons.record_voice_over,
                              size: 40, color: Colors.white),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'AAC Menu',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: _closeDrawer,
                          ),
                        ],
                      ),
                    ),

                    // Kid Mode Toggle
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isKidMode
                            ? Colors.green.withOpacity(0.2)
                            : Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isKidMode ? Colors.green : Colors.orange,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                isKidMode ? Icons.child_care : Icons.settings,
                                color: isKidMode ? Colors.green : Colors.orange,
                                size: 32,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isKidMode ? 'Kid Mode' : 'Parent Mode',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      isKidMode
                                          ? 'Simple & Safe'
                                          : 'All Features',
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: !isKidMode,
                                onChanged: (_) => _toggleKidMode(),
                                activeColor: Colors.orange,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isKidMode
                                ? '🔒 Settings hidden. Switch to Parent Mode to configure.'
                                : '⚙️ All settings available. Switch to Kid Mode for simple interface.',
                            style: const TextStyle(
                                fontSize: 11, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),

                    const Divider(),

                    // Menu Items
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          ListTile(
                            leading:
                                const Icon(Icons.star, color: Colors.amber),
                            title: const Text('Quick Access Setup'),
                            onTap: () async {
                              _closeDrawer();
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      QuickAccessSettingsScreen(
                                          language: selectedLanguage),
                                ),
                              );
                              _loadQuickAccessWords();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.add_circle,
                                color: Colors.purple),
                            title: const Text('Custom Words'),
                            onTap: () async {
                              _closeDrawer();
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustomCategoryScreen(
                                      language: selectedLanguage),
                                ),
                              );
                              _loadCategoryPreferences();
                            },
                          ),
                          ListTile(
                            leading:
                                const Icon(Icons.category, color: Colors.blue),
                            title: const Text('Category Settings'),
                            onTap: () async {
                              _closeDrawer();
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SettingsScreen(),
                                ),
                              );
                              if (result == true) _loadCategoryPreferences();
                            },
                          ),
                          ListTile(
                            leading: Icon(
                                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                                color: Colors.orange),
                            title:
                                Text(isDarkMode ? 'Light Mode' : 'Dark Mode'),
                            onTap: () {
                              setState(() => isDarkMode = !isDarkMode);
                              widget.onThemeChanged(isDarkMode);
                            },
                          ),
                          ListTile(
                            leading:
                                const Icon(Icons.language, color: Colors.green),
                            title: Text('Language: ${_getLanguageName()}'),
                            onTap: () => _showLanguageDialog(),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.volunteer_activism,
                                color: Colors.red),
                            title: const Text('Donate'),
                            onTap: () {
                              _closeDrawer();
                              _showDonationDialog();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.info, color: Colors.grey),
                            title: const Text('About'),
                            onTap: () => _showAboutDialog(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Hamburger Button
          Positioned(
            top: MediaQuery.of(context).padding.top + (isKidMode ? 10 : 0),
            left: 10,
            child: GestureDetector(
              onTap: _toggleDrawer,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isDrawerOpen ? Icons.close : Icons.menu,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),

          // Overlay
          if (isDrawerOpen)
            GestureDetector(
              onTap: _closeDrawer,
              child: Container(
                color: Colors.black.withOpacity(0.3),
                margin: const EdgeInsets.only(left: 250),
              ),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (quickAccessWords.isEmpty)
            FloatingActionButton.extended(
              heroTag: 'quick_access',
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        QuickAccessSettingsScreen(language: selectedLanguage),
                  ),
                );
                _loadQuickAccessWords();
              },
              icon: const Icon(Icons.star),
              label: const Text('Quick Access'),
              backgroundColor: Colors.amber,
            ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'custom',
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
            tooltip: 'Add Custom',
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('සිංහල'),
              value: 'si-LK',
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() => selectedLanguage = value!);
                _initTts();
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('தமிழ்'),
              value: 'ta-IN',
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() => selectedLanguage = value!);
                _initTts();
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en-US',
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() => selectedLanguage = value!);
                _initTts();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About AAC'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'AAC කථා කරමු',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Version 1.0.0'),
              SizedBox(height: 16),
              Text(
                  'Augmentative and Alternative Communication app for autism children in Sri Lanka.'),
              SizedBox(height: 16),
              Text('Features:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• Sinhala, Tamil & English'),
              Text('• Text-to-Speech'),
              Text('• Quick Access Dashboard'),
              Text('• Custom Words'),
              Text('• Kid Mode'),
              SizedBox(height: 16),
              Text('💙 Made with love for Sri Lankan children'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
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

// Donation Dialog
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
            const Text(
              'ස්තූතියි! ඔබේ දායකත්වය ළමයින්ට උදව් කරයි.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
          onPressed: () {
            Clipboard.setData(const ClipboardData(
                text:
                    'Bank: Bank of Ceylon\nBranch: Negombo\nAccount: 87654321\nName: AAC Lanka Foundation'));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Copied to clipboard!')),
            );
          },
          child: const Text('Copy Details'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
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
