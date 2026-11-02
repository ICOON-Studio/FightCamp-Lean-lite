# TASK_ASGAMERED7 - two tests red under `-- as_game` on master (ASGAMERED6 audit, S284)

Model: cursor. Discipline: boxing = demo. Cloud seat, headless only; no stills.

## The two reds (measured S284 on master f5cd4989, plain arm green)
1. `day_feed_screen_test` as_game, 3 FAILs: "one pin per room (8 drawn, 5 rooms)", "NEXT FIGHT carries the one gold", "YOUR FIGHTERS shows the roster as cards". Test: Godot/tests/day_feed_screen_test.gd lines ~70-84; panel: Godot/scripts/DayFeedPanel.gd (1226 lines, read in windows: `_build_pins` L391, `_build_next_fight` L507, `_build_no_bout` L586, `_build_fighter_row` L1037).
2. `day_plan_floor_test` as_game, 1 FAIL: "ON: minute holds while the panel is open (10)". The test sets `career["day_plan_on_demand"]=false` (L81) and `career["day_plan"]=true`; `GymHall3D._day_plan_morning` (L2855-2905) should then open the panel and hold the clock. Under as_game the clock runs (minute 10). `day_plan_remember=0` does not change it. Find which as_game switch/state skips `day_plan_panel_open = true` (L2899) or lets the clock run; `_fighter_row.is_empty()` at L2860 is a suspect.

## Rule
Verdict each: FIX THE GAME if the player gets a wrong screen/day, or REWRITE THE CHECK to the by-design replacement (HOME is the full-screen 3D gym under the one top bar, S275/S283; the empty-gym start has no roster). Never wrap a check in `if not as_game` (ASGAMERED6 rounds 3-5 did, and were refused). Write each verdict (BY DESIGN / DEFECT + evidence) into the PR body.

## Prior research / What would a human do? / Prefab check
`python Tools/prior_research.py day feed home pins`. A human: the HOME screen shows what the player's game shows. No prefab needed.

## Contract
OWNS: Godot/tests/day_feed_screen_test.gd, Godot/tests/day_plan_floor_test.gd, Godot/scripts/GymHall3D.gd, Godot/scripts/DayFeedPanel.gd
RED_TEST: Godot/tests/day_plan_floor_test.gd -> DAY_PLAN_FLOOR failures=0
REGRESSION: one_top_bar_test, day_plan_focus_test
VISUAL: none (headless; if a game defect is fixed, say so and Claude takes the still)

## VISUAL GATE
Not a visual change unless a DayFeedPanel/HOME draw changes; then it closes only on a game-camera still opened by Claude plus the operator's OK.

## Acceptance
Parse gate `python Godot/tools/check_scripts.py <touched .gd>`; each test GREEN on BOTH arms (`--script tests/<t>.gd` and `... -- as_game`). Use Godot_v4.7.2-stable_win64.exe only (never the console build). PR body: `RESULT: tests/day_plan_floor_test.gd -> DAY_PLAN_FLOOR failures=0` and `RESULT: tests/day_feed_screen_test.gd -> <its pass line>`. New features ship ON; plain `--script` stays the OFF control arm.
