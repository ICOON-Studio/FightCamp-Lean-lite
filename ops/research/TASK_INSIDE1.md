# TASK INSIDE1 - Inside is too close (the men run into each other), and where they overlap the man in front goes see-through (S562)

Kind: build (picture tools + page). Model: claude-opus-5-5. Discipline: boxing (Ring Switches, the main line).
Seat: console worker. Estimate: 4-5 hours, ~60-80 min of GPU renders (only with his game closed).

## Why - the owner's words (S562, on the Inside hold picture: blue's body over red's, red's front boot between blue's)
"can you make the silhoutes parts that are clipping transparent , the distance looks wrong to me btw".
Our numbers: Long = the guard spots, Mid one step in (0.355 m), Inside two steps (0.71 m) - Inside puts the men about
0.69 m apart (the tie-up gap of the clinch, `Clinch.PAIR_GAP_M` 0.68 / the push run's start). K50
(`ops/research/K50_SPACING_AND_REACH.md`, research): close range ~0.70-0.90 m between the feet midpoints; under that is
clinch approach. The picture gate's bars (`tools/pics2d_gate.gd`): torsos APART_MIN_M 0.60, HEAD_CLEAR_M 0.60, FEET_MIN_M
0.16. So Inside sits on the clinch line, and on the picture the bodies pass through each other.

## Phase 1 - Inside at a real inside-fighting distance (do first)
1. MEASURE on today's Inside hold (`blue_both_high_high_r1`, red on his spot, blue 0.71 in): the feet-midpoint gap, the
   torsos' apart_m, head_clear, feet - and the same at 0.60 / 0.55 / 0.50 m in. Pick the Inside where the holds pass the
   gate with a margin (and the feet-midpoint gap sits inside K50's 0.70-0.90) while the hooks and uppercuts still land
   from it (their contact steps, `PICS2D_ANIM ... step` lines: the puncher must not glide more than ~0.15 m into them).
   Write the table in your result before changing anything.
2. ONE shared table of the ranges' metres in (Long 0, Mid 0.355, Inside = your number) in `tools/pics2d_anim.gd`, read by
   `pics2d_anim.gd` (`range=`), `pics2d_anim_more.gd` (RANGE_IN, the push off's spots, the step runs), `pics2d_head.gd`
   and `pics2d_kick.gd` (GLIDE2's tools: the GLIDE2 worker was told to read it from there and to leave Inside to you).
   The step run that ENDS at Inside (Mid -> Inside) and the back off that STARTS there travel the new, shorter distance:
   the body carried by the step take's own hip travel scaled to it (say how; a foot must not skate more than it does now).
3. `proto/twohands/ring_ui.js`: the slide counts steps (STEP_M 0.355 a step): make it metres per range from the same
   numbers (the page must know Inside's metres; keep it one table in ring_ui.js with a comment naming the tool's).
4. RE-RENDER everything made at Inside: the guard and the eight holds (_r1, both corners) WITH the part masks (the head is
   its own part since BODYUI2 - so render ALL 54 hold/guard runs with masks: Long and Mid too, their pictures stay the
   same, their masks gain the head), the steps ending / starting at Inside, every punch `_r1` (pics2d_anim.gd range=1),
   `_feint_r1`, the push off, `slip_in_r1` and the head moves at Inside (GLIDE2 left them). Then anim_web, strips, the
   edge table (hold before, first frame, last frame, hold after; > 8 px = a jump), beat_shot at Inside on order.html and
   head.html, `mask_shots.mjs` 10 parts x 3 ranges (docs/BODYUI2_RESULT.md "What is left" - the head lights alone).
   The rules do not change: Inside is still Inside; only where the men stand on the picture.

## Phase 2 - where the men still overlap, the man in front is see-through
After Phase 1 the bodies no longer pass through each other, but at Inside and in a landed punch one man still covers part
of the other on the picture. The owner: those parts "transparent". Build it on the Inside holds and the Inside punch runs
first, show him 3-4 stills, and only then the rest:
- Per frame, render each man ALONE too (the other hidden; the same camera and frame) as two extra layers, beside the
  normal picture: `<run>_<k>_a.png` (red) and `_b.png` (blue), lossless, transparent background - or a cheaper way you
  measure as equal (a depth/ID pass that names the front man per pixel plus the back man's layer).
- The page draws the back man, then the front man with the pixels where he covers the back man at ~50% (one number,
  `OVERLAP_ALPHA`), a soft 2 px edge. Where nobody overlaps, the picture is exactly as today.
- No outline, circle or text on the men (owner S559/S562 rules). Weight on disk: say the MB per run before rendering all.

## Renders
HIS GAME FIRST: `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once`; ArcheAge running or
RED = wait (code and measurements on numbers can go on). One windowed render at a time: `python ops/Tools/godot_slot.py
status` shows no other hidden_desktop job. Godot only via godot_slot + tools/hidden_desktop.py, south=blue (the owner's
camera is read by the tools).

## Feedback loops
None: pictures and page drawing of the same rules (no number of the rules changes).

## Not allowed
No change to any page's rules (above `// ---- the page`) or under scripts/. Commit only your paths (`git commit -- <paths>`;
GLIDE2 shares the checkout). Push when done.

## Contract
- OWNS: tools/pics2d_anim.gd, tools/pics2d_anim_more.gd, tools/pics2d_mask.gd, proto/twohands/ring_ui.js, proto/twohands/body_ui.js, proto/twohands/tools/anim_web.py, proto/twohands/img/anim/frames.json, docs/INSIDE1_RESULT.md
- RED_TEST: today's Inside hold fails the picture gate's torso / head bars (measure it: step 1)
- REGRESSION: page_play_test.mjs 4 passed on order.html, punch.html, head.html, kick.html; page_parse.mjs ok; rules_test 37
- VISUAL: Inside stills before / after (the gate numbers on each), the Phase 2 stills, opened by the worker; the owner closes it

## VISUAL GATE
The owner's ring camera only (south=blue); every still checked by eye AND by the gate numbers; nothing drawn on or near the
men (memory feedback_nothing_near_fighters_s562).

## Prior research
ops/research/K50_SPACING_AND_REACH.md; ops/research/Q115_CLINCH_DISTANCE.md; docs/PICSFIX1_RESULT.md (the gate bars);
memory project_s562_glide_distance; docs/BODYUI2_RESULT.md; ops/research/TASK_GLIDE2.md.

## What would a human do?
Stand the two men where real inside fighters stand (heads close, bodies not inside each other), and where one still hides
the other, let the viewer see through the near man, as games do with an x-ray silhouette.

## Prefab check
Our own picture tools and Godot's own viewport layers; nothing to buy.
