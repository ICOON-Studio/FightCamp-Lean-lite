# S460 handover (written 2026-11-13 at the end of S459; S458's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S460`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k context; wrap-up from ~395k. At most TWO helper sessions / subagents at once.
- Never idle while a test or agent runs: run_in_background and do the next item.

## HIS S459 RULINGS (quote them)
- "need to finish intergrading mechanics before we spend more time in designing the menus" -> INTEGRATE1 first; no menu design.
- "use all free agents on loop until all mechanics have been designed . critics need to rate them at least 6 at depth and 6 at
  general design etc" -> design loop (ops/Tools/design_loop.py; tracker ops/research/DESIGN_LOOP_S459.md). Done = 6+ / 6+.
- Q-S294-218 "Hide the seams: no slow-down, calls any time, rules kept" + "hide the seam it gives away who is winning" -> DONE.
- "do not remove the holos yet" -> side holos stay; the shared holo sits in LANDED beside them (mockup sent, his call open).
- Estimate given: wiring the built modules ~Sun 15 Nov; designs to 6/6 ~Tue 17 Nov; all agreed mechanics built ~25-28 Nov.

## FIRST: collect the seat answers (queued S459, the 30-min reconcile sends them)
SQ73 Kalli: fight week v7 (revise) | SQ74 Dola: coach fit v4 (revise) | SQ75 John: hosted show score | SQ76 Maria: a fighter
leaves score. Each answer -> next round with design_loop.py (a revision goes to fresh critics; a score under 6/6 goes to a
revision). Queue the next batch the same session: PUSHTANK_MAP_V2_S442 critic, READREVEAL1 map (Claude drafts; the corner-minute
"Read her" job, his S458 add), CAMPLOC1, LEDGER1, weight hold/cut, turning pro.

## NEXT (Claude)
1. INTEGRATE1 (ops/research/INTEGRATION_S459.md): #3 PlanPhase, #4 Towel, #5 ProRead, #6 Loyalty, #7 TraitLine, #8 TrainRead,
   #9 TellWorth, #10 Knowledge, #11 ClubDeal, #12 CoachMarket. Each: wire into the game path + show on its EXISTING screen + one
   test that plays it. StyleName DONE (8c08210a). LineGrade HELD: wired as written it dropped a right plan's GOOD read 384 -> 161
   of 540 (OK = x0.85 nerfs every average plan 15%) - brief GRADE1 to a cloud seat (Goose/Arena): centre the multipliers so an
   average boxer's plan keeps its worth, measure Good vs Poor 2+ in 100 (PROGRESSION_MAP_S448 section 10), then wire.
2. Pre-existing reds (red on HEAD by control runs): fight_why_test (384/540 GOOD since S450 FIRELEVEL3; grading on fired uses
   only was tried: 231 and bad plans read GOOD 8x - reverted; decide with GRADE1); result_defects_test point 2 (not traced).
3. His open calls: Q-S294-219 liver vs ribs; the shared-holo mockup (remove the side holos?); switch the HUD regroup ON in the
   game (it is preview-only behind the `hudregroup` arg since S444 - every still he marks is the regroup) - ask on the board.
4. POWER1E rear uppercut tail (QUICK_BACK_S 0.10 + uppercut_tail). punch_range_test windowed baseline: 67 failures (animation
   geometry; it only runs with a picture - headless it lands nothing and errors at _finish).

## DONE IN S459
- FIXS458 (0f1e28b8): lasts-to off (STAMINA tooltip); body-map counts as dot + hooked line + plain number; call cards = glove +
  win-chance change from an even exchange (Exchanges.win_shift) + stamina cell, words on hover; PACE | AIM divider; LANDED rows
  with corner-coloured gloves (C383); office staff faces 76 px; money panel -> Club (members, room, 8 weeks, bills by date).
- FIGHTSEAM1 + shared holo (2d05de21): FightSeam.gd arms calls; no ShoutBar pause; dots/leader colour/Worked tag/ticks hidden
  until the bell; LANDED counts landed beats; SharedHolo.gd (hurt bands on labels); `sharedholo` arg hides side holos (mockup).
- Design loop tool + SQ73-76 (e9cdad24). StyleName wired (8c08210a, style_wire_test). bout_read fixed (749903ea).

## TRAPS (S459)
- LiveRound.gd has a TIGHT 470-line cap (file_limits): fold changes into existing lines.
- A seat-test or film run with `sharedholo` fails fight3d_play (the tool checks the side holos) - mockup only.
- Control runs: copy the touched files aside, `git show HEAD:<f> > <f>`, run, copy back (never a bare stash).
