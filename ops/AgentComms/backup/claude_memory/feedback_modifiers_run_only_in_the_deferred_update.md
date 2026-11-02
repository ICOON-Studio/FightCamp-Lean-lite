---
name: feedback_modifiers_run_only_in_the_deferred_update
description: S162b - SkeletonModifier3Ds run only in the skeleton's deferred update and Godot restores the unmodified poses after it; a pumped test must tick the tree and read the drawn pose inside skeleton_updated
metadata:
  type: feedback
---

S162b (2026-10-04): a FighterWrist modifier fired 66 times in a ticking probe, `Skeleton3D.advance()` in the pumped
cuff test changed nothing, and the ON-arm numbers were byte-identical to the unbound run.

**Why:** modifiers are processed inside the deferred NOTIFICATION_UPDATE_SKELETON (a ticking tree), the skins and
`skeleton_updated` see the modified poses, then Godot RESTORES the unmodified bone poses - `get_bone_global_pose`
afterwards never shows a modifier's work. A render diff against a 0-degree experiment is the proof the modifier reaches
the screen; a whole-second diff can miss brief mid-punch effects.

**How to apply:** a live-room test that must see modifiers pumps `_process` by hand with the room's own process off and
`await process_frame` once per sample; read bones through a cache captured inside `skeleton_updated`
(`CCFighterSkin.drawn_bone_pose`). Keep a modifier that must win LAST among the skeleton's children (`keep_wrist_last`).
See [[feedback_code_made_mesh_has_no_skeleton_path]].
