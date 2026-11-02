# DECISIONS

Population: 28 RamsterZ binding windows × 12 fighters, sampled at 30 fps (3,024 window × fighter × joint rows and 108 fighter × joint splits across nine R108 joints). The corrected metric is C100's unsigned angle between the two segments; signed error is source angle − retargeted angle.

The corrected result is predominantly constant offset for eight joints: pooled constant part exceeds motion part for both elbows, both knees, both shoulders, hip_l, and neck_lean. hip_r is the exception and needs IK. The largest pooled motion part is hip_r at 8.06°, below C100's largest per-joint error as required. These conclusions replace the first delivery's verdict.

| joint | constant part (deg) | motion part (deg) | offset share |
|---|---:|---:|---:|
| elbow_l | 14.22 | 5.10 | 88.6% |
| elbow_r | 13.74 | 4.90 | 88.7% |
| knee_l | 3.93 | 2.00 | 79.4% |
| knee_r | 4.29 | 1.73 | 86.0% |
| shoulder_abduction_l | 3.36 | 2.45 | 65.3% |
| shoulder_abduction_r | 3.38 | 2.45 | 65.5% |
| hip_l | 12.99 | 7.28 | 76.1% |
| hip_r | 7.60 | 8.06 | 47.1% |
| neck_lean | 8.38 | 6.08 | 65.5% |

The offset share is constant² / (constant² + motion²), pooled frame-weighted across fighters. It is a decomposition of the corrected signed error, not the unsigned C100 error.

Rest-offset prediction was tested per fighter by Pearson correlation between |rest_offset_deg| and constant_part_deg, with mean absolute error (MAE) between those magnitudes:

| joint | correlation r | MAE (deg) | interpretation |
|---|---:|---:|---|
| elbow_l | 0.97 | 1.91 | closely predicts the constant component |
| elbow_r | 0.97 | 2.12 | closely predicts the constant component |
| knee_l | 0.99 | 0.22 | very closely predicts the constant component |
| knee_r | 0.93 | 0.47 | closely predicts the constant component |
| shoulder_abduction_l | 0.88 | 0.74 | closely predicts the constant component |
| shoulder_abduction_r | 0.72 | 1.08 | moderately predicts the constant component |
| hip_l | 0.75 | 7.27 | directionally predicts, but not its full magnitude |
| hip_r | 0.60 | 2.65 | weak/moderate proxy; motion is larger |
| neck_lean | 1.00 | 0.56 | very closely predicts the constant component |

Per-joint conclusions:

- elbow_l: a rest correction would remove most of this.
- elbow_r: a rest correction would remove most of this.
- knee_l: a rest correction would remove most of this.
- knee_r: a rest correction would remove most of this.
- shoulder_abduction_l: a rest correction would remove most of this.
- shoulder_abduction_r: a rest correction would remove most of this.
- hip_l: a rest correction would remove most of this constant component; the remaining motion is smaller but still present.
- hip_r: this needs IK.
- neck_lean: a rest correction would remove most of this.

The nine-sample f01_m_box_welter / H2H_HitReaction01.FBX tripwire reproduced C100 at 7.2110° mean and 19.6378° maximum (required 7.21° / 19.64° within ±0.05°).
