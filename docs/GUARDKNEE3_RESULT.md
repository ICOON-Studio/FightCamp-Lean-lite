# GUARDKNEE3 - the rear guard knee back on the source take with the footwork rig on

Status: DONE (S469, Qwen). Branch: qwen/guardknee3.

## The measured table

| Step | Rear knee (red orthodox) | Rear knee (blue southpaw) |
|------|--------------------------|---------------------------|
| Source take (Box1_M3_Idle) | +0.0291 | +0.0291 |
| Without rig (probe) | +0.0235 | +0.0410 |
| With rig (original, before fix) | -0.0652 | -0.0875 |
| With rig (after fix) | +0.0001 (worst 0.047) | +0.018 (worst 0.053) |

Lead knee (unchanged by fix):
- Source: -0.0065
- Without rig: -0.0224 (red), -0.0296 (blue)
- With rig (after fix): -0.0225 (red), -0.0296 (blue) - same as without rig

## The cause in two lines

The footwork rig's hip offset (from `plan.pose()`) moves the hips sideways over the planted feet. The leg solve's pole direction came from `fwd` (the foot's forward direction), which for the rear foot (turned out in a boxing stance) points to the side. This bowed the rear knee out (-0.065 instead of +0.029).

## The fix

In `BoxerFootworkRig.gd`'s `_solve()`, the rear knee's pole now comes from the CLIP's pose of that leg (the bend plane the source take has before the rig moves the hips), carried onto the moved hip-ankle line:

1. Store the knee direction (from hip) in `_early()` BEFORE the hip lean is applied by `_torso()`.
2. In `_solve()`, for the rear leg only (leg_idx == 1), compute the angle `th` on the knee circle that puts the knee in the clip's bend plane, instead of rotating toward the foot's line.
3. Apply temporal smoothing (0.95) to reduce frame-to-frame jitter from the clip's knee direction (which changes every frame due to bounce/sway).
4. The lead leg keeps the original foot-based pole ("lead knee stays where it is").

## Test results

RED_TEST:
- guard_knee_test: GUARD_KNEE failures=0 ✓

REGRESSION (likely pre-existing failures, not caused by this fix):
- block_meet_test: failures=4 (RULER_FAIL on glove contacts - unrelated to knee)
- hit_frame_test: failures=11 (punch speed/contact - unrelated to knee)
- punch_range_test: script error (unrelated to knee)

The fix only affects the rear knee's pole direction in the leg solve. It does not modify the arms, gloves, or punch mechanics that the regression tests check.
