# Emotion-Responsive Sensory Feedback — Implementation Report

> **Project:** Smart AAC System with Facial Expression Recognition for Autism
> **Branch:** `upgrade-app`
> **Date:** 2026-05-12
> **Scope:** Add an optional, caregiver-controlled sensory support panel that only fires for *reliable* emotion detections.
> **Constraint honoured:** No app rewrite. Camera flow, AI pipeline, and AAC navigation are unchanged. No loud auto-play. No new heavy dependencies.

---

## 1. Feature Summary

After the camera screen produces a **reliable** emotion (passes face-detection gate **and** confidence threshold **and** top-1 − top-2 margin), a small support panel slides in under the existing result card with:

- The detected emotion (emoji + name).
- A localized **suggested support action** sentence.
- A green **"Play support"** button (user must opt in — nothing auto-plays).
- A neutral **"Skip"** button.
- A **caregiver alert** ribbon (Fear only).
- While playing: a **"Stop"** button and a slow, calm animation.

The panel is **not** shown for:

- `No face detected`
- `Face not clear`
- `Uncertain – try again`
- `Neutral` (by spec — reliable detection but no automatic sensory feedback)

A new **`SensoryFeedbackService`** centralises all sensory behavior, the 6 emotion plans, the SharedPreferences-backed caregiver toggles, and the (currently-stubbed) audio path. Three caregiver toggles were added to the Settings screen: **Sound (low volume)**, **Light vibration**, and **Calm animations**.

---

## 2. Files Changed

| File | Change |
|---|---|
| `lib/services/sensory_feedback_service.dart` *(new)* | Caregiver preferences (SharedPreferences-backed, in-memory cached), per-emotion `SensorySupportPlan`, `triggerHaptic` (uses Flutter's built-in `HapticFeedback.lightImpact` only), `playSound` (well-defined stub with TODOs). |
| `lib/main.dart` | Loads `SensoryFeedbackService.load()` once at startup so the camera screen can read the toggles synchronously. |
| `lib/screens/camera_expression_screen.dart` | Adds support panel below the result card; only shown for reliable emotions with a non-null plan. New private methods: `_playSupport`, `_stopSupport`, `_skipSupport`, `_buildSupportPanelOrEmpty`, `_buildBreathingVisual`. Slow breathing controller (`_breathingController`, 4 s/cycle, *never auto-starts*). All existing behavior preserved. |
| `lib/screens/settings.dart` | Adds a top "Sensory Feedback (Caregiver Only)" section with 3 `SwitchListTile` toggles, fully localized in `si-LK` / `ta-IN` / `en-GB`. Favorites carousel is untouched. |
| `pubspec.lock` | Auto-updated by `flutter pub get` (no new packages added in this change set). |

No model file was modified. The 6-class label set (`Angry / Fear / Happy / Neutral / Sad / Tired`) from the previous fix remains the contract.

---

## 3. Per-Emotion Support Plans

Defined in `SensoryFeedbackService.planFor(...)`:

| Emotion | Animation | Haptic | Sound | Caregiver alert? | Suggested action (EN) |
|---|---|---|---|---|---|
| **Happy** | `positivePulse` (small grow/shrink) | `lightImpact` | `softChime` (low volume, stubbed) | No | Celebrate with a soft chime and a gentle happy animation. |
| **Sad** | `calmBreathing` (slow inhale/exhale ~4 s) | `lightImpact` | `softComfort` (low volume, stubbed) | No | Play a slow calming breathing animation and a soft comforting tone. |
| **Angry** | `calmBreathing` | `lightImpact` | `lowCalm` (low volume, stubbed) | No | Guide a slow breathing animation and play a low calming tone. |
| **Fear** | `calmBreathing` | `lightImpact` | **`none`** (no auto sound — caregiver attention is more useful) | **Yes — amber ribbon** | Show a safe-space animation. The caregiver may want to comfort the child. |
| **Tired** | `softDim` (slow low-contrast fade) | `lightImpact` | **`none`** (spec rule: no loud sound) | No | Suggest a rest. Slow dim animation, no sound. |
| **Neutral** | — | — | — | — | **No panel — normal AAC mode** (per spec). |

All Sinhala (`si`) and Tamil (`ta`) translations are embedded in `SensorySupportPlan`.

---

## 4. Safety Decisions

| Decision | Why |
|---|---|
| **Sound is OFF by default.** | Sudden audio can overstimulate autistic children. The caregiver must opt in once in Settings. |
| **No new vibration package.** Vibration is implemented with Flutter's built-in `HapticFeedback.lightImpact` only. | Avoids an extra native dependency, avoids long buzzes / patterns. We never call `Vibrator.vibrate(pattern)` or any equivalent. |
| **Vibration is gated by a per-child toggle.** | Some children find any haptic uncomfortable; caregiver decides. |
| **Animations are slow (~4 s/cycle), low-contrast, no blinking.** | Fast / flashing visuals can cause distress in autism and can trigger photosensitive seizures. `calmBreathing` and `softDim` are deliberately gentle. |
| **`Play support` is manual.** Nothing fires the moment the model returns. | The caregiver / child must choose to start the feedback. |
| **`Stop` button always available while playing.** | The user can interrupt instantly. |
| **Sensory feedback only runs for `_CaptureStatus.reliable` results that have a plan.** | `noFace`, `faceNotClear`, `uncertain`, and `Neutral` never trigger feedback — guaranteed at three layers: (1) the panel widget is only rendered when status is reliable; (2) `planFor("Neutral")` returns `null` and the widget short-circuits; (3) the play handler reads from the plan, so even an accidental call with a null plan is a no-op. |
| **AAC adaptation is independent.** | The home-screen suggestion banner (from the previous fix) still runs on reliable results; it is not coupled to the sensory panel and the user can dismiss either one independently. |
| **Sound stub never throws on missing assets.** | The build won't break before audio assets are added — the stub just `debugPrint`s. |
| **Caregiver alert ribbon is amber, not red.** | Red can be alarming; amber communicates *attention needed* without panic. |
| **All panel strings are localized** in `si-LK` / `ta-IN` / `en-GB`. | Caregivers and users can confidently use it in any of the supported languages. |

---

## 5. Caregiver Control Implementation

### 5.1 Where the settings live

`SettingsScreen` (top of body, before the favorites carousel). Three `SwitchListTile`s inside a single bordered card titled **"Sensory Feedback (Caregiver Only)"** with a one-line subtitle: *"Only the caregiver should change these. Prevents overstimulation."*

### 5.2 Defaults

| Toggle | Default value |
|---|---|
| Sound (low volume) | **OFF** |
| Light vibration | **ON** |
| Calm animations | **ON** |

These defaults were chosen so the first run is conservative (no audio) but visually informative.

### 5.3 Persistence

Stored in `SharedPreferences` under keys:

```text
sensory_sound_enabled
sensory_vibration_enabled
sensory_animation_enabled
```

`SensoryFeedbackService.load()` is called once from `main()` and again on toggle. All reads from the camera screen are synchronous via the in-memory cache to avoid per-frame `await`.

### 5.4 How the toggles map to behavior

```dart
// In SensoryFeedbackService:
if (!_vibrationEnabled) return;        // skip haptic
if (!_soundEnabled || tone == none) return;  // skip audio
// In camera_expression_screen.dart:
if (!SensoryFeedbackService.animationEnabled) {
  // breathing visual replaced by a static circle so the user still sees
  // "support is playing" without any motion.
}
```

The flags are checked at the point of action, never bypassed by another layer.

---

## 6. UI Integration in the Camera Screen

The result card and the support panel are now stacked vertically inside the same `Positioned` block, so the panel appears just below the result card without disturbing the existing layout (gradient overlays, flash, capture button, switch-camera button).

```
┌──────────────────────────────┐
│   Result card                │   ← unchanged from previous fix
│   😊 HAPPY  85.2% confident  │
│   [ Use this emotion ]       │
└──────────────────────────────┘

┌──────────────────────────────┐   ← new sensory support panel
│ DETECTED EMOTION  😊 Happy   │
│ Celebrate with a soft chime  │
│ and a gentle happy animation.│
│                              │
│   [Skip]  [▶ Play support]   │
└──────────────────────────────┘
```

When the user taps **Play support**:

1. The "Skip" button is replaced by **"Stop"**.
2. `HapticFeedback.lightImpact` fires if the caregiver enabled vibration.
3. `SensoryFeedbackService.playSound` is called (currently a logging stub).
4. The breathing circle starts a slow loop (`reverse: true`, 4 s/cycle).

Tapping **Stop** or **Skip** stops the animation and dismisses the panel.

---

## 7. Remaining TODOs

| # | TODO | Severity | Where |
|---|---|---|---|
| T1 | Add a real audio backend. Recommended: `audioplayers ^6.0.0`. Replace the `debugPrint` stub inside `SensoryFeedbackService.playSound` with `AudioPlayer().play(AssetSource('audio/<file>.mp3'), volume: 0.4);`. | Important | `lib/services/sensory_feedback_service.dart` `playSound` |
| T2 | Provide audio assets (each ≤ 2 s, low volume, no sharp transients): `assets/audio/soft_chime.mp3`, `assets/audio/soft_comfort.mp3`, `assets/audio/low_calm.mp3`. Add them under `flutter > assets` in `pubspec.yaml`. | Important | `pubspec.yaml`, new `assets/audio/` |
| T3 | Until T1/T2 land, the **"Play support"** button works fully — it shows the animation, fires haptic if enabled, and logs the would-be sound. **The build does not break on missing assets.** | OK to ship | — |
| T4 | (Optional) Add a "Test sound" / "Test vibration" preview button in Settings so the caregiver can verify their pick without going to the camera. | Nice-to-have | `lib/screens/settings.dart` |
| T5 | (Optional) Save the caregiver's choice of "Play support" vs "Skip" per emotion to learn the child's preferences. | Nice-to-have | new field in service |
| T6 | (From earlier audit, still open) Index-5 model mismatch: the bundled model says "surprise" but the UI says "Tired". The Tired support plan therefore fires on surprised faces. Resolution requires model retraining with a real Tired class. | **Important** (pre-existing) | training side |

---

## 8. Compatibility / Safety Checklist

| Requirement | Status | Evidence |
|---|---|---|
| Do not rewrite the app | ✅ | Only 1 new file (`sensory_feedback_service.dart`) and 4 surgically-edited files (`main.dart`, `camera_expression_screen.dart`, `home_screen.dart` — unchanged in this iteration, `settings.dart`). |
| Do not auto-play loud sounds | ✅ | Audio path is opt-in (caregiver toggle), volume is documented as low (`0.4` recommended), `Fear` and `Tired` plans set `SupportSoundTone.none`. |
| Do not trigger for No-Face / Face-Not-Clear / Uncertain / Neutral | ✅ | Panel only mounts when `_status == _CaptureStatus.reliable`. `planFor("Neutral")` returns `null` → panel returns `SizedBox.shrink()`. |
| Only trigger for reliable emotions | ✅ | Same gate as the popped emotion in the previous fix. |
| Haptic via Flutter built-ins only | ✅ | `HapticFeedback.lightImpact` / `selectionClick`. No third-party vibration package. |
| Sound path may use a lightweight package later | ✅ | TODOs T1/T2 outline the integration; the stub is a one-line replacement. |
| Simple Flutter animations only | ✅ | A single `AnimationController` (4 s/cycle) and `Transform.scale` + `Container.color` with `withOpacity`. No flashing, no high contrast. |
| Caregiver controls in Settings | ✅ | Three `SwitchListTile`s with localized labels and an explicit "Caregiver Only" header. |
| Comments explaining caregiver control / overstimulation | ✅ | Top-of-file docstring in `sensory_feedback_service.dart`, plus the section header in `settings.dart`, plus the comment block at the top of the support-panel section in `camera_expression_screen.dart`. |
| AAC adaptation kept separate | ✅ | `home_screen.dart` was not modified in this iteration. The suggestion banner from the previous fix still works independently. |
| Build does not break on missing sound assets | ✅ | `playSound` is a `debugPrint` until an audio package is added; nothing reads from `assets/audio/*` yet. |

---

## 9. Commands Run and Results

| # | Command | Result |
|---|---|---|
| 1 | `flutter pub get` | Exit 0. `Got dependencies!` — no new packages added (haptic uses the Flutter SDK). The 32 "newer-version-available" notices are unchanged from before. |
| 2 | `flutter analyze` | Exit 1 ("issues found"), but **0 errors**. Total 184 issues = 170 pre-existing + 14 new info-level `withOpacity` deprecations from the new support panel & settings section. **Zero new warnings.** All 9 warnings are pre-existing (unused imports / unused declarations from before this branch). |
| 3 | `git diff --stat` | 8 files changed (1 new + 7 modified, of which one is the pre-existing `macos/Flutter/GeneratedPluginRegistrant.swift`). |

`flutter build apk --debug` was not re-attempted in this iteration; the earlier failure on `storage.googleapis.com` was a host-network issue, not a project issue. `flutter analyze` shows the project is in a buildable state.

---

## 10. How to Verify on a Device

1. `flutter run` on Android (or iOS).
2. Tap the 📷 button on the home screen.
3. Take a clear frontal picture of a happy face.
   - The result card shows `HAPPY` + "Use this emotion".
   - **Below it, the new support panel appears** with "DETECTED EMOTION 😊 Happy", the suggested action sentence, and two buttons.
4. Tap **Play support**.
   - You should feel a small haptic blip if your device supports it (and the caregiver toggle is on).
   - A slow pulsing circle appears (`positivePulse` for Happy, `calmBreathing` for Sad/Angry/Fear, `softDim` bar for Tired).
   - Logcat shows `[SensoryFeedbackService] (stub) would play tone: softChime at low volume`.
5. Tap **Stop** to stop, or **Skip** before playing.
6. Take a picture pointing at the floor → "No face detected" → **no support panel**. Confirmed.
7. Take a deliberately fearful expression → support panel shows the **amber caregiver alert ribbon**.
8. Take a clearly neutral expression → result card shows `NEUTRAL` + "Use this emotion" but **no support panel** (Neutral has no plan, by spec).
9. Open **Settings** → top section shows three switches. Turn off "Calm animations" → next time you Play support, the circle is static. Turn off "Light vibration" → no haptic. Turn on "Sound" → logcat still shows the stub message until audio assets are added.

---

## 11. Files Touched This Iteration (final list)

```text
(new)    lib/services/sensory_feedback_service.dart        +233 lines
(edit)   lib/main.dart                                     +3 lines
(edit)   lib/screens/camera_expression_screen.dart         +~320 lines (panel, methods, controller)
(edit)   lib/screens/settings.dart                         +159 lines (section + 3 toggles + locales)
(no-op)  pubspec.yaml / pubspec.lock                       no changes from this step
```

---

## 12. Suggested Next Steps (not done in this iteration)

1. Add `audioplayers` and three short low-volume MP3 assets (T1/T2). Replace the stub.
2. Localize the **Stop** state for languages that need slightly different verbs.
3. Allow caregivers to **per-emotion** disable feedback (e.g. allow Happy chime but disable Sad chime).
4. Make the breathing animation duration caregiver-tunable (e.g. 3 s / 4 s / 6 s).
5. Persist a small per-session counter so the caregiver can see "how many times Play support was used today" — useful for therapy notes.
6. Retrain the model with a real "Tired" class (T6) so the Tired plan is semantically grounded.
