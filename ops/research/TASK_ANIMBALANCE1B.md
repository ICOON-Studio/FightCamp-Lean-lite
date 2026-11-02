# TASK ANIMBALANCE1B - keep the boxer's balance during slips in the live fight (wire BodyBalance behind a switch) (S207)
Model: gpt-6.1-sol (Codex, animation). Worktree E:\FightCamp\wt\ANIMBALANCE1B, branch codex/animbalance1b. Keep fixing and re-running
until green - no run limit. Approved: board Q-S204-1 (Ludo r38 s3, verdict LUDO_ROUND38_VERDICT_S204.md item 2 "BALANCE").

## Prior research
LUDO_ROUND38_S204_reply*.txt s3 (balance), TASK_ANIMBALANCE1A.md (the pure maths), LUDO_ROUND38_VERDICT_S204.md (our corrections).
## What would a human do?
An animator shifts the hips (only the hips) toward the planted feet when a slip leans the body past its base, never the feet.
## Prefab check
Godot has no CoM/support solver; the pure module exists (Godot/scripts/animation/BodyBalance.gd, merged S207, 72/0).

## Spec
1. NEW switch `anim_balance` on FightStagePlayer (default OFF; OFF = byte-identical pose). In the same post-animation pass as
   `_inside_uppercut_pose_pass()` (FightStagePlayer.gd ~line 3835 - read `sed -n 3820,3860p` and grep-found windows only; the file
   is 6,494 lines) add a balance pass: while a slip/pull/duck clip plays (grep the role names the player uses), build the joints dict
   BodyBalance.com() needs from the composed skeleton (skeleton updated first), decide planted feet from the foot bones' heights,
   call `BodyBalance.hip_correction(joints, left_planted, right_planted)` and move ONLY the Hips bone pose by the returned shift
   (horizontal). Root and both feet untouched (our rule above Ludo's code).
2. NEW `Godot/tools/c225_balance_gate.gd` (SceneTree, windowless): two DIFFERENT legal boxing pairs (reuse how c224_uppercut_gate.gd
   builds them), play every slip-class move the certified palette has (`assets/data/certified_moves.json`), sample every frame
   the CoM margin inside the support polygon; print `C225 move=<id> pair=<a>v<b> min_margin_cm=<x> pass=<bool>` and
   `C225 total=N fails=M`. PASS = margin >= 3.0 cm on every planted frame. FIRST run it on master (switch OFF) and record the numbers.
3. With the switch ON the gate passes (or improves every failing row; report each row before/after).

## Owned files
- `Godot/scripts/FightStagePlayer.gd` (only: the switch var + the balance pass call)
- `Godot/scripts/animation/BalanceLayer.gd` (NEW - the pose layer; BodyBalance.gd stays read-only)
- `Godot/tools/c225_balance_gate.gd` (NEW)
- `Godot/tests/anim_balance_switch_test.gd` (NEW)
- `research/ANIMBALANCE1B_DIGEST.md` (NEW)

## Acceptance (tier: script edited)
- `c225_balance_gate.gd` master OFF numbers + branch ON numbers, both printed in your summary.
- NEW `anim_balance_switch_test.gd`: OFF -> every bone pose identical to a run without the feature (30 frames, two different
  fighters); ON -> root and both foot bones identical to OFF on every frame.
- `python Godot/tools/run_tests.py --jobs 1 --only certified,fight_stage_playback,fight_stage_technique,intent_bus,bench1,inside_uppercut,body_balance`
  - nothing that was green may go red.
- Parse every touched .gd first; `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe"` (never the _console exe).

## The one trap
BodyBalance works in metres in world space on the XZ plane - feed it global bone positions (skeleton.global_transform * pose
origin) AFTER `force_update_all_bone_transforms()`, and convert the world-space hip shift back into the Hips bone's parent space.

## ROUND 2 (S207, Claude) - the crash was the PC, not your code
Round 1 (a2f63e4b) died on allocation failures / signal 11 because Windows' commit memory was full (3.6 GB free; browsers held
~20 GB). The operator added a pagefile on E: (commit free now ~11 GB) and the watchdog now goes RED on low commit. Re-run the
master OFF baseline (one Godot process at a time - never run the C225 rows in parallel), then do the whole task.
