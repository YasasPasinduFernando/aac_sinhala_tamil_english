# Model (PDF) ↔ Flutter Alignment Report

> **Project:** Smart AAC System with Facial Expression Recognition for Autism
> **Branch:** `upgrade-app`
> **Date:** 2026-05-12
> **Source of truth for the model:** `c:\Users\HP\Desktop\model.pdf` — screenshots of the final Colab notebook used to train and export the deployed `assets/models/emotion_attention_model.tflite`.
> **Goal of this iteration:** make the Flutter app honest about what the model actually predicts. Stop pretending the model has a "Tired" class.

---

## 1. What the PDF Model Expects

| Property | Value (per `model.pdf`) |
|---|---|
| Architecture | EfficientNetB0 + custom CBAM attention |
| Input shape | `[1, 224, 224, 3]` float32 |
| Output shape | `[1, 6]` float32, softmax |
| Class count | 6 |
| Class order (raw labels) | `0 = Anger`, `1 = Fear`, `2 = Joy`, `3 = Natural`, `4 = Sadness`, `5 = Surprise` |
| Export format | TensorFlow Lite |
| Expected preprocessing | Same convention as EfficientNet/MobileNet variants in TF: pixel range `[-1, +1]`, RGB channel order |

The PDF also shows occasional Colab `NameError` cells. Per the task brief these are run-order issues in the notebook and do not invalidate the saved `.tflite` file. The deployed model file in the app is treated as authoritative.

---

## 2. What `labels.txt` Was Changed To

`assets/models/labels.txt` (this iteration):

```text
Anger
Fear
Joy
Natural
Sadness
Surprise
```

This is now the **raw model order**, exactly as the PDF defines it. Position in this file == softmax index. No casing changes. No reordering. No fake classes.

The previous content of this file in the previous iteration was:

```text
Angry
Fear
Happy
Neutral
Sad
Tired      ← incorrect: the model has no Tired class
```

That older list mixed *display* labels with the *model* contract and silently mapped index 5 (`Surprise`) to `Tired`. That has been removed.

A startup runtime check in `_initialize()` (`camera_expression_screen.dart`) verifies the labels.txt order matches the expected `[anger, fear, joy, natural, sadness, surprise]` (case-insensitive) and emits one of two log lines:

```
[EmotionDebug] ✅ labels.txt matches trained model order (Anger, Fear, Joy, Natural, Sadness, Surprise).
[EmotionDebug]    display mapping: {anger: Angry, fear: Fear, joy: Happy, natural: Neutral, sadness: Sad, surprise: Surprise}
```

or — if anyone changes `labels.txt` in the future — a `⚠️ LABEL ORDER WARNING` block.

---

## 3. Why "Tired" Was Removed

Three reasons, in priority order:

1. **The model never learned a Tired class.** Per `model.pdf`, the 6 trained classes are `Anger / Fear / Joy / Natural / Sadness / Surprise`. There is no fatigue / drowsiness / yawn dataset behind any output neuron. Calling neuron 5 "Tired" silently relabels every surprised face as a tired face.
2. **It poisons therapy / AAC suggestions.** When a child shows surprise (a startle, a wide-eyed reaction) and the AAC banner suggests *"Tired"*, the caregiver acts on a wrong cue. That can damage trust in the system and miss a real surprise/startle moment.
3. **It made debugging impossible.** Because the user sees "Tired" but the model said "Surprise", every `flutter logs` line had to be mentally translated. The new design keeps **raw** and **display** labels strictly separate (see §4), so the debug panel and logs always show what the model actually predicted.

`Tired` was removed from:

- `assets/models/labels.txt` (now `Surprise`).
- `_displayMap` in `camera_expression_screen.dart` (now `surprise → Surprise`).
- `_emotionEmojis` in the camera screen (replaced `tired: 😴` with `surprise: 😮`).
- `SensoryFeedbackService.planFor` (the `'tired'` case is gone; a new `'surprise'` case added — calm, no sound, no caregiver alert).
- `_feelingWordFor` in `home_screen.dart` (the `tired` case is gone; a new `surprise` case returns a localized "Surprised" word).
- `_emotionEmojiFor` in `home_screen.dart` (same swap).

`Tired` still exists as a normal AAC vocabulary entry in `lib/data/word_data/feelings.dart` so the user can still pick it manually from the Feelings category. The only change is that the **camera flow no longer suggests it**.

---

## 4. How Display Mapping Works

The Flutter side now has **two label namespaces** that never get confused:

| Namespace | Where it lives | Example |
|---|---|---|
| **`rawModelLabel`** — what `labels.txt` and the model softmax produce | `_resultLabel`, `_lastMeanSoftmax`, `_emotionEmojis` keys, debug logs `[EmotionDebug]`, the on-screen "raw model:" line in the debug panel | `Joy`, `Sadness`, `Surprise` |
| **`displayLabel`** — what the user reads on screen and what the home screen receives | result card title, "Use this emotion" pop value, suggestion banner, support panel header, debug panel "display:" line | `Happy`, `Sad`, `Surprise` |

The bridge is a single `static const` map plus one helper:

```dart
// camera_expression_screen.dart
static const Map<String, String> _displayMap = {
  'anger':    'Angry',
  'fear':     'Fear',
  'joy':      'Happy',
  'natural':  'Neutral',
  'sadness':  'Sad',
  'surprise': 'Surprise',
};

static String _displayFor(String? rawLabel) {
  if (rawLabel == null || rawLabel.isEmpty) return '';
  return _displayMap[rawLabel.toLowerCase()] ?? rawLabel;
}
```

All conversion happens at the boundary between the camera screen and the rest of the app:

```text
TFLite softmax  ─argmax→  rawLabel (e.g. "Joy")
                              │
                              ├── shown in debug panel as raw
                              ├── _displayFor("Joy") = "Happy"
                              │           │
                              │           ├── shown in result card
                              │           ├── shown in debug panel as display
                              │           ├── passed to SensoryFeedbackService.planFor("Happy")
                              │           └── passed via Navigator.pop to HomeScreen
                              └── used to look up emoji in _emotionEmojis
```

The debug panel's information block now reads (monospace):

```
raw model:  Joy   →   display:  Happy
top1:       Joy   78.4 %
top2:       Natural   13.9 %
margin:     64.5 %
decision:   RELIABLE
```

This makes it trivial to verify whether a "wrong" UI label is caused by the model (top-1 raw label is itself wrong) vs the mapping (top-1 raw label is right but the displayed name is wrong).

---

## 5. Does Preprocessing Match the PDF Model?

| Stage | Flutter does | Trained model (per PDF / EfficientNet convention) | Match? |
|---|---|---|---|
| Input shape | `[1, 224, 224, 3]` Dart `List<List<List<List<double>>>>` (≈ float32) | `[1, 224, 224, 3]` float32 | ✅ |
| Channel order | RGB (`pixel.r / pixel.g / pixel.b`) | RGB (Keras default for EfficientNetB0) | ✅ |
| Per-pixel normalisation | `(c / 127.5) - 1.0` → `[-1, +1]` | TF EfficientNet preprocessing typically routes through a `Rescaling(1./127.5, offset=-1.0)` layer (or the equivalent `mobilenet_v2.preprocess_input`). Both compress `[0,255]` to `[-1,+1]`. | ✅ |
| Crop | Face bounding box from ML Kit + 20 % padding, then `copyResize(224×224)` | Training images are usually face crops with some padding. | ✅ (very close) |
| Batch dim | Always 1 | 1 | ✅ |

Caveat: I cannot read the exact `preprocess_input(...)` line in the PDF (it is screenshot-only — the OCR-free text I get from the PDF is `-- N of 11 --` page markers). The mapping above is the most likely match for an EfficientNetB0 + CBAM + softmax model exported with default Keras preprocessing baked in or applied externally. **If the PDF instead used `tf.keras.applications.efficientnet.preprocess_input` (which is the *identity* — EfficientNet expects raw `[0,255]` floats and applies `Rescaling` inside the network)**, our `(c/127.5)-1.0` would be **wrong** and would shift every input by exactly 1.0 in normalized space. That would give the model a strong but uniform bias toward whatever class the network treats as "default", which is exactly what we observe with the persistent Happy bias.

Recommendation: confirm in the Colab notebook whether `preprocess_input` is the identity (EfficientNet) or the `[-1,+1]` mapping (MobileNet-style). If it is the identity, change exactly one line in `_buildModelInput`:

```dart
// from: return [(r / 127.5) - 1.0, (g / 127.5) - 1.0, (b / 127.5) - 1.0];
// to:   return [r, g, b];
```

I have **not** changed that line in this iteration because the user said *do not change the model file* and asked for an alignment based on the PDF. Touching preprocessing is a follow-up that should be A/B-tested with the new debug panel.

---

## 6. Is the Happy-only Behaviour Caused by Model, Threshold, Label, or Preprocessing?

Updated answer in light of the PDF + this alignment:

| Candidate | Verdict | New evidence |
|---|---|---|
| **Label issue** | **Was a partial cause for index 5; now fixed for indexes 0-5.** | `labels.txt` is now the raw model order; `_displayFor` is the only conversion. No `Surprise → Tired` slippage anywhere. |
| **Preprocessing** | **Plausible second-order cause.** Our `(c/127.5)-1.0` is correct for MobileNet-style preprocessing but is shifted by 1.0 if the model used `efficientnet.preprocess_input` (identity). | See §5 — this needs to be confirmed against the actual notebook `preprocess_input` line. |
| **Threshold** | **Confirmed contributor.** The previous 0.60 / 0.15 thresholds suppressed every non-Happy class. The current diagnostic thresholds (0.40 / 0.08 — still flagged with `TODO(thresholds)`) let rare classes pass and let you see them in the debug panel. | Already documented in `AI_EMOTION_DEBUG_DIAGNOSTIC_REPORT.md`. |
| **Model bias (class imbalance)** | **Most likely root cause.** The training datasets behind autism-emotion `.tflite` files are heavily skewed toward `joy` / `Natural`. EfficientNetB0 + CBAM helps but does not compensate for class imbalance unless trained with class weights or focal loss. | Same as previous report; the new debug panel will let you confirm by reading the `top1 / top2` lines on a sad/angry face. |

### One-line answer

> The Happy bias is mostly **model imbalance** (rare-class softmax peaks 30–45 %), made worse by the **threshold** (was 0.60 → has been temporarily lowered to 0.40 for testing), with a **possible preprocessing scale issue** worth confirming. The previous **label mismatch** (Surprise→Tired) is now fixed in this iteration.

---

## 7. Files Changed (this iteration)

| File | What changed |
|---|---|
| `assets/models/labels.txt` | Replaced `Angry / Fear / Happy / Neutral / Sad / Tired` with `Anger / Fear / Joy / Natural / Sadness / Surprise` — exactly the raw trained order from `model.pdf`. |
| `lib/screens/camera_expression_screen.dart` | Added `_displayMap` + `_displayFor`. `_resultLabel` now stores the **raw** model label; the result card, support panel, and `Navigator.pop` all go through `_displayFor`. Replaced emoji map keys with raw labels (added `surprise: 😮`, removed `tired: 😴`). Rewrote the startup label-order verification to compare against `[anger, fear, joy, natural, sadness, surprise]`. Extended the debug panel to show **raw model**, **display**, **top1**, **top2**, **margin**, **decision** in a monospace block (in addition to the bar chart). No model file changes, no removal of the face-detection gate, no removal of the debug panel. |
| `lib/services/sensory_feedback_service.dart` | Removed the `'tired'` case from `planFor`. Added a `'surprise'` case (calm-breathing animation, light haptic, no sound, no caregiver alert). Updated the docstring to explain that the deployed model has no Tired class. |
| `lib/screens/home_screen.dart` | `_feelingWordFor`: removed the `'tired'` case; added a `'surprise'` case returning a localized "Surprised" word (no new AAC card). `_emotionEmojiFor`: replaced `'tired': '😴'` with `'surprise': '😮'`. |

Untouched on purpose:

- `assets/models/emotion_attention_model.tflite` — model file is unchanged.
- `lib/screens/settings.dart` — sensory toggles unchanged.
- `lib/data/word_data/feelings.dart` — `Tired` and `Neutral` AAC entries kept (the user can still pick them manually).
- ML Kit face detection, the no-face / face-not-clear / uncertain gating, and the confidence + margin thresholds — all preserved.

---

## 8. Commands Run and Results

| # | Command | Result |
|---|---|---|
| 1 | `flutter analyze` | Exit 1, **187 issues, 1 error**. The single error is the pre-existing untracked orphan `lib/utils/io_file_helper.dart` (no Dart file imports it; not part of the build graph). All 9 warnings are pre-existing. **Zero new errors or warnings introduced by this iteration.** |
| 2 | `flutter build apk --release --no-shrink` | Exit 0. **`Built build\app\outputs\flutter-apk\app-release.apk (110.6 MB)`** in 165 s. Confirms the alignment changes ship in a release APK. |

---

## 9. Remaining Risks

| # | Risk | Severity | What to do |
|---|---|---|---|
| R1 | **Preprocessing scale is unverified.** If the Colab notebook fed the model with `efficientnet.preprocess_input` (identity), our `(c/127.5)-1.0` is off by a factor of 1.0 in normalised space. This would explain why even a strongly-sad face still has Happy in top-2/3. | High | Open the PDF / notebook and check the exact `preprocess_input` line. If it is the identity, change `_buildModelInput` to return raw `[0..255]` floats. A/B test with the new debug panel. |
| R2 | **Model class imbalance.** Even with correct labels and correct preprocessing, the model puts low absolute confidence on rare classes. Threshold 0.40 currently lets them through; that is *diagnostic*, not *production*. | High | Retrain with class weights or focal loss. See §11. |
| R3 | **CBAM ops compatibility.** Some custom attention implementations use TF ops that need `SELECT_TF_OPS` (Flex). If the deployed `.tflite` ever needs Flex, the current `Interpreter.fromAsset(...)` call (no options) will fail at load. | Medium | Verify with `tf.lite.Interpreter(...)` in Python that all ops are in `TFLITE_BUILTINS`. The model loads fine right now in our APK, so this is a forward-looking risk only. |
| R4 | **No real Tired class.** Removing the fake mapping makes the app honest, but it also means the model cannot detect tiredness. | Low (now documented) | Future retraining with a fatigue dataset (see §11). |
| R5 | **Surprise plan is generic.** The new Surprise support plan uses calm-breathing + no sound + no alert. Real children might react better to a quick grounding breathing exercise — needs caregiver feedback. | Low | Iterate after device testing. |
| R6 | **Diagnostic thresholds (0.40 / 0.08) are still active.** Tagged with `TODO(thresholds)` but easy to forget before final submission. | Medium | Tune to ~0.50 / 0.10 (or whatever device testing produces) and remove the TODO comment before the final build. |

---

## 10. Recommendation for Future Retraining (real Tired / fatigue class)

When you regenerate the model in Colab, do all of these in one pass:

1. **Add a real Tired class.** Sources to consider:
   - Drowsy-driver datasets (NTHU-DDD, YawDD).
   - ChildAffect or ABAW subsets containing yawning / eye-closure annotations.
   - Augment with EAR (eye-aspect-ratio) low-cases from a small custom recording set with caregiver consent.
2. **Keep the other 5 classes from `model.pdf`** in the same order to minimise app-side changes:
   - `0 - Anger`
   - `1 - Fear`
   - `2 - Joy`
   - `3 - Natural`
   - `4 - Sadness`
   - `5 - Surprise`
   - `6 - Tired` ← **new, appended last**
3. **Compensate for class imbalance.** Use one of:
   - `class_weight = compute_class_weight('balanced', classes=np.unique(y), y=y)` passed to `model.fit`.
   - **Focal loss** (`alpha=0.25, gamma=2`) instead of `sparse_categorical_crossentropy`.
   - Oversample the minority classes (Anger / Fear / Sadness / Tired) in the data pipeline.
4. **Bake preprocessing into the model.** Add `tf.keras.layers.Rescaling(1./127.5, offset=-1.0)` as the first layer **before** the EfficientNetB0 stem. Then the Flutter side can stop normalising in Dart and just feed `[0..255]` floats — eliminating risk R1 forever.
5. **Export with builtins-only:**
   ```python
   converter = tf.lite.TFLiteConverter.from_keras_model(model)
   converter.optimizations = [tf.lite.Optimize.DEFAULT]
   converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS]
   tflite_model = converter.convert()
   ```
   Avoid `SELECT_TF_OPS`. If CBAM uses an op TFLite cannot represent, refactor it to `Dense + Multiply + Sigmoid`.
6. **Ship the new file at the same asset path.**
   `assets/models/emotion_attention_model.tflite` — no Flutter code changes required if the preprocessing matches and the labels are appended.
7. **Update labels.txt to:**
   ```text
   Anger
   Fear
   Joy
   Natural
   Sadness
   Surprise
   Tired
   ```
   (Just append.)
8. **Reactivate Tired in three places** in Flutter once steps 1–7 are done:
   - Add `'tired': 'Tired'` back to `_displayMap` and `'tired': '😴'` to `_emotionEmojis`.
   - Re-add the `'tired'` case in `SensoryFeedbackService.planFor` (the previous version is preserved in this report — see §11 below).
   - Re-add the `'tired'` case in `home_screen.dart`'s `_feelingWordFor` and `_emotionEmojiFor`.
9. **Tighten thresholds** (`_kMinConfidence` to ~0.55, `_kMinTopMargin` to ~0.10) and remove the `TODO(thresholds)` comments.
10. **Verify in Python** before bundling: `tf.lite.Interpreter(...).get_input_details()[0]['shape'] == [1,224,224,3]`, output `[1, 7]`, and run a sanity-check inference on one image per class.

---

## 11. Reference: Previous Tired Plan (for reinstatement after retraining)

```dart
case 'tired':
  return const SensorySupportPlan(
    emotion: 'Tired',
    actionEn: 'Suggest a rest. Slow dim animation, no sound.',
    actionSi: 'විවේකය යෝජනා කරන්න. මන්දගාමී අඳුරු සංදර්ශනය, ශබ්ද රහිතයි.',
    actionTa: 'ஓய்வு பரிந்துரை. மெதுவான மங்கலான அசைவு, ஒலி இல்லை.',
    animation: SupportAnimation.softDim,
    hapticPattern: HapticPattern.light,
    soundTone: SupportSoundTone.none, // Spec rule: no loud sound for Tired.
    showCaregiverAlert: false,
  );
```

`SupportAnimation.softDim` is still defined in the service (it is now unused — kept on purpose so the future Tired plan can be re-activated with one switch case and one `_displayMap` entry).

---

## 12. Quick Reference — How to Re-verify on Device

```text
1. adb install -r build/app/outputs/flutter-apk/app-release.apk
2. adb logcat -s flutter
3. Open the app → tap 📷 → tap the 🐞 icon (top-right of camera screen).
4. Capture each emotion in turn. Read both:
   - the on-screen panel (raw + display + top1/top2/margin/decision)
   - the [EmotionDebug] log lines, which now include the ✅ / ⚠️ label-order line at startup.
5. For every face that shows "Happy" but should be Sad/Angry/Fear, copy the
   per-frame softmax line from logcat into a notes file. After 10–20 samples
   you will have a clear answer to whether the next fix is preprocessing
   (R1), thresholds (R6), or retraining (R2).
```
