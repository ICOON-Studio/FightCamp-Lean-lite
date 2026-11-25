# TASK RENDERFIT1 - ship the owner's-camera pictures to the page, with everything they need (S559)

Kind: build (page + picture tools). Model: claude-opus-5-5. Discipline: boxing + kickboxing (demo path).
Seat: console worker. Estimate: 2-3 hours (part of it waiting for the render).

## Why
Owner S559: "start the re-render with #16" (his camera: raised 31 deg, from the side; tools/pics2d_camera.json, committed).
The session started RINGCAM1's full re-render at ~01:33: `sh E:/FightCamp/tmp/ringcam1/full.sh` writes every picture to
`E:/FightCamp/tmp/ringcam_full/{more,punches,p_hook,p_upper,kicks}` and prints `RINGCAM_FULL_DONE` at the end of
`E:/FightCamp/tmp/ringcam_full.log` (~50 min). NOTHING reaches the page yet: the page must never show two cameras.
Read `ops/research/RINGCAM1_RESULT.md` whole first: its "Follow-ups the re-render forces" are this task.

## Do (start the code at once; publish only after RINGCAM_FULL_DONE and every check green)
1. THE RED SLIDE (RINGCAM1: without it red's steps snap a whole step, 87 px): the pictures are now in ring coordinates.
   Every page that draws ANIM (`proto/twohands/order.html`, `kick.html`, `head.html`, `body.html`; the page part below
   the rules mark only - the rules above it are NOT touched) keeps red's metres stood in (0 / 0.355 / 0.71, from the
   range and who moved) and draws every picture slid by that x `frames.json` `camera.axis_px` (scaled to the 480 px
   web picture). Make the hit burst (`hitAt`), the floor bar (`ring_ui.js`) and the limb masks (`body_ui.js`) slide with it.
2. THE FLOOR: `proto/twohands/ring_ui.js` `TOES` and `PX_M`: re-measure on the new pictures (the camera is 3.149 m wide;
   the men are no longer centred). The bar must still sit between the two front toes at all three ranges.
3. THE RING BACKGROUND (owner S559 camera is raised 31 deg, but the page's ring is a flat side-on CSS gradient with
   horizontal rope lines - the men would float): render the empty ring (canvas, ropes, posts) from the SAME camera as one
   picture (`proto/twohands/img/ring_bg.webp`, same framing as the runs) through the picture tools, and draw it behind the
   men on every page instead of the gradient + rope lines. If the stage has no ring mesh, say what it has and use the
   nearest honest option (a floor plane + three ropes from the same camera).
4. THE RED BACK-OFF END (RINGCAM1: its last pose has the hips 0.05 m ahead of the guard, 12 px): land the hips, not the
   root, on the next spot in `_step_run`'s carry; re-render `red_back_off*` only, into the same full folder.
5. PUBLISH: `python tools/step_travel_check.py E:/FightCamp/tmp/ringcam_full/more --hold=blue_lead_high` (all PASS),
   `python proto/twohands/tools/anim_web.py <the five dirs> --strips E:/FightCamp/tmp/ringcam_full/strips` with the alias
   list from docs/RINGANIM1_RESULT.md / the S554 digest (check anim_check's BORROWED lines stay as today),
   `node proto/twohands/tools/anim_check.mjs` (PASS), `node proto/twohands/tools/page_play_test.mjs` (4),
   `node proto/twohands/tools/kick_test.mjs`, `head_test.mjs`, `rules_test.mjs`; then play a beat on every page in the
   browser (server: `python proto/cardgame/serve.py 8797 twohands`, curl first): a blue step, a red step, a punch landed,
   a kick, at Long / Mid / Inside - no snap, bar between the toes, the burst on the glove. Screenshots to
   `ops/previews/s559_newcam/` and ONE on the board: `python ops/Tools/review_add.py --stage S559 --rating "not scored: your eye" --title "The fight from your camera" <png>`.
6. Commit by pathspec ONLY your files and the pictures + frames.json (NEVER `git add -A`/a folder sweep: S559 a worker's
   commit swept in 8,200 unrelated files). Before committing, `git diff --cached --stat | tail -1` must show only what
   you meant. Push.

## Contract
- OWNS: the page part of order.html / kick.html / head.html / body.html, proto/twohands/ring_ui.js, proto/twohands/body_ui.js
  (slide only), proto/twohands/img/ (the new pictures, ring_bg.webp, frames.json), tools/pics2d_anim_more.gd (`_step_run`
  carry only), a ring-background tool if needed under tools/
- RED_TEST: on the new pictures without the slide, a red step snaps (RINGCAM1 measured 87 px)
- REGRESSION: rules_test 36, kick_test 12, head_test 11, page_play_test 4, anim_check PASS
- VISUAL: the screenshots, opened by you, on all four pages

## Not allowed
The rules above each page's mark. Godot only through `python ops/Tools/godot_slot.py run --who RENDERFIT1 -- python
tools/hidden_desktop.py run ...`, never `_console.exe`. HIS GAME FIRST (`Get-Process ArcheAgeChronicles`). A balance.mjs
run may be going (kick fixes, then head moves): do not edit kick.html or head.html until `E:/FightCamp/tmp/s559_head/head_base.txt`
has its BARS line - page parts only even then, and only after that run ended.

## Prior research
ops/research/RINGCAM1_RESULT.md, STEPFIX1_RESULT.md, CAMPICK1_RESULT.md, MASK1_RESULT.md, KICKTAKE1_RESULT.md, docs/RINGANIM1_RESULT.md.

## What would a human do?
Re-shoot every plate from the new camera, rebuild the set from the same camera, and fix the continuity before the cut.

## Prefab check
Not applicable (our pictures).

## Feedback loops
None: pictures and the page's drawing.
