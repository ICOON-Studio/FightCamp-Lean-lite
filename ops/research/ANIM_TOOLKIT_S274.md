# ANIM TOOLKIT S274 - what we need to make the fight move properly (operator: "find which githubs you need")

Operator S274 on the A/B (previews/s274_layers/s274_layers_ab.mp4, same seed): "the right clip on the video is much
better well done but i think it can get even better". RIGHT = clips only (the bone-rewriting layers off). That answers board
Q-S273-2: the captured clip is the base; layers come back only where they measure as needed.

## Why the fighting games look right (and our fight did not)
They play the capture as captured (root motion moves the body), every move starts and ends in one shared neutral stance, and
nothing re-bends the bones after the clip. Ours glided the body and ~30 presentation layers rewrote arms, hands, face, legs
and root on top of the Rokoko take (S257 counted ~8 root writers alone). The A/B shows it on one seed.

## Already in our Godot 4.7.2 (no download) - ClassDB probe S274
- `TwoBoneIK3D` - foot plants: pin each foot on FootContacts.plants (rules/FootContacts.gd) frames only. Replaces HUMAN2's
  invented steps for captured takes.
- `LimitAngularVelocityModifier3D` - caps bone angular speed: kills the one-frame pops at clip joins without rewriting poses.
- `BoneTwistDisperser3D` - spreads forearm/upper-arm twist (the S246/S265 twist work, built in).
- `SpringBoneSimulator3D` - secondary motion (gloves' laces, hair) instead of hand-written springs.
- `PhysicalBoneSimulator3D` - hit reactions as partial physics later (replaces active_ragdoll layers).
- `CCDIK3D` / `FABRIK3D` / `JacobianIK3D` / `SplineIK3D` / `AimModifier3D` / `LookAtModifier3D` - available if a measured case needs one.

## GitHub (checked S274: licence, stars, last push)
| Repo | Licence | Use for us | Verdict |
|---|---|---|---|
| [GuilhermeGSousa/godot-motion-matching](https://github.com/GuilhermeGSousa/godot-motion-matching) | MIT, 249 stars, pushed 2026-06, release 0.2.1 (Godot 4.4+, GDExtension) | Motion matching over the Rokoko FightingIdle + step library: picks the next frame by pose + trajectory | TRIAL after the step library exists (FOOTWORK_PLAN "motion matching later"); test on a worktree with our 4.7.2 |
| [orangeduck/Motion-Matching](https://github.com/orangeduck/Motion-Matching) | MIT, 926 stars | Reference implementation (Holden, "Code vs Data Driven Displacement"): inertialization, foot locking, trajectory warping | READ - the algorithms (inertialization, foot lock) we port into our pure modules |
| [Remi123/MotionMatching](https://github.com/Remi123/MotionMatching) | MIT, 50 stars, pushed 2024-08 | Its inertialization player node is the stable part | Reference only (stale, 4.2) |
| Bandai Namco Research motion dataset / Ubisoft LaFAN1 | non-commercial | Fight / general mocap | OUT - we sell the game |

## Data (operator rule S274: Rokoko + ActionForge only)
Rokoko free combat takes (owned, any game) carry the fight; ActionForge fills locomotion. Hooks/uppercuts still have no clean
capture in either (Ailive and ActionForge hooks rejected S274) - the gap stays on the current clips until a source passes the
20 s fighters-only test.

## Order of work (decided)
1. Base = clips only (Q-S273-2 "much better"): turn the arm/hand/face/alive/foot-planner layers OFF for captured takes; keep
   spacing (no crowding) - measured on the 20 s render first.
2. Captured steps (StepIntent/StepPicker/FootContacts/StepRoot + Ziva's library) with TwoBoneIK3D plants.
3. LimitAngularVelocityModifier3D on the joins; inertialization from orangeduck where a join still pops.
4. Trial godot-motion-matching on the step + guard data.
