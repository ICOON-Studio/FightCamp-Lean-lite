# TASK_U148 - blind contract test for the CC skin's gloves and visibility (Cursor)

Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S61, 2026-09-23.

## Why
S61 put a Character Creator body on fighter A in the live room (`scripts/CCFighterSkin.gd`).
Claude's own test (`tests/fight_cc_skin_test.gd`) was written against Claude's implementation, so it
only ever agrees with it. This is the BLIND half: a test written from the CONTRACT below, never from
the code. **Do NOT open `scripts/CCFighterSkin.gd` beyond its signature lines** -
`grep -n "^func\|^static func\|^const\|^var" Godot/scripts/CCFighterSkin.gd` is all you may read of it.
Do not read `tests/fight_cc_skin_test.gd` either.

## Owned files
`Godot/tests/cc_skin_contract_test.gd` (new), `research/U148_DIGEST.md` (new). Nothing else.

## The contract (definitions - build your fixtures from these)
`CCFighterSkin.gd` is a RefCounted, `preload`able. Instance API:
- `mount(src_node: Node3D, src_aabb: AABB, discipline: String, path: String) -> bool`.
  `src_node` is a mounted fighter: it has a parent, and somewhere under it a `Skeleton3D` using OUR
  bone names (`Hips`, `LeftHand`, `RightHand`, `LeftLowerArm`, ... - the values of
  `FightClipRetarget.UE4_TO_OURS`). `path` is a `PackedScene` resource whose tree contains a
  `Skeleton3D` with UE4 names (the keys of `UE4_TO_OURS`, plus `middle_01_l/r`, `index_01_l/r`,
  `pinky_01_l/r`). Returns false, and adds NOTHING to the tree, when `path` does not exist or either
  skeleton is missing.
- After a true mount: `root` (Node3D) is a SIBLING of `src_node`; `skeleton` is its Skeleton3D;
  `paired` = how many `UE4_TO_OURS` rows found a bone on both sides.
- `root.scale` is uniform and equals `src_aabb.size.y * src_node.scale.y / CC_REST_HEIGHT_M`.
- `sync()`: root x,z = src_node's; root y = `src_node.position.y + src_aabb.position.y * src_node.scale.y`
  (his feet on the fighter's feet).
- Gloves: `gloves` is a Dictionary `"l"`/`"r"` -> Node3D child of `root`, each with a child named `Fist`.
  `glove_kind` is `"boxing"` for disciplines boxing, kickboxing, muay_thai; `"mma"` for mma; for ANY
  other discipline `gloves` is empty and `glove_kind` is `""`. A side whose hand bone is missing gets
  no glove.
- After `sync()`, each glove's `Fist` centre lies FORWARD of that side's wrist (the `hand_x` bone origin)
  along the wrist -> `middle_01_x` direction, between 0.03 and 0.15 of root-local metres from the
  wrist, and within 0.02 of that line; the glove node's +Y axis is parallel (dot > 0.98) to wrist ->
  middle. It follows: pose the hand to a new rotation, `sync()` again, the property still holds.
- `set_shown(false)`: `root` hidden, every SKINNED MeshInstance3D under `src_node` (one whose
  `skeleton` NodePath is non-empty) visible. `set_shown(true)`: the reverse. A NON-skinned mesh under
  `src_node` is never touched by either. `visible_source_meshes()` counts skinned src meshes visible
  in tree.

## Do
1. Build BOTH skeletons in code (no asset needed - the real CC export is gitignored and absent from
   worktrees). Pack the CC-side tree with `PackedScene.pack()`, save to `user://`, pass that path.
   Give the two skeletons DIFFERENT rest poses and proportions (never identical fixtures).
2. Assert every bullet above, plus a missing-path mount returning false with the parent's child count
   unchanged.
3. Prove it: break the module 4 ways in a scratch copy (skip hiding, wrong scale, glove at the wrist,
   gloves on for `bjj`) by pointing your test at the copy through a const you flip locally - each must
   fail your test. Report the four in the digest; ship the test pointing at the real module.
If the module DISAGREES with this contract, do not bend the test: report the disagreement in the
digest as a finding, with the failing line.

## Gate
Tier: a NEW test file only. `python Godot/tools/check_scripts.py Godot/tests/cc_skin_contract_test.gd`,
then that ONE test:
`Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/cc_skin_contract_test.gd`.
No suite. Branch `cursor/u148-cc-skin-contract`, digest, one `agent_comms.py send`. Do NOT edit HANDOFF.md.
