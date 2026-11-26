# TASK GLIDE2 - head moves and kicks at every range: the men keep their distance on head.html and kick.html (S562)

Kind: build (picture tools + page check). Model: claude-opus-5-5. Discipline: boxing / kickboxing (Ring Switches).
Seat: console worker. Estimate: 2-3 hours, ~30-40 min of GPU renders.

## Why
The owner on the main page (S562): "the distance between fighters is not consistant when clips play, it gets reset when
some clip animations play, can you check and fix all that" and "i select hold your ground yet the animation showed my
fighter moving wtf ????". Cause: every punch run stood the puncher on his glove's spot for the whole run, whatever the
range the page was at. GLIDE1 (S562, commits 83af562e5, 49f6ba017, 7bbc8a297) fixed it for the punches, the feint and the
push off on order.html: `tools/pics2d_anim.gd range=<1|2|3>` makes a run at a page range - the puncher starts and ends on
his spot (Long = the guard spots, Mid one step of 0.355 m in, Inside two; blue's runs with red on his spot, red's runs with
blue on his) and steps into the punch between (`_glide_w`); `short=1` makes the falls-short runs; `proto/twohands/ring_ui.js`
`atRange` plays the run of the range the men stand at. Read those three first.
Measured on the web pictures (left/right edge of the opaque pixels, 480 px; holds: blue's back edge 426 Long, 371 Mid, 317
Inside): the head-move runs (`tools/pics2d_head.gd`) and the kick runs (`tools/pics2d_kick.gd`) still stand at one fixed
gap each - `blue_jab_slipped` 370 (Mid), `blue_lead_hook_rolled` 324 (Inside), `blue_jab_leaned` 411-415, `blue_low_kick_*`
399-403, `blue_teep_*` 369-387. On head.html and kick.html those jump exactly as the punches did.

## Do
1. `tools/pics2d_head.gd` and `tools/pics2d_kick.gd`: the same `range=` (and the same naming: plain = Long, `_r2` Mid, `_r1`
   Inside, a `range` field in the run's row) - the attacker steps in and out as GLIDE1 does; the DEFENDER of a head move
   stays on his spot for the range (his head moves, his feet stay). Only the ranges the move happens at on the page
   (head.html's ACT / head-move reach; kick.html's kick reach table) - list them in your result.
2. Render both corners (south=blue; the owner's camera is read by the tools themselves) through `ops/Tools/godot_slot.py`
   + `tools/hidden_desktop.py`; ONE windowed render at a time: before each, `python ops/Tools/godot_slot.py status` shows no
   hidden_desktop job running. HIS GAME FIRST: `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1
   -Once`; if ArcheAge runs or the PC is RED, wait.
3. `python proto/twohands/tools/anim_web.py <dirs> --strips <dir>`; open the strips yourself.
4. `ring_ui.js` `atRange` already handles `<x>_(landed|blocked|missed)`: extend it (smallest change) for the head-move and
   kick result names if they differ (`_slipped`, `_rolled`, `_leaned`, kick results), and warm them.
5. Prove it: `node proto/twohands/tools/beat_shot.mjs <out> head.html '<beats>'` and the same for kick.html at Long, Mid and
   Inside; for each, the edges of the hold before, the run's first and last frame and the hold after (a jump is > 8 px).
   `docs/GLIDE2_RESULT.md` with that table. End with `GLIDE2 DONE` or `GLIDE2 BLOCKED: <why>`.

## Feedback loops
None: pictures of the same rules.

## Not allowed
No change to any page's rules (above `// ---- the page`), under scripts/, or to order.html / punch.html (BODYUI2 owns their
page part today). Commit only your paths (`git commit -- <paths>`); push when done.

## Contract
- OWNS: tools/pics2d_head.gd, tools/pics2d_kick.gd, proto/twohands/ring_ui.js, docs/GLIDE2_RESULT.md, proto/twohands/img/anim/frames.json
- RED_TEST: the edge table on today's head.html and kick.html (a jump > 8 px between a hold and a run)
- REGRESSION: page_play_test.mjs 4 passed on head.html and kick.html; head_test.mjs 11, kick_test.mjs 12; page_parse.mjs ok
- VISUAL: the strips and beat_shot screenshots, opened by the worker; the owner closes it by playing

## VISUAL GATE
The owner's ring camera only (south=blue); a run is checked on its strip and on the page, never from numbers alone.

## Prior research
ops/research/TASK_HEADPICS1.md, docs/HEADPICS1_RESULT.md (the head move is staged with the glove through the place the
head was), ops/research/KICKTAKE1_RESULT.md; GLIDE1 commits above; memory reference_s561_head_pictures_and_traps.

## What would a human do?
Make every clip start and end where the men stand, so a clip never moves a man the rules did not move.

## Prefab check
Our own tools; nothing to buy.
