# U114 — Cascadeur retarget: the three repairs

**Agent:** Cursor · **Branch:** `cursor/u114-cascadeur-retarget` · **2026-09-21

## What changed

### 1. `CASCY_TO_UE4` (21 rows)

Added beside `UE4_TO_OURS` in `FightClipRetarget.gd`. Values are UE4 Mannequin keys;
`cascy_to_ours()` chains through `UE4_TO_OURS`. `UE4_TO_OURS` is untouched.

`PairedStagePlayer.graft_pair` selects the map when `is_cascadeur_clip(att_path)` (`.glb`/`.gltf`);
RamsterZ FBX paths still use bind-time `UE4_TO_OURS` corrections unchanged.

### 2. GLB loading

`_load_fbx` dispatches on extension: `.glb`/`.gltf` via `GLTFDocument` (same pattern as
`FightStagePlayer._load_glb`), `.fbx` via `FBXDocument` as before.

Skinned glTF imports expose bones on a `Skeleton3D`, not as loose `Node3D` nodes. Added
`_index_skel` / `_local_at` skeleton path so `_source_frames` and reference reads work on
Cascadeur exports (RamsterZ mesh-free FBX still uses `_index_walk`).

### 3. `UpperChest` inherits from `Chest`

In `_to_ours`, after name-map lookup, `_inherit_upper_chest` copies **Chest's global
`Transform3D`** onto `UpperChest` when the source rig has no third spine segment. That is
not a separate rotation drive — both bones share the same global pose for correction and
silhouette segment math. Cascy has no `spine_03`; our `UpperChest` would otherwise be
absent from `source_rest`.

glTF multi-character exports prefix joint names (`character1:pelvis`); `_strip_namespace`
normalizes before map lookup.

## Reference pose answer

**A T-pose is not required.** `build_silhouette_corrections` loads the reference with
`_local_at(index, null, 0.0)` (line 241 in the pre-U114 file; same call after edits) —
the file's **bind/rest hierarchy**, not an played animation. RamsterZ comments say
"T-pose" because `T_pose.fbx` happens to be their vendor rest; the code never checks arm
angle.

Cascadeur clips carry a single keyframe at t=0 in rest pose; corrections must match **the
pose the clip data is relative to**. Wired `Cascy_rest_reference.glb` via `CASCY_REFERENCE`
and `reference_for()`.

## Load proof (Godot headless)

```
U114_PROBE clip=C:/Users/user/AppData/Local/Temp/FightCamp-cascadeur-export/S30_CLINCH_A.glb
U114_PROBE corrections=22
U114_PROBE bones_mapped=22
U114_PROBE PASS
```

`retarget_clip` clears `_load_fbx`, maps 22 bones, returns `error=""`. No later-stage
failure on this static clinch export (length 0 s, one rest keyframe).

## Subset tests

| Subset | total | fails | failing names |
|--------|------:|------:|---------------|
| `--only clip` | 9 | 0 | — |
| `--only pair` | 5 | 1 | `fight_pair_live_test.gd` (baseline red, parked) |
| `--only grapple` | 9 | 0 | — |

`python research/U114_check.py` exits 0. Pinned literal: `EXPECTED_CASCY_MAP_ROWS=21`.
