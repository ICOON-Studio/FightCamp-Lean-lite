# TASK SPLIT500C - GymSpend.gd under the 500-line rule with room to grow (pure move, no behaviour change)

Status: OPEN (S525, Claude main). Discipline: boxing (structure). Model: Qwen (PC, headless).
Why: scripts/state/GymSpend.gd is at 492 lines (S525 added the paying class nights); the next feature that touches the
week's money would have to split it mid-task. CLAUDE.md item 5: no script over 500 lines.

## What to do
Move the pro-talk and grant block - `pro_camp`, `check_talks`, `answer_talks`, `year_take`, `grant_bid`, `grant_day`
(today GymSpend.gd lines ~364-455, with the doc comments above each and any constant only they use) - into a NEW file
`scripts/state/GymDeals.gd` (extends RefCounted, static funcs, its own preloads). Update every caller to GymDeals:
scripts/state/Bouts.gd, scripts/ui/GymActs.gd, tests/gym_spend_test.gd, and any call INSIDE GymSpend.gd itself (e.g.
day_events / end_week) - grep `pro_camp|check_talks|answer_talks|year_take|grant_bid|grant_day` over scripts/ tests/ tools/
and fix every hit. Do not leave forwarding stubs. Do not change one line of logic, a number or a string.
Watch the preload cycle: if GymDeals needs GymSpend (e.g. member_cap), preload it in GymDeals; GymSpend may preload
GymDeals only if GymDeals does NOT preload GymSpend - pick one direction and say which in the PR body.

## Contract
OWNS: scripts/state/GymSpend.gd, scripts/state/GymDeals.gd, scripts/state/Bouts.gd, scripts/ui/GymActs.gd, tests/gym_spend_test.gd
RED_TEST: tests/gym_spend_test.gd -> GYM_SPEND failures=0
REGRESSION: gym_bills_test, class_nights_test, club_week_walk_test, golden_path_test, two_boxers_two_years_test, money_close_test
VISUAL: no
NOT YOURS: every other file. GymSpend.gd must end under 420 lines, GymDeals.gd under 200. PR body: the line counts before
and after, `RESULT: tests/<x>_test.gd -> <pass line>` for the red test and every regression test.

## Prior research
`python ops/Tools/prior_research.py split 500` -> TASK_SPLIT500.md / TASK_SPLIT500B.md (how earlier splits were done).

## What would a human do?
Cut along a seam the file already has (the talks and grants block), move it whole, fix the callers, change nothing else.

## Prefab check
None: a refactor.

## The one trap
A call inside GymSpend to a moved function (end_week / day_events) left pointing at GymSpend - parse passes, the week
then crashes at run time. Run golden_path and two_boxers_two_years, which play the weeks.
