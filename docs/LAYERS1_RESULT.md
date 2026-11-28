# LAYERS1 - one man per picture, phase 1 (S572, console worker)

Brief: ops/research/TASK_LAYERS1.md (owner on the board: "Yes, do all moves"). Phase 0: docs/LAYERS0_RESULT.md.
Renders: tools/pics2d_anim.gd layers=1, one family per render on the hidden desktop through godot_slot, watchdog +
"no ArcheAge, llama-server under 4 GB" before each (a preflight script waits 5 min on any of them). Work files in
E:\FightCamp\wt_tmp\LAYERS1\.

## Red first (today's ?layers=1 page, 6 random bouts, jumps over 4 screen px)
| | pictures | boundaries | jumps | touching the cross | both runs layered |
|---|---|---|---|---|---|
| before the cross (S572 start) | 425 | 62 | 63 | 5 | 0 |

## Trial: the cross family - PASSES
Render: pics2d_anim.gd layers=1 only=red_cross_,blue_cross_ at range=3 / 2 / 1 (18 runs, 186 frames, 0 refused, 0 gate
failures) + the short cross (range=3 short=1): both short runs FAIL the picture gate (glove 0.105 / 0.122 m from his face,
the gate wants 0.14), so the short cross stays on its old two-man picture (anim_web skipped it).

Two defects found on the ?layers=1 page and fixed (both would have hit every family):
1. **The man's anchor was wrong** (proto/twohands/tools/layers_cut.py feet_x). It was the mean x of his lowest leg pixels,
   i.e. the ONE foot nearer the camera. Blue's guard in the cross runs sets his feet differently from the hold, so he read
   0.43 m further in while his body stood on the same spot - and the page drew him 0.43 m off (red's cross landed in the
   air). Now the anchor is the middle of the span his feet cover (every column whose lowest leg pixel is in the bottom 40%
   of his legs). Checked: blue reads 0.846 in the hold and 0.83 in the cross; a static man varies under 0.03 m; every Mid
   and Inside run now starts within 0.08 m of the hold's gap (was 0.36-0.53 for the cross). All 138 layered runs re-cut.
   (The layer pictures did not change, only the anchors in img/layers/frames.json.)
2. **Layer pictures were not preloaded** (proto/twohands/layers_ui.js). The page warms a beat's two-man pictures before
   playing them; the layers were not, so the first time a run played the man stayed in his previous pose until his new
   picture loaded (red's cross drawn with red in his guard). warm() now also loads the layers of every run it warmed.

Measure note: the page shakes the whole stage on a landed hit (.stage.shake), which moves both men 5 px together; the
recorder counted it as a jump. The gate is now recorded with reduced motion (a copy of jump_rec.mjs in the work folder,
Emulation.setEmulatedMedia prefers-reduced-motion) - the shake is the ring moving, not a man.

| 6 random bouts, jumps over 4 px | pictures | boundaries | jumps | touching the cross | both runs layered |
|---|---|---|---|---|---|
| before (S572 start) | 425 | 62 | 63 | 5 | 0 |
| cross layered, old anchor, shake on | 491 | 68 | 74 | 10 | 2 (both the hit shake, -5 px each man) |
| cross layered, old anchor, shake off | 522 | 75 | 88 | 10 | **0** |
| cross layered, new anchor + preload, shake off | 425 | 50 | 71 | 14 | **0** (jab + holds family: 0 too) |
The jumps left touching the cross are where a layered run meets an old two-man run (steps, hooks, head moves): they go
family by family, as in phase 0.

Stills (beat_shot copy that pauses the page on the contact frame, ?layers=1, full size, opened): blue's cross landed at
Mid and Inside - glove on his face; blocked at Mid and Inside - glove on his raised glove; red's cross landed / blocked at
Mid and Inside - each man where the 3D take has him (the page's two layers are 88 and 77 px over, 0.04 m apart from the
render), red's cross meets blue's raised glove at his face as the take does. Both men head to feet, feet on the canvas
line, no arm through a body Inside. Long: the cross falls short - still the old two-man picture.
Regression: anim_check PASS (160 runs), page_play_test 4 passed.

## The other punch families (render chain, one render at a time)
| family | runs re-rendered | picture gate | start gap vs the hold |
|---|---|---|---|
| body jab | 12 (Long, Mid) | all pass | within 0.08 m |
| lead hook | 20 (Long, Mid, Inside, short) | all pass | within 0.09 m (Long 0.08: the page never plays a hook at Long) |
| rear hook (+ overhand, which plays its pictures) | 20 | all pass | within 0.11 m (Long only) |
| body hook | 20 | all pass | within 0.09 m |
| body cross | 19 + red short fails the gate (keeps its old picture) | 19 pass | within 0.09 m |
The overhand is an alias of the rear hook in img/anim/frames.json; layers_ui.js now maps an alias's pictures to the run
it borrows, so the overhand is layered with the rear hook. pics2d_anim_more.gd: layers=1 masks every frame (steps, feint,
push, clinch, knockdown; the head and kick tools go through it) - needed for families b-d.
01:30-02:12 the owner played ArcheAge; the chain waited in its preflight and went on when he closed it.
| lead uppercut | 16 (Long, Inside, short at Long and Mid) | all pass | within 0.09 m |
| rear uppercut | 15 + red short at Mid fails the gate (keeps its old picture) | 15 pass | within 0.10 m |

Gate on all punch families (jumps over 4 px, recorded with the hit shake off):
- 12 random bouts: 765 pictures, 110 boundaries, 0 jumps where both runs are layered for every family. The random bouts
  hardly reach Mid/Inside (body hook and rear uppercut never played), so:
- 6 directed bouts (both men forced to throw every punch, each bout held at Mid or Inside): 508 pictures, 72 boundaries,
  **1 jump in all** (a guard change, no punch).
- 3 directed bouts at Inside (uppercuts, body punches, overhand; health kept up so the bouts run long): 316 pictures,
  1 jump (the recorder's own jump from Long to Inside on the first beat).
- a scripted 16-beat sequence (rear uppercut both sides at Inside, overhand both sides at Mid): 1330 pictures, 88
  boundaries, 2 jumps - both the recorder setting the range on a beat, none touching a punch.
Regression: anim_check PASS (160 runs), page_play_test 4 passed.

Stills at the contact frame (paused page, full size, opened; ring crops in the work folder sheet_a/sheet_b.png): body jab
blocked Long + Mid, lead hook landed Mid + Inside, body hook blocked Mid + Inside, overhand landed Mid + Inside, body cross
blocked Mid + Inside, lead + rear uppercut blocked Inside. Both men head to feet, feet on the canvas line, no arm through
a body Inside. How far the page puts the two men from where the render had them at contact (from the page's own layer
offsets): body jab 0.02-0.03 m, body cross 0.02-0.05, overhand 0.03-0.07, body hook 0.06-0.09, lead hook 0.06-0.09,
uppercuts 0.08-0.10. That is the anchor reading the guard stance a little differently run to run (the feet span); the
exact fix is the renderer writing each man's true root per frame (next, below).

## Family b: steps in, back offs, feint, push, clinch (pics2d_anim_more.gd layers=1)
21 runs, 152 frames, every frame masked, 0 gate failures (the slip in, the side pushes and the check come from the head
and kick tools: families c and d).
Gate, 8 random bouts: first read 11 jumps, 3 where both runs are layered - red's back off from Mid and blue's step in
jumped ~0.4 m on their LAST picture. Cause (layers_ui.js): the page's run player calls done() while the last picture is
still up, and done() moves the stepper's spot to the end of his step at once; the layers read the spot again on that
picture and counted the step twice. Fix: each man's spot is read once, when a run starts. After: 8 bouts, 507 pictures,
65 boundaries, 11 jumps, **0 where both runs are layered**; every one of the 11 touches the short cross or the short body
cross (red), the two runs that fail the picture gate and keep their old two-man picture.
Regression: anim_check PASS, page_play_test 4 passed.

## MISTAKE FOUND AND BEING FIXED: the renders above left out south=blue
Every picture of the page is rendered with `south=blue` (ops/research/MASK1_RESULT.md, RESUME_S564_RENDERS.md: blue is
mirrored so both men show the camera their chest; the head and bob tools say it in their usage line, pics2d_anim.gd does
not). My cross, punch and family-b renders were made without it, so blue stood orthodox, half his back to the camera,
in those pictures - and they replaced the old ones in img/anim, so the plain page showed it too (commits 6ad20a23b,
b5cf3e78b, 61da431ec). It is also why blue's stance read 0.43 m off in the cross trial: the anchor fix is still right
(a stance must not move the man) but the stance itself was wrong. Re-render of all of them with south=blue started 01:27
(render_sb.sh in the work folder, same order, one render at a time); the gates and stills are redone on those pictures.

### The south=blue re-render (01:27-02:46): results
All cross, punch and family-b runs again with south=blue. Picture gate failures this time (near misses; the gate is not
loosened, each keeps its ORIGINAL pre-S572 picture, restored from git 6ad20a23b^, with no layers):
blue body hook landed at Long/Mid/Inside (head 0.570 m from the other body, gate 0.60), blue lead uppercut blocked at
Long/Inside (feet 0.159 m apart, gate 0.16), red clinch (arm 0.046 m from a torso, gate 0.07); the short cross (blue) and
the short rear uppercut at Mid (red) still fail too and keep theirs. Red's short body cross now passes and is layered.
Gate on the corrected pictures: **8 random bouts: 533 pictures, 74 boundaries, 0 jumps of any kind.** 6 directed bouts:
9 jumps, the 5 between layered runs are all the recorder pushing the range from Long to Mid/Inside on a bout's first beat
(a man moves 88-137 px with no step - not the page), the rest touch the restored body hook (no layers).
Stills (south=blue, paused contact, both sides): cross Mid + Inside, body jab, lead hook Mid + Inside, body hook blocked,
overhand, body cross, both uppercuts, red's cross, lead hook and rear uppercut - blue faces the camera as in the holds; the
page holds each man within 0.09 m of the render (the cross 0.01-0.04, most under 0.06).
Also found: tools/pics2d_head.gd did not load at all on main (it declared glide_a, which pics2d_anim.gd gained in S564):
the copy is removed. And the head / kick tools never made a part mask (their own _run skipped anim_more's): _frame now
makes it when layers=1. Head and kick pictures in this commit are south=blue but not yet layered (masked render running).

## Family c: head moves (pics2d_head.gd, south=blue, layers=1)
The head tool did not load on main (duplicate glide_a, fixed above) and the head / kick tools made no masks (fixed above).
Re-rendered: jab slipped / leaned at Long, every head move at Mid, cross slipped + lead hook / overhand rolled at Inside,
the slip in at every range: 32 runs, 330 frames, 0 gate failures, all layered.
Gate: head.html, 6 random bouts: 370 pictures, 52 boundaries, **0 jumps** (random bouts only reach the slip in), so a
directed 16-beat sequence (each man slips the other's jab and cross, rolls the hook and overhand, leans back from them, at
Mid and Inside): 1316 pictures, 89 boundaries, 3 jumps - all three blue landing in his Mid hold right after the script set
the range itself (Inside -> Mid, Long -> Mid), none touching a head move.
Stills (paused contact): red's jab slipped and leaned, blue's cross slipped and leaned, red's lead hook rolled, blue's
overhand rolled - the head off the line / under / back, the glove past or short as the take has it.

## Family d: kicks (pics2d_kick.gd, kick.html only)
Teep and low kick at Long and Mid, the check: 24 runs, 0 gate failures; red's missed low kick is refused at both ranges
(blue's toes leave the picture) and keeps its old picture. Gate: kick.html, 6 random bouts: 379 pictures, 42 boundaries,
**0 jumps** (teeps and low kicks played; the body and head kicks borrow pictures).
First stills: the page put the men 0.13-0.15 m too far apart on the teeps (the sole stopped at the knee) and 0.07-0.17 m
too close on the low kicks (red's shin through blue's leg) - each run's first picture reads a few cm off the hold (a kick's
chamber, a hook's set-up). Fix in layers_ui.js: the page's spots say where the PAIR stands, the render says how far apart
the men are - at a run's start the gap between the two is split between the men for the whole run (at most 0.25 m) and
the blend at the boundary eases it in. After: every kick still 0.000-0.002 m from the render (punches were 0.01-0.09).

## Step 3: layers ON by default (layers_ui.js), ?layers=0 the old way for one session
- order.html, 8 random bouts after the gap split: 583 pictures, 81 boundaries, **3 jumps**: two touch the short cross (old
  picture), one is after a push (the page keeps no distance for a push: its next run starts back on the old spots - the
  page's distance model, not the pictures; noted for the push's own fix).
- Plain order.html (no query), 6 bouts: 383 of 383 pictures drawn as two men, **0 jumps**. ?layers=0, 1 bout: 0 of 247.
- kick.html 6 bouts after the split: 329 pictures, **0 jumps**. head.html sequence: 3 (the script's own range sets).
- **Total jumps over 4 px: 3 in 8 bouts (target below 10; 54 on the S570 page).**
- ring_ui.js, removed (dead since the floor bar was hidden in S562): holdSlide(), TOES, PX_M, FLOOR, X(). KEPT, because
  the runs still on their old two-man picture and ?layers=0 need them: slide() (the two-man picture's slide by metres),
  atRange() (the run made at the range they stand at - layers need it too), stepChain()/playSteps() (each man's own step).
- make_head.py, make_kick.py, make_one.py rebuilt: byte-identical (every built page already loads layers_ui.js).
- Regression: anim_check PASS (160 runs), page_play_test 4 passed.

## What stays on the old two-man picture, and why
- short cross (blue), short rear uppercut at Mid (red): the picture gate (glove 0.085-0.107 m from his gloves, gate 0.14).
- blue's landed body hook (Long/Mid/Inside): head 0.570 m from the other body (gate 0.60).
- blue's blocked lead uppercut (Long/Inside): feet 0.159 m apart (gate 0.16).
- red's clinch: an arm 0.046 m from a torso (gate 0.07).
- red's missed low kick (Long/Mid): blue's toes leave the picture (refused by the framing gate).
- the knockdowns and the *_ko runs: not re-made here (the jump read skips them; the Animo knockdowns are meant to replace
  them, item 2).
Each of these restored from git 6ad20a23b^ where my first (orthodox) render had replaced it; no layers for them.

## Not done: item 2, the hit man's own reaction from the Animo pack
The pack (assets/anim/animo_boxing, one FBX, 121 takes) is on a 3ds Max Biped rig: "Robot:Bip01 Pelvis / Spine..Spine3 /
Neck / Head / L|R Clavicle / UpperArm / Forearm / Hand / Thigh / Calf / Foot / Toe0" (read from the file). The repo's
retarget (scripts/fight3d/RkRetarget.gd, the kicks' route) reads Mixamo names; the map is one-to-one (Pelvis->Hips,
Spine..Spine3->Spine..Spine2, Clavicle->Shoulder, UpperArm->Arm, Forearm->ForeArm, Thigh->UpLeg, Calf->Leg, Toe0->ToeBase),
so the next task is: copy the FBX to an imported folder (it is .gdignore'd), bake Get_Hit head / body, one stagger and one
knockdown through RkRetarget with that name table (the hold-bake route, assets/anim/baked/), put them in pics2d_set.gd
REACT / KO_CLIP, re-render the landed runs (south=blue, layers=1) and gate them as above. Not started tonight: it is a new
retarget route plus a re-render of every landed run (~1.5 h of GPU), past the 05:00 nightly run on this PC.

## Tools and files changed (all committed)
proto/twohands/layers_ui.js (warm preload, alias runs, spots once per run, render gap per run, ON by default),
proto/twohands/ring_ui.js (dead floor-bar code out), proto/twohands/tools/layers_cut.py (feet-span anchor),
tools/pics2d_anim_more.gd (layers=1 masks every frame, mask made for head/kick), tools/pics2d_head.gd (loads again),
proto/twohands/img/anim + img/layers (pictures, masks, layers), proto/twohands/version.js (0.572.1-.4, .6).
Work files: E:\FightCamp\wt_tmp\LAYERS1 (renders, logs, the reduced-motion / directed recorders, contact-shot tools).

## For the owner (three lines)
1. Every page now draws each fighter as his own picture: he stays where he stands between moves, and every punch, step,
   head move and kick meets the other man where the 3D take has him (0 jumps on the plain page in 6 bouts; 54 before).
2. A handful of moves still show the old picture (short cross, blue's landed body hook, a clinch, one missed kick); add
   ?layers=0 to the address to see the old way for comparison.
3. Your look decides it: http://127.0.0.1:8797/order.html - the hit man's own fall-back and knockdowns from the Animo pack
   are the next task.

LAYERS1 BLOCKED: items 1 and 3 done and ON by default; item 2 (the Animo hit reactions) needs a new Biped-rig retarget route (the repo's RkRetarget reads Mixamo names) and a re-render of every landed run - a task of its own, not started.
