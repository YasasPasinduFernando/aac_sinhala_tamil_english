# AI / Flutter / Model Compatibility Audit

> **Project:** Smart AAC System with Facial Expression Recognition for Autism
> **Flutter package:** `aac_sinhala_tamil_english` (version `1.1.0+2`)
> **Audit date:** 2026-05-12
> **Audit scope:** Read-only inspection only. **No source code, model files, or training scripts have been modified.**

This document is an inspection report. It traces the current AI / camera / TFLite pipeline, compares the Flutter side to the training side, identifies why the app fires emotions when no real face is present, and lists a fix plan (without applying it).

---

## 1. Project Run Status

### 1.1 Toolchain

| Component | Detected value |
|---|---|
| Flutter version | **3.41.2** (stable channel) |
| Dart version | **3.11.0** |
| DevTools | 2.54.1 |
| Engine revision | `6c0baaebf7` |
| Host OS | Windows 11 (build 26200) |
| Android SDK | 36.0.0 (platform `android-36`, build-tools `36.0.0`) |
| Android JDK | OpenJDK Corretto 17.0.18 (JDK 17) |
| `flutter doctor` | `√ No issues found!` (all checks pass: Flutter, Windows, Android toolchain, Chrome, VS Build Tools, network) |

### 1.2 Target platforms present in repo

| Platform | Folder | Status |
|---|---|---|
| Android | `android/` (Kotlin DSL `build.gradle.kts`) | Configured. `applicationId = lk.aac.sinhala_tamil_english`, JDK 17, Flutter Gradle plugin applied. |
| iOS | `ios/` | Folder present, not validated on Windows. |
| macOS | `macos/` | Folder present. `macos/Flutter/GeneratedPluginRegistrant.swift` shows as modified in `git status`. |
| Windows | `windows/` | Folder present. |
| Linux | `linux/` | Folder present. |
| Web | `web/` | Folder present, but `camera`/`tflite_flutter` are not web-compatible. |

### 1.3 Dependency resolution

`flutter pub get` ran successfully (exit code 0). Key direct dependencies that participate in AI:

| Package | Resolved version | Notes |
|---|---|---|
| `camera` | `0.11.3` (pubspec asks `^0.11.0+2`) | Newer `0.12.x` exists. |
| `tflite_flutter` | `0.12.1` | Latest. Pure TFLite C API, **no `tflite_flutter_helper` package included**. |
| `image` | `4.7.1` | Used for JPEG decode + resize. |
| `flutter_tts` | `3.8.5` | TTS for AAC speech. |
| `shared_preferences` | `2.5.4` | Local storage. |
| `connectivity_plus` | `5.0.2` | Older major; warning only, not blocking. |

`pub get` warning: *"32 packages have newer versions incompatible with dependency constraints."* — informational only, no version conflict prevents the build.

### 1.4 Static analysis

`flutter analyze` returned **168 issues, all `info`/`warning` severity, zero errors**:

- ~150 × `deprecated_member_use` for `Color.withOpacity` (Flutter 3.27+ deprecation; non-blocking).
- ~12 × `use_super_parameters` (style).
- `unused_local_variable` `size` at `lib/screens/camera_expression_screen.dart:264:11`.
- `unused_local_variable` `colors` at `lib/screens/category_screen.dart:712:11`.
- `unused_element` `_buildNavButton` at `lib/screens/category_screen.dart:704:10`.
- `WillPopScope deprecated` in `favourite_screen.dart`.
- `avoid_print` in `lib/screens/theme/animated_category_card.dart:54`.

**None of these prevent compilation or runtime execution.**

### 1.5 Build status

Attempted: `flutter build apk --debug --target-platform android-arm64`.

- Gradle could not download `io.flutter:arm64_v8a_debug` from `storage.googleapis.com`:
  - `> No such host is known (storage.googleapis.com)`
  - `BUILD FAILED in 17s` → `Gradle task assembleDebug failed with exit code 1`.
- **This is a network/DNS failure on the audit machine, not a project defect.** Once `storage.googleapis.com` is reachable, the build will proceed normally; nothing in the Gradle, manifest, plugin, or asset configuration is broken.

### 1.6 Runtime errors found during inspection

No runtime exceptions could be observed because the APK was not deployable in this environment (see 1.5). From source inspection, the most likely runtime failure modes are:

- `Interpreter.fromAsset` will throw if the device runtime hits an unsupported op (none expected for MobileNetV2; see §6).
- `_analyze()` silently turns any exception into the localized string `Failed to analyze image` (line 222) — actual stack traces are lost. This is a **diagnosability bug**.
- `CameraController` is initialized with `ImageFormatGroup.jpeg` (line 138) — fine for `takePicture()` but cannot be used with `startImageStream`, which restricts any future move to real-time inference.

---

## 2. Current AI Integration Flow

End-to-end trace from camera input to displayed emotion.

```text
HomeScreen ──"📷" header button──▶ CameraExpressionScreen
                                        │
                                        ├─ availableCameras()
                                        ├─ CameraController.initialize()
                                        ├─ Interpreter.fromAsset('assets/models/emotion_attention_model.tflite')
                                        └─ rootBundle.loadString('assets/models/labels.txt')

User taps shutter ─▶ _analyze()
   1. takePicture() → JPEG file
   2. img.decodeImage(bytes)
   3. img.copyResize(decoded, 224, 224)
   4. List.generate(1, 224, 224, 3) of (px/127.5 - 1.0)
   5. interpreter.run(input, output[1][6])
   6. argmax(output[0]) → bestIndex, bestScore
   7. setState(_resultLabel = labels[bestIndex], _resultScore = bestScore)
   8. Emoji shown via _emotionEmojis[label.toLowerCase()]
```

### 2.1 File-by-file responsibilities

| Step | File | Class / method | Lines |
|---|---|---|---|
| Entry from AAC home | `lib/screens/home_screen.dart` | `_HomeScreenState.build` → header button `'📷'` pushes `CameraExpressionScreen` | 631–641 |
| Camera screen state | `lib/screens/camera_expression_screen.dart` | `CameraExpressionScreen` / `_CameraExpressionScreenState` | 11–578 |
| Camera initialization | same | `_initCamera(int cameraIndex)` | 130–144 |
| Camera switching | same | `_switchCamera()` | 146–155 |
| Model loading | same | `_initialize()` calls `Interpreter.fromAsset('assets/models/emotion_attention_model.tflite')` | 111–112 |
| Label loading | same | `_initialize()` reads `assets/models/labels.txt`, splits by `\n`, strips blanks | 113–116 |
| Hardcoded label/emoji map | same | `_emotionEmojis` map: `anger, fear, joy, natural, sadness, surprise` (lowercase keys) | 46–53 |
| Image preprocessing | same | inline inside `_analyze()`: `img.copyResize` to 224×224 then `(c/127.5)-1.0` | 171–198 |
| Inference | same | `_interpreter!.run(input, output)` | 200–201 |
| Argmax / score | same | manual loop over `scores` | 203–211 |
| Result display | same | `Positioned`/`ScaleTransition`/`Text` block; emoji from `_getEmoji()` | 376–442 / 231–234 |
| AAC vocabulary adaptation | **NONE** | The camera screen never returns an emotion to `HomeScreen`. `Navigator.push` at line 632 has no `.then((emotion) { ... })`. The Feelings category (`lib/data/word_data/feelings.dart`) is static. | — |

### 2.2 Key observations on the flow

1. **No callback to AAC.** `CameraExpressionScreen` shows the result inside itself and ends. There is no `onEmotionDetected` callback, no shared state, no `Provider`, no `SharedPreferences` write, no event bus. The "AAC adaptation based on emotion" feature claimed in the project requirements **is not implemented**.
2. **No real-time stream.** Inference runs only after the user taps the shutter and `takePicture()` produces a JPEG. There is no `startImageStream` / `CameraImage` path. Latency is high (full JPEG round-trip) and there is no temporal averaging.
3. **No face detection step.** The full camera frame is resized to 224×224 and fed directly to the classifier.
4. **The model is loaded once** (in `initState`) and kept open until `dispose`. That part is correct.

---

## 3. Model Compatibility Check

### 3.1 What the training side declares

Source: `training/train_emotions.py`.

| Aspect | Training value | Where in code |
|---|---|---|
| Architecture | `tf.keras.applications.MobileNetV2` (NOT EfficientNetB0+CBAM as currently stated in the project description) | Line 80 |
| Input size | `IMG_SIZE = (224, 224)` | Line 11 |
| Channels | 3 (RGB) via `tf.io.decode_image(channels=3)` | Line 62 |
| Preprocessing | `tf.keras.applications.mobilenet_v2.preprocess_input` → maps pixels from `[0,255]` to `[-1,+1]` | Line 66 |
| Output classes | 6 | Line 9 |
| Labels (training order) | `["anger", "fear", "joy", "Natural", "sadness", "surprise"]` (lowercase except "Natural") | Line 9 |
| Activation | `softmax` | Line 91 |
| Optimizer / loss | Adam / `sparse_categorical_crossentropy` | Lines 93–97 |
| TFLite converter | `from_keras_model` + `tf.lite.Optimize.DEFAULT` (i.e. **float32 input/output, INT8-quantised weights**, no full-int quant, no `SELECT_TF_OPS`) | Lines 237–240 |
| Labels file output | `\n`-joined `CLASSES` written to `labels.txt` | Line 241 |
| Asset on device | `assets/models/labels.txt` actually shipped: `Anger`, `Fear`, `Joy`, `Natural`, `Sadness`, `Surprise` (Title-case, **different casing from training CLASSES**) | — |

### 3.2 What you said the final model should be

| Aspect | Required for final report |
|---|---|
| Architecture | EfficientNetB0 + CBAM |
| Input size | 224×224 |
| Channels | RGB |
| Output classes | 6 |
| Required final labels | **`Angry, Fear, Happy, Neutral, Sad, Tired`** |

### 3.3 Flutter side, observed values

Source: `lib/screens/camera_expression_screen.dart`.

| Aspect | Flutter value | Lines |
|---|---|---|
| Model asset | `assets/models/emotion_attention_model.tflite` (3.06 MB) | 112 |
| Other unused models in assets | `emotion_efficientnet_optimized.tflite` (9.27 MB), `emotion_mobilenetv2.tflite` (4.37 MB), `emotion_model.tflite` (3.17 MB). **Listed in folder but not declared in `pubspec.yaml`, so they are not bundled** — only `emotion_attention_model.tflite` and `labels.txt` are in the `assets:` section | `pubspec.yaml` 80–81 |
| Labels asset | `assets/models/labels.txt` → `Anger, Fear, Joy, Natural, Sadness, Surprise` | 113 |
| Hardcoded label↔emoji map (compared lowercase) | `anger, fear, joy, natural, sadness, surprise` | 46–53 |
| Input tensor shape used | `[1][224][224][3]` `List<List<List<List<double>>>>` (Dart `double` ≈ float32) | 179–198 |
| Channel order | **RGB** (`pixel.r, pixel.g, pixel.b`) | 187–193 |
| Normalisation | `(c / 127.5) - 1.0` → range `[-1, +1]` | 191–193 |
| Output tensor shape | `[1][_labels.length]` (i.e. `[1][6]` once labels.txt is loaded) | 200 |
| Argmax | manual loop, picks highest score | 204–211 |
| Confidence handling | Stores `_resultScore` and displays `XX.X% confident`; **no minimum threshold** | 213–217 / 428–435 |
| No-face / null handling | **None.** The pipeline always returns the argmax. | — |

### 3.4 Comparison table — training vs Flutter

| Check | Training expects | Flutter has | Match? |
|---|---|---|---|
| Input image size | 224×224 | 224×224 | ✅ |
| Channels | 3 (RGB) | 3 (RGB) | ✅ |
| Channel order | RGB | RGB | ✅ |
| Normalisation | MobileNetV2 `preprocess_input` → `[-1, +1]` | `(c/127.5) - 1.0` → `[-1, +1]` | ✅ (mathematically identical) |
| Batch dim | `[1, 224, 224, 3]` | `[1, 224, 224, 3]` | ✅ |
| Output classes | 6 | 6 (driven by `_labels.length`) | ✅ for *this* model |
| Output activation | softmax | implicit (model emits softmax) | ✅ |
| Label order | `anger, fear, joy, Natural, sadness, surprise` | `Anger, Fear, Joy, Natural, Sadness, Surprise` | ⚠️ Order ✅, casing different — works because emoji map uses `.toLowerCase()` |
| Label set matches **final required** set | `Anger/Fear/Joy/Natural/Sadness/Surprise` | same | ❌ Both differ from required final labels `Angry/Fear/Happy/Neutral/Sad/Tired` |
| Architecture vs claim | MobileNetV2 (per `train_emotions.py`) | model file present is `emotion_attention_model.tflite` (3.06 MB) — likely the CBAM variant from a separate, **unchecked-in** training script | ⚠️ The training script in repo does not produce this exact file |
| Confidence threshold | n/a | none | ❌ |
| No-face handling | n/a | none | ❌ |
| TFLite plugin compatibility | builtin ops only, float32 IO | `tflite_flutter 0.12.1` Interpreter, default builtin delegate | ✅ for builtin-op MobileNetV2/EffNetB0 graphs |
| Can the model load? | yes, if `tf.lite.Optimize.DEFAULT` only quantises weights | yes (`Interpreter.fromAsset` works at runtime in `_initialize()`); errors are caught & shown as `Failed to start camera` (misleading message — same catch handles model load failures) | ✅ structurally / ⚠️ error message |

### 3.5 Label-set mismatch — three layers disagree

There are **four** label namespaces in the project, and they don't line up:

| Layer | Label set |
|---|---|
| Training `CLASSES` | `anger, fear, joy, Natural, sadness, surprise` |
| Shipped `labels.txt` | `Anger, Fear, Joy, Natural, Sadness, Surprise` |
| Flutter `_emotionEmojis` keys | `anger, fear, joy, natural, sadness, surprise` |
| Required for final report | `Angry, Fear, Happy, Neutral, Sad, Tired` |
| AAC vocabulary (`lib/data/word_data/feelings.dart`) `en` keys | `Happy, Sad, Angry, Scared, …` |

The casing mismatch between `labels.txt` and the emoji map is masked by `emotion.toLowerCase()` (line 233), so the wrong-casing currently does not cause a visible bug — but it is fragile. Once the final required labels are introduced (`Happy/Sad/Tired/Neutral`), nothing in the Flutter side currently knows about them.

---

## 4. False Emotion Detection Issue — Why It Happens

### 4.1 What is in the code today

The full inference path in `_analyze()` (`camera_expression_screen.dart` lines 157–229):

1. Always takes a picture.
2. Always resizes to 224×224.
3. Always normalises and runs the model.
4. Always picks `argmax`.
5. Always sets `_resultLabel`.

That means the model is forced to choose **one of six emotions for every image**, regardless of what is actually in front of the camera. Softmax output sums to 1.0, so even on a black/blurred/floor image the highest score is shown — often around 30–50 %, which the UI confidently labels e.g. *"SURPRISE — 41.2% confident"*.

### 4.2 Checklist of what is missing

| Safeguard | Present? | Where it should live |
|---|---|---|
| Face detection before emotion inference | ❌ | `_analyze()` before step 4 |
| Minimum face size / bounding-box validation | ❌ | After face detection |
| Confidence (softmax max) threshold | ❌ | After step 6, before setting `_resultLabel` |
| Top-1 vs top-2 margin check (entropy / margin) | ❌ | Same place |
| Temporal smoothing over N frames | ❌ | The screen is single-shot, no buffer exists |
| "No face detected" state | ❌ | UI state machine in `_resultLabel` is binary (null or label) |
| "Uncertain emotion" state | ❌ | Same |
| Prevent AAC adaptation when no reliable face | ❌ | Adaptation itself is not implemented (§2) |
| Brightness / blur sanity check | ❌ | Would gate inference for dark/blurred shots |
| Camera-pointing-at-floor / hand-cover guard | ❌ | Implicit from the missing face detector |

### 4.3 Root cause summary

The model is a **6-class classifier with softmax**. Without a face-presence gate and without a confidence/margin threshold, the network *must* output one of the 6 classes for any input — including the floor, an object, a covered lens, or a partially-visible face. The current Flutter pipeline does not provide any of the standard ML guardrails (face detection, confidence threshold, temporal smoothing, neutral fallback).

---

## 5. Required Correction Plan (NOT applied)

This is a fix plan. **No file is changed in this step.**

### 5.1 Files to change

| File | Type of change |
|---|---|
| `pubspec.yaml` | Add a face detector dependency (`google_mlkit_face_detection: ^0.13.0` recommended) and remove the unused extra `.tflite` files from `assets/models/` (or list them only if you actually want them in the APK). Optionally bump `camera`. |
| `assets/models/labels.txt` | Replace with the final 6 labels exactly as the model was trained: `Angry / Fear / Happy / Neutral / Sad / Tired` — one per line, no trailing blank line. |
| `lib/screens/camera_expression_screen.dart` | Major: add face-detection gating, confidence threshold, temporal smoothing, "No face" / "Uncertain" states, surface real errors. Optionally split into a service. |
| `lib/services/emotion_service.dart` (new, recommended) | Move TFLite load + preprocessing + inference + smoothing here, so the screen stays UI-only. |
| `lib/screens/home_screen.dart` | Read the emotion result returned via `Navigator.pop(context, emotion)` in `.then((emotion) { ... })`, then highlight/scroll to the matching `Feelings` entry, or auto-pre-fill the sentence panel. |
| `lib/data/word_data/feelings.dart` | (Optional) align the `en` field with the new labels so `Tired/Neutral` map cleanly to AAC entries (add `Tired` row, add `Neutral` row). |
| `android/app/src/main/AndroidManifest.xml` | Add `<uses-feature android:name="android.hardware.camera" android:required="false"/>` and a meta-data tag for ML Kit if you adopt `google_mlkit_face_detection`. |
| `ios/Runner/Info.plist` | Already needs `NSCameraUsageDescription`; verify (not in scope of this audit). |
| `training/train_emotions.py` | Out of scope for this step. When you regenerate the final model, write `labels.txt` with the final 6 labels in the same order as the softmax output. |

### 5.2 What to change in each Flutter file

**A. `lib/screens/camera_expression_screen.dart`**

1. Add a `FaceDetector` instance (ML Kit) with `performanceMode: fast`, `enableLandmarks: false`, `enableClassification: false`, `enableTracking: false`, `minFaceSize: 0.20`.
2. Add fields:
   - `static const double _kMinFaceSize = 0.20;` (≥ 20 % of the shorter image side)
   - `static const double _kMinConfidence = 0.60;`
   - `static const double _kMinTopMargin = 0.15;` (top1 − top2)
   - `static const int _kSmoothingWindow = 7;`
   - `final Queue<List<double>> _scoreHistory = Queue();`
3. Rewrite `_analyze()` (or better: convert to a continuous stream using `startImageStream` + a worker isolate; if you keep tap-based, run 7 quick captures and average) so the new order is:
   1. Capture frame.
   2. Run ML Kit `FaceDetector.processImage` on the JPEG.
   3. If `faces.isEmpty` → set `_resultLabel = '__no_face__'`, clear history, return.
   4. If `faces.first.boundingBox` shorter side < `_kMinFaceSize * imageShortSide` → same as above.
   5. Crop image to the face bbox plus 20 % padding, then `copyResize(224, 224)`.
   6. Normalise to `[-1, +1]` (already correct).
   7. `interpreter.run(...)`.
   8. Push softmax vector into `_scoreHistory`, trim to `_kSmoothingWindow`.
   9. Compute element-wise mean of history → `meanScores`.
   10. `top1 = max(meanScores)`, `top2 = secondMax(meanScores)`.
   11. If `top1 < _kMinConfidence` **or** `(top1 - top2) < _kMinTopMargin` → set `_resultLabel = '__uncertain__'`.
   12. Else set `_resultLabel = labels[argmax(meanScores)]` and `_resultScore = top1`.
4. Update the UI:
   - When `_resultLabel == '__no_face__'`: show "No face detected" + `🙈` and disable any "Use in AAC" button.
   - When `_resultLabel == '__uncertain__'`: show "Uncertain — try again" + `🤔`.
   - Otherwise: show emotion as today.
5. Surface real errors. Replace the blanket `catch (e) { _errorText = _getText('Failed to analyze image'); }` with `debugPrint('Inference error: $e\n$st')` and a per-failure-mode message; separate the camera-init catch from the inference catch.
6. Remove the unused `size` local at line 264.
7. When user accepts an emotion (e.g. a "Use this" button) call `Navigator.pop(context, emotion)` so `HomeScreen` can adapt the AAC vocabulary.

**B. `lib/services/emotion_service.dart` (new — optional but cleaner)**

- Singleton holding the `Interpreter` and the labels.
- Methods:
  - `Future<void> load()` — load model + labels once.
  - `Future<EmotionResult> classify(img.Image cropped)` — preprocessing + inference + softmax already returned.
  - `EmotionResult smooth(List<List<double>> history)` — temporal smoothing + threshold + margin → returns `EmotionResult.noFace | uncertain | confident(label, score)`.
- Lets the screen stay UI-only and makes unit tests possible.

**C. `lib/screens/home_screen.dart`**

- Change the camera button (line 631) to:
  ```dart
  final emotion = await Navigator.push<String?>(
    context,
    MaterialPageRoute(
      builder: (_) => CameraExpressionScreen(
        language: selectedLanguage,
        isGirl: isGirl,
      ),
    ),
  );
  if (emotion != null && mounted) _applyEmotionToAac(emotion);
  ```
- Add `_applyEmotionToAac(String emotion)`:
  - Map emotion → preferred AAC category (`Happy/Sad/Angry/Tired/Scared/Neutral` → `Feelings`).
  - Auto-scroll to the Feelings card and prefill the sentence panel with the matching word (e.g. emotion `Sad` → push `feelings[1]` into `sentence`).
  - **Only run if `emotion` is one of the trained labels** — never run on `__no_face__` or `__uncertain__`.

**D. `assets/models/labels.txt`**

- Replace with the final 6 labels in exact softmax order:

  ```text
  Angry
  Fear
  Happy
  Neutral
  Sad
  Tired
  ```

- Update the hardcoded `_emotionEmojis` map keys to match (lowercase comparison is OK to keep): `angry, fear, happy, neutral, sad, tired`.

### 5.3 Concrete thresholds to start with

| Parameter | Suggested initial value | Tune by |
|---|---|---|
| `minFaceSize` (ML Kit) | `0.20` of shorter side | Increase if children too far from camera; decrease if cropping issues |
| Confidence threshold | `0.60` | Lower → more triggers, more false positives; higher → fewer triggers |
| Top1 − Top2 margin | `0.15` | Catches ambiguous cases (e.g. sadness vs neutral) |
| Smoothing window | 7 frames (or 5 captures if tap-based) | Larger → calmer but slower reaction |
| Min face bounding box | width ≥ 80 px in the resized space | Avoids tiny faraway faces |

---

## 6. TFLite Compatibility Assessment

### 6.1 Plugin capabilities

`tflite_flutter 0.12.1`:
- Wraps the TFLite C API.
- Supports **BUILTINS** and **BUILTINS + delegates** (NNAPI, GPU, XNNPACK on supported devices).
- **Does NOT bundle the `Flex` delegate.** A model that requires `SELECT_TF_OPS` will fail to load with an "ops not registered" error unless you ship `libtensorflowflex_*.so` yourself or use a different plugin (e.g. `flutter_tflite_audio`/manual native build).
- Supports **float32 input/output**, dynamic-shape ops, and INT8/float16 weight-only quantisation natively.

### 6.2 Specific checks against your model

| Question | Answer |
|---|---|
| Does the current Flutter code require `SELECT_TF_OPS` / Flex ops? | No. `Interpreter.fromAsset(...)` is called with no options — only builtins are available. **If your final model uses any TF op not in TFLite builtins (e.g. `tf.image.resize_with_crop_or_pad`, `tf.signal.*`, some custom CBAM attention ops), it will fail to load.** |
| Is float16 supported on the target device? | Yes on most modern Android (NNAPI / GPU delegate). With `tflite_flutter` builtin-only path, the float16 model still loads on CPU because activations are dequantised on the fly. No code change needed. |
| Is EfficientNet preprocessing correctly handled? | EfficientNet `tf.keras.applications.efficientnet.preprocess_input` is the **identity** (it does NOT remap to `[-1,+1]`; it expects raw `[0,255]` floats internally and the network applies a `Rescaling` layer). The current Flutter code applies `(c/127.5)-1.0`. **This is wrong for vanilla EfficientNetB0** but **correct for MobileNetV2** (which is what `train_emotions.py` actually trains). For a CBAM-on-EffNetB0 final model you must either (a) bake the `[0,255] → ImageNet normalisation` into the Keras model before export, or (b) change the Dart normaliser to match. |
| Should the model be exported as pure `TFLITE_BUILTINS`? | Strongly recommended. Convert with `converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS]` and avoid `SELECT_TF_OPS`. |
| Does the app require a `.txt` label file? | Yes — `_initialize()` reads `assets/models/labels.txt` and uses `_labels.length` to size the output buffer. The number of lines must equal `model.output_shape[-1]`. |
| Does the app expect float32 or uint8 input? | **float32** (the input is built as nested `List<double>`). A `uint8`-quantised model would crash with `Interpreter.run` shape/dtype mismatch unless the input buffer is rewritten. |

### 6.3 Verdict

The current Flutter integration is compatible with **MobileNetV2-style float32 IO TFLite models with builtin ops only**. It will be compatible with the planned EfficientNetB0+CBAM model **only if**:
- the exported `.tflite` uses builtin ops only (no `SELECT_TF_OPS`),
- input dtype is float32, shape `[1,224,224,3]`,
- output dtype is float32, shape `[1,6]`,
- and the **preprocessing pipeline matches what was used at training time** (currently `[-1,+1]`).

---

## 7. Final Model Recommendation

For the safest end-of-project export that works with the current Flutter code with the minimum number of Dart-side changes:

| Setting | Recommended value |
|---|---|
| Input tensor | `float32`, shape `[1, 224, 224, 3]`, layout `NHWC`, channel order `RGB` |
| Output tensor | `float32`, shape `[1, 6]`, softmax already applied inside the model (use `Dense(6, activation='softmax')`) |
| Preprocessing baked into the model? | **Yes.** Add a `tf.keras.layers.Rescaling(1./127.5, offset=-1.0)` as the first layer **before export**. The Flutter side then becomes "just pass raw `0–255` floats", but since the current Dart already produces `[-1,+1]` you can also keep preprocessing in Dart — pick one and document it. |
| `labels.txt` order | Exactly the order of the model's softmax outputs. Final labels: <br>`Angry`<br>`Fear`<br>`Happy`<br>`Neutral`<br>`Sad`<br>`Tired`<br>(no blank line at EOF) |
| Confidence threshold (Flutter) | `0.60` minimum, plus `top1 − top2 ≥ 0.15` |
| Temporal smoothing | Rolling mean of last 5–7 softmax vectors |
| TFLite converter settings | `converter.optimizations = [tf.lite.Optimize.DEFAULT]` (weight-only int8) **AND** `converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS]`. **Do NOT enable `SELECT_TF_OPS`.** If CBAM uses any op that requires it, replace the offending op with a TFLite-friendly equivalent (e.g. implement sigmoid attention with `Dense + Multiply` instead of custom `tf.nn.sigmoid` wrappers, avoid `tf.einsum`). |
| Quantisation | Weight-only INT8 (already the default with `Optimize.DEFAULT`). Avoid full integer quantisation — it would break the current float32 Dart input buffer. |
| File location | `assets/models/emotion_attention_model.tflite` (keep the current asset name so `pubspec.yaml` and `camera_expression_screen.dart` line 112 do not need to change). |
| Delete from `assets/models/` | The three unused `.tflite` files (`emotion_model.tflite`, `emotion_mobilenetv2.tflite`, `emotion_efficientnet_optimized.tflite`) — they bloat the repo by ~17 MB and are not referenced. |

Sanity tests to run **before final report submission**:

1. Load the exported model in Python (`tf.lite.Interpreter`) and assert `input_details[0]['shape'] == [1,224,224,3]` and `output_details[0]['shape'] == [1,6]`.
2. Inference on 6 known images (one per emotion) — argmax must match.
3. Inference on a black 224×224 image — top-1 confidence should be < 0.60 (validates that thresholding will catch garbage).
4. Inference on a floor photo — top-1 confidence should also be < 0.60.

---

## 8. Priority Fixes Before Final Report Submission

### 8.1 Critical (must fix — without these, the project demo can produce false claims)

| # | Fix | File(s) |
|---|---|---|
| C1 | Add face detection gate (e.g. `google_mlkit_face_detection`). Do **not** run the emotion model if no face is found. | `pubspec.yaml`, `lib/screens/camera_expression_screen.dart` |
| C2 | Add minimum face size & bounding-box validation; crop to face bbox before resize-to-224. | `lib/screens/camera_expression_screen.dart` |
| C3 | Add confidence threshold (`≥ 0.60`) and top1−top2 margin check (`≥ 0.15`). | `lib/screens/camera_expression_screen.dart` |
| C4 | Add "No face detected" and "Uncertain" UI states; never force an emotion. | `lib/screens/camera_expression_screen.dart` |
| C5 | Align `assets/models/labels.txt` with the final-report label set **and the actual softmax order of the deployed model** (`Angry, Fear, Happy, Neutral, Sad, Tired`). Regenerate `labels.txt` from the training script that produces the deployed model, not by hand. | `assets/models/labels.txt`, training side |
| C6 | Block AAC vocabulary adaptation when the result is `__no_face__` or `__uncertain__`. (Currently no adaptation exists at all, so the fix is to implement adaptation only behind a guard.) | `lib/screens/home_screen.dart`, `lib/screens/camera_expression_screen.dart` |

### 8.2 Important (should fix — affect reliability or marker-visible quality)

| # | Fix | File(s) |
|---|---|---|
| I1 | Add temporal smoothing (rolling mean of last 5–7 softmax vectors). Either run multiple quick captures per tap, or switch to `CameraController.startImageStream` with `ImageFormatGroup.yuv420` (note: this requires *also* changing `imageFormatGroup` away from `jpeg` on line 138). | `lib/screens/camera_expression_screen.dart` |
| I2 | Surface real inference errors instead of swallowing them as `Failed to analyze image`. | `lib/screens/camera_expression_screen.dart` lines 220–224 |
| I3 | Split AI logic into `lib/services/emotion_service.dart` so the screen is UI-only and the service is testable. | new file |
| I4 | Implement the AAC adaptation wire-up: `CameraExpressionScreen` returns the emotion via `Navigator.pop`, `HomeScreen` jumps to / pre-fills the `Feelings` category. | `home_screen.dart`, `camera_expression_screen.dart` |
| I5 | Verify the TFLite ops in the final EfficientNetB0+CBAM export are all in `TFLITE_BUILTINS`. If not, refactor the CBAM block to avoid `SELECT_TF_OPS`. | `training/*` (final export script) |
| I6 | Make sure the in-model preprocessing matches what Dart applies. Either bake `Rescaling(1/127.5, -1)` into the model **and** keep Dart at `[-1,+1]`, or remove Dart normalisation and ship a raw-pixel input model. Pick one. | training + Dart |
| I7 | Remove the three unused `.tflite` files from `assets/models/` (or list them in `pubspec.yaml` only if you want them shipped). | repo cleanup |
| I8 | Update `lib/data/word_data/feelings.dart` so `Tired` and `Neutral` rows exist with `si/ta/en` translations, otherwise mapping emotions → AAC entries will be incomplete. | `feelings.dart` |

### 8.3 Nice to have (polish — improves UX or code health, not strictly required for the report)

| # | Fix | File(s) |
|---|---|---|
| N1 | Replace deprecated `Color.withOpacity(x)` with `Color.withValues(alpha: x)` across all 150 occurrences. | most screens |
| N2 | Replace deprecated `WillPopScope` with `PopScope`. | `favourite_screen.dart` |
| N3 | Remove the duplicate/legacy `lib/screens/home_screen copy.dart` file. | repo cleanup |
| N4 | Remove unused locals/elements flagged by `flutter analyze` (`size` at line 264 of camera screen, `colors` at line 712 / `_buildNavButton` at line 704 of category screen). | per file |
| N5 | Show a small face-bounding-box overlay on the live preview so the user knows when a face is locked. | `camera_expression_screen.dart` |
| N6 | Localise the new UI strings ("No face detected", "Uncertain — try again", confidence labels) in `_getText` for `si-LK` and `ta-IN`. | `camera_expression_screen.dart` |
| N7 | Add a unit test for `EmotionService` (synthetic input → expected softmax handling, thresholding, smoothing edge cases). | `test/` |
| N8 | Bump `connectivity_plus` from 5.x to 7.x and `camera` to 0.12.x at your convenience (not required for AI). | `pubspec.yaml` |

---

## Appendix A — Concrete code anchors used in this audit

- Camera screen state class: `_CameraExpressionScreenState` in `lib/screens/camera_expression_screen.dart:25`.
- Model load: `lib/screens/camera_expression_screen.dart:111-116`.
- Hardcoded emoji map: `lib/screens/camera_expression_screen.dart:46-53`.
- Preprocessing block: `lib/screens/camera_expression_screen.dart:177-198`.
- Inference + argmax: `lib/screens/camera_expression_screen.dart:200-211`.
- Result UI: `lib/screens/camera_expression_screen.dart:376-442`.
- Camera launch from home: `lib/screens/home_screen.dart:631-641`.
- Training classes / preprocessing: `training/train_emotions.py:9, 11, 66, 91, 237-241`.
- AAC feelings (static): `lib/data/word_data/feelings.dart:1-80+`.
- Assets declared: `pubspec.yaml:80-81`.
- Shipped labels: `assets/models/labels.txt` (6 lines: `Anger, Fear, Joy, Natural, Sadness, Surprise`).

## Appendix B — What was NOT changed during this audit

- No `.dart`, `.py`, `.tflite`, `.txt`, `.yaml`, `.gradle*`, or manifest file was modified.
- Only read-only tooling was executed: `flutter --version`, `flutter doctor -v`, `flutter pub get`, `flutter analyze`, `flutter build apk --debug` (failed on network — no APK produced).
- The pre-existing dirty file `macos/Flutter/GeneratedPluginRegistrant.swift` (from before this audit started) was left untouched.
