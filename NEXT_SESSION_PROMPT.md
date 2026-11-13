# S451 handover (written 2026-11-13 ~14:35 at the end of S450; S449's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S451`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 300k context (S450 handed over at ~440k: too late, watch it).
- At most TWO helper sessions.

## HIS WORDS IN S450 (verbatim)
- Board answers:
  - Q-210 "Yes, that order"
  - Q-211 "Yes, go ahead"
  - Q-212 "Yes, map it after the fight week, real effects only"
  - Q-213 "A, full screen" (the office = a full-screen computer desktop)
- C352 "the seaside camp pictureis showing a mountain ?" -> fixed (camp_plan_v3.png, review board 2026-11-13_1330).
- C353/C354 on the lead uppercut (game camera): "wtf are these arm angles ? looks broken", "terrible", "terrible".
- C359 at 2.4 s of the uppercut film: "terrible hands completely broken".

  All three are in the POWER1C brief.

## RUNNING (collect first)
- **Qwen POWER1C** (wt/LEAN_POWER1C, ops/research/TASK_POWER1C.md): the lead uppercut's tail.
  - The bars: the glove never over her own head, the elbow under the shoulder, a 0.10-0.20 s follow-through, back to guard by 0.40 s at 9.6 m/s or less, the path in front of her face.
  - After the merge: film the seed 4242 bout on 3+ seeds (tools/hit_frame_film.gd, the game camera), open the stills, then the review board.
  - It moved from Antigravity, which stopped on its credit balance (his account, nothing to do from here).
- **Goose PROGPROBE1R2** (issue 251, branch goose/issue-251). Round 1 (goose/issue-248) was VOID:
  - steps never trained (drill_step_def never called)
  - the hold policies never ran

  Check its CONTROL row first; then the cadence, the hold units and the plan-size trade.
- **Grok Dev OFFICE1** (TASK_OFFICE1.md, the frame + Desktop, look A): render the real screen on the hidden desktop (tools/layout_snapshot.gd), open it, then the review board. Then **BLOCKLOOK4** is queued at Grok Dev: move the block's catch out to 90 % reach so the blocked punch keeps its shape.
- **Critics** SQ60/SQ62 (Kalli, John: AMATEURWEEK1 v4) and SQ61/SQ63 (COACHFIT1 v1). Briefs: ops/research/*_CRITIC_S450_BRIEF.md.
  - Two at 7+: fix the defects they name, then his board with --attach.
  - Below 7: write the next version.
  - SQ59 (John on v3) is superseded by v4: read it only for defects.

## DONE IN S450
- BODYFACTS1, MOVETREE1 and SLOTS1 collected.
- FIRELEVEL3 switched on, with a first-season re-measure: docs/FIRELEVEL3_RESULT.md. The harness gains `fire=off` and `plan=combos`.
- BLOCKLOOK3 collected (absorb) plus the BeatFire body-block one-liner. The reel is on the review board.
- FIGHTWEEKPROBE1 and FIGHTWEEKPROBE2 ran in-house: docs/FIGHTWEEKPROBE1_RESULT.md. LiveRound reads bout["r1_flat"] (default 0).
- AMATEURWEEK1 map v4 (ops/research/AMATEURWEEK1_MAP_V4_S450.md) and COACHFIT1 map v1 (ops/research/COACHFIT1_MAP_V1_S450.md).
- Five finished briefs marked DONE/SUPERSEDED.

## DECIDED IN S450 (Claude)
- FIGHT WEEK TARGET MOVED. In this engine a week's fight-night levers top out at about 5 wins in 100: the whole tank costs 8-16, and even a 3.0 flat round 1 costs only 3-4. The 10-12 "best vs laziest" target is therefore measured over a SEASON. That is FIGHTWEEKPROBE3, through career_harness: always Rest up / always Train through / the coach's pick. Rest up's flat is 2.0 (it ends the "Rest up wins every pair" lookup).
- John's rule-book numbers replace v3's guesses:
  - weigh-in on bout day, 1 h before
  - matching at walking weight inside the category gap
  - no $300 miss fee
  - seasonal camp prices
- The BLOCK's arm shape: move the catch out, not the punch (BLOCKLOOK4).
- The coach map folds S412's book (as each coach's school) and bond steps into the S448 fit/load/growth/temper plan and the progression map's M6 market.

## NEXT (after the collects)
1. FIGHTWEEKPROBE3, once v4 passes the critics.
2. The progression's next wave:
   - STEPMASTERY1 (Claude: steps and defences get mastery; PROGPROBE1R2 models it first)
   - then SPECIALTY1 (Qwen: the hold rule)
   - then wire SLOTS1 into PadWeek and the Monday review (Claude)
3. Miro P0 redraw (S450 did it once at the start).

## WAITING ON HIM (board)
- His look:
  - the block reel round 3
  - camp v3 (seaside fixed)
  - the result tabs
- His ear: the voices, the PA mix and the S448 sounds.

## TRAPS (S450)
- auto_collect's "CI log" check fails for every seat PR: CI does not run those tests. Collect by file and run the tests locally.
- A probe that reads the same in both arms is not a pass: career_harness's coach plan holds no combination lines (FireLevel never bit). `plan=combos` is the arm that can read worse.
- Since S398 an opponent's rating is NOT comparable to our BoutRules.fight_power: calibrate pairs on win share (tools/fightweek_probe.gd `_calibrate`).
- `rtk grep` takes no plain grep flags: use `rtk proxy grep` or the Grep tool. A bare `scripts/*.gd` glob with no match hangs.
- seat_dispatch.launch for a task whose LEAN_<task> worktree exists fails. An empty failed one: `git worktree remove --force` after checking its status.
