import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/app_theme.dart';
import 'theme/custom_card_widget.dart';

class CategoryScreen extends StatefulWidget {
  final List<Map<String, dynamic>> allCategories;
  final int initialCategoryIndex;
  final String language;
  final Function(String, {String emoji}) onWordSelected;
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
  bool _isProcessingTap = false;

  // Prevent multiple rapid taps from being processed
  Future<void> _processWordTap(String text, {String emoji = ''}) async {
    if (_isProcessingTap) return;

    _isProcessingTap = true;
    try {
      widget.onWordSelected(text, emoji: emoji);
      widget.onSpeak(text);
    } finally {
      // Reset after a short delay
      await Future.delayed(const Duration(milliseconds: 300));
      _isProcessingTap = false;
    }
  }

  @override
  void initState() {
    super.initState();
    currentCategoryIndex = widget.initialCategoryIndex;
    // Use a very large initial page to enable infinite scrolling
    final initialPage = 1000000 + widget.initialCategoryIndex;
    _pageController = PageController(initialPage: initialPage);
    _loadUserName();

    // Hide system navigation bar and make full screen
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.top],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    // Don't restore - let HomeScreen control the system UI
    // Just hide the nav again when returning
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.top],
    );
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
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors['gradient1']!, colors['gradient2']!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cute avatar
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colors['primary']!.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.isGirl ? '👧' : '👦',
                    style: const TextStyle(fontSize: 60),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Question
              Text(
                widget.language == 'si-LK'
                    ? '👋 ඔයාගේ නම මොකද්ද?'
                    : widget.language == 'ta-IN'
                        ? '👋 உங்கள் பெயர் என்ன?'
                        : '👋 What is your name?',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Input field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: TextField(
                  controller: nameController,
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
                            : 'Type your name...',
                    hintStyle: TextStyle(
                      color: colors['textColor']!.withOpacity(0.4),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // OK Button
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
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '✅',
                        style: TextStyle(
                          fontSize: 24,
                          color: colors['primary'],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.language == 'si-LK'
                            ? 'හරි!'
                            : widget.language == 'ta-IN'
                                ? 'சரி!'
                                : 'OK!',
                        style: TextStyle(
                          fontSize: 20,
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

  void _navigateToCategory(int direction) {
    // direction: -1 for previous, +1 for next
    if (_pageController.hasClients) {
      final currentPage = _pageController.page?.round() ?? 0;
      _pageController.animateToPage(
        currentPage + direction,
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
                            _processWordTap(actionText);
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
                                  action['emoji'] ?? '✓',
                                  style: const TextStyle(
                                    fontSize: 20,
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
                final emoji = item['emoji'] as String? ?? '';

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
                      _processWordTap(text, emoji: emoji);
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Speaker Button (Left)
              GestureDetector(
                onTap: _speakGreeting,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.4),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.volume_up,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
              // Title (Center)
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      hasAskedName && userName.isNotEmpty
                          ? 'Hello $userName'
                          : currentCategory['name'],
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              // Settings Button (Right)
              GestureDetector(
                onTap: () => _showNameDialog(),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.settings,
                    color: Colors.black,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: colors['background'],
          elevation: 0,
          toolbarHeight: 100,
          automaticallyImplyLeading: false,
        ),
        body: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              // Calculate actual category index using modulo for infinite loop
              // The index from onPageChanged is relative to the starting position,
              // so we need to ensure it properly maps to our category list
              int calculatedIndex = index % widget.allCategories.length;
              // Handle negative modulo results
              if (calculatedIndex < 0) {
                calculatedIndex += widget.allCategories.length;
              }
              currentCategoryIndex = calculatedIndex;
            });
          },
          itemBuilder: (context, index) {
            // Get the actual category using modulo for infinite scrolling
            int categoryIndex = index % widget.allCategories.length;
            // Handle negative modulo results
            if (categoryIndex < 0) {
              categoryIndex += widget.allCategories.length;
            }
            return _buildCategoryPage(widget.allCategories[categoryIndex]);
          },
        ),
        bottomNavigationBar: Container(
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.pink.shade200,
                Colors.pink.shade300,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Previous Category Button (Blue Circle)
                GestureDetector(
                  onTap: () => _navigateToCategory(-1),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                // Home Button (Large Red Circle)
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.6),
                          blurRadius: 20,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
                // Next Category Button (Blue Circle)
                GestureDetector(
                  onTap: () => _navigateToCategory(1),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ],
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
          horizontal: isHome ? 24 : 14,
          vertical: isHome ? 12 : 10,
        ),
        decoration: BoxDecoration(
          gradient: enabled
              ? (isHome
                  ? LinearGradient(
                      colors: [Colors.red.shade400, Colors.red.shade500],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.3),
                        Colors.white.withOpacity(0.2),
                      ],
                    ))
              : null,
          color: enabled ? null : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(isHome ? 30 : 18),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: isHome
                        ? Colors.red.withOpacity(0.5)
                        : Colors.black.withOpacity(0.15),
                    blurRadius: isHome ? 15 : 8,
                    spreadRadius: isHome ? 2 : 0,
                    offset: Offset(0, isHome ? 4 : 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isHome ? 32 : size,
              color: enabled
                  ? (isHome ? Colors.white : Colors.white)
                  : Colors.white.withOpacity(0.3),
            ),
            if (label != null && label.isNotEmpty && isHome) ...[
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
            if (label != null && label.isNotEmpty && !isHome) ...[
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: enabled ? Colors.white : Colors.white.withOpacity(0.3),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
