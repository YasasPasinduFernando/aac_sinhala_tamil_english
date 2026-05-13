import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global vibration preference + emotion support plans for the camera screen.
///
/// Settings exposes a single **"Vibration On"** toggle (`vibration_enabled`,
/// default ON). Light haptics use `HapticFeedback.lightImpact` only.
///
/// Sound and animation **settings** were removed for simplicity; the camera
/// support panel still runs its calm animations when the user taps
/// "Play support" (no user-facing animation toggle).
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

  /// Returns the matching support plan for a reliable emotion label.
  ///
  /// Labels accepted here are the *display* labels (Happy, Sad, Angry, Fear,
  /// Surprise, Neutral). The camera screen maps raw model labels first.
  static SensorySupportPlan? planFor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
        return const SensorySupportPlan(
          emotion: 'Happy',
          actionEn: 'Celebrate with a soft chime and a gentle happy animation.',
          actionSi: 'සැහැල්ලු සිනා ශබ්දයකින් සහ සතුටු සංදර්ශනයකින් සැමරුම.',
          actionTa: 'மென்மையான மணியோசை மற்றும் மகிழ்ச்சி அசைவு.',
          animation: SupportAnimation.positivePulse,
          hapticPattern: HapticPattern.light,
          soundTone: SupportSoundTone.none,
          showCaregiverAlert: false,
        );
      case 'sad':
        return const SensorySupportPlan(
          emotion: 'Sad',
          actionEn: 'Play a slow calming breathing animation and a soft comforting tone.',
          actionSi: 'සන්සුන් හුස්ම ගැනීමේ සංදර්ශනය සහ සැහැල්ලු සහනකාරී හඬ.',
          actionTa: 'அமைதியான மூச்சு அசைவு மற்றும் மென்மையான ஆறுதல் ஓசை.',
          animation: SupportAnimation.calmBreathing,
          hapticPattern: HapticPattern.light,
          soundTone: SupportSoundTone.none,
          showCaregiverAlert: false,
        );
      case 'angry':
        return const SensorySupportPlan(
          emotion: 'Angry',
          actionEn: 'Guide a slow breathing animation and play a low calming tone.',
          actionSi: 'මන්දගාමී හුස්ම ගැනීමේ සංදර්ශනය සහ සන්සුන් හඬ.',
          actionTa: 'மெதுவான மூச்சு அசைவு மற்றும் அமைதியான ஓசை.',
          animation: SupportAnimation.calmBreathing,
          hapticPattern: HapticPattern.light,
          soundTone: SupportSoundTone.none,
          showCaregiverAlert: false,
        );
      case 'fear':
        return const SensorySupportPlan(
          emotion: 'Fear',
          actionEn: 'Show a safe-space animation. The caregiver may want to comfort the child.',
          actionSi: 'ආරක්ෂිත සංදර්ශනය. රැකබලාගන්නා කෙනා දරුවාට සැනසීම සැපයීම සුදුසුයි.',
          actionTa: 'பாதுகாப்பான அசைவு. பராமரிப்பாளர் ஆறுதல் வழங்கலாம்.',
          animation: SupportAnimation.calmBreathing,
          hapticPattern: HapticPattern.light,
          soundTone: SupportSoundTone.none,
          showCaregiverAlert: true,
        );
      case 'surprise':
        return const SensorySupportPlan(
          emotion: 'Surprise',
          actionEn: 'Acknowledge the surprise with a slow calming animation.',
          actionSi: 'හදිසි ප්‍රතික්‍රියාව සන්සුන් සංදර්ශනයකින් පිළිගන්න.',
          actionTa: 'அதிர்ச்சியை அமைதியான அசைவுடன் ஏற்றுக்கொள்ளுங்கள்.',
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
