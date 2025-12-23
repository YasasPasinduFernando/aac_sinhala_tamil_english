import 'package:flutter/material.dart';
import '../data/word_data.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<String> pinnedCategories = [];
  List<String> hiddenCategories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final pinned = await StorageService.getPinnedCategories();
    final hidden = await StorageService.getHiddenCategories();
    setState(() {
      pinnedCategories = pinned;
      hiddenCategories = hidden;
      isLoading = false;
    });
  }

  Future<void> _togglePin(String category) async {
    setState(() {
      if (pinnedCategories.contains(category)) {
        pinnedCategories.remove(category);
      } else {
        pinnedCategories.add(category);
      }
    });
    await StorageService.savePinnedCategories(pinnedCategories);
  }

  Future<void> _toggleHide(String category) async {
    setState(() {
      if (hiddenCategories.contains(category)) {
        hiddenCategories.remove(category);
      } else {
        hiddenCategories.add(category);
        // Remove from pinned if hiding
        pinnedCategories.remove(category);
      }
    });
    await StorageService.saveHiddenCategories(hiddenCategories);
    await StorageService.savePinnedCategories(pinnedCategories);
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
        title: const Text('Category Settings'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Done', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manage Categories',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Pin your favorite categories to show them first, or hide categories you don\'t need.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          const Divider(),
          ...categories.keys.map((category) {
            final categoryData = categories[category]!;
            final isPinned = pinnedCategories.contains(category);
            final isHidden = hiddenCategories.contains(category);

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                leading: Icon(
                  categoryData['icon'],
                  color: categoryData['color'],
                  size: 32,
                ),
                title: Text(
                  category,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: isHidden ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text(
                  isPinned ? '📌 Pinned' : (isHidden ? '🙈 Hidden' : 'Visible'),
                  style: TextStyle(
                    color: isPinned
                        ? Colors.blue
                        : (isHidden ? Colors.grey : Colors.green),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                        color: isPinned ? Colors.blue : Colors.grey,
                      ),
                      onPressed: isHidden ? null : () => _togglePin(category),
                      tooltip: 'Pin/Unpin',
                    ),
                    IconButton(
                      icon: Icon(
                        isHidden ? Icons.visibility_off : Icons.visibility,
                        color: isHidden ? Colors.red : Colors.green,
                      ),
                      onPressed: () => _toggleHide(category),
                      tooltip: 'Show/Hide',
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
