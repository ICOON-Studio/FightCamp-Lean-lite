# TASK GLOVEFIT - the glove contact capsule is fitted from an empty transform

Model: any (Arena). Tier: one script edited -> parse + the focused test below.

## Spec
`Godot/scripts/FightBodyCapsules.gd` (`_fit_glove_parts`, ~line 319-360) mounts the procedural gloves on a throwaway
rest-pose fighter that is NOT in the scene tree, then reads `glove.global_transform` and `mi.global_transform`.
Off-tree, Godot returns `Transform3D()` and logs `ERROR: Condition "!is_inside_tree()" is true` (8 times per room in
a recording, S160). So `wrist`, `along` and every fist vertex are computed from identity: the glove capsule the
contact solver uses is not where the drawn glove is.

Fix: compose the transforms by hand from LOCAL transforms - walk `node.transform` up the parent chain to the
`fighter` node (the same pattern `CCFighterSkin._skel_to_root` uses) - and use that instead of every
`global_transform` read in `_fit_glove_parts` (and `_world_of` if it has the same problem off-tree). The result must
be expressed in skeleton space exactly as today's code intends (`to_skel * ...`).

## Owned files
- `Godot/scripts/FightBodyCapsules.gd` (only `_fit_glove_parts` and helpers it calls)
- new test `Godot/tests/glove_capsule_fit_test.gd`

## Acceptance
1. `python Godot/tools/check_scripts.py Godot/scripts/FightBodyCapsules.gd Godot/tests/glove_capsule_fit_test.gd`
2. New test: build the capsules for one boxing fighter the way the live room does, assert (a) no
   `!is_inside_tree` path is taken (count calls with the fighter off-tree), (b) each glove capsule's axis passes within
   3 cm of that hand's wrist bone in skeleton space, (c) a control arm: the SAME fitter fed a glove frame at identity
   (the old bug) fails (b). Bound values, no exact-number asserts.
3. `python Godot/tools/run_tests.py --jobs 2 --only glove,capsule` green (run locally by Claude - CI has no LFS models).

## Prior research
S155/S156 digests (GLOVES fixed, Q213G glove_contact: the gate measures the glove as drawn). This defect is the
capsule fit, not the drawn glove.

## What would a human do?
Read the transform chain without the tree, exactly as the skeleton-to-root helper already does.

## Prefab check
None needed - a transform composition.

## The one trap
Do not add the throwaway fighter to the tree to make `global_transform` work: it would draw a third body for a frame
and fire `skeleton_updated` hooks. Compose the transforms.
