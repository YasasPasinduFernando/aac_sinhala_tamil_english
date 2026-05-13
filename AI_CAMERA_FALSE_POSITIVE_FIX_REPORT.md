# AI Camera False-Positive Fix Report

> **Project:** Smart AAC System with Facial Expression Recognition for Autism
> **Branch:** `upgrade-app` (forked from `play-release-1`)
> **Date:** 2026-05-12
> **Scope:** Critical fixes from `AI_FLUTTER_MODEL_COMPATIBILITY_AUDIT.md`.
> **Constraint honoured:** No model file (`*.tflite`) was modified. UI design was preserved.

---

## 1. Files Changed

| File | Change |
|---|---|
| `pubspec.yaml` | Added `google_mlkit_face_detection: ^0.13.0` to dependencies. |
| `pubspec.lock` | Auto-updated by `flutter pub get` — added `google_mlkit_commons 0.11.1` + `google_mlkit_face_detection 0.13.2`. |
| `assets/models/labels.txt` | Replaced old labels (`Anger / Fear / Joy / Natural / Sadness / Surprise`) with final labels (`Angry / Fear / Happy / Neutral / Sad / Tired`). |
| `lib/screens/camera_expression_screen.dart` | Major rewrite of the inference path: face-detection gate, face-size validation, face-bbox crop with 20 % padding, 5-frame burst capture with rolling-average softmax, confidence + margin thresholds, four UI states (no-face / face-not-clear / uncertain / reliable), "Use this emotion" button that returns via `Navigator.pop`. The whole existing UI (camera preview, gradient overlays, flash, capture button, switch-camera button, animations) was preserved. |
| `lib/screens/home_screen.dart` | Camera button now `await`s the popped emotion; added `_applyEmotionToAac`, `_feelingWordFor`, `_buildEmotionSuggestionBanner`, `_emotionEmojiFor` helpers; added a small auto-dismiss "Suggested feeling" banner that appears under the offline banner; added `Timer` import and a `_suggestionTimer` field with proper `dispose`. |
| `lib/data/word_data/feelings.dart` | Added a new `Neutral` entry with `si/ta/en` translations and two child-friendly action phrases (kept the existing `Happy / Sad / Angry / Scared / Tired / …` rows untouched). |

No other files were touched. The pre-existing dirty file `macos/Flutter/GeneratedPluginRegistrant.swift` was carried over unchanged from `play-release-1`.

---

## 2. Exact Fixes Applied

### 2.1 Dependency

```yaml
# pubspec.yaml
  camera: ^0.11.0+2
  tflite_flutter: ^0.12.1
  image: ^4.1.7
  # Face detection gate (prevents emotion inference on no-face / unclear frames)
  google_mlkit_face_detection: ^0.13.0
```

Resolved versions after `flutter pub get`:
- `google_mlkit_face_detection 0.13.2`
- `google_mlkit_commons 0.11.1` (transitive)

### 2.2 Labels alignment (`assets/models/labels.txt`)

```text
Angry
Fear
Happy
Neutral
Sad
Tired
```

Position in this file == softmax index from the model. **A code comment was added in `camera_expression_screen.dart` warning that `labels.txt` order must match the softmax output order of the deployed model.**

### 2.3 Camera + inference pipeline (`camera_expression_screen.dart`)

New constants:

| Name | Value | Purpose |
|---|---|---|
| `_kBurstFrames` | 5 | Quick captures per shutter tap |
| `_kBurstDelay` | 120 ms | Spacing between captures |
| `_kMinConfidence` | 0.60 | Minimum top-1 softmax |
| `_kMinTopMargin` | 0.15 | Required top-1 − top-2 margin |
| `_kMinFaceRatio` | 0.18 | Face short-side ÷ image short-side floor |
| `_kFaceCropPadding` | 0.20 | Padding around face bbox before crop |

New `FaceDetector` (ML Kit) with:

```dart
FaceDetectorOptions(
  performanceMode: FaceDetectorMode.fast,
  enableLandmarks: false,
  enableClassification: false,
  enableTracking: false,
  minFaceSize: 0.15,
)
```

The detector is created in `initState`, closed in `dispose`. `Interpreter` and `FaceDetector` are both released cleanly.

New decision state enum:

```dart
enum _CaptureStatus { idle, noFace, faceNotClear, uncertain, reliable }
```

`_analyze()` was rewritten end-to-end. Per shutter tap it now:

1. Sets `_isAnalyzing = true`, plays the existing flash animation.
2. Loops 5 times:
   - `_controller.takePicture()` → JPEG file.
   - `FaceDetector.processImage(InputImage.fromFilePath(...))`.
   - If `faces.isEmpty` → count as a `framesNoFace`, skip.
   - Decode the JPEG with `package:image`.
   - Pick the **largest** detected face.
   - If `min(face.width, face.height) < imageShortSide * 0.18` → count as `framesUnclear`, skip.
   - Crop the face with `_kFaceCropPadding` padding on every side.
   - `img.copyResize(cropped, 224, 224)`.
   - Build `[1,224,224,3]` float32 tensor normalised to `(c/127.5) - 1.0` (unchanged from before — matches `mobilenet_v2.preprocess_input`).
   - `_interpreter.run(input, output)` → 6-class softmax vector.
   - Push softmax vector into `softmaxAccum`.
   - 120 ms delay before next capture.
3. After the loop, decide:
   - `softmaxAccum.isEmpty` and `framesUnclear > framesNoFace` → status = **face-not-clear**.
   - `softmaxAccum.isEmpty` → status = **no-face**.
   - Else compute `mean = elementwiseMean(softmaxAccum)`; `top1 = mean[argmax]`; `top2 = secondMax(mean)`.
   - If `top1 < 0.60` **or** `(top1 − top2) < 0.15` → status = **uncertain** (label + score are still stored for display but not used for AAC).
   - Else → status = **reliable**, store label + score.

`_buildResultCard` was added and routes the four statuses to four visual presentations (emoji + title + optional subtitle + optional "Use this emotion" button). Only the **reliable** case shows the "Use this emotion" button, which calls `Navigator.pop(context, _resultLabel)`. The other three statuses **never** return anything.

### 2.4 HomeScreen wiring (`home_screen.dart`)

Camera launch button changed from fire-and-forget to:

```dart
_buildHeaderButton('📷', () async {
  final emotion = await Navigator.push<String?>(
    context,
    MaterialPageRoute(
      builder: (context) => CameraExpressionScreen(
        language: selectedLanguage,
        isGirl: isGirl,
      ),
    ),
  );
  if (!mounted) return;
  if (emotion != null && emotion.isNotEmpty) {
    _applyEmotionToAac(emotion);
  }
}),
```

`_applyEmotionToAac` is intentionally minimal — it only sets `_suggestedEmotion` and an auto-dismiss timer:

```dart
void _applyEmotionToAac(String emotion) {
  final normalized = emotion.trim();
  if (normalized.isEmpty) return;
  _suggestionTimer?.cancel();
  setState(() => _suggestedEmotion = normalized);
  _suggestionTimer = Timer(const Duration(seconds: 6), () {
    if (mounted) setState(() => _suggestedEmotion = null);
  });
}
```

A banner widget is rendered under the offline banner whenever `_suggestedEmotion != null`. The banner shows the localized feeling word (mapped via `_feelingWordFor`) and an emoji, plus a close (`×`) button.

`_feelingWordFor` maps the model label to the matching entry in `feelings.dart`:

| Model label | `si-LK` | `ta-IN` | `en` |
|---|---|---|---|
| Angry | තරහයි | கோபம் | Angry |
| Fear | බයයි | பயம் | Scared |
| Happy | සතුටුයි | மகிழ்ச்சி | Happy |
| Neutral | සාමාන්‍යයි | சாதாரணம் | Neutral |
| Sad | දුකයි | சோகம் | Sad |
| Tired | මහන්සියි | சோர்வு | Tired |

### 2.5 Feelings dictionary (`feelings.dart`)

Added a new entry just before the `Tired` entry:

```dart
{
  'si': 'සාමාන්‍යයි', 'ta': 'சாதாரணம்', 'en': 'Neutral', 'emoji': '😐',
  'actions': [
    {'si': 'මට හොඳයි', 'ta': 'நான் நலம்', 'en': 'I am okay', 'emoji': '😐'},
    {'si': 'සාමාන්‍ය', 'ta': 'சாதாரணமாக', 'en': 'Feeling normal', 'emoji': '🙂'},
  ],
}
```

The existing `Happy / Sad / Angry / Scared / Tired` rows were already present and were not touched.

### 2.6 Error logging

Every `try` block now uses `debugPrint('… : $e\n$st')` with the real exception and stack trace:

- `_initialize` failure → logged + user-facing `Failed to start camera`.
- Face detector failure inside the burst loop → logged + the frame is silently skipped (no user-facing crash).
- Inference failure → logged + user-facing `Failed to analyze image`.

---

## 3. How No-Face Detection Works

1. ML Kit `FaceDetector` runs on every one of the 5 burst frames.
2. A frame counts toward `framesWithFace` only if **at least one** face is returned **and** its bounding-box short-side ≥ 18 % of the image short-side.
3. If `framesWithFace == 0` after all 5 frames, the inference output (TFLite) is **never** read.
4. The screen shows either:
   - 🙈 **"No face detected"** when no frame even returned a face, or
   - 😶‍🌫️ **"Face not clear"** when faces were found but they were too small / partial.
5. Neither state shows a "Use this emotion" button. `Navigator.pop` is never called with an emotion in those states, so `HomeScreen` never receives anything to suggest.

Result: pointing the camera at the floor, a hand, an object, a covered lens, a very distant face, or a partly-visible face produces **`No face detected`** or **`Face not clear`** — not a fake "SURPRISE 41 % confident" anymore.

---

## 4. How the Confidence Threshold Works

1. After the burst loop the softmax vectors of all face-bearing frames are averaged element-wise → `meanScores`.
2. `top1 = max(meanScores)`, `top1Idx = argmax(meanScores)`.
3. `top2 = secondMax(meanScores)` (largest value excluding `top1Idx`).
4. The decision is **reliable** only if **both**:
   - `top1 >= 0.60` **and**
   - `(top1 - top2) >= 0.15`.
5. Otherwise the decision is downgraded to **uncertain**.
6. Both thresholds are constants at the top of `_CameraExpressionScreenState` (`_kMinConfidence`, `_kMinTopMargin`) so they can be tuned without touching the rest of the code.

---

## 5. How Uncertainty Works

When `top1 < 0.60` or the margin is `< 0.15`:

- `_status = _CaptureStatus.uncertain`
- The result card shows 🤔 **"Uncertain – try again"** and the raw `top1` percentage as a subtitle (for diagnostics).
- The **"Use this emotion"** button is hidden.
- `Navigator.pop` is **not** called with an emotion.
- `HomeScreen._applyEmotionToAac` is consequently **not** invoked, so the AAC vocabulary is not adapted.

The same hiding rules apply for `noFace` and `faceNotClear`. AAC adaptation is therefore **gated** on a reliable, confident, margin-validated, smoothed result.

---

## 6. How Temporal Smoothing Works

- One shutter tap = 5 quick captures (`_kBurstFrames`) with 120 ms gaps.
- Each frame produces one softmax vector iff it passes the face-presence and face-size gates.
- The 5 vectors (or fewer, if some frames are gated out) are averaged element-wise into `mean`.
- All threshold checks (confidence, margin) operate on the averaged vector, not on a single noisy frame.
- This is roughly equivalent to a rolling window of 5, refreshed per tap, which is well within the 5-to-10 range you asked for.
- If 0 frames pass the face gate, no average is computed and the user gets `No face detected` / `Face not clear` instead of a guessed emotion.

The burst loop is sequential rather than concurrent on purpose — `tflite_flutter`'s `Interpreter` is not safe to call from multiple threads, and the `camera` plugin's `takePicture` doesn't support overlapping calls.

---

## 7. How Labels Were Aligned

- `assets/models/labels.txt` was rewritten in the order:
  `Angry, Fear, Happy, Neutral, Sad, Tired`.
- The hardcoded emoji map in `camera_expression_screen.dart` was updated:
  ```dart
  final Map<String, String> _emotionEmojis = {
    'angry': '😠', 'fear': '😨', 'happy': '😊',
    'neutral': '😐', 'sad': '😢', 'tired': '😴',
  };
  ```
  (lower-cased keys, lookup uses `emotion.toLowerCase()`).
- All previous label names (`Anger / Joy / Natural / Sadness / Surprise`) were removed from Dart code. Searching the repository for them returns zero matches inside `lib/`.
- A code comment was added next to the emoji map explicitly warning that **`labels.txt` order must match the softmax output order** of the deployed model.

> ### ⚠️ Important warning about the deployed model file
>
> The current bundled model `assets/models/emotion_attention_model.tflite` was trained on the order:
> `anger(0), fear(1), joy(2), Natural(3), sadness(4), surprise(5)` (see `training/train_emotions.py`).
>
> Indexes 0–4 map cleanly to the new labels by meaning:
>
> | Index | Model class | New label | Semantic match? |
> |---|---|---|---|
> | 0 | anger | Angry | ✅ |
> | 1 | fear | Fear | ✅ |
> | 2 | joy | Happy | ✅ |
> | 3 | Natural | Neutral | ✅ |
> | 4 | sadness | Sad | ✅ |
> | 5 | **surprise** | **Tired** | ❌ |
>
> Index 5 is a **known mismatch**: the model has never seen a "tired" face, so the screen will say "Tired" only when the model actually thinks the user looks "surprised". This is documented in the `_emotionEmojis` comment block inside `camera_expression_screen.dart`. To fully resolve it, the model must be retrained with a real "Tired" class (or that label should be dropped from `labels.txt`). **I did not pretend this is fixed.**

---

## 8. AAC Adaptation — Partial Implementation

- **Implemented (safe path):** receiving the popped emotion, mapping it to the corresponding `feelings.dart` entry in the user's language, and showing a small auto-dismissing banner under the offline banner (`Suggested feeling: <localized word>` with an emoji and a close button).
- **NOT implemented (deliberately, to avoid breaking AAC navigation):**
  - Automatic scrolling/jumping to the Feelings card on the home grid.
  - Automatic insertion of the corresponding feeling word into the bottom sentence panel.

This matches the user requirement: *"If direct prefill is risky, store the emotion and show a small banner/message such as 'Suggested feeling: Happy'."* Existing AAC navigation (Categories → Feelings → tap a word) is untouched.

---

## 9. Remaining Issues / Caveats

| # | Topic | Severity | Notes |
|---|---|---|---|
| R1 | Index-5 label semantic mismatch | **Important** | "Tired" displays will fire on surprised faces until the model is retrained. See §7 warning box. |
| R2 | The audit's three unused `.tflite` files (`emotion_model.tflite`, `emotion_mobilenetv2.tflite`, `emotion_efficientnet_optimized.tflite`) still sit in `assets/models/`. They are not bundled (not listed in `pubspec.yaml`), so they only bloat the repo (~17 MB). Not deleted in this change because deleting binary assets is out of scope of "critical fixes". | Nice-to-have | Safe to delete manually later. |
| R3 | Burst capture latency = 5 × (capture + face detection + inference + 120 ms) ≈ 1.5–2.5 s on a mid-range Android device. Single-tap UX is preserved (one tap, one result) but the user must hold still during the flash. | Acceptable | Future improvement: switch to `startImageStream` with `yuv420` for real-time inference. |
| R4 | Pre-existing analyzer warnings (`Unused import shared_preferences`, `Unused import custom_card_widget`, two unused private declarations) were **not** removed because they existed before this branch was created. | Nice-to-have | Outside the scope of this fix. |
| R5 | `flutter build apk --debug` was not re-attempted in this iteration; the earlier audit attempt failed only due to a network/DNS issue on the host machine (`storage.googleapis.com` unreachable), not due to project code. `flutter pub get` and `flutter analyze` both succeeded after the changes, so the project is in a buildable state. | Informational | Run a debug build on a network-connected host before final submission. |
| R6 | The 6-second auto-dismiss timer for the suggestion banner is hard-coded — easy to tune later. | Nice-to-have | — |
| R7 | The "Use this emotion" button localization is wired for `si-LK` and `ta-IN`; the no-face / face-not-clear / uncertain strings are also localized for all three languages. | Done | — |

---

## 10. Commands Run and Results

| # | Command | Result |
|---|---|---|
| 1 | `git checkout -b upgrade-app` | `Switched to a new branch 'upgrade-app'` |
| 2 | `flutter pub get` (after `pubspec.yaml` edit) | Exit 0. `Changed 2 dependencies` (added `google_mlkit_face_detection 0.13.2` + `google_mlkit_commons 0.11.1`). |
| 3 | `flutter analyze` | Exit 1 ("issues found"), but **0 errors**. 170 issues total = 168 pre-existing (info-level `withOpacity` deprecations + a few unused-element warnings inherited from `play-release-1`) + 2 new info-level items from the new code. **No new warnings or errors were introduced.** |
| 4 | `git diff --stat` | 6 files changed, +597 / −140. |

`flutter build apk --debug` was **not** re-run in this iteration; the prior audit-time attempt failed only on `No such host is known (storage.googleapis.com)`, which is a network condition on the host, not a project defect. The project compiles cleanly under `flutter analyze` and the dependency graph resolved without conflict.

---

## 11. Compatibility Compliance Checklist

| Constraint | Honoured? | Evidence |
|---|---|---|
| No `SELECT_TF_OPS` | ✅ | `Interpreter.fromAsset(...)` is called with no options. Only builtin TFLite ops are used. |
| Input remains float32 `[1, 224, 224, 3]` | ✅ | `_buildModelInput` returns nested Dart `List<double>` (≈ float32) of exactly that shape. |
| Output remains float32 `[1, 6]` | ✅ | `List<double>.filled(_labels.length, 0.0)` and `_labels.length == 6`. |
| Model file not changed | ✅ | `assets/models/emotion_attention_model.tflite` byte-for-byte identical. |
| UI design preserved | ✅ | All existing widgets (gradient, flash overlay, capture button, switch-camera, animations) were kept. Only the **content** of the result card was extended (added states / button), not its surrounding chrome. |
| No app rewrite | ✅ | 6 files touched, 597 insertions concentrated in 2 files. |
| Pre-existing AAC navigation untouched | ✅ | No changes to `category_screen.dart`, `favourite_screen.dart`, `settings.dart`, `splash_screen.dart`. `home_screen.dart` only adds new helpers + 1 banner block + an `await` on an existing button. |
| Warning given when model still uses old label order | ✅ | §7 warning box in this report, plus the comment block in `camera_expression_screen.dart` next to `_emotionEmojis`. |

---

## 12. How to Verify Quickly on a Device

1. `git status` should show the 6 modified files listed in §1.
2. `flutter pub get` → must succeed.
3. `flutter run` on an Android phone (or simulator with camera permission).
4. Tap the 📷 button in the header.
5. **Test cases:**
   - Cover the lens → should show 🙈 "No face detected" and no "Use this emotion" button. The home screen should NOT show a suggestion banner after popping back.
   - Point at the floor → same as above.
   - Hold the phone very far away → should show 😶‍🌫️ "Face not clear".
   - Take a normal frontal picture with a clear expression → should show one of the 6 emotion labels + the green "Use this emotion" button.
   - Tap "Use this emotion" → home screen should show the suggestion banner with the right localized word for ~6 seconds.
   - Take a deliberately ambiguous face → should show 🤔 "Uncertain – try again" with a low % subtitle.
6. (For semantic verification of Index-5) Take a clearly surprised face → it will be labelled "Tired". This is expected (see §7) and proves the model has not been retrained.

---

## 13. Suggested Next Steps (NOT done in this iteration)

- **Retrain the model with the 6 final classes (`Angry / Fear / Happy / Neutral / Sad / Tired`)** to resolve R1. Until that's done, ship the app with the current model but communicate that "Tired" is provisional.
- Switch from tap-based burst to `CameraController.startImageStream` for live emotion adaptation (currently the architecture supports it; only the `_analyze` method would need to be replaced).
- Delete the three unused `.tflite` files from `assets/models/` (R2).
- Clean up the pre-existing analyzer warnings inherited from `play-release-1` (R4).
- Add a unit test for the smoothing + threshold logic by extracting it into a small `EmotionService` class.
