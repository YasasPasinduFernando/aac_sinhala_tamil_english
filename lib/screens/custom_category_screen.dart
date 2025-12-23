import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../data/word_data.dart';

class CustomCategoryScreen extends StatefulWidget {
  final String language;

  const CustomCategoryScreen({Key? key, required this.language})
      : super(key: key);

  @override
  State<CustomCategoryScreen> createState() => _CustomCategoryScreenState();
}

class _CustomCategoryScreenState extends State<CustomCategoryScreen> {
  final _categoryController = TextEditingController();
  final _sinController = TextEditingController();
  final _taController = TextEditingController();
  final _enController = TextEditingController();
  final _emojiController = TextEditingController();

  String? selectedExistingCategory;
  List<Map<String, dynamic>> customWords = [];

  @override
  void initState() {
    super.initState();
    _loadCustomWords();
  }

  Future<void> _loadCustomWords() async {
    final words = await StorageService.getCustomWords();
    setState(() => customWords = words);
  }

  Future<void> _addWord() async {
    if (_sinController.text.isEmpty ||
        _taController.text.isEmpty ||
        _enController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all language fields')),
      );
      return;
    }

    final word = {
      'si': _sinController.text,
      'ta': _taController.text,
      'en': _enController.text,
      'emoji': _emojiController.text.isEmpty ? '⭐' : _emojiController.text,
      'category': selectedExistingCategory ?? _categoryController.text,
    };

    customWords.add(word);
    await StorageService.saveCustomWords(customWords);

    // Add to categories if new category
    if (selectedExistingCategory == null &&
        _categoryController.text.isNotEmpty) {
      categories[_categoryController.text] = {
        'icon': Icons.star,
        'color': Colors.purple,
        'items': [word],
      };
    } else if (selectedExistingCategory != null) {
      categories[selectedExistingCategory]!['items'].add(word);
    }

    _clearFields();
    _loadCustomWords();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Word added successfully!')),
    );
  }

  void _clearFields() {
    _sinController.clear();
    _taController.clear();
    _enController.clear();
    _emojiController.clear();
  }

  Future<void> _deleteWord(int index) async {
    customWords.removeAt(index);
    await StorageService.saveCustomWords(customWords);
    _loadCustomWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Words & Categories'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Add Custom Words',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add words that are important to you or your child',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Category Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Choose Category',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedExistingCategory,
                      decoration: const InputDecoration(
                        labelText: 'Existing Category',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem(
                            value: null, child: Text('Create New Category')),
                        ...categories.keys.map((cat) =>
                            DropdownMenuItem(value: cat, child: Text(cat))),
                      ],
                      onChanged: (value) =>
                          setState(() => selectedExistingCategory = value),
                    ),
                    if (selectedExistingCategory == null) ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: _categoryController,
                        decoration: const InputDecoration(
                          labelText: 'New Category Name',
                          border: OutlineInputBorder(),
                          hintText: 'e.g., My Favorites',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Word Input
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Word in All Languages',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _sinController,
                      decoration: const InputDecoration(
                        labelText: 'සිංහල (Sinhala)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.translate),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _taController,
                      decoration: const InputDecoration(
                        labelText: 'தமிழ் (Tamil)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.translate),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _enController,
                      decoration: const InputDecoration(
                        labelText: 'English',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.translate),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _emojiController,
                      decoration: const InputDecoration(
                        labelText: 'Emoji (optional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.emoji_emotions),
                        hintText: '😀 🎮 ⚽',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _addWord,
              icon: const Icon(Icons.add),
              label: const Text('Add Word'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 32),

            // Saved Custom Words
            const Text(
              'Your Custom Words',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            if (customWords.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'No custom words yet.\nAdd words that matter to you!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ...customWords.asMap().entries.map((entry) {
                final index = entry.key;
                final word = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Text(
                      word['emoji'] ?? '⭐',
                      style: const TextStyle(fontSize: 32),
                    ),
                    title:
                        Text('${word['si']} • ${word['ta']} • ${word['en']}'),
                    subtitle: Text('Category: ${word['category']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteWord(index),
                    ),
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}
