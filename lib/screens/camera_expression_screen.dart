import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import 'theme/app_theme.dart';

class CameraExpressionScreen extends StatefulWidget {
  final String language;
  final bool isGirl;

  const CameraExpressionScreen({
    super.key,
    required this.language,
    required this.isGirl,
  });

  @override
  State<CameraExpressionScreen> createState() => _CameraExpressionScreenState();
}

class _CameraExpressionScreenState extends State<CameraExpressionScreen>
    with TickerProviderStateMixin {
  CameraController? _controller;
  Interpreter? _interpreter;
  List<String> _labels = [];
  List<CameraDescription> _cameras = [];
  int _currentCameraIndex = 0;
  bool _isLoading = true;
  bool _isAnalyzing = false;
  bool _isSwitchingCamera = false;
  String? _errorText;
  String? _resultLabel;
  double? _resultScore;

  late AnimationController _emojiController;
  late AnimationController _pulseController;
  late AnimationController _flashController;
  late Animation<double> _emojiScale;
  late Animation<double> _pulseAnimation;
  late Animation<double> _flashAnimation;

  final Map<String, String> _emotionEmojis = {
    'anger': '😠',
    'fear': '😨',
    'joy': '😊',
    'natural': '😐',
    'sadness': '😢',
    'surprise': '😮',
  };

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initialize();
  }

  void _initAnimations() {
    _emojiController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _emojiScale = CurvedAnimation(
      parent: _emojiController,
      curve: Curves.elasticOut,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _flashController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flashAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flashController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _interpreter?.close();
    _emojiController.dispose();
    _pulseController.dispose();
    _flashController.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() {
          _errorText = _getText('No camera available');
          _isLoading = false;
        });
        return;
      }
      await _initCamera(_currentCameraIndex);

      _interpreter =
          await Interpreter.fromAsset('assets/models/emotion_attention_model.tflite');
      _labels = (await rootBundle.loadString('assets/models/labels.txt'))
          .split('\n')
          .where((label) => label.trim().isNotEmpty)
          .toList();
      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorText = _getText('Failed to start camera');
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _initCamera(int cameraIndex) async {
    if (_controller != null) {
      await _controller!.dispose();
    }
    _controller = CameraController(
      _cameras[cameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    await _controller!.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2 || _isSwitchingCamera) return;

    setState(() => _isSwitchingCamera = true);

    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras.length;
    await _initCamera(_currentCameraIndex);

    setState(() => _isSwitchingCamera = false);
  }

  Future<void> _analyze() async {
    if (_controller == null || _interpreter == null || _isAnalyzing || !_controller!.value.isInitialized) {
      return;
    }

    _flashController.forward(from: 0.0);

    setState(() {
      _isAnalyzing = true;
      _resultLabel = null;
      _resultScore = null;
    });

    try {
      final file = await _controller!.takePicture();
      final bytes = await File(file.path).readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded == null) {
        throw Exception('Failed to decode image');
      }
      final resized = img.copyResize(decoded, width: 224, height: 224);

      final input = List.generate(
        1,
        (_) => List.generate(
          224,
          (y) => List.generate(
            224,
            (x) {
              final pixel = resized.getPixel(x, y);
              final r = pixel.r;
              final g = pixel.g;
              final b = pixel.b;
              return [
                (r / 127.5) - 1.0,
                (g / 127.5) - 1.0,
                (b / 127.5) - 1.0,
              ];
            },
          ),
        ),
      );

      final output = List.generate(1, (_) => List.filled(_labels.length, 0.0));
      _interpreter!.run(input, output);

      final scores = output.first;
      var bestIndex = 0;
      var bestScore = scores.first;
      for (var i = 1; i < scores.length; i++) {
        if (scores[i] > bestScore) {
          bestScore = scores[i];
          bestIndex = i;
        }
      }

      setState(() {
        _resultLabel =
            _labels.isNotEmpty ? _labels[bestIndex] : _getText('Unknown');
        _resultScore = bestScore;
      });

      _emojiController.forward(from: 0.0);
    } catch (e) {
      setState(() {
        _errorText = _getText('Failed to analyze image');
      });
    } finally {
      if (mounted) {
        setState(() => _isAnalyzing = false);
      }
    }
  }

  String _getEmoji(String? emotion) {
    if (emotion == null) return '🤔';
    return _emotionEmojis[emotion.toLowerCase()] ?? '😐';
  }

  String _getText(String fallback) {
    switch (widget.language) {
      case 'si-LK':
        if (fallback == 'No camera available') return 'කැමරාවක් නැහැ';
        if (fallback == 'Failed to start camera') return 'කැමරාව ආරම්භ වෙන්නේ නැහැ';
        if (fallback == 'Failed to analyze image') return 'විශ්ලේෂණය අසාර්ථකයි';
        if (fallback == 'Unknown') return 'නොදන්නා';
        if (fallback == 'Analyzing...') return 'විශ්ලේෂණය කරමින්...';
        if (fallback == 'Capture & Analyze') return 'ග්‍රහණය කර විශ්ලේෂණය කරන්න';
        if (fallback == 'Switch Camera') return 'කැමරාව මාරු කරන්න';
        return fallback;
      case 'ta-IN':
        if (fallback == 'No camera available') return 'கேமரா இல்லை';
        if (fallback == 'Failed to start camera') return 'கேமரா துவங்கவில்லை';
        if (fallback == 'Failed to analyze image') return 'ஆய்வு தோல்வி';
        if (fallback == 'Unknown') return 'தெரியாதது';
        if (fallback == 'Analyzing...') return 'ஆய்வு செய்கிறது...';
        if (fallback == 'Capture & Analyze') return 'படம் எடுத்து பகுப்பாய்வு செய்';
        if (fallback == 'Switch Camera') return 'கேமராவை மாற்று';
        return fallback;
      default:
        return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.getThemeColors(widget.isGirl);
    final size = MediaQuery.of(context).size;

    return Theme(
      data: AppTheme.getThemeData(widget.isGirl),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            widget.language == 'si-LK'
                ? 'චායාරූපයෙන් හැඟීම්'
                : widget.language == 'ta-IN'
                    ? 'புகைப்பட உணர்வு'
                    : 'Emotion Camera',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 3.0,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            // Camera Preview
            if (_isLoading)
              Container(
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
                child: const Center(child: CircularProgressIndicator()),
              )
            else if (_errorText != null)
              Container(
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
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      _errorText!,
                      style: TextStyle(
                        fontSize: 16,
                        color: colors['textColor'],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            else if (_controller != null && _controller!.value.isInitialized)
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller!.value.previewSize!.height,
                    height: _controller!.value.previewSize!.width,
                    child: CameraPreview(_controller!),
                  ),
                ),
              ),

            // Flash overlay
            if (!_isLoading && _errorText == null)
              AnimatedBuilder(
                animation: _flashAnimation,
                builder: (context, child) {
                  return Container(
                    color: Colors.white.withOpacity(_flashAnimation.value * 0.7),
                  );
                },
              ),

            // Gradient overlay
            if (!_isLoading && _errorText == null)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                    stops: const [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
              ),

            // Emotion Result Display
            if (_resultLabel != null && !_isLoading && _errorText == null)
              Positioned(
                top: 120,
                left: 0,
                right: 0,
                child: Center(
                  child: ScaleTransition(
                    scale: _emojiScale,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: colors['primary']!.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _getEmoji(_resultLabel),
                            style: const TextStyle(fontSize: 64),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _resultLabel!.toUpperCase(),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: colors['primary'],
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (_resultScore != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colors['accent']!.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${(100 * _resultScore!).toStringAsFixed(1)}% confident',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: colors['textColor']!.withOpacity(0.8),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // Bottom Controls
            if (!_isLoading && _errorText == null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Switch Camera Button
                        if (_cameras.length > 1)
                          _ControlButton(
                            icon: Icons.flip_camera_ios,
                            onPressed: _isSwitchingCamera ? null : _switchCamera,
                            colors: colors,
                            size: 60,
                          ),

                        // Capture Button
                        ScaleTransition(
                          scale: _isAnalyzing ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
                          child: GestureDetector(
                            onTap: _isAnalyzing ? null : _analyze,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: colors['primary']!.withOpacity(0.5),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      colors['primary']!,
                                      colors['accent']!,
                                    ],
                                  ),
                                ),
                                child: _isAnalyzing
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 36,
                                      ),
                              ),
                            ),
                          ),
                        ),

                        // Placeholder for symmetry
                        if (_cameras.length > 1)
                          const SizedBox(width: 60)
                        else
                          Container(),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Map<String, Color> colors;
  final double size;

  const _ControlButton({
    required this.icon,
    required this.onPressed,
    required this.colors,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.2),
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.white,
          size: size * 0.4,
        ),
      ),
    );
  }
}
