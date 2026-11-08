# TASK SPLIT500 - QWEN (qwen3-coder) - make room in the two files at the 500-line limit

Status: OPEN (S405, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: CLAUDE.md rule 5, no script over 500 lines. scripts/ui/Main.gd is 504 lines. scripts/state/LiveRound.gd is 499, so no further reason row (R11) can be added to it.

## Contract
OWNS: scripts/ui/Main.gd, scripts/ui/MainFlow.gd, scripts/state/LiveRound.gd, scripts/state/LiveRoundAfter.gd, tests/file_limits_test.gd
RED_TEST: tests/file_limits_test.gd -> FILE_LIMITS failures=0
REGRESSION: exchanges_test, fight_flow_test, clinch_rest_test, clinch_why_test, fight_why_test, first_week_test, first_hour_walk_test, golden_path_test, save_load_test, plain_words_test, no_pronoun_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py split refactor main`. Read ops/research/GDSCRIPT_TRAPS.md before writing GDScript (autoload order, reused names).

## What would a human do?
Lift one coherent block out of each file into a new file, change no behaviour, and prove it with the tests that already play the game.

## Prefab check
None needed.

## The job
1. scripts/ui/Main.gd must end at 470 lines or fewer. Move one coherent group of functions to a new scripts/ui/MainFlow.gd as static functions taking `main: Node`. Keep the public names on Main that other scripts and tests call, as one-line forwards.
2. scripts/state/LiveRound.gd must end at 470 lines or fewer. Move the end-of-exchange bookkeeping (the part of `exchange` after the plan tally: pace cost, hurt, next mode) to a new scripts/state/LiveRoundAfter.gd as a static function, called once from `exchange`.
3. Change no number, no text, and the ORDER of every rng call. One rng call moved or added shifts every later roll in a career, and golden_path and save_load go red for no visible reason.

## Do
1. tests/file_limits_test.gd FIRST (prints `FILE_LIMITS failures=<n>`). It reads each script under scripts/ and fails for any over 500 lines, and also fails Main.gd or LiveRound.gd over 470. Run it on main: it must fail. scripts/ui/WeekCards.gd is 543 lines and is split by another task: list it in the test as the one known exception, with that reason in a comment.
2. Make it pass inside OWNS.
3. Run REGRESSION. Do not change any number or threshold in an existing test. If one goes red, stop and put what you measured in the PR body.

## Rules for this seat
Godot only through godot_slot, headless, `--audio-driver Dummy`. Parse check before any test. No screens opened. Nothing outside OWNS. PR body: `RESULT: tests/file_limits_test.gd -> FILE_LIMITS failures=0`, plus one RESULT line per REGRESSION test.

## The one trap
`exchange` uses local variables from earlier in the function (`rng`, `lv`, `rec`, `s`, `vals`, `opp`). Pass them as arguments, and do not copy a Dictionary that is meant to be changed in place.
