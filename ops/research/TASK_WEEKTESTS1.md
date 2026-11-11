# TASK WEEKTESTS1 - CURSOR - three tests still drive the old Training board that TRAININGB1 replaced

Status: OPEN (2026-11-11, nightly review). Discipline: boxing. Model: Cursor default.
Source: nightly 2026-11-11, 3 of 5 reds. Commit a0d9eb3c (TRAININGB1, approach B) rewrote scripts/ui/WeekBoard.gd and added WeekEditors/WeekTiles/WeekTired. Its message lists week_b, slate, plan, coach, training_week and weekend_plan as green; these three were not run.

## Contract
OWNS: tests/plan_tray_test.gd, tests/drill_card_test.gd, tests/hover_ghosts_test.gd (and scripts/ui/Week*.gd only if a check finds a real defect in the new board)
RED_TEST: tests/plan_tray_test.gd -> PLAN_TRAY FAIL 12 (red on main today); drill_card_test -> DRILL_CARD FAIL 8; hover_ghosts_test -> SCRIPT ERROR Cannot call method 'find_child' on a null value (line 111-117, `b.find_child("Goal")` / "Gauges")
REGRESSION: week_b_test, week_cause_test, plan_cards_test, golden_path_test
VISUAL: no

## Do
1. Read the new board (WeekBoard.gd, WeekEditors.gd, WeekTiles.gd, WeekTired.gd) and tests/week_b_test.gd, which already covers it.
2. For each failing check, decide: (a) the thing moved or was renamed in approach B (a "THE PLAN" tray, "Goal" and "Gauges" nodes, "Undo_<dow>" buttons, the 9 picture cards on a morning click) - point the check at where it now lives; (b) the thing was deliberately dropped by approach B - delete that check and say so in the PR body; (c) a real defect (the player can no longer do what the check proves) - fix the board and say so.
3. Never change a number or threshold to pass. Do not weaken a check that still has a place on the new board.
4. Each test prints its own pass line with failures=0. Under 500 lines per file.

## Rules for this seat
Godot only through `python ops/Tools/godot_slot.py run --who cursor -- ...`, headless, `--audio-driver Dummy`. Parse check before any test. Nothing opens on a monitor. PR body: one `RESULT: tests/<x>_test.gd -> <exact pass line>` per test.

## The one trap
Tests that fail with "(none)" on a title read a node that is simply absent: do not assume the board is broken, check approach B's design (ops/research, TRAININGB1 brief) first.
