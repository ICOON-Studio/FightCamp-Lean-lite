# GLIDE2 result (S562) - head moves and kicks at every range

Status: **BLOCKED on renders**. The tools and the page side are done and committed; the pictures are not made yet.
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
