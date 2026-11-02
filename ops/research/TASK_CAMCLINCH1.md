# TASK CAMCLINCH1 - ANTIGRAVITY - the fight camera's clinch angle (both heads seen while they hold)

Status: OPEN (S369, Claude). Seat: Antigravity (agy) on gemini-4-argon-high, via ops/Tools/seat_dispatch.py.
Discipline: boxing (the demo).

## Why
Operator S368: "many times it is behind the fighter and cant see". CAMVIEW1 (merged 51bc60b) fixed most of it:
cam_view_probe over 90 s of a live round, behind a boxer 36.9 % -> 2.8 %, chest hidden 6.1 % -> 0 %. Two lines still
FAIL, and both are clinches: either boxer's head hidden 5.1 % of frames (bar 5 %), the longest stretch 2.60 s at
t 43.7 (bar 1.0 s). In a tie-up the heads sit side by side, shoulder to shoulder; the broadcast lens stands side-on to
the pair (perpendicular to the line between their hips), which is exactly along the line between their heads - the near
head hides the far one for the whole hold.

## What the probe measures (read tools/cam_view_probe.gd first - do not edit it)
Every frame, from the game camera's lens, each boxer's head and chest: HIDDEN when the line from the lens to it passes
through the other boxer's torso or head capsule (the pose as shown). Bars: HEAD_HIDDEN_MAX 0.05, STRETCH_MAX_S 1.0,
BEHIND_MAX 0.05 (lens within 45 deg of straight behind a boxer). It prints CAMVIEW_SUMMARY ... PASS/FAIL.

## The job (scripts/fight3d/RingCamera.gd, and FightStage.gd's broadcast() only)
1. FightStage.broadcast(): tell the camera when a clinch is held, as it already tells it `avoid` (the referee): set
   `camera.clinch_heads = [head_a, head_b]` (world positions of both boxers' Head bones as shown, from their skeletons,
   or `stage.boxers[i]["pos"] + Vector3(0, 1.6, 0)` if a skeleton is missing) while `clinch.holder >= 0`, else `[]`.
2. RingCamera.broadcast(): while `clinch_heads` has two entries, the lens takes a CLINCH ANGLE instead of the shot's
   side-on yaw: turn it CLINCH_YAW_DEG = 40 off side-on, toward the side where the line from the lens to the far head
   clears the near head (try +40 and -40 against the current side; keep the one whose lens->far-head line passes
   furthest from the near head), raise it CLINCH_UP_M = 0.35 above the shot's height, and look at the midpoint of the two
   heads. Ease into it over ~0.4 s (the lerp broadcast() already uses), never a cut every frame; keep every existing rule
   - inside the ropes (spot_inside), the SIDE_ARC_DEG limit (clamp the clinch yaw to it), off the referee (avoid), never
   behind a boxer. When the clinch ends, ease back to the shot.
3. Keep RingCamera.gd under 500 lines (it is 320).

## Acceptance (Claude measures on your branch; numbers from the run, never from a description)
- tools/cam_view_probe.gd (90 s, windowed - the dispatcher's film runs it): CAMVIEW_SUMMARY PASS - either_head_hidden
  <= 0.05, longest_s <= 1.0, behind <= 0.05, inside 0.
- ring_lens_test, fight_flow_test, golden_path_test, clinch_rest_test green.
- Argon judges the before/after films (camera angle in the clinches); the operator judges after.

## Deliver
Edit only the OWNS files with your file tools; no shell. Do not commit: the dispatcher commits, tests, films and opens
the PR. Write docs/agy/CAMCLINCH1_result.md: what you changed, per numbered point.

## Contract
OWNS: scripts/fight3d/RingCamera.gd, scripts/fight3d/FightStage.gd:308-316, docs/agy/CAMCLINCH1_result.md
RED_TEST: tools/cam_view_probe.gd -- secs=90 -> CAMVIEW_SUMMARY
REGRESSION: ring_lens_test, fight_flow_test, golden_path_test, clinch_rest_test
VISUAL: yes
FILM: --resolution 1280x720 --script res://tools/cam_view_probe.gd -- secs=90

## Prior research
research/S368_DIGEST.md (CAMVIEW1 numbers), TASK_CAMVIEW1 (the merged lens rules), research/TWOPOINT_ALIGNMENT.md does
not apply (fight camera, not the gym).

## What would a human do?
A broadcast camera operator in a clinch walks round to the corner of the pair and lifts the camera, so both faces show
over the shoulders - never straight along their shoulder line.

## Prefab check
No engine camera rig solves occlusion of a specific pair; the probe's capsule test is the measure. RingCamera already has
spot_inside / high_spot - reuse them.
