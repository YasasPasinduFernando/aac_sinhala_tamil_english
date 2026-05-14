import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Trilingual WAV clips for “Play support” on the emotion camera (`si` / `ta` / `en`).
///
/// Paths: `assets/audio/support/<lang>/<emotion>.wav`
/// Playback is optional; missing files are handled without crashing.
class EmotionSupportAudioService {
  EmotionSupportAudioService._();

  static final AudioPlayer _player = AudioPlayer();
  static const String _fallbackLang = 'en';

  /// Maps app [languageCode] (e.g. `si-LK`) to audio subfolder name.
  static String _preferredLangFolder(String? languageCode) {
    switch (languageCode) {
      case 'si-LK':
        return 'si';
      case 'ta-IN':
        return 'ta';
      case 'en-GB':
      default:
        return 'en';
    }
  }

  /// Maps display or raw emotion text to WAV stem (no extension).
  /// Joy/Happy → happy, Sadness/Sad → sad, Anger/Angry → angry, etc.
  static String? _stemForEmotion(String label) {
    final k = label.trim().toLowerCase();
    switch (k) {
      case 'happy':
      case 'joy':
        return 'happy';
      case 'sad':
      case 'sadness':
        return 'sad';
      case 'angry':
      case 'anger':
        return 'angry';
      case 'fear':
        return 'fear';
      case 'surprise':
        return 'surprise';
      case 'neutral':
      case 'natural':
        return 'neutral';
      default:
        return null;
    }
  }

  /// Full asset key for [rootBundle] existence check (includes `assets/` prefix).
  static String _bundleKeyForRelative(String relativeUnderAssets) {
    if (relativeUnderAssets.startsWith('assets/')) {
      return relativeUnderAssets;
    }
    return 'assets/$relativeUnderAssets';
  }

  /// Path relative to Flutter `assets/` dir (for [AssetSource]).
  static String _assetSourcePath(String lang, String stem) {
    return 'audio/support/$lang/$stem.wav';
  }

  static Future<bool> _bundleHasAsset(String bundleKey) async {
    try {
      await rootBundle.load(bundleKey);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Plays the support clip for [emotionLabel] using [languageCode] (`si-LK`, `ta-IN`, `en-GB`).
  /// Tries language-specific WAV first, then `en`. Does not throw.
  static Future<void> playForDisplayEmotion(
    String emotionLabel,
    String? languageCode,
  ) async {
    final stem = _stemForEmotion(emotionLabel);
    if (stem == null) {
      return;
    }

    final preferred = _preferredLangFolder(languageCode);
    final primaryRel = _assetSourcePath(preferred, stem);
    final fallbackRel = _assetSourcePath(_fallbackLang, stem);
    final primaryKey = _bundleKeyForRelative(primaryRel);
    final fallbackKey = _bundleKeyForRelative(fallbackRel);

    String? playRel;
    if (await _bundleHasAsset(primaryKey)) {
      playRel = primaryRel;
    } else {
      debugPrint(
        '[EmotionAudio] Failed to play asset: $primaryKey error: missing file',
      );
      if (await _bundleHasAsset(fallbackKey)) {
        playRel = fallbackRel;
      } else {
        debugPrint(
          '[EmotionAudio] Failed to play asset: $fallbackKey error: missing file',
        );
        return;
      }
    }

    try {
      await _player.stop();
      await _player.setReleaseMode(ReleaseMode.release);
      await _player.play(AssetSource(playRel));
    } catch (e, st) {
      debugPrint(
        '[EmotionAudio] Failed to play asset: ${_bundleKeyForRelative(playRel)} error: $e',
      );
      debugPrint('$st');
    }
  }

  static Future<void> stop() async {
    try {
      await _player.stop();
    } catch (_) {}
  }
}
