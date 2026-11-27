# TASK RECOIL1 - the man who is hit, blocks or dodges ends on his spot: re-render the punch runs (S569)

Kind: render. Model: Opus 5.5 console worker (PC: GPU, hidden desktop) - only when no game is open and the watchdog is
not RED. Discipline: boxing + kickboxing pictures (Puncher's chance pages). Seat rules: ops/research/WORKER_S566.md.

## Why
Owner S569: "the animations played are not correct the fighter get displaced without moving , i suspect some clip rest
the position". The recorder (proto/twohands/tools/jump_rec.mjs + jump_ana.py, real beats in headless Edge) found two
causes. The step one is fixed (v0.569.4, ring_ui.js). The second: in almost every punch run the OTHER man (his hit
reaction, block, pull or duck) ends 8-10 render px off his guard spot (13-18 px on screen), and the next run puts him back
- a visible snap after nearly every punch. A picture-only pass fixed 7 of 99 runs (the men touch after the contact), so the
runs are made again.

## What to change
tools/pics2d_anim.gd (and pics2d_head.gd / pics2d_kick.gd if their runs show the same in the census): after the contact
the other man eases back to his own spot at the run's range over the last frames (the same ease the puncher's return
uses), so the LAST frame stands him where the guard run of that range stands him (within 2 render px). Nothing else moves:
the puncher's path, the contact pose and its gate stay as they are.

## Do
1. The census first (red on today's files): `python proto/twohands/tools/jump_ana.py` needs a recording - run
   `node proto/twohands/tools/jump_rec.mjs <out>.json 4` (page server 8797) and keep its JUMPS line as the before.
   Also the static check: for every run, the other man's last-frame shorts x against his guard run of the run's range
   (`python proto/twohands/tools/edge_census.py proto/twohands/img/anim 6`: shorts centroid by colour).
2. The script change; render ONE run (only=blue_jab_landed range=3) on the hidden desktop
   (`python tools/hidden_desktop.py run ...` - the command line is at the top of pics2d_anim.gd), check it, then all runs
   the census flags, by family, with `proto/twohands/tools/anim_web.py` to make the web pictures.
3. After: jump_rec 4 bouts again - no run-boundary jump over 8 screen px except knockdowns; anim_check.mjs PASS;
   page_play_test order.html; a full-size headless-Edge still of one landed punch (beat_shot.mjs).
4. docs/RECOIL1_RESULT.md: before/after JUMPS, the runs re-made, one line for the owner. Last line `RECOIL1 DONE` or
   `RECOIL1 BLOCKED: <why>`. One version.js line (pull first, next free 0.569.<n>).

## Feedback loops
None: pictures only; no rule, number or choice changes.

## Prior research
docs/GLIDE2_RESULT.md (the edge tables, the range= runs), docs/INSIDE1_RESULT.md (RANGE_IN), docs/KDPIC1_RESULT.md,
proto/twohands/tools/edge_table.py, tools/pics2d_anim.gd's header.

## What would a human do?
An animator: after the hit the man recovers his stance where he stood, so the next shot can cut to him without a jump.

## Prefab check
Not applicable (our own renders).

## Contract
- OWNS: tools/pics2d_anim.gd, tools/pics2d_head.gd, tools/pics2d_kick.gd (the ease only), proto/twohands/img/anim/*
  (the re-made runs and frames.json rows), proto/twohands/version.js (one line), docs/RECOIL1_RESULT.md
- RED_TEST: jump_ana.py on 4 recorded bouts: 13-18 px snaps after landed / blocked / missed runs
- REGRESSION: node proto/twohands/tools/anim_check.mjs; node proto/twohands/tools/page_play_test.mjs order.html
- VISUAL: a full-size still of a landed punch and its next run (beat_shot.mjs), opened before the merge

## Not yours
ring_ui.js (the step fix), order.html and every page's rules, kick.html's rules (KICKFIX5). Never Ring Switches.
