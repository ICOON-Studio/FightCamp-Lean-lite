# U153 digest — live-room grip witness (S63 solve in the bout)

## Seed

Task asked for 92000 (S62 realtime ground pin). **Live-room MMA on 92000 never reached a `Cascy_*` hold** (only `Paired_FullMount_PushOff`, 160 frames, zero `HOLD_GRIPS` rows). First in-range seed that did: **92001** (trap: re-pin, do not treat empty 92000 as a pass).

## Population

`ruleset=mma`, `rounds=3`, `seed=92001`, default demo pair: **wrestle-grappler (A)** 178 cm vs **striker (B)** 178 cm, meshes `f05_m_mma_light` / `f06_m_mma_lhw`, `pair_grip_solve` ON vs OFF. Pose read: compose globals from `get_bone_pose` (not `get_bone_global_pose`).

## Holds played (frames while paired film active)

| pair_key | frames |
|---|---:|
| Cascy_CageClinch | 240 |
| Paired_FullMount_H2H_ArmBar | 268 |
| Paired_FullMount_H2H_Punches | 770 |
| Paired_FullMount_Takedown_BodyLock_Loop | 1306 |
| Paired_FullMount_Takedown_BodyLock_Start | 140 |

Only **Cascy_CageClinch** has `HOLD_GRIPS` rows; grip stats below are for that hold.

## Part 1 — effector→anchor distance (m)

| grip | frames | ON p50 | ON p90 | ON max | OFF p50 | OFF p90 | OFF max |
|---|---:|---:|---:|---:|---:|---:|---:|
| 0:LeftHand→Neck | 240 | 0.317 | 0.333 | 0.338 | 0.275 | 0.290 | 0.294 |
| 0:RightHand→Neck | 240 | 0.324 | 0.341 | 0.346 | 0.295 | 0.314 | 0.319 |
| 1:RightHand→LeftUpperArm | 240 | 0.283 | 0.291 | 0.292 | 0.260 | 0.266 | 0.267 |

**Finding:** In the live room, `pair_grip_solve` ON does **not** tighten these three cage-clinch grips versus OFF on this seed — joint-centre distances are **larger** with the solve on (opposite of the probe’s intent for preservation). The witness still proves the solve path runs in-room (S63 fix) and that distances are measurable on a real bout.

## Part 2 — no-teleport sanity (unchanged across arms)

| arm | body jumps (>10 cm or >15° yaw / frame) | overlap frames >3 cm | longest >3 cm run (s) |
|---|---:|---:|---:|
| ON | 93 | 84 | 0.050 |
| OFF | 93 | 84 | 0.050 |

Grip solve does not move body roots or overlap refusal (arm/leg-only solve).

## Tool

`Godot/tools/u153_live_grip_witness.gd` — `on` / `off` / `seed=NNNN` args.

## Gate

Parse gate on witness; tool run once per arm (`on`, `off`). No suite.
