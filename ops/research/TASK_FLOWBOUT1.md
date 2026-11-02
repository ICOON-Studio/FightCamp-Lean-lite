# TASK FLOWBOUT1 - ARENA - every bout keeps its plan's results; the Playbook learns which plan lines win

Status: OPEN (S370, Claude). Seat: Arena (cloud, repo ICOON-Studio/FightCamp-Lean, branch from main).
Discipline: boxing (the demo).

## Why
Operator S369, on the fight result's THE PLAN, LIT UP map: "so the flow should be stored in the fighters profile ?" -
yes. Today each round's plan tally (which plan line - an "arrow" - was used in an exchange and whether that exchange was
won) lives only on the fight-night modal and is thrown away. Players of praised management games want every change to
carry its cause and a record they can learn from (S370 research, ops/research/S370_MENUS_RESEARCH.md).

## Read first (do not edit what is not in OWNS)
- scripts/rules/PlanFight.gd:164-178 `tally(exs)` -> {"used", "worked", "improvised", "moves": {move_id: [won, used]}}.
- scripts/state/LiveRound.gd:420-427: every closed round returns "arrows": PlanFight.tally(exs) and "plan": the arrows.
- scripts/state/BoutNight.gd:355-365: `c.results.push_front({...})` writes the finished bout (d, fid, who, opp, win, ...).
- tests/combo_odds_test.gd: the house style of a pure-module test (extends SceneTree, _check lines, quit code).

## The job
1. NEW scripts/rules/PlanRecord.gd (pure static functions, no state, no preload of UI; under 150 lines):
   - `summary(rounds: Array) -> Dictionary`: merges the rounds' "arrows" tallies into one bout record:
     {"plan": the LAST round's "plan" move ids in order, "used": int, "worked": int, "improvised": int,
     "lines": {move_id: [won, used]}}. Rounds without "arrows" are skipped; no rounds = {} (an empty dict).
   - `rates(results: Array, fid: String) -> Array`: across every result with that "fid" that has a non-empty "plan_rec",
     one row per move id: {"move", "won", "used", "bouts", "rate"} (rate = won / used, 0 when used is 0), sorted by
     used descending, then by move id.
   - `verdict(row: Dictionary) -> String`: "works" (rate >= 0.55 and used >= 6), "fails" (rate <= 0.35 and used >= 6),
     "too early" (used < 6), else "even".
2. scripts/state/BoutNight.gd:355-365 only: the result written by `c.results.push_front` gains
   `"plan_rec": PlanRecord.summary(rounds)` (`rounds` is that function's `m["rounds"]`), with the `const PlanRecord :=
   preload(...)` it needs at the top of BoutNight.gd. Nothing else in that file changes.
3. NEW tests/plan_record_test.gd: at least 8 checks - summary of two rounds adds the counts; the plan is the last
   round's; rounds with no "arrows" are skipped; empty rounds -> {}; rates only count the given fighter; rates sum across
   two bouts; the sort order; verdict at each threshold (5 vs 6 used, 0.35, 0.55). Print a final line
   `PLAN_RECORD failures=<n>` and quit(1) on any failure.
4. Do NOT edit tools/run_tests.sh (Claude adds the test to the suite when collecting).

## Acceptance (Claude checks on your PR)
- tests/plan_record_test.gd: PLAN_RECORD failures=0.
- golden_path_test, save_load_test, fight_flow_test still green (the result dict only gains a key).
- No script over 500 lines; no other file touched.

## Contract
OWNS: scripts/rules/PlanRecord.gd, scripts/state/BoutNight.gd:1-40, scripts/state/BoutNight.gd:355-365, tests/plan_record_test.gd
RED_TEST: tests/plan_record_test.gd -> PLAN_RECORD failures=0
REGRESSION: golden_path_test, save_load_test, fight_flow_test
VISUAL: no
