# TASK FASTGREY1 - [Fast] in the gym day turns the screen flat grey (Ziva playtest Round 3, item 5; boxing demo)

Model: Cursor (cloud). Discipline: BOXING (demo).
Source: `research/ZIVA_PLAYTEST_S267.md` Round 3 (line ~529): from a live day (career mornings ON, the plan running on the
floor), Ziva pressed **[Fast]** on the top time bar; the next frame was a flat grey screen - no HUD, no 3D scene - and the run
continued from there into the week review (screenshot `38_after_fast_blank_screen.png` in Ziva's playtest folder). A DEFECT a
player saw - no design change.

## The game path (trace it, do not guess)
- The time bar: `scripts/ClubSpeedControls.gd` `build_time_bar()` (:74), the Fast entry is `SPEEDS` row "Fast" = speed 3 (:12).
- Its callback: `scripts/GymHallPanel.gd` `_on_speed_pick(speed)` (:671) -> `hall.set_speed(speed)` (GymHall3D.gd, find
  `func set_speed`); `_on_speed_changed` (:676) refreshes the bar.
- At 3x the day's 600 minutes end sooner: `GymHall3D._end_visit()` (:995) emits `visit_ended` -> `GymHallPanel._on_visit_ended`
  (:839) -> `GameState.file_visit` -> `rebuild()` + `_show_day_wrap` (DayWrapDrawer). On Sunday `file_visit` completes the week.
  Likely suspects (prove one with a test, do not patch blind): `rebuild()` freeing the 3D hall/camera while a new one is not yet
  current; the day-wrap drawer or a modal drawing a full-rect grey panel; `set_speed(3)` refused on day 1 (LUDO10 item 5 lock,
  GymHall3D :1988) leaving a half-built state.

## What to build
1. A RED test first, on master, as_game: `Godot/tests/fast_no_grey_test.gd` - new career (copy the setup of
   `tests/self_run_day_test.gd`: UK boxer, career_mornings ON, NOT NOW, STEP IN; with day_plan ON start the suggested plan via
   `hall.day_plan_start(DayPlan.TEMPLATES[DayPlan.suggest(hall.day_plan_ctx())])`), then press the time bar's Fast button
   (`TimeBar` child for speed 3 - `.pressed.emit()`), run frames/minutes past the day's end (`hall.advance_minutes`), and assert
   on EVERY frame you step: the GymHallPanel is in the tree and visible, `get_viewport().get_camera_3d()` is non-null and
   inside the hall (or the hall's own SubViewport camera when it renders through one), the top bar (`GymTopBar`) or the
   TimeBar is visible, and no visible Control covering >= 90% of the 1920x1080 canvas is a plain flat-colour panel with no
   children (name it in the FAIL line). Do the same across a Sunday (seven days) so the week-complete path is covered.
   It must go RED on master as_game - paste the FAIL line in the PR body.
2. Fix the cause in the file the test points at. Keep the LUDO10 day-one lock (Fast on day 1 stays shut, as today).

## Owned files
`Godot/scripts/GymHallPanel.gd`, `Godot/scripts/ClubSpeedControls.gd`, `Godot/scripts/ui/DayWrapDrawer.gd`,
`Godot/tests/fast_no_grey_test.gd`. GymHall3D.gd (5,370 lines - never read whole; `sed -n` windows) only if the test proves the
cause is there, and then only the function named in the PR body.

## Parse gate and tests
`python Godot/tools/check_scripts.py <touched .gd>`; then on the cloud:
`python Tools/cloud_test.py fast_no_grey_test,self_run_day_test,floor_gain_coach_day_test,week_review_no_coach_test --as-game`
and the same list plain (plain `--script` runs are the switches-OFF control arm; the new test may SKIP-pass plain if the time
bar is not drawn there - print why).
PR body: `RESULT: tests/fast_no_grey_test.gd -> FAST_NO_GREY failures=0` and the red line from master.

## Prior research
searched: grey screen fast (nothing). Ziva Round 3 (above); S270 LUDO10 item 5 (day one at 1x).

## What would a human do?
Press Fast, watch the frame go grey, then look at which node is on top of the screen in that frame - before touching code.

## Prefab check
n/a (a defect in our own flow).

## The one trap
A headless test that only checks "no crash" passes on the grey screen. Assert what is VISIBLE (panel, camera, bar) every frame.

## Contract
OWNS: Godot/scripts/GymHallPanel.gd, Godot/scripts/ClubSpeedControls.gd, Godot/scripts/ui/DayWrapDrawer.gd, Godot/tests/fast_no_grey_test.gd
RED_TEST: Godot/tests/fast_no_grey_test.gd -> FAST_NO_GREY failures=0
REGRESSION: self_run_day_test
VISUAL: yes
