# U157 digest — why the grip solve loosened the cage clinch

## Population

`ruleset=mma`, `seed=92001`, `hold=Cascy_CageClinch`, `rounds=3`. Live bout: **wrestle-grappler (A)** 178 cm vs **striker (B)** 178 cm, meshes `f05_m_mma_light` / `f06_m_mma_lhw`. Probe graft uses the same binding (`mma_dirty_boxing` → `Cascy_CageClinch`) on the S31 boxer pair (`f01` welter / `f02` heavy) at mount identity.

## Part 1 — two instruments, same grips

| grip (`HOLD_GRIPS` row) | S31 probe joint mean (m) | probe drift vs Cascy authored | live joint p50 (m) | live surface est p50 (m) |
|---|---:|---:|---:|---:|
| 0:LeftHand→Neck | 0.062 (solve ON, live-key) | 15% (authored 0.073) | 0.275 | 0.165 |
| 0:RightHand→Neck | 0.098 | 1% (0.097) | 0.295 | 0.185 |
| 1:RightHand→LeftUpperArm | 0.073 | 13% (0.083) | 0.260 | 0.160 |

- **Same pairs** as `PairedStagePlayer.HOLD_GRIPS` for `Cascy_CageClinch` (matches S31 `PAIRS` for dirty boxing).
- **S31 “drift %”** is `|joint_centre_mean − authored_joint_centre| / authored` on the **grafted clip** at 9 samples (not a surface %).
- **U153/live** reads joint centres from composed `get_bone_pose` during the bout; **surface est** subtracts ~5 cm hand + ~6 cm neck (or 5 cm upper arm) from joint distance — live p50 ~0.16–0.19 m surface gap is still not contact.
- **Why they disagreed on “solve helps”:** probe measures the bake on small boxer rigs near Cascy-authored joint distances (~7–10 cm). The live room measures the same bake **after** mount on 178 cm MMA meshes where retarget joint centres sit ~26–30 cm apart; a solve that **increased** those distances looked like “ON worse than OFF” in U153 while S31 still reported low drift on the probe population.

## Part 2 — mechanism and fix

- **Stage:** graft-time bake in `PairedStagePlayer.graft_pair` (`_preserve_pair_grip_contacts`), not per-frame room IK (`finish_hand_frame` already no-ops on `set_paired_hold`).
- **Bug:** C168’s goal used a **world-fixed** source offset; when the target anchor rotated in retarget, IK goals sat farther from the anchor than the raw clip — loosening grips (U153: ON p50 0.317 vs OFF 0.275 on left hand to neck).
- **Fix (U157):** anchor-local authored offset (`FightPoseSolver.authored_grip_offset_local_m` + `grip_effector_goal_actor_space`) and **skip IK when the goal would not tighten** joint-centre distance vs the retarget already on the clip.

### After fix (live seed 92001, cage clinch, 240 frames)

| grip | ON p50 (m) | OFF p50 (m) |
|---|---:|---:|
| 0:LeftHand→Neck | 0.275 | 0.275 |
| 0:RightHand→Neck | 0.295 | 0.295 |
| 1:RightHand→LeftUpperArm | 0.260 | 0.260 |

ON ≤ OFF on every grip (equal here because loosening goals are skipped). S31 solve-ON left-hand drift returns to 15% (matches OFF-style retarget) instead of opening the hand.

## Tools

- `Godot/tools/u157_grip_two_instruments.gd` — live joint + surface est beside probe-authored drift.
- `Godot/tools/u153_live_grip_witness.gd` — unchanged contract; re-run for ON/OFF arms.

## Gate

`check_scripts.py` on touched `.gd`; `run_tests.py --only paired_stage,fight_pose_solver,fight_hold,grip,fight_world` → **SUITE total=10 fails=0**.
