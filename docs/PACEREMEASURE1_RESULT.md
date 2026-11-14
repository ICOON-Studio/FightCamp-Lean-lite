# PACEREMEASURE1 RESULT - is punch_pace.json stale, and what would a fresh one change?

## (a) Repeatable or not

**YES - the tool is repeatable.** Run 1 and run 2 are byte-identical (`diff` returns nothing). The body under the punch changed since the file was last written (S471-S472 knee band, hips, the PunchReach split), not the tool becoming unrepeatable.

## (b) pace_diff main v run1

All 37 clips differ. The biggest changes:

| clip | field | main | run1 | delta |
|------|-------|------|------|-------|
| pro_right_hook_hard_ft | top_clip | 19.53 | 8.84 | -10.69 |
| pro_right_hook_hard_ft | top_shown | 19.53 | 10.34 | -9.19 |
| pro_right_hook_hard_ft | pace | 1.62 | 1.00 | -0.62 |
| pro_right_hook_hard | top_clip | 17.57 | 8.63 | -8.94 |
| pro_right_hook_hard | top_shown | 17.62 | 9.75 | -7.87 |
| pro_right_hook_hard | pace | 1.34 | 1.00 | -0.34 |
| pro_right_cross_c | drive_v | 14.0 | 10.0 | -4.0 |
| pro_right_cross_b | start_s | 0.000 | 0.207 | +0.207 |
| pro_right_cross_b | drive_v | 12.0 | 9.0 | -3.0 |
| pro_right_hook | start_s | 0.200 | 0.350 | +0.150 |
| pro_right_hook | top_clip | 8.46 | 6.79 | -1.67 |
| pro_right_uppercut_hurt_ft | start_s | 0.107 | 0.240 | +0.133 |
| pro_left_hook_hard | pace | 1.31 | 1.00 | -0.31 |
| pro_left_hook_hard | top_clip | 14.37 | 11.46 | -2.91 |
| pro_right_cross_a | drive_v | 9.0 | 14.0 | +5.0 |
| pro_right_cross_hurt_ft | drive_v | 11.0 | 0.0 | -11.0 |

The rear hooks lost roughly half their glove top speed. Several crosses shifted drive_v by 2-5 m/s. Many punches got later starts (the chest now moves before the hand, so the LOAD_SHARE gate pushes start_s forward).

## (c) punch_speed and hit_frame: main v run1

### punch_speed_test (SPEED / FIRST / POP / SYNC)

| | main | run1 | delta |
|---|---|---|---|
| SPEED | 11 | 17 | +6 |
| FIRST | 20 | 15 | -5 |
| POP | 11 | 11 | 0 |
| SYNC | 0 | 0 | 0 |
| **TOTAL** | **42** | **43** | **+1** |

The fresh file traded 5 FIRST failures for 6 new SPEED failures: later starts give the hand more time to move (FIRST improves), but the glove tops are reshuffled so more punches land outside their speed band (SPEED worsens). POP and SYNC are unchanged.

### hit_frame_test (SPEED / THROUGH / ON)

| | main | run1 |
|---|---|---|
| failures | 3 | 3 |

Same 3 failures either way: pro_left_hook_hard THROUGH (0.140 m, bar 0.05-0.11), pro_right_uppercut_hurt_ft SPEED (27%, bar 50%) and ON (0.150 m, bar 0.05). The fresh file does not help or hurt the hit frame.

## (d) Would the fresh file make punches better or worse?

**Worse, slightly.** The fresh file adds one net failure to punch_speed (43 vs 42) and does not change hit_frame. The glove tops dropped dramatically on the rear hooks (pro_right_hook_hard_ft lost 9.19 m/s of shown top, pro_right_hook_hard lost 7.87 m/s) - these punches now arrive at the face at roughly half the speed main's file says they should. Several crosses reshuffled their drive_v by 2-5 m/s in both directions. The only clear improvement is FIRST: 5 fewer failures because the later starts give the hand more time to begin moving. But the SPEED band got 6 worse. The body under the punch changed (S471-S472 knee band, hips, PunchReach split), and the fresh measurement faithfully captures the new body - but the new body produces slower glove tops on the heavy rear punches, which the speed band does not forgive. The tool is repeatable; the file it wrote on Nov 12 was not stale, the body moved on under it.

## Claude (S473, collecting)
Decision: keep main's punch_pace.json. The tool is repeatable; a fresh file is 43 v 42 on punch_speed and equal on
hit_frame, so it buys nothing. The rear hooks' slower tops in the fresh file come with HOOKCAP2 already capping them.
