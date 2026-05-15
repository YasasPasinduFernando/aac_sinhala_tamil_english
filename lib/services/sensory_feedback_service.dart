import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global vibration preference + emotion support plans for the camera screen.
///
/// Settings exposes a single **"Vibration On"** toggle (`vibration_enabled`,
/// default ON). AAC cards use light impact; main nav (home / arrows) uses
/// a stronger medium impact when enabled.
///
/// Camera support copy describes **audio/sound only** (no animation wording).
/// The support panel may still show a calm visual when "Play support" is tapped.
class SensoryFeedbackService {
  static const String _kVibrationKey = 'vibration_enabled';
  /// Older builds stored this key from the previous sensory settings card.
  static const String _kLegacyVibrationKey = 'sensory_vibration_enabled';

  static bool _vibrationEnabled = true;

  static bool isVibrationEnabled() => _vibrationEnabled;

  /// Loads [vibration_enabled] from disk. If missing, falls back to legacy
  /// `sensory_vibration_enabled`, then defaults to **true**.
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_kVibrationKey)) {
      _vibrationEnabled = prefs.getBool(_kVibrationKey) ?? true;
    } else if (prefs.containsKey(_kLegacyVibrationKey)) {
      _vibrationEnabled = prefs.getBool(_kLegacyVibrationKey) ?? true;
      await prefs.setBool(_kVibrationKey, _vibrationEnabled);
    } else {
      _vibrationEnabled = true;
    }
  }

  static Future<void> setVibrationEnabled(bool value) async {
    _vibrationEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kVibrationKey, value);
  }

  /// Light haptic when [isVibrationEnabled] is true. Safe to call from UI.
  static Future<void> triggerLightVibrationIfEnabled() async {
    if (!_vibrationEnabled) return;
    try {
      await HapticFeedback.lightImpact();
    } catch (e, st) {
      debugPrint('SensoryFeedbackService.triggerLightVibrationIfEnabled: $e\n$st');
    }
  }

  /// Stronger haptic for bottom home / prev / next navigation circles.
  static Future<void> triggerMediumVibrationIfEnabled() async {
    if (!_vibrationEnabled) return;
    try {
      await HapticFeedback.mediumImpact();
    } catch (e, st) {
      debugPrint('SensoryFeedbackService.triggerMediumVibrationIfEnabled: $e\n$st');
    }
  }

  /// Returns the matching support plan for a reliable emotion label.
  ///
  /// Labels accepted here are the *display* labels (Happy, Sad, Angry, Fear,
  /// Surprise, Neutral). The camera screen maps raw model labels first.
  static SensorySupportPlan? planFor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
        return const SensorySupportPlan(
          emotion: 'Happy',
          actionEn: 'Celebrate with a soft happy support sound.',
          actionSi: 'සතුට ප්‍රකාශ කිරීමට මෘදු සහායක ශබ්දයක් වාදනය කරන්න.',
          actionTa: 'மகிழ்ச்சியை வெளிப்படுத்த மென்மையான ஆதரவு ஒலியை இயக்குங்கள்.',
          animation: SupportAnimation.positivePulse,
          hapticPattern: HapticPattern.light,
          soundTone: SupportSoundTone.none,
          showCaregiverAlert: false,
        );
      case 'sad':
        return const SensorySupportPlan(
          emotion: 'Sad',
          actionEn: 'Play a gentle comforting support sound.',
          actionSi: 'සැනසීමට මෘදු සහායක ශබ්දයක් වාදනය කරන්න.',
          actionTa: 'ஆறுதல் அளிக்க மென்மையான ஆதரவு ஒலியை இயக்குங்கள்.',
          animation: SupportAnimation.calmBreathing,
          hapticPattern: HapticPattern.light,
          soundTone: SupportSoundTone.none,
          showCaregiverAlert: false,
        );
      case 'angry':
        return const SensorySupportPlan(
          emotion: 'Angry',
          actionEn: 'Use a calm support sound to help the child settle.',
          actionSi: 'සන්සුන් වීමට මෘදු සහායක ශබ්දයක් වාදනය කරන්න.',
          actionTa: 'அமைதியாக உதவ மென்மையான ஆதரவு ஒலியை இயக்குங்கள்.',
          animation: SupportAnimation.calmBreathing,
          hapticPattern: HapticPattern.light,
          soundTone: SupportSoundTone.none,
          showCaregiverAlert: false,
        );
      case 'fear':
        return const SensorySupportPlan(
          emotion: 'Fear',
          actionEn: 'Play a soft reassuring support sound.',
          actionSi: 'භය අඩු කිරීමට මෘදු සහායක ශබ්දයක් වාදනය කරන්න.',
          actionTa: 'பயத்தை குறைக்க மென்மையான ஆதரவு ஒலியை இயக்குங்கள்.',
          animation: SupportAnimation.calmBreathing,
          hapticPattern: HapticPattern.light,
          soundTone: SupportSoundTone.none,
          showCaregiverAlert: true,
        );
      case 'surprise':
        return const SensorySupportPlan(
          emotion: 'Surprise',
          actionEn: 'Play a gentle attention sound.',
          actionSi: 'අවධානය යොමු කිරීමට මෘදු සහායක ශබ්දයක් වාදනය කරන්න.',
          actionTa: 'கவனத்தை ஈர்க்க மென்மையான ஆதரவு ஒலியை இயக்குங்கள்.',
          animation: SupportAnimation.calmBreathing,
          hapticPattern: HapticPattern.light,
          soundTone: SupportSoundTone.none,
          showCaregiverAlert: false,
        );
      case 'neutral':
        return null;
      default:
        return null;
    }
  }
}

enum SupportAnimation {
  positivePulse,
  calmBreathing,
  softDim,
}

enum HapticPattern { light, selection }

/// Kept on [SensorySupportPlan] for compatibility; sound is not played in-app.
enum SupportSoundTone { none }

class SensorySupportPlan {
  final String emotion;
  final String actionEn;
  final String actionSi;
  final String actionTa;
  final SupportAnimation animation;
  final HapticPattern hapticPattern;
  final SupportSoundTone soundTone;
  final bool showCaregiverAlert;

  const SensorySupportPlan({
    required this.emotion,
    required this.actionEn,
    required this.actionSi,
    required this.actionTa,
    required this.animation,
    required this.hapticPattern,
    required this.soundTone,
    required this.showCaregiverAlert,
  });

  String actionFor(String languageCode) {
    switch (languageCode) {
      case 'si-LK':
        return actionSi;
      case 'ta-IN':
        return actionTa;
      default:
        return actionEn;
    }
  }
}
