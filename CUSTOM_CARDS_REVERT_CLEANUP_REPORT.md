# Custom Cards Revert / Cleanup Report

> **Date:** 2026-05-13  
> **Scope:** Remove leftover “custom cards” naming and dead files. **No** changes to emotion model, camera, ML Kit, TFLite, `labels.txt`, debug panel, or sensory feedback.

---

## 1. Investigation summary

A repo-wide search found **no** dedicated screens or services named `custom_cards_screen.dart`, `add_custom_card_screen.dart`, `custom_card_service.dart`, etc. The **only** live code under the misleading name `custom_card_widget.dart` was **`CustomWordCard`**: the animated tile used in **`CategoryScreen`** for **fixed** vocabulary from `word_data.dart` — not a user-editable custom-card editor.

There were also **no** Settings strings such as “Custom Cards”, “Add Card”, or “Card Management” in `lib/screens/settings.dart` (those options were not present in this tree).

Cleanup therefore focused on:

1. Renaming the vocabulary tile widget so it is not called “custom”.
2. Removing unused / duplicate / broken files.

---

## 2. Files deleted

| Path | Reason |
|------|--------|
| `lib/screens/theme/custom_card_widget.dart` | Replaced by `aac_word_card_widget.dart` (same UI for fixed AAC words; old filename suggested “custom cards”). |
| `lib/screens/home_screen copy.dart` | Legacy duplicate of `home_screen.dart`; not imported; referenced `custom_card_widget`. |
| `lib/screens/theme/a..txt` | Junk/orphan fragment (invalid filename; contained stale imports). |
| `lib/utils/io_file_helper.dart` | Untracked stub with broken conditional import (`io_file_helper_stub.dart` missing); nothing imported it. |
| `lib/utils/ensure_dir.dart` | Untracked stub with missing `ensure_dir_io.dart`; nothing imported it. |
| `lib/utils/ensure_dir_stub.dart` | Companion to broken `ensure_dir.dart`. |

**Not deleted:** `lib/utils/gender_selection_util.dart` (still used).

---

## 3. Files added

| Path | Purpose |
|------|---------|
| `lib/screens/theme/aac_word_card_widget.dart` | **`AacWordCard`** — same behaviour as the former `CustomWordCard` for the category grid. |

---

## 4. Files edited

| Path | Change |
|------|--------|
| `lib/screens/category_screen.dart` | Import `aac_word_card_widget.dart`; use **`AacWordCard`** instead of `CustomWordCard`. |
| `lib/screens/home_screen.dart` | Removed unused `import 'theme/custom_card_widget.dart'`. Removed dead **`GradientButton`** class at end of file (never referenced; duplicate of unused widget that lived in deleted file). |

**Not edited:** `camera_expression_screen.dart`, `sensory_feedback_service.dart`, `assets/models/labels.txt`, `assets/models/emotion_attention_model.tflite`, `feelings.dart`, TTS, sentence builder, ML Kit, debug panel.

---

## 5. Settings / UI options removed

None — there were **no** Settings entries in this codebase for “Custom Cards”, “Add Card”, “Edit Card”, “Card Management”, or “Custom Vocabulary”. Nothing to remove from `settings.dart`.

---

## 6. SharedPreferences / storage

No custom-card-specific keys were found. Existing keys (`favoriteCategories`, sensory toggles, registration, etc.) were **not** modified.

---

## 7. Search confirmation (after cleanup)

Under `lib/`:

- No matches for: `Custom Cards`, `Add Card`, `Edit Card`, `Custom Vocabulary`, `Card Management`, `custom card`, `custom_aac_card`, `CustomWordCard`, `custom_card_widget`.

One historical mention remains in **`AI_CAMERA_FALSE_POSITIVE_FIX_REPORT.md`** (documentation only), referring to the old unused import; it does not affect the app.

---

## 8. Fixed AAC cards still work

- **`CategoryScreen`** still builds its grid with the same widget API (`text`, `emoji`, `onTap`, `onSpeak`, `isGirl`, `language`); only the class name and file path changed (`AacWordCard` in `aac_word_card_widget.dart`).
- **`word_data.dart` / `lib/data/word_data/*`** were not touched.
- **Navigation** from `HomeScreen` → `CategoryScreen` unchanged.

---

## 9. Camera / model assets unchanged

| Asset / file | Changed? |
|--------------|----------|
| `assets/models/emotion_attention_model.tflite` | **No** |
| `assets/models/labels.txt` | **No** |
| `lib/screens/camera_expression_screen.dart` | **No** |
| ML Kit face detection | **No** |
| Debug probability panel | **No** |
| `lib/services/sensory_feedback_service.dart` | **No** |

---

## 10. Commands run

### `flutter analyze`

- **Result:** Exit code 1 (“issues found”) with **0 errors**.
- **Count:** **155** issues (down from 187 when the broken `lib/utils/io_file_helper.dart` was present).
- Remaining items are mostly `info` deprecations (`withOpacity`) and a few **pre-existing** `warning`s in `home_screen.dart` / `category_screen.dart` (unused import / unused members).

### `flutter build apk --release --no-shrink`

- **Result:** Success.
- **Output:** `Built build\app\outputs\flutter-apk\app-release.apk (110.6MB)` (~175 s).

---

## 11. Remaining risks / notes

- **Naming only:** The category word tile is now clearly **`AacWordCard`**. If any external doc or branch still says `custom_card_widget`, update references to `aac_word_card_widget.dart`.
- **Markdown history:** Older reports may still mention `custom_card_widget.dart`; safe to ignore or update for consistency.

---

## 12. Recommendation

If a future **user-editable custom vocabulary** feature is added again, use a dedicated namespace (`user_vocabulary`, `UserWordTile`, etc.) and keep **`AacWordCard`** for built-in `word_data` only, so naming cannot be confused with model/camera work.
