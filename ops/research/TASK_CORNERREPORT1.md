# TASK CORNERREPORT1 (S226) - the result screen's CORNER tab numbers (pure module + blind contract test)

Model: Arena (cloud). Own branch `arena/<chat-id>-fightcamp` and PR; never master, never the Merge button. Everything sent is PUBLIC.
Approved build (operator Q-S221-5 "Approve, build it", LUDO_ROUND63_VERDICT_S224.md G item 4): "Result screen: a CORNER tab -
bleeding stopped, stamina won back on the stool, calls that won rounds, cutman grade." This task is the PURE half: the numbers.
(The screen tab and the seeded call-effect measurement are later, on other seats.)

## Write
1. `Godot/scripts/CornerReport.gd` - `extends RefCounted`, NO class_name, only `const CornerPitStop := preload("res://scripts/CornerPitStop.gd")`
   allowed (pure, no engine, no RNG). One entry point:
   `static func build(minutes: Array) -> Dictionary`
   Each item of `minutes` is one corner minute: `{"round": int, "apply": <the Dictionary CornerPitStop.apply() returned>,
   "after": <fighter Dictionary after the minute>, "stamina_before": float, "stamina_after": float, "call": String (the chief's
   instruction id, "" if none), "next_round_won": bool}`. Missing keys = safe defaults; a non-Dictionary item is skipped.
   Returns:
   - `bleeding_stopped`: int - over all minutes, entries of `CornerPitStop.payoff(apply.before, after)` whose id contains "cut"
     (or "blood"/"bleed") with verdict "eased".
   - `stamina_won_back`: float - sum of max(0, stamina_after - stamina_before), rounded to 1 decimal.
   - `calls_that_won`: Array of `{"round": int, "call": String}` for minutes with a non-empty call and next_round_won true, in round order.
   - `cutman_jobs`: int (applied ids across minutes), `cutman_mistakes`: int (mistakes across minutes; a refused minute counts 0 jobs).
   - `cutman_grade`: String "A".."F": no jobs -> "-"; else ratio = mistakes / (jobs + mistakes): <= 0.05 "A", <= 0.12 "B", <= 0.2 "C",
     <= 0.3 "D", <= 0.45 "E", else "F"; any `apply.events` id "emphysema" drops the grade one letter (F stays F).
   - `minutes`: int (items used).
2. `Godot/tests/corner_report_test.gd` - `extends SceneTree`, prints `PASS:`/`FAIL:` lines and a final `CORNER_REPORT PASS checks=N`
   or `CORNER_REPORT FAIL ...`, `quit(0|1)`. BLIND: written from THIS contract, not from your implementation. Build the fighter
   dictionaries with `CornerPitStop` shapes only (`body_condition` regions, `trauma` sites) - no assets, no autoloads, no LFS.
   Cover: empty input; non-Dictionary items skipped; a cut that eases counts; one that holds/worsens does not; stamina never negative;
   calls only when won and non-empty, in round order; every grade boundary (exactly 0.05, 0.12, 0.2, 0.3, 0.45) and the emphysema
   drop (incl. F stays F); refused minute = 0 jobs; >= 20 checks.
   Prove it with mutants in your report: flip one comparison, drop the emphysema rule, count "held" as stopped - each must turn the
   test red.

## Gate (CI, no LFS)
`godot --headless --path Godot --script tests/corner_report_test.gd` -> exit 0 AND the `CORNER_REPORT PASS` line. Do NOT delete,
skip or weaken any test to go green; do not touch other files.

## Prior research
LUDO_ROUND63_VERDICT_S224.md (E, F, G), CornerPitStop.gd (apply / payoff / problems), CAMPPAY1 (measured-effect style).

## What would a human do?
A designer reads the corner's own log after the fight and counts what the corner actually did - nothing invented.

## Prefab check
Nothing to import: it reads CornerPitStop's own records.

## The one trap
`payoff()` compares bands by id; a cut that disappears from `problems()` reads as "fine" -> "eased". That IS a stopped bleed - count it.
