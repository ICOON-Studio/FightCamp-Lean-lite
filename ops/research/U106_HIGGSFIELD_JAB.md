# U106 - a Higgsfield jab on our fighter
## DECISIONS
Meshy inside 29 of 34 footage keys; committed 28 of 34. Meshy wins extension_s and hip-dip counts; committed wins receiver_nose_moves and rear-knee angles. Committed swing 44.1deg glove 0.016m; Meshy contact IK glove 0.001m. Retarget: world-rotation deltas plus limb segment-aim for Mixamo roll.
## Bone map Hips(None)->Hips; Spine02(Hips)->Spine; Spine01(Spine02)->Chest; Spine(Spine01)->UpperChest; neck(Spine)->Neck; Head(neck)->Head; L/R limbs Mixamo->bridge (LeftArm->LeftUpperArm etc).
## Compare
```text
gap_T_before                                       2.20 / 2.20 / 2.20 (1)   2.06 / 2.60 / 3.02 (104)   inside | gap_T_peak                                         2.05 / 2.05 / 2.05 (1)   1.95 / 2.29 / 2.69 (104)   inside
gap_T_after                                        2.12 / 2.12 / 2.12 (1)   1.85 / 2.22 / 2.86 (104)   inside | feet_T_before                                      1.40 / 1.40 / 1.40 (1)   0.85 / 1.28 / 1.95 (104)   inside
feet_T_peak                                        1.20 / 1.20 / 1.20 (1)   0.33 / 1.02 / 1.65 (104)   inside | feet_T_after                                       1.40 / 1.40 / 1.40 (1)   0.27 / 0.98 / 1.73 (104)   inside
thrower_hips_out_T                               -0.00 / -0.00 / -0.00 (1)   -0.07 / 0.04 / 0.15 (104)   inside | thrower_lead_ankle_out_T                         -0.01 / -0.01 / -0.01 (1)   -0.25 / 0.02 / 0.28 (104)   inside
thrower_rear_ankle_out_T                         -0.00 / -0.00 / -0.00 (1)   -0.11 / 0.02 / 0.41 (104)   inside | extension_s                                        0.03 / 0.03 / 0.03 (1)   0.04 / 0.10 / 0.17 (104)   OUTSIDE
return_s                                           0.13 / 0.13 / 0.13 (1)   0.07 / 0.13 / 0.69 (104)   inside | receiver_nose_away_T_peak_plus_0.1s                0.26 / 0.26 / 0.26 (1)   -0.26 / 0.04 / 0.35 (104)   inside
receiver_nose_away_T_peak_plus_0.2s                0.37 / 0.37 / 0.37 (1)   -0.32 / 0.08 / 0.55 (104)   inside | receiver_nose_away_T_peak_plus_0.3s                0.20 / 0.20 / 0.20 (1)   -0.35 / 0.07 / 0.68 (104)   inside
receiver_hips_away_T_peak_plus_0.2s              -0.05 / -0.05 / -0.05 (1)   -0.37 / -0.02 / 0.25 (104)   inside | receiver_nose_moves_s_from_peak                    0.07 / 0.07 / 0.07 (1)   -0.07 / 0.03 / 0.20 (89)   inside
thrower_hips_drop_T                                0.19 / 0.19 / 0.19 (1)   0.00 / 0.08 / 0.29 (104)   inside | thrower_hips_drop_s_from_peak                      0.23 / 0.23 / 0.23 (1)   -0.07 / 0.19 / 0.49 (104)   inside
thrower_nose_drop_T                                0.27 / 0.27 / 0.27 (1)   0.01 / 0.12 / 0.48 (104)   inside | thrower_hips_dips_05T                              2.00 / 2.00 / 2.00 (1)   0.00 / 1.00 / 1.00 (104)   OUTSIDE
thrower_hips_dips_10T                              2.00 / 2.00 / 2.00 (1)   0.00 / 0.00 / 1.00 (104)   OUTSIDE | thrower_pitch_onset_deg                          10.10 / 10.10 / 10.10 (1)   -5.07 / 8.52 / 18.85 (104)   inside
thrower_pitch_peak_deg                           12.79 / 12.79 / 12.79 (1)   -3.68 / 10.15 / 22.83 (104)   inside | thrower_pitch_max_deg                            23.36 / 23.36 / 23.36 (1)   1.04 / 13.71 / 25.93 (104)   inside
thrower_pitch_forward_change_deg                 13.26 / 13.26 / 13.26 (1)   -0.27 / 4.09 / 12.77 (104)   OUTSIDE | thrower_lead_knee_onset_deg                      162.23 / 162.23 / 162.23 (1)   137.29 / 155.60 / 170.71 (101)   inside
thrower_lead_knee_min_deg                        108.69 / 108.69 / 108.69 (1)   118.30 / 137.98 / 159.51 (101)   OUTSIDE | thrower_lead_knee_bend_deg                       53.55 / 53.55 / 53.55 (1)   2.11 / 12.25 / 33.21 (101)   OUTSIDE
thrower_rear_knee_onset_deg                      169.26 / 169.26 / 169.26 (1)   147.88 / 165.77 / 176.30 (99)   inside | thrower_rear_knee_min_deg                        162.17 / 162.17 / 162.17 (1)   132.05 / 149.03 / 166.20 (99)   inside
thrower_rear_knee_bend_deg                         7.09 / 7.09 / 7.09 (1)   3.30 / 13.73 / 32.69 (99)   inside | receiver_pitch_onset_deg                         12.24 / 12.24 / 12.24 (1)   -3.63 / 7.63 / 20.26 (104)   inside
receiver_pitch_back_change_deg                   19.48 / 19.48 / 19.48 (1)   -1.32 / 7.40 / 23.36 (104)   inside | receiver_hips_dips_05T                             0.00 / 0.00 / 0.00 (1)   0.00 / 1.00 / 1.00 (104)   inside
```
```text
gap_T_before                                       2.24 / 2.24 / 2.24 (1)   2.06 / 2.60 / 3.02 (104)   inside | gap_T_peak                                         2.08 / 2.08 / 2.08 (1)   1.95 / 2.29 / 2.69 (104)   inside
gap_T_after                                        2.13 / 2.13 / 2.13 (1)   1.85 / 2.22 / 2.86 (104)   inside | feet_T_before                                      1.48 / 1.48 / 1.48 (1)   0.85 / 1.28 / 1.95 (104)   inside
feet_T_peak                                        1.21 / 1.21 / 1.21 (1)   0.33 / 1.02 / 1.65 (104)   inside | feet_T_after                                       1.49 / 1.49 / 1.49 (1)   0.27 / 0.98 / 1.73 (104)   inside
thrower_hips_out_T                                 0.07 / 0.07 / 0.07 (1)   -0.07 / 0.04 / 0.15 (104)   inside | thrower_lead_ankle_out_T                           0.02 / 0.02 / 0.02 (1)   -0.25 / 0.02 / 0.28 (104)   inside
thrower_rear_ankle_out_T                           0.01 / 0.01 / 0.01 (1)   -0.11 / 0.02 / 0.41 (104)   inside | extension_s                                        0.17 / 0.17 / 0.17 (1)   0.04 / 0.10 / 0.17 (104)   inside
return_s                                           0.35 / 0.35 / 0.35 (1)   0.07 / 0.13 / 0.69 (104)   inside | receiver_nose_away_T_peak_plus_0.1s                0.01 / 0.01 / 0.01 (1)   -0.26 / 0.04 / 0.35 (104)   inside
receiver_nose_away_T_peak_plus_0.2s                0.01 / 0.01 / 0.01 (1)   -0.32 / 0.08 / 0.55 (104)   inside | receiver_nose_away_T_peak_plus_0.3s                0.10 / 0.10 / 0.10 (1)   -0.35 / 0.07 / 0.68 (104)   inside
receiver_hips_away_T_peak_plus_0.2s              -0.00 / -0.00 / -0.00 (1)   -0.37 / -0.02 / 0.25 (104)   inside | receiver_nose_moves_s_from_peak                    0.32 / 0.32 / 0.32 (1)   -0.07 / 0.03 / 0.20 (89)   OUTSIDE
thrower_hips_drop_T                                0.02 / 0.02 / 0.02 (1)   0.00 / 0.08 / 0.29 (104)   inside | thrower_hips_drop_s_from_peak                      0.07 / 0.07 / 0.07 (1)   -0.07 / 0.19 / 0.49 (104)   inside
thrower_nose_drop_T                                0.08 / 0.08 / 0.08 (1)   0.01 / 0.12 / 0.48 (104)   inside | thrower_hips_dips_05T                              0.00 / 0.00 / 0.00 (1)   0.00 / 1.00 / 1.00 (104)   inside
thrower_hips_dips_10T                              0.00 / 0.00 / 0.00 (1)   0.00 / 0.00 / 1.00 (104)   inside | thrower_pitch_onset_deg                            7.75 / 7.75 / 7.75 (1)   -5.07 / 8.52 / 18.85 (104)   inside
thrower_pitch_peak_deg                           11.43 / 11.43 / 11.43 (1)   -3.68 / 10.15 / 22.83 (104)   inside | thrower_pitch_max_deg                            11.92 / 11.92 / 11.92 (1)   1.04 / 13.71 / 25.93 (104)   inside
thrower_pitch_forward_change_deg                   4.17 / 4.17 / 4.17 (1)   -0.27 / 4.09 / 12.77 (104)   inside | thrower_lead_knee_onset_deg                      132.04 / 132.04 / 132.04 (1)   137.29 / 155.60 / 170.71 (101)   OUTSIDE
thrower_lead_knee_min_deg                        116.89 / 116.89 / 116.89 (1)   118.30 / 137.98 / 159.51 (101)   OUTSIDE | thrower_lead_knee_bend_deg                       15.15 / 15.15 / 15.15 (1)   2.11 / 12.25 / 33.21 (101)   inside
thrower_rear_knee_onset_deg                      178.05 / 178.05 / 178.05 (1)   147.88 / 165.77 / 176.30 (99)   OUTSIDE | thrower_rear_knee_min_deg                        174.51 / 174.51 / 174.51 (1)   132.05 / 149.03 / 166.20 (99)   OUTSIDE
thrower_rear_knee_bend_deg                         3.54 / 3.54 / 3.54 (1)   3.30 / 13.73 / 32.69 (99)   inside | receiver_pitch_onset_deg                         12.47 / 12.47 / 12.47 (1)   -3.63 / 7.63 / 20.26 (104)   inside
receiver_pitch_back_change_deg                   19.72 / 19.72 / 19.72 (1)   -1.32 / 7.40 / 23.36 (104)   inside | receiver_hips_dips_05T                             0.00 / 0.00 / 0.00 (1)   0.00 / 1.00 / 1.00 (104)   inside
```
## Population
BOX_JAB_HEAD_LAND_F01_F09_MESHY: Higgsfield/Meshy Left_Jab_from_Guard on f01 through glb_clip_to_bridge.py, authored with the v1 spec
