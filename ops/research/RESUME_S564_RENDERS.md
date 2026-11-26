# S564 resume: INSIDE1 + GLIDE2 renders (one console worker, both tasks in order)

The S562 workers for TASK_INSIDE1.md and TASK_GLIDE2.md finished their code and stopped before any picture was made:
ArcheAge was open and the PC ran out of memory. On 2026-11-26 14:30 the game is CLOSED and the watchdog is GREEN.
You finish both, one windowed render at a time.

Read first: `docs/INSIDE1_RESULT.md`, `docs/GLIDE2_RESULT.md`, then `ops/research/TASK_INSIDE1.md` and
`ops/research/TASK_GLIDE2.md` (their bars, their owned files, their tests).

## Order
1. INSIDE1 Phase 1: `sh ops/previews/s562_inside/probe.sh` (one hidden-desktop run, ~5 min). Put the INSIDE_PROBE table
   in docs/INSIDE1_RESULT.md, pick the Inside distance by the task's bars (the punch table there already points at 0.55;
   the hold numbers decide), set `RANGE_INSIDE_M` (tools/pics2d_anim.gd) and `RANGE_M[1]` (proto/twohands/ring_ui.js) and
   the copy in tools/step_travel_check.py to the pick.
2. GLIDE2 renders: `sh ops/previews/s562_glide2/render.sh` (head r3, r2; kick r3, r2), then anim_web strips, open the
   strips with your file tool, the edge table at Long and Mid into docs/GLIDE2_RESULT.md.
3. INSIDE1 step 4 re-render at the new Inside (the holds/guard with masks, steps, punch _r1, feints, push, slip_in, the
   head moves at Inside and the GLIDE2 Inside runs it left for INSIDE1), anim_web, the edge table, beat_shot, mask_shots.
4. INSIDE1 Phase 2 (the see-through overlap) only if steps 1-3 are green; otherwise stop and write why.

## Rules for this run
- Before EVERY render: `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once` (exit 1 =
  wait) and `tasklist | grep -i archeage` - if the owner's game opens, finish the current render, then wait (one job only
  while it is open). Never two windowed renders at once; never Godot started any way but the scripts above / godot_slot.
- Every picture is `south=blue`, his fixed ring camera. Nothing near the fighters. A clip starts and ends where the men
  stand: the edge table (> 8 px = a jump) is the proof, never a shrunk strip.
- Open every strip/still you claim with your file tool. Nothing opens on his monitors.
- Commit by pathspec only: `git add -- <files>` then `git commit -m "..." -- <files>` (other sessions share this checkout).
  Pictures go in proto/twohands/img/anim the way the earlier runs did. Appended comments are `/* */`, never `//`.
- After any ring_ui.js change: `node proto/twohands/tools/page_play_test.mjs` on order.html, punch.html, head.html,
  kick.html; page_parse; rules_test, head_test, kick_test.
- Update both result docs as you go. End with `INSIDE1 DONE` / `GLIDE2 DONE` or `... BLOCKED: <why>` as the last line.
