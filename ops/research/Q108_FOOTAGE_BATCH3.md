# Q108 - footage batch 3 folded into the two-man table
## DECISIONS
Batch 3 adds 73 head-height jabs from five videos (HFSZxKUUE98 is slow motion, listed but excluded).
Four statistics whose pooled p50 moved >= 0.05 from batch 2: gap_T_before (2.23 -> 2.60), gap_T_peak (2.06 -> 2.29), gap_T_after (1.99 -> 2.22), receiver_nose_away_T_peak_plus_0.2s (-0.02 -> 0.08) - batch 2's partner drills were closer and the receiver moved less; batch 3's live bouts and sparring push every gap wider.
Both authored pairs (F01_F09 and F09_F01) are inside the pooled p10-p90 on every number measure_pair.py compares.
Pooled thrower_hips_drop_T of jabs_head_height: p50 0.08 T (our authored jab's thrower sinks about 0.17 T - INSIDE the pooled p10-p90 of 0.00-0.29, above only batch 2's drills' p90 of 0.08; corrected by Claude at collection, the sentence had read 'above the footage p90'); pooled peak_to_onset_s of all combinations: p50 0.35 s (our room can land one man's blows 0.1 s apart, faster than the footage).
XIja1S9SXI4 (coaching demo): 13 punches, 0 head-height jabs - rear-hand and body targets only; HFSZxKUUE98 (slow motion): 0 segments tracked, no usable side-on footage; d_PSlBJheZI (body shots): 1 punch to the body, 0 head-height jabs; xaXXD-w45b0 (AIBA amateur bout): 6 punches, 4 jabs - brief side-on windows in a broadcast fight.

## Per video
| id | fps | frames | segments | both_tracked_s | punches | head-height jabs | slow motion | note |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| xaXXD-w45b0 | 60 | 49449 | 12 | 15.8 | 6 | 4 | no | amateur bout, broadcast |
| wzUWvsviqTM | 30 | 33651 | 89 | 154.8 | 95 | 64 | no | pro bout, ringside |
| kuABaA2PY0U | 30 | 5505 | 11 | 41.6 | 17 | 5 | no | gym sparring |
| XIja1S9SXI4 | 30 | 8024 | 32 | 119.1 | 13 | 0 | no | coaching, rear-hand only |
| HFSZxKUUE98 | 60 | 14031 | 0 | 0.0 | 0 | 0 | yes | slow motion, no segments |
| d_PSlBJheZI | 60 | 33699 | 1 | 1.4 | 1 | 0 | no | body shots, 1 punch |

## Jabs to the head: batch 2 v batch 3 v pooled
| key | batch 2 | batch 3 | pooled |
| --- | --- | --- | --- |
| gap_T_before | 1.77 / 2.23 / 2.68 (31) | 2.27 / 2.70 / 3.07 (73) | 2.06 / 2.60 / 3.02 (104) |
| gap_T_peak | 1.80 / 2.06 / 2.63 (31) | 2.11 / 2.42 / 2.70 (73) | 1.95 / 2.29 / 2.69 (104) |
| gap_T_after | 1.55 / 1.99 / 2.53 (31) | 1.95 / 2.44 / 2.91 (73) | 1.85 / 2.22 / 2.86 (104) |
| feet_T_before | - | 0.99 / 1.47 / 2.01 (73) | 0.85 / 1.28 / 1.95 (104) |
| feet_T_peak | - | 0.33 / 1.08 / 1.67 (73) | 0.33 / 1.02 / 1.65 (104) |
| feet_T_after | - | 0.27 / 0.99 / 1.78 (73) | 0.27 / 0.98 / 1.73 (104) |
| thrower_hips_out_T | -0.01 / 0.04 / 0.14 (31) | -0.08 / 0.03 / 0.17 (73) | -0.07 / 0.04 / 0.15 (104) |
| thrower_lead_ankle_out_T | -0.01 / 0.02 / 0.23 (31) | -0.42 / 0.03 / 0.30 (73) | -0.25 / 0.02 / 0.28 (104) |
| thrower_rear_ankle_out_T | -0.04 / 0.00 / 0.15 (31) | -0.15 / 0.04 / 0.61 (73) | -0.11 / 0.02 / 0.41 (104) |
| extension_s | 0.06 / 0.10 / 0.20 (31) | 0.03 / 0.10 / 0.13 (73) | 0.04 / 0.10 / 0.17 (104) |
| return_s | - | 0.07 / 0.13 / 0.27 (73) | 0.07 / 0.13 / 0.69 (104) |
| receiver_nose_away_T_peak_plus_0.1s | - | -0.29 / 0.10 / 0.40 (73) | -0.26 / 0.04 / 0.35 (104) |
| receiver_nose_away_T_peak_plus_0.2s | -0.14 / -0.02 / 0.27 (31) | -0.34 / 0.15 / 0.60 (73) | -0.32 / 0.08 / 0.55 (104) |
| receiver_nose_away_T_peak_plus_0.3s | - | -0.39 / 0.13 / 0.72 (73) | -0.35 / 0.07 / 0.68 (104) |
| receiver_hips_away_T_peak_plus_0.2s | - | -0.45 / -0.04 / 0.35 (73) | -0.37 / -0.02 / 0.25 (104) |
| receiver_nose_moves_s_from_peak | - | -0.07 / 0.03 / 0.13 (71) | -0.07 / 0.03 / 0.20 (89) |
| thrower_hips_drop_T | - | 0.03 / 0.12 / 0.29 (73) | 0.00 / 0.08 / 0.29 (104) |
| thrower_hips_drop_s_from_peak | - | -0.03 / 0.20 / 0.43 (73) | -0.07 / 0.19 / 0.49 (104) |
| thrower_nose_drop_T | - | 0.03 / 0.14 / 0.52 (73) | 0.01 / 0.12 / 0.48 (104) |

## The next exchanges (pooled)
| group | punches | gap_T_before | gap_T_peak | thrower_hips_out_T | extension_s |
| --- | --- | --- | --- | --- | --- |
| rear_head_height | 18 | 1.92 / 2.46 / 3.00 (18) | 1.78 / 2.17 / 2.92 (18) | -0.13 / 0.02 / 0.10 (18) | 0.07 / 0.13 / 0.24 (18) |
| lead_body | 25 | 2.18 / 2.60 / 3.23 (25) | 2.06 / 2.73 / 3.07 (25) | -0.08 / 0.01 / 0.13 (25) | 0.07 / 0.17 / 0.27 (25) |
| rear_body | 11 | 2.10 / 2.56 / 3.06 (11) | 2.21 / 2.49 / 2.94 (11) | -0.05 / 0.05 / 0.25 (11) | 0.06 / 0.14 / 0.23 (11) |

## Combinations (pooled)
| name | n | peak_to_onset_s | peak_to_peak_s | returned_share |
| --- | --- | --- | --- | --- |
| all | 36 | 0.17 / 0.35 / 0.80 (36) | 0.25 / 0.47 / 0.92 (36) | 0.94 |
| lead->lead | 25 | 0.18 / 0.60 / 0.85 (25) | 0.25 / 0.67 / 0.97 (25) | 0.96 |
| lead->rear | 6 | 0.22 / 0.26 / 0.38 (6) | 0.37 / 0.41 / 0.52 (6) | 1.00 |
| rear->lead | 4 | 0.14 / 0.22 / 0.32 (4) | 0.25 / 0.41 / 0.46 (4) | 0.75 |
| rear->rear | 1 | 0.57 / 0.57 / 0.57 (1) | 0.63 / 0.63 / 0.63 (1) | 1.00 |

## measure_pair
```text
PAIR_NUMBERS {"id": "BOX_JAB_HEAD_LAND_F01_F09", "T_m": {"thrower": 0.5109341459735754, "receiver": 0.5166050649702019}, "gap_T_before": 2.174431, "gap_T_contact": 2.060077, "gap_T_after": 2.173681, "thrower_hips_out_T": 0.113251, "thrower_lead_ankle_out_T": 0.203873, "thrower_rear_ankle_out_T": 0.084313, "receiver_head_back_T_at_contact_plus_0.2s": 0.373991}
number                           pair   footage p10 / p50 / p90 (n)
gap_T_before                     2.17   2.06 / 2.60 / 3.02 (104)  inside
gap_T_contact                    2.06   1.95 / 2.29 / 2.69 (104)  inside
gap_T_after                      2.17   1.85 / 2.22 / 2.86 (104)  inside
thrower_hips_out_T               0.11   -0.07 / 0.04 / 0.15 (104)  inside
thrower_lead_ankle_out_T         0.20   -0.25 / 0.02 / 0.28 (104)  inside
thrower_rear_ankle_out_T         0.08   -0.11 / 0.02 / 0.41 (104)  inside
receiver_head_back_T_at_contact_plus_0.2s     0.37   no footage number
```

```text
PAIR_NUMBERS {"id": "BOX_JAB_HEAD_LAND_F09_F01", "T_m": {"thrower": 0.5167499180332951, "receiver": 0.5108866950202253}, "gap_T_before": 2.152754, "gap_T_contact": 2.06004, "gap_T_after": 2.152473, "thrower_hips_out_T": 0.091882, "thrower_lead_ankle_out_T": 0.189091, "thrower_rear_ankle_out_T": 0.064076, "receiver_head_back_T_at_contact_plus_0.2s": 0.357365}
number                           pair   footage p10 / p50 / p90 (n)
gap_T_before                     2.15   2.06 / 2.60 / 3.02 (104)  inside
gap_T_contact                    2.06   1.95 / 2.29 / 2.69 (104)  inside
gap_T_after                      2.15   1.85 / 2.22 / 2.86 (104)  inside
thrower_hips_out_T               0.09   -0.07 / 0.04 / 0.15 (104)  inside
thrower_lead_ankle_out_T         0.19   -0.25 / 0.02 / 0.28 (104)  inside
thrower_rear_ankle_out_T         0.06   -0.11 / 0.02 / 0.41 (104)  inside
receiver_head_back_T_at_contact_plus_0.2s     0.36   no footage number
```

## Population
pooled (batches 2+3, 2026-09-14): two men tracked with MediaPipe Pose (num_poses 2), identity by hip-midpoint continuity; only segments with both men side-on, shoulders, hips, ankles and nose visible; T = each man's shoulder-mid to hip-mid image length; HFSZxKUUE98 (slow motion, 60 fps file of slowed footage) is listed but excluded from every statistic.
