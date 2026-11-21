# FP2POSE2 - the cross's legs: rear heel, rear foot, foot spacing (owner C454 "wtf is that legs doing")

S536, 2026-11-22. Fight player v2 only (METHOD S510). Round 2 after docs/FP2POSE1_RESULT.md (gaze fixed, legs not).
Follows the S529 step refit's verdict (ops/research/FIGHTPLAYER2_SCOPE_S510.md; a bought take's legs are fixed OFFLINE at
the bake, never by a runtime layer). The owner closes this, not a test.

Tools: `tools/fp2pose2_takes.gd` (each take as baked, no player, own punch line; also the Mixamo candidates),
`tools/fp2pose_probe.gd only=cross` (the v2 player as drawn, every layer on), `tools/cross_legs_bake.gd` (the fix),
`tools/fp2pose_still.gd loop=<take>` (game-camera stills and the loop). Stills and films: `ops/previews/s536_fp2pose2/`.

## The reference (what a real cross's legs do)
Standard coaching, the same in every manual (stated from the coaching literature, e.g. ExpertBoxing's stance and
right-cross guides; not fetched again this session): the feet stay about shoulder width apart across the line and never
cross; the cross is driven off the BALL of the rear foot - the rear heel lifts and the rear foot turns in with the hips
("squash the bug") until the toes point nearly at the target; the rear knee bends and turns in.
A captured reference, measured here with the same ruler: Mixamo `Cross_Punch` - rear ankle 4.7 cm higher over the ball
at the contact, rear foot turned 20 deg (32 at most), rear knee bent to 116 deg, hips turned 54 deg, feet in place.

## 1. Measured BEFORE anything was changed

### The 8 cross takes v2 plays, as drawn in v2 (blue = mh_boxer_01, against the line to the other man)
In his guard before each: feet 34-39 cm apart across the line, 36-42 along it, 50-57 in all; rear toes 55 deg out;
rear ankle 10.0 cm over the ball (flat); rear knee 144-151 deg. Shoulder joints 36 cm apart.

| take (contact) | feet across / along / in all, cm | least across in the take | rear ankle over the ball vs the guard | rear toes off the line | rear knee |
|---|---|---|---|---|---|
| pro_right_cross (0.30 s) | 32 / 39 / 50 | 31 | +1.5 cm | -27 | 163 |
| pro_right_cross_a (0.47) | 36 / 40 / 54 | 31 | +0.7 | -31 | 158 |
| pro_right_cross_b (0.57) | 30 / 37 / 48 | 30 | +0.1 | -37 | 149 |
| pro_right_cross_c (0.38) | 29 / 37 / 47 | 29 | +0.3 | -34 | 153 |
| pro_right_cross_ft (0.53) | 34 / 43 / 55 | 32 | +2.4 | -32 | 160 |
| pro_right_cross_hard_ft (0.53) | 34 / 41 / 53 | 32 | +3.3 | -30 | 163 |
| pro_right_cross_hurt (0.29) | 31 / 43 / 53 | 27 | +0.0 | -40 | 151 |
| pro_right_cross_hurt_ft (0.66) | 29 / 44 / 53 | 29 | -1.8 | -40 | 159 |

What the numbers say:
- **The feet do not cross and are not narrow across the line**: 29-36 cm at the contact, 27 at the least, against
  shoulder joints 36 cm apart. FP2POSE1's reading stands. Nothing to fix there.
- **The rear heel does not lift at the contact**: 0 to 3 cm (one take presses it DOWN 1.8 cm). The takes as baked say
  why: the actor lifts his heel 2-5 cm on 8 of 9 takes, but 0.1-0.4 s AFTER the contact (the follow-through), not as he
  hits. At the contact he is flat-footed.
- **The rear foot barely turns**: 15-28 deg from the guard, most of it the join from the guard's stance into the take's;
  in the take itself 0-20 deg while the hips turn 31-51. It ends 27-40 deg out; a cross ends near 10.
- **The rear knee is straight**: 149-163 deg at the contact. Heel down + knee locked = the stiff back leg in his still.
- **Along the line the stance is short**: 37-44 cm. That is the guard's own length (36-42), not the cross's. Not
  changed here (see "Not fixed").

### The guard's width "23-51 cm" (FP2POSE1)
Alone, back in his guard 0.75 s after each cross, blue stood 34-39 cm across the line and 50-57 cm in all: the foot pins
hold a spread of about 5 cm here, not 28. The wide spread FP2POSE1 quoted was read inside a bout (the pins keep the feet
where the LAST take left them and the takes end 29-41 cm apart). The numbers do not point at the pins for C454, so the
pins are not touched.

### The Mixamo cross takes in his Downloads (candidates), on our body, own punch line
Copied to `E:/FightCamp/packs/mixamo_cross/` (outside the repo, like the steps). 11 takes:

| take | feet in all, start -> contact | rear heel at contact | rear foot turn | rear knee | rear ball travels |
|---|---|---|---|---|---|
| Cross_Punch (0.87 s) | 60 -> 59 cm | +4.7 cm | +20 deg (32 at most) | 124 -> 116 | 3 cm (in place) |
| Cross_Punch__A_Cross_Punch (2.0 s, contact 1.13) | 65 -> 72 | +4.3 | +51 | 127 -> 161 | 7 cm |
| Back_Hand_Cross | 64 -> 73 | +2.5 | steps | 129 -> 106 | 38 cm (a step) |
| the 8 jab-cross combos | 61-65 -> 75-89 | -4 to +4.5 | step | 112-130 | 8-47 cm (steps) |

Only `Cross_Punch` is an in-place cross with clean legs. **Not used as a take**: its actor stands 60 cm wide with the
knees at 124 deg where the Punch PRO stance is 51 cm and 144 deg - the S529 finding again (a take from another man's
stance lunges and dips at every join); it is one take against eight; and the gloves, the contact times, the aim and the
gaze are all measured on the PRO takes. It is used as the REFERENCE for how much heel and how much turn.

## 2. The fix (in v2, at the cause: the takes' rear leg, re-baked)
`tools/cross_legs_bake.gd` -> `assets/anim/baked/v2/mc_Box1_M3_Right_Cross*.res` (9 files, the rear leg's four joints
only), laid over the takes by `scripts/fight3d/v2/CrossLegs.gd` as the v2 library is built (StepClips.load_into: v2 and
its census only - the shipped player keeps the takes as bought). No runtime layer. `-- fp2nocrosslegs` = as bought.

Picture by picture, driven by the take's own hip turn (0 at the start, 1 at the contact, nothing while the take has
the foot in the air, eased at both ends):
- the rear foot turns about its BALL the way the hips turn, to 12 deg off the punch line at the contact;
- the foot pitches up about the ball to 28 deg at the contact (the heel comes up); only what the take does not do by
  that picture is added, so the actor's own later lift is kept;
- the leg is solved again onto the raised, turned ankle under the take's own hips (the knee bends); the toes stay flat.
A take whose hips turn under 35 deg by its contact gets less (x 0.70-0.77 on cross_b, cross_c, cross_hurt).
The ball of the foot does not move (0.0-0.3 mm in the bake), so the foot pin (FootTake pins by the ball) has nothing
new to hold. The hips, trunk, arms, head and lead leg are untouched: the punch lands where it landed.

### After, as drawn in v2 (same run, same body)

| take | feet across / along / in all (at the ankles) | rear ankle over the ball vs the guard | rear toes off the line | rear knee |
|---|---|---|---|---|
| pro_right_cross | 36 / 35 / 50 | +4.6 cm (was +1.5) | -14 (was -27) | 149 (was 163) |
| pro_right_cross_a | 41 / 37 / 55 | +4.5 (0.7) | -18 (-31) | 139 (158) |
| pro_right_cross_b | 36 / 33 / 49 | +3.7 (0.1) | -15 (-37) | 136 (149) |
| pro_right_cross_c | 33 / 34 / 47 | +3.5 (0.3) | -15 (-34) | 139 (153) |
| pro_right_cross_ft | 39 / 39 / 56 | +4.5 (2.4) | -12 (-32) | 145 (160) |
| pro_right_cross_hard_ft | 39 / 39 / 55 | +4.5 (3.3) | -13 (-30) | 158 (163) |
| pro_right_cross_hurt | 30 / 33 / 45 | +3.4 (0.0) | -17 (-40) | 130 (151) |
| pro_right_cross_hurt_ft | 31 / 32 / 44 | +4.1 (-1.8) | -9 (-40) | 131 (159) |

Rear heel up 3.4-4.6 cm on all 8 (the Mixamo reference: 4.7); rear foot turned 37-46 deg from the guard (was 15-28),
ending 9-18 deg off the line; rear knee 130-158 (was 149-163). The spacing is read at the ankles: the rear ankle swings
out and forward over a ball that stays put, so "across" grows 1-6 cm and "along" shrinks 3-12; the feet themselves
stand where they stood.

## 3. Films (game camera, both men head to feet, hidden desktop; opened by me)
- `1_blue_cross_before.jpg` / `2_blue_cross_after.jpg`: pro_right_cross frozen at its contact. Before: both boots
  flat, the back leg a straight post. After: the rear boot is up on its ball, heel off the canvas, the knee bent in.
- `3_loop_cross_before_left_after_right.mp4`: guard -> pro_right_cross -> guard, before on the left, after on the
  right, four times. The heel rises into the contact and settles on the way back; no pop at either join.
- `4_loop_tired_cross_before_left_after_right.mp4`: the same for pro_right_cross_hurt_ft (the take that pressed its
  heel down).
My read: **6 / 10** (the before: 4). The rear leg now does a cross's job. What still holds it under a 7 is below.

## Not fixed, said plainly
- **The stance is short along the line** (36-42 cm in the guard, 32-39 at a cross's contact; a boxing stance is 1 to
  1.5 shoulder widths long, 45-65 cm here), and at the contact the chest is 9-14 cm ahead of the hips: on the side
  camera the two boots sit close under a body that leans past them. That is the GUARD's stance (st_wait / st_wait_g and
  the take's own start), the same thing C458 pointed at; lengthening it means refitting the guard and every punch take's
  lead leg onto a longer stance - its own item, not a cross fix.
- `pro_right_cross_hard_ft`: the rear knee is still 158 deg at the contact (the hips ride high in that take).
- The lead foot is untouched (it stays flat and turns 3-19 deg in, which is right for a cross).
- Rear hooks and rear uppercuts have the same flat rear foot (not measured here); the bake is one table away from them
  (CrossLegs.TAKES) once this one is approved.

## Tests
RED_TEST `tests/player2_test.gd` HEEL (at the contact the rear ankle is 2.5 cm or more higher over the ball than in his
guard, every cross take v2 plays) beside FEET (the feet never cross the line):
- `-- fp2nocrosslegs` (the takes as bought): **FAIL HEEL least -1.7 cm, pro_right_cross_hurt_ft**; failures=1.
- with the re-baked legs: PASS HEEL least 3.6 cm; PASS FEET least 20 cm; PASS GAZE worst 20 deg; failures=0. Landed
  gloves median 0.006 m, 14 of 14 (unchanged); JUMPS 1 and SLIDE 6.70 / 6.99 m are the same DEBT (6.67 / 6.92 before).
Regression: choreographer_test failures=0, arm_build_test failures=0, file_limits_test failures=0.

## Prefab check
Mixamo cross takes measured (above): none taken into the repo; `Cross_Punch` served as the captured reference only.
