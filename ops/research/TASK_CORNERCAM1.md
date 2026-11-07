# TASK CORNERCAM1 - GOOSE (cloud) - the corner minute's shots keep every head in frame

Status: OPEN (S397, Claude, anim-chain session). Discipline: boxing (the corner minute between rounds).

## Contract
OWNS: scripts/fight3d/CornerShots.gd, tests/corner_cam_test.gd
RED_TEST: tests/corner_cam_test.gd -> CORNER_CAM failures=0
REGRESSION: corner_lens_test, fight_polish_test, crowd_room_test, corner_warm_test
VISUAL: yes
FILM: --resolution 1920x1080 --script res://tools/corner_film.gd -- E:/FightCamp/tmp/cornercam1 film

## Why
Blind judges, S396 (ops/research/FIGHT_TESTS_S396.md): "The walk into the corner (`behind` shot) is tight: the coach's head
leaves the top of the frame." The shot (CornerShots.gd `"behind"`) aims at seat + 0.85 m with fov 34 from 3.7 m and dollies
0.9 m in: at 2.8 m the top of the frame is ~1.7 m above the canvas, under a standing coach's head. Other shots were fixed one
at a time (S396 low_out, corner_wide); nothing checks the whole shot list, so the next crew move breaks one again (another
seat, FIGHTWALK2, is moving the coach to work crouched in front of her right now).

## Do
1. Write tests/corner_cam_test.gd FIRST, headless (extends SceneTree; build FightStage + CornerCrew + CornerMinute the way
   tests/fight_polish_test.gd / tests/crowd_room_test.gd do, run a whole corner minute frame by frame with a fixed delta).
   Read the REAL Camera3D every frame (global transform + fov, aspect 16:9), not CornerShots' dictionary, and project points
   yourself (angle off the view axis vs half the fov, vertical and horizontal). Bars, per shot, at every frame of the shot:
   - a. people shots ("behind", "low_out", "side2", "corner_wide", "reverse", "ots", "other", "push"): the boxer's Head bone
     + 0.12 m (the top of her head) is inside the frame with at least 5% of the frame height to spare at the top;
   - b. the shots that show the coach ("behind", "side2", "corner_wide", "reverse", "other" for the blue coach): his Head
     bone + 0.12 m is inside the frame with 5% to spare, for at least 90% of the shot's frames;
   - c. inserts ("water", "ice", "cutman") are close-ups by design: only her face (Head bone) in frame;
   - d. the camera does not move on a fighter's step (operator C242: "stop moving the camera on every step a fighter does"):
     a shot without `track` moves only by its own drift (position change over the shot within 0.02 m of `drift`).
   Print one line per shot: name, frames, worst top margin for her and for the coach. The test must FAIL on main (b for
   "behind" at least); write main's numbers in the PR body.
2. Make it green in CornerShots.gd: frame from where the bodies are (the shot already reads bones at its start): raise the
   look point or widen / pull back the lens until both heads fit, keep every lens inside the ropes (the S380 / S386 rules:
   `inside()`, `keep_out()`, HALF_M, KEEP_M stay as they are), keep each shot's idea (behind = from the ring's middle
   behind her as she walks in; side2 = both in profile; ...).
3. Keep every REGRESSION test green. Do not touch CornerMinute.gd, CornerCrew.gd (FIGHTWALK2 owns them now),
   RingCamera.gd, FightView.gd, nor the fight model (scripts/rules/*, scripts/state/*, scripts/world/*).

## Rules
- Files under 500 lines (CornerShots.gd is 258). Commit with clear messages. No edits to ops/, tools/run_tests.sh or gates.
- Run Godot headless only (`--headless --audio-driver Dummy`); nothing opens on screen. The dispatcher films before/after.

## Result lines (PR body)
RESULT: CORNER_CAM main  <per shot: frames, her top margin, coach top margin>
RESULT: CORNER_CAM after <same>
RESULT: regression <pass/fail per test>

## Prior research
ops/research/FIGHT_TESTS_S396.md (blind corner notes); CornerShots.gd comments S307-S396 (each shot's history);
TASK_CORNERLENS1 (S386, the lens never inside a body).

## What would a human do?
A TV director in the corner minute frames the boxer and the coach together, head room above both, and holds the shot still
while they talk; inserts (water, ice, the cutman) are the only crops.

## Prefab check
No asset; camera framing maths only.
