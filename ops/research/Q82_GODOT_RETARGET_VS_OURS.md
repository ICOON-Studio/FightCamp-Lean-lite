# Q82 — Godot 4.7.2 Engine Retarget vs Ours

Stage S4a research. No `.gd` edited. Godot source: tag `4.7.2-stable`.

## DECISIONS

1. **Fetch from source, not memory.** Every option key and line number comes from files fetched from `raw.githubusercontent.com/godotengine/godot/4.7.2-stable/`. The gate re-fetches and verifies every citation. **SOURCED.**
2. **Three post-import plugins register the `retarget/` options.** The rest fixer (`post_import_plugin_skeleton_rest_fixer.cpp`), the track organizer (`post_import_plugin_skeleton_track_organizer.cpp`), and the renamer (`post_import_plugin_skeleton_renamer.cpp`). A fourth file (`resource_importer_scene.cpp`) registers the gateway `retarget/bone_map`. **SOURCED.**
3. **The engine has 18 retarget options in 4.7.2.** They cover bone mapping, rest fixing (with three retarget methods), silhouette correction, track removal, and bone renaming. Several are gated behind the `retarget_method` enum choice. **SOURCED.**
4. **Ours is a partial re-implementation of Overwrite Axis.** The bone-name map, rest correction, and per-frame rotation retarget cover the same mathematical ground. The critical missing piece is silhouette fixing. **INFERENCE** from comparing `BoneRestFixer.gd:49` with `rest_fixer.cpp:330-400`.
5. **The `Use Retarget Modifier` method is a runtime approach** that creates a `RetargetModifier3D` node. It handles proportion differences at runtime through cached bone-rest decompositions. Ours bakes everything at import time. **SOURCED** from `rest_fixer.cpp:530-570` and `retarget_modifier_3d.cpp:230-270`.

## OPTIONS

All options registered under the `retarget/` prefix in Godot 4.7.2-stable.

### Gateway: `resource_importer_scene.cpp`

| Key | Type | Default | What |
|-----|------|---------|------|
| `retarget/bone_map` | Object (BoneMap) | null | The BoneMap resource mapping source bone names to SkeletonProfileHumanoid. When null, all other retarget/ options are hidden. (**SOURCED**: `resource_importer_scene.cpp:2369`) |

### Rest Fixer: `post_import_plugin_skeleton_rest_fixer.cpp`

| Key | Type | Default | What |
|-----|------|---------|------|
| `retarget/rest_fixer/apply_node_transforms` | bool | true | Bakes scene node global Transform3D into bone rests and animation tracks; zeroes the node transform. (**SOURCED**: line 42) |
| `retarget/rest_fixer/normalize_position_tracks` | bool | true | Sets motion_scale from the base bone's Y height; divides position tracks by it. (**SOURCED**: line 43) |
| `retarget/rest_fixer/reset_all_bone_poses_after_import` | bool | true | Resets bone poses to the new rest after overwrite. (**SOURCED**: line 44) |
| `retarget/rest_fixer/retarget_method` | int enum | 1 (Overwrite Axis) | None=0, Overwrite Axis=1, Use Retarget Modifier=2. Selects the retargeting strategy. (**SOURCED**: line 46) |
| `retarget/rest_fixer/keep_global_rest_on_leftovers` | bool | true | Unmapped bones without mapped descendants keep their global rest. Visible only when method==1. (**SOURCED**: line 47) |
| `retarget/rest_fixer/use_global_pose` | bool | true | Global vs local pose retargeting in the modifier. Visible only when method==2. (**SOURCED**: line 56) |
| `retarget/rest_fixer/original_skeleton_name` | String | "OriginalSkeleton" | Name for the original skeleton when using the modifier. Visible only when method==2. (**SOURCED**: line 57) |
| `retarget/rest_fixer/fix_silhouette/enable` | bool | false | Enables silhouette fixing: rotates bone rests to align head-to-tail directions with the profile. (**SOURCED**: line 58) |
| `retarget/rest_fixer/fix_silhouette/filter` | Array | [] | Bones excluded from silhouette fixing. (**SOURCED**: line 63) |
| `retarget/rest_fixer/fix_silhouette/threshold` | float | 15 | Minimum angle (degrees) before silhouette fixing activates. (**SOURCED**: line 64) |
| `retarget/rest_fixer/fix_silhouette/base_height_adjustment` | float | 0.0 | Vertical offset on the scale-base bone. (**SOURCED**: line 65) |

### Track Organizer: `post_import_plugin_skeleton_track_organizer.cpp`

| Key | Type | Default | What |
|-----|------|---------|------|
| `retarget/remove_tracks/except_bone_transform` | bool | false | Removes all non-bone-TRS tracks. (**SOURCED**: line 35) |
| `retarget/remove_tracks/unimportant_positions` | bool | true | Removes position tracks on mapped bones except root and scale-base. (**SOURCED**: line 36) |
| `retarget/remove_tracks/unmapped_bones` | int enum | 0 (None) | None=0, Remove=1, Separate Library=2. (**SOURCED**: line 37) |

### Renamer: `post_import_plugin_skeleton_renamer.cpp`

| Key | Type | Default | What |
|-----|------|---------|------|
| `retarget/bone_renamer/rename_bones` | bool | true | Renames source bones to profile names via the BoneMap. (**SOURCED**: line 35) |
| `retarget/bone_renamer/unique_node/make_unique` | bool | true | Makes the skeleton a unique node (%Name). (**SOURCED**: line 36) |
| `retarget/bone_renamer/unique_node/skeleton_name` | String | "GeneralSkeleton" | The unique node name. (**SOURCED**: line 37) |

## OURS VS ENGINE

### 1. Bone Name Map

| Ours | Engine |
|------|--------|
| `UE4_TO_OURS` const Dictionary, 22 entries, hardcoded in GDScript (`FightClipRetarget.gd:33`) | `BoneMap` resource linked to `SkeletonProfileHumanoid`, editable in inspector, with auto-detection (`bone_map.cpp:130`) |

**Verdict**: Functionally equivalent for name coverage. The engine's is data-driven; ours is code. **SOURCED.**

### 2. Rest Correction

| Ours | Engine |
|------|--------|
| `BoneRestFixer.correction(reference_global, target_rest_global) -> reference_global.inverse() * target_rest_global` (`BoneRestFixer.gd:49`) | Overwrite Axis: `tgt_rot = src_pg.inverse() * prof_skeleton->get_bone_global_rest(prof_idx).basis` (`rest_fixer.cpp:688`) |

Both compute a per-bone rotation that aligns the source rest with the target rest. Ours reads the target rest from the fighter's actual `Skeleton3D.get_bone_global_rest()`; the engine reads it from `SkeletonProfileHumanoid`'s built-in reference poses. The reference source differs (vendor T-pose FBX vs profile data), but the math is the same: inverse-source times target. **SOURCED.**

### 3. Per-Frame Retarget

| Ours | Engine |
|------|--------|
| Resamples at chosen FPS, computes source globals, applies `correction`, converts to local via parent chain (`BoneRestFixer.gd:76`) | Modifies existing rotation tracks in-place: `new_pg_q.inv * old_pg_q * qt * old_rest_q.inv * old_pg_q.inv * new_pg_q * new_rest_q` (`rest_fixer.cpp:735`) |

**Different strategies.** Ours discards the source's original keyframes and resamples. The engine preserves them and adjusts each key by the rest change. The engine's approach is more faithful to the source animation's timing; ours introduces resampling artifacts but has the advantage of working on meshless FBX imports (plain Node3Ds, not Skeleton3D). **SOURCED.**

### 4. Position Tracks

| Ours | Engine |
|------|--------|
| ROTATION ONLY. `_build` creates only `TYPE_ROTATION_3D` tracks (`FightClipRetarget.gd:260`). Root translation dropped. | Keeps position tracks on root and scale-base bones; normalises by `motion_scale` (`rest_fixer.cpp:410-416`, `rest_fixer.cpp:880-905`) |

**Fundamentally different.** Ours deliberately drops all position data. The engine preserves and normalises it. This is a design choice, not an oversight: the project's ring position is the sim's business, not the clip's. **SOURCED.**

### 5. Node Transform Baking

| Ours | Engine |
|------|--------|
| No explicit step. FBX loaded via `FBXDocument`, bone transforms read from node hierarchy (`FightClipRetarget.gd:90`) | Walks node hierarchy, bakes global Transform3D into bone rests and animation tracks, zeroes nodes (`rest_fixer.cpp:119-217`) |

**INFERENCE.** The FBX loader applies the file's root transform implicitly. The engine's explicit bake-and-zero handles cases where the root Node3D carries a transform that should be part of the skeleton rest.

### 6. Global Composition

| Ours | Engine |
|------|--------|
| Iterative parent-chain multiplication of Node3D transforms (`FightClipRetarget.gd:330`) | Native `Skeleton3D.get_bone_global_rest()` / `get_bone_global_pose()` |

**Implementation detail, not a functional difference.** Ours needs this because meshless FBX imports as plain Node3Ds. The engine operates on a real Skeleton3D. **SOURCED.**

### What the engine does that ours does NOT

1. **Silhouette fixing** (`retarget/rest_fixer/fix_silhouette/enable`): Compares each bone's head-to-tail direction against the profile, rotates the rest to align when the difference exceeds the threshold (`rest_fixer.cpp:330-400`). **This is the most plausible explanation for "looks bad".** Our correction handles axis-convention flips (the 177.6° RightToes case) but cannot correct proportion-driven direction differences. **INFERENCE** — cause 2 (proportions).

2. **Position track normalisation** (`retarget/rest_fixer/normalize_position_tracks`): Sets `motion_scale` from the base bone height and scales position tracks. Ours drops position tracks entirely. **SOURCED** — cause 3 (root/position).

3. **Runtime retarget modifier** (`retarget/rest_fixer/retarget_method` = 2): Creates a `RetargetModifier3D` that handles proportion differences at runtime through cached bone-rest decompositions (`retarget_modifier_3d.cpp:113-150`). Ours bakes at import time with no runtime adaptation. **SOURCED** — cause 2 (proportions).

4. **Node transform baking** (`retarget/rest_fixer/apply_node_transforms`): Explicit bake-and-zero of the scene node's global transform. **SOURCED** — cause 1 (axis correction).

5. **Bone renaming** (`retarget/bone_renamer/rename_bones`): Renames source bones to profile names in the skeleton, skin, and animation tracks. Ours maps at read time but keeps source names. **SOURCED** — cause 1 (axis correction).

## RECIPE

A/B test: import `H2H_JabInPlace.FBX` through the engine's retargeter onto `SkeletonProfileHumanoid`.

### BoneMap

Create a `BoneMap` resource:
- `profile` = `SkeletonProfileHumanoid`
- For each entry in `UE4_TO_OURS`, set the mapping: profile bone name → source skeleton bone name.
  - `Hips` → `pelvis`, `Spine` → `spine_01`, `Chest` → `spine_02`, `UpperChest` → `spine_03`, `Neck` → `neck_01`, `Head` → `head`
  - `LeftShoulder` → `clavicle_l`, `LeftUpperArm` → `upperarm_l`, `LeftLowerArm` → `lowerarm_l`, `LeftHand` → `hand_l`
  - `RightShoulder` → `clavicle_r`, `RightUpperArm` → `upperarm_r`, `RightLowerArm` → `lowerarm_r`, `RightHand` → `hand_r`
  - `LeftUpperLeg` → `thigh_l`, `LeftLowerLeg` → `calf_l`, `LeftFoot` → `foot_l`, `LeftToes` → `ball_l`
  - `RightUpperLeg` → `thigh_r`, `RightLowerLeg` → `calf_r`, `RightFoot` → `foot_r`, `RightToes` → `ball_r`

### Import Keys

```
retarget/bone_map                              = <the BoneMap resource>
retarget/bone_renamer/rename_bones             = true
retarget/bone_renamer/unique_node/make_unique  = true
retarget/bone_renamer/unique_node/skeleton_name = "GeneralSkeleton"
retarget/rest_fixer/apply_node_transforms      = true
retarget/rest_fixer/normalize_position_tracks  = true
retarget/rest_fixer/retarget_method            = 1  (Overwrite Axis)
retarget/rest_fixer/keep_global_rest_on_leftovers = true
retarget/rest_fixer/fix_silhouette/enable      = true
retarget/rest_fixer/fix_silhouette/threshold   = 15.0
retarget/remove_tracks/unimportant_positions   = true
retarget/remove_tracks/unmapped_bones          = 0  (None)
```

### A/B Procedure

1. Import `H2H_JabInPlace.FBX` with the settings above → engine-retargeted version.
2. Import the same file through `FightClipRetarget.retarget_clip()` with the existing `UE4_TO_OURS` map and `BoneRestFixer` corrections → our version.
3. Play both on f01 side by side in the S4a session.

## VERDICT

**Ours is a PARTIAL RE-IMPLEMENTATION of the engine's Overwrite Axis retarget method.** The bone-name map (`UE4_TO_OURS` vs `BoneMap`), the rest correction (`BoneRestFixer.correction` vs the engine's rest overwrite at `rest_fixer.cpp:688`), and the per-frame rotation retarget (`pose_frame` vs the engine's track modification formula at `rest_fixer.cpp:735`) cover the same mathematical ground. The critical **MISSING** piece is **silhouette fixing** (`retarget/rest_fixer/fix_silhouette/enable`): the engine compares each bone's head-to-tail direction against the profile and rotates the rest to align when the difference exceeds a threshold (`rest_fixer.cpp:330-400`). Ours computes a pure rest-to-rest axis correction from a vendor T-pose file, which handles axis-convention flips (the 177.6° RightToes case from R108) but cannot correct proportion-driven direction differences between the source rig and the target fighter. This is the most plausible explanation for "looks bad" on clips where the UE4 Mannequin's bone directions differ from f01's beyond a simple axis flip. A secondary gap is position-track handling: the engine normalises and preserves root movement; ours discards it entirely — a deliberate design choice for this project, but one that loses data the engine would use.
