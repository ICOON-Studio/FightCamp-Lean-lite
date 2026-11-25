# RINGCAM1 result (S559) - one ring camera for every picture: the step snap is gone

Worker: console (Opus 5.5). Brief: ops/research/TASK_RINGCAM1.md. Sample only; nothing under proto/ re-rendered, anim_web.py not run.

**HIS CAMERA WAS SAVED WHILE I WORKED.** `tools/camera_pick.cmd` ran from 01:04 (his Godot window, pid 51292, still open at
the end), 12 saves 01:06-01:11; the file now reads pitch 35.3, yaw 0.96 (360.963), size 3.149 m, look_y 0.639,
look_shift -0.165 (`saved_at 2026-11-26T01:11:42`, = saves 11 and 12 of `ops/previews/campick/saves.jsonl`). Every
sample picture below uses THAT save (checked before and after each render). If he saves again, the sample is stale
but the code is not: it reads the file at each run. The json is his: not committed by me.

## What changed
- `tools/pics2d_camera.gd`: `cam=ring` (the DEFAULT) / `cam=pair`; `mid()` = the camera's aim point: on the ring
  camera ONE fixed spot, `ring_at`; on `cam=pair` the old middle of the hips of who is in the picture (moved here
  word for word from `_aim`).
- `tools/pics2d_set.gd`: `_setup` reads `ring_at` once - the hips' middle of the pair in the guard at Long; `_aim`
  asks `CamPick.mid` (496 lines, was 499).
- `tools/pics2d_anim.gd`: frames.json gets `"camera": {ring, px_per_m, axis_px, size_m}` on the ring camera (absent on
  `cam=pair`, so its frames.json is unchanged). `axis_px` = picture px per metre along red -> blue (his camera:
  [243.85, 2.37]).
- `tools/pics2d_anim_more.gd` `_step_run`: one line beyond "aim call sites" (said out loud): a step now SETTLES
  40 frames on its start spot (`_home_guard(start, who)`) instead of settling at Long and being moved there just
  before frame 0. With a fixed camera this was the rest of the start snap: frame 0 drew the man 13-28 px short of his
  start spot (the guard had not caught up). A step that starts at Long runs the same code as before.
- `tools/step_travel_check.py`: reads .png renders as well as the page's .webp (the px bars scale with the width:
  6 page px = 9.6 px at 768); `--hold=<run>`; the shorts and boot bands are read off the men's own height (a raised
  camera); on a ring-camera folder a RED run is checked against the blue man's hold SLID by red's metres in (below).
  On today's page frames it prints exactly what STEPFIX1 printed.

## Where the ring spot is, and why not "the Mid midpoint"
The Long hips' middle. The page's hold pictures are always the BLUE man's (switch.html:273 `'blue_' + h`), made with
blue stood in (`_home_guard(step, who)` moves blue only). In those, red never moves and blue moves inward, so every
Mid and Inside hold lies inside the Long frame: aimed on the Long middle, Long frames as today and Inside fits
with room to spare. The Mid midpoint would move the whole frame 0.18 m toward red for nothing. ORTHO size: his 3.149 m
holds everything; today's 2.55 m held it too (Long was always the widest picture). Nothing needs widening.

## RED steps: the page must slide the picture (page side, not mine)
With one fixed camera, the pictures are in RING coordinates. After the RED man steps in, the pair stands one step
toward blue's corner, but the page still draws the blue man's Mid hold (blue stood in). The camera is orthographic,
so the two pictures differ only by a slide: **draw the hold slid by (metres red has stood in) x axis_px**, i.e.
0.355 m = 87 px at 768 = 54 px on the 480 page picture, per red step. The page keeps one number, red's metres in
(0 / 0.355 / 0.71, clamped by the range), and slides every picture by it. The strip's third row shows it: red's last
frame lands on the slid Mid hold. Without the slide, the ring camera makes RED steps snap by a full step (87 px)
at the end, which is worse than today. **So the full re-render must ship WITH this page change (switch.html, order.html
via make_order.py, kick.html, head.html, body.html - every page that draws ANIM).**

## The bars (python tools/step_travel_check.py E:/FightCamp/tmp/ringcam1/ring2 --hold=blue_both_high_high)
| run | travels | other man | last v next hold | first v previous hold | |
|---|---|---|---|---|---|
| blue_step_in_r2 | 90 px | 0 | 1 | **2** | PASS |
| blue_step_in_r1 | 90 | 0 | 1 | **2** | PASS |
| blue_back_off_r3 | 82 | 1 | 4 | **1** | PASS |
| blue_back_off_r2 | 83 | 1 | 4 | **0** | PASS |
| red_step_in_r2 | 78 | 0 | 8 | **2** | PASS (with the slide) |
| red_step_in_r1 | 78 | 0 | 8 | **2** | PASS (with the slide) |
| red_back_off_r3 | 74 | 0 | 12 | **2** | FAIL end |
| red_back_off_r2 | 74 | 0 | 12 | **2** | FAIL end |
(px of the 768 render; the bars: travel >= 40, other < 8, end and start <= 9.6.) Before (same sample, today's camera,
`E:/FightCamp/tmp/ringcam1/before`): start 45-66 px on every run, the RED_TEST; today's page frames: 28-41 page px.
The red back-off end: his take's last pose has the hips 0.05 m ahead of the guard's (12 px here, 6 page px on today's
frames - it sat on the bar already). Not a camera thing; the fix is to land the hips, not the root, on the next spot
(a few lines in `_step_run`'s carry) - left for the session, outside this brief.

## Checks
- REGRESSION, `cam=pair`: the HEAD code (copied to a temporary tools/_rc_old/, removed after) and the new code,
  same camera file, `only=blue_both_high_high,blue_step_in_r2`: **50 of 50 pictures and frames.json byte-identical.**
- Framing gate on his camera, ring aim: 0 refused in every run - holds at Long / Mid / Inside, all 12 step runs
  (including the plain step in / back off that go a step OUTSIDE Long), blue_jab_landed, blue_cross_landed.
- VISUAL: `ops/previews/s559_ringcam.png` (git-ignored folder, as STEPFIX1's strip), opened: row 1 today's camera,
  blue steps Mid -> Inside, both men jump right at frame 0; row 2 the ring camera, both men on their dashed lines from
  frame 0 to the Inside hold; row 3 red steps Long -> Mid onto the slid Mid hold. Both men head to feet in every tile.
- Parse: every render ran (no SCRIPT ERROR); no unit test covers these tools.

## The full re-render, the minute he says his angle is final
`sh E:/FightCamp/tmp/ringcam1/full.sh` (copies the camera file it used beside the output), in this order:
1. `pics2d_anim_more.gd` -> more: guard x3 ranges, steps, 8 holds x3 ranges (+ masks), feint, knockdown, 9 KO runs, push, clinch. ~20 min (GUESS: 9 runs took 2 min here; RINGANIM1's 15 took 5).
2. `pics2d_anim.gd` -> punches: 9 families x 3 results x 2 corners. ~22 min (48 runs took 19 in RINGANIM1).
3. The HOLDTAKES1 overrides (chain3.sh): `only=blue_body_hook_landed take=pro_kidney_shot`, `only=blue_lead_uppercut_blocked`. ~1 min each.
4. `pics2d_kick.gd` -> kicks: teep and low kick x 3 results x 2 corners, the shin check. ~3 min (GUESS).
5. `step_travel_check.py <dir>/more --hold=blue_lead_high`, then `anim_web.py <dirs> --strips ... --alias ...` (the
   alias list: S554 digest), `anim_stills.py`, `node proto/twohands/tools/anim_check.mjs`, `page_play_test.mjs`.
All runs `south=blue art=toon set=m`, through `godot_slot.py run --who ...` + `hidden_desktop.py`, his game checked first.

## Follow-ups the re-render forces
1. **The page slide for red's steps** (above): every page that draws ANIM, plus frames.json's `camera.axis_px` read by the page.
2. `proto/twohands/ring_ui.js` `TOES` (the front-toe x per range in the 480 px picture) and its `PX_M`: re-measure on
   the new pictures (the camera is 3.149 m wide now, not 2.55, and the men are no longer centred; and with the slide,
   red's toe moves with it).
3. `tools/pics2d_set.gd` `_dodge`: `var ppm := SIZE / ORTHO_M` -> `SIZE / cam.size`. With his 3.149 m it reads a miss's
   clearance 23% too large in px (CAMPICK1's note). One word; do it BEFORE the punch render, or misses clear by too much.
4. `Gate.fit` still re-centres a picture a man is cut from (only the knockdown needs it): it is the one place the camera
   leaves the ring spot. 0 times in this sample.
5. The red back-off end (above). 6. Commit his `tools/pics2d_camera.json` with the re-render.
