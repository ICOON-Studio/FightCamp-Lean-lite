# TASK BARGUARD1 - CURSOR (Grok 4.7 High) - the boots stay above the corner bar while a shot holds, even when a boxer stands at the lens

Status: OPEN (S428, Claude main). Discipline: boxing. Model: grok-4.7-high.
Source: operator S426 "the hud hides players feet"; S427 fixed it AT A CUT only (TvShot.BAR_CLEAR 0.68, TvShot.place frames
both boxers head to feet with the room under the boots). A cut places the lens once and one FOV for the whole shot; while the shot
holds the boxers walk, and when one stands right at the lens his boots slide under the bar (S427 still:
docs/mockups/s427 corner_bar_board_real.png, Lucy's boots under the bar). Animation item of the session: the camera for the legs.

## Contract
OWNS: scripts/fight3d/BarGuard.gd, tests/bar_guard_test.gd, scripts/fight3d/RingCamera.gd (ONE call line only: it is exactly 500 lines, so remove one comment or blank line elsewhere in the file for each line you add; it must stay at or under 500)
RED_TEST: tests/bar_guard_test.gd -> BAR_GUARD failures=0
REGRESSION: ring_lens_test, corner_lens_test, promo_shot_test, round_board_test
VISUAL: yes (stills on the game's own camera, see below)

## The job
1. Read scripts/fight3d/TvShot.gd (BAR_CLEAR, BAR_DROP_M, FOOT_M, frame_fov, place) and the shot-holding code in RingCamera.gd
   (grep "hold", "TvShot" around lines 158-260). The bar covers the bottom ~16% of the picture: a point below the lens's line of
   sight may only use BAR_CLEAR of the lower half of the picture.
2. BarGuard.gd, pure functions: `BarGuard.lowest_boot(lens_xf, fov, aspect, boots: Array) -> float` = how far the lowest boot sits
   below the bar line, as a fraction of the lower half (0 = on the line, negative = clear); and `BarGuard.fix(lens_xf, fov, aspect,
   boots, dt) -> {raise_m, look_drop_m}` = the smallest bounded correction (at most 0.6 m a second so it never pops) that brings every
   boot clear again: first lower the look point, then raise the lens, never widen the FOV mid-shot (one FOV per shot is a rule).
3. RingCamera calls it once a frame while a shot holds, with both boxers' boot positions (their root y + 0.0, the same two points
   pair_points uses at FOOT_M = -0.2 plus the boots' own world position). A cut still places as today.
4. tests/bar_guard_test.gd (write it first, red on main): (a) a boxer 0.8 m from the lens, the other 2.5 m: boots clear after 1.5 s of
   fix calls at 60 fps; (b) both far: the correction is zero (no drift); (c) the correction never exceeds 0.6 m a second; (d) the
   FOV is unchanged; (e) the head still in frame (HEAD_M).
5. Stills: three shots with a boxer at the lens, saved ONLY through tools/still_framing.gd save_if_framed on the hidden desktop
   (`python tools/hidden_desktop.py run ... tools/fight3d_play.gd`), opened by you: boots above the bar in all three.

## Prior research
docs/FIGHTDISPLAY3_RESULT.md, memory S426/S427 corner bar notes (ops/research), TvShot.gd comments, tools/cam_view_probe.gd.

## What would a human do?
A TV director never lets a boxer's feet drop under the lower third while the cameraman is pulling focus: he tilts up a touch.

## Prefab check
No asset or library applies.

Every Godot job through the queue: `python ops/Tools/godot_slot.py run --who cursor -- <godot.exe> --headless --audio-driver
Dummy --path . --script res://tests/bar_guard_test.gd` (the plain win64 exe, never the console one). Parse first.
RESULT lines for the PR body: `RESULT: tests/bar_guard_test.gd -> BAR_GUARD failures=0`.
