# S424 digest (2026-11-10)

One stage: act on his two board answers (dues, cutman), collect what landed, keep the two animation items moving.

## What changed in the game
Nothing in the shipped game. Collected: tools/fight_slide_probe.gd + docs/FIGHTSLIDE1_RESULT.md (FIGHTSLIDE3, Qwen, 2dce6130).

## Decisions, from his board answers
- Q-176 dues: "Yes, but change something" - "ok for the mechanism but the design needs better presentation". The pure part
  (Membership intake chance per band 0.50 / 0.35 / 0.20, tests/dues_bands_sim_test.gd: no band wins all 9 cases, control =
  flat 0.35 must show premium winning everywhere) went to Goose issue #165 (TASK_DUESBAND1). Claude wires HomeJuniors and
  "from next month" after it lands. The look: Ludo `image edit` repaint of docs/mockups/s423/dues_choice.png with the
  Overview concept as reference, 4 tries, 2 credits; the pick has every number right (docs/mockups/s424/dues_painted_v4.png),
  on the board as Q-177.
- Q-175 cutman: "need to improve the depth of the mechanic, rated 4/10". v2 was a critic's 10/10 and he scored it 4. v3 brief
  to Kalli (SQ32): linked decisions before the fight, in the round, on the cards, in the 60 s minute, and across the career.

## Evidence
- LEGTREMBLE3's head_aim red (E:/FightCamp/tmp/head_aim.log): the only failure is `AIM B_A_dn lead_hook ... gap=0.972 VOID`
  with gap_m 0.916 and GAP_TOL 0.05; every aim bar passed. `_reset` reads the hips gap 3 frames after the guard, so the VOID
  is a body still settling, not an aim fault. LEGTREMBLE4 briefed for Qwen.
- KDFIX3 (qwen/kdfix3 3f227d73): knockdown chest side travel 1.91 -> 0.76 cm, all layers off 0.18 cm, bar 0.5 above it:
  failures=3. Its text said the rest "comes from the fall clip", which its own numbers contradict. block_meet failures=2 on the
  branch, called "pre-existing"; the 05:00 full run on main (a5d7f66b) passed 239 of 239. KDFIX4 briefed.
- R37: Matchmaking.ask + ProLadder already give the PRO ask with refusal reasons; the amateur path has offers only
  (AmateurBooking). John SQ33 researches how a club really asks for a bout.

## What a seat got wrong, and how it was caught
- KDFIX3: a red test called pre-existing (caught against the nightly) and a cause claimed against its own floor reading.
- FIGHTDISPLAY1 (Cursor) hung on "Connection lost, reconnecting" at 12:41, no edits. Stopping its process tree was refused by
  the permission check: the operator is asked.

## HANDOFF
Next action and order: roadmap.json `now.next_action` and NEXT_SESSION_PROMPT.md. Running: DUESBAND1 (Goose #165), KDFIX3's
runner checks (Qwen), FIGHTDISPLAY1 (Cursor, hung). Queued on Qwen: LEGTREMBLE4, KDFIX4. Chat seats: Kalli SQ32, John SQ33.
Board: Q-177.

## Stage 2 (S424b, same session: he asked "why you stopped this session ??" - the first ship was early)
- FIGHTDISPLAY1 collected f3883134 (Cursor's run hung on "Connection lost" AFTER building; stopped by PID with his OK).
  Windowed render E:/FightCamp/tmp/s424_fd1 looked at (bar at y 905-1075); corner_bar_test now checks against the fight
  view's bottom (headless the view is 1920 tall); LiveRound.gd 473 -> 469 lines (file_limits was red on main since S423).
  Tests green: corner_bar, hud_shown, hit_flash, holo_live, fight_flow, file_limits, words_on_screens, golden_path,
  plan_fight, plan_read; cover_probe reads as before (34.5%).
- Dues intake by band live 34826128 (membership, membership_why, gym_spend, golden_path green). 5-year balance test RED
  (premium 9 of 9) kept on claude/duesband1; John SQ34. DUESCARD1 briefed (Q-177 "Yes, build it"), Ludo member paintings
  in assets/ui/dues.
- Old project research: every written doc already here; 2 PDFs added; ops/research/OLD_PROJECT_MEDIA.md.
- Stopped at 402k context (rule ~420k). Running: LEGTREMBLE4 (Qwen), KDFIX4 (Cursor).
