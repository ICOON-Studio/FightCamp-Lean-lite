# TASK ASGAMERED1 - eight tests red in their `-- as_game` arm (gym camera / floor HUD), not caused by their own scripts

Model: Cursor (cloud). Discipline: BOXING (demo) - the gym floor and its HUD.
Owner split: Codex owned the gym floor camera (TASK_FLOORTPM1) but its plan expired after step 2 (c5ba8507: free camera, rooms = glides of
the one camera, Two Point numbers) - you may touch camera code ONLY where a test below proves a defect; never redesign it.
`GymHall3D.gd` (~5,600 lines) and `GymClub3D.gd` (~3,400) are shared: small hunks only, never read them whole (grep, then `sed -n` windows).
New behaviour goes in `GameSwitches.GAME_ON` read with `GameSwitches.on()`; plain `--script` tests = OFF arm, `-- as_game` = ON arm.

## The eight (each passes plain, fails or hangs with `-- as_game` on master)
club_camera_orbit_test, gym_floor_view_test, iso_camera_test, room_info_hud_test, rooms_training_hud_test, see_through_occluders_test,
top_bar_timeline_test, hud_v3_layout_test (HANG/timeout as_game).
Run one: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/<name>.gd -- as_game`.

## Likely causes (verify each - do not assume)
Since S268-S275 the GAME arm turned on: `free_camera` + rooms as camera glides (FLOORTPM1 step 0-2), `one_top_bar` (ui/OneTopBar.gd: the
gym's own second bar and the page-icon dock are hidden, PLAN/APPLICANT in the shell bar), `applicant_chip_only`, `day_plan_on_demand`
(S276: the week's plan repeats; nothing opens by itself), the iso camera at FOV 17 (TWOPOINT_ALIGNMENT.md). A test written before a
switch may look for a node or a camera pose the game arm no longer has.

## Do
1. For each test: run it as_game on master, copy its FAIL lines into the PR body, and decide: (a) the GAME is wrong (a real defect - fix
   the code), or (b) the test pins the OLD design the operator replaced (name the switch + the operator ruling quoted in the switch's
   comment in GameSwitches.gd) - then the test's as_game arm asserts the NEW design's equivalent (e.g. the shell bar's TrayPlan instead of
   the gym bar's PLAN). Never delete a check, never loosen a bound to make it pass; a check with no new-design equivalent moves into the
   plain arm only, with a comment naming the switch.
2. hud_v3_layout_test HANG: find the frame loop that never ends (parse gate first - a parse error hangs a headless test).
3. Each of the eight green plain AND as_game.

## Contract
OWNS: Godot/tests/club_camera_orbit_test.gd, Godot/tests/gym_floor_view_test.gd, Godot/tests/iso_camera_test.gd, Godot/tests/room_info_hud_test.gd, Godot/tests/rooms_training_hud_test.gd, Godot/tests/see_through_occluders_test.gd, Godot/tests/top_bar_timeline_test.gd, Godot/tests/hud_v3_layout_test.gd
RED_TEST: Godot/tests/iso_camera_test.gd -> as_game arm green
REGRESSION: one_top_bar_test, day_plan_week_test, focus_popup_test, applicant_chip_first_test
VISUAL: no

## Prior research
S275_DIGEST.md "Open / next" item 5 (this list); S268/S275 memory: HUD = ONE top bar + modals, nothing auto-opens; TWOPOINT_ALIGNMENT.md
(the iso camera, FOV 17); GDSCRIPT_TRAPS.md.

## What would a human do?
A QA engineer after a UI redesign: run each red test, sort "the game broke" from "the test still checks the old screen", fix the first,
port the second to the new screen's equivalent with the design decision cited - and never green a test by weakening it.

## Prefab check
None - project tests.

## The one trap
Arena/agents have deleted or loosened checks to go green before (CLAUDE.md s8). The PR body lists every changed assertion with old vs new
and the switch/ruling that justifies it; Claude reads that list against this brief.

## Output
PR from cursor/issue-<n> with `RESULT: tests/<x>_test.gd -> <pass line>` for each of the eight (plain + as_game) and the regression set.
