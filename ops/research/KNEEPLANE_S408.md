# The guard knee, measured properly (S408, Claude main)

Answer: on today's guard there is no knock-knee in the numbers or the stills. The game stays within 0.02 of leg length of the source take on every leg. Nothing to fix. PRs #78, #101, #102, #103 closed on this.

## Why the earlier numbers were wrong
S406, KNEERAW1 and KNEERAW2 measured the knee sideways from the ankle. In a wide stance a straight leg reads as "inward", because the hip sits inside the foot. KNEERAW2 also:
- scored walking frames as the guard (its GAME arm played rk_loc_* clips);
- swapped lead and rear for the southpaw (`rig._legs` is already [lead, rear]);
- ran "clip only" with 0 layers switched off, on one process whose settings carried from arm to arm.

## The measure
Knee distance out of the plane through hip, ankle and foot direction, as a share of leg length. + = towards her own midline, taken from which leg it is. A straight slanted leg reads 0. Same maths in `tools/knee_plane_probe.gd` (read inside skeleton_updated, guard clip frames only, one process per setup) and `tools/knee_plane_raw.py` (Blender, source take); each runs a made-up-pose self-check first.

## Numbers (mh_boxer_01 orthodox v mh_boxer_02 southpaw, pro_idle frames)
| | lead | rear |
|---|---|---|
| Source take Box1_M3_Idle (frame 30 on, 20 frames) | -0.0065 | +0.0291 |
| Baked clip, all 16 layers off, red | -0.0148 | +0.0197 |
| Baked clip, all 16 layers off, blue | -0.0138 | +0.0219 |
| Game, red | -0.0220 | +0.0109 |
| Game, blue | -0.0236 | +0.0139 |

Furthest in on any frame: +0.036 (2.7 cm, blue rear). The lead knee sits slightly outward.

Layers: only JoinSmoother + RkJoinFeet change the reading (switching them off gives the all-off row exactly). FootPlant, KneeTrack, BoxerFootworkRig and FloorClear are inactive in the guard (`rig.w` 0.00, influence 0.00), so switching them off changes nothing. That is why a rig fix (#78) could not reach what is on screen.

## Limits
Two bodies, guard frames only: walking clips (rk_loc_*) and punches are not measured. Red's stance looks narrow from the front because the feet are nearly in line: a width question, not a knee one.

## The bar
`tests/guard_knee_test.gd`: mean within 0.03 of the source per leg, no frame further in than 0.06, and the same drawn pose with its knee pushed 8 cm in must trip the bar.
