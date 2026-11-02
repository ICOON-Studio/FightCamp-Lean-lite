# U148 digest — blind CC skin contract test (Cursor)

## Delivered
- `Godot/tests/cc_skin_contract_test.gd` — blind contract test from `TASK_U148_CC_SKIN_CONTRACT.md`.
- Fixtures: code-built Tripo-side skeleton (OUR bone names) and CC-side skeleton (UE4 map + finger
  chains), **different rest lengths/offsets**; CC tree `PackedScene.pack()` → `user://` with child
  `owner` set (otherwise Godot drops the skeleton from the packed scene).

## Gate
- Parse: `CHECK total=1 fails=0` on the test file.
- Run: `godot --headless --path Godot --script tests/cc_skin_contract_test.gd`
- **Current result with shipped `CCFighterSkin.gd`:** `checks=76 failures=12` (all glove geometry /
  follow-pose asserts). Mount, scale, sync, disciplines, `set_shown`, and missing-hand behaviour pass.

## Finding (module vs contract)
`_pose_glove` (`CCFighterSkin.gd` ~193–206) uses `skeleton.get_bone_global_pose().origin`, which stays
`(0,0,0)` on the code-built CC skeleton after `FighterSkinFollower` (same headless pattern as
`fight_stage_playback_test.gd` / `fight_clip_slice_test.gd`). `_pose_glove` then returns early and
gloves never align to wrist→middle; fist stays at built-in local offset only.

**Fix (verified locally, not committed — owned files only):** compose the pose chain and map into
root space, e.g. `_bone_point_in_root(bone, to_root)` using `get_bone_pose` walk, then
`p.append(_bone_point_in_root(int(i), to_root))`. With that change the contract test is **failures=0**.

## Scratch break proof (const flipped to `res://research/U148_break_*.gd`, not shipped)
| Break | Patch | Test line |
|-------|--------|-----------|
| skip hiding | `set_shown`: `(m).visible = on` instead of `not on` | visibility checks |
| wrong scale | `s = world_h / CC_REST_HEIGHT_M * 0.5` | scale assert |
| glove at wrist | `BOXING_GLOVE centre` 0.085 → 0.0 | Fist along-line asserts |
| gloves on bjj | `GLOVES["bjj"] = BOXING_GLOVE` | bjj bare asserts |

Each run: `failures=2` (targeted), with `_bone_point_in_root` fix applied on the scratch base so
glove tests are meaningful.

## Trap noted
Real CC export is gitignored; test never touches `cc_welter_01.fbx`.
