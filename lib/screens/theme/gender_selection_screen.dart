import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/storage_service.dart';
import 'app_theme.dart';

class GenderSelectionScreen extends StatefulWidget {
  final Function(bool) onGenderSelected;
  final String language;

  const GenderSelectionScreen({
    Key? key,
    required this.onGenderSelected,
    this.language = 'si-LK',
  }) : super(key: key);

  @override
  State<GenderSelectionScreen> createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getGreetingText() {
    switch (widget.language) {
      case 'si-LK':
        return '👋 ඔබ කවුද?';
      case 'ta-IN':
        return '👋 நீங்கள் யார்?';
      case 'en-US':
        return '👋 Who Are You?';
      default:
        return '👋 Who Are You?';
    }
  }

  String _getSubtitleText() {
    switch (widget.language) {
      case 'si-LK':
        return 'ඔබේ සිතුමම මතකට ගිය වර්ණ තෝරා ගන්න!';
      case 'ta-IN':
        return 'உங்கள் விருப்பமான வண்ணத் தேர்வு செய்யுங்கள்!';
      case 'en-US':
        return 'Choose Your Favorite Color!';
      default:
        return 'Choose Your Favorite Color!';
    }
  }

  String _getGirlText() {
    switch (widget.language) {
      case 'si-LK':
        return 'ගැහැනු\nළමයා';
      case 'ta-IN':
        return 'பெண்\nவள்ளி';
      case 'en-US':
        return 'Girl';
      default:
        return 'Girl';
    }
  }

  String _getBoyText() {
    switch (widget.language) {
      case 'si-LK':
        return 'පිරිමි\nළමයා';
      case 'ta-IN':
        return 'ஆண்\nவள்ளி';
      case 'en-US':
        return 'Boy';
      default:
        return 'Boy';
    }
  }

  void _selectGender(bool isGirl) async {
    final gender = isGirl ? 'girl' : 'boy';
    await StorageService.saveUserData(
      name:
          (await SharedPreferences.getInstance()).getString('user_name') ?? '',
      phone:
          (await SharedPreferences.getInstance()).getString('user_phone') ?? '',
      isPremium:
          (await SharedPreferences.getInstance()).getBool('is_premium') ??
              false,
      gender: gender,
    );
    widget.onGenderSelected(isGirl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purple.shade200,
              Colors.blue.shade200,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _animation,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    _getGreetingText(),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ScaleTransition(
                scale: _animation,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    _getSubtitleText(),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // ගිරු දරුවු තෝරන බටන්
                  _buildGenderCard(
                    emoji: '👧',
                    title: _getGirlText(),
                    subtitle: '(Pink Theme)',
                    isGirl: true,
                  ),
                  // පිරිමු දරුවු තෝරන බටන්
                  _buildGenderCard(
                    emoji: '👦',
                    title: _getBoyText(),
                    subtitle: '(Blue Theme)',
                    isGirl: false,
                  ),
                ],
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderCard({
    required String emoji,
    required String title,
    required String subtitle,
    required bool isGirl,
  }) {
    final colors = AppTheme.getThemeColors(isGirl);
    return ScaleTransition(
      scale: _animation,
      child: GestureDetector(
        onTap: () => _selectGender(isGirl),
        child: ScaleAnimationButton(
          onTap: () => _selectGender(isGirl),
          child: Container(
            width: 140,
            height: 200,
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
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 60),
                ),
                const SizedBox(height: 15),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScaleAnimationButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const ScaleAnimationButton({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  @override
  State<ScaleAnimationButton> createState() => _ScaleAnimationButtonState();
}

class _ScaleAnimationButtonState extends State<ScaleAnimationButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
