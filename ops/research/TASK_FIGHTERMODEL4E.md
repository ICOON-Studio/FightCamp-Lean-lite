# TASK FIGHTERMODEL4E - CURSOR (Grok 4.7 High) - the plan must beat the coach again on the new fighter model

Status: OPEN (S410, Claude main). Discipline: boxing. Model: grok-4.7-high.
Start every Godot run through `python ops/Tools/godot_slot.py run --who cursor -- <godot cmd>`.
FIRST: merge origin/main into this branch.

## Contract
BASE: cursor/fightermodel4d
OWNS: scripts/rules/Attrs.gd, scripts/rules/AttrGen.gd, scripts/rules/Duels.gd, scripts/rules/BoutRead.gd, scripts/rules/Exchanges.gd, scripts/state/RingDuel.gd, scripts/state/LiveRound.gd, scripts/state/LiveRead.gd, scripts/world/WorldBout.gd, scripts/world/WorldSim.gd, scripts/world/WorldGen.gd, tests/fighter_model_speed_test.gd
RED_TEST: tests/plan_bots_test.gd -> PLAN_BOTS checks=26 failures=0
REGRESSION: fighter_model, fighter_model_speed, world_years, golden_path_test, save_load
VISUAL: no

## Prior research
ops/research/TASK_FIGHTERMODEL4D.md, item 5, was not done. PR 117 (4D) made one speed change (the fight page's read of a fighter uses the world's one-step ladder and is kept while the stats stay on the same point). Its own regression still prints PLAN_BOTS checks=26 failures=2: "your plan beats the coach's clearly" (0.425 against 0.375 + 0.05) and "the coach's best is about half of a well-read plan at most". main passes both.
The player's game plan is one of the game's three core mechanics, so this is the fault that matters most in the branch.

## What would a human do?
Change one thing at a time between main's model and this one, and watch which change takes the plan's lead away.

## Prefab check
tests/plan_bots_test.gd already measures the lead. tools/fighter_bars.gd and tools/round_reports.gd print the model's bars. No new library.

## The job
1. Print the plan's lead over the coach, the two numbers the test compares, on main and on this branch, same seeds, back to back. Put both in the PR body.
2. Find the term that narrowed it: switch each new term of the model off or back to main's value, one at a time, and print the lead after each. A table, one row per term. Name the term with the row that shows it.
3. Fix that term so the two checks pass. The test's bars do not move. Seeded results of the player's bouts may change only through this term: say so in the PR body.
4. Keep 4D's speed: two_boxers_two_years_test at most 150 s and golden_path_test at most 45 s on this PC, each run alone, with what the watchdog read. Read the CI tests job's duration after you push and put it in the PR body, against its 18-minute limit. If it does not finish inside the limit, say so first in the body.

## Rules
Do not change the attribute list or any test bar. No file over 500 lines. Godot headless with --audio-driver Dummy, the plain windows build only. Nothing opens on the monitors.

## The one trap
A win share over a handful of seeds moves by chance. Print how many bouts each number rests on, and do not call a term the cause on a difference smaller than the noise you measure between two seed sets.

## Result lines (PR body)
RESULT: tests/plan_bots_test.gd -> PLAN_BOTS checks=26 failures=0
