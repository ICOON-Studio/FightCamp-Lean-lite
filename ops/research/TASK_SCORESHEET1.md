# TASK SCORESHEET1 - the official scorecard sheet as data (pure rule module)

Status: OPEN (S503, Claude main). Discipline: boxing. Model: Qwen (qwen3-coder), default.

## Why now
The operator (S503, showing a real promotion's official scorecard): "add similar score cards at the end of the fight".
Claude's answer: a Scorecard tab on the result page laid out like an official sheet - a header (date, venue, weight
class, referee, bout number), three judge sheets (red corner left, blue right: round score, point deduction, round,
point deduction, round score; the totals; the judge's name and lean), a result line. The judges already score every
round (`scripts/rules/Judges.gd` `cards()`, kept on `m["judges"]` by `scripts/state/JudgeNight.gd`). This task builds the
SHEET AS DATA only: one pure function the screen will read. No UI, no wiring - Claude does those after the mockup.

## What to build
1. `scripts/rules/ScoreSheet.gd` - `extends RefCounted`, pure static, ZERO preloads (pass everything in).
   `static func build(j: Dictionary, meta: Dictionary) -> Dictionary`
   - `j` is `Judges.cards()` output: `{cards [[a, b] x3], by_round [[{a, b, reason, part} x3] per round], running,
     verdict "unanimous"|"split"|"majority"|"draw", winner "a"|"b"|""}`. `a` = the player's boxer, `b` = the opponent.
     Read `scripts/rules/Judges.gd` lines 195-260 for the exact shape before writing.
   - `meta`: `{a_corner "red"|"blue", date String, venue String, weight_class String, referee String, bout_no int,
     rounds_scheduled int, stopped bool, stop_round int, stop_time String ("2:14"), stop_winner "a"|"b"|"",
     judge_seed int, leans Array[String] (3 lean words, e.g. "Clean punches"), deductions Array (optional, per round
     [[a_pts, b_pts], ...]; missing = all zero)}`.
   - Returns `{header {date, venue, weight_class, referee, bout_no, rounds_scheduled}, judges [3 x {name, lean,
     rows [{round, red, blue, red_ded, blue_ded}], total_red, total_blue, card_winner "red"|"blue"|"even"}],
     result {kind "decision"|"stoppage"|"draw", words String, winner "red"|"blue"|""}}`.
   - RED is the red corner whoever it is: when `a_corner == "blue"`, the player's scores go in the BLUE column.
   - A round's score subtracts that corner's deduction (10 with a 1-point deduction shows 9 in the round score and 1 in
     the deduction column); totals sum the shown round scores.
   - A stopped bout: rows only up to and including `stop_round` (the stoppage round is scored as far as the cards have
     it; if `by_round` has fewer rounds, rows stop there); `result.kind = "stoppage"`, words
     `"Winner by stoppage, round %d (%s)"`. Decisions: `"Winner by unanimous decision"`, `"... split decision"`,
     `"... majority decision"`; a draw: kind "draw", words `"Draw"` plus `" (split)"` / `" (majority)"` when the cards
     are not all level. NO NAMES in any words (operator S448: names only in headers) - the screen puts the winner's
     name in the header line.
   - Judge names: three DIFFERENT fictional names drawn from a small built-in list (at least 20 first + 20 last names,
     mixed sexes, UK club boxing flavour, no real officials) with a `RandomNumberGenerator` seeded by `judge_seed` - the
     same seed always gives the same panel.
   - Empty or malformed `j` (no `by_round`): return `{}`.
2. `tests/score_sheet_test.gd` (`extends SceneTree`, prints `SCORE_SHEET failures=<n>`, quits 1 on failure). Hand-built
   `j` dictionaries, at least: a unanimous 30-27 (a red), the SAME bout with `a_corner "blue"` (columns swap), a split
   29-28 / 28-29 / 29-28, a 10-8 knockdown round, a deduction round (10 -> 9, ded 1, totals follow), a stoppage in
   round 2 of 3 (two rows, kind stoppage, words with the round and time), a draw (all 28-28 -> "Draw"; 29-28/28-29/28-28
   -> "Draw (split)"), the judge names (three different; seed 7 twice -> same; seed 8 -> a different panel), `{}` in ->
   `{}` out, and a check that no `words` string contains either boxer's name (pass names in meta-less tests as
   "Lucy Jackson" / "Priya Nair" through a fake `reason` and confirm they never reach `result.words`).

## Contract
OWNS: scripts/rules/ScoreSheet.gd, tests/score_sheet_test.gd
RED_TEST: tests/score_sheet_test.gd -> SCORE_SHEET failures=0
REGRESSION: judges_test, file_limits_test
VISUAL: no - a pure rule; Claude builds the Scorecard tab after the operator's yes on a mockup.
NOT YOURS: every other file. Never delete or weaken a test. Work on your own branch, open a PR into main, never merge.
Each file stays under 500 lines (aim for under 250).
Run one test: `godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd` (Godot 4.7.2).
Never `tools/run_tests.sh`. Never run Godot windowed. Nothing may open on the owner's monitors.
PR body: `RESULT: tests/score_sheet_test.gd -> SCORE_SHEET failures=0`, `RESULT: tests/judges_test.gd -> JUDGES ...`,
`RESULT: tests/file_limits_test.gd -> FILE_LIMITS ...` (file_limits is red on main today for GamePlan.gd and MatTree.gd
at 501 lines - not yours; say so, do not touch them).

## Prior research
`scripts/rules/Judges.gd` (the cards and their shape), `scripts/state/JudgeNight.gd` (`verdict_words`, how the cards sit
on `m["judges"]`), `scripts/ui/JudgeCards.gd` (today's judge block on the result page), `docs/JUDGES1_RESULT.md`.
`ops/research/GDSCRIPT_TRAPS.md` before writing GDScript (Variant `:=`, `%%`, reused names).

## What would a human do?
A boxing official fills the same paper sheet every bout: each judge's round scores per corner, deductions in their own
column, totals, the judge signs, the referee and venue on top, the result written at the bottom. Build that sheet.

## Prefab check
None: a dictionary transform; no library.

## The one trap
Red and blue are CORNERS, not "us" and "them": the player's boxer can be in either. Every check that passes with
`a_corner "red"` must be repeated with `a_corner "blue"` and the columns must swap.
