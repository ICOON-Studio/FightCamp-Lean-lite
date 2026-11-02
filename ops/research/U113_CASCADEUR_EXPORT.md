# NO-GO — Cascadeur GLB cannot enter `FightClipRetarget` as-is; needs GLB loader + Cascy rename map + Cascy reference pose

Measured 2026-09-21 from the three on-disk exports. Bone counts use each file's **skin joint array**, not scene node counts.

---

## 1. What is in the box

Counts below are **skin joint array** lengths (unique names). Scene node counts are higher because Cascadeur exports controllers and helpers as nodes; only skinned joints matter.

| File | Scene nodes | Unique skin joints | Skins (joint counts) | Meshes | Skinned mesh | Animation |
|------|-------------|-------------------|----------------------|--------|--------------|-----------|
| `S30_CLINCH_pair.glb` | 134 | **132** | 132, 57, 57 | 2 | yes | 1 clip, **198 channels**, **1 keyframe at t=0.0 s** (length 0.0 s) |
| `S30_CLINCH_A.glb` | 67 | **66** | 66, 57 | 1 | yes | 1 clip, **198 channels**, **1 keyframe at t=0.0 s** |
| `S30_CLINCH_B.glb` | 67 | **66** | 66, 57 | 1 | yes | 1 clip, **198 channels**, **1 keyframe at t=0.0 s** |

**Axis / scale:** glTF 2.0 — **Y-up**, **metres** (default; no `asset.extras` override in these files).

**Hierarchy (Cascy, depth-truncated):** single root bone `pelvis`, max depth ~7 to fingertip chains.

```
pelvis
  stomach → chest → neck → head → hair
                  ├→ clavicle_l → arm_l → [arm_twist_l] → forearm_l → hand_l → (16 finger bones) + weapon_l
                  └→ clavicle_r → arm_r → [arm_twist_r] → forearm_r → hand_r → (16 finger bones) + weapon_r
  thigh_l → calf_l → foot_l → toe_l
  thigh_r → calf_r → foot_r → toe_r
```

**Are `_A` and `_B` one body each?** Yes. Each has **one** skinned mesh, **66** unique skin joints, and **67** scene nodes (66 bones + scene root). They are not a hidden pair: `S30_CLINCH_pair.glb` is the only file with two bodies (**132** unique joints = 66 + 66, second set prefixed `character1:`, **two** meshes). `_B` names carry the `character1:` prefix on skin joints; stripped before comparison they match `_A` exactly.

The secondary skin (57 joints) in each file is a **subset** of the main 66-joint rig — not a second character.

---

## 2. Bone correspondence: Cascy → f01 (`f01_m_box_welter_rigged.glb`)

Our fighter rig has **22** skin joints: `Hips`, `Spine`, `Chest`, `UpperChest`, `Neck`, `Head`, shoulders/arms/hands/legs/feet/toes.

**Prefix handling:** `_B` joint names are compared after stripping `character1:`.

### Direct match against `FightClipRetarget.UE4_TO_OURS` keys (no rename)

**12 / 22** exact key matches: `pelvis`, `head`, `clavicle_l`, `clavicle_r`, `hand_l`, `hand_r`, `thigh_l`, `thigh_r`, `calf_l`, `calf_r`, `foot_l`, `foot_r`.

### With a Cascy → UE4 rename map (cheap — naming only)

**21 / 22** of our bones reachable:

| Cascy bone | UE4 key | Our bone | Gap type |
|------------|---------|----------|----------|
| `pelvis` | `pelvis` | `Hips` | naming |
| `stomach` | `spine_01` | `Spine` | naming |
| `chest` | `spine_02` | `Chest` | naming |
| — | `spine_03` | `UpperChest` | **topology** — Cascy has no third spine segment |
| `neck` | `neck_01` | `Neck` | naming |
| `head` | `head` | `Head` | naming |
| `clavicle_l` | `clavicle_l` | `LeftShoulder` | naming |
| `arm_l` | `upperarm_l` | `LeftUpperArm` | naming |
| `forearm_l` | `lowerarm_l` | `LeftLowerArm` | naming |
| `hand_l` | `hand_l` | `LeftHand` | naming |
| `clavicle_r` | `clavicle_r` | `RightShoulder` | naming |
| `arm_r` | `upperarm_r` | `RightUpperArm` | naming |
| `forearm_r` | `lowerarm_r` | `RightLowerArm` | naming |
| `hand_r` | `hand_r` | `RightHand` | naming |
| `thigh_l` | `thigh_l` | `LeftUpperLeg` | naming |
| `calf_l` | `calf_l` | `LeftLowerLeg` | naming |
| `foot_l` | `foot_l` | `LeftFoot` | naming |
| `toe_l` | `ball_l` | `LeftToes` | naming |
| `thigh_r` | `thigh_r` | `RightUpperLeg` | naming |
| `calf_r` | `calf_r` | `RightLowerLeg` | naming |
| `foot_r` | `foot_r` | `RightFoot` | naming |
| `toe_r` | `ball_r` | `RightToes` | naming |

**Gaps — Cascy → our (44 bones, no target):**

| Cascy bone | Gap type |
|------------|----------|
| `arm_twist_l`, `arm_twist_r` | topology (twist splits; we have none) |
| 32 finger bones (`f_*`) | topology (we have no finger chain) |
| `hair` | extra prop |
| `weapon_l`, `weapon_r` | extra prop |

**Gaps — our → Cascy (1 bone):**

| Our bone | Gap type |
|----------|----------|
| `UpperChest` | topology (no `spine_03` / third spine in Cascy) |

---

## 3. What `FightClipRetarget` would do with this export

Read `Godot/scripts/FightClipRetarget.gd` (not modified).

**Would it accept this skeleton today? No — three independent blockers:**

1. **Format:** `_load_fbx` (line 667) uses `FBXDocument` only. These exports are **GLB**. `retarget_clip` would return `"could not load …"` before any bone is read. `FightStagePlayer` already has a `_load_glb` via `GLTFDocument` (line 1110), but the retargeter does not call it.

2. **Name map:** `PairedStagePlayer.graft_pair` hardcodes `FightClipRetarget.UE4_TO_OURS` (line 161). Against raw Cascy names only **12/22** bones map. A `CASCY_TO_UE4` rename table (21 rows, see §2) fixes naming for all but `UpperChest`.

3. **Reference pose:** `build_silhouette_corrections` loads `reference_fbx_path` through `_load_fbx` and applies `UE4_TO_OURS`. Paired bindings use `PAIRED_REFERENCE` = `res://assets/anim/audition/ramsterz_h2h/T_pose.fbx` — the **UE4 Mannequin** T-pose, not Cascy. Corrections built from the wrong reference would silently fold the clip (R108 failure mode).

**Per-joint rotation error:** not measured here. Computing the retarget correction and sampled pose error requires Godot (`BoneRestFixer`, skeleton rest reads). No number is reported.

**Single smallest change that would let it run end-to-end:** extend `_load_fbx` to also accept `.glb` via `GLTFDocument` (copy the pattern from `FightStagePlayer._load_glb`), **and** pass a `CASCY_TO_UE4` map (or equivalent) instead of bare `UE4_TO_OURS`, **and** supply a Cascy T-pose reference file exported from Cascadeur. Any one of the three alone is insufficient.

**Cheapest repair for S31 (ordered):**

1. Add `CASCY_TO_UE4` constant beside `UE4_TO_OURS` (naming only, 21 rows).
2. Teach `_load_fbx` / `_source_frames` to load `.glb` (one function, ~10 lines).
3. Export Cascy T-pose once from Cascadeur as FBX or GLB for `build_silhouette_corrections`.
4. Accept `UpperChest` inherits from `Chest` (one missing spine segment — likely acceptable for a clinch hold).

---

## 4. Format: GLB vs FBX for paired binding

`PAIRED_BINDINGS` paths are **`.fbx`** (`FightClipBinding.gd:880–949`). That table is not format-agnostic in practice: every paired graft goes through `FightClipRetarget.retarget_clip(att_path, …)` which calls `_load_fbx`.

Non-paired bindings can use GLB directly (`combo_jab_cross_hook.glb` at line 27) but those skip retarget (`retarget: false`).

**S31 cannot bind these GLBs through the existing paired retarget path without either:**

- re-exporting from Cascadeur as FBX, **or**
- extending `FightClipRetarget._load_fbx` to load GLB (code route above; no format conversion tool exists in-repo).

`PairedClipMount._clip_basename` strips `.glb` extensions for naming (line 93), but that is display only — it does not load the file.

---

## Gate

`research/U113_check.py` — exits 0 on the real exports. Pinned literals: `EXPECTED_CASCY_JOINTS=66`, `EXPECTED_RENAME_MATCHES=21`, `EXPECTED_UE4_DIRECT_MATCHES=12`. Tripwire: fails if `_A` and `_B` are byte-identical or any export is empty.
