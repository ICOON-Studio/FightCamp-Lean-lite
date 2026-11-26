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

**apart_pic_m reads 0.001 at every distance, 0.50 included**: his camera (south=blue) looks down the line between the men,
so on the picture one trunk always covers the other. No distance fixes that - it is exactly what Phase 2 (the see-through
man in front) is for. The pick goes by the ring bars (apart 0.60, feet 0.16, head 0.60) and K50's 0.70-0.90 m.

**Pick: Inside = 0.55 m in** (was 0.71). The first distance where the guard AND the holds pass every ring bar with margin
(guard feet 0.217, head 0.627; holds 0.211 / 0.691); feet midpoints 0.80-0.82 m (inside K50's close range); every landed
hook and uppercut within 0.12 m of its contact (table above). 0.60 fails the guard's head bar (0.578) and holds the feet
with 0.001 m to spare; 0.50 puts the uppercuts over the 0.15 m glide bar.
Set: tools/pics2d_anim.gd RANGE_INSIDE_M 0.55, proto/twohands/ring_ui.js RANGE_M[1] 0.55, tools/step_travel_check.py
RANGE_IN _r1 0.55. Regression: page_play_test 4 passed on order, punch, head, kick; page_parse ok; rules_test 37; head_test
11; kick_test 12.
