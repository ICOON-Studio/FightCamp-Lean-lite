# TASK ZIVAFIX1 - the first five minutes stop fighting the player (Ziva playtest P1, P2, P7, P9; boxing demo)

Model: Cursor (cloud). Discipline: BOXING (demo).
Source: `research/ZIVA_PLAYTEST_S267.md` (Ziva played the as_game build as a new player, S269): first 5 minutes 6/10 -
"the two things a new player actually has to do (find a country, then a city) both stall or hide behind small targets, and the
biggest build hitch of the whole game happens exactly there." These are DEFECTS a player saw - no design change, no new look.

## The four defects (each one fix, each one test check)

### 1. P1 + B2 - the city step freezes ~4.4 s and eats clicks
CHOOSE MARKET -> the board drops to ~2.3 fps for 4.4 s while `scripts/CreationFlowPanel.gd` (1,067 lines) `_build_city()` (:524)
builds the 3D `CreationBackdrop` + roster preview behind the city cards; clicks made in that window land in one frame and the
city pick is lost (ENTER CITY pressed before the selection applied).
Fix: the city CARDS appear first (same frame as today's board swap); the heavy 3D backdrop/preview mounts after
`await get_tree().process_frame` (two frames is fine), so no single frame of the step build costs more than ~100 ms on the cards'
side. A card click is applied the frame it is delivered; ENTER CITY reads the applied pick (if you find the queued-click path,
name it in the PR).

### 2. P2 - the globe marker is hard to hit and moves under the cursor
`scripts/creation/GlobePicker.gd` (880 lines): `MARKER_HIT_PX := 14.0` (:30) while Ludo r66's medallion is **56 px across at 1080p**
(LUDO_ROUND66_VERDICT_S226.md:22); Ludo S270 (ludo_rx/LUDO_S270_ZIVA_10_raw.txt) asks for a 32 px hit radius at 1080p with snap-to-nearest marker inside it (scale with the viewport height
if the marker draws scaled). The idle sway (`IDLE_SWAY_RAD` :28, applied :407) must stop while the mouse is over the globe
(ease `_sway_mix` to 0 in ~0.3 s on hover, back on exit) - nothing moves under a cursor that is aiming.
MARKET LIST toggle (`CreationFlowPanel._use_globe_picker` :243 is the switch; find the toggle button): at least 44 px tall and a
visible label "MARKET LIST" (John GLOBEREVIEW1: "the globe is theatre, the list is the control").

### 3. P7 / B3 - the routed gym step shows a flat grey preview
New career -> country -> city -> THE GYM: the centre frame (`scripts/creation/GymStepPanel.gd` 630 lines `_build_centre()`
:290-303, `scripts/creation/GymPreview.gd` 769 lines `_ready()` :44-48 `_build_shell()`) stays grey after 26 s. The direct mount
(`tools/s238_gym_preview_probe.gd`) renders the club in the same build. Find why the ROUTED step's SubViewport does not render
(suspects: viewport size 0 at `_ready` because the router adds the panel before layout, `render_target_update_mode`, the camera not
`current` in the routed tree, the panel built while hidden) and fix it so both paths render.

### 4. P9 - a placeholder line ships
"THE DAY'S NEWS LANDS HERE" shows on the first day (`scripts/ui/FloorHud2Widgets.gd:151`, `scripts/ui/HudV3Widgets.gd:84`). With no
news yet, show the day's real first line instead: `"<GYM NAME> OPENS ITS DOORS - DAY 1"` on the career's first day, else
`"A QUIET MORNING AT <GYM NAME>"` (gym name from `GameState.career.world.gym_name`, upper-case). Never the placeholder.

## Files you own
`Godot/scripts/CreationFlowPanel.gd`, `Godot/scripts/creation/GlobePicker.gd`, `Godot/scripts/creation/GymStepPanel.gd`,
`Godot/scripts/creation/GymPreview.gd`, `Godot/scripts/ui/FloorHud2Widgets.gd`, `Godot/scripts/ui/HudV3Widgets.gd`,
NEW `Godot/tests/ziva_first_minutes_test.gd`.
Do NOT edit GameState.gd, GymHall3D.gd, WeekReviewPanel.gd (Claude is on B1/P6 there).

## Test (NEW `Godot/tests/ziva_first_minutes_test.gd`, OK/FAIL lines, ends `print("ZIVA_FIRST_MINUTES failures=%d" % failures)`)
Must go RED on master first (say which checks were red in the PR body). Run it with `-- as_game` (the globe arm is as_game only).
1. Mount the creation flow, commit a market (the code path CHOOSE MARKET uses): the city cards exist the SAME frame; the
   step-build frame time measured with `Time.get_ticks_usec()` around the call is < 150 ms (print achieved); the backdrop exists
   within 5 frames.
2. `GlobePicker`: a pick at 30 px from a marker's screen centre selects it (fails at 14); with the mouse inside the globe rect
   for 30 frames the sway angle stops changing (|delta| < 0.001 rad over the last 10 frames).
3. Routed gym step (go through the router, not a direct mount): after 30 frames the preview SubViewport size is > 0 on both axes
   and its texture is not one flat colour (sample a 16x16 grid of `get_texture().get_image()` pixels: > 1 distinct colour).
   Headless has no renderer - if the image is null headless, check size + `render_target_update_mode != UPDATE_DISABLED` + camera
   `current` and say so; Claude takes the windowed still.
4. The first-day HUD news line equals the gym-name line; the string "LANDS HERE" appears nowhere in the HUD tree.

## Acceptance
`RESULT: tests/ziva_first_minutes_test.gd -> ZIVA_FIRST_MINUTES failures=0` (as_game), and these still pass plain and as_game:
`creation_flow_test`, `globe_picker_test`, `gym_step_panel_test` (use the names that exist - list them in the PR), `hud_v3_test`
or the HUD tests that exist for the two widget files. PR body: RESULT lines, line windows edited. You cannot see images - Claude
takes the stills on the game camera.

## Prior research
ZIVA_PLAYTEST_S267.md (P1, P2, P7, P9, B2, B3); LUDO_ROUND66_VERDICT_S226.md (medallion 56 px); GLOBEREVIEW1_JOHN_XAI.md (list is
the control); s238_gym_preview_probe.gd (the preview renders when mounted directly); TWOPOINT_ALIGNMENT.md section 1-2 (a clickable
thing within a minute, never wait on a board).

## What would a human do?
Football Manager / Motorsport Manager new-career screens: the list always works, the picture never moves under the mouse, the next
screen appears at once and fills in behind.

## Prefab check
None - our own creation flow; Godot's `await process_frame` deferral is the standard tool.

## The one trap
Do not change the look (colours, layout, Ludo's medallion art) or any money/game data - only timing, hit areas, sway on hover,
the preview render and the placeholder text. New features ship ON (GAME_ON); plain `--script` tests are the OFF arm.

## Contract
OWNS: Godot/scripts/CreationFlowPanel.gd, Godot/scripts/creation/GlobePicker.gd, Godot/scripts/creation/GymStepPanel.gd, Godot/scripts/creation/GymPreview.gd, Godot/scripts/ui/FloorHud2Widgets.gd, Godot/scripts/ui/HudV3Widgets.gd, Godot/tests/ziva_first_minutes_test.gd
RED_TEST: Godot/tests/ziva_first_minutes_test.gd -> ZIVA_FIRST_MINUTES failures=0
