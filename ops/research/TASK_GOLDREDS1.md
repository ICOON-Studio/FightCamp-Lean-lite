# TASK GOLDREDS1 - six career-path tests red in the GAME arm (S292, Claude) - D48 golden path gap 7

Model: Cursor (cloud, label `cursor`). Discipline: BOXING career path (demo) - the week/camp/corner screens the player crosses on the
D48 golden path (quick start -> fight night).

Found S291 (Claude, PC, research/S291_DIGEST.md gap 7): these are red with `-- as_game` on master AND on c02c96ff (every S291
session-touched script swapped back), so they predate S291. Plain `--script` arm status: check it yourself first.
```
timeline_bar_test (as_game): "14 day cells", gold ribbon, FAST one day
first_corner_test (as_game): get_node on null (SCRIPT ERROR)
floor_week_bookkeeping_test (as_game): PLANNED 1/1, stats sum 0.0
week_review_test (as_game): seventh Continue, camp cash, P37 gain
camp_reaches_bout_test (as_game): camp_live OFF byte-identity
camp_pays_test (as_game): known red (S271: 10 seeds time out on the cloud)
```

## Prior research
`python Tools/prior_research.py timeline_bar first_corner week_review camp_pays` - S166 TIMELINE1 (timeline_bar switch, 1 day / 4 s play,
1 day / s fast), S183 (first corner played; first_corner_test is slow - SLOW_TEST_TIMEOUT_S 1082), S271 (camp_pays timeouts), S290 MGT2
timeline (the day rolls on the kept floor, a closed shell has no clock) and S291 (CareerRoot._rebuild_shell hands the new top bar to the
mounted screen; GymHall3D._goal_day uses the day count, not the weekday) - those two S290/S291 changes are the likely reason the
as_game arm now disagrees with tests written before them.

## What would a human do?
Run each test both arms on master, read the FAIL line, read the game code it exercises (trace the route from the test's first press),
and decide per FAIL: (a) the GAME is wrong -> fix the game; (b) the test encodes a rule the operator changed on purpose (S290 "the date
ticks on, no daily reset"; R8 "payrolls and upkeep monthly"; D48) -> update the test to the new rule and quote the commit/operator line;
(c) the setup is stale (the as_game world now starts with a built gym / a different day) -> move the setup, never delete the check.

## Prefab check
None - existing game code and tests only.

## Do
1. Merge origin/master first. For each test: FAIL lines both arms, verdict a/b/c per FAIL, fix.
2. Never guard a check away, never lower a bound, never delete a test or a check. A switched-off mechanic's test stays the OFF control.
3. first_corner_test loads LFS clips - if your box has no LFS, fix it by reading the code and say "not run: LFS" in the PR body; Claude runs it on the PC.
4. Run the six both arms (`python Godot/tools/run_tests.py --jobs 2 [--as-game] --only <the six>`) plus regression
   `golden_path_test,goal_next_test,calendar_drawer_test` both arms (golden_path is ~5 min - it is THE D48 gate and must stay 9/9).

## Contract
OWNS: Godot/tests/timeline_bar_test.gd, Godot/tests/first_corner_test.gd, Godot/tests/floor_week_bookkeeping_test.gd, Godot/tests/week_review_test.gd, Godot/tests/camp_reaches_bout_test.gd, Godot/tests/camp_pays_test.gd, Godot/scripts/TimelineBar.gd, Godot/scripts/WeekReviewPanel.gd, Godot/scripts/GymHall3D.gd
RED_TEST: Godot/tests/week_review_test.gd -> week_review_test: 0 failure(s)
REGRESSION: golden_path_test, timeline_bar_test
VISUAL: no

## The trap
GameState.gd and FightRealtime.gd are never read whole (use `sed -n` windows around a grep hit). If a fix needs a file outside OWNS,
say so in the PR body with the line you changed and why.

## PR body
One `RESULT: tests/<name>.gd -> <pass line>` per test per arm, and the a/b/c verdict per FAIL with the code line that decided it.
