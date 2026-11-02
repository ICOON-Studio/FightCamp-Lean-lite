---
name: feedback-ludo-writes-code-claude-integrates-s228
description: S228 operator - Codex replaced; Ludo writes complete code per item, Claude integrates on the PC (tests, stills, Cascadeur, merge)
metadata:
  type: feedback
---
The operator asked on S228 (2026-10-16): "you take the tasks of codex from now on ? use more ludo for code and if possible ludo replace codex ?"

**Why:** Codex is out of rotation ([[feedback-no-codex-tasks-s228]]). Ludo's long answers already include full GDScript (rounds 68-72, part E).

**How to apply:**
- Every Ludo round asks for COMPLETE, paste-ready GDScript in part E. Use a fresh chat per round, upload pictures, and ask for "CONTINUE" until the code is whole.
- Claude does Codex's PC job: wires Ludo's code into the right files, runs the parse gate and the tests (red first), renders stills on the game camera, does the Cascadeur work, and merges.
- Ludo cannot run Godot, the tests or Cascadeur, so it never closes an item alone.
- Cloud Cursor stays the UI builder and Arena stays on pure modules and tests.
- The owner rows live in roadmap.json plan.owners (rooms, animations, gym_floor -> Ludo + Claude).
Related: [[feedback-one-owner-per-area-s227]], [[feedback-ludo-checks-every-screen-s227]].
