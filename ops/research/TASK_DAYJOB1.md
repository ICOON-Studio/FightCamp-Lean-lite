# TASK DAYJOB1 - the day job: two mornings lost a week, the sponsorship billed in 4-week blocks (pure module + test)

Status: OPEN (S485, Claude main). Discipline: boxing. Model: Arena (cloud, lite mirror), default.

## Why now
The owner's ruling (S484, club week Q-S294-243): "2 mornings" - a boxer without the gym sponsorship loses 2 coached
mornings a week to work. Today the game hides this as a flat 0.85 gain multiplier (GymSpend.DAY_JOB_GAIN). This module is
the rule; Claude wires it (build plan ops/research/CLUBWEEK1_BUILD_S485.md, item 1). Pure rules only: no game state, no UI.

## What to build: scripts/rules/DayJob.gd (extends RefCounted; pure static; NO preload, NO class_name)
Constants:
- LOST := 2                      (mornings a week lost to work)
- LOST_DAYS := [1, 3]            (week-day indices 0 Mon .. 5 Sat that are lost first: Tue, Thu)
- WEEK_DAYS := 6                 (training days Mon..Sat)
- BLOCK_WEEKS := 4               (the sponsorship is billed in 4-week blocks)
- WORK_WORD := "Work"

Functions:
1. `lost(day_job: bool) -> int` - LOST when day_job, else 0.
2. `lost_days(day_job: bool, rest_days: Array = []) -> Array` - the day indices lost to work, sorted ascending. Empty when
   not day_job. Start from LOST_DAYS; a day in rest_days (the boxer rests that day anyway) is skipped and the next free
   day is taken instead, scanning 0..WEEK_DAYS-1 from the skipped day forward and wrapping; never a rest day, never twice.
   If fewer than LOST free days exist, return the free ones only.
3. `mornings_left(planned: int, day_job: bool) -> int` - max(0, planned - lost(day_job)).
4. `gain_share(planned: int, day_job: bool) -> float` - mornings_left / planned as a float; 1.0 when planned <= 0.
5. `block_cost(weekly_stipend: int) -> int` - weekly_stipend * BLOCK_WEEKS.
6. `block_end(start_day: int) -> int` - start_day + BLOCK_WEEKS * 7.
7. `day_word(day: int, lost_list: Array) -> String` - WORK_WORD when day is in lost_list, else "".
8. `line(day_job: bool) -> String` - "" when not day_job, else "Works 2 mornings a week (Tue, Thu)" built from LOST and
   LOST_DAYS with day names ["Mon","Tue","Wed","Thu","Fri","Sat"].
Comment block at the top in the house style: what it is, the owner's ruling quoted, the build plan path, one usage line
per function.

## Test: tests/day_job_test.gd (extends SceneTree; preload the module by path; prints "ok   <what>" / "FAIL <what>",
ends with one line `DAY_JOB PASS fails=0` or `DAY_JOB FAIL fails=<n>`, quit(0) on pass, quit(1) on fail)
Cover at least: lost(true) == 2, lost(false) == 0; lost_days(false) == []; lost_days(true) == [1, 3];
lost_days(true, [1]) == [2, 3]; lost_days(true, [3]) == [1, 4]; lost_days(true, [1, 2, 3]) == [4, 5];
lost_days(true, [0,1,2,3,4]) == [5]; mornings_left(6, true) == 4, mornings_left(1, true) == 0, mornings_left(6, false) == 6;
gain_share(6, true) is 4/6 within 0.001, gain_share(0, true) == 1.0; block_cost(250) == 1000; block_end(10) == 38;
day_word(1, [1, 3]) == "Work", day_word(2, [1, 3]) == ""; line(true) == "Works 2 mornings a week (Tue, Thu)", line(false) == "".

## Pass lines
RESULT: tests/day_job_test.gd -> DAY_JOB PASS fails=0
(Arena's runner has no Godot: write the code and test exactly to this brief; Claude runs the test on the PC.)

## Contract
OWNS: scripts/rules/DayJob.gd, tests/day_job_test.gd
RED_TEST: tests/day_job_test.gd -> DAY_JOB PASS fails=0 (red on main: the files do not exist)
REGRESSION: tests/day_job_test.gd (nothing else calls it yet; Claude wires GymSpend after)
VISUAL: no
NOT YOURS: every other file. Both files under 500 lines. Never delete or weaken a test.
Run: `godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/day_job_test.gd` (Godot 4.7.2).
Work on your own branch, open a PR, never merge.

## Prior research
CLUBWEEK1 v9 map 3.6 (the gym sponsorship and the day job); GymSpend.gd stipends block (DAY_JOB_GAIN 0.85, set_stipend);
the owner's answer in ops/research/CLUBWEEK1_V9_CHECKS_S483.md.

## What would a human do?
A club boxer with a job trains the evenings and the mornings they are free; the coach knows which mornings they work.

## Prefab check
None needed: two constants and arithmetic.
