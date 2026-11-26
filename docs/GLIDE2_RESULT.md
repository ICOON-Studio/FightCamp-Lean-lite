# GLIDE2 result (S562) - head moves and kicks at every range

Status: S564 rendered and measured (see the end); two leftovers named there. Was: **BLOCKED on renders**. The tools and the page side are done and committed; the pictures are not made yet.
The render chain (`ops/previews/s562_glide2/render.sh`, one windowed render at a time) waited while ArcheAge was open,
then Claude Code stopped it because the PC was critically low on memory. Nothing was rendered. It is not restarted
without the owner's or the main session's go.

Inside left for INSIDE1 (main session S562: the Inside distance is being widened). The tools read every range's spot
from the shared `RANGE_IN` table in `tools/pics2d_anim_more.gd` (no 0.71 in them; the teep push = RANGE_IN _r2 - Long).

## What was built
- `tools/pics2d_head.gd range=<3|2>`: the head-move runs at a page range (plain = Long, `_r2` Mid; a `range` field in
  the row). The puncher starts and ends on his spot at that range and steps into the punch's spot between (GLIDE1's glide,
  starting on the run's first DRAWN picture); the man who moves his head stays on his own spot.
  Ranges each run happens at on head.html (ACT reach; a lean back only at Mid or Long):
  jab_slipped Long, Mid · cross_slipped Mid (Inside for INSIDE1) · lead_hook_rolled / overhand_rolled Mid (Inside for INSIDE1)
  · jab_leaned Long, Mid · cross_leaned, lead_hook_leaned, overhand_leaned Mid.
- `tools/pics2d_kick.gd range=<3|2>`: the teep and low kick runs at Long and Mid (they reach Long and Mid on kick.html).
  The kicker is carried from his range spot into the kick's spot and back; the other man starts and ends on his spot (a
  miss's given ground and a teep's push ease in and out) - except a teep that LANDS at Mid ends with him one step back
  (the rules: range + 1).
- `proto/twohands/ring_ui.js`:
  - `atRange` takes `_slipped / _rolled / _leaned`-style head results and the kick results; warms them.
  - A teep landed at Mid: the page's counts move him one step back (matches the run's last picture).
  - A planning hold run STOPS when a beat run starts (all four pages share the same playRun; ring_ui now holds that copy).
    Measured on today's pages: the hold's pictures were drawn between the beat's (blue_lead_high_r2_4 between
    blue_cross_slipped_0 and _1, 11-17 px apart).
  - A miss SMOTHERED at a range it does not reach (a kick Inside, a jab Inside) with no run of that range plays that
    range's guard run (the men stand) instead of a run made a step away (the teep Inside jumped 68 px).

## RED test - today's pages (before new pictures)
Both men's back edges on screen, in 480-px picture units (the page's slide included), measured on every picture the page
drew in headless Edge (scratch recorder; holds sway +-8 by themselves). Jump = > 8 px between a hold and a run.

### head.html
| beat | run | hold before | first | last | hold after | jump in | jump out |
|---|---|---|---|---|---|---|---|
| L_blue_jab_slipped | blue_jab_slipped | 353 / 654 | 408 / 654 | 404 / 653 | 352 / 655 | **JUMP** +55 / +0 | **JUMP** -52 / +2 |
| L_red_jab_leaned | red_jab_leaned | 353 / 654 | 362 / 646 | 339 / 655 | 352 / 655 | **JUMP** +9 / -8 | **JUMP** +13 / +0 |
| M_blue_cross_slipped | blue_cross_slipped | 408 / 654 | 406 / 655 | 406 / 654 | 406 / 655 | -2 / +1 | +0 / +1 |
| M_red_hook_rolled | red_lead_hook_rolled | 408 / 654 | 416 / 625 | 412 / 620 | 406 / 655 | **JUMP** +8 / -29 | **JUMP** -6 / +35 |
| M_blue_over_leaned | blue_overhand_leaned | 408 / 654 | 409 / 650 | 402 / 688 | 406 / 655 | +1 / -4 | **JUMP** +4 / -33 |
| I_blue_hook_rolled | blue_lead_hook_rolled | 462 / 654 | 453 / 655 | 455 / 662 | - | **JUMP** -9 / +1 | - |
| I_red_cross_slipped | red_cross_slipped | 462 / 654 | 470 / 711 | 470 / 712 | 461 / 655 | **JUMP** +8 / +57 | **JUMP** -9 / -57 |
JUMPS 10

### kick.html
| beat | run | hold before | first | last | hold after | jump in | jump out |
|---|---|---|---|---|---|---|---|
| L_blue_teep_landed | blue_teep_landed | 353 / 654 | 394 / 668 | 409 / 663 | 352 / 655 | **JUMP** +41 / +14 | **JUMP** -57 / -8 |
| L_red_low_landed | red_low_kick_landed | 353 / 654 | 357 / 652 | 357 / 648 | 352 / 655 | +4 / -2 | -5 / +7 |
| M_blue_low_checked | blue_low_kick_blocked | 408 / 654 | 358 / 664 | 361 / 668 | 406 / 655 | **JUMP** -50 / +10 | **JUMP** +45 / -13 |
| M_red_teep_caught | red_teep_blocked | 414 / 654 | 398 / 679 | 413 / 670 | 406 / 655 | **JUMP** -16 / +25 | **JUMP** -7 / -15 |
| M_blue_teep_landed | blue_teep_landed | 407 / 654 | 394 / 668 | 409 / 663 | 352 / 655 | **JUMP** -13 / +14 | **JUMP** -57 / -8 |
| I_blue_teep_smothered | blue_teep_missed | 462 / 654 | 394 / 687 | 409 / 754 | - | **JUMP** -68 / +33 | - |
| I_blue_hook | blue_lead_hook_blocked_r1 | 462 / 654 | 471 / 655 | 471 / 653 | 461 / 655 | **JUMP** +9 / +1 | **JUMP** -10 / +2 |
JUMPS 11

## Still to do (after the renders)
`sh ops/previews/s562_glide2/render.sh` (head r3, r2; kick r3, r2) -> `python proto/twohands/tools/anim_web.py <dirs>
--strips <dir>` -> open the strips -> the same recorder at Long and Mid -> the green table here.

## Regression (with the ring_ui change)
page_play_test 4 passed on head.html, kick.html, order.html; head_test 11 passed; kick_test 12 passed; page_parse ok
(head, kick, order, switch); both tools pass a headless --check-only parse.


## S564 - rendered (ArcheAge closed, watchdog GREEN, one windowed render at a time)
`ops/previews/s562_glide2/render.sh`: head Long 4 runs, head Mid 16 runs, gate_failed 0. Kick Long / Mid: 11 runs each,
refused 1 (below). anim_web: 42 runs kept. Strips: ops/previews/s562_glide2/strips (head), ops/previews/s564_kick/strips
(kick) - all opened.

### The edge table, first pass: head moves green, kicks red
Measured with `proto/twohands/tools/edge_table.py` (S564, new: the old S562 recorder was a scratch file and is gone). Where
each man STANDS = the middle of his shorts (the step_travel_check band), red / blue, 480-px web units, with the page's slide
(a red run slid by how far blue stands in). The S562 table above used the outer edges, which a lean or a kicking leg moves.
Head moves, all 20 runs at Long and Mid: within 3 px in and out (the defender's feet stay; the head moves).
Kicks: the kicker 15-25 px off his hold at the first and last picture (43 jumps). Seen on overlays: the kick take stands
his hips away from his root, and the glide put the ROOT on the range's spot.

### The fix (tools/pics2d_kick.gd) and the second render
`_kglide` now also puts the kicker's HIPS where the guard puts them (the guard's Hips-to-root offset, read once at the
start of a range= run), eased out by the same weight as the glide (0 at the kick). Re-rendered: ops/previews/s564_kick/
render.sh (headless parse first, then Long and Mid), 22 runs.

| run | hold before | first | last | hold after | jump in | jump out |
|---|---|---|---|---|---|---|
| blue_cross_leaned_r2 | 162 / 314 | 163 / 314 | 165 / 316 | 162 / 314 | +1 / -0 | -2 / -2 |
| blue_cross_slipped_r2 | 162 / 314 | 162 / 315 | 164 / 314 | 162 / 314 | -0 / +1 | -1 / +0 |
| blue_jab_leaned_r2 | 162 / 314 | 163 / 312 | 165 / 314 | 162 / 314 | +0 / -2 | -2 / +0 |
| blue_jab_leaned | 162 / 368 | 163 / 366 | 165 / 368 | 162 / 368 | +0 / -3 | -2 / +0 |
| blue_jab_slipped_r2 | 162 / 314 | 163 / 312 | 162 / 314 | 162 / 314 | +0 / -2 | +0 / -0 |
| blue_jab_slipped | 162 / 368 | 163 / 366 | 162 / 367 | 162 / 368 | +0 / -2 | +0 / +1 |
| blue_lead_hook_leaned_r2 | 162 / 314 | 163 / 312 | 165 / 313 | 162 / 314 | +0 / -2 | -2 / +1 |
| blue_lead_hook_rolled_r2 | 162 / 314 | 163 / 312 | 165 / 313 | 162 / 314 | +0 / -2 | -2 / +1 |
| blue_low_kick_blocked_r2 | 162 / 314 | 166 / 314 | 162 / 304 | 162 / 314 | +4 / -0 | **JUMP** +1 / +10 |
| blue_low_kick_blocked | 162 / 368 | 167 / 368 | 162 / 358 | 162 / 368 | +4 / -0 | **JUMP** +1 / +10 |
| blue_low_kick_landed_r2 | 162 / 314 | 164 / 312 | 163 / 304 | 162 / 314 | +1 / -2 | **JUMP** -0 / +10 |
| blue_low_kick_landed | 162 / 368 | 164 / 366 | 163 / 358 | 162 / 368 | +1 / -2 | **JUMP** -0 / +10 |
| blue_low_kick_missed_r2 | 162 / 314 | 163 / 312 | 154 / 304 | 162 / 314 | +0 / -2 | **JUMP** +8 / +10 |
| blue_low_kick_missed | 162 / 368 | 163 / 366 | 154 / 358 | 162 / 368 | +1 / -2 | **JUMP** +8 / +10 |
| blue_overhand_leaned_r2 | 162 / 314 | 163 / 314 | 165 / 316 | 162 / 314 | +0 / -0 | -2 / -2 |
| blue_overhand_rolled_r2 | 162 / 314 | 162 / 314 | 165 / 316 | 162 / 314 | -0 / -1 | -2 / -1 |
| blue_teep_blocked_r2 | 162 / 314 | 162 / 311 | 162 / 313 | 162 / 314 | -0 / -3 | +1 / +1 |
| blue_teep_blocked | 162 / 368 | 162 / 365 | 161 / 367 | 162 / 368 | +0 / -3 | +1 / +1 |
| blue_teep_landed_r2 | 162 / 314 | 162 / 310 | 110 / 313 | 108 / 314 | -0 / -4 | -2 / +1 |
| blue_teep_landed | 162 / 368 | 162 / 364 | 157 / 367 | 162 / 368 | -0 / -4 | +5 / +1 |
| blue_teep_missed_r2 | 162 / 314 | 163 / 310 | 159 / 313 | 162 / 314 | +1 / -4 | +3 / +1 |
| blue_teep_missed | 162 / 368 | 164 / 364 | 159 / 367 | 162 / 368 | +1 / -4 | +3 / +1 |
| red_cross_leaned_r2 | 162 / 314 | 162 / 313 | 162 / 311 | 162 / 314 | -0 / -1 | +0 / +3 |
| red_cross_slipped_r2 | 162 / 314 | 162 / 313 | 162 / 313 | 162 / 314 | -1 / -1 | +0 / +1 |
| red_jab_leaned_r2 | 162 / 314 | 164 / 313 | 161 / 311 | 162 / 314 | +1 / -1 | +1 / +3 |
| red_jab_leaned | 162 / 368 | 165 / 368 | 161 / 365 | 162 / 368 | +2 / -1 | +2 / +3 |
| red_jab_slipped_r2 | 162 / 314 | 164 / 313 | 161 / 313 | 162 / 314 | +2 / -1 | +2 / +1 |
| red_jab_slipped | 162 / 368 | 164 / 368 | 161 / 368 | 162 / 368 | +2 / -0 | +1 / +1 |
| red_lead_hook_leaned_r2 | 162 / 314 | 163 / 313 | 161 / 311 | 162 / 314 | +1 / -1 | +1 / +3 |
| red_lead_hook_rolled_r2 | 162 / 314 | 163 / 313 | 162 / 312 | 162 / 314 | +1 / -1 | +0 / +3 |
| red_low_kick_blocked_r2 | 162 / 314 | 161 / 309 | 170 / 313 | 162 / 314 | -1 / -5 | -8 / +1 |
| red_low_kick_blocked | 162 / 368 | 161 / 364 | 170 / 367 | 162 / 368 | -1 / -5 | -8 / +1 |
| red_low_kick_landed_r2 | 162 / 314 | 162 / 313 | 171 / 314 | 162 / 314 | -1 / -1 | **JUMP** -8 / -0 |
| red_low_kick_landed | 162 / 368 | 162 / 367 | 171 / 369 | 162 / 368 | -0 / -1 | **JUMP** -9 / -0 |
| red_overhand_leaned_r2 | 162 / 314 | 164 / 313 | 160 / 311 | 162 / 314 | +2 / -1 | +3 / +3 |
| red_overhand_rolled_r2 | 162 / 314 | 163 / 313 | 159 / 312 | 162 / 314 | +1 / -1 | +4 / +3 |
| red_teep_blocked_r2 | 162 / 314 | 165 / 316 | 163 / 313 | 162 / 314 | +2 / +2 | -0 / +1 |
| red_teep_blocked | 162 / 368 | 166 / 370 | 163 / 368 | 162 / 368 | +4 / +2 | -0 / +1 |
| red_teep_landed_r2 | 162 / 314 | 165 / 314 | 163 / 364 | 162 / 368 | +3 / -0 | -0 / +4 |
| red_teep_landed | 162 / 368 | 166 / 368 | 163 / 371 | 162 / 368 | +4 / -0 | -0 / -3 |
| red_teep_missed_r2 | 162 / 314 | 165 / 314 | 163 / 315 | 162 / 314 | +3 / -1 | -0 / -1 |
| red_teep_missed | 162 / 368 | 166 / 368 | 163 / 369 | 162 / 368 | +4 / -0 | -1 / -1 |
JUMPS 8

### Left (named, not hidden)
- **The low kicks' last picture, 8-10 px** (8 rows above): the take ends in its own recovery stance (the kicking foot
  planted forward, feet switched), so the body sits ~10 px ahead of the guard; the hips are on the spot. A position fix
  cannot fix a stance - the take needs a recovery-to-guard tail (or the run ends earlier). Not done here.
- **red_low_kick_missed (Long and Mid) refused**: STILL_FRAMING FAIL at -0.15 s, blue's LeftToes at x 780 of 768 - the
  ground he gives on the miss takes his back foot out of the fixed ring camera. The page still plays the OLD run of that
  name (no range in its row): +167 px. Fix in `_kfind` / the miss's given ground (smaller at Long), then re-render it.
- Inside head moves (cross_slipped, lead_hook_rolled, overhand_rolled _r1): left to INSIDE1 (Inside is now 0.55 m).

Regression: page_play_test 4 passed on order, punch, head, kick; page_parse ok; rules_test 37; head_test 11; kick_test 12
(the ring_ui change is INSIDE1's Inside metres; no page change in this step).
