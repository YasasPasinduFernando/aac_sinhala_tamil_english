Emotion support audio (WAV), trilingual layout:

  assets/audio/support/en/*.wav
  assets/audio/support/si/*.wav
  assets/audio/support/ta/*.wav

Required stems (per language folder):
  happy.wav  sad.wav  angry.wav  fear.wav  surprise.wav  neutral.wav

Playback is triggered only from the emotion camera “Play support” button.
App language picks the folder (si-LK → si, ta-IN → ta, en-GB → en); if a
file is missing, English clips are used as fallback.
