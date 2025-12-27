# Emoji Flickering - Step-by-Step Debugging Guide

## 🎯 If Flickering Still Occurs After Fix

Follow this systematic debugging approach to identify what's happening:

---

## Phase 1: Verify the Fix Was Applied Correctly

### Step 1.1: Check EmojiText Widget Exists
```bash
# Verify file exists
ls -la lib/widgets/emoji_text.dart

# Check it has no 'fontFamily: emoji'
grep -n "fontFamily" lib/widgets/emoji_text.dart
# Expected: No results (fontFamily should NOT be present)
```

### Step 1.2: Verify AnimatedCategoryCard Uses EmojiText
```bash
grep -n "EmojiText\|_memoizedEmoji" lib/screens/theme/animated_category_card.dart
# Expected output should show:
# - import statement for EmojiText
# - _memoizedEmoji in initState
# - EmojiText(...) calls instead of Text(...) for emoji
```

### Step 1.3: Verify Grid Delegate Optimizations
```bash
grep -n "addAutomaticKeepAlives\|addRepaintBoundaries" lib/screens/home_screen.dart
# Expected:
# addAutomaticKeepAlives: true
# addRepaintBoundaries: false
```

---

## Phase 2: Device & Environment Check

### Step 2.1: Check Flutter Version
```bash
flutter --version
# Expected: Flutter 3.x or higher
# If lower: flutter upgrade
```

### Step 2.2: Check Android SDK Version
```bash
adb shell getprop ro.build.version.sdk_int
# Expected: 29+ (Android 10+) for best emoji support
# If 26-28: App should still work with fixes
# If below 26: May need emoji fallback strategy
```

### Step 2.3: Check Device Emoji Font
```bash
adb shell ls -la /system/fonts/ | grep -i emoji
# Expected: At least one emoji font (e.g., NotoColorEmoji.ttf)

# Check which emoji font is used
adb shell getprop persist.sys.usb.config
```

---

## Phase 3: Runtime Debugging

### Step 3.1: Enable Flutter DevTools
```bash
# Terminal 1: Start app
flutter run -d <device_id>
# Press 'w' to launch web DevTools

# Terminal 2: In DevTools
# 1. Go to "Console" tab
# 2. Look for any dart errors about rendering
```

### Step 3.2: Monitor Frame Rate
```bash
# While app is running, press 'P' in terminal
# Shows: "# refresh" with frame timing
# Look for:
# ✅ 60 FPS = good
# ⚠️ < 50 FPS = performance issue
# 🔴 Spikes to 16ms+ = rendering bottleneck
```

### Step 3.3: Enable Performance Overlay
```bash
# In code, temporarily add:
# main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ... other init code ...
  
  // TEMPORARY: Show performance overlay
  runApp(
    MaterialApp(
      showPerformanceOverlay: true,  // ← This
      home: const SplashScreen(),
    ),
  );
}

# Run app: flutter run
# Look for yellow/red areas in performance graph
# Yellow = slow builds, Red = slow frames
```

---

## Phase 4: Detailed Analysis - Build vs Render

### Step 4.1: Check Build Count
```dart
// Add to AnimatedCategoryCard._build
@override
Widget build(BuildContext context) {
  debugPrint('🔨 BUILDING: ${widget.categoryName}');  // ← Add this line
  super.build(context);
  // ... rest of build ...
}
```

**What to expect**:
```
✅ GOOD: "🔨 BUILDING: Body Parts" appears only once on startup
❌ BAD: "🔨 BUILDING: Body Parts" appears every frame or on language change
```

**Run test**:
```bash
flutter run
# Watch console output
# 1. App launches → should see each category print once
# 2. Scroll → no new build prints
# 3. Change language → all 14 categories print again (expected, they rebuild)
# 4. After language change, scroll → no new prints
```

### Step 4.2: Check Emoji String Reference
```dart
// Add to AnimatedCategoryCard._build
@override
Widget build(BuildContext context) {
  debugPrint('Emoji: ${widget.emoji} vs Memoized: $_memoizedEmoji '
      'Same? ${identical(widget.emoji, _memoizedEmoji)}');
  super.build(context);
  // ... rest ...
}
```

**Expected output**:
```
✅ GOOD: Same? true (or false is also OK if values are equal)
❌ BAD: Memoized shows null or empty
```

---

## Phase 5: Emoji Rendering Analysis

### Step 5.1: Check Emoji Unicode Values
```dart
// In EmojiText widget build:
void debugPrintEmoji(String emoji) {
  final runes = emoji.runes.toList();
  debugPrint('Emoji: $emoji');
  debugPrint('Codepoints: ${runes.map((r) => '0x${r.toRadixString(16)}').join(', ')}');
  debugPrint('Length: ${emoji.length}');
}

// Call it in build:
@override
Widget build(BuildContext context) {
  debugPrintEmoji(emoji);
  return Text(emoji, ...);
}
```

**What to look for**:

```
Family emoji (multi-codepoint):
Emoji: 👨‍👩‍👧‍👦
Codepoints: 0x1f468, 0x200d, 0x1f469, 0x200d, 0x1f467, 0x200d, 0x1f466
Length: 25
✅ If you see this, emoji is a complex sequence (ZWJ)

Simple emoji (single codepoint):
Emoji: 👤
Codepoints: 0x1f464
Length: 2
✅ Single codepoint emoji
```

### Step 5.2: Check System Font Capability
```bash
# Create debug app to test emoji rendering
# Add this widget to test specific emojis
const testEmojis = [
  '👤', '🐶', '🍎', '🍽️', '🏠', '🎨', '🔢', '😊',
  '⚽', '🎵', '👨‍👩‍👧‍👦', '🌍', '🙏', '💬',
];

// In build:
ListView(
  children: testEmojis.map((e) => 
    EmojiText(e, fontSize: 60)
  ).toList(),
)

# If some emojis show as blank/missing glyph:
# → Device doesn't have complete emoji font
# → Need fallback strategy
```

---

## Phase 6: Android Specific Issues

### Step 6.1: Check Logcat for Rendering Warnings
```bash
# Terminal: Watch for rendering errors
adb logcat | grep -E "Codec|TextLayout|Skia|RenderThread"

# Expected: Minimal output, no repeated errors
# If you see repeated errors about specific emoji:
# → System font missing that glyph
# → Need fallback emoji
```

### Step 6.2: Monitor Memory During Scroll
```bash
# Terminal 1: Run app in profile mode
flutter run --profile -d <device_id>

# Terminal 2: Monitor memory
adb shell dumpsys meminfo | grep native

# Expected:
# Memory stays stable (±10MB) while scrolling
# If memory spikes:
# → Possible memory leak in emoji rendering
# → Check for excessive widget creation
```

### Step 6.3: Check GPU Load
```bash
# Enable GPU profiling
adb shell setprop debug.hwui.profile global

# Then check:
adb shell getprop debug.hwui.profile
# Expected: global

# Run app and scroll - GPU should stay under 16ms per frame
# If sustained > 16ms:
# → Rendering bottleneck
# → May need to simplify emoji rendering or use smaller size
```

---

## Phase 7: Specific Issue Diagnosis

### Issue: Emojis Blank on Launch

```dart
// Debug code:
@override
void initState() {
  super.initState();
  _memoizedEmoji = widget.emoji;
  debugPrint('Init: emoji="${widget.emoji}", memoized="$_memoizedEmoji"');
}

// If memoized is empty:
// → widget.emoji is null from parent
// → Check _categories in home_screen.dart
// → Verify all category maps have 'emoji' key
```

**Fix checklist**:
- [ ] All items in `siCategories`, `taCategories`, `enCategories` have `'emoji'` key
- [ ] No null emojis in the lists
- [ ] `_categories` getter properly returns categories

### Issue: Emojis Disappear When Scrolling

```dart
// This means widget is being disposed
// Check if this is happening:

@override
void dispose() {
  debugPrint('⚠️ DISPOSING: ${widget.categoryName}');
  super.dispose();
}

// If you see dispose prints while scrolling:
// → AutomaticKeepAliveClientMixin not working
// → Verify wantKeepAlive = true is present
// → Verify class includes AutomaticKeepAliveClientMixin
```

**Verification code**:
```dart
class _AnimatedCategoryCardState extends State<AnimatedCategoryCard>
    with AutomaticKeepAliveClientMixin {  // ← MUST have this mixin
  
  @override
  bool get wantKeepAlive => true;  // ← MUST return true
  
  @override
  Widget build(BuildContext context) {
    super.build(context);  // ← MUST call this
    // ...
  }
}
```

### Issue: Emojis Disappear on State Change (Gender/Language)

```dart
// This means full rebuild is happening
// Expected behavior with current fix:
// 1. Parent setState called
// 2. _categories list rebuilt
// 3. All cards rebuild (new widget instances created)
// 4. But _memoizedEmoji is in state, so doesn't change
// 5. EmojiText widget should show emoji without flicker

// If still flickering:
// → Verify _memoizedEmoji is being used, not widget.emoji
// → Check that EmojiText doesn't trigger rebuild itself
```

---

## Phase 8: Verification Tests

### Test 1: Console Logging
```dart
// Add to AnimatedCategoryCard:
@override
Widget build(BuildContext context) {
  debugPrint('🎨 CARD[${widget.categoryName}]: ${widget.emoji}');
  super.build(context);
  // ...
}

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  debugPrint('📌 didChangeDependencies: ${widget.categoryName}');
}
```

**Run these tests**:
```bash
# Test 1: Launch app
flutter run
# Expected: 14 "🎨 CARD" logs, one per category

# Test 2: Scroll up/down
# Expected: No new logs (cards not rebuilding)

# Test 3: Change language
# Expected: 14 "🎨 CARD" logs again (rebuild expected)

# Test 4: Scroll after language change
# Expected: No new logs
```

### Test 2: Frame Rate Check
```bash
# While app running, press P in terminal
# For each action, check FPS:

# ✅ Ideal Performance:
# - Initial load: 60 FPS after 500ms
# - Scrolling: Consistent 60 FPS
# - Language change: Brief dip to 30 FPS (OK), then back to 60
# - Post-language-change scrolling: 60 FPS

# 🔴 Performance Issues:
# - Any sustained < 40 FPS
# - Repeated janks (sudden drops)
# - Memory not releasing
```

---

## Phase 9: If Still Not Fixed

### Option 1: Switch to Icon Font
```dart
// Replace EmojiText with Icon widget
import 'package:flutter/material.dart';

const categoryIcons = {
  '👤': Icons.person,
  '🐶': Icons.pets,
  '🍎': Icons.apple,
  // ... etc
};

// In card:
Icon(categoryIcons[emoji]!, size: 50)
```

### Option 2: Use Image Assets
```dart
// Convert emojis to images
AssetImage('assets/emojis/person.png')
// Store 14 emoji images in assets/
```

### Option 3: Report to Flutter Team
If none of the above work, the issue might be device-specific:
```bash
# Create minimal reproduction case
# File issue at: https://github.com/flutter/flutter/issues
# Include:
# - Device model & Android version
# - Reproduction steps
# - Console output from debugging
```

---

## Quick Reference: Common Findings

| Symptom | Cause | Solution |
|---------|-------|----------|
| Blank emoji on launch | Null emoji value | Check _categories has all emoji keys |
| Emoji disappears when scrolling | Widget disposed | Verify AutomaticKeepAliveClientMixin present |
| Emoji flickers on gender/language change | Full rebuild loses reference | Verify _memoizedEmoji used in EmojiText |
| Some emojis always blank | Device lacks glyph | Use fallback emoji or icon |
| Memory grows while scrolling | Widgets not disposed when needed | Check addAutomaticKeepAlives setting |
| Janky scrolling (< 40 FPS) | Too many rebuilds | Check grid delegate optimization |

---

## Summary Checklist

- [ ] Phase 1: Fix was applied correctly
- [ ] Phase 2: Device & Flutter versions are compatible
- [ ] Phase 3: DevTools shows normal frame rate (60 FPS)
- [ ] Phase 4: Build count is as expected
- [ ] Phase 5: Emoji unicode values are correct
- [ ] Phase 6: No Android-specific rendering errors
- [ ] Phase 7: Specific issue diagnosed and addressed
- [ ] Phase 8: Verification tests pass
- [ ] 🎉 Flickering resolved!

---

**Last Updated**: December 27, 2025
