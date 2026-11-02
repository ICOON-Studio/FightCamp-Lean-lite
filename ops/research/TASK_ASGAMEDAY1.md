# TASK ASGAMEDAY1 - as_game: the no-coach career's first day cannot be started on the test path (5 as_game reds on master)

Model: Cursor (cloud). Discipline: BOXING (demo).

## Why (Claude S273, measured on master 4628072b..04831c33, cloud `--as-game`)
These five fail `-- as_game` ON MASTER (plain they pass):
- `self_run_day_test` - "FAIL: CONTROL: the coach offer is up before NOT NOW": as_game the coach offer is the S270 LUDO10 item 3
  APPLICANT chip (`GymHall3D.show_coach_hire` :4839 stashes the offer; the card opens only when the day plan panel is not open),
  so `Hud/CoachHire` is never visible and the test cannot reach NOT NOW -> STEP IN.
- `floor_week_bookkeeping_test` (S273, new) as_game: "START_DAY no step: hire=false card=false timebar=true running=false" -
  no morning card, no TimeBar/MorningAction; START DAY on the day plan panel (`GymHall3D.day_plan_start` :2849) does not set
  `running` - so is there ANY way a no-coach as_game player starts his day? Find it on the game path (ui first, then code).
- `training_hub_panel_test` rc=1, `floor_gain_coach_day_test` rc=1, `week_program_test` HANG, `week_review_test` HANG.

## What to do
1. For each of the 5, run it on the cloud as_game (`python Tools/cloud_test.py <name> --as-game`), read ITS OWN FAIL line /
   the last line before the hang, and classify: GAME DEFECT (a player on as_game hits it) or TEST PATH (the test drives a UI
   the as_game build replaced). Table in the PR body.
2. GAME DEFECT "the no-coach day cannot start as_game": if a player with no coach, after the applicant chip / NOT NOW, has no
   control that starts the day, fix the game (the smallest change in GymHall3D / GymHallPanel that gives START DAY or STEP IN
   the clock), with a red-first check in `self_run_day_test`'s as_game arm.
3. TEST PATH: teach the test the as_game control (the applicant chip -> its card -> NOT NOW; the plan panel's START DAY), never
   skip the as_game arm, never delete a check.
4. Hangs: find the frame/loop that never ends (print progress), fix the harness or the game, and say which.

## Owned files
Godot/tests/self_run_day_test.gd, Godot/tests/floor_week_bookkeeping_test.gd (only its `_start_day`), Godot/tests/training_hub_panel_test.gd,
Godot/tests/floor_gain_coach_day_test.gd, Godot/tests/week_program_test.gd, Godot/tests/week_review_test.gd;
Godot/scripts/GymHall3D.gd (5,375 lines - `sed -n` windows only; morning/day-plan functions named above) ONLY for a GAME DEFECT.
Cursor FASTGREY1 (#289) and FIGHTSTAB1 (#290) also touch GymHallPanel.gd - do not edit it; if the fix needs it, say so in the PR.

## Parse gate and tests
`python Godot/tools/check_scripts.py <touched .gd>`; cloud, both arms:
`python Tools/cloud_test.py self_run_day_test,floor_week_bookkeeping_test,training_hub_panel_test,floor_gain_coach_day_test,week_program_test,week_review_test --shards 3`
and the same with `--as-game`. PR body: `RESULT: tests/<x>_test.gd -> <pass line>` per test, both arms.

## Prior research
S270 LUDO10 item 3 (applicant chip), S270 B1 self_run_day (no-coach day), S273 LOOP1 04831c33 (floor_week_bookkeeping).

## What would a human do?
Start a new career as_game, say NOT NOW to the coach, and try to start the day - before reading code.

## Prefab check
n/a.

## The one trap
"The test drives an old UI" is not a pass: first prove a player CAN start the day as_game; only then change the test.

## Contract
OWNS: Godot/tests/self_run_day_test.gd, Godot/tests/training_hub_panel_test.gd, Godot/tests/floor_gain_coach_day_test.gd, Godot/tests/week_program_test.gd, Godot/tests/week_review_test.gd
RED_TEST: Godot/tests/self_run_day_test.gd -> SELF_RUN_DAY_TEST checks=
REGRESSION: floor_week_bookkeeping_test
VISUAL: no
