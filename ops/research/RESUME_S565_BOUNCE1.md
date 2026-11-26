# S565 launch note for the BOUNCE1 console worker (read this, then ops/research/TASK_BOUNCE1.md whole)

The render slot is free on 2026-11-26 17:00: GLIDE2 is pushed (7534204a0) and INSIDE1 steps 1-4 are pushed (aae794ded).
INSIDE1's Phase 2 (the see-through overlap) is NOT started and nobody else holds `proto/twohands/ring_ui.js`,
`tools/pics2d_anim_more.gd` or `proto/twohands/img/anim/frames.json` now. You own them for BOUNCE1.

## What changed since the brief was written (S562)
- INSIDE is 0.55 m now (was 0.71): `tools/pics2d_anim.gd` RANGE_INSIDE_M, `proto/twohands/ring_ui.js` RANGE_M[1],
  `tools/step_travel_check.py`. Every hold run at Inside (`_r1`) was re-made at that distance, with head masks. Your
  bounce runs are made at the same three distances the hold runs use - read them from the tool, never type a number.
- Read `docs/INSIDE1_RESULT.md` (the last 40 lines) and `docs/GLIDE2_RESULT.md` (the end) first: the edge-table method
  (hold before, first frame, last frame, hold after; over 8 px = a jump) is the proof for your loop too.
- New pages since S562: `punch.html` and `wait.html` are BUILT copies of order.html (make_punch.py, make_wait.py). They
  load the same ring_ui.js. After your ring_ui.js change run `page_play_test.mjs` on order.html, punch.html, head.html,
  kick.html and wait.html, and `page_parse.mjs` on all five.
- `body_ui.js` is not yours; do not edit it.

## Rules for this run
- Before EVERY render: `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once` (exit 1 =
  wait) and `tasklist | grep -i archeage` - if the owner's game opens, finish the current render, then wait. Never two
  windowed renders at once; Godot only through the project's hidden-desktop scripts / godot_slot.
- Every picture is `south=blue`, the owner's fixed ring camera. Nothing drawn on or near the men.
- Open every strip and screenshot you claim with your file tool. Nothing opens on his monitors.
- Commit by pathspec only (`git add -- <files>` then `git commit -m "..." -- <files>`): other sessions share this
  checkout. Push after each finished step. Appended comments are `/* */`, never `//`.
- Review board: `python ops/Tools/review_add.py --stage S565 ...` for the strips.
- End `docs/BOUNCE1_RESULT.md` with `BOUNCE1 DONE` or `BOUNCE1 BLOCKED: <why>` as its last line, and stop. Do not start
  KDPIC1 or any other task.
