# Audio support integration report

Date: 2026-05-15

## Summary

Trilingual **WAV** emotion support clips were integrated under `assets/audio/support/{en,si,ta}/`. `EmotionSupportAudioService` picks a file from the folder that matches the app language, falls back to **English** if the preferred file is absent, and never crashes on missing assets or playback errors.

## Copied / present audio folders

| Path | Contents |
|------|-----------|
| `assets/audio/support/en/` | `happy.wav`, `sad.wav`, `angry.wav`, `fear.wav`, `surprise.wav`, `neutral.wav` |
| `assets/audio/support/si/` | same six stems |
| `assets/audio/support/ta/` | same six stems (source pack lacked `ta/angry.wav`; `en/angry.wav` was copied in as `ta/angry.wav` so all six stems exist; stray `English.wav` was removed) |

Source pack used:  
`C:\Users\HP\Downloads\emotion_support_voice_tts_trilingual_pack\assets\audio\support`

## `pubspec.yaml` assets

Declared:

- `assets/audio/support/`
- `assets/audio/support/en/`
- `assets/audio/support/si/`
- `assets/audio/support/ta/`

(Plus existing model / `labels.txt` entries unchanged.)

## Supported languages (runtime)

| App `languageCode` | Audio subdirectory |
|--------------------|--------------------|
| `si-LK` | `si` |
| `ta-IN` | `ta` |
| `en-GB` (default) | `en` |

## File mapping (stem → WAV)

| Emotion label(s) accepted | File |
|-------------------------|------|
| Joy, Happy | `happy.wav` |
| Sadness, Sad | `sad.wav` |
| Anger, Angry | `angry.wav` |
| Fear | `fear.wav` |
| Surprise | `surprise.wav` |
| Natural, Neutral | `neutral.wav` |

Matching is case-insensitive on the **display** / friendly label passed from the camera screen (raw vs display separation elsewhere is unchanged).

## Extension

**`.wav` only** in bundled paths. The service does not assume `.mp3`.

## Fallback behaviour

1. Try `assets/audio/support/<preferredLang>/<stem>.wav` (existence checked via `rootBundle.load`).
2. If missing, log:  
   `[EmotionAudio] Failed to play asset: assets/audio/support/<lang>/<stem>.wav error: missing file`
3. Then try `assets/audio/support/en/<stem>.wav`.
4. If that is also missing, log the same pattern for the English path and **return** (no play).

## Playback failure (device / codec)

If `audioplayers` throws after a file is chosen:

`[EmotionAudio] Failed to play asset: assets/... error: <error>`  
plus a stack trace line from `debugPrint`.

## When audio runs

Only from the emotion camera **“Play support”** tap. **Haptic runs first**, then audio (`camera_expression_screen.dart` `_playSupport` order unchanged).

## Code touched

- `lib/services/emotion_support_audio_service.dart` — language-aware WAV paths, existence check, fallbacks, logging.
- `lib/screens/camera_expression_screen.dart` — passes `widget.language` into `playForDisplayEmotion`.
- `assets/audio/support/README.txt` — updated for WAV layout.
- `pubspec.yaml` — explicit `en` / `si` / `ta` asset entries.

## Build / analyze (this session)

- **`flutter pub get`**: run as part of integration.
- **`flutter analyze`**: completed with project-wide infos/warnings (e.g. deprecations); **no new errors** from this audio work.
- **`flutter build apk --release --no-shrink`**: **not run** — user will run release builds locally.

## Unchanged (per requirements)

TFLite primary/fallback loading, ML Kit face pipeline, confidence / margin thresholds, AAC cards — not modified for this audio change.
