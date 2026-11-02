# U107 - text-to-motion jab types on our fighter

## DECISIONS

- t2m_committed: reach_share_peak 0.99, extension_s 0.133, hips_out_T 0.302
- t2m_rangefinder: reach_share_peak 0.74, extension_s 0.433, hips_out_T 0.093
- t2m_feint: reach_share_peak 0.66, extension_s 0.083, hips_out_T 0.011
- bought_jab: reach_share_peak 1.00, extension_s 0.017, hips_out_T 0.021
- meshy_jab: reach_share_peak 0.98, extension_s 0.383, hips_out_T 0.244
- t2m reach at peak: feint 0.66 < rangefinder 0.74 < committed 0.99; hips_out_T committed 0.302 > rangefinder 0.093 > feint 0.011.

## Mechanics

| label | bridge | take | arm_len_m | reach_share_peak | guard_share | onset_s | peak_s | extension_s | return_s | hips_out_T | lead_ankle_out_T | rear_hand_v_head_m | length_s |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| t2m_committed | f01_takes_t2m.json | jab_committed_t2m | 0.5039 | 0.9874 | 0.3647 | 1.8667 | 2.0 | 0.1333 | 0.1667 | 0.302 | 0.1763 | -0.0982 | 2.55 |
| t2m_rangefinder | f01_takes_t2m.json | jab_rangefinder_t2m | 0.5039 | 0.7388 | 0.3647 | 1.2 | 1.6333 | 0.4333 | 0.2 | 0.0927 | -0.0309 | -0.1053 | 2.55 |
| t2m_feint | f01_takes_t2m.json | jab_feint_t2m | 0.5039 | 0.6552 | 0.4938 | 1.4167 | 1.5 | 0.0833 | 0.3833 | 0.0107 | 0.0534 | -0.0617 | 2.55 |
| bought_jab | f01_takes.json | jab | 0.5039 | 1.0 | 0.413 | 0.2167 | 0.2333 | 0.0167 | 0.2167 | 0.0207 | 0.0004 | -0.2089 | 0.833 |
| meshy_jab | f01_takes_meshy.json | jab_meshy | 0.5039 | 0.979 | 0.3934 | 0.35 | 0.7333 | 0.3833 | 0.3 | 0.2435 | 0.2455 | -0.0923 | 1.7667 |

## Bone map

| source (parent) | ours |
| --- | --- |
| Hips (none) | Hips |
| Spine (Hips) | Spine |
| Spine2 (Spine1) | Chest |
| Spine3 (Spine2) | UpperChest |
| Neck (Spine3) | Neck |
| Head (Neck) | Head |
| LeftShoulder (Spine3) | LeftShoulder |
| LeftArm (LeftShoulder) | LeftUpperArm |
| LeftForeArm (LeftArm) | LeftLowerArm |
| LeftHand (LeftForeArm) | LeftHand |
| LeftUpLeg (Hips) | LeftUpperLeg |
| LeftLeg (LeftUpLeg) | LeftLowerLeg |
| LeftFoot (LeftLeg) | LeftFoot |
| LeftToeBase (LeftFoot) | LeftToes |
| RightShoulder (Spine3) | RightShoulder |
| RightArm (RightShoulder) | RightUpperArm |
| RightForeArm (RightArm) | RightLowerArm |
| RightHand (RightForeArm) | RightHand |
| RightUpLeg (Hips) | RightUpperLeg |
| RightLeg (RightUpLeg) | RightLowerLeg |
| RightFoot (RightLeg) | RightFoot |
| RightToeBase (RightFoot) | RightToes |

Unmapped: Spine1 (between Spine and Spine2). End sites and thumb chains omitted.

## Population

Five jab takes on f01: t2m_committed, t2m_rangefinder and t2m_feint from Higgsfield ARDY npz clips retargeted via npz_clip_to_bridge; bought_jab from f01_takes.json; meshy_jab from f01_takes_meshy.json.
