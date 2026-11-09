# TASK FIGHTERMODEL4F - CURSOR (Grok 4.7 High) - the nine red tests the new fighter model leaves behind

Status: OPEN (S411, Claude main). Discipline: boxing. Model: grok-4.7-high.
Start every Godot run through `python ops/Tools/godot_slot.py run --who cursor -- <godot cmd>`.
FIRST: merge origin/main into this branch.

## Contract
BASE: cursor/fightermodel4e
OWNS: scripts/rules/Attrs.gd, scripts/rules/AttrGen.gd, scripts/rules/Duels.gd, scripts/rules/BoutRead.gd, scripts/rules/Exchanges.gd, scripts/state/RingDuel.gd, scripts/state/LiveRound.gd, scripts/state/LiveRead.gd, scripts/world/WorldBout.gd, scripts/world/WorldSim.gd, scripts/world/WorldGen.gd, tests/fighter_model_speed_test.gd, tests/exchanges_test.gd, tests/habit_fix_test.gd, tests/fighter_profile_test.gd, tests/grey_reason_test.gd, tests/week_actual_test.gd, tests/week_twist_test.gd, tests/camp_cards_test.gd, tests/camp_protocol_test.gd, tests/fight_why_test.gd, tests/week_read_test.gd
RED_TEST: tests/exchanges_test.gd -> EXCHANGES failures=0
REGRESSION: plan_bots_test, bout_read_test, world_years_test, golden_path_test, save_load_test
VISUAL: no

## Prior research
ops/research/TASK_FIGHTERMODEL4E.md and its PR 119 body (the form spread, why the plan's lead moved). CI run 42598121108 is the first run on this model that finished: main is fully green, in 11 minutes, and this branch took 16.5. Before it, every run on the model was cancelled at the time limit, so these reds were never seen. tools/run_tests.sh now prints `TIME <s> s <test>` as each test ends.

## What would a human do?
Take the list of what broke, sort it into "the game changed" and "the check is reading an old name", and fix them in that order.

## Prefab check
None needed.

## The reds, from the CI log
- exchanges_test: "wrong calls lose clearly more"; "always picking her best-graded call is no better than silence; reading wins"
- habit_fix_test: "fixing the punished habit wins more than the read alone"
- fighter_profile_test: "different fighters give different footwork"
- grey_reason_test, week_actual_test ("week 1 run as planned: the stats land on the plan, the reason says so"), week_twist_test ("a short-notice win reached in 40 nights"), camp_cards_test, camp_protocol_test, fight_why_test, week_read_test.
matchmaking_bots_test is also red. That one is FIGHTERMODEL4B's: leave it.

## The rule
1. Read each failure's first line and classify it in the PR body: GAME (the model really changed what the check protects) or READ (the check or screen reads a name or path that moved).
2. READ: fix what reads the old name. The check keeps its meaning and its numbers.
3. GAME: fix the model so the check passes as written. The first three are the corner mattering: a wrong call must cost, and fixing a habit must pay. The narrower form spread cannot be undone (`FORM_SD` stays 5, plan_bots stays green).
4. Change no number or threshold in an existing test. If a GAME check truly cannot hold on the agreed 10 attributes, leave it red and write why, with the measured numbers: Claude decides.
5. The tests job stays well inside its limit: name any test that got slower than main by over 60 s (matchmaking_bots_test 316 s v 122, bout_read_test 280 v 135 in that run) and take the repeated work out of the top two.

## Result lines (PR body)
RESULT: tests/exchanges_test.gd -> EXCHANGES failures=0
RESULT: one line per red test above: GAME or READ, and what changed
RESULT: CI tests job duration

The branch's own fighter_model_test, fighter_model_speed_test and fighter_model_bars_test stay green too (they are not on main, so the contract cannot name them).

## The one trap
BoutRead must stay in step with the real bout (tests/bout_read_test.gd, within 0.06). A change to how calls or habits land moves the shown odds too.
