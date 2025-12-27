# Quick Implementation Reference

## What Was Changed

### 1. New Widget: `EmojiText`
**Purpose**: Stable emoji rendering without `fontFamily: 'emoji'` workaround

**Location**: `lib/widgets/emoji_text.dart`

**Key Properties**:
```dart
const EmojiText(
  this.emoji,
  {
    this.fontSize = 50,
    this.textAlign = TextAlign.center,
    this.maxLines = 1,
  }
)
```

**Usage in `AnimatedCategoryCard`**:
```dart
// Background emoji (decorative)
Positioned(
  right: -20,
  top: -20,
  child: RepaintBoundary(
    child: Opacity(
      opacity: 0.1,
      child: EmojiText(_memoizedEmoji, fontSize: 80),
    ),
  ),
),

// Main emoji (interactive)
RepaintBoundary(
  child: EmojiText(_memoizedEmoji, fontSize: 50),
),
```

---

## Why the Fix Works

### Problem Chain
```
🔴 fontFamily: 'emoji' specified
  ↓
🔴 Android native emoji fallback disabled
  ↓
🔴 Multi-codepoint emojis (👨‍👩‍👧‍👦) render inconsistently
  ↓
🔴 Parent state changes → full rebuild → emoji disappears
  ↓
🔴 User sees flickering effect
```

### Solution Chain
```
🟢 Remove fontFamily specification
  ↓
🟢 Use system's native emoji font
  ↓
🟢 Add proper text metrics (height, leadingDistribution)
  ↓
🟢 Memoize emoji string in initState
  ↓
🟢 Even on parent rebuild, emoji reference is stable
  ↓
🟢 Grid keeps cards in memory (addAutomaticKeepAlives)
  ↓
🟢 No flicker - emojis render consistently
```

---

## Testing Scenarios

### ✅ Test 1: Initial Load
```
Expected: All 14 emojis visible on first launch
Verify: No emoji appears blank/null
```

### ✅ Test 2: Scrolling
```
Expected: Emojis stable while scrolling
Verify: No emoji flickers during scroll
```

### ✅ Test 3: Gender Toggle
```
Steps:
  1. Tap 👧/👦 gender button
  2. Select different gender
  3. Return to home screen
Expected: All emojis still visible
Verify: Card colors change, but emojis don't flicker
```

### ✅ Test 4: Language Change
```
Steps:
  1. Tap 🇱🇰 language button
  2. Select different language (🇮🇳 or 🇺🇸)
Expected: Category names + descriptions change, emojis stable
Verify: No emoji disappears during language switch
```

### ✅ Test 5: Background Suspend/Resume
```
Steps:
  1. Launch app, see all emojis
  2. Lock device
  3. Unlock device
Expected: All emojis still visible
Verify: No flicker on lifecycle change
```

### ✅ Test 6: App Background/Foreground
```
Steps:
  1. Launch app, see all emojis
  2. Switch to another app
  3. Return to AAC app
Expected: All emojis visible
Verify: `didChangeAppLifecycleState` doesn't cause flicker
```

---

## Technical Deep Dive

### Why `fontFamily: 'emoji'` is Problematic

```dart
// ❌ BEFORE (causes flickering)
Text(
  '👨‍👩‍👧‍👦',
  style: TextStyle(
    fontSize: 50,
    fontFamily: 'emoji',  // ← Forces specific font
  ),
)

// 🟢 AFTER (stable rendering)
Text(
  '👨‍👩‍👧‍👦',
  style: TextStyle(
    fontSize: 50,
    height: 1.0,
    leadingDistribution: TextLeadingDistribution.even,
    // No fontFamily specified ← Uses system default
  ),
)
```

**Why system default is better**:
1. **Font Fallback Chain**: System tries multiple fonts until one has the glyph
2. **Hardware Optimization**: System fonts get optimized rendering
3. **Emoji Variations**: System handles regional emoji variants (e.g., 👨‍👩‍👧‍👦 vs emoji style)
4. **Performance**: No font file loading overhead

---

### Memoization Pattern

```dart
class _AnimatedCategoryCardState extends State<AnimatedCategoryCard> {
  late final String _memoizedEmoji;
  
  @override
  void initState() {
    super.initState();
    // Stored once, never recreated even if parent rebuilds
    _memoizedEmoji = widget.emoji;
  }
  
  @override
  Widget build(BuildContext context) {
    return EmojiText(_memoizedEmoji);  // Always same reference
  }
}
```

**Why this matters**:
- `widget.emoji` could change if parent rebuilds
- `_memoizedEmoji` is cached in state, survives rebuild cycles
- Text widget sees same string reference → no re-rendering of glyphs

---

### Grid Optimization

```dart
SliverChildBuilderDelegate(
  // ... builder function ...
  childCount: _categories.length,
  addAutomaticKeepAlives: true,   // ← Keep widgets in memory
  addRepaintBoundaries: false,    // ← Manual boundaries prevent duplication
),
```

**What each flag does**:

| Flag | Value | Effect |
|------|-------|--------|
| `addAutomaticKeepAlives` | `true` | Wraps each child with `AutomaticKeepAliveWidget`, preventing disposal |
| `addRepaintBoundaries` | `false` | We manually add `RepaintBoundary`, so disable auto-wrapping to avoid duplication |

---

## Device-Specific Notes

### Android 10+ (API 29+)
- ✅ Better emoji support
- ✅ Hardware emoji rendering
- ⚠️ Still needs careful font handling

### Android 8-9 (API 26-28)
- ⚠️ Emoji rendering quirks
- ⚠️ May need fallback emojis for rare glyphs
- ✅ System fonts still reliable

### Android 7 and below
- ⚠️ Limited emoji support
- 💡 Consider showing replacement text or icons
- 💡 Test on actual devices

---

## Debugging Commands

### Check Device for Emoji Support
```bash
adb shell getprop ro.build.version.android
adb shell getprop ro.product.model
```

### Monitor Emoji Rendering
```bash
# Terminal 1: Run app with profiling
flutter run --profile

# Terminal 2: Watch logcat for rendering issues
adb logcat | grep -E "RenderThread|skia|Codec"
```

### Force Rebuild & Check Performance
```bash
# Run with semantics update enabled
flutter run --dart-define=FORCE_SEMANTICS_UPDATE=true
```

---

## Monitoring in Production

### Add Analytics (Optional)
```dart
Future<void> _trackEmojiRendering(String categoryName) async {
  // Log to Firebase Analytics
  await FirebaseAnalytics.instance.logEvent(
    name: 'emoji_rendered',
    parameters: {
      'category': categoryName,
      'timestamp': DateTime.now().toString(),
    },
  );
}
```

### Error Tracking
```dart
try {
  // Render emoji
  EmojiText(emoji);
} catch (e) {
  // Report to Sentry or Crashlytics
  Sentry.captureException(e);
}
```

---

## Future Optimizations

### Option A: Icon Font Instead of Emojis
```dart
// Use Material Icons or FontAwesome
Icon(Icons.people, size: 50)
```
Pros: More stable, smaller file size  
Cons: Less visual appeal

### Option B: Cached Emoji Rendering
```dart
class _EmojiCache {
  static final _cache = <String, ImageProvider>{};
  
  static ImageProvider getEmoji(String emoji) {
    return _cache.putIfAbsent(emoji, () => /* render to image */);
  }
}
```
Pros: Pre-rendered, pixel-perfect  
Cons: Complex implementation

### Option C: Noto Color Emoji Font
```yaml
# pubspec.yaml
fonts:
  - family: NotoColorEmoji
    fonts:
      - asset: assets/fonts/NotoColorEmoji-Regular.ttf
```
Pros: Consistent look across devices  
Cons: Large file (~35MB)

---

## Summary

| What | Where | Why |
|------|-------|-----|
| Remove `fontFamily: 'emoji'` | `EmojiText` widget | Uses system default font |
| Memoize emoji string | `initState` | Stable reference across rebuilds |
| Use `AutomaticKeepAlives` | Grid delegate | Widgets stay in memory |
| Manual `RepaintBoundary` | Card + emoji | Better control, no duplication |

**Result**: Flickering emojis → Stable, consistent rendering ✅
