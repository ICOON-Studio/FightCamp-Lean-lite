# TASK LAYERS1 - one man per picture, phase 1: every family re-rendered with masks, then ?layers=1 the default (S571)

Kind: build (renders + page drawing). Model: Opus 5.5 console worker (PC; GPU renders on the hidden desktop, ONE render at
a time, never beside another windowed render; no game open - stop and wait if ArcheAge or llama-server > 4 GB is up).
Discipline: Puncher's chance, boxing (order.html; kick.html / head.html / one.html are built from it).
Seat rules: ops/research/WORKER_S566.md. Spec: ops/research/LAYERS_SCOPE_S569.md. Phase 0 (holds + jab) is DONE:
docs/LAYERS0_RESULT.md - read it first, it says how (layers_cut.py on MASK1 part masks, layers_ui.js, the clip blend).
Starts only after the owner has looked at http://127.0.0.1:8797/order.html?layers=1 (phase 0 said "your look decides").

## Do
1. Re-render with `layers=1` (a part mask beside every frame), ONE family per render, in this order (most-seen first):
   a. the other punches: cross, lead hook, rear hook, body jab, body hook, uppercuts, overhand, body cross - both sides,
      Long / Mid / Inside, landed / blocked / missed / short (tools/pics2d_anim.gd);
   b. steps in / back off / push / clinch (tools/pics2d_anim_more.gd);
   c. head moves - slip, roll, pull (tools/pics2d_head.gd);
   d. kicks (tools/pics2d_kick.gd) - kick.html only.
   After each family: `anim_web.py`, `layers_cut.py`, then the gate on that family (below). A family that fails stays on
   the old picture and the next one goes on; say which.
2. The hit man's own reaction runs from the Animo pack (assets/anim/animo_boxing, ops/research/ANIMO_PACK_S570.md):
   Get_Hit head / body, a stagger, a knockdown - retargeted once, rendered solo with masks like the rest.
3. When every punch family passes: `?layers=1` becomes the default on order.html (a `?layers=0` keeps the old way for one
   session), the GLIDE / step patch code in ring_ui.js that layers replace is removed (name each function removed), and
   the built pages (make_kick.py, make_head.py, make_one.py) are rebuilt.

## Feedback loops
None: drawing only - no rule, number or AI choice changes; the page plays the same beats. Trial first: the cross family
alone, rendered, cut and gated, before the rest.

## VISUAL GATE
Red first: jump_ana on today's ?layers=1 page counts the boundary jumps touching each family (phase 0 measured 77 jumps
in all, 0 between two layered runs). Per family: `node proto/twohands/tools/jump_rec.mjs` + `python
proto/twohands/tools/jump_ana.py` on 6 random bouts - 0 jumps over 4 screen px where both runs are layered. At the end:
total jumps over 4 px below 10 (from 54 on the S570 page). Full-size stills (beat_shot.mjs, `?layers=1`) of each family
at each range, opened with the file tool and checked for: both men head to feet in frame, no arm through a body at
Inside, feet on the canvas line, the near man in front. The owner's look on the page closes it.

## Do not
- No text or marks near the fighters (owner S562). No patch layer on two-man pictures (METHOD line S569).
- Never "Ring Switches" (the game is Puncher's chance).

## Contract
- OWNS: tools/pics2d_anim.gd, tools/pics2d_anim_more.gd, tools/pics2d_head.gd, tools/pics2d_kick.gd (the layers=1 mode
  only), proto/twohands/img/layers/, proto/twohands/layers_ui.js, proto/twohands/ring_ui.js (layers default + the glide
  code it retires), proto/twohands/version.js (one line a family), docs/LAYERS1_RESULT.md
- RED_TEST: jump_ana on the ?layers=1 page, per family: its boundary jumps
- REGRESSION: node proto/twohands/tools/page_play_test.mjs; node proto/twohands/tools/anim_check.mjs
- VISUAL: the stills above

## Result
docs/LAYERS1_RESULT.md: per family the jumps before/after, the stills, what stayed on the old picture and why; three plain
lines for the owner; last line `LAYERS1 DONE` or `LAYERS1 BLOCKED: <why>`.

## Prior research
LAYERS_SCOPE_S569.md, docs/LAYERS0_RESULT.md, MMC_DISTANCE_S569.md, GLIDE1/GLIDE2 results, memory S562 glide distance,
S569 jumps + steps, S570 layers phase 0.

## What would a human do?
A fighting-game animator: each fighter is his own sprite on his own position; the code moves the position, the clip only
plays on top - and the hit man has his own reaction clip.

## Prefab check
The Animo pack (bought S570) for hit reactions, staggers and knockdowns; our own 3D takes for the punches, steps and holds.
