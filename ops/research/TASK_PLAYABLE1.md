# TASK PLAYABLE1 - the whole first-hour boxer career plays end to end, no dead end, no script error (S197)
Model: Codex gpt-6-luna, MEDIUM. Worktree E:/FightCamp/wt/PLAYABLE1, branch codex/playable1 (from master).
Operator S197 (verbatim): "delegate huge tasks i want the project to be playable by tomorrow".

## Goal
The game as the player gets it (`-- as_game`, empty gym start = `GameState.empty_gym_start()`) walks the milestone's
finish line with a BOXER, from a fresh career, and closes the loop:
T1 new career -> T2 sign first boxer -> T3 hire a coach -> T4 train him (programme + floor) and gains are visible ->
T5 find and book a boxing fight -> T6 fight week + weigh-in -> T7 the bout plays to a result -> T8 result screen:
purse, record, injury, fame change -> T9 advance to the next week and book again (the loop closes). Then a SECOND bout.

## What to do
1. Write `Godot/tests/playable_loop_test.gd` (extends SceneTree, same harness shape as `tests/career_loop_walk_test.gd`,
   own save dir `user://fightcamp_playable_loop_test`). It drives the PLAYER'S path through the real screens/routes
   (CareerRoot routes, the buttons a player presses - find them via the scene tree, not by calling GameState shortcuts
   the UI never calls). Turn the game switches on the way `-- as_game` does (read how `as_game` is parsed; mirror it).
   Assert each step T1..T9 reached, twice round the loop; on a failure print `PLAYABLE STEP <Tn> FAIL: <what the screen showed>`.
2. Run it on master FIRST and record which steps go red (that list goes in your final message - it is the evidence).
3. Fix every dead end, SCRIPT ERROR, null access, and refused advance you hit, in the game code (smallest correct fix, at the
   point of the write). Never weaken an existing test. Never turn a switch OFF to dodge a failure.
4. Also run `tools/s64_career_walk.gd` and `tools/s144_live_walk.gd` headless with `-- as_game` and fix any SCRIPT ERROR they print.

## Owned files
- `Godot/tests/playable_loop_test.gd`
- `Godot/scripts/GameState.gd`
- `Godot/scripts/FightWorldLiveScreen.gd`
- `Godot/tools/s64_career_walk.gd`
- `Godot/tools/s144_live_walk.gd`
(S198: listed after the run - the files its fixes touched, reviewed by Claude.)
`Godot/tests/playable_loop_test.gd` (new). Fixes may touch any game script; the big ones are NEVER read whole:
`Godot/scripts/GameState.gd` (19,168 lines - grep for the function, read `sed -n 'a,bp'` windows of <=200 lines),
`Godot/scripts/FightRealtime.gd` (same rule), `Godot/scripts/CareerRoot.gd` (506), `Godot/scripts/GymClub3D.gd` (2,146 - windows).

## Gates (run on the worktree)
- Parse: `python Godot/tools/check_scripts.py <every .gd you touched>`
- Focused: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/playable_loop_test.gd`
  (NEVER the _console.exe). Pass = exit 0 AND no `SCRIPT ERROR` AND no FAIL line AND the `PLAYABLE ... total=.. fails=0` line.
- Related: `python Godot/tools/run_tests.py --only career --jobs 2` and `--only first_hour --jobs 2` and `--only demo_slice --jobs 2`: no NEW red vs master.
- The worktree may lack imported assets (.import): if a test fails ONLY on a missing import, say so - Claude re-runs on master.

## Prior research
PLAYTEST_PROTOCOL.md (T1-T9 above come from it), PLAYTEST_S144_PASS1.md / S146_PASS2.md (earlier dead ends), S187_PLAYTEST_UI.md,
career_loop_walk_test.gd (S64/S65 breaks: profile buttons that went nowhere, bout with no way into the ring, scale never read).
## What would a human do?
A QA tester plays the build cold, writes down every place they got stuck, the dev fixes them, the tester plays again (RITE).
## Prefab check
None - this is our own flow; GUT/GdUnit would not change the method (the repo uses SceneTree scripts).

## The one trap
A walk that calls GameState functions directly proves nothing the player can do. Press the UI the player sees.
Rules: commit on codex/playable1 and push it; never touch master; never open any window/image viewer; no audio.
Final message: the red list from step 2, each fix (file:line, one line why), the final test output lines.
