# INSIDE1 - Inside too close, overlapping parts see-through (S562) - status

S564: Phase 1 step 1 done (the probe below, Inside = 0.55 m); the re-render follows. The S562 block (ArcheAge open, no run) is history.

## Done (code only; the page and the pictures are unchanged, because Inside is still 0.71)
- `tools/pics2d_anim.gd`: ONE table of the ranges, `RANGE_LONG_M 0 / RANGE_MID_M 0.355 / RANGE_INSIDE_M 0.71`
  (`RANGE_M` by page range). A punch run's `glide_from` reads it (it was `(3 - range) * 0.355`).
- `tools/pics2d_anim_more.gd`: `RANGE_IN` is built from that table, so pics2d_head.gd, pics2d_kick.gd and camera_pick.gd
  follow it unchanged. A ranged step run (step in ending on a range, back off starting on one) now starts on the NEIGHBOURING
  range and is carried the gap between the two (Mid -> Inside = RANGE_INSIDE_M - 0.355), by the take's own hip-travel
  share scaled to that gap (the same RootPath fraction as before, times the shorter distance). FootLock holds the standing
  feet. Each step run prints `STEP_SKATE <run>: carried <m>, standing toes slid <l> / <r> m` to compare foot slide before and after.
- `tools/pics2d_anim_more.gd probe_in=0.71,0.65,0.60,0.55,0.50`: the guard and the eight holds with blue that far in
  (red on his spot), one `INSIDE_PROBE` line each: roots gap, feet-midpoint gap, apart_m, apart_pic_m, feet_m,
  head_clear_m, PASS/FAIL against the gate's bars. It makes no pictures.
- `proto/twohands/ring_ui.js`: the slide is in metres (`RANGE_M`, the same numbers as the tool's table; `redM` / `blueM`
  move by the gap between the two ranges at each step or teep push). With 0.71 it plays exactly as before.
  page_play_test 4 passed on order, punch, head, kick; page_parse ok; rules_test 37 passed.

## The punch side of the choice, from the S562 GLIDE1 Inside runs (ops/previews/s562_glide/r1/frames.json)
The contact spots (m in from Long) of the hooks and uppercuts. At 0.71 every punch steps BACK to land (Inside is closer
than any contact). How far the puncher moves INTO the contact from a new Inside X (the bar is 0.15 m):

| run (landed) | contact | X=0.60 | X=0.55 | X=0.50 |
|---|---|---|---|---|
| lead hook (blue / red) | 0.544 / 0.562 | -0.06 / -0.04 | -0.01 / +0.01 | +0.04 / +0.06 |
| rear hook | 0.537 / 0.580 | -0.06 / -0.02 | -0.01 / +0.03 | +0.04 / +0.08 |
| lead uppercut | 0.612 / 0.655 | +0.01 / +0.06 | +0.06 / +0.11 | +0.11 / +0.16 |
| rear uppercut | 0.657 / 0.672 | +0.06 / +0.07 | +0.11 / +0.12 | +0.16 / +0.17 |
| body hook | 0.397 / 0.556 | back | back / +0.01 | back / +0.06 |

So 0.55 (feet midpoints ~0.85 m apart, inside K50's 0.70-0.90) keeps every landed hook and uppercut within 0.12 m; 0.50
puts the uppercuts over the bar. The pick still waits on the gate numbers of the holds (the probe).

## To finish (with ArcheAge closed and pc_watchdog.ps1 -Once exit 0)
1. `sh ops/previews/s562_inside/probe.sh` (waits for the game, then one hidden-desktop run, ~5 min): the INSIDE_PROBE table
   goes here; set RANGE_INSIDE_M (tool) and RANGE_M[1] (ring_ui.js) to the pick.
2. The re-render of TASK_INSIDE1 step 4 (54 hold/guard runs with masks, steps, punch _r1, feints, push, slip_in, head
   moves at Inside), anim_web, edge table, beat_shot, mask_shots.
3. Phase 2 (see-through overlap).
Not owned, still holding the old 0.71: `tools/step_travel_check.py` RANGE_IN (a copy) - update it with the pick.


## S564 Phase 1 step 1 - the probe (ops/previews/s562_inside/probe/run.log, one hidden-desktop run, south=blue)
Blue stood in that far, red on his spot; the guard and the eight holds (their last picture). The eight holds read the same
numbers at each distance (they differ in the hands; the measures are trunk, feet and head).

| Inside in (m) | row | roots | feet midpoints | apart_m (0.60) | feet_m (0.16) | head_clear_m (0.60) | apart_pic_m | ring bars |
|---|---|---|---|---|---|---|---|---|
| 0.71 | guard | 0.740 | 0.662 | 0.570 | 0.057 | 0.469 | 0.001 | FAIL apart+feet+head |
| 0.71 | 8 holds (same) | 0.740 | 0.639 | 0.603 | 0.051 | 0.533 | 0.001 | FAIL feet+head |
| 0.65 | guard | 0.800 | 0.722 | 0.630 | 0.117 | 0.528 | 0.001 | FAIL feet+head |
| 0.65 | 8 holds (same) | 0.800 | 0.699 | 0.663 | 0.111 | 0.592 | 0.001 | FAIL feet+head |
| 0.60 | guard | 0.850 | 0.772 | 0.679 | 0.167 | 0.578 | 0.001 | FAIL head |
| 0.60 | 8 holds (same) | 0.850 | 0.749 | 0.713 | 0.161 | 0.642 | 0.001 | PASS |
| 0.55 | guard | 0.900 | 0.822 | 0.729 | 0.217 | 0.627 | 0.001 | PASS |
| 0.55 | 8 holds (same) | 0.900 | 0.799 | 0.763 | 0.211 | 0.691 | 0.001 | PASS |
| 0.50 | guard | 0.950 | 0.872 | 0.778 | 0.267 | 0.676 | 0.001 | PASS |
| 0.50 | 8 holds (same) | 0.950 | 0.849 | 0.813 | 0.261 | 0.741 | 0.001 | PASS |

**apart_pic_m reads 0.001 at every distance, 0.50 included: a probe artifact, not his camera.** `_probe_inside` measures
before the run's picture camera is placed (`_view()` = the camera's look, pics2d_set.gd:449), so the trunks are flattened
along the men's own line. On his camera (south=blue, the GLIDE2 strips of S564) the men stand side by side and do not
cover each other at Long or Mid. The pick goes by the ring bars (apart 0.60, feet 0.16, head 0.60) and K50's 0.70-0.90 m;
the picture bar is checked for real by the step-4 renders (the gate runs on every contact frame with the camera placed).

**Pick: Inside = 0.55 m in** (was 0.71). The first distance where the guard AND the holds pass every ring bar with margin
(guard feet 0.217, head 0.627; holds 0.211 / 0.691); feet midpoints 0.80-0.82 m (inside K50's close range); every landed
hook and uppercut within 0.12 m of its contact (table above). 0.60 fails the guard's head bar (0.578) and holds the feet
with 0.001 m to spare; 0.50 puts the uppercuts over the 0.15 m glide bar.
Set: tools/pics2d_anim.gd RANGE_INSIDE_M 0.55, proto/twohands/ring_ui.js RANGE_M[1] 0.55, tools/step_travel_check.py
RANGE_IN _r1 0.55. Regression: page_play_test 4 passed on order, punch, head, kick; page_parse ok; rules_test 37; head_test
11; kick_test 12.


## S564 step 4 - everything made at Inside again, Inside = 0.55 m (ArcheAge closed, GREEN, one windowed render at a time)
`ops/previews/s564_inside/render.sh`:
- `pics2d_anim_more.gd` (masks on): the guard and the eight holds at Long, Mid and Inside, both corners (54 runs, each frame
  with its part mask - 10 colours, the head its own part: checked on blue_both_high_high_r1_0_mask and red_guard_0_mask),
  step_in_r1, back_off_r2, feint_r1, push (and the _ko runs, which the "red_lead_" / "red_rear_" prefixes also caught - same
  takes, re-made): 69 runs, refused 0, gate_failed 0.
- `pics2d_anim.gd range=1`: every punch at Inside, 42 runs; gate_failed 2 (blue_body_hook_landed_r1 head_clear 0.570,
  blue_lead_uppercut_blocked_r1 feet 0.159 - the same two S562 fixed): made again with the family's other take
  (pro_kidney_shot, pro_left_uppercut_hard, render_fix.sh) - both pass.
- `pics2d_head.gd range=1`: the head moves at Inside (cross_slipped, lead_hook_rolled, overhand_rolled, both corners), 6 runs;
  slip_in_r1 both corners, 2 runs. All pass.
anim_web: 119 runs kept. Strips: ops/previews/s564_inside/strips, all opened (17 sheets): the holds stand closer than Mid
with the bodies apart, every Inside punch starts and ends on the Inside spots.

### Steps (tools/step_travel_check.py) - all 8 PASS
Its red rows had failed by 34-52 px: it moved the hold by axis_px (render px, 768) on the 480-px web pictures - fixed
(scaled by the picture's width / render_px). After: blue/red step_in_r2, step_in_r1, back_off_r3, back_off_r2 all PASS
(the run's first and last picture within 1-4 px of the holds of the ranges it starts and ends on).

### The edge table at Inside (proto/twohands/tools/edge_table.py; where each man stands, the shorts' middle, 480 px)
The first pass had 22 jumps at Inside - and the same at Mid, so not the new distance: GLIDE1's punch runs (S562).
Three causes, fixed in tools/pics2d_anim.gd `_pose_at` / `_glide_w` and the runs made again (s564_punchfix, _punchfix2):
1. a miss's given ground stood on the run's ends (the defender 27-37 px back on the first and last picture): it now eases
   in and out with the glide;
2. a run whose punch starts late is drawn from offs[first], but the glide eased from offs[0] - on the first picture the
   puncher was already 30% into it (the crosses, the body jab: 11-23 px): the glide starts on the first DRAWN picture;
3. the puncher's hips (and on a miss the defender's) are put where the guard puts them at the run's ends.
After (every punch run at Inside):

| run | hold before | first | last | hold after | jump in | jump out |
|---|---|---|---|---|---|---|
| blue_body_cross_blocked_r1 | 162 / 284 | 162 / 285 | 161 / 285 | 162 / 284 | +0 / +0 | +1 / -1 |
| blue_body_cross_landed_r1 | 162 / 284 | 162 / 292 | 159 / 285 | 162 / 284 | -0 / +8 | +4 / -1 |
| blue_body_cross_missed_r1 | 162 / 284 | 162 / 284 | 165 / 285 | 162 / 284 | -0 / -0 | -2 / -1 |
| blue_body_hook_blocked_r1 | 162 / 284 | 162 / 286 | 163 / 284 | 162 / 284 | -0 / +2 | -0 / +1 |
| blue_body_hook_landed_r1 | 162 / 284 | 162 / 280 | 159 / 285 | 162 / 284 | +0 / -4 | +3 / -1 |
| blue_body_hook_missed_r1 | 162 / 284 | 162 / 284 | 164 / 284 | 162 / 284 | -0 / -0 | -2 / +0 |
| blue_cross_blocked_r1 | 162 / 284 | 162 / 284 | 164 / 284 | 162 / 284 | -1 / -0 | -1 / +1 |
| blue_cross_landed_r1 | 162 / 284 | 162 / 284 | 164 / 284 | 162 / 284 | -1 / -0 | -2 / +0 |
| blue_cross_missed_r1 | 162 / 284 | 161 / 284 | 165 / 283 | 162 / 284 | -1 / -0 | -2 / +2 |
| blue_cross_slipped_r1 | 162 / 284 | 162 / 284 | 163 / 285 | 162 / 284 | -0 / -0 | -1 / -1 |
| blue_feint_r1 | 162 / 284 | 162 / 285 | 162 / 284 | 162 / 284 | -0 / +1 | +0 / +0 |
| blue_lead_hook_blocked_r1 | 162 / 284 | 162 / 283 | 162 / 284 | 162 / 284 | -0 / -1 | +1 / +1 |
| blue_lead_hook_landed_r1 | 162 / 284 | 162 / 282 | 165 / 283 | 162 / 284 | -0 / -2 | -3 / +1 |
| blue_lead_hook_missed_r1 | 162 / 284 | 162 / 283 | 167 / 283 | 162 / 284 | -0 / -1 | -4 / +1 |
| blue_lead_hook_rolled_r1 | 162 / 284 | 162 / 282 | 164 / 283 | 162 / 284 | -0 / -2 | -2 / +1 |
| blue_lead_uppercut_blocked_r1 | 162 / 284 | 162 / 283 | 161 / 286 | 162 / 284 | -1 / -1 | +2 / -2 |
| blue_lead_uppercut_landed_r1 | 162 / 284 | 164 / 279 | 164 / 284 | 162 / 284 | +1 / -5 | -2 / +0 |
| blue_lead_uppercut_missed_r1 | 162 / 284 | 163 / 280 | 164 / 283 | 162 / 284 | +1 / -5 | -2 / +1 |
| blue_overhand_blocked_r1 | 162 / 284 | 162 / 283 | 162 / 287 | 162 / 284 | -0 / -1 | +1 / -2 |
| blue_overhand_landed_r1 | 162 / 284 | 162 / 284 | 164 / 287 | 162 / 284 | -0 / +0 | -1 / -2 |
| blue_overhand_missed_r1 | 162 / 284 | 161 / 284 | 163 / 286 | 162 / 284 | -1 / -0 | -0 / -2 |
| blue_overhand_rolled_r1 | 162 / 284 | 162 / 283 | 164 / 286 | 162 / 284 | -1 / -1 | -2 / -2 |
| blue_rear_hook_blocked_r1 | 162 / 284 | 162 / 283 | 162 / 287 | 162 / 284 | -0 / -1 | +1 / -2 |
| blue_rear_hook_landed_r1 | 162 / 284 | 162 / 284 | 164 / 287 | 162 / 284 | -0 / +0 | -1 / -2 |
| blue_rear_hook_missed_r1 | 162 / 284 | 161 / 284 | 163 / 286 | 162 / 284 | -1 / -0 | -0 / -2 |
| blue_rear_uppercut_blocked_r1 | 162 / 284 | 164 / 280 | 163 / 283 | 162 / 284 | +1 / -5 | -0 / +2 |
| blue_rear_uppercut_landed_r1 | 162 / 284 | 164 / 280 | 165 / 282 | 162 / 284 | +1 / -5 | -2 / +2 |
| blue_rear_uppercut_missed_r1 | 162 / 284 | 163 / 280 | 165 / 282 | 162 / 284 | +0 / -5 | -2 / +2 |
| red_body_cross_blocked_r1 | 162 / 284 | 162 / 284 | 161 / 283 | 162 / 284 | -0 / +0 | +1 / +1 |
| red_body_cross_landed_r1 | 162 / 284 | 156 / 282 | 160 / 285 | 162 / 284 | -6 / -2 | +2 / -0 |
| red_body_cross_missed_r1 | 162 / 284 | 163 / 284 | 160 / 281 | 162 / 284 | +0 / -0 | +3 / +3 |
| red_body_hook_blocked_r1 | 162 / 284 | 160 / 283 | 159 / 284 | 162 / 284 | -3 / -1 | +3 / +1 |
| red_body_hook_landed_r1 | 162 / 284 | 165 / 283 | 157 / 284 | 162 / 284 | +2 / -1 | +5 / -0 |
| red_body_hook_missed_r1 | 162 / 284 | 160 / 284 | 158 / 281 | 162 / 284 | -3 / -0 | +4 / +3 |
| red_cross_blocked_r1 | 162 / 284 | 162 / 283 | 162 / 283 | 162 / 284 | -1 / -1 | -0 / +1 |
| red_cross_landed_r1 | 162 / 284 | 162 / 283 | 161 / 282 | 162 / 284 | -0 / -1 | +2 / +2 |
| red_cross_missed_r1 | 162 / 284 | 162 / 284 | 162 / 281 | 162 / 284 | -1 / -0 | +1 / +3 |
| red_cross_slipped_r1 | 162 / 284 | 162 / 283 | 162 / 283 | 162 / 284 | -0 / -1 | +0 / +1 |
| red_feint_r1 | 162 / 284 | 162 / 283 | 161 / 284 | 162 / 284 | -1 / -1 | +1 / +0 |
| red_lead_hook_blocked_r1 | 162 / 284 | 163 / 283 | 161 / 283 | 162 / 284 | +1 / -1 | +1 / +1 |
| red_lead_hook_landed_r1 | 162 / 284 | 164 / 284 | 162 / 281 | 162 / 284 | +1 / -0 | +1 / +4 |
| red_lead_hook_missed_r1 | 162 / 284 | 163 / 284 | 161 / 283 | 162 / 284 | +1 / -0 | +1 / +1 |
| red_lead_hook_rolled_r1 | 162 / 284 | 164 / 284 | 161 / 282 | 162 / 284 | +1 / -1 | +1 / +2 |
| red_lead_uppercut_blocked_r1 | 162 / 284 | 166 / 284 | 161 / 283 | 162 / 284 | +4 / -0 | +1 / +1 |
| red_lead_uppercut_landed_r1 | 162 / 284 | 166 / 285 | 162 / 281 | 162 / 284 | +4 / +0 | +1 / +3 |
| red_lead_uppercut_missed_r1 | 162 / 284 | 166 / 284 | 161 / 281 | 162 / 284 | +4 / -0 | +1 / +3 |
| red_overhand_blocked_r1 | 162 / 284 | 162 / 284 | 159 / 284 | 162 / 284 | +0 / -0 | +3 / -0 |
| red_overhand_landed_r1 | 162 / 284 | 163 / 284 | 160 / 284 | 162 / 284 | +0 / -0 | +3 / +1 |
| red_overhand_missed_r1 | 162 / 284 | 163 / 285 | 159 / 281 | 162 / 284 | +0 / +1 | +3 / +3 |
| red_overhand_rolled_r1 | 162 / 284 | 162 / 283 | 159 / 282 | 162 / 284 | -0 / -1 | +4 / +2 |
| red_rear_hook_blocked_r1 | 162 / 284 | 162 / 284 | 159 / 284 | 162 / 284 | +0 / -0 | +3 / -0 |
| red_rear_hook_landed_r1 | 162 / 284 | 163 / 284 | 160 / 284 | 162 / 284 | +0 / -0 | +3 / +1 |
| red_rear_hook_missed_r1 | 162 / 284 | 163 / 285 | 159 / 281 | 162 / 284 | +0 / +1 | +3 / +3 |
| red_rear_uppercut_blocked_r1 | 162 / 284 | 167 / 284 | 162 / 283 | 162 / 284 | +4 / -1 | +0 / +1 |
| red_rear_uppercut_landed_r1 | 162 / 284 | 167 / 284 | 163 / 283 | 162 / 284 | +4 / -1 | -0 / +2 |
| red_rear_uppercut_missed_r1 | 162 / 284 | 167 / 284 | 162 / 281 | 162 / 284 | +4 / -0 | +0 / +3 |
JUMPS 0

Every ranged punch run at Long, Mid and Inside (108): 33 jumps before, 2 after:
| red_jab_missed | 162 / 368 | 164 / 396 | 161 / 397 | 162 / 368 | **JUMP** +2 / +28 | **JUMP** +1 / -29 |
| red_jab_missed_r2 | 162 / 314 | 164 / 342 | 161 / 343 | 162 / 314 | **JUMP** +2 / +28 | **JUMP** +1 / -29 |
JUMPS 4
red_jab_missed (Long, Mid) is the old S562 picture: the new one is refused (STILL_FRAMING FAIL at -0.20 s, blue's LeftToes
at x 845 of 768 - the pull-back take carries blue back out of the fixed camera). Left, named.

### On the page (beat_shot, ops/previews/s564_inside/beats) and the part masks (mask_shots, ops/previews/s564_inside/masks)
order.html and head.html at Inside: lead hook, cross, rear uppercut, feint; Mid -> Inside step in. Each beat plays the
hold, the _r1 run frame by frame, then the hold (BEAT_SHOT pictures lines); the screenshots (opened) show the men at an
inside-fighting distance, heads close, bodies and feet apart. One page note: on head.html the rear uppercut beat drew
guard.webp then blue_rear_uppercut_blocked.webp (the old stills, not the _r1 run) - the run was not ready (warmed) on that
page; order.html played the run. Not changed here (head.html's page half is not INSIDE1's).
mask_shots: 10 parts x 3 ranges on order.html and the two heads x 3 on head.html - 36 of 36 parts found, the head lights
alone at every range; the page does not scroll at 1920x1080.
Regression after all of it: page_play_test 4 passed on order, punch, head, kick; page_parse ok; rules_test 37; head_test
11; kick_test 12.

## Phase 2 (the see-through overlap) - NOT started, as the S564 resume says ("only if steps 1-3 are green")
Steps 1 and 3 are green at Inside. Step 2 (GLIDE2) and the punch runs it checked still have three named red rows, none at
Inside: the low kicks' last picture 8-10 px (the take ends in a switched stance), red_low_kick_missed and red_jab_missed
refused at Long and Mid (the defender's foot leaves the fixed camera on the miss). Phase 2 is the next build: per frame
each man alone as two layers, OVERLAP_ALPHA ~0.5 where the front man covers the back one; 3-4 Inside stills to the owner
first (TASK_INSIDE1.md Phase 2).
