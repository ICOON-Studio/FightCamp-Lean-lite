# DECISIONS

This study covers 28 distinct RamsterZ `(path, start_s, end_s)` windows from `FightClipBinding.BINDINGS`, each retargeted onto all 12 fighter bodies: 336 rows, sampled at 30 fps over each binding window (every sampled frame). The R108 tripwire is 7.21° mean / 19.64° max on the nine-sample f01 control.

The error is spread across the body, not confined to one axis: hips and elbows dominate, with every measured joint contributing non-zero pooled error. The worst pooled joint is `hip_l` (36.81° max). The worst row is `H2H_Haymaker_InPlace.FBX` [0.0, 1.0] on `f04_f_box_middle`, max 36.81°.

Worst reach difference is arm 0.19498 (f10), versus leg 0.09953 (f12). The largest floor penetration is -0.07366 m; the largest float is +0.95537 m (f01). f06 and f08 are retained at their measured 1.00 m mesh scale; no rescaling was applied.

## Ten worst rows by angle_max_deg

| clip | window | fighter | max° | worst joint |
|---|---:|---|---:|---|
| H2H_Haymaker_InPlace.FBX | 0.00–1.00 | f04_f_box_middle | 36.81 | hip_l |
| H2H_Haymaker_InPlace.FBX | 0.00–1.00 | f01_m_box_welter | 34.21 | hip_l |
| H2H_Haymaker_InPlace.FBX | 0.00–1.00 | f05_m_mma_light | 32.88 | hip_l |
| H2H_Haymaker_InPlace.FBX | 0.00–1.00 | f09_m_bare_welter | 30.88 | hip_l |
| H2H_SlipLeft.FBX | 0.00–0.67 | f04_f_box_middle | 30.28 | hip_r |
| H2H_Haymaker_InPlace.FBX | 0.00–1.00 | f06_m_mma_lhw | 29.67 | hip_l |
| H2H_SlipLeft.FBX | 0.00–0.67 | f01_m_box_welter | 28.89 | hip_r |
| H2H_SlipRight.FBX | 0.00–0.67 | f04_f_box_middle | 28.43 | hip_l |
| H2H_Haymaker_InPlace.FBX | 0.00–1.00 | f03_f_box_fly | 28.42 | hip_l |
| H2H_SlipLeft.FBX | 0.00–0.67 | f05_m_mma_light | 27.94 | hip_r |

## Pooled joint error

| joint | mean° | p95° | max° |
|---|---:|---:|---:|
| hip_l | 13.84 | 21.94 | 36.81 |
| hip_r | 9.36 | 19.05 | 31.02 |
| elbow_l | 14.22 | 22.02 | 24.61 |
| elbow_r | 13.74 | 21.95 | 24.24 |
| neck_lean | 8.48 | 17.88 | 18.44 |
| knee_r | 4.30 | 7.24 | 11.00 |
| shoulder_abduction_r | 3.50 | 7.59 | 9.63 |
| shoulder_abduction_l | 3.53 | 7.95 | 9.31 |
| knee_l | 3.93 | 7.07 | 8.45 |

## Per-fighter envelope

| fighter | max° | arm reach | leg reach | floor min m | float max m |
|---|---:|---:|---:|---:|---:|
| f04_f_box_middle | 36.81 | .11015 | .07135 | -.06722 | .94274 |
| f01_m_box_welter | 34.21 | .12839 | .03829 | -.05241 | .95537 |
| f05_m_mma_light | 32.88 | .14991 | .03646 | -.06581 | .87272 |
| f09_m_bare_welter | 30.88 | .14773 | .05098 | -.05893 | .93640 |
| f06_m_mma_lhw | 29.67 | .13361 | .02427 | -.07137 | .84682 |
| f03_f_box_fly | 28.42 | .07061 | .06039 | -.05257 | .89218 |
| f07_f_mma_straw | 27.90 | .09635 | .01043 | -.06618 | .87264 |
| f08_f_mma_bantam | 27.53 | .19349 | .02999 | -.06805 | .84693 |
| f02_m_box_heavy | 26.48 | .14336 | .04125 | -.06640 | .84835 |
| f12_f_bare_welter | 26.08 | .09354 | .09953 | -.05449 | .91766 |
| f10_m_bare_heavy | 24.61 | .19498 | .02159 | -.07366 | .85801 |
| f11_f_bare_feather | 21.99 | .05546 | .05673 | -.05882 | .81836 |
