# ROUND 2 (S275, Claude) - read this first
Round 1 collected on master 53340738: af_motion, asset_manifest, stat_vocabulary. Your POWER_HINTS reorder was NOT taken - reordering
code so a test's regex stops seeing it is dodging the instrument; the scan was fixed in the test instead (>= 3 stat names = a copy).
Never change code only to hide it from a test. Merge origin/master first. Four left, with their FAIL lines on master (S275, PC):
- profile_overview_test: `CHECK FAIL profile2_back_resumes` (118 checks, 1 fail).
- switch_gate_contact_push_carry_test: `FAIL contact_push_carry: root/hip pops ON 3 < OFF 2` - the switch ON now pops MORE than OFF.
  Find which commit made ON worse (S274 clips_only_base fabfeef4 / captured steps c65a7033 OFF / ROKOKOMOVES1 03cbc6cd guard windows).
  The switch exists to reduce pops: fix the game if ON is really worse; move the pin only if a ruling made it so, and write which.
- punch_retime_test: PASSES plain on the PC - the nightly red is likely its `-- as_game` arm; run it that way.
- fight_room_walkout_test: hangs (timeout) - find the loop that never ends.
Same gates and PR body lines as below.

# TASK NIGHTLY12 - seven tests that went red in the 2026-10-20 cloud nightly (bb2108dc), green the day before (S275)

Model: Goose (cloud, long job). Discipline: BOXING (demo) - every test below plays the boxing demo path.
New red on 10-20 vs 10-19 (`AgentComms/nightly/suite_2026-10-19.log` vs `suite_2026-10-20.log`):
af_motion_test, asset_manifest_test, profile_overview_test, punch_retime_test, stat_vocabulary_test,
switch_gate_contact_push_carry_test, fight_room_walkout_test (hang/timeout).
(iso_ceiling_fixtures_test and see_through_occluders_test also went red - they belong to the gym floor owner, TASK_FLOORTPM1; leave them.)

## Likely causes (commits between the two nightlies - check each with `git log --oneline <10-19 nightly sha>..bb2108dc -- <file>`)
- S274 clips_only_base (fabfeef4): the fight's room layers stand down in the game arm -> punch_retime_test, switch_gate_contact_push_carry_test,
  fight_room_walkout_test may pin a value the clips-only base changed. Spacing (contact push, stance offset) is meant to stay ON.
- S274 11 attributes on the profile / stat words (S260-S274 ATTRIB): profile_overview_test, stat_vocabulary_test.
- New asset files without a manifest row / new Ailive or Rokoko clips (11f73ef1, S274 imports): asset_manifest_test, af_motion_test.
- S274 fight_floating_text OFF (57386723), captured_steps OFF (c65a7033).

## Do (per test)
1. Run it on master and read the FAIL line(s). One test: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/<name>.gd`
   (Linux: `godot --headless ...`); the cloud nightly ran with the game arm for some shards - check `.github/workflows/nightly-suite.yml`
   for the user args and run it the same way.
2. Find the commit that turned it red (bisect between the 10-19 and 10-20 nightly commits).
3. Decide: the GAME is wrong (fix the game, smallest change) or the test pins an old value a deliberate operator-approved change moved
   (update the pin AND write in the test, beside it, which commit/ruling moved it). Never delete a test or loosen it until it cannot fail;
   a green instrument must still be able to read worse.
4. fight_room_walkout_test HANGS: find the frame loop that never ends (a parse error hangs a headless test - run the parse gate first).

## Gates
- Parse gate: `python Godot/tools/check_scripts.py <touched .gd>`.
- Each of the 7 tests green, run alone; then `python Godot/tools/run_tests.py --jobs 2 --only af_motion,asset_manifest,profile_overview,punch_retime,stat_vocabulary,switch_gate_contact_push_carry,fight_room_walkout`.
- PR body: per test one line `RESULT: tests/<x>_test.gd -> <exact pass line>` and one line `CAUSE: <commit> <one sentence>`.
- Commit only the files you changed for these tests (git add -- <files>); never a tree-wide commit (Goose trap S224: a stale-tree commit reverted 439 files).

## Contract
OWNS: Godot/tests/af_motion_test.gd, Godot/tests/asset_manifest_test.gd, Godot/tests/profile_overview_test.gd, Godot/tests/punch_retime_test.gd, Godot/tests/stat_vocabulary_test.gd, Godot/tests/switch_gate_contact_push_carry_test.gd, Godot/tests/fight_room_walkout_test.gd
RED_TEST: Godot/tests/punch_retime_test.gd -> PUNCH_RETIME failures=0
REGRESSION: af_motion_test, asset_manifest_test, profile_overview_test, stat_vocabulary_test
VISUAL: no

## Prior research
NIGHTLY1 row in AgentComms/roadmap.json (what each earlier nightly found), TASK_NIGHTLY11.md (the last batch), GDSCRIPT_TRAPS.md.

## What would a human do?
Bisect each red to its commit, then judge the test against the operator's ruling that made the commit - fix the game when the game broke,
move the pin (with the reason written beside it) when the change was the point.

## Prefab check
None - test maintenance.

## The one trap
A test that pins the OFF arm and a test that plays the game arm read different switches: confirm which arm the nightly ran before changing
anything, or a fix turns the other arm red.
