// ==========================================
// FILE: lib/screens/splash_screen.dart
// ==========================================
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../services/storage_service.dart';
import 'registration_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _pulseController;
  late AnimationController _emojiController;
  late AnimationController _shimmerController;

  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _emojiScale;
  late Animation<Offset> _emojiSlide;
  late Animation<double> _shimmerAnimation;

  final List<String> _emojis = ['😊', '🎉', '🌟', '❤️', '👋'];
  int _currentEmojiIndex = 0;
  Timer? _emojiTimer;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startEmojiRotation();
    _checkRegistration();

    // Hide system navigation bar
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.top],
    );
  }

  void _setupAnimations() {
    // Logo bounce animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.elasticOut,
      ),
    );

    _logoRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeInOut,
      ),
    );

    // Pulse animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Emoji animations
    _emojiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _emojiScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _emojiController,
        curve: Curves.elasticOut,
      ),
    );

    _emojiSlide = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _emojiController,
        curve: Curves.easeOut,
      ),
    );

    // Shimmer animation for text
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _shimmerController,
        curve: Curves.linear,
      ),
    );

    // Start animations
    _logoController.forward();
    _emojiController.forward();
  }

  void _startEmojiRotation() {
    _emojiTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (mounted) {
        setState(() {
          _currentEmojiIndex = (_currentEmojiIndex + 1) % _emojis.length;
        });
        _emojiController.forward(from: 0);
      }
    });
  }

  Future<void> _checkRegistration() async {
    await Future.delayed(const Duration(seconds: 3));
    final isRegistered = await StorageService.isRegistered();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              isRegistered ? const HomeScreen() : const RegistrationScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _pulseController.dispose();
    _emojiController.dispose();
    _shimmerController.dispose();
    _emojiTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF87CEEB), // Sky blue
              const Color(0xFFB8E0F6), // Light blue
              const Color(0xFFFFB6C1), // Pink
              const Color(0xFFFFC0CB), // Light pink
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Animated background circles
              _buildBackgroundCircles(),

              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated logo with emojis
                    _buildAnimatedLogo(),

                    const SizedBox(height: 40),

                    // App name with shimmer effect
                    _buildShimmerText(),

                    const SizedBox(height: 12),

                    // Subtitle with fade-in
                    _buildSubtitle(),

                    const SizedBox(height: 60),

                    // Loading indicator with pulse
                    _buildLoadingIndicator(),

                    const SizedBox(height: 20),

                    // Fun loading text
                    _buildLoadingText(),
                  ],
                ),
              ),

              // Floating emojis
              _buildFloatingEmojis(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundCircles() {
    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -100,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: -150,
          left: -150,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.2 - _pulseAnimation.value + 1,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScale.value,
          child: Transform.rotate(
            angle: _logoRotation.value * 0.1,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.3),
                    blurRadius: 40,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Microphone icon
                  const Icon(
                    Icons.record_voice_over_rounded,
                    size: 90,
                    color: Color(0xFF4A90E2),
                  ),
                  // Rotating emoji on top
                  Positioned(
                    top: 10,
                    right: 10,
                    child: AnimatedBuilder(
                      animation: _emojiController,
                      builder: (context, child) {
                        return SlideTransition(
                          position: _emojiSlide,
                          child: ScaleTransition(
                            scale: _emojiScale,
                            child: Text(
                              _emojis[_currentEmojiIndex],
                              style: const TextStyle(fontSize: 40),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerText() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Colors.white,
                Color(0xFFFFD700), // Gold
                Colors.white,
                Color(0xFFFFD700),
                Colors.white,
              ],
              stops: [
                0.0,
                _shimmerAnimation.value / 4,
                _shimmerAnimation.value / 2,
                _shimmerAnimation.value * 0.75,
                1.0,
              ],
            ).createShader(bounds);
          },
          child: const Text(
            'AAC කථා කරමු',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(3, 3),
                  blurRadius: 8,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  Widget _buildSubtitle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
      ),
      child: const Text(
        'සිංහල • தமிழ் • English',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.3),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: CircularProgressIndicator(
                strokeWidth: 5,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                backgroundColor: Colors.white.withOpacity(0.2),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingText() {
    return AnimatedBuilder(
      animation: _emojiController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _emojiScale,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _emojis[_currentEmojiIndex],
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Loading... පටවමින්...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingEmojis() {
    return Stack(
      children: [
        _buildFloatingEmoji('🎈', 0.15, 0.2, 3000),
        _buildFloatingEmoji('⭐', 0.8, 0.15, 3500),
        _buildFloatingEmoji('🌈', 0.2, 0.7, 4000),
        _buildFloatingEmoji('💝', 0.85, 0.75, 3200),
        _buildFloatingEmoji('🎉', 0.5, 0.9, 3800),
        _buildFloatingEmoji('✨', 0.1, 0.4, 3300),
        _buildFloatingEmoji('🌸', 0.9, 0.45, 3600),
      ],
    );
  }

  Widget _buildFloatingEmoji(
      String emoji, double left, double top, int duration) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: duration),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Positioned(
          left: MediaQuery.of(context).size.width * left,
          top: MediaQuery.of(context).size.height * top +
              (value * 20 * (left > 0.5 ? 1 : -1)),
          child: Opacity(
            opacity: 0.6 + (value * 0.4),
            child: Transform.scale(
              scale: 0.8 + (value * 0.4),
              child: Transform.rotate(
                angle: value * 0.5 * (left > 0.5 ? 1 : -1),
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 40),
                ),
              ),
            ),
          ),
        );
      },
      onEnd: () {
        // Loop the animation
        if (mounted) {
          setState(() {});
        }
      },
    );
  }
}
