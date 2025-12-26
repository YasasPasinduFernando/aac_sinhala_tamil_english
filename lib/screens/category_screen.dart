import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  final String category;
  final List<Map<String, dynamic>> items;
  final List<Map<String, dynamic>>? actions;
  final Color color;
  final String language;
  final Function(String) onWordSelected;
  final Function(String) onSpeak;

  const CategoryScreen({
    Key? key,
    required this.category,
    required this.items,
    this.actions,
    required this.color,
    required this.language,
    required this.onWordSelected,
    required this.onSpeak,
  }) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final Map<int, bool> _pressedActions = {};
  final Map<int, bool> _pressedItems = {};

  String _getText(Map<String, dynamic> item) {
    switch (widget.language) {
      case 'si-LK':
        return item['si'] ?? '';
      case 'ta-IN':
        return item['ta'] ?? '';
      case 'en-US':
        return item['en'] ?? '';
      default:
        return item['si'] ?? '';
    }
  }

  String _actionsLabel() {
    switch (widget.language) {
      case 'si-LK':
        return 'කරසරු';
      case 'ta-IN':
        return 'செயல்கள்';
      default:
        return 'Actions';
    }
  }

  Widget _buildIconOrEmoji(
      Map<String, dynamic> item, double size, Color color) {
    final icon = item['icon'] as IconData?;
    final emoji = item['emoji'] as String?;
    if (icon != null) return Icon(icon, size: size, color: color);
    if (emoji != null && emoji.isNotEmpty)
      return Text(emoji, style: TextStyle(fontSize: size));
    return const SizedBox.shrink();
  }

  Color _getItemColor(int index) {
    final colors = [
      const Color(0xFF00BCD4), // Cyan
      const Color(0xFFFF6B6B), // Red
      const Color(0xFF4CAF50), // Green
      const Color(0xFFFFC107), // Amber
      const Color(0xFF9C27B0), // Purple
      const Color(0xFFE91E63), // Pink
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [widget.color, widget.color.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(25)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 28),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.zero,
                ),
                Text(
                  widget.category,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // ITEMS SECTION (upper 2/3)
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Text(
                    'පිළිවෙල',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF424242),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: widget.items.length,
                    itemBuilder: (context, index) {
                      final item = widget.items[index];
                      final text = _getText(item);
                      final pressed = _pressedItems[index] == true;
                      final itemColor = _getItemColor(index);

                      return GestureDetector(
                        onTapDown: (_) =>
                            setState(() => _pressedItems[index] = true),
                        onTapUp: (_) {
                          setState(() => _pressedItems[index] = false);
                          widget.onWordSelected(text);
                          widget.onSpeak(text);
                          Navigator.pop(context);
                        },
                        onTapCancel: () =>
                            setState(() => _pressedItems[index] = false),
                        child: AnimatedScale(
                          scale: pressed ? 0.90 : 1.0,
                          duration: const Duration(milliseconds: 100),
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            shadowColor: itemColor.withOpacity(0.4),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    itemColor,
                                    itemColor.withOpacity(0.7)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildIconOrEmoji(item, 48, Colors.white),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(
                                      text,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
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
              ],
            ),
          ),
          // DIVIDER
          Container(
            height: 2,
            color: widget.color.withOpacity(0.3),
            margin: const EdgeInsets.symmetric(vertical: 8),
          ),
          // ACTIONS SECTION (lower 1/3)
          if (widget.actions != null && widget.actions!.isNotEmpty)
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                    child: Text(
                      _actionsLabel(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: widget.color,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        final act = widget.actions![index];
                        final text = _getText(act);
                        final pressed = _pressedActions[index] == true;
                        final actionColor =
                            _getItemColor(index + widget.items.length);

                        return GestureDetector(
                          onTapDown: (_) =>
                              setState(() => _pressedActions[index] = true),
                          onTapUp: (_) {
                            setState(() => _pressedActions[index] = false);
                            widget.onWordSelected(text);
                            widget.onSpeak(text);
                            Navigator.pop(context);
                          },
                          onTapCancel: () =>
                              setState(() => _pressedActions[index] = false),
                          child: AnimatedScale(
                            scale: pressed ? 0.88 : 1.0,
                            duration: const Duration(milliseconds: 100),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              shadowColor: actionColor.withOpacity(0.4),
                              child: Container(
                                width: 110,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      actionColor,
                                      actionColor.withOpacity(0.7)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildIconOrEmoji(act, 40, Colors.white),
                                    const SizedBox(height: 6),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6),
                                      child: Text(
                                        text,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemCount: widget.actions!.length,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
