# S452 digest (2026-11-13, Claude Opus 5.5)

## Done
- His C362-C364 on the live fight HUD (4044a5ab): RoundHits icon mode sizes each organ to its own place (brain 0.85 of the head,
  ribs/liver 1.3 of their own rx), count outside the body; HudRegroup SMALL 176x270 -> 200x320; ScoreBug CARDS row from under the
  round box (y 178, at the heads) to its left at y 8. holo_live_test, corner_bar_test green; fight3d_play hudregroup failures=0.
  Stills on the review board.
- Qwen POWER1C rejected, PR 253 closed: by its own table OVER_HEAD and ELBOW still red after the fix; join_return 0->2,
  hit_carry 40->52, punch_speed 39->41. The fourth seat round on punch motion that missed -> POWER1D in-house.
- Grok Dev BLOCKLOOK4 not merged, PR 254 closed: placement alone inert; the arm_block landed-path hook passes MATCH for jabs but
  over-reaches hooks and regresses meet 10->12, absorb 0->4. Findings kept: ops/research/BLOCKLOOK4_RESULT.md.
- BLOCKLOOK5 sent to Grok Dev (TASK_BLOCKLOOK5.md): straights on the landed path, hooks as today, meet/absorb held.
- STEPMASTERY1A launched on Qwen (TASK_STEPMASTERY1A.md): StepMastery pure rules + tests; Claude wires after.
- Coach default pad cards (2 of 6 punches): decided no standalone change - map M3's "coach holds it" (PROGBUILD1) owns it.
- Export built (Builds/FightCamp.exe), WHAT_TO_TRY current.

## Not done
- Miro P0 redraw: connector returns server errors even for a one-line update after his reconnect; svg at E:/FightCamp/tmp/wwa_nodel.svg
  (16 surplus widgets' deletions stripped - they need his OK before any data-deleted send).
- Critics SQ61-65 still queued at the seats.

## Trap
- A GDScript `var x := a or b` on a Dictionary-derived value is a parse error that only shows as missing holos in a still run
  (the log is needed: hidden_desktop.py --log=F). Type it.
