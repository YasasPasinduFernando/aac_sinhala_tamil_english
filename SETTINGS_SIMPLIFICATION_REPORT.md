# Settings simplification report

Date: 2026-05-13 (branch `upgrade-app`)

## Summary

The caregiver-only sensory feedback card (sound, vibration, calm animations toggles and related copy) was removed from Settings. A single **“Vibration On”** switch was added, persisted as `vibration_enabled` (default **ON**). AAC-related taps call `SensoryFeedbackService.triggerLightVibrationIfEnabled()` so haptics run only when the switch is on.

## Files changed (this work)

| File | Change |
|------|--------|
| `lib/services/sensory_feedback_service.dart` | Rewritten: `vibration_enabled` + legacy `sensory_vibration_enabled` migration; `isVibrationEnabled()`, `setVibrationEnabled()`, `triggerLightVibrationIfEnabled()`; removed sound prefs, animation prefs, `playSound`, `triggerHaptic`. Kept `planFor` / `SensorySupportPlan` for the emotion camera support panel. |
| `lib/screens/settings.dart` | Removed sensory card; added `_buildVibrationSection` with one `SwitchListTile` (“Vibration On” / Sinhala / Tamil). |
| `lib/screens/camera_expression_screen.dart` | Support “Play support”: one light haptic via `triggerLightVibrationIfEnabled()`; removed `playSound` and `animationEnabled` gating; support breathing animation always runs when playing. |
| `lib/main.dart` | Still calls `SensoryFeedbackService.load()` at startup (comment notes vibration key). |
| `lib/screens/theme/aac_word_card_widget.dart` | On card tap release, `unawaited(triggerLightVibrationIfEnabled())`. |
| `lib/screens/theme/animated_category_card.dart` | Before `widget.onTap()`, same haptic helper. |
| `lib/screens/favourite_screen.dart` | Favourites word grid taps call `triggerLightVibrationIfEnabled()`. |

## Settings removed

- Entire **“Sensory Feedback (Caregiver Only)”** card and subtitle.
- **Sound (low volume)** and related SharedPreferences / service API.
- **Light vibration** as a separate row (replaced by the single **Vibration On** control).
- **Calm animations** user setting; in-app support animations are no longer gated by a preference (no animation *setting* in Settings).

## Final Settings options

1. **Vibration On** — single switch (localized title: English “Vibration On”, Sinhala “කම්පනය සක්‍රියයි”, Tamil “அதிர்வு இயக்கம்”).
2. Unchanged: **favourite categories** selection, bottom navigation, TTS-related behaviour elsewhere.

**Confirmation:** Only **“Vibration On”** remains as a user preference at the top of Settings (plus favourite categories below).

## Default value

- **`vibration_enabled`**: if the key is absent, vibration defaults to **ON** (`true`).
- If only legacy **`sensory_vibration_enabled`** exists, its value is read once and copied to `vibration_enabled`.

## Emotion model / camera / assets

**Not modified in this pass:** `assets/models/labels.txt`, TFLite model assets, ML Kit configuration, emotion inference thresholds, debug probability panel wiring, or camera capture logic beyond the support-panel haptic/sound/animation-setting cleanup described above.

## Git status (snapshot)

`git status` on this branch showed many pre-existing modified files (e.g. `AndroidManifest.xml`, `labels.txt`, large `camera_expression_screen.dart` history). The **settings simplification** edits are the subset listed in “Files changed” above.

## Build and analyze

| Command | Result |
|---------|--------|
| `flutter analyze` | **Exit code 1** — project reports **153** issues (mostly `info`: deprecated `withOpacity`, `use_super_parameters`, etc.; **warnings** e.g. unused `_buildNavButton` in `category_screen.dart`). **No analyzer `error` diagnostics** observed in the full analyze run for this simplification. |
| `flutter build apk --release --no-shrink` | **Success** — `build\app\outputs\flutter-apk\app-release.apk` (~110.6 MB). |
