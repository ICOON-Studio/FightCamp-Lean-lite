# TASK R26SWAP1 - QWEN (qwen3-coder) - the corner minute's line change: the line that lost most, and two rated lines to swap in (one pure module + its test)

Status: OPEN (S440, Claude main). Discipline: boxing. Model: qwen3-coder.
Mechanic: R26 "Corner minute: three fixes, time for two" (critics 8/9 and 7/8, average 8.0, ops/research/MECHANICS_BUILD_STATE_S440.md).
Source: ops/research/PLAYBOOK_MAP_S432.md section 4.10 (line 225: READ IT, with 4.1 and section 5's worth sum) and
CORE_LOOP_MAP_S432.md C26 (the minute's order: "the line change (the line that lost most and two rated replacements)"). The
Playbook map passed two critics at 7 and 7. Today the minute offers a bare dropdown of every other move on every card
(PlanFight.corner_options, used by scripts/ui/CornerJobsRow.gd line 41), with nothing to say which line failed or what would do better.
THIS task is only the pure rule module: no screen (CornerJobsRow is Claude's, later), no IF READ note (R25 is off until ADAPT1).

## Contract
OWNS: scripts/rules/LineSwap.gd, tests/line_swap_test.gd
RED_TEST: tests/line_swap_test.gd -> LINE_SWAP failures=0
REGRESSION: plan_fight_test, plan_lines_test, corner_jobs_test, file_limits_test
VISUAL: no
NOT YOURS: every other file (tools/run_tests.sh too). Read, never edit: scripts/rules/PlanFight.gd (244 lines: fit 83, can_do 93, rate 114,
value 122, card_mean 130, tally 164, corner_change 183, corner_options 193, fought_cards 219), scripts/rules/StrikeMap.gd (123: MOVES,
outs, move), scripts/rules/PlanLines.gd (177: FIT_WORDS line 23, PLACE_WORDS 20), scripts/ui/CornerJobsRow.gd (245: lines 30-44 show
what the minute already has: arrows, limit, f["moves"] as mastery, f["combos"]), scripts/state/LiveRound.gd (456: the exchange record
345-372: arrow, planned, won, at, sit, psit).

## The job: scripts/rules/LineSwap.gd (pure, static, under 220 lines; preloads PlanFight, StrikeMap, PlanLines)
1. `lost_most(exs) -> Dictionary` {move, at, won, thrown, lost, tally}: over the bout's exchange records so far, the PLANNED line
   (planned true, arrow non-empty) with the most exchanges lost (thrown - won); ties: the lower win share, then the more thrown, then
   the earlier in the plan. tally = "<move name> <won> of <thrown>" (StrikeMap move name). {} when no planned line lost an exchange.
2. `shown_game(round_exs) -> String`: the situation the opponent showed most in the round just gone (the record's `psit`, the plan
   situation PlanFight rates against: read LiveRound line 359-360 and say in the PR body which key you read); ties: the later one.
3. `options(plan, lost, sit, mastery, combos, limit, grade := {}) -> Array` of at most 2 {move, name, fit, fit_words, worth,
   was_worth, i}: the other moves out of the lost line's card that this boxer can throw (PlanFight.can_do), each a change the plan
   accepts (PlanFight.corner_change(plan, i, move, limit) != plan), rated
   worth = PlanFight.value(move, sit, PlanFight.rate(move, combos)) x g - PlanFight.card_mean(at, sit, mastery, combos),
   where g = float(grade.get(move, 1.0)) (the hook for LineGrade later; empty today); was_worth the same sum for the lost line. Only
   options worth MORE than the lost line, best first; [] when none.
4. `row(plan, bout_exs, round_exs, mastery, combos, limit) -> Dictionary` {lost, game, game_words, options}: what the minute shows,
   or {} when no planned line lost (the minute then shows nothing for the line change).
5. `apply(plan, option, limit) -> Array`: PlanFight.corner_change(plan, option.i, option.move, limit) (one click; refused changes
   return the plan unchanged, exactly as corner_change does).

## The test FIRST: tests/line_swap_test.gd (extends SceneTree, prints `LINE_SWAP failures=N`, quits with N)
RED ON MAIN: run it on main first: the preload of the missing LineSwap.gd fails to load. Say so in the PR body. Use two DIFFERENT
boxers' punch mastery (`moves`) and `combos`, shaped as the game stores them (Data.lucy() has none yet: read tests/plan_fight_test.gd
and tests/plan_lines_test.gd for how they build these dictionaries, and Combos.LEARN_AT for the line a combination needs), and
hand-built exchange records with the keys LiveRound writes. Assert at least:
- a plan with three lines where "1-2-3" (long range) lost 3 of 4 and "step_back" lost 1 of 3: lost_most is "1-2-3" with tally
  "One-two-hook 1 of 4"; a tie on losses goes to the lower win share;
- against "counter" (where PlanFight.ANSWERS has 1-2-3 as wrong), the options are moves out of "long", at most 2, best worth first,
  every one worth more than the lost line, every worth equal to the sum above computed IN THE TEST from PlanFight's functions;
- a move the boxer cannot throw yet (PlanFight.can_do false for that mastery) is never offered; the boxer with more mastery gets at
  least as many options;
- a change past the coach's limit or onto a place already held is never offered (corner_change refuses it);
- the grade hook: grade = {"1-1": 0.35} lowers that option's worth exactly by the factor, and can drop it below the lost line;
- no planned line lost -> row() is {}; apply() equals corner_change on the same arguments;
- shown_game returns the most frequent situation of the round, the later one on a tie;
- no pronoun in tally or game_words;
- MUTANTS inside the test: a copy of lost_most that counts thrown instead of lost, and a copy of options that keeps options worth
  less than the lost line, must each FAIL the same asserts; print `MUTANT caught` for each.

## Traps
- ops/research/GDSCRIPT_TRAPS.md first (typed Dictionary reads, no `:=` on a Variant).
- The one trap: corner_options already exists and the minute uses it. Do not edit it or CornerJobsRow; LineSwap is the new source
  the screen will read, built on PlanFight's own rules so a line rated here is rated exactly as the bout plays it.
- Words: "Coach", never a surname; no pronoun in a built string. Do NOT delete or weaken any existing test.
- Write the PR body last, from the final run.

## Prior research
`python ops/Tools/prior_research.py corner change line` -> topics/plans_corner.md (what a corner changes between rounds), PLAYBOOK_MAP_S432.md
4.10 and 4.1, J55_THE_CORNER_BETWEEN_ROUNDS.md (one instruction, said plainly, in the minute).

## What would a human do?
Between rounds the trainer says one thing: "the hook isn't there, he's waiting for it: double jab and get out". He names what failed,
with what the opponent showed, and gives the boxer the one replacement that works.

## Prefab check
None: a ranking over PlanFight's own rules and the round's records.

Test command: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tests/line_swap_test.gd`
(the plain win64 exe, never the console one). Parse first: `--check-only` on both files.
RESULT lines for the PR body: `RESULT: tests/line_swap_test.gd -> LINE_SWAP failures=0`.
