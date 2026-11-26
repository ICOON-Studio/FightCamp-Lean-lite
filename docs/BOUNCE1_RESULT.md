# BOUNCE1 - never still: a light bounce while the player plans (S565, console worker)

Task: ops/research/TASK_BOUNCE1.md; launch note ops/research/RESUME_S565_BOUNCE1.md. Renders on 2026-11-26 with the watchdog
GREEN, ArcheAge closed, one hidden-desktop render at a time (godot_slot), south=blue on the owner's ring camera.

## What was built
- **tools/pics2d_bob.gd** (new, 184 lines; extends pics2d_anim_more.gd, which is at 464 lines - the block would have
  taken it past the 500-line rule, so it is a sibling with the same command line). For each hold (the eight one-hand /
  two-hand holds) and the plain guard, at Long, Mid and Inside (RANGE_IN, read from the tool - Inside 0.55 m), both
  corners: `<corner>_<hold>_bob[_r1|_r2]`, 5 pictures at 0.0-0.4 s, one bounce every 0.5 s. With part masks (mask=on), so
  the body view keeps working on the bouncing pictures. 54 runs, 270 frames, refused 0, gate_failed 0.
- **proto/twohands/ring_ui.js**: when a hold run played in plan settles, its `_bob` run loops (0.1 s a picture, back to the
  first after 0.5 s) until the beat is fought. Any other run stops it; Fight stops it at once and puts the hold's last
  picture back, so the beat's run starts from where it always did. No `_bob` run on disk = the still, as before.
- **proto/twohands/version.js**: 0.565.4, one line ("Never still ...").

## How the bounce is made (my call, and why)
A lower-body LAYER, not a bake of a bounce take. The hold take is stopped on its last picture (the authored arms, the
guard, the head exactly as the hold run ends); a small SkeletonModifier3D added last on each skeleton lowers the hips by
up to 2.6 cm and rocks them 1.2 cm forward/back over the feet, then bends each leg back onto where its ankle stood (the
two-bone solve FootLock/FloorStand use, the foot keeping its turn). So the feet cannot leave their spots and the guard
rides with the body unchanged.
Not the takes on disk: `ow_bounce_idle` moves the hips 0.19 m and turns the body 30 deg (clip_db), `st_bounce_guard` has
its own arms and stance; laid under the authored holds either one moves the feet off the hold's spots (a jump on the page)
and swings the arms with the torso. (`pro_bounce` does not exist: GuardLife's bounce is `ow_bounce_idle`.)
Both men bounce - the man who holds and the other man in his guard - red a fifth of a cycle behind blue: in lockstep two
men read as a machine (GuardLife's note: "bounce correlated 0.92").
The loop's first picture is the hold's last one with no dip and no sway (blue exactly; red is 0.2 of a cycle in, 1-4 px).

## Proof
### The bars, read on the drawn skeleton (BOB_GATE, every run)
Head: 0.024 m at most off the hold's height (bar +-0.03) for every man in all 54 runs. Ankles: 0.0011 m at most off the
hold's (bar 0.005). (The stage's own bone reads come before the skeleton modifiers, so the tool reads what is DRAWN: the
first smoke run read 0.000 everywhere through Gate.world while the pictures plainly moved - fixed before the full render.)

### The edge table (where each man stands, the middle of his shorts, 480-px page pictures; jump = > 8 px)
Each loop against its hold's last picture (the worst of its 5 pictures), and the loop's own seam (last -> first).
| loop | hold last (red / blue x, top y) | worst bob frame off the hold (red / blue / top) | loop seam last->first | |
|---|---|---|---|---|
| blue_both_high_high_bob | 163 / 367 / 92 (blue_both_high_high_6.webp) | 2.7 / 2.3 / 4 | 2.3 / 1.3 / 2 |  |
| blue_both_high_high_bob_r1 | 163 / 284 / 93 (blue_both_high_high_r1_6.webp) | 2.8 / 2.4 / 3 | 2.2 / 1.3 / 1 |  |
| blue_both_high_high_bob_r2 | 163 / 313 / 93 (blue_both_high_high_r2_6.webp) | 2.7 / 2.4 / 3 | 2.4 / 1.2 / 1 |  |
| blue_both_high_low_bob | 163 / 367 / 92 (blue_both_high_low_6.webp) | 2.6 / 2.4 / 4 | 2.2 / 1.2 / 2 |  |
| blue_both_high_low_bob_r1 | 163 / 284 / 93 (blue_both_high_low_r1_6.webp) | 2.5 / 2.4 / 3 | 2.2 / 1.3 / 1 |  |
| blue_both_high_low_bob_r2 | 163 / 313 / 93 (blue_both_high_low_r2_6.webp) | 2.5 / 2.4 / 3 | 2.3 / 1.2 / 1 |  |
| blue_both_low_high_bob | 163 / 368 / 92 (blue_both_low_high_6.webp) | 2.7 / 2.3 / 4 | 2.1 / 1.3 / 2 |  |
| blue_both_low_high_bob_r1 | 163 / 284 / 93 (blue_both_low_high_r1_6.webp) | 2.5 / 2.3 / 3 | 2.1 / 1.3 / 1 |  |
| blue_both_low_high_bob_r2 | 163 / 314 / 93 (blue_both_low_high_r2_6.webp) | 2.5 / 2.4 / 3 | 2.1 / 1.1 / 1 |  |
| blue_both_low_low_bob | 163 / 368 / 92 (blue_both_low_low_6.webp) | 2.7 / 2.3 / 4 | 2.3 / 1.3 / 2 |  |
| blue_both_low_low_bob_r1 | 163 / 284 / 93 (blue_both_low_low_r1_6.webp) | 2.7 / 2.2 / 3 | 2.1 / 1.4 / 1 |  |
| blue_both_low_low_bob_r2 | 163 / 314 / 93 (blue_both_low_low_r2_6.webp) | 2.6 / 2.3 / 3 | 2.2 / 1.1 / 1 |  |
| blue_guard_bob | 163 / 368 / 97 (blue_guard_0.webp) | 2.6 / 2.8 / 3 | 2.3 / 1.1 / 1 |  |
| blue_guard_bob_r1 | 162 / 284 / 97 (blue_guard_r1_0.webp) | 2.6 / 2.1 / 3 | 1.9 / 1.1 / 1 |  |
| blue_guard_bob_r2 | 162 / 314 / 97 (blue_guard_r2_0.webp) | 2.7 / 2.2 / 3 | 2.1 / 1.1 / 1 |  |
| blue_lead_high_bob | 163 / 367 / 92 (blue_lead_high_6.webp) | 2.5 / 2.4 / 4 | 2.2 / 1.2 / 2 |  |
| blue_lead_high_bob_r1 | 163 / 284 / 93 (blue_lead_high_r1_6.webp) | 2.6 / 2.4 / 3 | 2.3 / 1.3 / 1 |  |
| blue_lead_high_bob_r2 | 163 / 313 / 93 (blue_lead_high_r2_6.webp) | 2.6 / 2.5 / 3 | 2.3 / 1.1 / 1 |  |
| blue_lead_low_bob | 163 / 368 / 92 (blue_lead_low_6.webp) | 2.5 / 2.3 / 4 | 2.1 / 1.3 / 2 |  |
| blue_lead_low_bob_r1 | 163 / 284 / 93 (blue_lead_low_r1_6.webp) | 2.7 / 2.3 / 3 | 2.1 / 1.4 / 1 |  |
| blue_lead_low_bob_r2 | 163 / 314 / 93 (blue_lead_low_r2_6.webp) | 2.6 / 2.3 / 3 | 2.1 / 1.1 / 1 |  |
| blue_rear_high_bob | 163 / 367 / 92 (blue_rear_high_6.webp) | 2.7 / 2.4 / 4 | 2.2 / 1.3 / 2 |  |
| blue_rear_high_bob_r1 | 163 / 283 / 93 (blue_rear_high_r1_6.webp) | 2.5 / 2.3 / 3 | 2.0 / 1.2 / 1 |  |
| blue_rear_high_bob_r2 | 163 / 313 / 93 (blue_rear_high_r2_6.webp) | 2.8 / 2.5 / 3 | 2.1 / 1.2 / 1 |  |
| blue_rear_low_bob | 163 / 367 / 92 (blue_rear_low_6.webp) | 2.8 / 2.4 / 4 | 2.2 / 1.3 / 2 |  |
| blue_rear_low_bob_r1 | 163 / 284 / 93 (blue_rear_low_r1_6.webp) | 2.6 / 2.4 / 3 | 2.1 / 1.2 / 1 |  |
| blue_rear_low_bob_r2 | 163 / 313 / 93 (blue_rear_low_r2_6.webp) | 2.6 / 2.4 / 3 | 2.1 / 1.1 / 1 |  |
| red_both_high_high_bob | 163 / 368 / 93 (red_both_high_high_6.webp) | 3.5 / 2.1 / 3 | 2.4 / 1.0 / 1 |  |
| red_both_high_high_bob_r1 | 246 / 368 / 93 (red_both_high_high_r1_6.webp) | 3.7 / 2.1 / 3 | 1.9 / 1.0 / 2 |  |
| red_both_high_high_bob_r2 | 216 / 368 / 93 (red_both_high_high_r2_6.webp) | 4.1 / 2.1 / 3 | 2.8 / 1.0 / 2 |  |
| red_both_high_low_bob | 163 / 368 / 93 (red_both_high_low_6.webp) | 3.5 / 2.2 / 3 | 2.3 / 1.0 / 1 |  |
| red_both_high_low_bob_r1 | 246 / 368 / 93 (red_both_high_low_r1_6.webp) | 3.6 / 2.2 / 3 | 1.8 / 1.1 / 2 |  |
| red_both_high_low_bob_r2 | 216 / 367 / 93 (red_both_high_low_r2_6.webp) | 3.9 / 2.0 / 3 | 2.1 / 1.0 / 2 |  |
| red_both_low_high_bob | 161 / 368 / 93 (red_both_low_high_6.webp) | 3.8 / 2.2 / 3 | 2.1 / 1.0 / 1 |  |
| red_both_low_high_bob_r1 | 245 / 368 / 93 (red_both_low_high_r1_6.webp) | 3.9 / 2.1 / 3 | 2.5 / 1.0 / 2 |  |
| red_both_low_high_bob_r2 | 215 / 368 / 93 (red_both_low_high_r2_6.webp) | 3.9 / 2.1 / 3 | 2.3 / 1.0 / 2 |  |
| red_both_low_low_bob | 161 / 368 / 93 (red_both_low_low_6.webp) | 3.9 / 2.1 / 3 | 2.0 / 1.2 / 1 |  |
| red_both_low_low_bob_r1 | 245 / 368 / 93 (red_both_low_low_r1_6.webp) | 4.1 / 2.1 / 3 | 1.9 / 1.1 / 2 |  |
| red_both_low_low_bob_r2 | 215 / 368 / 93 (red_both_low_low_r2_6.webp) | 4.3 / 2.1 / 3 | 2.3 / 1.0 / 2 |  |
| red_guard_bob | 161 / 367 / 97 (red_guard_0.webp) | 2.7 / 2.0 / 3 | 2.2 / 1.1 / 1 |  |
| red_guard_bob_r1 | 246 / 367 / 96 (red_guard_r1_0.webp) | 2.3 / 2.1 / 4 | 2.1 / 1.2 / 1 |  |
| red_guard_bob_r2 | 216 / 367 / 96 (red_guard_r2_0.webp) | 2.5 / 2.0 / 4 | 2.2 / 1.1 / 1 |  |
| red_lead_high_bob | 163 / 368 / 93 (red_lead_high_6.webp) | 3.6 / 2.1 / 3 | 2.0 / 1.0 / 1 |  |
| red_lead_high_bob_r1 | 246 / 368 / 93 (red_lead_high_r1_6.webp) | 3.8 / 2.1 / 3 | 2.0 / 1.0 / 2 |  |
| red_lead_high_bob_r2 | 216 / 368 / 93 (red_lead_high_r2_6.webp) | 3.8 / 2.1 / 3 | 2.5 / 1.0 / 2 |  |
| red_lead_low_bob | 161 / 368 / 93 (red_lead_low_6.webp) | 3.7 / 2.2 / 3 | 2.2 / 1.1 / 1 |  |
| red_lead_low_bob_r1 | 245 / 368 / 93 (red_lead_low_r1_6.webp) | 4.0 / 2.1 / 3 | 2.3 / 1.1 / 2 |  |
| red_lead_low_bob_r2 | 215 / 368 / 93 (red_lead_low_r2_6.webp) | 4.2 / 2.0 / 3 | 2.0 / 1.0 / 2 |  |
| red_rear_high_bob | 163 / 368 / 93 (red_rear_high_6.webp) | 3.5 / 2.1 / 3 | 2.1 / 1.0 / 1 |  |
| red_rear_high_bob_r1 | 246 / 368 / 93 (red_rear_high_r1_6.webp) | 3.5 / 2.1 / 3 | 1.8 / 1.0 / 2 |  |
| red_rear_high_bob_r2 | 216 / 368 / 93 (red_rear_high_r2_6.webp) | 4.0 / 2.1 / 3 | 2.3 / 1.0 / 2 |  |
| red_rear_low_bob | 163 / 368 / 93 (red_rear_low_6.webp) | 3.6 / 2.1 / 3 | 2.2 / 1.0 / 1 |  |
| red_rear_low_bob_r1 | 246 / 368 / 93 (red_rear_low_r1_6.webp) | 3.7 / 2.1 / 3 | 1.6 / 1.1 / 2 |  |
| red_rear_low_bob_r2 | 216 / 368 / 93 (red_rear_low_r2_6.webp) | 4.0 / 2.1 / 3 | 2.5 / 1.0 / 2 |  |
JUMPS 0

The 2-4 px is the forward/back rock, inside the bar; tops of the heads move 3-4 px (the dip).

### On the page (headless Edge, nothing on a monitor; ops/previews/s565_bounce/page, /beats)
- RED (today's page, the bob runs taken out of the table): order.html at Long, Mid and Inside - **0 picture changes in 2 s**,
  the page stands on blue_both_high_high[_r2|_r1]_6 (statues).
- With BOUNCE1: order, punch, head, kick and wait.html at Long, Mid and Inside - 21-25 picture changes in 2 s, every gap
  101-103 ms (the 5-picture loop). On Fight, every page: the picture at once is the hold's last (..._6.webp), the loop
  stopped (bobState hold ''), the beat then plays from it.
- Trap met: headless Edge throttles timers to 1 s in a background window - the first pass showed 1 s gaps, in the hold run
  too (the control's r1_5 -> r1_6 took 954 ms). With --disable-background-timer-throttling every gap is ~100 ms.
- One load race fixed: a bob picture still loading from an earlier warm made ready() false and the loop gave up once
  (kick.html, Inside); the loop now waits for it (150 ms, up to 3 s).
- beat_shot at Long (jab), Mid (cross), Inside (lead hook): each beat starts on the hold's last picture and plays its
  ranged run as before (order_<range>_plan / _after.png opened: nothing drawn on or near the men, v0.565.4 beside the
  sound button).
- Strips: ops/previews/s565_bounce/strips (54, opened: blue_lead_high_bob_r1, red_rear_high_bob_r2, blue_guard_bob);
  8 of them on the review board (S565, "BOUNCE1: both men bounce lightly while you plan").

### Regression
page_play_test.mjs 4 passed on order, punch, head, kick and wait.html; page_parse.mjs ok on all five; node --check
ring_ui.js ok.

## Not done / left
- The red_*_bob runs are made (both corners, as the brief asks) but the page only shows blue's holds (showHold), so they
  wait for a page that plays red's.
- The owner's play closes the visual gate (is a 2.6 cm dip at 2 bounces a second the right amount of life?).
  The numbers to turn are BOB_DIP_M / BOB_SWAY_M / BOB_CYCLE in tools/pics2d_bob.gd (and BOB_S in ring_ui.js).
- Render recipe: ops/previews/s565_bounce/render.sh (git-ignored folder): `sh render.sh all only=red_guard_bob,blue_guard_bob,red_lead_,blue_lead_,red_rear_,blue_rear_,red_both_,blue_both_`
  then `python proto/twohands/tools/anim_web.py ops/previews/s565_bounce/all --strips ops/previews/s565_bounce/strips`.

BOUNCE1 DONE
