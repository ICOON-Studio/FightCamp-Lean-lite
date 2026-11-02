# TRAIN1B - slice 2: the move you picked is drilled ON the 3D floor (clip, progress bar, round-end float)

Model: Cline (OpenRouter free stealth model; seat ends 2026-10-05). Worktree E:/FightCamp/wt/CLINE, branch `cline/train1b`
from origin/master. Nothing opens on the operator's screen: stills only via `Tools\godot_hidden.ps1`, view images with
your FILE tool, never start/Invoke-Item/explorer/a browser.

## Why (operator, verbatim)
S150: "this needs also to be displayed in 2.5d the fighter training with the coach etc" and "the whole training selection
scene needs revamping and modernazation , you have all tools to make it the strongest hub of the game after the 3d fight".
S151 (D33): "i think i like the 3d aspect better" - so slice 2 lives on the existing 3D floor (`TrainingFloor3D.gd`), no
painting. Slice 1 (merged 8b4fa72f) lets the player pick a move at a station and press TRAIN THIS; today the floor then
shows nothing of it - the fighter keeps playing the station's generic clip and no number moves.

## Prior research
`TRAINING_LOOP_DESIGN.md` s4-s5 (watchable rounds, round-end gains, the coach in the mitt pocket),
`G112_TRAINING_LOOP.md`, `K85_SCENE_TREE_REVIEW.md` + `M41_SCENE_TREE_ART_REVIEW.md` (fighter + coach at the station,
progress visible on the floor), `J61_SCENE_TREE_GAMES_SURVEY.md` s4 (no shipped game previews a move; Two Point Hospital
training room = object -> one screen -> visible duration). TASK_TRAIN1_FLOOR_MOVE_PICKER.md = slice 1.

## What would a human do?
Look across the gym and see your boxer at the pads throwing THE move you told the coach to teach him, the coach catching
it, and between rounds hear "that's coming along" - a number that moves toward "learned".

## Prefab check
All of it exists already, only unwired: round clock + `round_ended` signal + tag pulse (`TrainingFloor3D.gd` l.1539-1556),
coach placed in the mitt pocket (`TrainingFloorLayout.place_coach` l.450, `TrainingFloor3D._build_coach` l.1392),
mastery pips as a 3D-bar pattern (`_build_mastery` l.1445), the move's clip (`FightClipBinding.clip_for(technique_id)`
l.2746, the same lookup `UIKit.technique_preview` uses at l.833), the plan numbers
(`GameState.get_technique_training_plan` l.5265 -> `progress.reps_completed`, `required_reps`,
`progress.weeks_trained`, `requirement.minimum_calendar_weeks`), the athlete's pick
(`athlete["technique_training_target"]`, written by `assign_technique_training` l.5311).

## Owned files (only these)
- `Godot/scripts/TrainingFloorPanel.gd` (1127 lines) - the fighter dict built in the roster loop, l.406-433: add keys `move_id`,
  `move_name`, `reps_done`, `reps_needed`, `round_gain` for a fighter whose `technique_training_target` is set AND whose
  plan `station_id` == his station today. Read with `sed -n 380,450p`.
- `Godot/scripts/TrainingFloorLayout.gd` (place_fighters l.360) - only if it drops unknown keys; pass them through.
- `Godot/scripts/TrainingFloor3D.gd` (2226 lines, never read whole: `sed -n 1288,1330p`, `1392,1478p`, `1539,1582p`,
  `1745,1820p`) - clip choice, progress bar, round-end float.
- `Godot/tests/train1b_floor_drill_test.gd` (NEW)
- `previews/train1b/` (stills)

## Spec (switch: `career.floor_move_picker`, the slice-1 switch; OFF = today's floor byte-identical)
1. CLIP: a fighter with a `move_id` plays that move's clip (`FightClipBinding.clip_for(move_id)`) looped at his station
   instead of `STATION_CLIPS[catalog_id]`. No clip found -> station clip (never a T-pose, never an empty body).
   Set `node.set_meta("clip", ...)` to the clip actually used, as today.
2. COACH: if the coach is in the mitt pocket for this fighter (`holding_for` == his id), the coach plays the mitt-holder
   idle he plays today; nothing new to build - just keep him there (the test checks he stays).
3. PROGRESS BAR: a thin 3D bar above the tag (reuse the pip height pattern): fill = reps_done / reps_needed, gold fill,
   dark track, a Label3D "JAB  34 / 60" (move name upper-case, reps). Node name `MoveBar` under the fighter node, meta
   `fill` (float 0-1). A learned move shows a full bar + "LEARNED".
4. ROUND-END FLOAT: on `round_ended`, each fighter with a `move_id` spawns a Label3D "+N JAB" (N = `round_gain`, the
   per-round share of today's reps: plan session units / rounds in a day; derive it from the coordinator's own numbers,
   name the constant) that rises ~0.6 m and fades over ~1.5 s, then frees itself. Node name prefix `GainFloat`.
   The bar's displayed fill steps up by the same amount (display only - the save is untouched until the week runs).
5. Icons over text with a tooltip where a 2D control is added (GLOSSARY 'Icon with tooltip'); 3D labels stay short.

## The test (write it FIRST) - `tests/train1b_floor_drill_test.gd`
Two DIFFERENT boxers (different stats via DevJump or the existing test fixtures; print both ids + stats), demo palette
(certified moves only). Assign boxer A a certified move at the mitts/bag via `assign_technique_training`; boxer B gets
none. Build the floor ON and assert: A's clip meta == clip_for(move); A has `MoveBar` with fill == reps_done/reps_needed
(±0.01); B has no MoveBar and plays his station clip; emitting `round_ended` once spawns exactly one GainFloat on A, none
on B, and A's bar fill rises by round_gain/reps_needed. OFF arm (control, cannot share the bug): same save, switch off ->
no MoveBar, no GainFloat, clips == STATION_CLIPS, and the floor's node-name tree equals the pre-change tree. Prove the
test can fail: break `clip_for` lookup to return "" and show the clip assertion goes red (record the red line).

## Gates
Parse: `python Godot/tools/check_scripts.py <every touched .gd>`. Test: `%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/train1b_floor_drill_test.gd`
(exit code alone is not a pass - read for FAIL / SCRIPT ERROR). Then
`python Godot/tools/run_tests.py --only training_floor,station_move,floor_drawer,gym_floor,room_click --jobs 2`.
Stills (open every one): `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <args> -- as_game`
showing a boxer at the pads with the coach, the bar, and a float mid-rise -> `docs/previews/train1b/`.
Commit on `cline/train1b`, push, end with the red-before line, the test totals and the still paths.

## The one trap
`as_game` must follow `--` or the game switches stay OFF and the still shows today's floor. And never fight two identical
fighters: A and B differ in stats, not just names.
