# TASK PRESSFLASH1 - crowd camera flashes never read as a hit in empty air

Status: OPEN (S497, Claude main). Discipline: boxing. Model: Grok Dev.

## Why now
FIGHT MOTION WEEK (owner S496: "The fight looks terrible should we stop this project?"). Two blind critics scored the
filmed bout 4/10 and BOTH read the crowd's camera flashes as fake impact flashes: "the flash is above red's head while
blue's hand is at waist height ... flash at blue's waist with no glove near ... flash out by the ring post ... Every one
of these tells the viewer 'this is fake'." The flashes are `scripts/fight3d/CrowdFlashes.gd` (camera flashes on crowd
seats; a big shot calls `burst(9)` from `HitImpact.gd`). Seen through the ring they sit next to the boxers.

## Read first
- `scripts/fight3d/CrowdFlashes.gd` WHOLE (141 lines): `_fire()` picks a seat (`near` rows 70 % of the time), prefers
  one inside the camera's frustum, shows a billboard star for FLASH_S.
- `tests/crowd_flashes_test.gd` (how the test builds seats and steps the node).

## What to build (CrowdFlashes.gd only, stay under 200 lines)
1. A pure helper `static func clear_of(p_screen: Vector2, boxes: Array, pad: float) -> bool`: true when the screen
   point is outside every `Rect2` in `boxes` grown by `pad` pixels.
2. `var keep_off: Callable` (default empty): when set it returns an Array of `Rect2` in viewport pixels (the two
   boxers' screen boxes). In `_fire()` a seat is taken only if its screen point (`cam.unproject_position`) is
   `clear_of` those boxes with `KEEP_OFF_PX := 90.0` (at 1280x720; scale by viewport height / 720). Up to 12 tries; if
   none is clear the flash is SKIPPED this time (never fired next to a boxer). `var skipped := 0` counts them.
3. A flash is a crowd camera, not a hit: its star is at most `MAX_PX := 46.0` wide on screen (scale the node down for
   a seat close to the lens), and a burst's flashes come from at least 4 different seats.
4. `scripts/fight3d/RingSet.gd` (or wherever `flashes` is made - find it with grep): set `flashes.keep_off` to a
   Callable returning the two boxers' screen boxes: for each boxer the box of her Head, Hips, both Hands and both
   Feet bone positions (`skel.global_transform * skel.get_bone_global_pose(i).origin`) unprojected by the current
   camera. Add at most 15 lines there.
5. Extend `tests/crowd_flashes_test.gd`: `clear_of` truth table (inside, inside the pad, outside), and a fired flash
   with `keep_off` covering every seat's screen point is skipped (`skipped` grows, `fired` does not).

## Contract
OWNS: scripts/fight3d/CrowdFlashes.gd, tests/crowd_flashes_test.gd, scripts/fight3d/RingSet.gd
RED_TEST: tests/crowd_flashes_test.gd -> clear_of
REGRESSION: hit_flash_test, file_limits_test
VISUAL: yes - Claude films the bout on the PC and checks that no flash sits within a glove's width of a boxer; not merged before.
NOT YOURS: every other file. Never delete or weaken a test. Work on your own branch, open a PR into main, never merge.
Run one test: `godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd` (Godot 4.7.2).
Never `tools/run_tests.sh`. The 3D fight only exists with a picture: do not try to film it on your box.
PR body: `RESULT: tests/crowd_flashes_test.gd -> <its pass line>` and one RESULT line per regression test.

## Prior research
CrowdFlashes.gd header (S447: made in the game, seats in view preferred). The critics' text:
`E:/FightCamp/tmp/fightweek/r0/critic_coach.md` (quoted above).

## What would a human do?
On TV the press flashes are small, far and in the stands; a flash right beside a boxer's head is read as the hit spark.
A broadcast keeps the ring picture clean and lets the crowd sparkle around it.

## Prefab check
None: our own billboard pool.

## The one trap
`keep_off` is read only when a camera exists (`is_inside_tree()` and `get_viewport().get_camera_3d() != null`); the
headless tests have no camera, so without one today's behaviour must stay exactly as it is (the existing test lines
must pass unchanged). If RingSet.gd would pass 500 lines, put the Callable in a small new file instead and say so.
