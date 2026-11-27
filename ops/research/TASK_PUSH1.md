# TASK PUSH1 - the push off drawn right: a run for each side, at Inside, and the page moves the men (S569)

Kind: render. Model: Opus 5.5 console worker (PC: GPU, hidden desktop) - AFTER RECOIL1 (one windowed render at a time),
only when no game is open and the watchdog is not RED. Discipline: boxing (Puncher's chance pages).
Seat rules: ops/research/WORKER_S566.md.

## Why
Owner S569: "the fighter get displaced without moving". The recorder (proto/twohands/tools/jump_rec.mjs + jump_ana.py)
found the push off jumps 24-55 px at both ends: `push`, `blue_push` and `red_push` are ONE picture set (push_*.webp,
tools/pics2d_anim_more.gd `push`, PushOff from the tie-up gap 0.68 m) - the same man pushes whichever side the page
asks for, it starts from the old tie-up gap (not today's Inside, RANGE_IN 0.55 m), and ring_ui.js never moves the step
counts after a push (the page's rule: a push Inside puts the range at Mid), so the next run snaps.

## Do
1. Before: `node proto/twohands/tools/jump_rec.mjs <out>.json 6` and `python proto/twohands/tools/jump_ana.py <out>.json
   proto/twohands/img/anim 12` - keep every line naming push. Pushes are rare (about 3% of beats): if the random bouts
   play none, force one with beat_shot.mjs (`"mine": {"lead": "push"}` at range 1) and record that.
2. pics2d_anim_more.gd: `blue_push` and `red_push`, each with the right man pushing, starting at Inside (RANGE_IN, the
   holds' own spots) and ending with the pushed man one place back at Mid (the guard_r2 spots); a push at nothing
   (range > 1) draws the guard run of that range (no new run). anim_web.py for the web pictures; frames.json rows with
   `range: 1`.
3. ring_ui.js: after a push run that the page resolved as landing (the range went Inside -> Mid), the pushed man's count
   moves one back (as stepOne does for a back off), then slide(); a push at nothing moves nothing. Read order.html line
   ~248 (the push rule) and the event it writes; do not edit order.html.
4. After: the same recording - no boundary jump over 8 screen px at a push; anim_check.mjs PASS; page_play_test
   order.html; a full-size still of a push (beat_shot.mjs) opened before the commit. One version.js line (pull first).
5. docs/PUSH1_RESULT.md, last line `PUSH1 DONE` or `PUSH1 BLOCKED: <why>`.

## Feedback loops
None: pictures and the page's drawing only; no rule, number or choice changes.

## Prior research
docs/RECOIL1_RESULT.md (when it lands), docs/GLIDE2_RESULT.md, docs/INSIDE1_RESULT.md, tools/pics2d_anim_more.gd header,
proto/twohands/ring_ui.js (stepChain / stepOne, S569).

## What would a human do?
An animator: the man who shoves is the one whose arms go out, and the man shoved lands where the next shot expects him.

## Prefab check
Not applicable (our own renders; PushOff.gd is ours).

## Contract
- OWNS: tools/pics2d_anim_more.gd (the push only), proto/twohands/img/anim/blue_push_*, red_push_* and their frames.json
  rows, proto/twohands/ring_ui.js (the push count only), proto/twohands/version.js (one line), docs/PUSH1_RESULT.md
- RED_TEST: jump_ana.py: push boundaries 24-55 px; blue_push and red_push share one picture set
- REGRESSION: node proto/twohands/tools/anim_check.mjs; node proto/twohands/tools/page_play_test.mjs order.html
- VISUAL: a full-size still of each side's push (beat_shot.mjs), opened before the commit

## Not yours
order.html and every page's rules, kick.html (KICKFIX5), the punch runs (RECOIL1). Never Ring Switches.
