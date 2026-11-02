# Q217 - Close-range boxing moves certified under G147

## Method
Spine forward lean (25°) enlarges the torso envelope so _clearance_spacing pushes the opponent
further back. Hips yaw (25°) staggers the lead legs laterally. Together they eliminate the LEG
capsule overlap at close range. Layer timing: peak_s=0.6, hold_s=0.2, to_s=2.01 (covers exit).

## boxing_lead_uppercut - CERTIFIED 4/4 (rear-glove layer added)

| rig | gap m | G147 worst cm | pin pops | target | onset |
|-----|-------|---------------|----------|--------|-------|
| welter_a vs welter_b | 0.855 | 0 | 0 | pass | pass |
| welter_b vs welter_a | 0.830 | 0 | 0 | pass | pass |
| heavy_c vs heavy_d | 0.907 | 0 | 0 | pass | pass |
| heavy_d vs heavy_c | 0.890 | 0 | 0 | pass | pass |

Q213 mode=clips pin=1: failing=0, worst_cm=7.81, PASS.
Baseline was: gap 0.70m, LEG 20 cm worst, g147_clipping on all 4 rigs.
Pose layer: Spine [25,0,0] + Hips [0,25,0] + RightUpperArm [15,-2,-4] + RightLowerArm [3,0,0] + RightShoulder [3,0,0].
Rear-glove layer keeps the rear hand near the chin during the strike (solved by target, cost 0.72 → 0.009).
Certificate: q217_lu_rg3_bound.json (54325ed8).
Side still: pending (render timed out).

## Remaining moves (same approach: Spine lean + Hips yaw pose layer)
- boxing_inside_uppercut: same clip, faster warp (0.55). Needs per-move angle tuning.
  At 25/25: rig 2 LEG 3.4 cm fail. At 30/30: rig 3 LEG fail, rig 4 pin_pops=25.
- boxing_rear_hook, boxing_rear_hook_body, boxing_shovel_hook, boxing_lead_hook: not started.
