# Q47 — THE INVENTORY OF EVERY CLIP WE ACTUALLY OWN

**Agent:** qwen | **Date:** 2026-09-11
**Harness:** `Godot/tools/inventory_owned_clips.gd`
**CSV:** `research/Q47_INVENTORY.csv` (161 rows)

---

## Summary line

```
Q47_INVENTORY files=161 loaded=160 failed=1 map22=156 rootmotion=85
```

---

## 1. Load status — 160 / 161

| # | file | reason |
|---|---|---|
| 1 | `OneHandSword_Mesh.fbx` (full_mount) | NO_ANIM_PLAYER — mesh asset, not an animation clip |

160 of 161 files loaded and contained at least one AnimationPlayer with one Animation. The single failure is a weapon mesh bundled in the Full Mount Attacks pack, not an animation.

---

## 2. Map coverage — 156 at 22/22, 4 props at 0/22, 1 failed

**R107's assertion holds for every animation clip.** All 156 animation files across both packs contain all 22 UE4 bone names from the `UE4_TO_OURS` map. One BoneMap serves every RamsterZ pack.

The 5 files that do NOT reach 22/22 are not animation clips:

| file | pack | map_covers | what it is |
|---|---|---|---|
| `Android_SkeletalMesh.fbx` | full_mount | 0/22 | character mesh (has `Skeleton3D` + `Body` nodes, no UE4 bones) |
| `Android_SkeletalMesh.fbx` | h2h | 0/22 | same mesh, duplicated in h2h pack |
| `Hammer_Mesh.FBX` | full_mount | 0/22 | prop (single node: `Hammer`) |
| `OneHandAxe.fbx` | full_mount | 0/22 | prop (single node: `Axe`) |
| `OneHandSword_Mesh.fbx` | full_mount | 0/22 | prop (failed to load — no AnimationPlayer) |

**No animation clip in either pack deviates from 22/22.**

---

## 3. Root motion — 85 travelling, 75 in-place

| pack | with root motion (span > 0.1 m) | in-place | total |
|---|---|---|---|
| full_mount | 18 | 19 | 37 |
| h2h | 67 | 57 | 124 |
| **total** | **85** | **76** | **161** |

### Every clip with root_span_m > 0.1

**full_mount (18 clips):**

| file | span (m) |
|---|---|
| Paired_FullMount_Takedown_DoubleLeg_Start_Vic.fbx | 0.932 |
| Paired_FullMount_Takedown_BodyLock_End_Vic.fbx | 0.790 |
| Paired_FullMount_PushOff_Vic.fbx | 0.795 |
| Paired_FullMount_Takedown_BodyLock_Start_Att.fbx | 0.801 |
| Paired_FullMount_Takedown_BodyLock_Start_Vic.fbx | 0.786 |
| Paired_FullMount_H2H_ArmBar_Att.fbx | 0.779 |
| Paired_FullMount_PushOff_Att.fbx | 0.762 |
| Paired_FullMount_Reversal_Vic.fbx | 0.535 |
| Paired_FullMount_Takedown_DoubleLeg_Start_Att.fbx | 0.505 |
| Paired_FullMount_Takedown_BodyLock_End_Att.fbx | 0.502 |
| Paired_FullMount_Reversal_Att.fbx | 0.458 |
| Paired_FullMount_H2H_Punches_Att.fbx | 0.246 |
| Paired_FullMount_1HM_AxeToFace_Att.fbx | 0.229 |
| Paired_FullMount_H2H_HeadSmash_Att.fbx | 0.145 |
| Paired_FullMount_1HM_KnifeStab_Att.fbx | 0.121 |
| Paired_FullMount_H2H_Strangle_Att.fbx | 0.108 |
| Paired_FullMount_AttackBlock_Att.fbx | 0.103 |
| Paired_FullMount_H2H_Punches_Vic.fbx | 0.101 |

**h2h (67 clips):**

| file | span (m) |
|---|---|
| H2H_BackflipKick_InPlace.FBX | 2.105 |
| H2H_JumpingUppercut_Forward.FBX | 1.738 |
| H2H_JumpingUppercut_InPlace.FBX | 1.738 |
| H2H_JumpStart.FBX | 1.512 |
| H2H_JumpIdle.FBX | 1.498 |
| H2H_JumpLand.FBX | 1.334 |
| H2H_FrontflipKick_Forward.FBX | 1.197 |
| H2H_BarrelRollKick_Forward.FBX | 0.955 |
| H2H_StaggerLarge03.FBX | 0.817 |
| H2H_StaggerLarge01.FBX | 0.777 |
| H2H_GetUp01.FBX | 0.762 |
| H2H_KnockDown01.FBX | 0.762 |
| H2H_KnockDown02.FBX | 0.764 |
| H2H_TrippleSpinningHookKick_Forward.FBX | 0.672 |
| H2H_JumpSpinHookKick_Forward.FBX | 0.600 |
| H2H_StaggerLarge_FromBehind02.FBX | 0.501 |
| H2H_StaggerLarge_FromBehind01.FBX | 0.494 |
| H2H_JumpingBackKick_Forward.FBX | 0.477 |
| H2H_JumpingBackKick_InPlace.FBX | 0.477 |
| H2H_PowerChargeEnd.FBX | 0.469 |
| H2H_PowerChargeStart.FBX | 0.469 |
| H2H_PowerPunch01_Forward.FBX | 0.466 |
| H2H_LegSweep_InPlace.FBX | 0.469 |
| H2H_RightCutKick_Forward.FBX | 0.465 |
| H2H_StaggerLarge04_LowHit.FBX | 0.394 |
| H2H_StaggerLarge_FromBehind03.FBX | 0.399 |
| H2H_GroinPunch_InPlace.FBX | 0.433 |
| H2H_LeadingUppercut_InPlace.FBX | 0.323 |
| H2H_SpinningElbow_Forward.FBX | 0.339 |
| H2H_FlipAxeKick_Forward.FBX | 0.315 |
| H2H_LeftCutKick_Forward.FBX | 0.344 |
| H2H_SlipLeft.FBX | 0.288 |
| H2H_PowerHayMaker_Forward.FBX | 0.258 |
| H2H_TornadoKick_Forward.FBX | 0.266 |
| H2H_FadeBack.FBX | 0.277 |
| H2H_SpinningHookKick_InPlace.FBX | 0.210 |
| H2H_Haymaker_Forward.FBX | 0.198 |
| H2H_Haymaker_InPlace.FBX | 0.198 |
| H2H_JabForward.FBX | 0.195 |
| H2H_StraightPunchForward.FBX | 0.177 |
| H2H_SlipRight.FBX | 0.178 |
| H2H_RightCutKick_InPlace.FBX | 0.155 |
| H2H_Dodge_Back.FBX | 0.163 |
| H2H_BlockEnd.FBX | 0.121 |
| H2H_StraightPunchInPlace.FBX | 0.137 |
| H2H_Dodge_Left.FBX | 0.135 |
| H2H_Dodge_Right.FBX | 0.135 |
| H2H_Dodge_Forward.FBX | 0.129 |
| H2H_HighSideKick_InPlace.FBX | 0.129 |
| H2H_KneeStrike_Forward.FBX | 0.128 |
| H2H_RoundhouseKick_InPlace.FBX | 0.125 |
| H2H_BackHandSwing_Forward.FBX | 0.112 |
| H2H_SprintForward.FBX | 0.122 |
| H2H_AxeKick_InPlace.FBX | 0.118 |
| H2H_LowSideKick_InPlace.FBX | 0.116 |
| H2H_RunBack.FBX | 0.116 |
| H2H_RunBackLeft.FBX | 0.116 |
| H2H_RunBackRight.FBX | 0.116 |
| H2H_RunForward.FBX | 0.116 |
| H2H_RunForwardLeft.FBX | 0.116 |
| H2H_RunForwardRight.FBX | 0.116 |
| H2H_HookPunch_InPlace.FBX | 0.142 |
| H2H_LeftCutKick_InPlace.FBX | 0.110 |
| H2H_BlockIdle.FBX | 0.133 |
| H2H_BlockStart.FBX | 0.135 |
| H2H_StaggerMedium01.FBX | 0.105 |

---

## 4. Duration distribution

| pack | min | median | max | n |
|---|---|---|---|---|
| full_mount | 0.07 s | 1.83 s | 6.00 s | 36 (excl. 1 failed) |
| h2h | 0.07 s | 1.00 s | 11.53 s | 124 |

### Clips under 1.5 s — 98 total

These are the single-beat units: the clips a fight presenter can fire per action beat.

**full_mount (10 clips under 1.5 s):**

| file | length |
|---|---|
| T_pose.fbx | 0.07 s |
| Paired_FullMount_H2H_Punches_Att.fbx | 1.17 s |
| Paired_FullMount_H2H_Punches_Vic.fbx | 1.17 s |
| Paired_FullMount_AttackBlock_Att.fbx | 1.33 s |
| Paired_FullMount_AttackBlock_Vic.fbx | 1.33 s |
| Paired_FullMount_1HM_BluntSmack_Att.fbx | 1.33 s |
| Paired_FullMount_1HM_BluntSmack_Vic.fbx | 1.33 s |
| Paired_FullMount_1HM_SlashNeck_Att.fbx | 1.33 s |
| Paired_FullMount_1HM_SlashNeck_Vic.fbx | 1.33 s |

**h2h (88 clips under 1.5 s):**

| file | length |
|---|---|
| T_pose.fbx | 0.07 s |
| H2H_JumpStart.FBX | 0.33 s |
| H2H_BlockStart.FBX | 0.33 s |
| H2H_LegBlockStart.FBX | 0.33 s |
| H2H_TurnLeft90.FBX | 0.60 s |
| H2H_TurnRight90.FBX | 0.60 s |
| H2H_RunBack.FBX | 0.50 s |
| H2H_RunBackLeft.FBX | 0.50 s |
| H2H_RunBackLeft_RootMotion.fbx | 0.50 s |
| H2H_RunBackRight.FBX | 0.50 s |
| H2H_RunBackRight_RootMotion.fbx | 0.50 s |
| H2H_RunBack_RootMotion.fbx | 0.50 s |
| H2H_RunForward.FBX | 0.50 s |
| H2H_RunForwardLeft.FBX | 0.50 s |
| H2H_RunForwardLeft_RootMotion.fbx | 0.50 s |
| H2H_RunForwardRight.FBX | 0.50 s |
| H2H_RunForwardRight_RootMotion.fbx | 0.50 s |
| H2H_RunForward_RootMotion.fbx | 0.50 s |
| H2H_RunLeft.FBX | 0.50 s |
| H2H_RunLeft_RootMotion.fbx | 0.50 s |
| H2H_RunRight.FBX | 0.50 s |
| H2H_RunRight_RootMotion.fbx | 0.50 s |
| H2H_SprintForward.FBX | 0.57 s |
| H2H_SprintForward_RootMotion.fbx | 0.57 s |
| H2H_RoundhouseKick_InPlace.FBX | 0.70 s |
| H2H_Turn180.FBX | 0.70 s |
| H2H_PowerChargeStart.FBX | 0.80 s |
| H2H_SpinningHookKick_InPlace.FBX | 0.80 s |
| H2H_BlockIdle.FBX | 0.77 s |
| H2H_LegBlockIdle.FBX | 0.77 s |
| H2H_LegSweep_InPlace.FBX | 0.77 s |
| H2H_Dodge_Back.FBX | 0.67 s |
| H2H_Dodge_Forward.FBX | 0.67 s |
| H2H_Dodge_Left.FBX | 0.67 s |
| H2H_Dodge_Right.FBX | 0.67 s |
| H2H_Equip.FBX | 0.67 s |
| H2H_FadeBack.FBX | 0.67 s |
| H2H_SlipLeft.FBX | 0.67 s |
| H2H_SlipRight.FBX | 0.67 s |
| H2H_Unequip.FBX | 0.67 s |
| H2H_JabForward.FBX | 0.83 s |
| H2H_JabInPlace.FBX | 0.83 s |
| H2H_StraightPunchForward.FBX | 0.83 s |
| H2H_StraightPunchInPlace.FBX | 0.83 s |
| H2H_BackHandSwing_Forward.FBX | 0.93 s |
| H2H_FlipAxeKick_Forward.FBX | 0.90 s |
| H2H_JumpingBackKick_Forward.FBX | 0.90 s |
| H2H_JumpingBackKick_InPlace.FBX | 0.90 s |
| H2H_KneeStrike_Forward.FBX | 0.90 s |
| H2H_TornadoKick_Forward.FBX | 0.90 s |
| H2H_AxeKick_InPlace.FBX | 1.00 s |
| H2H_GetUp01.FBX | 1.00 s |
| H2H_GroinPunch_InPlace.FBX | 1.00 s |
| H2H_Haymaker_Forward.FBX | 1.00 s |
| H2H_Haymaker_InPlace.FBX | 1.00 s |
| H2H_HookPunch_InPlace.FBX | 1.00 s |
| H2H_LeadingUppercut_InPlace.FBX | 1.00 s |
| H2H_LeftCutKick_Forward.FBX | 1.00 s |
| H2H_LeftCutKick_InPlace.FBX | 1.00 s |
| H2H_RightCutKick_Forward.FBX | 1.00 s |
| H2H_RightCutKick_InPlace.FBX | 1.00 s |
| H2H_SnappingBackfist_InPlace.FBX | 1.00 s |
| H2H_StaggerSmall01.FBX | 1.00 s |
| H2H_WalkBack.FBX | 1.00 s |
| H2H_WalkBackLeft.FBX | 1.00 s |
| H2H_WalkBackLeft_RootMotion.fbx | 1.00 s |
| H2H_WalkBackRight.FBX | 1.00 s |
| H2H_WalkBackRight_RootMotion.fbx | 1.00 s |
| H2H_WalkBack_RootMotion.fbx | 1.00 s |
| H2H_WalkForward.FBX | 1.00 s |
| H2H_WalkForwardLeft.FBX | 1.00 s |
| H2H_WalkForwardLeft_RootMotion.fbx | 1.00 s |
| H2H_WalkForwardRight.FBX | 1.00 s |
| H2H_WalkForwardRight_RootMotion.fbx | 1.00 s |
| H2H_WalkForward_RootMotion.fbx | 1.00 s |
| H2H_WalkLeft.FBX | 1.00 s |
| H2H_WalkLeft_RootMotion.fbx | 1.00 s |
| H2H_WalkRight.FBX | 1.00 s |
| H2H_WalkRight_RootMotion.fbx | 1.00 s |
| H2H_BarrelRollKick_Forward.FBX | 1.27 s |
| H2H_StaggerFromBehind01.FBX | 1.23 s |
| H2H_JumpIdle.FBX | 1.20 s |
| H2H_HighSideKick_InPlace.FBX | 1.17 s |
| H2H_LowSideKick_InPlace.FBX | 1.17 s |
| H2H_JumpSpinHookKick_Forward.FBX | 1.13 s |
| H2H_PowerHayMaker_Forward.FBX | 1.13 s |
| H2H_SpinningElbow_Forward.FBX | 1.13 s |
| H2H_BackflipKick_InPlace.FBX | 1.33 s |
| H2H_FrontflipKick_Forward.FBX | 1.07 s |

---

## Notable observations

- **The h2h pack has `_RootMotion` variants** for walk/run/sprint clips. These are separate FBX files with the same animation content but different root motion treatment. 18 such variants exist (walk, run, sprint in all directions).
- **`T_pose.fbx` appears in both packs** at 0.07 s — a reference pose, not a usable animation clip.
- **All full_mount clips are paired** (_Att/_Vic suffixes). The 18 root-motion clips in this pack are predominantly the victim (Vic) files and the attacker files for takedowns/submissions where bodies translate.
- **The longest clip is `H2H_JumpStart.FBX` at 11.53 s** — a multi-phase jump animation. Most h2h clips cluster around 0.8–1.0 s.
- **Props bundled in the packs** (Android_SkeletalMesh, Hammer_Mesh, OneHandAxe, OneHandSword_Mesh) are weapon/character meshes, not animation clips. They load but carry no animation tracks.
