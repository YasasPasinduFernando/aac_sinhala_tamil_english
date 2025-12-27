import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/app_theme.dart';
import 'theme/custom_card_widget.dart';

class CategoryScreen extends StatefulWidget {
  final List<Map<String, dynamic>> allCategories;
  final int initialCategoryIndex;
  final String language;
  final Function(String) onWordSelected;
  final Function(String) onSpeak;
  final bool isGirl;

  const CategoryScreen({
    Key? key,
    required this.allCategories,
    required this.initialCategoryIndex,
    required this.language,
    required this.onWordSelected,
    required this.onSpeak,
    required this.isGirl,
  }) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late PageController _pageController;
  late int currentCategoryIndex;
  String userName = '';
  bool hasAskedName = false;

  @override
  void initState() {
    super.initState();
    currentCategoryIndex = widget.initialCategoryIndex;
    _pageController = PageController(initialPage: currentCategoryIndex);
    _loadUserName();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('userName') ?? '';

    if (mounted) {
      setState(() {
        userName = savedName;
        hasAskedName = savedName.isNotEmpty;
      });

      if (savedName.isEmpty) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _showNameDialog();
        });
      }
    }
  }

  Future<void> _saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
  }

  void _showNameDialog() {
    final colors = AppTheme.getThemeColors(widget.isGirl);
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors['gradient1']!, colors['gradient2']!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: colors['primary']!.withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated cute avatar
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.6),
                            blurRadius: 25,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          widget.isGirl ? '👧' : '👦',
                          style: const TextStyle(fontSize: 65),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              // Sparkles decoration
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('✨', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 8),
                  Text('✨', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 8),
                  Text('✨', style: TextStyle(fontSize: 20)),
                ],
              ),
              const SizedBox(height: 16),
              // Question with wave animation
              Text(
                widget.language == 'si-LK'
                    ? '👋 ඔයාගේ නම මොකද්ද?'
                    : widget.language == 'ta-IN'
                        ? '👋 உங்கள் பெயர் என்ன?'
                        : '👋 What is your name?',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              // Input field with icon
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        '✏️',
                        style: TextStyle(
                          fontSize: 24,
                          color: colors['primary'],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: nameController,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: colors['textColor'],
                        ),
                        decoration: InputDecoration(
                          hintText: widget.language == 'si-LK'
                              ? 'නම ලියන්න...'
                              : widget.language == 'ta-IN'
                                  ? 'பெயரை எழுதுங்கள்...'
                                  : 'Type your name...',
                          hintStyle: TextStyle(
                            color: colors['textColor']!.withOpacity(0.4),
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // OK Button with gradient
              GestureDetector(
                onTap: () {
                  final name = nameController.text.trim();
                  if (name.isNotEmpty) {
                    setState(() {
                      userName = name;
                      hasAskedName = true;
                    });
                    _saveUserName(name);
                    Navigator.pop(context);

                    final greeting = widget.language == 'si-LK'
                        ? 'හෙලෝ $name'
                        : widget.language == 'ta-IN'
                            ? 'வணக்கம் $name'
                            : 'Hello $name';
                    widget.onSpeak(greeting);
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.white.withOpacity(0.95)],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '✅',
                        style: TextStyle(
                          fontSize: 28,
                          color: colors['primary'],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        widget.language == 'si-LK'
                            ? 'හරි!'
                            : widget.language == 'ta-IN'
                                ? 'சரி!'
                                : 'OK!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: colors['primary'],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _speakGreeting() {
    if (userName.isEmpty) return;

    final greeting = widget.language == 'si-LK'
        ? 'හෙලෝ $userName'
        : widget.language == 'ta-IN'
            ? 'வணக்கம் $userName'
            : 'Hello $userName';

    widget.onSpeak(greeting);
  }

  void _navigateToCategory(int index) {
    if (index >= 0 && index < widget.allCategories.length) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
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

  Widget _buildCategoryPage(Map<String, dynamic> categoryData) {
    final colors = AppTheme.getThemeColors(widget.isGirl);
    final items = categoryData['items'] as List<Map<String, dynamic>>;

    return Container(
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
                      ? () => _showActionsBottomSheet(context, text, actions)
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.getThemeColors(widget.isGirl);
    final currentCategory = widget.allCategories[currentCategoryIndex];

    return Theme(
      data: AppTheme.getThemeData(widget.isGirl),
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                currentCategory['name'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (hasAskedName && userName.isNotEmpty)
                Text(
                  'Hello $userName! 👋',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
            ],
          ),
          centerTitle: true,
          elevation: 0,
          leading: hasAskedName && userName.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.volume_up,
                          size: 24, color: Colors.white),
                    ),
                    onPressed: _speakGreeting,
                    tooltip: 'Say Hello',
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.settings, size: 24),
                ),
                onPressed: () => _showNameDialog(),
                tooltip: 'Settings',
              ),
            ),
          ],
        ),
        body: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              currentCategoryIndex = index;
            });
          },
          itemCount: widget.allCategories.length,
          itemBuilder: (context, index) {
            return _buildCategoryPage(widget.allCategories[index]);
          },
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.getGradient(widget.isGirl),
            boxShadow: [
              BoxShadow(
                color: colors['primary']!.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous Category Button
                  _buildNavButton(
                    icon: Icons.arrow_back_ios_rounded,
                    label: widget.language == 'si-LK'
                        ? 'පෙර'
                        : widget.language == 'ta-IN'
                            ? 'முந்தைய'
                            : 'Prev',
                    onTap: currentCategoryIndex > 0
                        ? () => _navigateToCategory(currentCategoryIndex - 1)
                        : null,
                    enabled: currentCategoryIndex > 0,
                  ),
                  // Home Button (Larger & Center)
                  _buildNavButton(
                    icon: Icons.home_rounded,
                    label: widget.language == 'si-LK'
                        ? 'ගෙදර'
                        : widget.language == 'ta-IN'
                            ? 'வீடு'
                            : 'Home',
                    onTap: () => Navigator.pop(context),
                    isHome: true,
                    size: 50,
                  ),
                  // Next Category Button
                  _buildNavButton(
                    icon: Icons.arrow_forward_ios_rounded,
                    label: widget.language == 'si-LK'
                        ? 'ඊළඟ'
                        : widget.language == 'ta-IN'
                            ? 'அடுத்த'
                            : 'Next',
                    onTap: currentCategoryIndex <
                            widget.allCategories.length - 1
                        ? () => _navigateToCategory(currentCategoryIndex + 1)
                        : null,
                    enabled:
                        currentCategoryIndex < widget.allCategories.length - 1,
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
    String? label,
    required VoidCallback? onTap,
    bool enabled = true,
    bool isHome = false,
    double size = 28,
  }) {
    final colors = AppTheme.getThemeColors(widget.isGirl);

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isHome ? 20 : 16,
          vertical: isHome ? 16 : 12,
        ),
        decoration: BoxDecoration(
          gradient: enabled
              ? (isHome
                  ? LinearGradient(
                      colors: [Colors.white, Colors.white.withOpacity(0.95)],
                    )
                  : LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.3),
                        Colors.white.withOpacity(0.2),
                      ],
                    ))
              : null,
          color: enabled ? null : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(isHome ? 25 : 20),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: isHome
                        ? Colors.white.withOpacity(0.6)
                        : Colors.black.withOpacity(0.15),
                    blurRadius: isHome ? 20 : 8,
                    spreadRadius: isHome ? 3 : 0,
                    offset: Offset(0, isHome ? 3 : 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: size,
              color: enabled
                  ? (isHome ? colors['primary'] : Colors.white)
                  : Colors.white.withOpacity(0.3),
            ),
            if (label != null && label.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: isHome ? 16 : 13,
                  fontWeight: isHome ? FontWeight.bold : FontWeight.w600,
                  color: enabled
                      ? (isHome ? colors['primary'] : Colors.white)
                      : Colors.white.withOpacity(0.3),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
