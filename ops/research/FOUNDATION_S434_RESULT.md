# Foundation fixes: the S434 workflow's result (landed 2026-11-11 late, after the S437 handover was written)

Branch `claude/foundation-s433`, pushed at b61377ea (11 commits on main's merge base; main is ~42 commits ahead).
Worktree E:/FightCamp/wt/LEAN_FOUNDATION_S433, clean. Workflow wf_91da691c-70b, journal under the S434 session's
subagents/workflows folder.

## Verdicts (fresh skeptic per item, two rounds each, then a final check)
- PUNCHSTART1: READY after round 2. Open, not gated: the first offers average 25.7 in 100 against M8's 40-60
  (PUNCHFLOOR1, a tuning call); PLAN_CARRY now 1.9 (a large catch-all, fitted on held-out arms); one held-out miss
  (Lucy -3 jab + tie-up v Maria 0.383 read, 0.318 real).
- CARDIO1: FIX AGAIN after round 2. Open: the Cardio camp card's Stamina end is derived from the mean's forecast
  (understates fight night); the fade SIZE is not held (share held 63.6 v 64.6 %, the mean fade 0.946 v main 0.646);
  the Stamina line shows on hover only (T17 wants it on the row); the design maps still say 64 (the game says 60) -
  TRAINING_MAP_S432 lines 37, 114, 153, 212, 324, 375, 431, 586 and CORE_LOOP_MAP_S432 C3; stale "59" comments.
- NOCAMP1: FIX AGAIN after round 2. Open: no test reads the bout page's fight-night chance on the path the player sees
  (FightPrep._tale -> CampForecast.for_read); fight_why passes by one bout (487 of 540, bar 486); the opponent's Tank
  is still Combos.TANK (F5, a note); weight left to the day never costs Tank (needs the same-day weigh-in).

## Final check (branch tip, not merged with main)
18 named tests + 25 readers green, including bout_read_test (the PUNCHSTART1 red is fixed). Not covered: RingDuel,
BoutCompare, WorldLadder, GoalTalk have no test that reads them. Add tests/plan_chain_test.gd to the daily list.
Merge conflict: only tools/run_tests.sh - take main's line and add `plan_chain_test punch_start_test` after
bout_read_test.

## Next (for the session that takes it)
Collect PUNCHSTART1 by diff once CARDIO1 and NOCAMP1 have their third round (they share files: BoutRead, BoutRules,
Sim); or collect the whole branch after that round, re-running the 18 named tests on the merge with main.
