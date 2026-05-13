import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/sensory_feedback_service.dart';
import 'app_theme.dart';
import '../../widgets/emoji_text.dart';

class AnimatedCategoryCard extends StatefulWidget {
  final String categoryName;
  final String emoji;
  final String description;
  final VoidCallback onTap;
  final bool isGirl;
  final int index;

  const AnimatedCategoryCard({
    Key? key,
    required this.categoryName,
    required this.emoji,
    required this.description,
    required this.onTap,
    required this.isGirl,
    required this.index,
  }) : super(key: key);

  @override
  State<AnimatedCategoryCard> createState() => _AnimatedCategoryCardState();
}

class _AnimatedCategoryCardState extends State<AnimatedCategoryCard>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late final String _memoizedEmoji;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Memoize emoji to prevent re-rendering issues
    _memoizedEmoji = widget.emoji;

    // Setup pop animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    // Start animation with slight delay based on index for staggered effect
    Future.delayed(
      Duration(milliseconds: widget.index * 50),
      () {
        if (mounted) {
          print(
              '🎯 Card "${widget.categoryName}" animating at index ${widget.index}');
          _controller.forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final colors = AppTheme.getThemeColors(widget.isGirl);

    return RepaintBoundary(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTap: () {
            unawaited(SensoryFeedbackService.triggerLightVibrationIfEnabled());
            widget.onTap();
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors['gradient1']!,
                  colors['gradient2']!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: colors['primary']!.withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  top: -20,
                  child: RepaintBoundary(
                    child: Opacity(
                      opacity: 0.1,
                      child: EmojiText(
                        _memoizedEmoji,
                        fontSize: 80,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RepaintBoundary(
                        child: EmojiText(
                          _memoizedEmoji,
                          fontSize: 50,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.categoryName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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

class CategoryGridView extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  final Function(String) onCategorySelected;
  final bool isGirl;

  const CategoryGridView({
    Key? key,
    required this.categories,
    required this.onCategorySelected,
    required this.isGirl,
  }) : super(key: key);

  @override
  State<CategoryGridView> createState() => _CategoryGridViewState();
}

class _CategoryGridViewState extends State<CategoryGridView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      cacheExtent: 500,
      addAutomaticKeepAlives: true,
      addRepaintBoundaries: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: widget.categories.length,
      itemBuilder: (context, index) {
        final category = widget.categories[index];
        return AnimatedCategoryCard(
          key: ValueKey('${category['name']}_$index'),
          categoryName: category['name'],
          emoji: category['emoji'],
          description: category['description'] ?? 'සිටින්න!',
          onTap: () => widget.onCategorySelected(category['name']),
          isGirl: widget.isGirl,
          index: index,
        );
      },
    );
  }
}
