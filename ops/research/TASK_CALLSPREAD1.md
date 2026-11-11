# TASK CALLSPREAD1 - QWEN (qwen3-coder) - a corner call's strength rises point by point from 56 to 62, not in one jump at 62 (one function + its test)

Status: OPEN (S434, Claude main). Discipline: boxing. Model: qwen3-coder.
DISPATCH AFTER the S434 foundation branch (claude/foundation-s433: CARDIO1, NOCAMP1, PUNCHSTART1) is on main: both move the fight
balance tests (exchanges_test, fight_why_test); one change at a time.
Source: `ops/research/TRAINING_MAP_S432.md` section 0 row F10 CALLSPREAD1 (line ~43) and the Calls row (~115); CORE_LOOP_MAP_S432.md
section 5 STEP 0 row F15. Read both rows.

## Contract
OWNS: scripts/rules/Exchanges.gd (grade() only, lines 188-197 today; the file is 372 lines), tests/call_spread_test.gd (NEW)
RED_TEST: tests/call_spread_test.gd -> CALL_SPREAD checks=6 failures=0
REGRESSION: exchanges_test, call_evidence_test, stripe_call_test, fight_why_test, plan_bots_test, bout_read_test, fight_feel_test
VISUAL: no

## The defect (read in today's code, S434)
`Exchanges.grade(call, vals)` (scripts/rules/Exchanges.gd:188) takes the mean of the values the call needs and returns a WORD and a
MULT: Good (x1.0) from GOOD_AT 62, OK (x0.6) from OK_AT 50, else Poor (x0.3) (constants at lines 24-26). So a fighter at a mean of
61.9 gets the same 0.6 as one at 50, and one point more doubles nothing then jumps to 1.0. Training a call's stats from 56 to 61 buys
nothing on the night; the point at 62 buys everything. The map's fix: spread the OK-to-Good step across 56 to 62.

## The job
1. In grade(): keep `word` exactly as today (Good from 62, OK from 50, else Poor: the corner's buttons and CallButtons read the word;
   `COMMIT[word]` in call_edge reads it too). Change only `mult`:
   - mean < OK_AT (50): 0.3 (as today)
   - OK_AT <= mean < SPREAD_FROM: 0.6 (as today)
   - SPREAD_FROM <= mean < GOOD_AT: 0.6 + 0.4 x (mean - SPREAD_FROM) / (GOOD_AT - SPREAD_FROM)
   - mean >= GOOD_AT: 1.0
   with a new constant `const SPREAD_FROM := 56.0` beside GOOD_AT and a one-line comment naming CALLSPREAD1 (TRAINING_MAP F10).
   Read the step sizes from GRADE ("OK" 0.6, "Good" 1.0), never type 0.6 / 1.0 inside the formula.
2. Nothing else in Exchanges.gd changes. No other file changes except the new test.

## The checks (tests/call_spread_test.gd; extends SceneTree; copy the shape of tests/stand_down_test.gd: `_check(ok, what)` prints
PASS/FAIL, counts checks and failures, last line `CALL_SPREAD checks=%d failures=%d`, `quit(1 if failures > 0 else 0)`)
Use a call from Exchanges.CALLS with two needs (read its "needs" at run time; do not hard-code the call's stats) and set both values
to the mean you want.
a. mean 55.9: mult 0.6, word OK.
b. mean 59.0: mult 0.8 (within 0.001), word OK.   <- RED on main (main gives 0.6)
c. mean 61.0: mult within 0.001 of 0.6 + 0.4 x 5/6, word OK.   <- RED on main
d. mean 62.0: mult 1.0, word Good.
e. mean 49.0: mult 0.3, word Poor.
f. monotone: from mean 50 to 65 in steps of 0.5, mult never falls and never rises by more than 0.4 / 6 x 0.5 + 0.001 in one step
   (no jump left).   <- RED on main (the jump at 62)
Run it BEFORE you change grade() and paste the FAIL lines (b, c and f fail on main), then after.

## Prior research
`python ops/Tools/prior_research.py "call grade" exchanges corner`: TRAINING_MAP_S432.md F10 and the Calls row; FIGHT_LINK_MAP_S432.md
(the corner's calls); the S318 call evidence work (tests/call_evidence_test.gd).

## What would a human do?
A coach's call works a little better for every bit of the skill the fighter has: a fighter who is nearly good at slipping and
countering does it nearly well, not as badly as a beginner until the day it suddenly works.

## Prefab check
None: one formula in our own rule.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script <script>`
(`<godot.exe>` = %LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe). Parse first with `--check-only --script res://<file>`.
No file over 500 lines. Do not add the test to tools/run_tests.sh. Keep grade()'s signature and its returned keys.
GDScript traps (ops/research/GDSCRIPT_TRAPS.md): type a value read from a Dictionary (`var m: float = float(g["mult"])`); `%` in a
format string is `%%`; one variable name per function.
THE REGRESSIONS: the balance tests will move a little (a call at a 56-62 mean now gives more). Run each REGRESSION test before and after
and paste both pass lines. NEVER change a bar, a seed or a sample size in another test to make it pass: if one goes red, stop, leave it
red and report its before and after numbers in the PR body (Claude decides).

## Result lines (PR body)
RESULT: tests/call_spread_test.gd -> CALL_SPREAD checks=6 failures=0 (and the FAIL lines it read on main)
RESULT: tests/<each REGRESSION test>.gd -> <its pass line before> / <after>
