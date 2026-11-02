## DECISIONS

On non-walk takes, **ours_ue** agrees better with source than ours_c114 (pooled IoU 0.702 vs 0.463).

| take | foot | source_planted | c114_iou | ue_iou | p50 m/s | p95 m/s |
|------|------|----------------|----------|--------|---------|---------|
| muay_thai_straight_knee | RightToes | 7 | 0.00 | 0.00 | 1.92 | 2.16 |
| muay_thai_straight_knee | LeftToes | 13 | 0.00 | 0.00 | 1.64 | 3.74 |
| react_body | LeftToes | 13 | 0.00 | 0.00 | 1.24 | 1.45 |
| kickboxing_body_kick | LeftToes | 22 | 0.00 | 0.00 | 1.07 | 3.28 |
| kickboxing_roundhouse | LeftToes | 22 | 0.00 | 0.00 | 1.07 | 3.28 |
| muay_thai_round_kick | LeftToes | 22 | 0.00 | 0.00 | 1.07 | 3.28 |

Walks (loc_advance, loc_retreat): 124 foot-frames, zero source plants — the in-place stride lifts both toes every cycle, so neither detector should drive the foot lock on locomotion.
