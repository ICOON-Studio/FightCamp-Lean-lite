# TASK NIGHTLY7 - seven nightly reds on master, one small PR each (S240, Grok Dev, after PLAYLOOP4)

Seat: Grok Dev (cloud coding seat, Godot 4.7.2, no LFS). Model: Grok Dev default. Discipline: BOXING (demo).
Start this AFTER PLAYLOOP4's PR is open. One branch + PR per test: `grok/nightly7-<test stem>`, PR to master; Claude merges by diff.

## The reds (nightly 2026-10-17 @5b92bef2, SUITE total=885 fails=16; these seven are unowned)
Work them in this order; each line = the test and how it failed in the suite:
1. `tests/decision_pacing_test.gd` - hang (timeout). Suspect: S238 LOOPOFF1 turned story/tutorial OFF and the pacing path it waits for never fires.
2. `tests/camp_pays_test.gd` - rc=1.
3. `tests/promotions_board_test.gd` - rc=1.
4. `tests/default_build_shows_no_real_name_test.gd` - rc=1 (a real organisation/person name leaks into the default build - fix the DATA/TEXT, never the test's name list).
5. `tests/station_move_picker_test.gd` - rc=1 (2D UI node tree changed).
6. `tests/corner_instruction_contract_test.gd` - rc=1.
7. `tests/staff_pose_test.gd` - rc=1 (long known red - if it needs LFS models you cannot load, say so in one line and skip it).

## Do, per test
1. Run it alone on master: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/<name>.gd` - paste its FAIL / SCRIPT ERROR line.
2. Find WHY with `git log -p --since=2026-10-10 -- <the files the failing check reads>` - name the commit that broke it.
3. Fix the GAME (or stale fixture data the commit made wrong) - never delete, skip or weaken an assertion; if the test's expectation
   is genuinely obsolete because a newer operator-approved design replaced it, say which commit/design in the PR and change only that
   expectation, nothing else.
4. Green: the test alone prints its pass line; parse gate `python Godot/tools/check_scripts.py <touched .gd>`; plus
   `python Godot/tools/run_tests.py --only <the touched system's substring> --jobs 2` unchanged-or-better vs master (paste both SUITE lines).
If a test fails only because an LFS asset (.glb/.png/.fbx) is missing on your box, write that in one PR comment line and move on.

## Rules
research/GDSCRIPT_TRAPS.md. GameState.gd, GymHall3D.gd, FightRealtime.gd are huge - grep + sed -n windows, never whole.
New features ship ON (GameSwitches.GAME_ON); plain --script tests are the OFF control arm. Never test identical fighters.
THE ONE TRAP: never delete or weaken a test to go green - a red test that is right stays red and you report it.

## Prior research
roadmap NIGHTLY1 row (history of each red), S238_DIGEST.md (LOOPOFF1), S239_DIGEST.md, AgentComms/nightly/latest.txt.

## What would a human do?
Bisect each red to the commit that broke it, fix the cause in the game, prove it with the test alone, ship small PRs.

## Prefab check
None - regressions in our own code.
