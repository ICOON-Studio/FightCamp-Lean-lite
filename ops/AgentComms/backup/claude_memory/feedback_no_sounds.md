---
name: feedback-no-sounds
description: "Operator 2026-09-28 \"i dont want to hear sounds\" - every background Godot run is silent (Dummy audio driver in godot_hidden.ps1)"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 3080d91d-d528-4603-8550-aaadcb517a03
  modified: 2026-09-27T22:30:04.451Z
---

Operator, 2026-09-28 (S116), verbatim: "i dont want to hear sounds". A windowed walk (s64_career_walk.gd through
Tools/godot_hidden.ps1) played the game's music and fight audio through his speakers.

**Why:** background jobs must not intrude on the operator's PC use (same family as [[feedback-no-popups]]).
**How to apply:** `Tools/godot_hidden.ps1` now prepends `--audio-driver Dummy` to every run; only a job that truly needs
audio sets `FIGHTCAMP_GODOT_AUDIO=on`. Never launch a windowed Godot or the .exe for a check outside that launcher.
Voice narration (say.ps1) stays foreground-only per [[feedback-narrate-in-voice]].
