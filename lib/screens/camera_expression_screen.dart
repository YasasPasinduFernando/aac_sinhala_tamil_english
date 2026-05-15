import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../services/emotion_support_audio_service.dart';
import '../services/sensory_feedback_service.dart';
import 'theme/app_theme.dart';

/// High-level state of a capture attempt.
enum _CaptureStatus { idle, noFace, faceNotClear, uncertain, reliable }

enum _EmotionModelSlotResult { ok, loadFailed, tensorFailed }

/// Which `.tflite` to load (saved in SharedPreferences).
enum _EmotionModelLoadMode { auto, primaryOnly, fallbackOnly }

/// Soft shadow for white text/icons over the live camera preview.
const List<Shadow> _kCameraOverlayShadows = [
  Shadow(offset: Offset(0, 1), blurRadius: 4, color: Color(0x99000000)),
  Shadow(offset: Offset(0, 0), blurRadius: 10, color: Color(0x55000000)),
];

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
  // ──────────────────────────────────────────────────────────────────────────
  // Inference / face-gate constants
  // ──────────────────────────────────────────────────────────────────────────

  /// Number of quick captures per shutter tap. Their softmax vectors are
  /// averaged to produce one stable decision.
  static const int _kBurstFrames = 5;

  /// Small delay between consecutive captures so the camera buffer refreshes.
  static const Duration _kBurstDelay = Duration(milliseconds: 120);

  /// Minimum softmax probability for the winning class. Below this the
  /// decision is treated as "Uncertain".
  ///
  /// TODO(thresholds): TEMPORARILY LOWERED from 0.60 → 0.40 for the debug /
  /// diagnostic phase. This makes more non-Happy classes pass the gate so we
  /// can see which probabilities the model actually emits for sad / angry /
  /// fear / tired faces. **Before final submission, tune this with real
  /// device test results (probably 0.50-0.65).**
  static const double _kMinConfidence = 0.40;

  /// Required margin between top-1 and top-2 softmax probabilities. Catches
  /// ambiguous cases like sad-vs-neutral.
  ///
  /// TODO(thresholds): TEMPORARILY LOWERED from 0.15 → 0.08 for the debug /
  /// diagnostic phase. Same tuning note as above.
  static const double _kMinTopMargin = 0.08;

  /// Minimum face bounding box short-side, expressed as a fraction of the
  /// shorter side of the full image. Below this the face is considered
  /// "Face not clear" (too far / too small).
  static const double _kMinFaceRatio = 0.18;

  /// Padding around the detected face bbox before cropping (fraction of bbox
  /// width / height on each side).
  static const double _kFaceCropPadding = 0.20;

  // ──────────────────────────────────────────────────────────────────────────
  // Camera + model + face detector
  // ──────────────────────────────────────────────────────────────────────────

  CameraController? _controller;
  Interpreter? _interpreter;
  late final FaceDetector _faceDetector;
  List<String> _labels = [];
  List<CameraDescription> _cameras = [];
  int _currentCameraIndex = 0;
  bool _isLoading = true;
  bool _isAnalyzing = false;
  bool _isSwitchingCamera = false;
  String? _errorText;

  // Result of the latest decision.
  _CaptureStatus _status = _CaptureStatus.idle;
  String? _resultLabel;
  double? _resultScore;

  // ──────────────────────────────────────────────────────────────────────────
  // Animations (kept identical to the previous UI)
  // ──────────────────────────────────────────────────────────────────────────

  late AnimationController _emojiController;
  late AnimationController _pulseController;
  late AnimationController _flashController;
  late Animation<double> _emojiScale;
  late Animation<double> _pulseAnimation;
  late Animation<double> _flashAnimation;

  // ──────────────────────────────────────────────────────────────────────────
  // Emotion-Responsive Sensory Feedback
  // ──────────────────────────────────────────────────────────────────────────
  // The support panel is only shown for *reliable* results that have a
  // non-null SensorySupportPlan. `Neutral` has no plan (see
  // SensoryFeedbackService.planFor) so it is automatically skipped.
  bool _supportPanelDismissed = false;
  bool _supportPlaying = false;
  // Slow breathing controller (~4 s per cycle). Lazy-initialized so it is
  // only created once and never plays unless the user taps "Play support".
  late final AnimationController _breathingController;

  // ──────────────────────────────────────────────────────────────────────────
  // AI debug / diagnostic panel
  //
  // ⚠️ DEBUG ONLY — must be hidden / removed before final release if you don't
  // want testers to see raw probabilities. The toggle defaults to OFF.
  //
  // The valid raw label order matches `assets/models/labels.txt` / model softmax:
  //   0 = Anger, 1 = Fear, 2 = Joy, 3 = Natural, 4 = Sadness, 5 = Surprise
  // The user-facing display mapping lives just below in `_displayMap`.
  // ──────────────────────────────────────────────────────────────────────────
  bool _showDebugProbs = false;
  List<double>? _lastMeanSoftmax;
  List<int>? _lastFrameStats; // [framesWithFace, framesUnclear, framesNoFace]

  /// Human-readable active TFLite model (set when interpreter loads).
  String _activeEmotionModelName = '';
  _EmotionModelLoadMode _modelLoadMode = _EmotionModelLoadMode.auto;
  bool _faceGateEnabled = true;
  bool _reloadModelBusy = false;

  // ──────────────────────────────────────────────────────────────────────────
  // RAW model labels  ──>  USER-FRIENDLY display labels
  //
  // Source of truth for the deployed model: model.pdf (Colab notebook
  // screenshots). Trained class order:
  //   0 - Anger
  //   1 - Fear
  //   2 - Joy
  //   3 - Natural
  //   4 - Sadness
  //   5 - Surprise
  // Architecture: primary = EfficientNetB0 fine-tuned; fallback = MobileNetV2.
  //
  // `assets/models/labels.txt` MUST stay in this exact raw order — it is the
  // contract with the model's softmax output. Anything user-facing should go
  // through `_displayFor(...)` so the raw label and the display label are
  // never confused.
  //
  // We DO NOT map "Surprise" to "Tired". Tired is reserved for future work
  // (a separate fatigue class added to a retrained model). Mapping Surprise
  // → Tired would silently mislabel every surprised face.
  // ──────────────────────────────────────────────────────────────────────────
  static const Map<String, String> _displayMap = {
    'anger': 'Angry',
    'fear': 'Fear',
    'joy': 'Happy',
    'natural': 'Neutral',
    'sadness': 'Sad',
    'surprise': 'Surprise',
  };

  static const String _kPrimaryModelAsset =
      'assets/models/emotion_efficientnetb0_finetuned.tflite';
  static const String _kFallbackModelAsset =
      'assets/models/emotion_mobilenetv2_fallback.tflite';
  static const String _kLabelsAsset = 'assets/models/labels.txt';
  static const List<int> _kExpectedInputShape = [1, 224, 224, 3];
  static const List<int> _kExpectedOutputShape = [1, 6];

  /// Emoji map keyed by RAW label (lower-cased), so lookups stay in sync
  /// with the model's softmax indexes.
  final Map<String, String> _emotionEmojis = {
    'anger': '😠',
    'fear': '😨',
    'joy': '😊',
    'natural': '😐',
    'sadness': '😢',
    'surprise': '😮',
  };

  /// Convert a raw model label (from labels.txt) to a user-friendly label.
  /// Returns the input unchanged if no mapping exists, so an unexpected
  /// label can never crash the screen.
  static String _displayFor(String? rawLabel) {
    if (rawLabel == null || rawLabel.isEmpty) return '';
    return _displayMap[rawLabel.toLowerCase()] ?? rawLabel;
  }

  @override
  void initState() {
    super.initState();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.fast,
        enableLandmarks: false,
        enableClassification: false,
        enableTracking: false,
        minFaceSize: 0.15,
      ),
    );
    _initAnimations();
    unawaited(_bootstrapCameraScreen());
  }

  Future<void> _bootstrapCameraScreen() async {
    final p = await SharedPreferences.getInstance();
    final idx = p.getInt('emotion_model_load_mode');
    if (idx != null &&
        idx >= 0 &&
        idx < _EmotionModelLoadMode.values.length) {
      _modelLoadMode = _EmotionModelLoadMode.values[idx];
    }
    _faceGateEnabled = p.getBool('emotion_face_gate_enabled') ?? true;
    if (!mounted) return;
    setState(() {});
    await _initialize();
  }

  Future<void> _persistModelLoadMode(_EmotionModelLoadMode mode) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt('emotion_model_load_mode', mode.index);
  }

  Future<void> _persistFaceGate(bool enabled) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('emotion_face_gate_enabled', enabled);
  }

  Future<void> _applyModelLoadMode(_EmotionModelLoadMode next) async {
    if (_reloadModelBusy || next == _modelLoadMode) return;
    setState(() => _reloadModelBusy = true);
    final prev = _modelLoadMode;
    _modelLoadMode = next;
    await _persistModelLoadMode(next);
    final ok = await _loadEmotionInterpreterOnly(isInitialStartup: false);
    if (!mounted) {
      return;
    }
    if (!ok) {
      _modelLoadMode = prev;
      await _persistModelLoadMode(prev);
      await _loadEmotionInterpreterOnly(isInitialStartup: false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_debugModelSwitchFailedMessage())),
      );
    }
    setState(() => _reloadModelBusy = false);
  }

  String _debugModelSwitchFailedMessage() {
    switch (widget.language) {
      case 'si-LK':
        return 'මොඩලය මාරු කිරීම අසාර්ථකයි. පෙර සැකසුම යළි යොදන ලදී.';
      case 'ta-IN':
        return 'மாதிரி மாற்றம் தோல்வி. முந்தைய அமைப்பு மீட்டமைக்கப்பட்டது.';
      default:
        return 'Could not switch model. Reverted to previous.';
    }
  }

  Future<void> _setFaceGateEnabled(bool value) async {
    setState(() => _faceGateEnabled = value);
    await _persistFaceGate(value);
  }

  /// Center-crop square then 224² — used when face gate is OFF.
  img.Image _wholeFrameSquare224(img.Image decoded) {
    final w = decoded.width;
    final h = decoded.height;
    final side = math.min(w, h);
    final x = ((w - side) / 2).floor();
    final y = ((h - side) / 2).floor();
    final cropped = img.copyCrop(decoded, x: x, y: y, width: side, height: side);
    return img.copyResize(cropped, width: 224, height: 224);
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

    // Slow, calm 4-second breathing/dim loop. Intentionally NOT auto-started.
    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
  }

  void _failInit(String localizedMessage) {
    if (!mounted) return;
    setState(() {
      _errorText = localizedMessage;
      _isLoading = false;
    });
  }

  bool _emotionModelTensorsValid(Tensor input, Tensor output) {
    bool shapeEq(List<int> a, List<int> b) =>
        a.length == b.length &&
        List.generate(a.length, (i) => a[i] == b[i]).every((ok) => ok);
    return shapeEq(input.shape, _kExpectedInputShape) &&
        shapeEq(output.shape, _kExpectedOutputShape) &&
        input.type == TensorType.float32 &&
        output.type == TensorType.float32;
  }

  /// Loads one `.tflite` from assets and validates I/O tensors. On success,
  /// assigns [_interpreter] and prints `[ModelLoad]` diagnostics.
  Future<_EmotionModelSlotResult> _tryLoadEmotionModelSlot({
    required String assetPath,
    required String slotLogName,
    required String activeEmotionModelDebugName,
  }) async {
    debugPrint('[ModelLoad] Trying ${slotLogName.toLowerCase()} model: $assetPath');
    Interpreter? interp;
    try {
      interp = await Interpreter.fromAsset(assetPath);
    } catch (e, st) {
      debugPrint('[ModelLoad] $slotLogName model failed: $e\n$st');
      return _EmotionModelSlotResult.loadFailed;
    }
    try {
      final inDetails = interp.getInputTensor(0);
      final outDetails = interp.getOutputTensor(0);
      debugPrint('[ModelLoad] $slotLogName input tensor shape/type: '
          '${inDetails.shape} / ${inDetails.type}');
      debugPrint('[ModelLoad] $slotLogName output tensor shape/type: '
          '${outDetails.shape} / ${outDetails.type}');
      if (!_emotionModelTensorsValid(inDetails, outDetails)) {
        debugPrint('[ModelLoad] $slotLogName model failed: tensor validation '
            '(expected input $_kExpectedInputShape float32, '
            'output $_kExpectedOutputShape float32)');
        interp.close();
        return _EmotionModelSlotResult.tensorFailed;
      }
    } catch (e, st) {
      debugPrint('[ModelLoad] $slotLogName model failed: $e\n$st');
      interp.close();
      return _EmotionModelSlotResult.tensorFailed;
    }
    _interpreter = interp;
    _activeEmotionModelName = activeEmotionModelDebugName;
    debugPrint('[ModelLoad] $slotLogName model loaded OK');
    debugPrint('[ModelLoad] Active model: $assetPath');
    debugPrint('[ModelLoad] Active emotion model: $activeEmotionModelDebugName');
    return _EmotionModelSlotResult.ok;
  }

  /// Loads TFLite interpreter according to [_modelLoadMode]. On failure during
  /// app startup, calls [_failInit]. During debug model switch, returns false.
  Future<bool> _loadEmotionInterpreterOnly({
    required bool isInitialStartup,
  }) async {
    _interpreter?.close();
    _interpreter = null;
    _activeEmotionModelName = '';

    _EmotionModelSlotResult primaryResult = _EmotionModelSlotResult.loadFailed;
    _EmotionModelSlotResult? fallbackResult;

    switch (_modelLoadMode) {
      case _EmotionModelLoadMode.primaryOnly:
        primaryResult = await _tryLoadEmotionModelSlot(
          assetPath: _kPrimaryModelAsset,
          slotLogName: 'Primary',
          activeEmotionModelDebugName: 'EfficientNetB0 Fine-tuned',
        );
        if (primaryResult == _EmotionModelSlotResult.ok) {
          return true;
        }
        if (isInitialStartup) {
          _failInit(
            primaryResult == _EmotionModelSlotResult.tensorFailed
                ? _getText('Emotion model shape is not supported')
                : _getText('Emotion model failed to load'),
          );
        }
        return false;

      case _EmotionModelLoadMode.fallbackOnly:
        fallbackResult = await _tryLoadEmotionModelSlot(
          assetPath: _kFallbackModelAsset,
          slotLogName: 'Fallback',
          activeEmotionModelDebugName: 'MobileNetV2 Fallback',
        );
        if (fallbackResult == _EmotionModelSlotResult.ok) {
          return true;
        }
        if (isInitialStartup) {
          _failInit(
            fallbackResult == _EmotionModelSlotResult.tensorFailed
                ? _getText('Emotion model shape is not supported')
                : _getText('Emotion model failed to load'),
          );
        }
        return false;

      case _EmotionModelLoadMode.auto:
        primaryResult = await _tryLoadEmotionModelSlot(
          assetPath: _kPrimaryModelAsset,
          slotLogName: 'Primary',
          activeEmotionModelDebugName: 'EfficientNetB0 Fine-tuned',
        );
        if (primaryResult == _EmotionModelSlotResult.ok) {
          return true;
        }
        fallbackResult = await _tryLoadEmotionModelSlot(
          assetPath: _kFallbackModelAsset,
          slotLogName: 'Fallback',
          activeEmotionModelDebugName: 'MobileNetV2 Fallback',
        );
        if (fallbackResult == _EmotionModelSlotResult.ok) {
          return true;
        }
        if (isInitialStartup) {
          if (primaryResult == _EmotionModelSlotResult.tensorFailed &&
              fallbackResult == _EmotionModelSlotResult.tensorFailed) {
            _failInit(_getText('Emotion model shape is not supported'));
          } else {
            _failInit(_getText('Emotion model failed to load'));
          }
        }
        return false;
    }
  }

  Future<void> _initialize() async {
    // 1) Camera discovery
    debugPrint('[InitDebug] Camera discovery started');
    try {
      _cameras = await availableCameras();
    } catch (e, st) {
      debugPrint('[InitDebug] Camera discovery failed: $e\n$st');
      _failInit(_getText('Camera discovery failed'));
      return;
    }
    if (_cameras.isEmpty) {
      debugPrint('[InitDebug] Camera discovery: no devices');
      _failInit(_getText('No camera available'));
      return;
    }
    debugPrint(
        '[InitDebug] Camera discovery OK (${_cameras.length} device(s))');

    // 2) Camera permission / initialization
    try {
      await _initCamera(_currentCameraIndex);
    } catch (e, st) {
      debugPrint('[InitDebug] Camera initialize failed: $e\n$st');
      try {
        await _controller?.dispose();
      } catch (_) {}
      _controller = null;
      _failInit(_getText('Camera permission or initialization failed'));
      return;
    }
    debugPrint('[InitDebug] Camera initialized OK');

    // 3–5) TFLite emotion model then labels + order check
    final modelOk =
        await _loadEmotionInterpreterOnly(isInitialStartup: true);
    if (!modelOk) {
      return;
    }

    // Labels (after a valid interpreter is chosen)
    debugPrint('[InitDebug] Loading labels: $_kLabelsAsset');
    try {
      final raw = await rootBundle.loadString(_kLabelsAsset);
      _labels = raw
          .split('\n')
          .where((label) => label.trim().isNotEmpty)
          .map((label) => label.trim())
          .toList();
    } catch (e, st) {
      debugPrint('[InitDebug] Labels load failed: $e\n$st');
      _interpreter?.close();
      _interpreter = null;
      _failInit(_getText('Emotion labels failed to load'));
      return;
    }
    debugPrint('[InitDebug] Labels loaded: $_labels');

    // Tensor contract already verified in _tryLoadEmotionModelSlot.
    // ── Label-order verification (text file only; do not change labels) ───
    debugPrint('[EmotionDebug] Loaded labels.txt -> $_labels');
    const expectedRaw = [
      'anger',
      'fear',
      'joy',
      'natural',
      'sadness',
      'surprise',
    ];
    final loadedLower = _labels.map((l) => l.toLowerCase()).toList();
    final orderOk = loadedLower.length == expectedRaw.length &&
        List.generate(expectedRaw.length, (i) => loadedLower[i] == expectedRaw[i])
            .every((ok) => ok);
    if (orderOk) {
      debugPrint('[EmotionDebug] ✅ labels.txt matches trained model order '
          '(Anger, Fear, Joy, Natural, Sadness, Surprise).');
      debugPrint('[EmotionDebug]    display mapping: $_displayMap');
    } else {
      debugPrint('[EmotionDebug] ⚠️ LABEL ORDER WARNING:');
      debugPrint('[EmotionDebug]   labels.txt order:  $_labels');
      debugPrint('[EmotionDebug]   expected (from model.pdf): $expectedRaw');
      debugPrint('[EmotionDebug]   The displayed names may not match what '
          'the model actually predicts.');
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    unawaited(EmotionSupportAudioService.stop());
    _controller?.dispose();
    _interpreter?.close();
    _faceDetector.close();
    _emojiController.dispose();
    _pulseController.dispose();
    _flashController.dispose();
    _breathingController.dispose();
    super.dispose();
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

  // ──────────────────────────────────────────────────────────────────────────
  // Single tap → 5 quick captures → face-gate → crop → infer → average → decide
  // ──────────────────────────────────────────────────────────────────────────
  Future<void> _analyze() async {
    if (_controller == null ||
        _interpreter == null ||
        _isAnalyzing ||
        !_controller!.value.isInitialized) {
      return;
    }

    _flashController.forward(from: 0.0);

    setState(() {
      _isAnalyzing = true;
      _status = _CaptureStatus.idle;
      _resultLabel = null;
      _resultScore = null;
      _supportPanelDismissed = false;
      _supportPlaying = false;
      _lastMeanSoftmax = null;
      _lastFrameStats = null;
    });
    _breathingController.stop();
    _breathingController.value = 0.0;
    debugPrint('[EmotionDebug] ──── New capture (burst=$_kBurstFrames) ────');

    final softmaxAccum = <List<double>>[];
    int framesWithFace = 0;
    int framesUnclear = 0;
    int framesNoFace = 0;

    try {
      for (var i = 0; i < _kBurstFrames; i++) {
        final XFile file = await _controller!.takePicture();

        if (!_faceGateEnabled) {
          final bytesWhole = await File(file.path).readAsBytes();
          final decodedWhole = img.decodeImage(bytesWhole);
          if (decodedWhole == null) {
            if (i < _kBurstFrames - 1) {
              await Future.delayed(_kBurstDelay);
            }
            continue;
          }
          final resizedWhole = _wholeFrameSquare224(decodedWhole);
          final inputWhole = _buildModelInput(resizedWhole);
          final outputWhole = List.generate(
              1, (_) => List<double>.filled(_labels.length, 0.0));
          _interpreter!.run(inputWhole, outputWhole);
          softmaxAccum.add(List<double>.from(outputWhole.first));
          framesWithFace++;
          debugPrint('[EmotionDebug] frame ${i + 1}/$_kBurstFrames: '
              'face_gate=OFF (whole-frame crop → 224²)');
          if (i < _kBurstFrames - 1) {
            await Future.delayed(_kBurstDelay);
          }
          continue;
        }

        // 1. Face detection on the raw JPEG.
        final inputImage = InputImage.fromFilePath(file.path);
        List<Face> faces;
        try {
          faces = await _faceDetector.processImage(inputImage);
        } catch (e, st) {
          debugPrint('Face detector failure: $e\n$st');
          faces = const [];
        }

        if (faces.isEmpty) {
          framesNoFace++;
          debugPrint('[EmotionDebug] frame ${i + 1}/$_kBurstFrames: no face');
          if (i < _kBurstFrames - 1) {
            await Future.delayed(_kBurstDelay);
          }
          continue;
        }

        // 2. Decode the captured image to inspect its real pixel size.
        final bytes = await File(file.path).readAsBytes();
        final decoded = img.decodeImage(bytes);
        if (decoded == null) {
          if (i < _kBurstFrames - 1) {
            await Future.delayed(_kBurstDelay);
          }
          continue;
        }

        // 3. Pick the largest face and validate its size.
        final face = _largestFace(faces);
        final imageShortSide =
            math.min(decoded.width, decoded.height).toDouble();
        final faceShortSide = math.min(
          face.boundingBox.width,
          face.boundingBox.height,
        );
        if (faceShortSide < imageShortSide * _kMinFaceRatio) {
          framesUnclear++;
          debugPrint('[EmotionDebug] frame ${i + 1}/$_kBurstFrames: face too '
              'small (face_short=${faceShortSide.toStringAsFixed(0)} px, '
              'image_short=${imageShortSide.toStringAsFixed(0)} px, '
              'ratio=${(faceShortSide / imageShortSide).toStringAsFixed(3)} '
              '< $_kMinFaceRatio)');
          if (i < _kBurstFrames - 1) {
            await Future.delayed(_kBurstDelay);
          }
          continue;
        }

        // 4. Crop with safe padding, then resize to 224×224.
        final cropped = _cropWithPadding(decoded, face.boundingBox);
        final resized = img.copyResize(cropped, width: 224, height: 224);

        // 5. Normalise to [-1, +1] (matches mobilenet_v2.preprocess_input).
        final input = _buildModelInput(resized);

        // 6. Run inference.
        final output =
            List.generate(1, (_) => List<double>.filled(_labels.length, 0.0));
        _interpreter!.run(input, output);
        final raw = List<double>.from(output.first);
        softmaxAccum.add(raw);
        framesWithFace++;

        debugPrint('[EmotionDebug] frame ${i + 1}/$_kBurstFrames: '
            'face=${face.boundingBox.width.toStringAsFixed(0)}x'
            '${face.boundingBox.height.toStringAsFixed(0)} '
            'softmax=${_formatVec(raw)}');

        if (i < _kBurstFrames - 1) {
          await Future.delayed(_kBurstDelay);
        }
      }
    } catch (e, st) {
      debugPrint('Emotion inference failed: $e\n$st');
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _errorText = _getText('Failed to analyze image');
        });
      }
      return;
    }

    if (!mounted) return;

    // ── Decision logic ──────────────────────────────────────────────────────
    debugPrint('[EmotionDebug] burst summary: framesWithFace=$framesWithFace '
        'framesUnclear=$framesUnclear framesNoFace=$framesNoFace');

    if (framesWithFace == 0) {
      // Distinguish "no face at all" vs "face is too small / unclear".
      final unclearDominant = framesUnclear > framesNoFace;
      final decision = unclearDominant
          ? _CaptureStatus.faceNotClear
          : _CaptureStatus.noFace;
      debugPrint('[EmotionDebug] FINAL DECISION: $decision');
      setState(() {
        _isAnalyzing = false;
        _status = decision;
        _lastFrameStats = [framesWithFace, framesUnclear, framesNoFace];
      });
      _emojiController.forward(from: 0.0);
      return;
    }

    final mean = _meanVector(softmaxAccum);
    final top1Idx = _argmax(mean);
    final top1 = mean[top1Idx];
    final top2Idx = _argmaxExcept(mean, top1Idx);
    final top2 = mean[top2Idx];
    final margin = top1 - top2;

    debugPrint('[EmotionDebug] mean softmax: ${_formatVec(mean)}');
    debugPrint('[EmotionDebug] top1=${_labels[top1Idx]} '
        '(${(top1 * 100).toStringAsFixed(1)}%)  '
        'top2=${_labels[top2Idx]} '
        '(${(top2 * 100).toStringAsFixed(1)}%)  '
        'margin=${(margin * 100).toStringAsFixed(1)}%');

    if (top1 < _kMinConfidence || margin < _kMinTopMargin) {
      debugPrint('[EmotionDebug] FINAL DECISION: uncertain '
          '(top1=${(top1 * 100).toStringAsFixed(1)}% < '
          '${(_kMinConfidence * 100).toStringAsFixed(0)}% OR '
          'margin=${(margin * 100).toStringAsFixed(1)}% < '
          '${(_kMinTopMargin * 100).toStringAsFixed(0)}%)');
      setState(() {
        _isAnalyzing = false;
        _status = _CaptureStatus.uncertain;
        _resultLabel = _labels.isNotEmpty ? _labels[top1Idx] : null;
        _resultScore = top1;
        _lastMeanSoftmax = mean;
        _lastFrameStats = [framesWithFace, framesUnclear, framesNoFace];
      });
      _emojiController.forward(from: 0.0);
      return;
    }

    debugPrint('[EmotionDebug] FINAL DECISION: reliable -> ${_labels[top1Idx]} '
        '@ ${(top1 * 100).toStringAsFixed(1)}%');
    setState(() {
      _isAnalyzing = false;
      _status = _CaptureStatus.reliable;
      _resultLabel = _labels[top1Idx];
      _resultScore = top1;
      _lastMeanSoftmax = mean;
      _lastFrameStats = [framesWithFace, framesUnclear, framesNoFace];
    });
    _emojiController.forward(from: 0.0);
  }

  /// Helper: format a small vector as `[12.3%, 4.1%, 67.0%, …]` for logs.
  String _formatVec(List<double> v) =>
      '[${v.map((x) => '${(x * 100).toStringAsFixed(1)}%').join(', ')}]';

  // ──────────────────────────────────────────────────────────────────────────
  // Helpers
  // ──────────────────────────────────────────────────────────────────────────

  Face _largestFace(List<Face> faces) {
    faces.sort((a, b) => (b.boundingBox.width * b.boundingBox.height)
        .compareTo(a.boundingBox.width * a.boundingBox.height));
    return faces.first;
  }

  img.Image _cropWithPadding(img.Image source, Rect bbox) {
    final padW = bbox.width * _kFaceCropPadding;
    final padH = bbox.height * _kFaceCropPadding;
    int x = (bbox.left - padW).clamp(0, source.width - 1).toInt();
    int y = (bbox.top - padH).clamp(0, source.height - 1).toInt();
    int w = (bbox.width + 2 * padW).toInt();
    int h = (bbox.height + 2 * padH).toInt();
    if (x + w > source.width) w = source.width - x;
    if (y + h > source.height) h = source.height - y;
    if (w < 1) w = 1;
    if (h < 1) h = 1;
    return img.copyCrop(source, x: x, y: y, width: w, height: h);
  }

  List<List<List<List<double>>>> _buildModelInput(img.Image resized) {
    return List.generate(
      1,
      (_) => List.generate(
        224,
        (y) => List.generate(
          224,
          (x) {
            final pixel = resized.getPixel(x, y);
            final r = pixel.r.toDouble();
            final g = pixel.g.toDouble();
            final b = pixel.b.toDouble();
            return [
              (r / 127.5) - 1.0,
              (g / 127.5) - 1.0,
              (b / 127.5) - 1.0,
            ];
          },
        ),
      ),
    );
  }

  List<double> _meanVector(List<List<double>> vectors) {
    final n = vectors.length;
    final dim = vectors.first.length;
    final out = List<double>.filled(dim, 0.0);
    for (final v in vectors) {
      for (var i = 0; i < dim; i++) {
        out[i] += v[i];
      }
    }
    for (var i = 0; i < dim; i++) {
      out[i] /= n;
    }
    return out;
  }

  int _argmax(List<double> v) {
    var idx = 0;
    var best = v[0];
    for (var i = 1; i < v.length; i++) {
      if (v[i] > best) {
        best = v[i];
        idx = i;
      }
    }
    return idx;
  }

  /// Returns the index of the largest element, ignoring [excludeIdx].
  int _argmaxExcept(List<double> v, int excludeIdx) {
    int best = -1;
    double bestVal = double.negativeInfinity;
    for (var i = 0; i < v.length; i++) {
      if (i == excludeIdx) continue;
      if (v[i] > bestVal) {
        bestVal = v[i];
        best = i;
      }
    }
    return best;
  }

  String _getEmoji(String? emotion) {
    if (emotion == null) return '🤔';
    return _emotionEmojis[emotion.toLowerCase()] ?? '😐';
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Sensory support panel actions
  //
  // These run only when the user taps "Play support". Nothing auto-fires.
  // Haptics respect the global "Vibration On" setting in Settings.
  // ──────────────────────────────────────────────────────────────────────────
  Future<void> _playSupport() async {
    if (_supportPlaying) return;
    setState(() => _supportPlaying = true);

    await SensoryFeedbackService.triggerLightVibrationIfEnabled();
    final display = _displayFor(_resultLabel);
    if (display.isNotEmpty) {
      unawaited(EmotionSupportAudioService.playForDisplayEmotion(
        display,
        widget.language,
      ));
    }

    // Slow, calm breathing/dim animation. Always slow; never blinking.
    _breathingController.value = 0.0;
    await _breathingController.repeat(reverse: true).orCancel
        .catchError((_) {});
  }

  void _stopSupport() {
    unawaited(EmotionSupportAudioService.stop());
    _breathingController.stop();
    _breathingController.value = 0.0;
    if (mounted) {
      setState(() => _supportPlaying = false);
    }
  }

  void _skipSupport() {
    _stopSupport();
    setState(() => _supportPanelDismissed = true);
  }

  String _getText(String fallback) {
    switch (widget.language) {
      case 'si-LK':
        if (fallback == 'No camera available') return 'කැමරාවක් නැහැ';
        if (fallback == 'Camera discovery failed') {
          return 'කැමරාව සොයා ගැනීම අසාර්ථකයි';
        }
        if (fallback == 'Camera permission or initialization failed') {
          return 'කැමරා අවසරය හෝ ආරම්භය අසාර්ථකයි';
        }
        if (fallback == 'Emotion model failed to load') {
          return 'හැඟීම් මොඩලය පූරණය වීම අසාර්ථකයි';
        }
        if (fallback == 'Emotion labels failed to load') {
          return 'හැඟීම් ලේබල් පූරණය වීම අසාර්ථකයි';
        }
        if (fallback == 'Emotion model shape is not supported') {
          return 'හැඟීම් මොඩල් හැඩය සහාය නොදක්වයි';
        }
        if (fallback == 'Failed to start camera') return 'කැමරාව ආරම්භ වෙන්නේ නැහැ';
        if (fallback == 'Failed to analyze image') return 'විශ්ලේෂණය අසාර්ථකයි';
        if (fallback == 'Unknown') return 'නොදන්නා';
        if (fallback == 'Analyzing...') return 'විශ්ලේෂණය කරමින්...';
        if (fallback == 'Capture & Analyze') return 'ග්‍රහණය කර විශ්ලේෂණය කරන්න';
        if (fallback == 'Switch Camera') return 'කැමරාව මාරු කරන්න';
        if (fallback == 'No face detected') return 'මුහුණක් හමු වුණේ නැහැ';
        if (fallback == 'Face not clear') return 'මුහුණ පැහැදිලි නැහැ';
        if (fallback == 'Uncertain - try again') return 'අවිනිශ්චිතයි - නැවත උත්සාහ කරන්න';
        if (fallback == 'Use this emotion') return 'මේ හැඟීම තෝරන්න';
        return fallback;
      case 'ta-IN':
        if (fallback == 'No camera available') return 'கேமரா இல்லை';
        if (fallback == 'Camera discovery failed') {
          return 'கேமரா கண்டுபிடிப்பு தோல்வி';
        }
        if (fallback == 'Camera permission or initialization failed') {
          return 'கேமரா அனுமதி அல்லது தொடக்கம் தோல்வி';
        }
        if (fallback == 'Emotion model failed to load') {
          return 'உணர்வு மாதிரி ஏற்ற முடியவில்லை';
        }
        if (fallback == 'Emotion labels failed to load') {
          return 'உணர்வு லேபல்கள் ஏற்ற முடியவில்லை';
        }
        if (fallback == 'Emotion model shape is not supported') {
          return 'உணர்வு மாதிரி வடிவம் ஆதரிக்கப்படவில்லை';
        }
        if (fallback == 'Failed to start camera') return 'கேமரா துவங்கவில்லை';
        if (fallback == 'Failed to analyze image') return 'ஆய்வு தோல்வி';
        if (fallback == 'Unknown') return 'தெரியாதது';
        if (fallback == 'Analyzing...') return 'ஆய்வு செய்கிறது...';
        if (fallback == 'Capture & Analyze') return 'படம் எடுத்து பகுப்பாய்வு செய்';
        if (fallback == 'Switch Camera') return 'கேமராவை மாற்று';
        if (fallback == 'No face detected') return 'முகம் கண்டுபிடிக்கப்படவில்லை';
        if (fallback == 'Face not clear') return 'முகம் தெளிவில்லை';
        if (fallback == 'Uncertain - try again') return 'நிச்சயமற்றது - மீண்டும் முயற்சி';
        if (fallback == 'Use this emotion') return 'இந்த உணர்வை பயன்படுத்து';
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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.white,
            shadows: _kCameraOverlayShadows,
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.38),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          title: Text(
            widget.language == 'si-LK'
                ? 'චායාරූපයෙන් හැඟීම්'
                : widget.language == 'ta-IN'
                    ? 'புகைப்பட உணர்வு'
                    : 'Emotion Camera',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: _kCameraOverlayShadows,
            ),
          ),
          actions: [
            // ⚠️ DEBUG-ONLY: flips the raw-probabilities panel.
            // Safe to leave for testers; can be hidden behind a build flag
            // later if you want to ship without it.
            IconButton(
              tooltip: _showDebugProbs
                  ? 'Hide raw probabilities'
                  : 'Show raw probabilities',
              icon: Icon(
                _showDebugProbs ? Icons.bug_report : Icons.bug_report_outlined,
                color: _showDebugProbs ? Colors.amberAccent : Colors.white,
                shadows: _kCameraOverlayShadows,
              ),
              onPressed: () {
                setState(() => _showDebugProbs = !_showDebugProbs);
                debugPrint('[EmotionDebug] Show raw probabilities = '
                    '$_showDebugProbs');
              },
            ),
          ],
        ),
        body: Stack(
          children: [
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

            if (!_isLoading && _errorText == null)
              AnimatedBuilder(
                animation: _flashAnimation,
                builder: (context, child) {
                  return Container(
                    color: Colors.white.withOpacity(_flashAnimation.value * 0.7),
                  );
                },
              ),

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

            // Result card + support + debug: scrollable band so controls never overlap.
            if (_status != _CaptureStatus.idle && !_isLoading && _errorText == null)
              Positioned(
                left: 12,
                right: 12,
                top: MediaQuery.of(context).padding.top + 52,
                bottom: MediaQuery.of(context).padding.bottom + 136,
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildResultCard(colors),
                      if (_status == _CaptureStatus.reliable &&
                          _resultLabel != null &&
                          !_supportPanelDismissed)
                        _buildSupportPanelOrEmpty(colors),
                      if (_showDebugProbs) _buildDebugProbsPanel(colors),
                    ],
                  ),
                ),
              ),

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
                        if (_cameras.length > 1)
                          _ControlButton(
                            icon: Icons.flip_camera_ios,
                            onPressed: _isSwitchingCamera ? null : _switchCamera,
                            colors: colors,
                            size: 60,
                          ),
                        ScaleTransition(
                          scale: _isAnalyzing
                              ? _pulseAnimation
                              : const AlwaysStoppedAnimation(1.0),
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

  Widget _buildResultCard(Map<String, Color> colors) {
    // Choose presentation based on the capture status.
    String emoji;
    String title;
    String? subtitle;
    bool showUseButton = false;

    switch (_status) {
      case _CaptureStatus.idle:
        return const SizedBox.shrink();
      case _CaptureStatus.noFace:
        emoji = '🙈';
        title = _getText('No face detected');
        subtitle = null;
        break;
      case _CaptureStatus.faceNotClear:
        emoji = '😶‍🌫️';
        title = _getText('Face not clear');
        subtitle = null;
        break;
      case _CaptureStatus.uncertain:
        emoji = '🤔';
        title = _getText('Uncertain - try again');
        subtitle = _resultScore != null
            ? '${(100 * _resultScore!).toStringAsFixed(1)}%'
            : null;
        break;
      case _CaptureStatus.reliable:
        // _resultLabel holds the RAW model label (e.g. "Joy"); the user
        // sees the friendly display label (e.g. "Happy").
        emoji = _getEmoji(_resultLabel);
        final display = _displayFor(_resultLabel);
        title = (display.isEmpty ? _getText('Unknown') : display).toUpperCase();
        subtitle = _resultScore != null
            ? '${(100 * _resultScore!).toStringAsFixed(1)}% confident'
            : null;
        showUseButton = true;
        break;
    }

    return ScaleTransition(
      scale: _emojiScale,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
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
            Text(emoji, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colors['primary'],
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: colors['accent']!.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors['textColor']!.withOpacity(0.8),
                  ),
                ),
              ),
            ],
            if (showUseButton) ...[
              const SizedBox(height: 14),
              ElevatedButton.icon(
                // Return the DISPLAY label (e.g. "Happy") so the home screen
                // never has to know about raw model class names.
                onPressed: () => Navigator.of(context).pop(_displayFor(_resultLabel)),
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: Text(
                  _getText('Use this emotion'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors['primary'],
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Sensory support panel UI
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildSupportPanelOrEmpty(Map<String, Color> colors) {
    // Use the DISPLAY label so the service never has to know raw model
    // class names. (Internally planFor() lower-cases the key.)
    final plan = SensoryFeedbackService.planFor(_displayFor(_resultLabel));
    if (plan == null) {
      // Neutral / unknown → no panel by spec.
      return const SizedBox.shrink();
    }

    final actionText = plan.actionFor(widget.language);
    final playLabel = widget.language == 'si-LK'
        ? 'සහාය ක්‍රියාත්මක කරන්න'
        : widget.language == 'ta-IN'
            ? 'ஆதரவை இயக்கு'
            : 'Play support';
    final skipLabel = widget.language == 'si-LK'
        ? 'මඟ හරින්න'
        : widget.language == 'ta-IN'
            ? 'தவிர்'
            : 'Skip';
    final stopLabel = widget.language == 'si-LK'
        ? 'නවත්වන්න'
        : widget.language == 'ta-IN'
            ? 'நிறுத்து'
            : 'Stop';
    final suggestedHeader = widget.language == 'si-LK'
        ? 'හඳුනාගත් හැඟීම'
        : widget.language == 'ta-IN'
            ? 'கண்டறிந்த உணர்வு'
            : 'Detected emotion';
    final caregiverAlert = widget.language == 'si-LK'
        ? '⚠️ රැකබලාගන්නාට දන්වන්න: දරුවාට බයයි.'
        : widget.language == 'ta-IN'
            ? '⚠️ பராமரிப்பாளரின் கவனம் தேவை: குழந்தைக்கு பயம்.'
            : '⚠️ Caregiver attention: the child looks scared.';

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: colors['primary']!.withOpacity(0.2),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Detected-emotion strip
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(suggestedHeader,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors['textColor']!.withOpacity(0.7),
                      letterSpacing: 0.6,
                    )),
                const SizedBox(width: 6),
                Text(
                  '${_getEmoji(_resultLabel)} ${plan.emotion}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colors['primary'],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Suggested action description
            Text(
              actionText,
              style: TextStyle(
                fontSize: 13,
                color: colors['textColor']!.withOpacity(0.85),
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),

            // Caregiver alert ribbon (Fear only)
            if (plan.showCaregiverAlert) ...[
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber.shade700, width: 1),
                ),
                child: Text(
                  caregiverAlert,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.amber.shade900,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],

            // Slow breathing / dim visual that is only animated when playing.
            // Width-bounded so the panel never grows past the screen.
            if (_supportPlaying) ...[
              const SizedBox(height: 10),
              _buildBreathingVisual(plan.animation, colors),
            ],

            const SizedBox(height: 12),

            // Action buttons (wrap so long Sinhala/Tamil labels never collide).
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                if (!_supportPlaying)
                  TextButton.icon(
                    onPressed: _skipSupport,
                    icon: const Icon(Icons.close, size: 18),
                    label: Text(skipLabel),
                    style: TextButton.styleFrom(
                      foregroundColor:
                          colors['textColor']!.withOpacity(0.7),
                    ),
                  )
                else
                  TextButton.icon(
                    onPressed: _stopSupport,
                    icon: const Icon(Icons.stop_circle, size: 18),
                    label: Text(stopLabel),
                    style: TextButton.styleFrom(
                      foregroundColor:
                          colors['textColor']!.withOpacity(0.7),
                    ),
                  ),
                ElevatedButton.icon(
                  onPressed:
                      _supportPlaying ? null : () => unawaited(_playSupport()),
                  icon: const Icon(Icons.spa, color: Colors.white, size: 18),
                  label: Text(
                    playLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors['accent'],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreathingVisual(
      SupportAnimation animation, Map<String, Color> colors) {
    return AnimatedBuilder(
      animation: _breathingController,
      builder: (context, _) {
        final t = _breathingController.value;
        switch (animation) {
          case SupportAnimation.positivePulse:
            final scale = 0.95 + 0.10 * t;
            return Transform.scale(
              scale: scale,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      colors['primary']!.withOpacity(0.55),
                      colors['accent']!.withOpacity(0.55),
                    ],
                  ),
                ),
              ),
            );
          case SupportAnimation.calmBreathing:
            final scale = 0.85 + 0.30 * t;
            return Transform.scale(
              scale: scale,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors['accent']!.withOpacity(0.35 + 0.15 * t),
                ),
              ),
            );
          case SupportAnimation.softDim:
            return Container(
              width: 90,
              height: 12,
              decoration: BoxDecoration(
                color: colors['primary']!.withOpacity(0.20 + 0.20 * (1 - t)),
                borderRadius: BorderRadius.circular(6),
              ),
            );
        }
      },
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // AI debug panel (Show raw probabilities)
  //
  // Displays all six softmax values as percentages with 1 decimal place,
  // plus the burst frame stats. The whole panel is wrapped in a single
  // Container so it never affects the camera preview underneath.
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildDebugProbsPanel(Map<String, Color> colors) {
    final mean = _lastMeanSoftmax;
    final stats = _lastFrameStats;

    // Top-1 / Top-2 derived from the smoothed mean (not from a single frame).
    int? top1Idx;
    int? top2Idx;
    double top1 = 0, top2 = 0, margin = 0;
    if (mean != null && mean.isNotEmpty) {
      top1Idx = _argmax(mean);
      top1 = mean[top1Idx];
      top2Idx = _argmaxExcept(mean, top1Idx);
      top2 = top2Idx >= 0 ? mean[top2Idx] : 0.0;
      margin = top1 - top2;
    }

    String decisionLine;
    switch (_status) {
      case _CaptureStatus.idle:
        decisionLine = 'decision: (none yet)';
        break;
      case _CaptureStatus.noFace:
        decisionLine = 'decision: NO FACE';
        break;
      case _CaptureStatus.faceNotClear:
        decisionLine = 'decision: FACE NOT CLEAR';
        break;
      case _CaptureStatus.uncertain:
        decisionLine = 'decision: UNCERTAIN';
        break;
      case _CaptureStatus.reliable:
        decisionLine = 'decision: RELIABLE';
        break;
    }

    final rawTop = (top1Idx != null && top1Idx < _labels.length)
        ? _labels[top1Idx]
        : '—';
    final displayTop = _displayFor(rawTop);
    final rawTop2 = (top2Idx != null && top2Idx >= 0 && top2Idx < _labels.length)
        ? _labels[top2Idx]
        : '—';

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.78),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.amberAccent, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  '🐞 RAW PROBABILITIES',
                  style: TextStyle(
                    color: Colors.amberAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  'debug only',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _debugLine(
              'active_model: ${_activeEmotionModelName.isEmpty ? "—" : _activeEmotionModelName}',
            ),
            Text(
              widget.language == 'si-LK'
                  ? 'මොඩලය: Auto = ස්වයං, නැතහොත් එකක් පමණක් බලන්න.'
                  : widget.language == 'ta-IN'
                      ? 'மாதிரி: Auto = தானாக, அல்லது ஒன்றை கட்டாயமாக்கு.'
                  : 'Model: Auto picks best load; or force one TFLite.',
              style: const TextStyle(color: Colors.white60, fontSize: 10),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                ChoiceChip(
                  label: Text(
                    widget.language == 'si-LK'
                        ? 'ස්වයං'
                        : widget.language == 'ta-IN'
                            ? 'தானாக'
                            : 'Auto',
                    style: const TextStyle(fontSize: 11),
                  ),
                  selected: _modelLoadMode == _EmotionModelLoadMode.auto,
                  onSelected: _reloadModelBusy
                      ? null
                      : (v) {
                          if (v) {
                            unawaited(
                                _applyModelLoadMode(_EmotionModelLoadMode.auto));
                          }
                        },
                  selectedColor: Colors.amber.withOpacity(0.35),
                  labelStyle: const TextStyle(color: Colors.white),
                ),
                ChoiceChip(
                  label: Text(
                    widget.language == 'si-LK'
                        ? 'EfficientNet'
                        : widget.language == 'ta-IN'
                            ? 'EfficientNet'
                            : 'EfficientNet',
                    style: const TextStyle(fontSize: 11),
                  ),
                  selected:
                      _modelLoadMode == _EmotionModelLoadMode.primaryOnly,
                  onSelected: _reloadModelBusy
                      ? null
                      : (v) {
                          if (v) {
                            unawaited(_applyModelLoadMode(
                                _EmotionModelLoadMode.primaryOnly));
                          }
                        },
                  selectedColor: Colors.amber.withOpacity(0.35),
                  labelStyle: const TextStyle(color: Colors.white),
                ),
                ChoiceChip(
                  label: Text(
                    widget.language == 'si-LK'
                        ? 'MobileNet'
                        : widget.language == 'ta-IN'
                            ? 'MobileNet'
                            : 'MobileNet',
                    style: const TextStyle(fontSize: 11),
                  ),
                  selected:
                      _modelLoadMode == _EmotionModelLoadMode.fallbackOnly,
                  onSelected: _reloadModelBusy
                      ? null
                      : (v) {
                          if (v) {
                            unawaited(_applyModelLoadMode(
                                _EmotionModelLoadMode.fallbackOnly));
                          }
                        },
                  selectedColor: Colors.amber.withOpacity(0.35),
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            SwitchListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(
                widget.language == 'si-LK'
                    ? 'මුහුණ හඳුනාගැනීම (ON = මුහුණ අවශ්‍ය)'
                    : widget.language == 'ta-IN'
                        ? 'முகம் கண்டறிதல் (ON = முகம் தேவை)'
                        : 'Face detection (ON = require face crop)',
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
              value: _faceGateEnabled,
              onChanged: (v) => unawaited(_setFaceGateEnabled(v)),
              activeColor: Colors.amberAccent,
            ),
            const SizedBox(height: 6),
            Container(height: 1, color: Colors.white24),
            const SizedBox(height: 6),
            if (mean == null || mean.isEmpty)
              const Text(
                'No inference yet — tap the shutter while a face is in frame.',
                style: TextStyle(color: Colors.white70, fontSize: 11),
              )
            else
              ..._buildDebugProbRows(mean),
            const SizedBox(height: 8),
            // Raw vs display, top1/top2/margin, decision — single mono block.
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _debugLine(
                      'raw model:  $rawTop   →   display:  $displayTop'),
                  _debugLine(
                      'top1:       $rawTop  ${(top1 * 100).toStringAsFixed(1)}%'),
                  _debugLine(
                      'top2:       $rawTop2  ${(top2 * 100).toStringAsFixed(1)}%'),
                  _debugLine(
                      'margin:     ${(margin * 100).toStringAsFixed(1)}%'),
                  _debugLine(decisionLine),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'thresholds: confidence ≥ '
              '${(_kMinConfidence * 100).toStringAsFixed(0)}% '
              '· margin ≥ '
              '${(_kMinTopMargin * 100).toStringAsFixed(0)}%'
              '${stats == null ? '' : '   ·   frames OK/unclear/noFace = '
                  '${stats[0]}/${stats[1]}/${stats[2]}'}',
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 10.5,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 4),
            Container(height: 1, color: colors['accent']!.withOpacity(0.25)),
          ],
        ),
      ),
    );
  }

  Widget _debugLine(String text) => Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11.5,
          fontFamily: 'monospace',
          height: 1.4,
        ),
      );

  List<Widget> _buildDebugProbRows(List<double> mean) {
    // Build (label, score) pairs sorted by score descending so the dominant
    // class is on top and easy to read on a phone.
    final pairs = <MapEntry<String, double>>[];
    for (var i = 0; i < mean.length; i++) {
      final label = i < _labels.length ? _labels[i] : 'idx$i';
      pairs.add(MapEntry(label, mean[i]));
    }
    pairs.sort((a, b) => b.value.compareTo(a.value));

    return pairs.map((e) {
      final pct = (e.value * 100).toStringAsFixed(1);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: Row(
          children: [
            SizedBox(
              width: 70,
              child: Text(
                e.key,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: e.value.clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor: Colors.white12,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.amberAccent),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 56,
              child: Text(
                '$pct %',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
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
        color: Colors.black.withOpacity(0.32),
        border: Border.all(
          color: Colors.white.withOpacity(0.65),
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.white,
          size: size * 0.4,
          shadows: _kCameraOverlayShadows,
        ),
      ),
    );
  }
}
