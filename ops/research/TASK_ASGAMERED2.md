# TASK ASGAMERED2 - ten more gym tests red in their `-- as_game` arm on master (rooms, zones, look, top bar)

Model: Cursor (cloud). Discipline: BOXING (demo) - the gym floor, its rooms and its HUD.
Same job as ASGAMERED1 (collected S277, 4f52e822 - read its diff first: `git show 4f52e822 -- Godot/tests`), ten more tests.
`GymHall3D.gd` (~5,750 lines), `GymClub3D.gd` (~3,450) and `GameState.gd` are shared: small hunks only, never read them whole.
New behaviour goes in `GameSwitches.GAME_ON` read with `GameSwitches.on()`; plain `--script` tests = OFF arm, `-- as_game` = ON arm.

## The ten (each passes plain, fails or hangs with `-- as_game` on master )
club_routes_floor_test, club_zones_test, gym_club_3d_test, gym_look2_shell_test, office_pc_wiring_test, one_top_bar_test, office_room_test, staff_room_test, locker_room_test, physio_room_test (locker_room_test and physio_room_test HANG as_game - parse gate first, then find the frame loop that never ends).
Run one: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/<name>.gd -- as_game`.

## Likely causes (verify each - do not assume)
The S268-S276 game switches: free_camera + rooms as camera glides, one_top_bar, applicant_chip_only, day_plan_on_demand,
no_interrupts (no block stops, nothing holds the clock), training_rotation, stripped_start (a new gym's floor is EMPTY - every zone in
build mode's tray; S277 GYMBUILD A also makes it an empty SHELL: `career["club_rooms_built"] = {}` = no rooms - see GymClubLayout
`_apply_built_rooms`, `is_shell`). A room test's honest fixture under stripped_start is a gym whose owner BUILT what the test is about:
`gs.career.erase("club_rooms_built")` (the five data rooms) and/or `erase("club_zones_placed")` + `erase("club_zone_store")`, then
`GymClubLayout.reload()` - the pattern S277 used in see_through_occluders_test / focus_popup_test / club_rooms_split_test.

## Do
1. For each test: run it as_game on master, copy its FAIL lines into the PR body, decide (a) the GAME is wrong (fix the code) or
   (b) the test pins the OLD design the operator replaced (name the switch + the operator ruling quoted in GameSwitches.gd) - then
   the as_game arm asserts the new design's equivalent or uses the built-gym fixture. Never delete a check, never loosen a bound;
   a check with no new-design equivalent moves to the plain arm only, with a comment naming the switch.
2. Each of the ten green plain AND as_game.

## Contract
OWNS: Godot/tests/club_routes_floor_test.gd, Godot/tests/club_zones_test.gd, Godot/tests/gym_club_3d_test.gd, Godot/tests/gym_look2_shell_test.gd, Godot/tests/office_pc_wiring_test.gd, Godot/tests/one_top_bar_test.gd, Godot/tests/office_room_test.gd, Godot/tests/staff_room_test.gd, Godot/tests/locker_room_test.gd, Godot/tests/physio_room_test.gd
RED_TEST: Godot/tests/office_room_test.gd -> as_game arm green
REGRESSION: one_top_bar_test, focus_popup_test, club_rooms_split_test, see_through_occluders_test
VISUAL: no

## Prior research
TASK_ASGAMERED1.md + its collected diff 4f52e822; S277 shell (GYMBUILD_PLAN_S276.md, GymClubLayout._apply_built_rooms); GDSCRIPT_TRAPS.md.

## What would a human do?
A QA engineer after a redesign: sort "the game broke" from "the test still checks the old screen", fix the first, port the second with
the design decision cited - never green a test by weakening it.

## Prefab check
None - project tests.

## The one trap
Agents have deleted or loosened checks to go green before. The PR body lists every changed assertion with old vs new and the
switch/ruling that justifies it.

## Output
PR from cursor/issue-<n> with `RESULT: tests/<x>_test.gd -> <pass line>` for each of the ten (plain + as_game) and the regression set.
