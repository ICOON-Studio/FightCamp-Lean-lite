# TASK_TRAINCLIPS1 - her eight training sessions as pictures of her doing them (Cursor)
Model: Cursor (cursor_task.cmd). Discipline: boxing (demo). Repo: **E:\FightCamp\Lean** - worktree
E:\FightCamp\wt\LEAN_TRAINCLIPS1, branch `cursor/trainclips1`. Lean rules: its CLAUDE.md (no script over 500 lines, Godot
headless or the hidden desktop only, nothing opens on the screen, never the `_console.exe`).
Operator rule S338: "keep all agents working on animations and you work on the mechanics and ui" - this is the animation half
of the training screen Claude built in S349.

## Why
FIGHTERS > Training (S349, `scripts/ui/TrainingBoard.gd`, rules `scripts/rules/TrainingWeek.gd`) shows her week as eight
session cards round her body, from the operator's MMA home-training picture - in his picture every card has a PHOTO of the
exercise. Ours have a line icon. This task bakes one picture per session of HER (the fighter's own MetaHuman body) doing it.

## Spec
NEW `tools/bake_session_pics.gd` (extends SceneTree; template: `tools/bake_body_portraits.gd` - same lighting, kit and
camera code; read it first). For a boxer glb (arg `glb=res://assets/models/metahuman/mh_boxer_10.glb`, default that one) it
writes `assets/ui/training/<stem>_<session_id>.png`, 256 x 256, transparent background, 3/4 front view, head to feet in
frame, for these eight `TrainingWeek.SESSIONS` ids, posed from clips ALREADY in `assets/anim/baked` (sample the clip at the
named moment; `scripts/fight3d/BeatClips.gd` / `MoveClips.gd` show how clips are loaded and their contact times read):
| id | pose | prop (simple mesh, our colours) |
|---|---|---|
| shadow | jab at its contact time | none |
| heavy_bag | cross at its contact time | heavy bag: cylinder 0.35 m wide, 1.0 m tall, hanging so the glove touches its face |
| sparring | guard / block loop (`mc_Box1_M3_Block_Loop`) | none |
| slip_rope | `boxing_slip` at its deepest point | a rope line at her head height, across her front |
| pads | lead hook at its contact time | a focus mitt where the glove lands (round pad 0.24 m, black) |
| speed_bag | a short combo punch at first contact, hands at eye height | speed bag on a board above her eye line |
| roadwork | `loc_advance` mid step (a jog stand-in; say so) | none |
| neck | `mc_Box1_M3_Idle` chin tucked (stand-in; say so) | none |
Then wire it: `TrainingBoard._session_card` shows `<stem>_<id>.png` (64 x 64, left of the name) when the file exists and keeps
the icon when it does not. That is the ONLY change to TrainingBoard.gd.

## Contract
OWNS: Lean/tools/bake_session_pics.gd, Lean/assets/ui/training/, Lean/tests/session_pics_test.gd, Lean/scripts/ui/TrainingBoard.gd (the picture only)
RED_TEST: tests/session_pics_test.gd -> SESSION_PICS failures=0
REGRESSION: training_week_test, grey_reason_test, golden_path_test
VISUAL: yes - Claude opens each picture (you cannot see images: check geometry in the test)

## The test - NEW `tests/session_pics_test.gd` (prints `SESSION_PICS failures=<n>`)
For mh_boxer_10's eight pictures: each file exists, is 256 x 256 with alpha; the opaque bounding box is at least 80 % of the
height (head to feet) and touches neither the top nor the bottom edge; no two pictures are pixel-identical (eight different
poses); the heavy_bag and pads pictures have prop pixels (their prop colour) within 6 px of glove pixels (red). It must fail
before the bake runs (no files).

## How to run (exact)
Bake (GPU, hidden desktop): `python tools/hidden_desktop.py run --timeout=300 "%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --path . --windowed --resolution 1280x720 --audio-driver Dummy --log-file E:/FightCamp/tmp/session_pics.log --script res://tools/bake_session_pics.gd -- glb=res://assets/models/metahuman/mh_boxer_10.glb`
Test: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tests/session_pics_test.gd`
Regression: `sh tools/run_some.sh training_week_test grey_reason_test golden_path_test`
Then the training still: `python tools/hidden_desktop.py run --timeout=200 "%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --path . --windowed --resolution 1920x1080 --audio-driver Dummy --log-file E:/FightCamp/tmp/training_still.log --script res://tools/training_still.gd -- E:/FightCamp/wt/LEAN_TRAINCLIPS1/docs/playtest/trainclips`
Commit only owned files + the two stills; push `cursor/trainclips1`. End: `RESULT: tests/session_pics_test.gd -> SESSION_PICS failures=0`.

## The trap
A picture that is cropped (feet or head cut) or a blank frame passes a file-exists check: the bounding-box checks are the
real test. Do not pose with your own hand-set bone angles - every pose comes from a clip; a stand-in clip is named as one.

## Prior research
`python Tools/prior_research.py training station clip` -> topics/training_floor.md (U180 speed bag + skipping station clips,
C209 drill gate - in the OLD repo, not importable here), TrainingWeek.gd header (sessions and the stat each builds).

## What would a human do?
A game artist makes one "exercise card" picture per drill from the character's own rig: pose from the real animation at its
most readable frame (the punch at contact, the slip at its deepest), a simple prop, the same light and camera for all, so the
set reads as one family - the way his MMA home-training sheet does.

## Prefab check
Mixamo has jogging / skipping / neck clips (in the old repo, E:\FightCamp\Game\Godot\assets\anim\mixamo_gymlife) but they
are not retargeted to Lean's MetaHuman rig: round 2 imports them for roadwork and neck. Ludo / Tripo make props only (bodies
stay MetaHuman, operator S334). No ready-made exercise-card set exists for our bodies.

## VISUAL GATE
Claude opens all eight pictures and the training still before merging: her own face and kit, head to feet, the punch
pictures with the glove ON the prop, no T-pose, no floating prop.
