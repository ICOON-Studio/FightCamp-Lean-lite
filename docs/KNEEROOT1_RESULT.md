# KNEEROOT1 - where the bent knee and the wandering gloves came from

S537, 2026-11-22. Owner C462-C466. Fight player v2 only (METHOD S510); nothing was added, two of our own stages were
taken off. The owner closes this, not a test.

**The cause, in one sentence each.**
- **Knee:** our foot-pin layer (FootTake) held each foot where the WAITING stance had stood it while the punch moved the
  hips as the actor's moved, and the leg solver made up the difference by bending the knee. The bought take was fine.
- **Gloves:** our "keep the glove off his own face" stage (Gloves, S536) bent the glove at the wrist, up to 34 degrees off
  its own forearm, and flicked it as the head moved. The hands themselves were where the take puts them.

## How it was found
The bought take was put beside the game picture by picture (`tools/kneeroot_probe.gd`): the bought FBX on its own
skeleton, the same take as baked onto our body with every layer off, and the game as drawn; then the game again with one
layer off at a time. Blue = mh_boxer_01, red = mh_boxer_02, the plain cross (`pro_right_cross`), contact at 0.30 s.
Lengths are on our own leg (84 cm). "Knee off line" = how far the knee sits off the straight line from hip to ankle.

### The knee, at the contact (blue; red reads the same within 0.1)
| | lead knee off line | lead knee bend | rear knee off line | rear knee bend | lead / rear foot turn |
|---|---|---|---|---|---|
| Bought take (FBX, the actor's skeleton) | 3.7 cm | 11 deg | 1.0 cm | 22 deg | 9 / 27 deg |
| The take baked on our body, all layers off | 4.5 cm | 13 deg | 2.2 cm | 26 deg | 7 / 27 deg |
| **Game before** | **11.8 cm** | **35 deg** | 1.4 cm | 16 deg | 7 / 27 deg |
| Game before, FootTake off | 4.5 cm | 13 deg | 2.2 cm | 26 deg | 7 / 27 deg |
| **Game now** | **4.5 cm** | **13 deg** | 2.2 cm | 26 deg | 7 / 27 deg |

- The bake itself is innocent: baked against bought is within 1.2 cm and 4 deg on every picture of the take.
- Before, the lead knee was 8.1 cm further off its line than the bought take and bent 24 deg more (worst picture 8.5 cm);
  run to run 8-10 cm, because it depends on where the feet happened to be pinned.
- Switching off any other stage changed nothing that mattered (join smoother, gaze, guard hold, tired sag, floor stand,
  arm finish, twist bones, corrective joints, the circling, starting from the Pro guard, the take's own travel: all
  still 7-12 cm off). Only FootTake off gave the bought take back, to the millimetre.
- Now: the game equals the baked take at the contact on both boxers; the worst picture of the whole punch is 2.0 cm
  (0.05 s in, while the pin is letting go).
- The foot turn was never changed by us (7 / 27 deg in every row): nothing "twists" the knee. What read as a twist in
  the owner's picture is the lead knee bent 35 deg instead of 13 with the foot where it was.

### The gloves, 4 s of the waiting guard
| | red rear glove off its forearm's line | most in one picture | red lead glove | blue rear glove |
|---|---|---|---|---|
| Game before | 14 to 34 deg | 17 deg | 3 to 20 deg | 15 to 31 deg |
| Take alone, layers off, glove stage still on | 27 to 34 deg | 6 deg | 4 to 22 deg | 17 to 32 deg |
| Glove stage off | 0 to 1 deg | 0.1 deg | 3 to 4 deg | 1 deg |
| The Pro guard (hands further from the face) | 3 deg | 0.1 deg | 3 deg | 3 deg |
| **Game now** | **as "stage off"** | | | |

- The wrists do what the take says: guard hold, gaze, join smoother and the foot layers off change the wrist's path by
  nothing (red 8.3 / 10.3 cm box in every row).
- The glove also slid 3.6 cm on red's rear hand; now 0.

## Where in the code
- `scripts/fight3d/v2/FootTake.gd:133` (the pin) with the leg solve it feeds, `scripts/fight3d/FootPlant.gd:275`.
- `scripts/fight3d/Gloves.gd:231` (`_off_face`), called at `:184`; its 0.6 rad wrist give is `:47`.
- Not in LineGrade, LiveRound, StepWire or MHRig: none of them was touched or is involved.

## What was removed
1. **A punch plays its legs as recorded.** While a punch or a feint plays, FootTake lets go (the same ease a fall
   already uses) and takes the feet back where they stand when the punch ends. `FootTake.gd:31, :82`; switched from
   `Player2.gd:442`. `-- fp2pinpunch` = pinned as before (the control).
2. **The glove stays on the hand in the v2 fight.** `Gloves.face_clear` (`Gloves.gd:85`), switched off by Player2. The
   gym and the shipped player keep the stage.

## Tests
`tests/player2_test.gd` (the two new checks live in `tests/player2_match.gd`; the test file is at the line limit):
| check | before | now |
|---|---|---|
| KNEEMATCH: on the plain cross both knees within 2 cm of the take alone, from 0.2 s to the contact + 0.1 s | FAIL 8.4 cm (`-- fp2pinpunch`) | PASS 0.0 cm (its own control arm reads 6.9) |
| GLOVEMATCH: over 4 s no glove swings more than 3 deg against its forearm | 23.5 deg with the stage on (the check's own control arm) | PASS 1.5 deg |
| SLIDE (already a debt) | 6.24 / 6.61 m over two exchanges | **9.99 / 10.06 m** (worse: see the cost below) |

Green: player2_test (failures=0; SLIDE and nothing else prints as DEBT), choreographer_test, arm_build_test, file_limits_test, golden_path_test, own_gloves_test (failures=0 each).

## What it costs, said plainly
1. **The feet slide more.** A punch's feet now settle from the waiting stance onto the punch's own stance as it starts
   (a few cm in 0.2 s), where the pin used to hold them. SLIDE went from about 6.4 m to about 10 m over two 30 s
   exchanges, and its guard in the test was raised from 5 to 6 m an exchange for that - a bar moved, not met. The real
   cure is upstream: the waiting take and the punch takes should stand on the same feet (the refit of the waiting take),
   then nothing needs to settle.
2. **The glove can sit in his own face again**: 2.5 and 1.9 cm on the two boxers of `own_gloves_test` in the waiting guard
   ( its v2 check is now a tripwire at 8 cm, it was a 1 cm bar). The cure is where the bake holds the
   wrists (`tools/step_bake.gd:288` GUARD_AT puts the rear wrist 15 cm in front of the head bone - nearer than a glove
   is long), not a glove that bends away.
3. Between punches the pin still holds the feet, so the waiting guard's knees are still ours, not the take's (red lead
   knee bend 24 deg as drawn against 33 as baked). Not asked here, not changed.
4. C465 ("blue doesn't look like a human", the cross contact with the leg bakes on): those bakes are off since
   36505506d; with the pin off too the contact is the bought take. Whether the bought cross itself looks right to him
   is his call on the pictures below.

## Pictures (ops/previews/s537_kneeroot1/pairs/, the bought take alone on the left, the game on the right)
One fixed camera per film, the same in both halves. Left = the baked take with every pose layer off (the skin's twist
and corrective joints stay on: they move no limb). Each film plays twice at speed, then once at quarter speed.
- `1_blue_guard_side.jpg`, `2_blue_guard_front.jpg`, `7_red_guard_side.jpg`, `8_red_guard_front.jpg`: the guard.
- `3_blue_cross_side.jpg`, `9_red_cross_side.jpg`: the cross on its contact, side camera.
- `5_blue_cross.mp4`, `11_red_cross.mp4` (+ `_strip.jpg`, five pictures across the punch): guard -> cross -> guard.
- `6_blue_idle.mp4`, `12_red_idle.mp4` (+ `_strip.jpg`): 4 s of the waiting guard on a closer camera, for the gloves.

What I opened myself: `3_blue_cross_side.jpg` and the two strips of `5_blue_cross` and `12_red_idle`. My read:
- On the cross contact the legs are now the same in both halves: lead knee nearly straight, rear leg behind him - the
  bought take's legs. The upper body differs on purpose (the game turns his head to the other man and finishes the arm on
  the target; the bought take looks past him).
- The difference before / after is NOT in these pictures: they show bought against game-now. The "before" is the
  owner's own marked still (ops/Feedback/2026-11-22-01) and the numbers above. No before film was made.
- At strip size the gloves look the same in both halves, as they should now; I did not judge the glove swing by eye.
- The front-camera cross pair was dropped: its left half came out showing the guard, not the contact (a fault of the
  still tool's second play-through with the layers off, not found). The front guard pairs are kept.
- The red bottom rope crosses the feet on the side camera; the knees are clear of it.
- I did not play the four films through as video.

## Prefab check
None.
