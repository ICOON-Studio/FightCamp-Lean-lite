# TASK OFFERFACE1 - GROK DEV - the offer letter's opponent picture keeps the whole head

Status: OPEN (nightly review 2026-11-22, Claude). Discipline: boxing. Model: Grok Dev default.
Source: nightly 2026-11-22, face_frame_test red since b81ae44c4 (S535 OFFERBUILD1, the bout offer as the host club's letter).
Defect fix on an approved screen: keep the letter's layout and the slot size; only where the picture sits inside the slot changes.

## The defect (from the log)
`bout | .../BoutPage/OfferPage/.../OfferOpp/.../OppArt/Body | mh_boxer_13.png 600x800 | 330x640 | covered | 181,7 237x365 | 183,178 172x195 | FAIL`
The slot shows picture pixels x 181..418, y 7..372. Boxer 13's head box is x 183..355, y 178..373. The rule (FACEFRAME1)
is the whole head plus 6% of its height on every side: the chin (373) and the left cheek (183, needs 171) are cut.
Cause: `scripts/ui/OfferSides.gd` `_portrait()` (~line 283) places every body picture at a fixed `position = (-70, -6)`,
`size = (330, 640)` inside `PORTRAIT = (190, 292)`. Each picture's head sits somewhere else, so a fixed offset cannot hold.

## Contract
OWNS: scripts/ui/OfferSides.gd (`_portrait` only; the file stays under 500 lines)
RED_TEST: tests/face_frame_test.gd -> PASS face_frame_test (FACE_FRAME failures=0)
REGRESSION: bout_offer_letter_test, versus_test, p4p_coach_read_test, camp_slate_test, file_limits_test
VISUAL: yes - a still of the offer page through tools/layout_snapshot.gd on the hidden desktop; Claude opens it beside
ops/previews/s535_offer_mockup/built/12_bout_real.png.

## Prior research
`python ops/Tools/prior_research.py face frame portrait`. FACEFRAME1 built `scripts/ui/FaceFrame.gd` (box_for(tex) reads the
head box from scripts/ui/face_boxes.json; window() picks a frame that holds it). docs/OFFERBUILD1_RESULT.md describes the letter.

## What would a human do?
Look at the opponent on the letter and see his whole face, hair to chin, with the shoulders below it fading into the slate.

## Prefab check
None: FaceFrame.gd is ours and already does the maths.

## Do
1. Run face_frame_test on main: it must fail on the bout row above.
2. In `_portrait`, keep the scale (0.8 of the 600x800 picture, head to waist) and place the picture from its head box
   (`FaceFrame.box_for`): the head plus its 6% margin inside the 190x292 slot, the head as high as it can sit. A picture
   with no head box keeps today's offset.
3. Run REGRESSION. Do not change any number or threshold in an existing test; if one goes red, stop and say what it measured.

## Rules for this seat
Godot only through `python ops/Tools/godot_slot.py run --who grok -- ...`, headless, `--audio-driver Dummy`. Nothing opens on
screens. Nothing outside OWNS. PR body: `RESULT: tests/face_frame_test.gd -> PASS face_frame_test`.

## The one trap
Do not zoom to a face crop (FaceFrame.fit): the owner approved a head-to-waist picture. Move it, do not rescale it.
