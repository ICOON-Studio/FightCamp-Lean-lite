## DECISIONS

| variant | first lead | entry_pose_deg | twist_max_deg | spine_from_rest_max_deg | strike (x,y,z) | hand_node_dev_max_m | skate_mean_mps |
|---|---:|---:|---:|---:|---|---:|---:|
| mirror | RightToes | 75.4 | 23.8 | 20.7 | 0.13,0.50,1.05 | 0.000 | 0.325 |
| upper_mirror_lower_idle | LeftToes | 23.1 | 24.1 | 20.7 | -0.64,0.56,0.09 | 1.227 | 0.014 |
| global_chest_lower_idle | LeftToes | 36.3 | 146.3 | 139.0 | 0.17,0.51,0.68 | 0.547 | 0.014 |
| global_chest_yawmatch_lower_idle | LeftToes | 36.9 | 71.8 | 71.0 | -0.66,0.51,-0.09 | 1.386 | 0.014 |
| global_chest_yawmatch_split_lower_idle | LeftToes | 36.1 | 71.8 | 40.6 | -0.65,0.52,-0.10 | 1.381 | 0.014 |
| hook_lead (ref) | LeftToes | — | 23.8 | 20.7 | -0.13,0.50,1.05 | — | 0.325 |

Variants 2-5 keep idle stance (skate ~0.014). upper_mirror_lower_idle starts nearest idle (entry 23.1 deg).
Only mirror/upper_mirror stay inside hook_lead twist (23.8 deg); global_chest_lower_idle wrings 146.3 deg on Spine alone.
None lands mirror reach: best global_chest_lower_idle z=0.68 vs hook_lead 1.05; yawmatch heights match (y~0.50) but fist goes sideways (z<0).
