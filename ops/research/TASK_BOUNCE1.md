# TASK BOUNCE1 - never still: a light bounce while the player plans (S562)

Kind: build (picture tool + page). Model: claude-opus-5-5. Discipline: boxing (Ring Switches, the main line).
Seat: console worker. Estimate: 2-3 hours, ~30 min of GPU renders. START ONLY after GLIDE2 has pushed (it owns ring_ui.js
and frames.json until then) and when `python ops/Tools/godot_slot.py status` shows no hidden_desktop job.

## Why
The roadmap row BOUNCE1 ("Never still: a light bounce between beats - the steps already glide: measured in S560") and the
S561 handover ("The never-still bounce ... renders: only when his game is closed"). While the player plans, the page shows
the hold run (`<corner>_<hold>[_r1|_r2]`, `tools/pics2d_anim_more.gd` HOLDS / HOLD_T: 7 frames of the hands going to the
hold) and then stands on its last frame: two statues. Boxers between exchanges are never still: a light bounce on the
balls of the feet, the guard staying where it is.

## Do
1. A bounce loop per hold and range, both corners: the hold's arms as they are (the authored hold takes), the hips and
   legs from a light in-place bounce. Candidates on disk: `ow_bounce_idle` (clip_db: hips_max 0.19 m, hips_side -0.17 m -
   too big as it is: scale it or pick its quiet part), the GuardLife fidget `pro_bounce` (scripts/fight3d/GuardLife.gd).
   The feet stay on their spots (the loop ends where it starts: a jump > 8 px between its last and first frame is a fail),
   the head stays inside its hold height +-3 cm. 4-6 frames a loop. Your call how to combine (a lower-body layer or a
   bake); write why in the result. A new block in `tools/pics2d_anim_more.gd` (`<corner>_<hold>_bob[_r1|_r2]`), south=blue,
   the owner's camera (read by the tool), with masks (`mask=on`) so the body view keeps working.
2. `proto/twohands/ring_ui.js`: after the hold run settles in plan, loop its `_bob` run (about 0.5 s a cycle) until the beat
   is fought; stop at once on Fight. If the bob run is missing, keep the still (as today).
3. Prove it: beat_shot screenshots at Long, Mid, Inside; the edge table (hold last frame, bob frames) shows no jump.
   `docs/BOUNCE1_RESULT.md`; strips on the review board (`python ops/Tools/review_add.py --stage S562 ...`). End with
   `BOUNCE1 DONE` or `BOUNCE1 BLOCKED: <why>`.

## Renders
HIS GAME FIRST: `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once`; if ArcheAge runs or
the PC is RED, wait. One windowed render at a time (godot_slot status shows no other hidden_desktop job).

## Feedback loops
None: pictures of the same rules.

## Not allowed
No change to any page's rules, under scripts/, or to order.html's page part (BODYUI2). Commit only your paths; push.

## Contract
- OWNS: tools/pics2d_anim_more.gd, proto/twohands/ring_ui.js, proto/twohands/img/anim/frames.json, docs/BOUNCE1_RESULT.md
- RED_TEST: on today's page two frames 1 s apart while planning are byte-identical (statues)
- REGRESSION: page_play_test.mjs 4 passed on order.html, punch.html, head.html, kick.html; page_parse.mjs ok
- VISUAL: the strips and beat_shot screenshots, opened by the worker; the owner's play closes it

## VISUAL GATE
The owner's ring camera only (south=blue); nothing drawn on or near the men (memory feedback_nothing_near_fighters_s562).

## Prior research
docs/ANIM_REBUILD_DESIGN.md (GuardLife fidgets), ops/research/S560_DIGEST.md (the steps glide), memory
project_s562_glide_distance (runs start and end where the men stand).

## What would a human do?
An animator loops a small bounce on the legs under the held guard, so the fighter breathes and moves without going
anywhere.

## Prefab check
Our own takes (ow_bounce_idle, pro_bounce); nothing to buy.
