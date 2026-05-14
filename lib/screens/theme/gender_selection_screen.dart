import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/sensory_feedback_service.dart';
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

  Widget _buildGreetingHeader() {
    switch (widget.language) {
      case 'si-LK':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 10, top: 4),
              child: Text('👋', style: TextStyle(fontSize: 38)),
            ),
            Flexible(
              child: Text(
                'ඔබ කවුද?',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      case 'ta-IN':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 10, top: 4),
              child: Text('👋', style: TextStyle(fontSize: 38)),
            ),
            Flexible(
              child: Text(
                'நீங்கள் யார்?',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      case 'en-GB':
      default:
        return const Text(
          '👋 Who Are You?',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        );
    }
  }

  Widget _buildSubtitle() {
    final style = const TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.w500,
      height: 1.35,
    );
    switch (widget.language) {
      case 'si-LK':
        return Text(
          'ඔබට මනාප වන වර්ණයක් තෝරන්න!',
          style: style,
          textAlign: TextAlign.center,
        );
      case 'ta-IN':
        return Text(
          'உங்கள் விருப்பமான வண்ணத்தைத் தேர்ந்தெடுக்கவும்!',
          style: style,
          textAlign: TextAlign.center,
        );
      case 'en-GB':
      default:
        return Text(
          'Choose your favourite colour!',
          style: style,
          textAlign: TextAlign.center,
        );
    }
  }

  String _getGirlText() {
    switch (widget.language) {
      case 'si-LK':
        return 'ගැහැනු ළමයා';
      case 'ta-IN':
        return 'பெண் குழந்தை';
      case 'en-GB':
        return 'Girl';
      default:
        return 'Girl';
    }
  }

  String _getBoyText() {
    switch (widget.language) {
      case 'si-LK':
        return 'පිරිමි ළමයා';
      case 'ta-IN':
        return 'ஆண் குழந்தை';
      case 'en-GB':
        return 'Boy';
      default:
        return 'Boy';
    }
  }

  void _selectGender(bool isGirl) async {
    unawaited(SensoryFeedbackService.triggerMediumVibrationIfEnabled());
    final gender = isGirl ? 'girl' : 'boy';
    final prefs = await SharedPreferences.getInstance();
    await StorageService.saveUserData(
      name: prefs.getString('user_name') ?? '',
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
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _animation,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
                      child: _buildGreetingHeader(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ScaleTransition(
                    scale: _animation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildSubtitle(),
                    ),
                  ),
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildGenderCard(
                        emoji: '👧',
                        title: _getGirlText(),
                        subtitle: '(Pink Theme)',
                        isGirl: true,
                      ),
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
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.close,
                    color: Colors.white.withOpacity(0.95),
                    size: 26,
                  ),
                  tooltip: widget.language == 'si-LK'
                      ? 'වසන්න'
                      : widget.language == 'ta-IN'
                          ? 'மூடு'
                          : 'Close',
                  onPressed: () {
                    unawaited(
                        SensoryFeedbackService.triggerMediumVibrationIfEnabled());
                    Navigator.of(context).pop();
                  },
                ),
              ),
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
                  height: 1.25,
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
