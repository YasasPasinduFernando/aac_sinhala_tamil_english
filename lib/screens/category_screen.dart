import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'theme/custom_card_widget.dart';

class CategoryScreen extends StatelessWidget {
  final String category;
  final List<Map<String, dynamic>> items;
  final String language;
  final Function(String) onWordSelected;
  final Function(String) onSpeak;
  final bool isGirl;

  const CategoryScreen({
    Key? key,
    required this.category,
    required this.items,
    required this.language,
    required this.onWordSelected,
    required this.onSpeak,
    required this.isGirl,
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
    final colors = AppTheme.getThemeColors(isGirl);

    return Theme(
      data: AppTheme.getThemeData(isGirl),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            category,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colors['background']!,
                colors['accent']!.withOpacity(0.3),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '😢',
                        style: TextStyle(fontSize: 60),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'කිසිදු දේ නැත',
                        style: TextStyle(
                          fontSize: 20,
                          color: colors['textColor'],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final text = _getText(item);
                    return CustomWordCard(
                      text: text,
                      emoji: item['emoji'],
                      isGirl: isGirl,
                      language: language,
                      onTap: () {
                        onWordSelected(text);
                        Navigator.pop(context);
                      },
                      onSpeak: () => onSpeak(text),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
