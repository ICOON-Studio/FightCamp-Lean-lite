# TASK FIGHTERMODEL4C - CURSOR (Grok 4.7 High) - the fighter model at the old speed

Status: OPEN (S408, Claude main). Discipline: boxing. Model: grok-4.7-high.
Start every Godot run through `python ops/Tools/godot_slot.py run --who cursor -- <godot cmd>`.
FIRST: merge origin/main into this branch.

## Contract
BASE: cursor/fightermodel4a
OWNS: scripts/rules/Attrs.gd, scripts/rules/AttrGen.gd, scripts/rules/Duels.gd, scripts/rules/BoutRead.gd, scripts/rules/Exchanges.gd, scripts/state/RingDuel.gd, scripts/state/LiveRound.gd, scripts/state/LiveRead.gd, scripts/world/WorldBout.gd, scripts/world/WorldSim.gd, scripts/world/WorldGen.gd, tests/fighter_model_speed_test.gd
RED_TEST: tests/fighter_model_speed_test.gd -> FIGHTER_SPEED failures=0
REGRESSION: fighter_model, world_years, plan_bots, golden_path_test, save_load
VISUAL: no

## Prior research
Claude timed this branch against main on the same PC, one test at a time (S408). PR #106's CI hit its 18-minute limit twice; main's run takes 12.

| test | main | this branch |
|---|---|---|
| world_years_test | 1 s | 13 s |
| golden_path_test | 33 s | 84 s |
| two_boxers_two_years_test | 113 s | over 290 s, cut off |
| plan_bots_test | 10 s, 0 failures | 19 s, 2 failures |
| balance_harness_test | 5 s | 5 s |

## What would a human do?
Time one bout on each side, find the line that runs far too often, and stop it repeating the same work.

## Prefab check
None needed: Godot's own clock (Time.get_ticks_usec) is enough.

## The job
1. tests/fighter_model_speed_test.gd FIRST (prints `FIGHTER_SPEED failures=<n>`): simulate 200 seeded world bouts and 20 seeded live bouts between differing fighters. Print microseconds per bout for each, and the number of calls per bout to each function you suspect (attribute reads, AttrGen, move-level lookups, the migration from the old seven). The bar is a call-count bar, not a clock bar, because CI runners differ: attribute generation and migration must run at most once per fighter per bout, and no derived attribute may be recomputed per punch when its inputs have not changed.
2. Find what is called too often. Likely places, unproved: Attrs reading or migrating a fighter on every access; LEGACY summaries rebuilt each read; AttrGen giving world boxers move levels on every bout; Duels looking up mastery by string per punch. Measure before changing.
3. Fix it with a cache or by moving the work out of the loop. Every number the fight produces stays as it is: seeded results must match before and after, printed as one digest line per bout set.
4. Time the five tests above again on this branch and put the table in the PR body. Aim: within 1.3 x of main's column, and two_boxers_two_years_test under 150 s.
5. plan_bots_test: 2 checks fail here and passed on main. "the coach's best is about half of a well-read plan at most", and rule 4 reads weighed - lookup -0.005 against a target of +0.08. Say in the PR body which number moved and why. Do not change either bar: if the new attributes really change that answer, stop and report the numbers.

## Rules
Do not change the attribute list, any test bar, or how much any attribute does. No file over 500 lines. Headless, --audio-driver Dummy, never _console.exe. Nothing opens on the monitors.

## The one trap
Faster by changing what a fighter does is not faster. The seeded digest must be identical before and after each speed change.

## Result lines (PR body)
RESULT: tests/fighter_model_speed_test.gd -> FIGHTER_SPEED failures=0
