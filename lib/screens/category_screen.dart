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

  String _getActionText(Map<String, dynamic> action) {
    switch (language) {
      case 'si-LK':
        return action['si'] as String;
      case 'ta-IN':
        return action['ta'] as String;
      case 'en-US':
        return action['en'] as String;
      default:
        return action['si'] as String;
    }
  }

  void _showActionsBottomSheet(
      BuildContext context, String itemText, List<dynamic> actions) {
    final colors = AppTheme.getThemeColors(isGirl);

    showModalBottomSheet(
      context: context,
      backgroundColor: colors['background'],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colors['background']!,
                colors['accent']!.withOpacity(0.2),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  itemText,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colors['textColor'],
                  ),
                ),
              ),
              const Divider(),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: actions.length,
                  itemBuilder: (context, index) {
                    final action = actions[index] as Map<String, dynamic>;
                    final actionText = _getActionText(action);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            onWordSelected(actionText);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colors['primary']!,
                                  colors['accent']!,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '✓',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: colors['buttonText'],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    actionText,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: colors['buttonText'],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
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
                    final actions = item['actions'] as List<dynamic>? ?? [];

                    return GestureDetector(
                      onLongPress: actions.isNotEmpty
                          ? () =>
                              _showActionsBottomSheet(context, text, actions)
                          : null,
                      child: CustomWordCard(
                        text: text,
                        emoji: item['emoji'],
                        isGirl: isGirl,
                        language: language,
                        onTap: () {
                          onWordSelected(text);
                          Navigator.pop(context);
                        },
                        onSpeak: () => onSpeak(text),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
