# TASK NIGHTLY5B_FIX1 (S216) - make the face_drawn_foe fix smooth (no facing snap), then re-prove it

Model: Qwen qwen3-coder (Tools\qwen_task.cmd). SAME worktree E:/FightCamp/wt/NIGHTLY5B, SAME branch qwen/nightly5b (HEAD 28d537b6).

## Claude's review of 28d537b6 (your NIGHTLY5B fix)
The finding is right (separation_strip_velocity makes the drawn body line and the engine track line disagree during whole takes).
Two defects in the code change in `Godot/scripts/FightWorldLiveScreen.gd` `_toward_drawn_foe` (~line 3483):
1. HARD SWITCH = A VISIBLE SNAP: at dot = 0 the result jumps from `compensated` to `engine_forward` in one frame. When the two lines
   hover near 90 deg the fighter's facing flips back and forth between two directions.
2. The comment says "more than ~45 deg ... Blend toward the engine forward as the disagreement grows" but the code does not blend.

## Do
Replace the `if dot >= 0.0 ... return engine_forward` tail with a continuous blend:
`w = clampf(dot / 0.5, 0.0, 1.0)` (full compensation at <= 60 deg disagreement, engine forward at >= 90 deg), and return
`engine_forward.normalized().slerp(compensated, w)` (both normalised, horizontal; if either is ~zero length return engine_forward).
Make the comment say exactly that. Touch nothing else.

## Gates (run with --jobs 1; the PC is warm)
- `python Godot/tools/check_scripts.py Godot/scripts/FightWorldLiveScreen.gd`
- the test that printed `face_drawn_foe body-vs-drawn-aim p90` (the same one you ran) - it must still PASS ON < OFF; paste before/after.
- `python Godot/tools/run_tests.py --jobs 1 --only switch_gate,game_switches,hold_pair_geometry`
- ADD to the digest: a one-line continuity check - over the same bout, the largest frame-to-frame change of the returned facing
  (degrees) for your 28d537b6 version vs the blended version (the blended one must be smaller).
Commit on qwen/nightly5b, push, and update `research/NIGHTLY5B_DIGEST.md`. Owned files: `Godot/scripts/FightWorldLiveScreen.gd`
(this one function only), `research/NIGHTLY5B_DIGEST.md`. Nothing opens on the operator's screens.

## The one trap
FightWorldLiveScreen.gd is 6,645 lines - never read it whole (`sed -n 3460,3510p`).
