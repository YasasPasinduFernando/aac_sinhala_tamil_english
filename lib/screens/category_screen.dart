import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  final String category;
  final List<Map<String, dynamic>> items;
  final Color color;
  final String language;
  final Function(String) onWordSelected;
  final Function(String) onSpeak;

  const CategoryScreen({
    Key? key,
    required this.category,
    required this.items,
    required this.color,
    required this.language,
    required this.onWordSelected,
    required this.onSpeak,
  }) : super(key: key);

  String _getText(Map<String, dynamic> item) {
    switch (language) {
      case 'si-LK':
        return item['si'];
      case 'ta-IN':
        return item['ta'];
      case 'en-US':
        return item['en'];
      default:
        return item['si'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category), backgroundColor: color),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final text = _getText(item);
          return GestureDetector(
            onTap: () {
              onWordSelected(text);
              onSpeak(text);
              Navigator.pop(context);
            },
            child: Card(
              elevation: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item['emoji'], style: const TextStyle(fontSize: 50)),
                  const SizedBox(height: 8),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
