import 'package:flutter/material.dart';
import '../data/word_data.dart';
import '../services/storage_service.dart';

class QuickAccessSettingsScreen extends StatefulWidget {
  final String language;

  const QuickAccessSettingsScreen({Key? key, required this.language})
      : super(key: key);

  @override
  State<QuickAccessSettingsScreen> createState() =>
      _QuickAccessSettingsScreenState();
}

class _QuickAccessSettingsScreenState extends State<QuickAccessSettingsScreen> {
  List<Map<String, dynamic>> selectedWords = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSelectedWords();
  }

  Future<void> _loadSelectedWords() async {
    final words = await StorageService.getQuickAccessWords();
    setState(() {
      selectedWords = words;
      isLoading = false;
    });
  }

  bool _isWordSelected(Map<String, dynamic> word) {
    return selectedWords.any((w) =>
        w['si'] == word['si'] &&
        w['ta'] == word['ta'] &&
        w['en'] == word['en']);
  }

  Future<void> _toggleWord(Map<String, dynamic> word) async {
    setState(() {
      if (_isWordSelected(word)) {
        selectedWords.removeWhere((w) =>
            w['si'] == word['si'] &&
            w['ta'] == word['ta'] &&
            w['en'] == word['en']);
      } else {
        if (selectedWords.length < 10) {
          selectedWords.add(word);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Maximum 10 words allowed in Quick Access')),
          );
        }
      }
    });
    await StorageService.saveQuickAccessWords(selectedWords);
  }

  String _getWordText(Map<String, dynamic> word) {
    switch (widget.language) {
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Access Setup'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.amber.withOpacity(0.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 28),
                    SizedBox(width: 8),
                    Text(
                      'Quick Access Words',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Select up to 10 most used words. They will appear at the top of the home screen for quick access.',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                Text(
                  '${selectedWords.length}/10 selected',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color:
                        selectedWords.length >= 10 ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
          ),

          // Selected Words Preview
          if (selectedWords.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Selected Words:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ReorderableListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: selectedWords.length,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex--;
                    final item = selectedWords.removeAt(oldIndex);
                    selectedWords.insert(newIndex, item);
                  });
                  StorageService.saveQuickAccessWords(selectedWords);
                },
                itemBuilder: (context, index) {
                  final word = selectedWords[index];
                  final text = _getWordText(word);
                  return Card(
                    key: ValueKey(word),
                    elevation: 4,
                    margin: const EdgeInsets.only(right: 8),
                    child: Container(
                      width: 90,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(word['emoji'] ?? '⭐',
                              style: const TextStyle(fontSize: 32)),
                          const SizedBox(height: 4),
                          Text(
                            text,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
          ],

          // All Words by Category
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              itemBuilder: (context, catIndex) {
                final category = categories.keys.elementAt(catIndex);
                final categoryData = categories[category]!;
                final items =
                    categoryData['items'] as List<Map<String, dynamic>>;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    leading: Icon(categoryData['icon'],
                        color: categoryData['color']),
                    title: Text(
                      category,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${items.length} words'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: items.map((word) {
                            final isSelected = _isWordSelected(word);
                            final text = _getWordText(word);
                            return FilterChip(
                              selected: isSelected,
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(word['emoji'] ?? '⭐'),
                                  const SizedBox(width: 4),
                                  Text(text),
                                ],
                              ),
                              selectedColor: Colors.amber.withOpacity(0.5),
                              checkmarkColor: Colors.amber[900],
                              onSelected: (_) => _toggleWord(word),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: selectedWords.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () async {
                await StorageService.saveQuickAccessWords([]);
                setState(() => selectedWords.clear());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Quick Access cleared')),
                );
              },
              icon: const Icon(Icons.clear_all),
              label: const Text('Clear All'),
              backgroundColor: Colors.red,
            )
          : null,
    );
  }
}
