---
name: session-S83-2026-09-26
description: S83 shipped training floor step 1 (training legible on today's screens); U178 reverted; Codex paused at 25% allowance
metadata:
  type: project
---
S83 (2026-09-26): TrainingPreview.gd is the one gain rule (planner forecast == applied gain; Qwen's blind Q185 test 25/0
against it). Per-day stat_history in the save drives profile bars + 7-day arrows, HOME "Yesterday on the floor" + Monday
report, planner EXPECTED gain + INJURY RISK, fight-week camp card. Fixed a fight-week crash on a Dictionary `slots`.

Lessons: a merged agent fix (U178 leg share) can pass its own gate and break a neighbour's (footwork m/min) - run the
neighbour subsets and a control run before pushing; revert, don't ship around. A restore trap must use absolute paths
(`cd` into Godot/ made `git checkout -- Godot/...` miss and left GameState.gd reverted until caught).
Codex burned 75% of its week vs Claude's 26% - see [[codex-allowance-2026-09-26]].
Next: S84 = 3D floor tiers 1-2; greybox the 23 prop-less items at G113 use-zone sizes until G114 verifies sources.
