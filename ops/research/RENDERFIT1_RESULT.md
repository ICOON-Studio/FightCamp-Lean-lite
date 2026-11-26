# RENDERFIT1 result (S559): the owner's-camera pictures are on the page, with the red slide, the floor bar, the ring and the red back-off end

Worker: console (Opus 5.5). Brief: ops/research/TASK_RENDERFIT1.md. Camera: his #16 (tools/pics2d_camera.json, pitch 31.04,
yaw -0.27, 3.149 m; the copy beside the render, E:/FightCamp/tmp/ringcam_full/camera_used.json, is the same save).
Prior research followed: RINGCAM1_RESULT (the slide and the follow-ups), STEPFIX1 (the step bars), MASK1 (masks), KICKTAKE1.

## What is on the page now (all four pages: order, kick, head, body)
Every picture in img/anim/ (169 runs, 1398 pictures, 342 masks) and the 74 stills in img/ come from ONE camera: his. The old
camera's last two runs (red_teep_missed, red_low_kick_missed) were replaced, not kept (see "Kicks" below). frames.json now
carries `camera` {axis_px [243.88, -0.59], px_per_m 243.9, size_m 3.149, render_px 768}.

## 1. The red slide - proto/twohands/ring_ui.js only (no page HTML touched: hitAt and playRun sit ABOVE the rules mark)
- The page keeps two counts in steps of 0.355 m: red's metres in and blue's metres in (their sum = the range: Long 0, Mid 1,
  Inside 2). The step runs the page plays move them (red_step_in +1 red, blue_back_off -1 blue, ...); at each plan the range
  is the truth (blue takes up what the counts missed: a cut-off, a clinch break, a push); a new round / bout resets both.
- Each picture is drawn slid along red -> blue by CSS `translate` (screen px = metres x axis_px x drawn height / 768,
  mirrored): a hold, a guard or a blue run (made with red on his spot) by red's metres in; a red run (his punch, his step;
  made with blue on his spot) back by blue's metres in. A MutationObserver on the picture sets it before the frame is painted.
- The hit burst: `hitAt` is wrapped and adds the slide (seen: blue's jab burst on red's head, red's jab burst on blue's head).
- The limb masks (body_ui.js): NOT changed - its glow and hit-test read the picture's getBoundingClientRect, which includes
  the translate; its mirror test reads `transform`, which the translate does not touch.
- RED_TEST, on the page (Edge, order.html, after blue stepped in once): red's step Mid -> Inside ends with the run slid +70 px
  and the hold slid -70 px. Without the slide both men jump 110-127 screen px at that moment (RINGCAM1's 87 render px was
  the simpler case, blue never in). With it, blue (who does not move) shifts 13 px: that is the hold take's own heel jitter
  (its frames 1-4 read 449-464), and the old pictures showed the same 13.

## 2. The floor bar - ring_ui.js TOES / PX_M / FLOOR, re-measured on blue_both_high_high*_6 (the lead boots' inner ends)
TOES {3: [231, 318], 2: [231, 264], 1: [231, 231]}, PX_M 152.4 (= axis_px x 480/768), FLOOR 324/480 (the front toes sit at
y 318 red / 331 blue: the raised camera puts the lead feet higher than the rear ones). Gaps: Long 57 cm, Mid 22 cm, Inside toe
to toe (the lead boots pass each other at different depths) - the old camera read 60 / 24 / 0. The bar takes the HOLD's
slide (red's metres in) whatever picture is up, and its x no longer reads the picture's width (a wide picture has the same
middle and scale). Seen at all three ranges, on all four pages: between the two lead boots.

## 3. The ring - tools/pics2d_ring_bg.gd -> proto/twohands/img/ring_bg.webp (1920x480, 9 KB)
The stage HAS a ring (FightStage's RingSet: canvas, apron, 4 posts, 3 ropes a side). The tool builds the same stage and camera
as the runs (pics2d_set _setup, aimed at ring_at), hides the boxers, the crowd, the crowd's camera flashes (one sat on the
middle of the canvas) and the posts and rope pieces on the camera's side (in the runs they would stand in front of the men),
and renders 4 times as wide at the same height (KEEP_HEIGHT): its middle 768 px are exactly a run picture's frame. ring_ui.js
puts it behind the men with the picture's own CSS (126% high, mirrored) and switches off the page's gradient and the two CSS
rope lines (an injected style, so the four pages' HTML is untouched). It does not slide (the ring does not move).

## 4. The red back-off end - tools/pics2d_anim_more.gd `_step_run` (carry only)
Read in the run: the Hips bone stays on the root all through the back-off take (0.023 m every frame), so "the hips ahead" was
not a hips-vs-root offset: the run's last picture is taken at 0.72 s, when the take has carried him only 87% of its travel,
so he ended 0.05 m short of the next spot. The carry is now spread over the pictures' own window for a back off (the last
picture lands on the spot); step in is unchanged. Re-rendered red_back_off* AND blue_back_off* (the same code path; blue's
bars are unchanged at 3 px), merged into the full folder (the earlier ones kept in ringcam_full/backoff_before).
`python tools/step_travel_check.py E:/FightCamp/tmp/ringcam_full/more --hold=blue_lead_high`: **STEP_TRAVEL PASS**, all 8
(red_back_off end 12 -> 4 px).

## Kicks: two runs needed a wider picture - tools/pics2d_kick_wide.gd (new, said out loud)
The full render refused red_teep_missed and red_low_kick_missed: blue's back foot pulls out past the fixed frame (x 767 / 807
of 768). Dropping them failed anim_check (MISSING 2); keeping the old rows would show two cameras. The new tool (a subclass of
pics2d_kick.gd) renders those two 1.5 times as wide at the same height, size and aim (KEEP_HEIGHT), with the gate's own frame
check on the wider width. The page draws a wide picture centred on the same middle, so men, slide and ring line up. Their
`hit` (unused on a miss) is still a share of 768, not of the wide picture.

## Publish checks
- anim_web: `python proto/twohands/tools/anim_web.py <dir>/more <dir>/punches <dir>/p_hook <dir>/p_upper <dir>/kicks --strips
  <dir>/strips` + the S554 alias list (overhand x4 x2 corners, blue_push/red_push=push, red_clinch=blue_clinch,
  blue_step_in=blue_step_in_r2), then `<dir>/kicks_wide`. SKIPPED by their gate, as before: red_clinch (aliased),
  blue_body_hook_landed and blue_lead_uppercut_blocked (the HOLDTAKES1 overrides p_hook / p_upper replace them).
  anim_web.py now carries frames.json's `camera` into the page table (and warns if two folders' cameras differ).
- `node proto/twohands/tools/anim_check.mjs`: **PASS** (138 ok, missing 0, the same 12 BORROWED lines as before).
- page_play_test **4 passed**, kick_test **12**, head_test **11**, rules_test **36**. anim_stills.py: 74 stills.
- The browser: `node proto/twohands/tools/renderfit_shots.mjs ops/previews/s559_newcam <page>` (new: headless Edge, his plan
  forced; logs every picture's slide and each man's outer boot edge on screen) on all four pages: blue step in, red step in,
  red back off, a jab landed each way, (kick.html) a low kick and a teep. The man who does not move: 4-5 px on blue's steps,
  12-17 px on red's (the hold take's jitter above, the same on the old pictures). Screenshots in ops/previews/s559_newcam/
  (git-ignored), opened: the ring behind the men, the bar between the lead boots at Long / Mid / Inside, the burst on the head
  for both jabs. One on the board.

## Left, for the session
1. **Red's step in: his rear heel pops 31 px into the hold** (body.html 41; the hips pass the bar at 7). The step-in take's
   last picture is taken before his rear foot has landed. The old pictures had it too (24 px), so not new, but on a fixed
   camera it is easier to see. Same cure as the back off: a later last picture, or the rear foot landed in the carry; then
   re-render the 12 step runs.
2. The hold takes move blue's back heel 13 px across their own frames: worth a look in HOLDTAKES (not a camera thing).
3. `img/guard.webp` (the plain-guard still the page shows when no hand is held) is the Long picture at every range: at Mid it
   draws blue a step out. Pre-existing; the page could pick blue_guard_r2 / _r1 (body.html already prefers ANIM.blue_guard).
4. The kick misses' `hit` share (above); the knockdown runs still use Gate.fit when a body leaves the frame (RINGCAM1 #4).
5. The screenshot tool cannot catch a 250 ms contact picture reliably in headless Edge even when frozen; the burst was seen in
   its earlier run (and burst = hitAt + the same slide as the picture).

## Files
proto/twohands/ring_ui.js, proto/twohands/img/ (ring_bg.webp, anim/ pictures + masks + frames.json, the stills),
proto/twohands/tools/anim_web.py (camera passthrough), proto/twohands/tools/renderfit_shots.mjs (new), tools/pics2d_ring_bg.gd
(new), tools/pics2d_kick_wide.gd (new), tools/pics2d_anim_more.gd (`_step_run`). Render folders: E:/FightCamp/tmp/ringcam_full/
{more, punches, p_hook, p_upper, kicks, kicks_wide, strips}, E:/FightCamp/tmp/renderfit1/{bg, backoff}.
