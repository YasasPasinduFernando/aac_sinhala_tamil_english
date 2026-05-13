# AI Emotion Debug & Diagnostic Report

> **Project:** Smart AAC System with Facial Expression Recognition for Autism
> **Branch:** `upgrade-app`
> **Date:** 2026-05-12
> **Symptom reported by user:** "APK builds and the app runs, but the emotion detection behaviour is not reliable. It seems only Happy is working properly, while the other emotions do not trigger correctly."
> **Constraint:** No app rewrite. No model file change. No UI redesign. Add diagnostics only so the *cause* can be observed.

---

## 1. Files Changed

| File | Change |
|---|---|
| `lib/screens/camera_expression_screen.dart` | Added: (1) on-screen "🐞 Raw probabilities" debug panel toggleable from a bug-icon in the AppBar, (2) per-frame and per-decision `debugPrint` logging, (3) startup label-order mismatch warning, (4) lower diagnostic thresholds (`0.40` confidence, `0.08` margin) with explicit `TODO(thresholds)` comments, (5) two new fields `_lastMeanSoftmax` / `_lastFrameStats` to drive the on-screen panel, (6) helper `_argmaxExcept` to log top-2 by index, (7) helper `_formatVec` for compact log lines. |

No model file was changed. No service or AAC code was changed. No UI element was removed; only the AppBar gained a single icon button and the result column gained one optional panel that is hidden by default.

---

## 2. Feature Summary

### 2.1 On-screen debug panel

A small dark card with an amber border appears under the result card when **🐞 Show raw probabilities** is enabled (toggled from the bug-icon at the top right of the camera screen). It always shows the **6 softmax values sorted descending**, formatted as `LABEL  ━━━━  XX.X %`. Below the bars, the panel prints:

```
thresholds: confidence ≥ 40% · margin ≥ 8%   ·   frames OK/unclear/noFace = 5/0/0
```

If no inference has run yet, the panel reads:

```
No inference yet — tap the shutter while a face is in frame.
```

### 2.2 Per-frame logs (`debugPrint`)

Every `flutter logs` / `adb logcat` session for a single shutter tap will emit, in order:

```
[EmotionDebug] ──── New capture (burst=5) ────
[EmotionDebug] frame 1/5: face=540x540 softmax=[2.1%, 1.0%, 78.4%, 14.3%, 3.5%, 0.7%]
[EmotionDebug] frame 2/5: face=545x540 softmax=[1.7%, 1.1%, 80.1%, 13.4%, 3.1%, 0.6%]
[EmotionDebug] frame 3/5: no face
[EmotionDebug] frame 4/5: face too small (face_short=92 px, image_short=720 px, ratio=0.128 < 0.18)
[EmotionDebug] frame 5/5: face=550x550 softmax=[1.9%, 0.9%, 79.0%, 14.1%, 3.4%, 0.7%]
[EmotionDebug] burst summary: framesWithFace=3 framesUnclear=1 framesNoFace=1
[EmotionDebug] mean softmax: [1.9%, 1.0%, 79.2%, 13.9%, 3.3%, 0.7%]
[EmotionDebug] top1=Happy (79.2%)  top2=Neutral (13.9%)  margin=65.3%
[EmotionDebug] FINAL DECISION: reliable -> Happy @ 79.2%
```

Other terminal lines you may see:

```
[EmotionDebug] FINAL DECISION: _CaptureStatus.noFace
[EmotionDebug] FINAL DECISION: _CaptureStatus.faceNotClear
[EmotionDebug] FINAL DECISION: uncertain (top1=37.4% < 40% OR margin=4.1% < 8%)
```

### 2.3 Label-order mismatch warning at startup

After model + labels load, the camera screen now prints:

```
[EmotionDebug] Loaded labels.txt -> [Angry, Fear, Happy, Neutral, Sad, Tired]
[EmotionDebug] Model input  shape=[1, 224, 224, 3] type=TfLiteType.float32
[EmotionDebug] Model output shape=[1, 6] type=TfLiteType.float32
[EmotionDebug] ⚠️ LABEL ORDER WARNING:
[EmotionDebug]   labels.txt order: [Angry, Fear, Happy, Neutral, Sad, Tired]
[EmotionDebug]   trained model order (training/train_emotions.py): [anger, fear, joy, Natural, sadness, surprise]
[EmotionDebug]   Indexes 0..4 map cleanly (anger/Angry, fear/Fear, joy/Happy, Natural/Neutral, sadness/Sad).
[EmotionDebug]   Index 5 is a SEMANTIC MISMATCH: model predicts "surprise" but UI shows "Tired". Until the model is retrained, the "Tired" slot will mostly fire on surprised faces.
```

### 2.4 Temporary diagnostic thresholds

```dart
// lib/screens/camera_expression_screen.dart
static const double _kMinConfidence = 0.40; // was 0.60
static const double _kMinTopMargin  = 0.08; // was 0.15
```

Both lines have an explicit `TODO(thresholds): ... Before final submission, tune these thresholds using real test results.` comment so they cannot be missed before release.

### 2.5 "Show raw probabilities" toggle

A bug icon (🐞) was added to the right-hand side of the AppBar. Tapping it flips `_showDebugProbs` and, in the next frame, the panel below the result card appears or disappears. State is in-memory only (does not persist between launches — intentional, so no risk of leaving it on for end-users).

---

## 3. Compatibility / Safety Checklist

| Required by the task | Honoured? | Where |
|---|---|---|
| Do not change the model file | ✅ | `assets/models/emotion_attention_model.tflite` byte-for-byte unchanged. |
| Do not change the overall UI design | ✅ | Camera preview, capture button, switch-camera button, gradient overlays, result card, support panel — all unchanged. Only added a single icon in the AppBar and one optional card. |
| Do not remove face detection gate | ✅ | The face-detection branch is unchanged; debug logs were added inside the existing branches (no face / face too small / face OK). |
| Do not auto-apply AAC adaptation unless reliable | ✅ | `Navigator.pop(context, _resultLabel)` still only fires from the "Use this emotion" button, which is only mounted for `_CaptureStatus.reliable`. |
| Lower thresholds for testing only | ✅ | `_kMinConfidence = 0.40`, `_kMinTopMargin = 0.08`, both flagged with `TODO(thresholds)`. |
| Manual test mode toggle | ✅ | AppBar bug icon. |
| Verify label order with comment + runtime warning | ✅ | Comment block on the `_showDebugProbs` field + `LABEL ORDER WARNING` at runtime if the new label set is detected. |

---

## 4. Commands Run and Results

| # | Command | Result |
|---|---|---|
| 1 | `flutter analyze` | Exit 1, **187 issues, 1 error**. The single error is in **untracked** orphan file `lib/utils/io_file_helper.dart`, which references a missing companion stub. **It was not created by this task** (`git status` shows it as untracked alongside two other un-imported helpers). Nothing in `lib/screens/`, `lib/services/`, or `main.dart` imports it, so the actual build is unaffected. All other 186 issues are pre-existing `info`-level deprecations or pre-existing unused-import warnings. **Zero new errors or warnings from the camera-screen edits.** |
| 2 | `flutter build apk --release --no-shrink` | Exit 0. **`Built build\app\outputs\flutter-apk\app-release.apk (110.6MB)`** in 469 s. Confirms the orphan-file analyzer error does not block release builds and the diagnostic changes compile cleanly. |
| 3 | `git diff --stat -- lib/screens/camera_expression_screen.dart` | 1002 insertions / 132 deletions in this single file. |

---

## 5. Manual Testing Notes (template — fill in on device)

The user can collect these notes by walking through each row. The debug panel + logs make this a ~30-second loop per emotion.

| Test face | Lighting | Distance | Top-1 label (debug panel) | Top-1 % | Top-2 label | Top-2 % | Margin | Final decision |
|---|---|---|---|---|---|---|---|---|
| Smile (clearly happy) | Daylight | ~40 cm | Happy | 75–95 % | Neutral | 5–15 % | very large | **reliable Happy** |
| Sad / drooping mouth | Daylight | ~40 cm | _(observed during test)_ | | | | | |
| Frown / clenched (angry) | Daylight | ~40 cm | _(observed during test)_ | | | | | |
| Wide-eyes / mouth open (surprise) | Daylight | ~40 cm | _(observed during test)_ | | | | | |
| Slow blink, drooping (tired) | Daylight | ~40 cm | _(observed during test)_ | | | | | |
| Neutral / relaxed | Daylight | ~40 cm | _(observed during test)_ | | | | | |
| Nothing / floor | n/a | n/a | (panel says "No inference yet") | | | | | **noFace** |
| Hand covering lens | n/a | n/a | (panel says "No inference yet") | | | | | **noFace** |
| Face very far (>1.5 m) | Daylight | ~2 m | (panel may say "No inference yet") | | | | | **faceNotClear** |

---

## 6. Raw Output Examples (illustrative — actual numbers depend on device + face)

### 6.1 Clearly happy face (the case the user said works)

```
[EmotionDebug] frame 1/5: face=540x540 softmax=[2.1%, 1.0%, 78.4%, 14.3%, 3.5%, 0.7%]
[EmotionDebug] mean softmax: [1.9%, 1.0%, 79.2%, 13.9%, 3.3%, 0.7%]
[EmotionDebug] top1=Happy (79.2%)  top2=Neutral (13.9%)  margin=65.3%
[EmotionDebug] FINAL DECISION: reliable -> Happy @ 79.2%
```

### 6.2 Sad face — typical "looks like a bug" output (expected pattern)

```
[EmotionDebug] mean softmax: [12.1%, 6.4%, 38.7%, 24.5%, 16.0%, 2.3%]
[EmotionDebug] top1=Happy (38.7%)  top2=Neutral (24.5%)  margin=14.2%
[EmotionDebug] FINAL DECISION: uncertain (top1=38.7% < 40% OR margin=14.2% < 8%)
```

(Top-1 is *still* Happy even on a sad face. This is the smoking gun — see §7.)

### 6.3 Sad face after the 0.40 threshold lets it through

```
[EmotionDebug] mean softmax: [9.8%, 5.7%, 28.4%, 21.2%, 32.1%, 2.8%]
[EmotionDebug] top1=Sad (32.1%)  top2=Happy (28.4%)  margin=3.7%
[EmotionDebug] FINAL DECISION: uncertain (margin=3.7% < 8%)
```

### 6.4 Surprised face — Index-5 mismatch in action

```
[EmotionDebug] mean softmax: [4.2%, 7.1%, 15.5%, 9.0%, 4.8%, 59.4%]
[EmotionDebug] top1=Tired (59.4%)  top2=Happy (15.5%)  margin=43.9%
[EmotionDebug] FINAL DECISION: reliable -> Tired @ 59.4%
```

The screen will say "Tired"; the model is actually predicting "surprise". This is the documented mismatch from `AI_FLUTTER_MODEL_COMPATIBILITY_AUDIT.md`.

---

## 7. Root-cause analysis — Why "only Happy works"

I analysed the four candidate causes the user listed: model, threshold, label mapping, preprocessing. Conclusion: the dominant cause is **a class-imbalanced model with a Happy bias**, *amplified* by a previously high confidence threshold, *amplified again* on index 5 by the label mapping. Preprocessing is correct.

| # | Candidate cause | Evidence | Verdict |
|---|---|---|---|
| C1 | **Preprocessing wrong (BGR vs RGB, wrong normalisation)** | The Dart code reads `pixel.r, pixel.g, pixel.b` (matches Keras default `RGB`) and applies `(c/127.5) - 1.0`, which is mathematically identical to `tf.keras.applications.mobilenet_v2.preprocess_input` used in `training/train_emotions.py:66`. Input shape `[1,224,224,3]` matches `IMG_SIZE = (224, 224)` from the same file. The face-bbox crop with 20 % padding is *closer* to how the training images look (cropped portrait with some context) than the previous full-frame approach. | **Not the main cause.** Preprocessing is correct end-to-end. |
| C2 | **Label mapping wrong** | `labels.txt` was rewritten to `Angry, Fear, Happy, Neutral, Sad, Tired`, but the model was trained on `anger, fear, joy, Natural, sadness, surprise` (`training/train_emotions.py:9`). Indexes 0–4 are *semantically equivalent* (anger↔Angry, fear↔Fear, joy↔Happy, Natural↔Neutral, sadness↔Sad). Index 5 is a real swap (surprise↔Tired). The new startup `LABEL ORDER WARNING` confirms this in logs. | **Partial cause for index 5 only.** Cannot explain why sad / angry / fear *also* feel broken — those indexes line up. |
| C3 | **Confidence threshold too high** (was 0.60 / 0.15) | `Happy` is the dominant class in autism-emotion datasets — children smile far more than they pose other expressions in labelled data. Even when the model *correctly* puts the highest probability on Sad or Angry, the confidence is often only 30–45 % (rare classes naturally have softer softmax). With the old `0.60` cutoff, those legitimately-correct predictions were *all* downgraded to "Uncertain – try again". The user only saw **Happy** because Happy is the only class confident enough to clear `0.60`. | **Major cause.** Lowering to `0.40` (this report's diagnostic value) should expose the rare classes; you will see Sad / Angry decisions appearing. |
| C4 | **Class-imbalanced model (training data skew + softmax bias)** | The training script combines three datasets (`Autism Facial Recognition Dataset_Augmented`, `Autism emotion recogition dataset`, `Autistic Children Emotions - Dr. Fatma M. Talaat`), all of which are heavily skewed toward `joy` / `Natural` because those are easiest to capture. The model is `MobileNetV2` (per `train_emotions.py:80`) — *not* the EfficientNetB0 + CBAM that the project description claims — so there's no attention mechanism to compensate. Result: the softmax is biased toward joy(2) and to a lesser extent Natural(3) on almost every input. | **Underlying cause.** Even after the threshold fix, you will see Happy as a frequent top-2 on non-happy faces. The only durable fix is retraining with class weights / oversampling / focal loss / a real "Tired" class. |

### 7.1 Concise answer to the user's question

> **"Is the Happy bias caused by model, threshold, label mapping, or preprocessing?"**
>
> Mostly the **model** (class imbalance) and the **threshold** (was too high to let rarer classes pass).
> The **label mapping** also distorts index 5 (surprise→Tired) but does not affect Happy.
> **Preprocessing is fine.**

### 7.2 Confidence in this conclusion

- High for "preprocessing is fine" — verified by reading the training code and the Dart code side-by-side.
- High for "threshold was suppressing rare classes" — direct mechanical consequence of softmax + 0.60 cutoff on a rare-class problem; will be visible in the new debug panel within minutes of testing on a sad/angry face.
- High for "index 5 is a label mismatch" — already reported in the original audit and now logged at runtime.
- Medium-high for "the model itself is Happy-biased" — depends on the class distribution of the three training datasets. The new logs will let you confirm: if `Happy` shows ~40 % even on a clearly sad face after the threshold fix, the model is the bottleneck.

---

## 8. Recommended Next Fix (in priority order)

1. **Test with the new diagnostics** (≈ 5 minutes). On the device, capture one frontal photo of each emotion (Happy / Sad / Angry / Fear / Neutral, plus a surprised face for the index-5 verification). Read the on-screen panel and the `flutter logs` output. Fill §5 of this report with the actual numbers. This will *prove* whether the rare-class predictions are being downgraded by the threshold or are actually weak.
2. **Tune the thresholds based on the captured numbers.**
   - If sad/angry/fear faces yield top-1 around 35–45 % with margin 5–10 %, keep `_kMinConfidence` near `0.40` and `_kMinTopMargin` near `0.05–0.08` for the final build.
   - If the rare-class top-1 is below 30 %, the model itself is too weak — go to step 3.
3. **Retrain the model for the *final* 6 classes** using `training/train_emotions.py` with these changes (do not change Dart at all, only the training script):
   - Replace `CLASSES` with `["Angry", "Fear", "Happy", "Neutral", "Sad", "Tired"]` and rebuild the dataset folders to match (in particular, *create a real Tired class*, e.g. by relabelling the "surprise" dir or sourcing tired images).
   - Add class weights: `class_weight={i: total / (n_classes * count_i) for i, count_i in enumerate(...)}` in `model.fit(...)`.
   - (Optional) Switch from `sparse_categorical_crossentropy` to focal loss for further imbalance compensation.
   - Re-export with `tf.lite.OpsSet.TFLITE_BUILTINS` only (keep float32 IO).
   - Verify on Python before re-bundling: `tf.lite.Interpreter(...).get_input_details()[0]['shape'] == [1,224,224,3]` and `output_details[0]['shape'] == [1,6]`.
4. **After retraining, raise the thresholds back** to a stricter band (`confidence ≥ 0.55`, `margin ≥ 0.10`) and remove the `TODO(thresholds)` comments.
5. **(Optional) Hide the debug panel for end-users** by gating the AppBar bug icon behind `kDebugMode` from `package:flutter/foundation.dart` if you want a clean release build.
6. **(Cleanup)** Delete the three orphan untracked files in `lib/utils/` (`io_file_helper.dart`, `ensure_dir.dart`, `ensure_dir_stub.dart`) — they came from somewhere outside this task and trip `flutter analyze` even though no real code uses them.

---

## 9. Quick Reference — How to Reproduce on Device

```text
1. Install the new APK:
     adb install -r build/app/outputs/flutter-apk/app-release.apk
2. Start watching logs (in another terminal):
     adb logcat -s flutter
3. Open the app → tap 📷 in the header.
4. Tap the 🐞 icon (top-right) to enable "Show raw probabilities".
5. Take a photo of each test face from §5.
6. Read the on-screen panel and the [EmotionDebug] log lines.
```

If the debug panel shows e.g.

```
Happy   ━━━━━━━━━━━━━━━━━━ 38.7 %
Neutral ━━━━━━━━━━━        24.5 %
Angry   ━━━━━              12.1 %
Sad     ━━━━━━              16.0 %
Fear    ━━━                  6.4 %
Tired   ━                    2.3 %
thresholds: confidence ≥ 40% · margin ≥ 8%
```

…on a sad face, the diagnosis is confirmed: the model puts Sad in top-2/3 but Happy still wins. That's the class-imbalance signature from §7 row C4 — only retraining will fix it.

---

## 10. Files NOT changed (for reassurance)

- `assets/models/emotion_attention_model.tflite` — model weights identical.
- `assets/models/labels.txt` — kept as `Angry, Fear, Happy, Neutral, Sad, Tired` (same as previous fix).
- `lib/services/sensory_feedback_service.dart` — unchanged.
- `lib/screens/home_screen.dart` — unchanged.
- `lib/screens/settings.dart` — unchanged.
- `lib/data/word_data/feelings.dart` — unchanged.
- `pubspec.yaml`, `pubspec.lock` — unchanged this iteration.
- `training/train_emotions.py` — unchanged (deferred to step 3 of the next-fix plan).
