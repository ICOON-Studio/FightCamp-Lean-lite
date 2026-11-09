# REARHAND3 result (S415)

Two skeletons, two rulers. Measure the reach against each one's own arm, not their height.

## (a) Rest-pose numbers

| Skeleton | Body height | Arm length | Hips offset |
|---|---|---|---|
| Game (mh_boxer_10) | 1.397 m | 0.597 m | 0.035 m |
| Raw (source FBX) | 1.541 m | 0.541 m | 0.049 m |

Body height: Head joint above foot joint.
Arm length: shoulder to elbow plus elbow to hand (left arm).
Hips offset: Hips joint above the midpoint between the two thigh joints.

## (b) Control table: ahead-of-hips in both columns

The bar is 0.05 of the ruler (body height or arm length). Game and raw must agree within it.

| Control | Game low_ahead (body) | Raw low_ahead (body) | diff (body) | Game low_ahead (arm) | Raw low_ahead (arm) | diff (arm) |
|---|---|---|---|---|---|---|
| pro_left_jab | 0.218 | 0.272 | 0.054 | 0.509 | 0.775 | 0.266 |
| pro_right_cross | 0.200 | 0.243 | 0.043 | 0.469 | 0.693 | 0.224 |
| pro_left_hook | 0.169 | 0.228 | 0.059 | 0.396 | 0.650 | 0.254 |

Body-height column: bar 0.03, all three miss (0.054, 0.043, 0.059).
Arm-length column: bar 0.05, all three miss worse (0.266, 0.224, 0.254).

The arm-length ruler does not close the gap. The raw skeleton has shorter arms (0.541 m vs 0.597 m), so the same absolute distance becomes a larger share of arm length. The gap widens from 0.04-0.06 of body height to 0.22-0.27 of arm length.

## (c) Right hooks: low-over-hips (this column passed its controls in REARHAND2)

| Clip | Game low_h | Raw low_h | diff |
|---|---|---|---|
| pro_right_hook | 0.019 | 0.042 | 0.023 |
| pro_right_hook_hard | -0.036 | -0.023 | 0.013 |
| pro_right_hook_ft | 0.058 | 0.082 | 0.024 |
| pro_right_hook_hard_ft | 0.083 | 0.099 | 0.016 |
| pro_right_hook_miss | 0.007 | 0.024 | 0.017 |
| pro_right_hook_hurt | 0.017 | 0.038 | 0.021 |
| pro_right_hook_hurt_ft | 0.071 | 0.087 | 0.016 |
| pro_right_hook_special | 0.075 | 0.080 | 0.005 |

Low-over-hips agrees on all eight right hooks (all within 0.03 of body height).

## Stop

The arm-length column does not pass the controls. Per the contract, no section (d) is written. A bar loosened to pass is worth nothing.

The forward vectors are 1 degree apart (game 0.167,0.000,0.986 vs raw 0.157,0.000,0.988), which accounts for under 0.01 of the gap. The remaining 0.22-0.27 of arm length is the hand sitting further in front of the hips on the source skeleton than on the retargeted game skeleton, measured against each one's own arm.
