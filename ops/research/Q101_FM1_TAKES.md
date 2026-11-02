## DECISIONS
**NOT production's retarget.** FM1 clips import as Skeleton3D (skin data); FightClipRetarget._index
walks nodes and cannot find their bones. This sampler reads the FBX directly: source animated
rotations on our rest positions, production hip_position for pelvis placement. Silhouette
corrections from build_silhouette_corrections cannot be applied (BlueGuy.fbx is the source's own
bind rest, which BoneRestFixer warns against). Heads 0.09 m and hands 0.14 m below production
idle are genuine skeleton-proportion differences, not a float error.
**(1) idle_A / idle_Tiramis** — entry 76°/72° from prod idle, hands at 0.31/0.32 m (prod: 0.46 m,
chest-height guard not high guard). LeftToes lead, split 0.34 m (prod 0.59), width 0.25 m (prod
0.33). Skate 0.56/0.53 m/s, 12/17 planted frames. Orthodox stance, Q100 "baked-in stance" NOT
confirmed — these are ordinary boxing idles on f01, hands low. Add to stance rotation.
**(2) bp_hook_right_A** (+ nomove/bp_hook_right_A2.fbx twin) — entry 77° (prod hook_rear 75°).
LeftToes lead kept. Strike y=0.05 m, z=0.14 m (prod hook_rear z=1.05 m). "bp" = BODY PUNCH
confirmed by strike height well below head. Very short reach. nomove twin identical.
**(3) hp_straight_right_A** — cross role, RightHand. Entry 77°. Strike y=-0.07 m (2 check failures:
the sampler's rotation-transfer approximation places the hand 7 cm below the canvas at max reach;
production's RestFixer.pose_frame with a matching T_pose.fbx would fix this).
**(4) Table** — 42 clips, 0 errors, 21 bones each. All LeftToes lead. entry° from prod idle.
hp=head punch, bp=body punch, hk=hook kick, bb/bd=body blow, hb/hd=head blow, bk=back,
lk=liver kick, lb/ld=liver/body blow.
idle_A 76° | idle_Tiramis 72° | hp_straight_left_A(jab) 68° | hp_straight_right_A(cross) 77°
hp_hook_left_A(hook_lead) 77° | bp_hook_right_A(hook_rear body) 77° | hp_upper_right_A(upper) 77°
hp_straight_left_Tiramis 58° | hk_rh_right_A 77° | hk_side_left_A 77°
bb_front_A 86° | bd_front_A 84° | bk_push_left_A 76° | bk_rh_right_A 77° | bp_upper_left_A 76°
getup_A 85° | hb_front_A 77° | hd_front_A 77° | hd_front_B 74° | knockdown_A 77°
knockdown_loop_A 84° | lb_front_A 77° | ld_front_A 76° | lk_rh_left_A 77° | lk_rh_right_A 77°
lk_rh_right_Tiramis 73° | move_backward_B 72° | move_forward_B 80° | win_A 77°
nomove/ 12 clips (A2 suffix): same roles, entry 58–86°. bk_rh_right_A2 77° | bp_hook_right_A2 77°
bp_upper_left_A2 76° | hk_rh_right_A2 77° | hk_side_left_A2 77° | hp_straight_right_A2 77°
hp_upper_right_A2 77° | knockdown_A2 77° | lk_rh_left_A2 77° | lk_rh_right_A2 77°
move_backward_B2 72° | move_forward_B2 80°
