# TASK FACEFRAME1 - CURSOR (Grok 4.7 High) - every face picture in the menus shows the whole head

Model: Grok 4.7 High
Discipline: boxing (the demo).

## The operator's words (S430)
"not sure why in all profiles and corner pictures the camera cuts the face , is it that hard to make a proper camera
adjustment for all profile to show up correctly ?"

## Contract
OWNS: a new shared helper scripts/ui/FaceFrame.gd, the call sites that draw a face or head-and-shoulders picture (list them
in the result page before you change them), tests/face_frame_test.gd (new), docs/FACEFRAME1_RESULT.md (new)
RED_TEST: tests/face_frame_test.gd -> FACE_FRAME failures=0   (red on main first: paste both runs)
REGRESSION: faces_test, promo_shot_test, roster_cards_test, home_look_test, fight_poster_test, words_on_screens_test
Run one test: `python ops/Tools/godot_slot.py run --who cursor -- "%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tests/<name>.gd`
Parse first: the same command with `--check-only --script res://<file>`. No script over 500 lines.

## The job
1. CENSUS first, no fix: every place the game draws a person's face (grep `Faces.`, `PromoShot`, `RosterCards.body`,
   `FaceFill`, `FighterFace`, `face/studio`, `face/poster`, `mh_staff`, the guide's portrait, the tape room, the bout page,
   the poster, Home rows, the roster cards, the fighter page, the week review, the corner card's figure). For each: the
   file and line, the picture's source size, the control's size at 1920x1080, the stretch or crop used, and the part of
   the picture that is really visible (a rect in picture pixels). Print it as a table from the test and paste it.
2. THE RULER: each source picture needs a HEAD BOX (top of hair to chin, ear to ear) in picture pixels. Find how the
   pictures were made (the studio and poster sets were rendered by a tool in `tools/`: read it for where the head sits).
   You cannot see images, so derive the box from that tool's camera numbers, or by scanning the picture's pixels in a
   script (alpha or background colour). Store it once per picture SET in one small data file and say which way you used.
   A place PASSES when the whole head box plus a margin of 6% of its height lies inside the visible rect. Red on main.
3. THE FIX: one helper, `FaceFrame.fit(control, head_box, size)`, that sets the crop so the head box is whole and sits a
   little above the middle, for any slot shape (square, tall, wide, round). Every call site uses it; no call site keeps
   its own crop numbers.
4. Result page: the census table before and after, the head boxes and where they came from, the rect of every slot.

## Not in this task
The 3D corner-minute camera (TASK_CORNERFACE1, Qwen). The fighter's full-body 3D figure on the Overview.

## Stills
You cannot see pictures: Claude renders the real screens at collect and reads them. The test is the only thing you can
trust, so it must measure the visible rect the way the engine really crops (stretch mode, region, clip, the round mask).

## Prior research
`python ops/Tools/prior_research.py portrait face crop promo`. The portraits were re-shot in S421 (`assets/ui/face/studio`,
`assets/ui/face/poster`).

## What would a human do?
A photo editor crops every head shot to one rule: eyes on the upper third, nothing of the head cut. One rule, applied by
one tool, to every frame in the magazine.

## Prefab check
Nothing to fetch.

## The one trap
A test that checks the helper's arithmetic and never asks the real screen which pixels are visible passes while faces are
still cut. Build each real screen through `Main.act` and read the real controls.

End the PR body with `RESULT: tests/face_frame_test.gd -> FACE_FRAME failures=0`.
