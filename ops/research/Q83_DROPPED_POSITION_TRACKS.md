# DECISIONS: THE POSITION TRACKS WE DROP

Population: 28 unique bound windows across the RamsterZ H2H clips in FightClipBinding.BINDINGS, sampled at 30 fps from each binding's own start_s/end_s. Pelvis rest height: 0.9130 m (from T_pose.fbx hierarchy).

## Root cause of the first delivery's failure

Two bugs, both in the composition of pelvis world position:

1. **Axis mismatch**: the FBX importer (ufbx) converts the skeleton hierarchy from Z-up to Y-up, but leaves animation tracks in native Z-up. The first delivery read `.z` from the COMPOSED position - correct axis for the track space, but the composition was wrong.
2. **Pelvis position track override**: in these UE4 FBXs the pelvis position track gives (0,0,0) - it places the pelvis at the root origin, OVERRIDING the skeleton's rest offset (~0.97m above root). Reading the root's `.z` during a fall (where root.z drops to -0.92) gives -0.77 for the pelvis - 77cm `through the floor` that was never the pelvis height.

**FIX**: pelvis_world = root_animated_position + root_rotation * pelvis_rest_offset_from_T_pose. The rest offset (from T-pose hierarchy, converted Y-up to Z-up) is (0.0000, 0.0106, 0.9675).

## Physical tripwire

| source | pelvis_y_m |
|---|---:|
| T_pose.fbx hierarchy (Y-up) | 0.9130 |
| Idle t=0 (root track .z, Z-up) | 0.9130 |

## C94 comparison

C94 reads the raw pelvis position track `.y` (a horizontal axis in Z-up). Its WalkForward bob of 0.0020 m is the side-to-side sway, not the vertical bob. Our corrected measurement adds the rest offset and reads `.z` (true height). They will NOT agree - C94 measured the wrong axis.

| clip | our bob_m | our travel_m | C94 bob_m | C94 travel_m | agrees |
|---|---:|---:|---:|---:|:---:|
| H2H_WalkForward.FBX | 0.0625 | 0.0000 | 0.0020 | 0.0000 | NO |
| H2H_WalkBack.FBX | 0.0625 | 0.0067 | 0.0020 | 0.0067 | NO |

## Windows ranked by pelvis drop below rest (most negative first)

| clip | role(s) | pelvis_drop_m | pelvis_y_range_m | pelvis_xz_path_m |
|---|---|---:|---:|---:|
| H2H_KnockDown01.FBX | knockdown | -0.7794 | 0.7800 | 0.0000 |
| H2H_KnockDown02.FBX | knockdown | -0.7641 | 0.7641 | 0.0000 |
| H2H_StaggerLarge04_LowHit.FBX | react_leg | -0.4166 | 0.4438 | 0.0342 |
| H2H_SlipLeft.FBX | slip | -0.2111 | 0.2111 | 0.4290 |
| H2H_Haymaker_InPlace.FBX | boxing_overhand | -0.1977 | 0.1977 | 0.0000 |
| H2H_FadeBack.FBX | slip | -0.1798 | 0.1798 | 0.3636 |
| H2H_SlipRight.FBX | slip | -0.1477 | 0.1478 | 0.2167 |
| H2H_StraightPunchInPlace.FBX | strike_body | -0.1428 | 0.1428 | 0.0005 |
| H2H_BlockStart.FBX | block | -0.1351 | 0.1351 | 0.0000 |
| H2H_KneeStrike_Forward.FBX | muay_thai_straight_knee | -0.1037 | 0.1374 | 0.0000 |
| H2H_StaggerSmall03.FBX | react_body | -0.1032 | 0.1056 | 0.0000 |
| H2H_RightCutKick_InPlace.FBX | kickboxing_low_kick | -0.1026 | 0.2362 | 0.0000 |
| H2H_JabInPlace.FBX | boxing_double_jab | -0.0984 | 0.0984 | 0.0469 |
| H2H_HitReaction03.FBX | react_head | -0.0932 | 0.0932 | 0.0000 |
| H2H_StaggerMedium01.FBX | react_body | -0.0884 | 0.1251 | 0.0000 |
| H2H_StaggerMedium02.FBX | react_body | -0.0788 | 0.0834 | 0.0000 |
| H2H_StaggerMedium04.FBX | react_body | -0.0762 | 0.0911 | 0.0000 |
| H2H_StaggerSmall02.FBX | react_body | -0.0756 | 0.1137 | 0.1735 |
| H2H_WalkForward.FBX | loc_advance | -0.0739 | 0.0625 | 0.0920 |
| H2H_WalkBack.FBX | loc_retreat | -0.0739 | 0.0625 | 0.0949 |
| H2H_StaggerMedium03.FBX | react_body | -0.0618 | 0.0872 | 0.0000 |
| H2H_HitReaction04.FBX | react_head | -0.0521 | 0.0709 | 0.0000 |
| H2H_StaggerSmall01.FBX | react_body | -0.0485 | 0.0524 | 0.0000 |
| H2H_HitReaction02.FBX | react_head | -0.0279 | 0.0279 | 0.0000 |
| H2H_HitReaction01.FBX | react_head | -0.0231 | 0.0402 | 0.0000 |
| H2H_Idle.FBX | idle | -0.0226 | 0.0305 | 0.0422 |
| H2H_LeftCutKick_InPlace.FBX | strike_leg | -0.0067 | 0.1358 | 0.0000 |
| H2H_RoundhouseKick_InPlace.FBX | muay_thai_round_kick, kickboxing_roundhouse, muay_thai_switch_kick_body, kickboxing_body_kick | 0.0000 | 0.1258 | 0.0000 |

## Windows ranked by pelvis horizontal path length (largest first)

| clip | role(s) | pelvis_xz_path_m | pelvis_xz_net_m | root_path_m |
|---|---|---:|---:|---:|
| H2H_SlipLeft.FBX | slip | 0.4290 | 0.0000 | 0.0000 |
| H2H_FadeBack.FBX | slip | 0.3636 | 0.0990 | 0.0990 |
| H2H_SlipRight.FBX | slip | 0.2167 | 0.0000 | 0.0000 |
| H2H_StaggerSmall02.FBX | react_body | 0.1735 | 0.0008 | 0.3481 |
| H2H_WalkBack.FBX | loc_retreat | 0.0949 | 0.0067 | 0.0000 |
| H2H_WalkForward.FBX | loc_advance | 0.0920 | 0.0000 | 0.0000 |
| H2H_JabInPlace.FBX | boxing_double_jab | 0.0469 | 0.0000 | 0.0181 |
| H2H_Idle.FBX | idle | 0.0422 | 0.0000 | 0.0000 |
| H2H_StaggerLarge04_LowHit.FBX | react_leg | 0.0342 | 0.0000 | 0.5441 |
| H2H_StraightPunchInPlace.FBX | strike_body | 0.0005 | 0.0000 | 0.0000 |
| H2H_StaggerMedium03.FBX | react_body | 0.0000 | 0.0000 | 0.7393 |
| H2H_StaggerMedium01.FBX | react_body | 0.0000 | 0.0000 | 0.7667 |
| H2H_StaggerMedium04.FBX | react_body | 0.0000 | 0.0000 | 0.7180 |
| H2H_StaggerMedium02.FBX | react_body | 0.0000 | 0.0000 | 0.5827 |
| H2H_RightCutKick_InPlace.FBX | kickboxing_low_kick | 0.0000 | 0.0000 | 0.7422 |
| H2H_RoundhouseKick_InPlace.FBX | muay_thai_round_kick, kickboxing_roundhouse, muay_thai_switch_kick_body, kickboxing_body_kick | 0.0000 | 0.0000 | 0.3643 |
| H2H_KneeStrike_Forward.FBX | muay_thai_straight_knee | 0.0000 | 0.0000 | 0.2408 |
| H2H_StaggerSmall03.FBX | react_body | 0.0000 | 0.0000 | 0.3591 |
| H2H_StaggerSmall01.FBX | react_body | 0.0000 | 0.0000 | 0.2979 |
| H2H_HitReaction03.FBX | react_head | 0.0000 | 0.0000 | 0.2598 |
| H2H_HitReaction04.FBX | react_head | 0.0000 | 0.0000 | 0.2825 |
| H2H_KnockDown02.FBX | knockdown | 0.0000 | 0.0000 | 0.7637 |
| H2H_KnockDown01.FBX | knockdown | 0.0000 | 0.0000 | 0.9257 |
| H2H_HitReaction02.FBX | react_head | 0.0000 | 0.0000 | 0.3199 |
| H2H_HitReaction01.FBX | react_head | 0.0000 | 0.0000 | 0.2752 |
| H2H_LeftCutKick_InPlace.FBX | strike_leg | 0.0000 | 0.0000 | 0.6276 |
| H2H_Haymaker_InPlace.FBX | boxing_overhand | 0.0000 | 0.0000 | 0.3666 |
| H2H_BlockStart.FBX | block | 0.0000 | 0.0000 | 0.1703 |

A rotation-only retarget visibly misrepresents H2H_KnockDown01.FBX (hips drop -0.7794 m below rest) and H2H_SlipLeft.FBX (0.4290 m of horizontal path that becomes zero): these clips carry position information the current pipeline discards.
