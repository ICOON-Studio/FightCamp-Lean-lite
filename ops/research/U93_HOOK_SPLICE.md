## DECISIONS

| variant | first lead | last lead | entry_pose_deg | hand_node_dev_max_m | reach_fwd_max_m | torso_yaw_dev_max_deg | skate_mean_mps |
|---------|------------|-----------|----------------|---------------------|-----------------|----------------------|----------------|
| mirror | RightToes | RightToes | 75.39 | 0.000 | 1.049 | 0.0 | 0.325 |
| upper_mirror_lower_lead | LeftToes | LeftToes | 23.13 | 1.086 | 0.419 | 178.0 | 0.325 |
| upper_mirror_lower_idle | LeftToes | LeftToes | 23.07 | 1.227 | 0.346 | 128.3 | 0.014 |
| upper_mirror_hipsrot_mirror_lower_idle | RightToes | RightToes | 64.40 | 0.544 | 0.686 | 0.03 | 1.080 |

`upper_mirror_lower_idle` is the only splice that keeps idle's left-foot stance at entry; its chest-frame arm chain matches mirror (≤0.2 µm) but the fist drifts ~1.23 m in node space because the mirrored torso rides idle hips. `upper_mirror_hipsrot_mirror_lower_idle` tracks mirror's fist best (0.54 m node dev, 0.03° torso yaw) at the cost of reintroducing the right-foot-forward swap. For idle stance plus lowest planted-foot skate (0.014 m/s vs mirror's 0.325), `upper_mirror_lower_idle` wins; no variant holds both idle stance and a mirror-close fist.
