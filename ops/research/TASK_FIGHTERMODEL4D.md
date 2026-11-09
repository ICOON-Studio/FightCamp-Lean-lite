# TASK FIGHTERMODEL4D - CURSOR (Grok 4.7 High) - the fighter model fits inside the test limit

Status: OPEN (S409, Claude main). Discipline: boxing. Model: grok-4.7-high.
Start every Godot run through `python ops/Tools/godot_slot.py run --who cursor -- <godot cmd>`.
FIRST: merge origin/main into this branch.

## Contract
BASE: cursor/fightermodel4c
OWNS: scripts/rules/Attrs.gd, scripts/rules/AttrGen.gd, scripts/rules/Duels.gd, scripts/rules/BoutRead.gd, scripts/rules/Exchanges.gd, scripts/state/RingDuel.gd, scripts/state/LiveRound.gd, scripts/state/LiveRead.gd, scripts/world/WorldBout.gd, scripts/world/WorldSim.gd, scripts/world/WorldGen.gd, tests/fighter_model_speed_test.gd
RED_TEST: tests/fighter_model_speed_test.gd -> FIGHTER_SPEED failures=0
REGRESSION: fighter_model, world_years, plan_bots, golden_path_test, save_load
VISUAL: no

## Prior research
PR #113 (4C) cached the repeated reads and kept seeded results identical, but its CI's tests job still ran the full 18-minute limit and was cancelled; main's takes about 12. Merging it would stop main's tests from finishing. Your own table:

| test | main | 4C |
|---|---|---|
| world_years_test | 1 s | 6 s |
| golden_path_test | 33 s | 72 s |
| two_boxers_two_years_test | 113 s | 313 s |
| plan_bots_test | 10 s, 0 failures | 15 s, 2 failures |

4C's note: a world year still walks the duel matrix, about 1.3 ms a bout, and those pages also load 3D clips. Neither was measured apart.

## What would a human do?
Run the slow test once with a stopwatch on each part: how long the world bouts take, how long the live bouts take, how long the page loads take. Then fix the biggest part, not the first one you suspect.

## Prefab check
Time.get_ticks_usec is enough. No new library.

## The job
1. Print a breakdown for two_boxers_two_years_test and golden_path_test, on main and on this branch: total time in world bouts, live bouts, page and clip loading, everything else. Count of bouts of each kind. Put both tables in the PR body before changing anything.
2. Cut the biggest part. Bouts that involve neither of the player's fighters are the likely place: they may use a precomputed table or a cheaper read of the same attributes.
3. Seeded results: the player's bouts stay identical, printed as one digest line. World bouts between other fighters may change in the fine detail only if world_years_test and tests/balance_harness_test.gd stay green with their bars untouched, and the win share of the better fighter across 2,000 seeded world bouts moves by under 0.02 (print it for both).
4. Bars: two_boxers_two_years_test at most 150 s and golden_path_test at most 45 s on this PC, one at a time. The real bar is the CI's tests job finishing inside its limit. Read that job's duration after you push and put it in the PR body.
5. plan_bots_test's two failures: "your plan beats the coach's clearly" (0.425 against 0.375 + 0.05) and "the coach's best is about half of a well-read plan at most". Find which term in the new model narrowed the plan's lead over the coach and name it with numbers, the old value and the new. You may change that one constant only. Do not change either bar and do not change how much any attribute does. If one constant cannot do it, stop and report the numbers in the PR body.

## Rules
Do not change the attribute list or any test bar. No file over 500 lines. Headless, --audio-driver Dummy, never _console.exe. Nothing opens on the monitors.

## The one trap
Timing on a warm PC lies. Run each timed test alone, say what the watchdog read, and time main and this branch back to back.

## Result lines (PR body)
RESULT: tests/fighter_model_speed_test.gd -> FIGHTER_SPEED failures=0
