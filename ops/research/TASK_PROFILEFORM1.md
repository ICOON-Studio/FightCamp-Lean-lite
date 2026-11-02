# TASK PROFILEFORM1 - the profile's form badges and camp line (pure module + headless test)

Model: Qwen (qwen3-coder, --yolo). Tier: a new pure module + its own test only (parse gate + that one test).

## Why
The full fighter profile (PROFILE2B, Ludo round 37, approved by the operator: "approve all - build A then B then C") has a right column
with the LAST-5 FORM (W/L circles, newest first) and a CAMP line. The screen must show only data the game really holds (verdict:
"no invented numbers"). This module turns the game's own rows into what the screen prints. The screen is a later task.

## Prior research
`research/LUDO_ROUND37_S202_reply2a.txt` (right column), `research/LUDO_ROUND37_VERDICT_S202.md` (no invented numbers).
Input shapes, from `Godot/scripts/GameState.gd` (19,312 lines - never read it whole; `sed -n 15769,15807p` shows the row writer):
- `athlete["fight_history"]` is an Array, NEWEST FIRST, of rows like
  `{"week": 12, "result": "win"|"loss"|"draw"|"no_contest", "method": "KO"|"TKO"|"DECISION"|..., "opponent_name": "M. Ramos",
  "event": "Friday Fight Night", "amateur": false}` - any key may be missing on old saves.
- `GameState.get_camp_summary(id)` returns `{"has_camp": bool, "cold": bool, "weeks_done": int, "weeks_total": int, "readiness": float}`.

## What would a human do?
Football Manager's "Form" strip: five small coloured circles, newest on the LEFT, a tooltip with opponent + method. Missing data shows
nothing - never a grey "?" circle pretending to be a result.

## Prefab check
None needed - a list mapping. Use the house style of `Godot/scripts/rules/FighterReadout.gd` (static funcs, typed vars).

## Owned files (create both; edit nothing else)
- `Godot/scripts/rules/ProfileForm.gd` - `extends RefCounted`, `class_name ProfileForm`, static funcs only. PURE: no `preload`, no
  `load(`, no autoload, no GameState, no RNG, no Node, no file access. Never mutates its input (work on copies).
- `Godot/tests/profile_form_test.gd` - `extends SceneTree`; one `PASS <name>` / `FAIL <name>: <detail>` line per check, final line
  `PROFILEFORM total=<n> fails=<m>`; `quit(0)` only when fails == 0, else `quit(1)`.

## API (exact names)
1. `badge(row: Dictionary) -> Dictionary` - {} when `result` is missing or not one of the four; else
   {"letter": "W"|"L"|"D"|"NC", "color": "#22C55E"|"#EF4444"|"#64748B"|"#475569", "tip": text}. tip = "W vs M. Ramos - KO - week 12"
   built ONLY from keys that exist (no "vs" part without opponent_name, no "- week" part without week; method upper-cased).
2. `form(history: Array, count: int = 5) -> Array` - the first `count` VALID badges (rows whose badge is {} are skipped, not counted),
   newest first. Amateur rows (`amateur == true`) are skipped too: the pro form strip is pro only. count <= 0 -> [].
3. `streak(history: Array) -> Dictionary` - over the same valid pro rows, newest first: {"letter": "W"|"L"|"D", "count": n} for the run
   of identical results at the top; NC rows break nothing and count nothing (skip them); {} when there is no valid row.
4. `camp_line(camp: Dictionary) -> String` - "" when `has_camp` is false or `weeks_total` <= 0; "CAMP WK %d/%d" % [week, total] where
   week = clamp(weeks_done + 1, 1, weeks_total); "CAMP DONE" when weeks_done >= weeks_total; "COLD CAMP" (no week) when `cold` is true.

## Test checks (each its own PASS/FAIL line)
- badge for each of the four results; unknown result "bye" -> {}; missing result -> {}.
- tip uses only present keys: a row with result only -> tip "W" exactly; with opponent + method -> "W vs M. Ramos - KO".
- form: 7 valid rows -> 5 badges in the input order; a list with 2 invalid rows among 6 -> the 5 valid ones are returned and the
  invalid rows are not counted; amateur rows skipped; count 0 -> [].
- streak: [win, win, loss] -> W x2; [no_contest, loss, loss, win] -> L x2; [] -> {}.
- camp_line: no camp -> ""; weeks_done 4 of 8 -> "CAMP WK 5/8"; 8 of 8 -> "CAMP DONE"; cold -> "COLD CAMP"; weeks_total 0 -> "".
- purity (input): the history Array equals a `duplicate(true)` copy taken before each call.
- purity (source): read `res://scripts/rules/ProfileForm.gd` as text and FAIL if it contains `preload`, `load(`, `GameState`, `randf`,
  `randi` or `RandomNumberGenerator`.
- CAN READ WORSE: inside the test, a deliberately broken `form` (one that counts invalid rows) must fail the "invalid rows not counted"
  check - assert the check returns false for it.

## Gates and the one test
- Parse: `python Godot/tools/check_scripts.py Godot/scripts/rules/ProfileForm.gd Godot/tests/profile_form_test.gd`
- Test: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/profile_form_test.gd`
  (never the `_console.exe`). Pass = `PROFILEFORM total=<n> fails=0`, exit 0, and no `SCRIPT ERROR` line.

## The one trap
`var x := <call>` fails to parse when the call returns Variant - type it (`var n: int = ...`). A variable name reused inside one
function is a parse error even across blocks. Never delete or weaken a check to go green.
