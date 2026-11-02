# TASK_MOVECLIPS1 - every boxing move on the map has its clips (Qwen)

Model: qwen3-coder. Discipline: BOXING (demo). Operator S338: "keep all agents working on animations" - this is animation
coverage. Repo: **E:\FightCamp\Lean** (worktree E:\FightCamp\wt\LEAN_MOVECLIPS1, branch `qwen/moveclips1`). Lean rules:
its CLAUDE.md, no script over 500 lines, Godot headless only, nothing opens on the screen.

## Why
The boxing move map (`scripts/rules/StrikeMap.gd`, const MOVES, 30 moves: steps, combos, defences, forced moves, each with
`id`, `name`, `kind`, `combo`, `from`, `to`) is what the coach plans with. The 3D fight shows clips from
`scripts/fight3d/FightClips.gd`: native punches (CLIPS: jab, cross, lead_hook), BAKED roles (idle, react_head, react_body,
react_leg->react_hurt, advance, retreat, strafe_left, strafe_right, slip, pull, body_hook, rear_uppercut, clinch_att,
clinch_vic ...) and MoCap Online Punch PRO: 145 files `assets/anim/baked/mc_Box1_M3_<Name>.res`, loaded as
`pro_<name lower case>` (FightClips.pro_name). Nothing says which clips show each map move, so a planned move cannot be shown.

## Spec
NEW pure data module `scripts/fight3d/MoveClips.gd` (extends RefCounted, preloads nothing):
- `const MAP := {move_id: [clip names in play order]}` for EVERY StrikeMap move id (30). Clip names are the names the
  fight's AnimationPlayer holds: "jab", "cross", "lead_hook", BAKED values ("advance", "slip", "body_hook", ...) and
  "pro_<name>" for Punch PRO files (e.g. mc_Box1_M3_Left_Uppercut.res -> "pro_left_uppercut"). Read the file list in
  assets/anim/baked/ and FightClips.gd before choosing.
- Choose like a boxing coach reading the move: a combo = its punches in order (StrikeMap's `combo` code: 1 jab, 2 cross,
  3 lead hook, 3b lead body hook, 6 rear uppercut ... read the codes in StrikeMap.gd/Combos.gd), preferring Punch PRO clips;
  "slip 2-3" starts with a slip; steps use advance/retreat/strafe (cut_off, herd, pivot_out: strafe + advance); defences
  (tie_up -> clinch_att, roll_out -> a weave/dodge PRO clip then retreat); forced moves (backed_up -> retreat x2,
  break/push_off -> retreat, spins_out -> strafe). Every id gets at least one clip.
- `static func clips(move_id: String) -> Array` (empty array for an unknown id), `static func missing(have: Array) -> Array`
  (the clip names in MAP that are not in `have`).
- A short `## why` comment per non-obvious choice.

## Contract
OWNS: Lean/scripts/fight3d/MoveClips.gd, Lean/tests/move_clips_test.gd
RED_TEST: tests/move_clips_test.gd -> PASS move_clips_test
REGRESSION: strike_map_test, beat_clips_test
VISUAL: no (Claude renders moves later)

## The test (write it FIRST; red on main)
`tests/move_clips_test.gd` (extends SceneTree): every StrikeMap.MOVES id has a non-empty list; every clip name resolves:
a CLIPS key, a BAKED value, or "pro_" + a file in assets/anim/baked/ (build the name set from FightClips the way it does -
use FightClips.pro_stems()/pro_name and its BAKED/CLIPS consts); each combo move lists at least as many punch clips as its
combo code has punches; `clips("nope")` is empty; `missing(<all names>)` is empty. Ends `PASS move_clips_test` /
`FAIL <n>`, quit(0/1); a SCRIPT ERROR line is a failure even with exit 0.
Command: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tests/move_clips_test.gd`
then the two REGRESSION tests the same way. Do NOT edit tools/run_tests.sh. The plain exe only; never the _console.exe.

## Final answer
`RESULT: tests/move_clips_test.gd -> PASS move_clips_test`, the MAP printed (move -> clips), the last lines of each run,
the files touched.

## Prior research
searched: move clips boxing map -> STRIKEMAP_S335.md (the map), FightClips.gd (S299 Punch PRO baking), J17_THE_CLIP_COUNT.md
(buy by punch type; block/slip are poses or short clips).

## What would a human do?
An animator on a boxing game keeps a move list -> animation table and checks every planned move has its takes before the
fight scene uses it.

## Prefab check
Owned: MoCap Online Punch PRO + Starter (bought by the operator), the old game's baked clips. Nothing new downloaded.

## The trap
Never invent a clip name - only names that exist on disk / in FightClips. Do not touch FightClips.gd or FightStage.gd.
