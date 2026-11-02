# TASK U211 - FOOTLOCK 2: split the sliding by cause, then kill the biggest cause

Model: gpt-6-luna, medium. Owner: Codex (S143: moved off Cursor - operator "cursor is almost out of quota ... retask u211"). Worktree `E:/FightCamp/wt/U211`, branch
`cursor/u211-footlock-by-cause` cut from `origin/cursor/u210-footlock-planner` (so the U210 planner is underneath).

## Why (operator, verbatim)
2026-10-02: "i see a lot of sliding in the video why the 3d fight is getting worse ?"
S143: "I want to see the new video working with everything on ... The fix on the footwork and sliding."

## The problem (primary source: your own research/U210_DIGEST.md)
U210's planner cut pooled planted slide 22% (5599 -> 4343 cm/fighter-min) but the s139 p95 barely moved
(2.649 -> 2.586 m/s; gate <= 1.32). Your own finding: `tools/s139_slide_probe.gd` (78 lines) counts EVERY low-foot
frame in the bout - strikes, joins, guard, reactions, clinch - and the planner only owns footwork beats. Nobody knows
which beat class holds the slide. Bucket first (S131 rule: "bucket a defect by clip first" - the code-read cause was
wrong last time, the per-clip split found it).

## Build
1. **Instrument.** `Godot/tools/u211_slide_by_cause.gd`: the s139 metric unchanged (posed planted feet, same height
   band, same seeds 92012/94301/17701, 30 s, `as_game`), PLUS each planted-foot sample tagged with what the body was
   doing that frame: `footwork`, `strike_whole` (and which clip), `sequence_step`, `join/between_take`, `guard_idle`,
   `slip/pull/catch`, `reaction`, `clinch_hold`, `walk_to_engine` (placement catching up, no take). Read the tag at the
   point of write - the FightStagePlayer state / room take that owns the root that frame - never inferred afterwards.
   Output: a table per bucket - frames, share of total slide cm, p95 m/s - for master AND the U210 branch.
2. **Fix the top bucket** (by share of slide cm). If it is root travel while a take holds the feet (the room moving the
   root under planted feet), the industry answer is: the feet stay planted and the root travel is either (a) given to
   a step (the planner's step trigger), or (b) refused/deferred to the next idle frame. Do NOT add a fifth IK pass
   (U185-U188 measured worse every time). One switch, `footlock_cause` (game ON, `--script` OFF), byte-identical off.
3. Re-run the instrument; then the second bucket if time allows.

## Acceptance
- The bucket table, master vs U210 vs U211, in `research/U211_DIGEST.md`.
- The top bucket's slide cm halved; bout-wide s139 p95 down vs U210 (target <= 1.32 m/s - say plainly if not reached).
- C223 rows unchanged: `python Tools/c223_parallel.py production -- report=u211_c223.json` all pass as on master.
- A 20 s silent live-room MP4 (seed 92012, as_game, `tools/record_room.gd` through `Tools\godot_hidden.ps1`), frames
  opened with your FILE tool, named in the digest.

## Owned files
`Godot/tools/u211_slide_by_cause.gd` (new), `Godot/scripts/FightStagePlayer.gd` (5,671 lines on master - NEVER read
whole: your U210 hooks are at ~2312-2320, ~3289-3305, ~4147-4174, ~5205-5395; `grep -n` for anything else),
`Godot/scripts/FightStepPlanner.gd`, `Godot/scripts/FightWorldLiveScreen.gd` (5,911 lines - only to add the switch beside
`_shuffle_from_bell` at ~753 and read root placement with `grep -n "_place_whole_bodies\|_face_and_walk"`),
`Godot/tests/fight_step_planner_test.gd`, `research/U211_DIGEST.md`.
**Delete `Godot/tools/u188_kneel_probe.gd` from the branch - it is 0 bytes on U210 and an empty .gd pops a native
"doesn't inherit SceneTree" dialog on the operator's screen every time anything runs it.** Copy the real file from
the U188 branch or leave it out.

## Prior research
`python Tools/prior_research.py slide planted footwork bucket` -> research/topics/footwork.md (canonical),
S4_BODY_LAYERS.md ("legs keep walking while the arms work" - 21% of body-frames carried with no locomotion),
J18_THE_OTHER_SEVENTY_PERCENT.md (shipped games clamp residual skate; play-rate matched to speed), U185-U188, U210 digests.

## What would a human do?
An animation programmer turns on foot-skate debug draw, colours each skating frame by the animation state that owns
it, and fixes the state that skates most - usually root motion applied while a non-locomotion clip is playing.

## Prefab check
Godot 4.7 has no built-in foot locking for scripted roots (SkeletonModifier3D/TwoBoneIK3D are already in use). The
planner (U186/U187 port) is the in-house prefab; extend it, do not replace it.

## Test (tier: script edited)
Parse gate: `python Godot/tools/check_scripts.py Godot/scripts/FightStagePlayer.gd Godot/scripts/FightStepPlanner.gd Godot/tools/u211_slide_by_cause.gd`.
Focused: `fight_step_planner_test.gd`. Then `python Godot/tools/run_tests.py --only fight_step_planner,fight_foot_lock,fight_leg_ik,fight_stage --jobs 2`.
Watchdog before every Godot run: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once`.

## The one trap
The instrument must tag by the root's OWNER at the frame of write. Tagging by "which clip is playing" mis-files the
frames where a take ended this frame and placement jumps the root to the engine's spot - those are exactly the
suspected skate frames.

Rules: never open a viewer or window (file tool only); git add explicit paths; commit; `git push -u origin cursor/u211-footlock-by-cause`.
Never edit HANDOFF.md. Do not stop at written.
