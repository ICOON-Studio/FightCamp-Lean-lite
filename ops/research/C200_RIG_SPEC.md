# C200 canonical fighter rig v1

## Decision and immutable reference

Use the existing f01 rig, not a new skeleton: `res://assets/models/fighters/f01_m_box_welter_rigged.glb`.
Its SHA256 is `b368689ce9e0db054a3e2a35f8de7ad6cb6c8ec9f61ba068c45aa111835543e5`. The importer refuses a changed reference; changing this file requires a deliberate rig-version migration and new pose evidence.

Exactly 22 bones, case-sensitive names below, no auxiliary deform joints. Hips is the only root. Units are metres, +Y up, +Z fighter forward, +X fighter left. Reference mesh height is 1.850000024 m. The origin is the existing body-centred asset origin, not a newly invented floor origin: mesh Y range -0.925000012..+0.925000012. Placement at the floor is a scene responsibility.

The rest is f01's measured near-T pose (including its small elbow/neck/hip offsets), not an idealized textbook T. All local bone bases are identity in this reference. The local translations below are f01 reference measurements, NOT universal admission values. Authoritative reference precision remains in the hashed GLB. Animation rotations in Godot 4 include rest, not just delta rotations. Keep the original inverse binds and skin weights when using f01. New meshes must follow the STRICT definition below, retaining their own PER-BODY translations and compensating inverse binds; renaming a foreign rig is insufficient.

| Bone | Parent | Local rest translation X, Y, Z (m) |
|---|---|---|
| Hips | none | 0.003281279, 0.104785159, 0.032554697 |
| Spine | Hips | 0.000221210, 0.101171881, -0.021678556 |
| Chest | Spine | 0.000221210, 0.122851565, -0.021678559 |
| UpperChest | Chest | 0.000221210, 0.137304693, -0.021678559 |
| Neck | UpperChest | 0.000294947, 0.151757807, -0.028904747 |
| Head | Neck | -0.000221210, 0.057812512, 0.021678559 |
| LeftShoulder | UpperChest | 0.065330625, 0.137304693, -0.028241117 |
| LeftUpperArm | LeftShoulder | 0.130071342, -0.028906286, 0.001327258 |
| LeftLowerArm | LeftUpperArm | 0.259995222, -0.007226527, 0.017106891 |
| LeftHand | LeftLowerArm | 0.230500579, 0.021679699, 0.074621439 |
| RightShoulder | UpperChest | -0.064740732, 0.137304693, -0.029568378 |
| RightUpperArm | RightShoulder | -0.130071357, -0.028906286, -0.001327258 |
| RightLowerArm | RightUpperArm | -0.260290176, -0.007226527, 0.011797857 |
| RightHand | RightLowerArm | -0.231975287, 0.021679699, 0.069902293 |
| LeftUpperLeg | Hips | 0.094087891, -0.057812501, -0.013493795 |
| LeftLowerLeg | LeftUpperLeg | 0.014673591, -0.440820336, -0.021531086 |
| LeftFoot | LeftLowerLeg | 0.007889807, -0.426367193, -0.064961948 |
| LeftToes | LeftFoot | 0.005677722, -0.086718738, 0.151823655 |
| RightUpperLeg | Hips | -0.093866684, -0.057812501, -0.008184761 |
| RightLowerLeg | RightUpperLeg | -0.006931245, -0.440820336, -0.028978482 |
| RightFoot | RightLowerLeg | -0.006562561, -0.426367193, -0.065109417 |
| RightToes | RightFoot | -0.016000837, -0.086718738, 0.151602447 |

## Admission: STRICT definition, PER-BODY proportions (C201)

STRICT: exactly the named 22 bones and parent chain; every local rest basis is identity within 0.5 degrees, with unit scale and no reflection; metres, +Y up, +Z forward, +X left; body-centred origin. Skeleton scene transforms are identity. Admission checks the centred vertical mesh bounds, arm-side orientation/centering and forward toe direction. These geometric checks cannot establish anatomical facing for an arbitrary adversarial mesh; source and rendered inspection remain required.

PER-BODY: bone lengths, local translations and stature belong to each character. Allowed mesh stature is 1.55?2.05 m. Do not stretch every body onto f01's limbs. Animation translation/hip scaling handles proportions. f01 remains the immutable reference and its SHA256 above is unchanged.

C200's original ?differs on 22 bones? comparison included translations. C201 inspection of ALL raw joint nodes found identity local bases already present on all twelve legacy bodies. Nine of the eleven non-reference bodies therefore needed no orientation repair; f06/f08 additionally required metre scaling from 1.00 to 1.75 m. Blender 5.2.1 exports explicitly reconstruct the canonical axes, preserve each joint head and bone length (scaled for f06/f08), preserve skin weights, and regenerate inverse binds from the new rests. See C201_DIGEST.md for world-space skin checks and the moving f03 comparison.

| Body admitted | Stature m | Max local basis error degrees | Result |
|---|---:|---:|---|
| f01 original | 1.85 | 0.000000 | ADMIT |
| f02_v1 | 1.85 | 0.000000 | ADMIT |
| f03_v1 | 1.75 | 0.000000 | ADMIT |
| f04_v1 | 1.75 | 0.000000 | ADMIT |
| f05_v1 | 1.85 | 0.000000 | ADMIT |
| f06_v1 | 1.75 | 0.000000 | ADMIT |
| f07_v1 | 1.75 | 0.000000 | ADMIT |
| f08_v1 | 1.75 | 0.000000 | ADMIT |
| f09_v1 | 1.85 | 0.000000 | ADMIT |
| f10_v1 | 1.85 | 0.000000 | ADMIT |
| f11_v1 | 1.75 | 0.000000 | ADMIT |
| f12_v1 | 1.75 | 0.000000 | ADMIT |

The new files use `<original_stem>_v1.glb`. Live originals and bindings are unchanged. f06/f08 are reusable bodies chosen by sex/weight, not bound to one fixed athlete; 1.75 m is the task-authorized fallback, not an invented athlete measurement. Live swap is deferred to S76 operator review.

## Single clip import route

`Godot/tools/import_fighter_clip.gd` is the offline entry for UE4 FBX, Cascy glTF, and glTF exported by video tools. It calls `FightClipRetarget` for loading, rest correction, sampling and hip displacement: no second pose solver or alternate map table. It saves a ready-to-address Animation `.tres` with canonical tracks and metre hip translations. Use `FightClipRetarget.address_tracks` when binding it to a skeleton.

```
python Godot/tools/check_scripts.py scripts/FightClipRetarget.gd tools/import_fighter_clip.gd
# Headless; no window. Run from the worktree root:
godot --headless --path Godot --script tools/import_fighter_clip.gd -- source=res://assets/anim/audition/ramsterz_h2h/H2H_HitReaction01.FBX reference=res://assets/anim/audition/ramsterz_h2h/T_pose.fbx output=user://react_head_canonical.tres start=2.47 end=3.03
# Mesh admission (nonzero exit on foreign naming, scale or rest):
godot --headless --path Godot --script tools/import_fighter_clip.gd -- mesh=res://assets/models/fighters/f01_m_box_welter_rigged.glb
```

For Cascy, pass `reference=res://assets/anim/audition/cascadeur/Cascy_rest_reference.glb`. It lacks UpperChest: the importer explicitly adds a canonical rest rotation track there. Never synthesize a duplicate chest rotation. Both source and rest must have all mapped source joints. Unknown rigs require `map=<JSON path>` with a one-to-one source-name to canonical-name dictionary and an explicit matching rest file; unknown/partial maps fail. A `.glb` extension alone no longer means Cascy in `name_map_for`.

Source and reference must use the same authored unit and axes. The existing hip-height ratio converts that source into f01 metres; the source's root travel remains under the live retargeter's established policy. This importer handles single-actor clips. Pair-contact and shared-origin bake options remain with the existing paired pipeline, and are not silently approximated here. Frame zero of a motion clip is not a substitute for its actual matching rest reference.

Imported animations must drive all 22 rotation tracks, use canonical names, contain no scale tracks and at most hip position tracks inside a 5 m body-motion envelope. Outputs carry source, reference, convention and units metadata; existing output paths are refused. Unsupported rigs fail closed. This is an explicit offline admission command, not an automatic EditorScenePostImport hook or a migration of the current clip bindings.

## Evidence and production practice

J49 sections 3 and 6/G6 support locking the template before scaling content. A small studio keeps a versioned master armature, applies units and axes at export, uses one retarget preset per source family, bakes once, and admits only validated output. Godot's standard BoneMap/SkeletonProfile import tools offer that pattern; here the existing measured per-bone rest fixer is preserved to protect RamsterZ. See [Godot's retargeting explanation](https://godotengine.org/article/animation-retargeting-in-godot-4-0/).

No SMPL, SMPL-X, MANO or BUDDI assets, models or tools are used. A generic video-tool glTF test fixture proves interchange plumbing only; it is not a licence or quality claim about any provider.
