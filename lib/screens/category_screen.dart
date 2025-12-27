import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/app_theme.dart';
import 'theme/custom_card_widget.dart';

class CategoryScreen extends StatefulWidget {
  final String category;
  final List<Map<String, dynamic>> items;
  final String language;
  final Function(String) onWordSelected;
  final Function(String) onSpeak;
  final bool isGirl;
  final int currentCategoryIndex;
  final int totalCategories;
  final Function(int)? onNavigateToCategory;

  const CategoryScreen({
    Key? key,
    required this.category,
    required this.items,
    required this.language,
    required this.onWordSelected,
    required this.onSpeak,
    required this.isGirl,
    this.currentCategoryIndex = 0,
    this.totalCategories = 14,
    this.onNavigateToCategory,
  }) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('user_name');
    
    if (savedName == null || savedName.isEmpty) {
      // නම නැත්නම් අහන්න
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showNameDialog();
      });
    } else {
      setState(() => userName = savedName);
      _speakGreeting(savedName);
    }
  }

  Future<void> _showNameDialog() async {
    final TextEditingController nameController = TextEditingController();
    final colors = AppTheme.getThemeColors(widget.isGirl);

    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors['gradient1']!, colors['gradient2']!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '👋',
                style: TextStyle(fontSize: 60),
              ),
              const SizedBox(height: 16),
              Text(
                widget.language == 'si-LK'
                    ? 'ඔබේ නම මොකක්ද?'
                    : widget.language == 'ta-IN'
                        ? 'உங்கள் பெயர் என்ன?'
                        : 'What is your name?',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: nameController,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colors['textColor'],
                  ),
                  decoration: InputDecoration(
                    hintText: widget.language == 'si-LK'
                        ? 'නම ලියන්න...'
                        : widget.language == 'ta-IN'
                            ? 'பெயரை எழுதுங்கள்...'
                            : 'Enter name...',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      Navigator.pop(context, value);
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    Navigator.pop(context, nameController.text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: colors['primary'],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '✓',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.language == 'si-LK'
                          ? 'හරි'
                          : widget.language == 'ta-IN'
                              ? 'சரி'
                              : 'OK',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (result != null && result.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', result);
      setState(() => userName = result);
      _speakGreeting(result);
    }
  }

  void _speakGreeting(String name) {
    final greeting = widget.language == 'si-LK'
        ? 'හෙලෝ $name'
        : widget.language == 'ta-IN'
            ? 'வணக்கம் $name'
            : 'Hello $name';
    widget.onSpeak(greeting);
  }

  String _getText(Map<String, dynamic> item) {
    switch (widget.language) {
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
    switch (widget.language) {
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
    final colors = AppTheme.getThemeColors(widget.isGirl);

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
                            widget.onWordSelected(actionText);
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
    final colors = AppTheme.getThemeColors(widget.isGirl);

    return Theme(
      data: AppTheme.getThemeData(widget.isGirl),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              // Sound button
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.volume_up, size: 28),
                  color: Colors.white,
                  onPressed: () {
                    if (userName.isNotEmpty) {
                      _speakGreeting(userName);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Greeting text
              Expanded(
                child: GestureDetector(
                  onTap: _showNameDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      userName.isEmpty
                          ? (widget.language == 'si-LK'
                              ? 'හෙලෝ'
                              : widget.language == 'ta-IN'
                                  ? 'வணக்கம்'
                                  : 'Hello')
                          : (widget.language == 'si-LK'
                              ? 'හෙලෝ $userName'
                              : widget.language == 'ta-IN'
                                  ? 'வணக்கம் $userName'
                                  : 'Hello $userName'),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Settings button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.settings, size: 28),
                  color: Colors.white,
                  onPressed: _showNameDialog,
                ),
              ),
            ],
          ),
          elevation: 0,
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
          child: Column(
            children: [
              // Category title
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colors['gradient1']!, colors['gradient2']!],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors['primary']!.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Text(
                  widget.category,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              // Content
              Expanded(
                child: widget.items.isEmpty
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
                              widget.language == 'si-LK'
                                  ? 'කිසිදු දේ නැත'
                                  : widget.language == 'ta-IN'
                                      ? 'எதுவும் இல்லை'
                                      : 'Nothing here',
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
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: widget.items.length,
                        itemBuilder: (context, index) {
                          final item = widget.items[index];
                          final text = _getText(item);
                          final actions =
                              item['actions'] as List<dynamic>? ?? [];

                          return GestureDetector(
                            onLongPress: actions.isNotEmpty
                                ? () => _showActionsBottomSheet(
                                    context, text, actions)
                                : null,
                            child: CustomWordCard(
                              text: text,
                              emoji: item['emoji'],
                              isGirl: widget.isGirl,
                              language: widget.language,
                              onTap: () {
                                widget.onWordSelected(text);
                                Navigator.pop(context);
                              },
                              onSpeak: () => widget.onSpeak(text),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        // Bottom navigation
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors['gradient1']!, colors['gradient2']!],
            ),
            boxShadow: [
              BoxShadow(
                color: colors['primary']!.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous button
                  _buildNavButton(
                    icon: Icons.arrow_back,
                    label: widget.language == 'si-LK'
                        ? 'පෙර'
                        : widget.language == 'ta-IN'
                            ? 'பின்'
                            : 'Prev',
                    onPressed: widget.currentCategoryIndex > 0
                        ? () {
                            if (widget.onNavigateToCategory != null) {
                              widget.onNavigateToCategory!(
                                  widget.currentCategoryIndex - 1);
                            }
                          }
                        : null,
                    colors: colors,
                  ),
                  
                  // Home button (larger)
                  Container(
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
                    child: IconButton(
                      icon: const Icon(Icons.home, size: 36),
                      color: Colors.white,
                      onPressed: () => Navigator.pop(context),
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                  
                  // Next button
                  _buildNavButton(
                    icon: Icons.arrow_forward,
                    label: widget.language == 'si-LK'
                        ? 'ඊළඟ'
                        : widget.language == 'ta-IN'
                            ? 'அடுத்தது'
                            : 'Next',
                    onPressed: widget.currentCategoryIndex <
                            widget.totalCategories - 1
                        ? () {
                            if (widget.onNavigateToCategory != null) {
                              widget.onNavigateToCategory!(
                                  widget.currentCategoryIndex + 1);
                            }
                          }
                        : null,
                    colors: colors,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required Map<String, Color> colors,
  }) {
    final isEnabled = onPressed != null;
    
    return Container(
      decoration: BoxDecoration(
        color: isEnabled
            ? Colors.blue
            : Colors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}