# S425 handover: collect the two animation fixes, film them, then the dues boards (written 2026-11-10, S424 + S424b)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S425` and redraw the map (recipe: ops/Tools/where_we_are_svg.py docstring; the frame refuses to resize - harmless; after a redraw run `learn` / `trim` as the svg command prints).
Older handovers are in git (this file's history); S396 to S417 in ops/research/HANDOVERS_S349_S417.md.

## What S424 did (one session, two stages: he asked "why you stopped this session ??" after the first ship - it was early)
- His board answers: Q-176 dues "ok for the mechanism but the design needs better presentation"; Q-175 cutman "need to
  improve the depth ... rated 4/10"; Q-177 the painted dues boards "Yes, build it".
- FIGHTDISPLAY1 COLLECTED (f3883134): corner bar, graded calls, wood scorebug. Cursor's run hung on "Connection lost" AFTER
  building; stopped by PID with his OK. Windowed render E:/FightCamp/tmp/s424_fd1 looked at; corner_bar_test fixed (headless
  the fight view is 1920 tall); LiveRound.gd back under its 470 cap (S423's probe hook had file_limits red on main).
- Dues: Membership.intake_chance + HomeJuniors reads the band (34826128, live). The 5-year balance test is RED (premium wins
  9 of 9; S423's sums assumed the cap never binds and a home-grown boxer = half a stipend) - branch claude/duesband1, NOT
  merged. John SQ34 asks what really funds a cheap community club. Grants already exist (Grants.gd, ~$1,700 a year
  expected): not enough alone. Do not tune to pass.
- DUESCARD1 briefed for Cursor (painted boards, true numbers, change from next month); Ludo painted the three member
  pictures (assets/ui/dues). FIGHTDISPLAY2 now also fixes the empty last-call box and orders calls best-first in gold.
- R28 v3 (depth) -> Kalli SQ32. R37: the pro ask exists (ProLadder); the amateur ask -> John SQ33.
- Old project research (his "share the research of oldproject"): every written doc was already in ops/research; the two
  research PDFs added; ops/research/OLD_PROJECT_MEDIA.md says where the 268 old stills/films live and how to fetch one.
- FIGHTSLIDE3 collected (no single slide cause).

## Running (yours)
- LEGTREMBLE4 (Qwen, wt LEAN_LEGTREMBLE4, branch qwen/legtremble4): head_aim's VOID (hips gap read 3 frames after reset).
- KDFIX4 (Cursor, wt LEAN_KDFIX4, branch cursor/kdfix4): knockdown sway 0.76 cm -> settle vs sway; block_meet red on the
  KDFIX branches (green on main's nightly).
- Cursor queue after KDFIX4: DUESCARD1, FIGHTDISPLAY2, TRAININGB1. Chat seats: Kalli SQ32, John SQ33, SQ34.

## Order for S425
1. Collect LEGTREMBLE4 / KDFIX4 as they land (diff, the touched tests), FILM round 2 / a knockdown, LOOK, post on the
   review board + SendUserFile. He asked "when do you think i will be able to see a second animation on the board ?".
   Close PRs 162, 163, 166 when their fix is in.
2. Collect DUESCARD1, render Club > Money, compare with docs/mockups/s424/dues_painted_v4.png.
3. John SQ34 -> redo the dues sums -> make the 5-year test green honestly -> merge claude/duesband1's test.
4. Kalli SQ32 -> two critics -> board (Q for R28 v3). John SQ33 -> R37 amateur ask map. Then R55, R58.

## Traps
- `agent_comms.py ask --attach` resolves paths from ops/: pass absolute paths.
- `seat_queue.py add --brief` takes the path from ops/ (research/<file>.md).
- A REGRESSION test that lives only on the BASE branch fails brief_contract: keep it in the RESULT lines instead.
- A seat calling a red test "pre-existing": check the nightly before believing it.
- Goose's CI "success" does not run a new test: run it yourself (DUESBAND1's was red).
- A hung agent may have finished its work: look at the worktree before relaunching.
- Do not ship while a collectable PR or a free seat's work is in reach (he asked why the session stopped).

SETTINGS: S424 ran on Opus 5.5. Weekly plan use was ~88% at S423's end (resets 11-12): propose Sonnet, high effort, Fast off, until the reset.
