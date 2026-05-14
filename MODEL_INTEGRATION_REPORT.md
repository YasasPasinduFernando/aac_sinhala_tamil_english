# Model integration report

Date: 2026-05-14

## Summary

Final Flutter-ready emotion models from  
`C:\Users\HP\Desktop\model train final\flutter_models_ready-20260513T210353Z-3-001\flutter_models_ready`  
were copied into the app, `pubspec.yaml` was updated to bundle only the new assets, and `CameraExpressionScreen` now loads the **primary** EfficientNetB0 fine-tuned model first, then the **MobileNetV2** fallback if the primary fails to load or fails tensor validation. Labels and display mapping are unchanged (no Tired, no Surprise→Tired). Preprocessing remains **float32 in \[-1, +1\]** via `(pixel / 127.5) - 1.0`.

## Copied model files (into repo)

| Source (Desktop) | Destination in project |
|------------------|-------------------------|
| `emotion_efficientnetb0_finetuned.tflite` | `assets/models/emotion_efficientnetb0_finetuned.tflite` (~4.7 MB) |
| `emotion_mobilenetv2_fallback.tflite` | `assets/models/emotion_mobilenetv2_fallback.tflite` (~2.7 MB) |
| `labels.txt` | `assets/models/labels.txt` |

Older `.tflite` files may still exist under `assets/models/` on disk but are **not** listed in `pubspec.yaml` and are therefore **not shipped** in the APK.

## `pubspec.yaml` assets

Added / kept exactly:

- `assets/models/emotion_efficientnetb0_finetuned.tflite`
- `assets/models/emotion_mobilenetv2_fallback.tflite`
- `assets/models/labels.txt`

Removed from the bundle list (no longer required for this screen):

- `assets/models/emotion_attention_model.tflite`
- `assets/models/emotion_efficientnet_optimized.tflite`

## Primary and fallback paths (code)

| Role | Path |
|------|------|
| **Primary** | `assets/models/emotion_efficientnetb0_finetuned.tflite` |
| **Fallback** | `assets/models/emotion_mobilenetv2_fallback.tflite` |
| **Labels** | `assets/models/labels.txt` |

Constants: `_kPrimaryModelAsset`, `_kFallbackModelAsset`, `_kLabelsAsset` in `lib/screens/camera_expression_screen.dart`.

## `labels.txt` content (order preserved)

```
Anger
Fear
Joy
Natural
Sadness
Surprise
```

Runtime checks still expect lowercase tokens `anger` … `surprise` in that order (unchanged logic).

## Active loading order

1. After camera discovery and `CameraController.initialize()` succeed, call `_tryLoadEmotionModelSlot` for the **primary** asset.
2. If that returns `ok` (load + tensor validation), keep that interpreter.
3. Else call `_tryLoadEmotionModelSlot` for the **fallback** asset.
4. If fallback returns `ok`, use it.
5. If both slots fail:
   - If **both** failed with `tensorFailed` → user message **“Emotion model shape is not supported”**.
   - Otherwise → **“Emotion model failed to load”**.

## Tensor validation (applied to whichever model is accepted)

Required for **both** primary and fallback before the interpreter is kept:

- Input shape: `[1, 224, 224, 3]`
- Output shape: `[1, 6]`
- Input dtype: `float32`
- Output dtype: `float32`

Logs per attempt include `[ModelLoad] <Primary|Fallback> input tensor shape/type: …` and `… output tensor shape/type: …`.

## `[ModelLoad]` debug lines

Implemented (see `_tryLoadEmotionModelSlot`):

- `[ModelLoad] Trying primary model: assets/models/emotion_efficientnetb0_finetuned.tflite`
- `[ModelLoad] Primary model loaded OK` (only after tensor validation passes)
- `[ModelLoad] Primary model failed: <error>` (load exception or tensor / introspection failure)
- `[ModelLoad] Trying fallback model: assets/models/emotion_mobilenetv2_fallback.tflite`
- `[ModelLoad] Fallback model loaded OK`
- `[ModelLoad] Fallback model failed: <error>`
- `[ModelLoad] Active model: <model path>`
- `[ModelLoad] Active emotion model: EfficientNetB0 Fine-tuned` **or** `MobileNetV2 Fallback`

**Whether EfficientNetB0 loaded successfully** and **whether fallback was needed** are determined **at runtime** on device/emulator; inspect logcat / Flutter run console for the lines above.

## Preprocessing

Unchanged: image tensor uses **float32** and **\[-1, +1\]** normalization `(r / 127.5) - 1.0` (and same for G/B). No switch to `[0, 255]`; both models receive the same pipeline.

## Raw vs display labels

Unchanged: `_resultLabel` and softmax indices use **raw** strings from `labels.txt`; UI strings use `_displayFor(...)` (`Anger`→`Angry`, `Joy`→`Happy`, etc.).

## Build tooling note (Windows)

Release build initially hit Kotlin incremental compilation errors (Pub cache on `C:` vs project on `D:`). **`android/gradle.properties`** now includes:

```properties
kotlin.incremental=false
```

to stabilize Kotlin compiles across drives.

## Commands run

| Command | Result |
|---------|--------|
| `flutter clean` | Ran earlier in this session (symlink / Developer Mode notice may appear on some setups). |
| `flutter pub get` | Success. |
| `flutter analyze` | Completes with **153** reported issues (mostly `info` / deprecation); **no Dart compile errors** in the integration changes. Exit code **1** due to lint severity aggregation. |
| `flutter build apk --release --no-shrink` | **Success** after Gradle auto-retry; output: `build\app\outputs\flutter-apk\app-release.apk` (**~114.7 MB**). A transient CMake/configure hiccup occurred once; the retried build finished with **√ Built**. |

## Files touched (integration)

- `assets/models/emotion_efficientnetb0_finetuned.tflite` (copied)
- `assets/models/emotion_mobilenetv2_fallback.tflite` (copied)
- `assets/models/labels.txt` (copied)
- `pubspec.yaml` (assets list)
- `lib/screens/camera_expression_screen.dart` (dual model load, `[ModelLoad]` logs, enum `_EmotionModelSlotResult`)
- `android/gradle.properties` (`kotlin.incremental=false` for Windows cross-drive builds)

## Remaining issues / notes

- **`flutter analyze`**: project-wide infos/warnings (e.g. deprecated `withOpacity`, unused elements in other screens) — not introduced by this integration.
- **APK size**: larger than before because both finetuned and fallback `.tflite` files are bundled (~7.4 MB models + labels).
- **Runtime tensor check**: If a future model export uses different shapes, the app will reject it and attempt the other file; if both are invalid, the user sees **Emotion model shape is not supported**.

No ML Kit face pipeline, burst/threshold/margin logic, or AAC UI was modified beyond camera init and asset wiring.
