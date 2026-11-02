## DECISIONS

- Headless verdict: YES WITH OVERRIDES. The bind, bake, and unbind operators use ordinary object/scene/view-layer context, but a background script must explicitly set active/selected armatures; UI-only range framing is not part of the bake path.
- Sequence (3 core calls): `bpy.ops.armature.retarget_constrain_to_armature(...)` with S selected and T active; `bpy.ops.armature.retarget_bake_constrained_actions()` with T active; `bpy.ops.armature.retarget_unbind_armature()`.
- Mapping can be guessed with `object.retarget_guess`, or assigned directly through `S.data.retarget_retarget` and `T.data.retarget_retarget`. Use `Unreal_Mannequin_5_0.py` for RamsterZ-style source only as a starting point.
- Biggest risk: preset coverage and bone spelling. No shipped preset is a direct Godot humanoid target; Unreal/Mixamo source presets do not automatically map `Hips`, `LeftUpperArm`, etc. Verify every required field and use explicit mapping where needed.

`retarget_constrain_to_armature` requires at least two selected armatures and treats the active armature as the target. Its `src_preset` and `trg_preset` properties are names of preset files; `--Current--` preserves the already stored target mapping. The bake operator says it needs no second selected armature, but still reads active object, scene, selected objects, and view layer while collecting actions.

The add-on stores the primary mapping on `Armature.retarget_retarget` and scene helper state on `Scene.retarget_setting`; `Scene.retarget_bind_to` is the panel bind target. Mapping groups include face, spine, left/right arms, left/right legs, fingers, IK groups, root, and an `other_bone` collection.

All shipped presets are recorded in the JSON. `Mixamo.py`, `Mixamo_Control.py`, `Unreal_Mannequin.py`, and `Unreal_Mannequin_5_0.py` are the relevant source-side candidates; `Rigify_Controls.py`, `Rigify_Deform.py`, and `Rigify_Metarig.py` are the Rigify-side candidates. The add-on's preset handler loads these Python preset files and validates names against the armature.

No Blender or Godot execution was used for this forecast. The sequence should be tested in Claude's actual background Blender process with temporary context overrides if an operator reports a missing `VIEW_3D`/window area; the documented bake path itself does not intentionally invoke a modal viewport operator.
