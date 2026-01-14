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

class _CameraExpressionScreenState extends State<CameraExpressionScreen> {
  CameraController? _controller;
  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _isLoading = true;
  bool _isAnalyzing = false;
  String? _errorText;
  String? _resultLabel;
  double? _resultScore;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _interpreter?.close();
    super.dispose();
  }

  Future<void> _initialize() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _errorText = _getText('No camera available');
          _isLoading = false;
        });
        return;
      }
      _controller = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _controller!.initialize();
      _interpreter =
          await Interpreter.fromAsset('assets/models/emotion_model.tflite');
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

  Future<void> _analyze() async {
    if (_controller == null || _interpreter == null || _isAnalyzing) {
      return;
    }
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

      final output =
          List.generate(1, (_) => List.filled(_labels.length, 0.0));
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
        _resultLabel = _labels.isNotEmpty
            ? _labels[bestIndex]
            : _getText('Unknown');
        _resultScore = bestScore;
      });
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

  String _getText(String fallback) {
    switch (widget.language) {
      case 'si-LK':
        if (fallback == 'No camera available') return 'කැමරාවක් නැහැ';
        if (fallback == 'Failed to start camera') return 'කැමරාව ආරම්භ වෙන්නේ නැහැ';
        if (fallback == 'Failed to analyze image') return 'විශ්ලේෂණය අසාර්ථකයි';
        if (fallback == 'Unknown') return 'නොදන්නා';
        return fallback;
      case 'ta-IN':
        if (fallback == 'No camera available') return 'கேமரா இல்லை';
        if (fallback == 'Failed to start camera') return 'கேமரா துவங்கவில்லை';
        if (fallback == 'Failed to analyze image') return 'ஆய்வு தோல்வி';
        if (fallback == 'Unknown') return 'தெரியாதது';
        return fallback;
      default:
        return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.getThemeColors(widget.isGirl);

    return Theme(
      data: AppTheme.getThemeData(widget.isGirl),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.language == 'si-LK'
                ? 'චායාරූපයෙන් හැඟීම්'
                : widget.language == 'ta-IN'
                    ? 'புகைப்பட உணர்வு'
                    : 'Emotion Camera',
          ),
        ),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colors['background']!,
                colors['accent']!.withOpacity(0.1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorText != null
                  ? Center(
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
                    )
                  : Column(
                      children: [
                        if (_controller != null)
                          AspectRatio(
                            aspectRatio: _controller!.value.aspectRatio,
                            child: CameraPreview(_controller!),
                          ),
                        const SizedBox(height: 16),
                        if (_resultLabel != null)
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: colors['primary']!.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  _resultLabel!,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: colors['textColor'],
                                  ),
                                ),
                                if (_resultScore != null)
                                  Text(
                                    'Confidence: ${(100 * _resultScore!).toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: colors['textColor']!
                                          .withOpacity(0.7),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _isAnalyzing ? null : _analyze,
                              icon: const Icon(Icons.camera_alt),
                              label: Text(
                                _isAnalyzing
                                    ? _getText('Analyzing...')
                                    : _getText('Capture & Analyze'),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                backgroundColor: colors['primary'],
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
