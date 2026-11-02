# C102 — Silhouette-matched rest study

## DECISIONS

Per-joint pooled mean OFF → ON (degrees): elbow_l 14.219 → 0.384; elbow_r 13.736 → 0.401; knee_l 3.929 → 0.077; knee_r 4.298 → 0.104; shoulder_abduction_l 3.526 → 0.086; shoulder_abduction_r 3.501 → 0.095; hip_l 13.838 → 1.617; hip_r 9.362 → 1.102; neck_lean 8.484 → 0.277.

Pooled mean across all joint observations: 8.321° OFF → 0.460° ON. Zero of 336 rows got worse. A silhouette-matched rest removes most of the retarget error; the constant rest offset was the dominant measured failure.

The adjustment does not fix C101’s motion component: residual ON maxima remain 14.001° at hip_l and 11.646° at hip_r. It also does not restore Q82’s dropped position tracks.

## Gate evidence

- R108 tripwire: 7.21° mean / 19.64° max.
- 336 rows generated.
- OFF row-by-row comparison to `C100_retarget_by_frame.json`: 0 mismatches over 0.01° for mean or max.
- `C102_check.py`: pass.

## Pooled joint metrics

| Joint | OFF mean | OFF p95 | OFF max | ON mean | ON p95 | ON max |
|---|---:|---:|---:|---:|---:|---:|
| elbow_l | 14.219 | 22.017 | 24.611 | 0.384 | 1.163 | 1.414 |
| elbow_r | 13.736 | 21.948 | 24.238 | 0.401 | 1.223 | 1.501 |
| knee_l | 3.929 | 7.068 | 8.447 | 0.077 | 0.235 | 0.363 |
| knee_r | 4.298 | 7.237 | 10.999 | 0.104 | 0.222 | 0.304 |
| shoulder_abduction_l | 3.526 | 7.952 | 9.311 | 0.086 | 0.284 | 0.334 |
| shoulder_abduction_r | 3.501 | 7.588 | 9.631 | 0.095 | 0.354 | 0.380 |
| hip_l | 13.838 | 21.935 | 36.812 | 1.617 | 4.071 | 14.001 |
| hip_r | 9.362 | 19.050 | 31.021 | 1.102 | 2.912 | 11.646 |
| neck_lean | 8.484 | 17.876 | 18.438 | 0.277 | 0.498 | 0.514 |

## Per-fighter mean

| Fighter | OFF | ON |
|---|---:|---:|
| f01_m_box_welter | 8.256 | 0.424 |
| f02_m_box_heavy | 10.075 | 0.431 |
| f03_f_box_fly | 6.119 | 0.494 |
| f04_f_box_middle | 9.224 | 0.461 |
| f05_m_mma_light | 11.376 | 0.521 |
| f06_m_mma_lhw | 9.444 | 0.742 |
| f07_f_mma_straw | 5.780 | 0.491 |
| f08_f_mma_bantam | 8.937 | 0.458 |
| f09_m_bare_welter | 9.223 | 0.401 |
| f10_m_bare_heavy | 9.662 | 0.570 |
| f11_f_bare_feather | 4.607 | 0.536 |
| f12_f_bare_welter | 6.873 | 0.472 |

## Worse rows

None: no row had an ON mean greater than its OFF mean, so there are no ten worse rows to list.

The source side stayed exactly C100’s source globals. Only the fighter rest was silhouette-adjusted, then the ordinary `BoneRestFixer.pose_frame` correction was applied.
