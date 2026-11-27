# TASK LAYERS0 - one man per picture, phase 0: the guard holds + the jab, behind ?layers=1 (S570)

Kind: build (renders + page drawing). Model: Opus 5.5 console worker (PC; GPU renders on the hidden desktop, ONE render at
a time, never beside another windowed render; no game open). Discipline: Puncher's chance, boxing (order.html).
Seat rules: ops/research/WORKER_S566.md. Owner S570: Cascadeur Indie bought, the Animo pack bought ("bought it, its in
downloads") = LAYERS approved (ops/research/LAYERS_SCOPE_S569.md - read it first, it is the spec).

## Do (phase 0 only)
1. Renders, one man each: in tools/pics2d_anim.gd (and pics2d_bob.gd for the holds) add a `solo=blue|red` mode - the same
   scene, camera and takes, the OTHER man hidden but kept as a depth-only occluder (Inside: his body cuts the arm that is
   behind it), transparent background. Each frame records the man's feet point (root x in metres along the ring axis).
   Output `proto/twohands/img/layers/<run>_<side>_<k>.webp` + rows in `proto/twohands/img/layers/frames.json` with
   `root: [m, ...]` per frame, the contact frame and the camera (metres -> px).
   Family: the four guard holds (both_high_high .. both_low_low, + _bob) and the jab (landed / blocked / missed) at Long,
   Mid and Inside, both sides; the man hit by the jab gets his own reaction run (a small head snap; the Animo pack's
   Get_Hit_Type01_Head is the reference - its file is assets/anim/animo_boxing, catalogue ops/research/ANIMO_PACK_S570.md;
   retarget it only if our own take has no hit reaction, and say which you used).
2. ring_ui.js: behind `?layers=1` only, draw two pictures - each man at his own spot (metres -> px), the near man in
   front. A run starts from the man's CURRENT spot; if the contact needs a different gap, ease the puncher over 100 ms.
   Every run family not yet re-made plays the old two-man picture as today. Without ?layers=1 nothing changes.
3. Gate: `node proto/twohands/tools/jump_rec.mjs` + `python proto/twohands/tools/jump_ana.py` on 6 random bouts with
   ?layers=1 - no boundary jump over 4 screen px in the jab + holds family; anim_check PASS; page_play_test on order.html;
   full-size stills of each range (beat_shot.mjs, add `layers=1` to the URL) of a jab landed and a guard hold.
4. docs/LAYERS0_RESULT.md: the jump numbers before/after for this family, the stills, what phase 1 needs; one version.js
   line; last line `LAYERS0 DONE` or `LAYERS0 BLOCKED: <why>`.

## Feedback loops
None: drawing only - no rule, number or AI choice changes; the page plays the same beats. Trial first: ONE run (blue jab
landed at Mid) rendered and drawn before the whole family.

## VISUAL GATE
Red first: a jump_ana run on today's page (no ?layers) records the jab family's boundary jumps - the number to beat.
Stills are opened with the file tool and checked for: both men head to feet in frame, no arm through a body at Inside,
no man floating (feet on the canvas line), the near man in front. The owner's look on the page closes it.

## Contract
- OWNS: tools/pics2d_anim.gd, tools/pics2d_bob.gd (the solo mode only), proto/twohands/img/layers/ (new),
  proto/twohands/ring_ui.js (the ?layers=1 path only), proto/twohands/version.js (one line), docs/LAYERS0_RESULT.md
- RED_TEST: jump_ana on today's page, jab family: the boundary jumps it reports
- REGRESSION: node proto/twohands/tools/page_play_test.mjs order.html; node proto/twohands/tools/anim_check.mjs
- VISUAL: the stills above

## Prior research
LAYERS_SCOPE_S569.md, MMC_DISTANCE_S569.md, GLIDE1/GLIDE2 results (why patches failed), memory S562 glide distance,
S569 jumps found + steps fixed.

## What would a human do?
A fighting-game animator: each fighter is his own sprite on his own position; the code moves the position, the clip only
plays on top.

## Prefab check
The Animo pack (bought) for reactions; our own 3D takes for the punches and holds.

## Not yours
order.html rules, every other page, the public site. Never "Ring Switches".
