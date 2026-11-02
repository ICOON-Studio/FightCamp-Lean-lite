# U46 — Motifect (and Mixamo) free-pack audition

Audition date: 2026-09-11. Tool: `Godot/tools/audit_anim_pack.gd`.
Licence re-read on itch today, unchanged: **"Free for personal and commercial use in your games."**

Pack downloaded from CloudFront (no auth). Binaries live under
`Godot/assets/anim/audition/` (gitignored). This report + the tool are what
ship.

---

## 1. File manifest vs store page

Store claim was 40 clips. **On disk: 40 GLB + 40 FBX + 40 BVH.** Class split
matches the vendor page Claude already read — **no discrepancy**:

| class | count | files |
|---|---|---|
| WEAPONS | **17** | 10 sword + 6 staff + 1 spear |
| STRIKING | **16** | 8 muay thai + 8 TKD |
| GRAPPLING | **7** | 2 judo + 5 wrestling |

Every clip: **68 animated bones** in the GLB (BVH hierarchy lists 77 joints
including End Sites). **30 fps.** Durations from BVH `Frames:` (authoritative):

| file | frames | s | file | frames | s |
|---|---|---|---|---|---|
| sword_draw_stance | 150 | 5 | tkd_front_kick_high | 120 | 4 |
| sword_slash_horizontal | 120 | 4 | tkd_side_kick | 120 | 4 |
| sword_slash_diagonal_down | 120 | 4 | tkd_roundhouse_high | 120 | 4 |
| sword_thrust_forward | 120 | 4 | tkd_back_kick | 120 | 4 |
| sword_overhead_strike | 120 | 4 | tkd_jump_front_kick | 150 | 5 |
| sword_block_high | 90 | 3 | tkd_spinning_heel_kick | 150 | 5 |
| sword_parry_and_riposte | 150 | 5 | tkd_axe_kick | 120 | 4 |
| sword_spinning_slash | 150 | 5 | tkd_jump_spinning_kick | 180 | 6 |
| sword_sheathe | 120 | 4 | muay_thai_teep | 120 | 4 |
| sword_combo_slash_thrust | 210 | 7 | muay_thai_roundhouse | 120 | 4 |
| staff_spin_guard | 180 | 6 | muay_thai_knee_clinch | 120 | 4 |
| staff_overhead_strike | 120 | 4 | muay_thai_elbow_cut | 90 | 3 |
| staff_thrust | 90 | 3 | muay_thai_guard_stance | 300 | 10 |
| staff_sweep_legs | 120 | 4 | muay_thai_body_kick | 120 | 4 |
| staff_block | 90 | 3 | muay_thai_combination | 300 | 10 |
| staff_combo | 210 | 7 | muay_thai_push_kick_defense | 90 | 3 |
| spear_thrust_sequence | 150 | 5 | wrestling_double_leg_takedown | 150 | 5 |
| wrestling_single_leg_takedown | 150 | 5 | wrestling_body_slam | 180 | 6 |
| wrestling_guard_position | 300 | 10 | wrestling_stand_up_defense | 120 | 4 |
| judo_hip_throw | 180 | 6 | judo_ankle_sweep | 120 | 4 |

**Bone names (shared by every clip):**
`Hips, Spine1, Spine2, Chest, Neck1, Neck2, Head, Jaw, LeftEye, RightEye,
LeftShoulder, LeftArm, LeftForeArm, LeftHand, (+ finger chain),
RightShoulder, RightArm, RightForeArm, RightHand, (+ finger chain),
LeftLeg, LeftShin, LeftFoot, LeftToeBase, RightLeg, RightShin, RightFoot,
RightToeBase`.

---

## 2. Class counts the C75 way (a tag is not a clip)

### STRIKING

| class | count | evidence |
|---|---|---|
| jab | **0** | no dedicated clip |
| cross | **0** | |
| hook | **0** | |
| uppercut | **0** | |
| elbow | **1** | `muay_thai_elbow_cut` |
| knee | **1** | `muay_thai_knee_clinch` |
| kick | **14** | 7 TKD kicks + teep/roundhouse/body_kick + combo + push_kick_defense |
| block | **0** | (sword/staff blocks are weapons) |
| parry | **0** | |
| region reactions | **0** | |
| knockdown | **0** | |
| KO | **0** | |

`muay_thai_combination`'s *prompt* says "jab, cross, left hook, right body
kick, finishing with a knee" — that is a label on one 10 s single-actor clip,
not four punch clips. **Boxing still gets nothing usable as typed punches.**
`muay_thai_guard_stance` is a stance hold, not a block/parry/reaction.

### GRAPPLING

| class | count | evidence |
|---|---|---|
| takedown | **2** | double leg, single leg — **one body** |
| throw | **2** | judo hip throw, wrestling body slam — **one body** |
| guard | **1** | `wrestling_guard_position` — **one body in a shape** |
| half guard | **0** | |
| side | **0** | |
| mount | **0** | |
| back | **0** | |
| pass | **0** | |
| sweep | **1** | `judo_ankle_sweep` — **one body** |
| submission | **0** | |
| ground-and-pound | **0** | |

**The trap fired.** Motifect's grappling is a label. C75's structural point
survives the now-known manifest: **paired contact-matched two-body sequences =
0.** "Double Leg Takedown" is one body shooting at nobody.

---

## 3. Retarget audition (U42 / R94 method on f01)

R94's bar: Ludo clip → `exact_humanoid=22/22`, path rename only,
`moves_bones=22/22 unmatched=0`.

Motifect, path-only `BoneTrackGraft` onto `f01_m_box_welter_rigged.glb`:

| clip | exact by name | tracks matched | unmatched | moves_bones |
|---|---|---|---|---|
| `muay_thai_roundhouse.glb` | **9/22** | 10 | 59 | **9/22** |
| `wrestling_double_leg_takedown.glb` | **9/22** | 10 | 59 | **9/22** |

Exact hits: `Hips, Chest, Head, Left/RightShoulder, Left/RightHand,
Left/RightFoot`.

**Need a mapping table for 13 of 22 body bones:**
`Spine, UpperChest, Neck, Left/RightUpperArm, Left/RightLowerArm,
Left/RightUpperLeg, Left/RightLowerLeg, Left/RightToes`
(source names: `Spine1/Spine2/Neck1`, `LeftArm/LeftForeArm`,
`LeftLeg/LeftShin`, `LeftToeBase`, …).

Not zero motion — the nine exact-name bones do move — but **not R94's
ten-line rename**. Motifect is Mixamo-shaped (no `mixamorig:` prefix), so it
needs the same name table Mixamo would, plus a rest-pose check once mapped.
Fingers/eyes/jaw are extra unmatched noise our 22-bone roster never carries.

---

## 4. Mixamo jab — stopped on Adobe session

Mixamo API `/api/v1/products?...query=jab` returns **HTTP 403** without an
Adobe session. Per the task: download needs a session → **stop rather than
work around**.

What is already known without the file (C75 + public BoneMap practice), and
**not measured today**:

- Mixamo ships `mixamorig:` / `mixamorig_` prefixed bones (`Hips`, `Spine`,
  `Spine1`, `Spine2`, `Neck`, `Head`, `LeftArm`, `LeftForeArm`, `LeftUpLeg`,
  `LeftLeg`, `LeftToeBase`, …).
- Exact name overlap with `SkeletonProfileHumanoid` after stripping the prefix
  is small; a **~22-row BoneMap** is the normal Godot import path.
- Rest-pose / A-pose correction is commonly required on top of the name map
  (Godot retarget docs). **Unmeasured here — needs the jab FBX.**

**Ask the operator to export one Mixamo jab (Y-bot, FBX, no skin) into
`Godot/assets/anim/audition/mixamo/` and re-run:**

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot \
  --script tools/audit_anim_pack.gd -- graft \
  <abs>/f01_m_box_welter_rigged.glb <abs>/jab.glb
```

(Convert FBX→GLB first, or extend the tool for FBX.) Until then Mixamo's
`moves_bones` cell stays **NV**.

---

## 5. Is the $60 worth it? Recommendation

| question | answer |
|---|---|
| Does Motifect clear boxing punches? | **No.** jab/cross/hook/uppercut = 0. |
| Does Motifect clear paired ground? | **No.** 7 single-actor labels. |
| Does Motifect clear kicks / elbows / knees / entries? | **Yes as single-actor clips**, after a 13-row name map. |
| Does Motifect clear R94's free path-rename? | **No.** `moves_bones=9/22` without a map. |
| Buy Unity "MMA Fight Actions" ($60, no manifest)? | **Still no.** Motifect already shows what a 40-clip generated pack yields: weapons dead weight, no punches, grappling labels. Paying $60 for an unpublished manifest buys the same risk. |
| Free path forward | **Mixamo for punches** (session needed to finish the bone measure) + Motifect for kicks/entries if we accept the map cost. Paired ground remains the RamsterZ Full Mount problem from the task brief — Motifect does not solve it. |

**Operator recommendation:** do **not** buy the $60 Unity pack on the strength
of this audition. Motifect is free evidence that a labelled "martial arts /
wrestling" pack can still be zero punches and zero paired ground. Finish the
Mixamo jab measure under an Adobe session before spending anything on striking;
treat paired ground as a separate purchase decision (RamsterZ), not something
Motifect or an unmanifested MMA pack will quietly include.
