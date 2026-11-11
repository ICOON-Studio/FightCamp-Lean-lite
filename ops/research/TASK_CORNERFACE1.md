# TASK CORNERFACE1 - QWEN (qwen3-coder) - the corner minute's camera keeps the boxer's face in the open part of the screen

Model: qwen3-coder
Discipline: boxing (the demo).

## The operator's words (S430)
"not sure why in all profiles and corner pictures the camera cuts the face , is it that hard to make a proper camera
adjustment for all profile to show up correctly ?"
Seen by Claude on a real still (docs/playtest/S430/corner_fight_so_far.png): the corner card covers the right two thirds
of the frame and the camera stands behind the boxer's shoulder: the face is out of the picture, only the back of the head
shows.

## Contract
OWNS: scripts/fight3d/CornerShots.gd, scripts/fight3d/CornerMinute.gd (shot choice and timing only),
tests/corner_face_test.gd (new), tools/corner_face_probe.gd (new), docs/CORNERFACE1_RESULT.md (new)
RED_TEST: tests/corner_face_test.gd -> CORNER_FACE failures=0   (red on main first: paste both runs)
REGRESSION: corner_lens_test, corner_card_test, corner_warm_test, corner_crew_bodies_test, fight_flow_test
Run one test: `python ops/Tools/godot_slot.py run --who qwen -- "%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tests/<name>.gd`
Parse first: the same command with `--check-only --script res://<file>`. Do NOT touch scripts/fight3d/RingCamera.gd
(CAMLINE1) or the corner card's layout (scripts/fight3d/CornerOverlay.gd).

## The job
1. THE RULER, on the game path (the real CornerMinute run by the real FightView, the way `tests/corner_lens_test.gd` boots
   it): for every shot of the minute, at its start, middle and end, project the boxer's head to the screen: the head
   bone's position with a 12 cm radius (top, chin, both ears) and the nose point 10 cm in front of the head bone along
   the face's forward. A shot PASSES when
   (a) all five points are inside the frame between the letterbox bars;
   (b) while the corner card is up, all five are inside the OPEN area, the part of the frame the card does not cover
       (read the card's real rect, do not type it), with 40 px to spare;
   (c) the camera sees the face and not the back of the head: the dot of the camera-to-head direction with the face's
       forward is below -0.2.
   The cut-away to the other corner is judged on the other boxer. Print one line a shot: name, the five points, pass or
   fail and why. Red on main.
2. THE FIX: the shots while the card is up frame the boxer's face in the open area: move and aim the camera (position,
   look-at, the frame's horizontal shift), never by shrinking the card. The slow drift stays inside the passing band. The
   coach may share the open area but never covers the boxer's face (project his head too and keep the two apart).
3. `tools/corner_face_probe.gd`: the same lines for ten seeds and both corners (red and blue stool), so one lucky pose is
   not the proof.
4. Result page: the table before and after, the shots you changed and the numbers.

## Stills
A windowed run on the hidden desktop (`tools/fight3d_play.gd` with `end=corner hold=6`) writes the corner stills; Claude
reads them at collect. Two different boxers (stats, style, frame), never twins.

## Prior research
`python ops/Tools/prior_research.py corner lens camera face`. `ops/research/TASK_CORNERLENS1.md`,
`ops/research/TASK_CORNERCAM1.md`, `tests/corner_lens_test.gd` (what it measures today, and why it is green while the face
is cut).

## What would a human do?
A TV director puts the camera in front of the stool, a little to the side the graphics leave free, eyes on the upper
third. Nobody shoots the back of a boxer's head while the trainer talks to the face.

## Prefab check
Nothing to fetch.

## The one trap
The first finding is why `corner_lens_test` is green today. If your new ruler is green on main, it is blind too.

End the PR body with `RESULT: tests/corner_face_test.gd -> CORNER_FACE failures=0`.
