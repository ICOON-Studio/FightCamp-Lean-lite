# TASK NIGHTLY3 - four tests that went red in the 2026-10-11 nightly (reproduce on master, fix the cause, prove green)

Model: Cursor (composer). Tier: a script edited -> parse, the focused test, then `run_tests.py --only <substring>` for the systems touched.

## Why
The nightly suite of 2026-10-11 ran at commit a6c70708 (680 tests, 7 red). Four reds are NEW against 2026-10-10 (the other three are old
and owned elsewhere - leave them):
1. `Godot/tests/club_fill_test.gd`
2. `Godot/tests/no_garage_test.gd`
3. `Godot/tests/playable_loop_test.gd`
4. `Godot/tests/switch_gate_contact_push_carry_test.gd`
Master has moved since (S202 commits: fighter drawer 2194dc6d, club_zones double-kit hide in GymClub3D.gd, WIRE-LASTSPAR 3ab2bb3d,
AMBITION1A 915938d9, MATCHMAKE1A d1b74578). Some may already be green, some may have been turned red by those commits.

## Prior research
`python Tools/prior_research.py club_fill no_garage playable_loop push_carry` before you start. `AgentComms/nightly/suite_2026-10-11.log`
names the four; it has no failure detail, so you reproduce each yourself.

## What would a human do?
Run each test alone on current master, read its own FAIL line, `git log -S`/`git log -L` the line it checks to find the commit that
changed the behaviour, then decide: the CODE regressed (fix the code) or the TEST encodes a rule the operator since changed (update the
test to the new rule and quote the commit that changed it). Never weaken a check just to go green.

## Prefab check
Not applicable (defect fixing).

## Steps
1. For each of the four, on your branch (cut from master): run it alone
   `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/<name>.gd`
   (NEVER `_console.exe`). Record: exit code, its FAIL lines, any `SCRIPT ERROR`. Already green on master -> write that down with the
   output's last 3 lines and move on.
2. For each red: find the cause (file:line + the commit that introduced it). Fix the code; a test change is allowed ONLY when the test
   asserts something a later operator-approved commit deliberately changed - quote that commit message in your commit message.
3. Parse gate on every .gd you touch: `python Godot/tools/check_scripts.py <files>`.
4. Prove: each of the four alone -> green (exit 0, its pass line, no SCRIPT ERROR). Then
   `python Godot/tools/run_tests.py --jobs 2 --only <substring>` for each system you touched (e.g. `club_`, `gym_hall`, `playable`,
   `switch_gate`).

## Owned files
Whatever the fix needs, but NOT `Godot/scripts/GameState.gd` or `Godot/scripts/FightRealtime.gd` beyond a <= 15-line local change
(both are huge: never read them whole - `grep -n` then `sed -n <a>,<b>p`). Never `AgentComms/`, never `HANDOFF.md`.

## The one trap
`switch_gate_*` tests check that a game switch is OFF by default in headless runs; a commit that turned a switch ON by default (or read
it from `career` without a default) is the usual cause - the fix is the default, not the test. Tests run with the game switches OFF.
Never open a window, viewer or browser.

## Done =
Branch `cursor/nightly3` pushed; final message lists, per test: red-or-green on master before, the cause (file:line, commit), the fix, the
green output after, and the `--only` subset results.
