# TASK U102 — CURSOR — THE POSE BRIDGE: OUR RETARGETED TAKES OUT TO BLENDER AND BACK, EXACTLY

Model: `composer-2.5`, medium, `-p --force --trust`. Owner: cursor. Worktree
`C:/Users/user/AppData/Local/Temp/FightCamp-U80`, branch `cursor/u102-pose-bridge` (Claude creates it from `master`
before launch - do not switch branches). Push the BRANCH. Stage: S4a (THE MOVE SCRIPT).

**Test tier: A NEW MODULE, A NEW TOOL AND A NEW TEST - NO EXISTING SCRIPT EDITED.** Parse gate on the three files, the
one new test, one run of the new tool, then `U102_check.py`. No suite: nothing existing is touched.

## Owned files (these three only)

- `Godot/scripts/FightPoseBridge.gd` - NEW. Statics only, `extends RefCounted`, `class_name FightPoseBridge`, ZERO preloads.
- `Godot/tools/export_take_poses.gd` - NEW. `extends SceneTree`.
- `Godot/tests/fight_pose_bridge_test.gd` - NEW. `extends SceneTree`.

Everywhere you use the module, write `const Bridge := preload("res://scripts/FightPoseBridge.gd")` and call
`Bridge.<func>` - never the bare class name (a new class_name is unknown to a headless run until the editor rescans).

## Why this exists

The operator watched our 3D boxing match and said the thrower's punch and the receiver's reaction have no cohesion,
and asked "Why you don't use tools like blender ?". So each exchange (jab lands on the head, and so on) will be
AUTHORED IN BLENDER as one scene with both fighters on one timeline, then played back in our room. Our retarget of the
bought clips onto our fighters stays in Godot (it copies the source joint angles within 0.15 deg; Blender's add-on was
9 deg). So we need a bridge: our retargeted takes leave Godot as plain numbers, Claude's Blender script poses the
fighters from them, and the authored result comes back into Godot as an Animation on our skeleton. This task is the
Godot half. It must be EXACT: a round trip that moves a hand 5 mm is a new source of the jitter the operator hates.

## The format (a contract - Claude's Blender script reads and writes exactly this)

```
{"format": "fightcamp.pose_bridge", "version": 1, "fps": 60,
 "fighter": "<the mesh path the body was mounted from>",
 "skeleton_world": [12 floats],            // the Skeleton3D node's world transform in the room at setup
 "bones": [{"name": "Hips", "parent": -1, "rest": [12 floats]}, ...],   // Skeleton3D bone order; rest = SKELETON-SPACE GLOBAL rest
 "takes": {"jab": {"length_s": 0.8333, "contact_s": 0.2333, "times": [0.0, 0.016667, ...],
                   "pose": [[12 floats per bone, bones concatenated in the "bones" order], ...one row per time]}}}
```
- A transform is 12 floats: `[basis.x.x, basis.x.y, basis.x.z, basis.y.x, basis.y.y, basis.y.z, basis.z.x,
  basis.z.y, basis.z.z, origin.x, origin.y, origin.z]` - the three basis COLUMNS, then the origin.
- `pose` rows are SKELETON-SPACE GLOBAL transforms of every bone (the parent chain already composed), never locals.
- `times`: `k / fps` for `k = 0, 1, ...` while `k / fps < length_s - 1e-6`, then `length_s` itself as the last entry.
  So `length_s = 0.8333` gives 51 times, the last one 0.8333.
- `contact_s`: `FightStagePlayer.contact_s(<role>)` for a strike take, `-1.0` for anything else.

## The module API (a contract)

- `static func xform_to_array(x: Transform3D) -> Array` and `static func array_to_xform(a: Array) -> Transform3D`
- `static func sample_times(length_s: float, fps: float) -> PackedFloat64Array` - the rule above.
- `static func skeleton_block(skel: Skeleton3D) -> Array` - the `bones` array: name, parent index, global rest
  (`get_bone_rest` composed down the parent chain).
- `static func globals_at(skel: Skeleton3D, anim: Animation, t: float) -> Array` - one `Transform3D` per bone index,
  skeleton space: for each bone the take's keyed rotation / position / scale at `t` where a track exists (matched by the
  LAST subname of the track path, e.g. `Skeleton3D:LeftHand`), otherwise that channel of the bone's rest; composed
  `parent_global * Transform3D(Basis(rot) * Basis.from_scale(scale), pos)`. This is the same composition as
  `FightStagePlayer._sample_global` (`Godot/scripts/FightStagePlayer.gd:2297`) - read that function, and
  `_bone_tracks` at `:2275`, and match them exactly.
- `static func take_block(skel: Skeleton3D, anim: Animation, fps: float, contact_s: float) -> Dictionary`
- `static func animation_from(data: Dictionary, take: String, skel: Skeleton3D, skel_path: String) -> Animation` -
  builds a take on `skel` from the data: bones matched BY NAME (the target skeleton's bone order may differ from the
  data's); for each frame, `local = parent_global.affine_inverse() * global` with the parent taken FROM THE DATA row;
  a position track and a rotation track (quaternion from the orthonormalised basis) for every matched bone, and a
  scale track only when some frame's local scale differs from 1 by more than 1e-4; keys at the data's `times`,
  linear interpolation, `length = length_s`, track paths `skel_path + ":" + bone_name`. Data bones missing from `skel`
  are skipped; a skeleton bone missing from the data gets no track.
- `static func validate(data: Dictionary) -> PackedStringArray` - human-readable errors, empty when valid: format and
  version, `fps > 0`, non-empty bones with unique names and parents in `[-1, bones.size())`, each rest 12 floats, each
  take's `times` strictly increasing from 0 to `length_s`, `pose.size() == times.size()`, every row `12 * bones.size()`.

## The tool: `tools/export_take_poses.gd`

`-- side=a takes=jab,cross,hook_rear,react_head,idle out=<absolute path.json> fps=60`
1. Mount the live room exactly as `Godot/tools/probe_clip_keys.gd` does (87 lines - read it whole: it loads
   `res://scenes/FightWorldLive.tscn`, calls `configure({"seed": 94301, "rounds": 3})` and `setup()`, then takes
   `stage_players()[0]` for side a, `[1]` for side b, and its `animation_player()` / `skeleton()`).
2. Write the JSON above with `JSON.stringify` (no indent) to `out`. `fighter`: the room's `FIGHTER_A` constant for side
   a, its `_fighter_b_mesh` for side b. `skeleton_world`: the Skeleton3D's `global_transform`. For each take,
   `contact_s` is `player.contact_s(<take name>)` when the take is one of `FightStagePlayer.HAND_STRIKE_ROLES`, else -1.
3. VERIFY against production, for every take, at `t = 0, L/4, L/2, 3L/4, L` and every bone: the bridge's
   `globals_at` against `player.call("_sample_global", bone, anim, player.call("_bone_tracks", anim), t)`. Print
   `EXPORT VERIFY <take> max_rot_deg %.5f max_pos_mm %.4f` (rotation error = the angle of `a.basis.orthonormalized()`
   relative to `b.basis.orthonormalized()`; position error in skeleton units x 1000).
4. ROUND TRIP, for every take: `animation_from(data, take, skel, skel_path)` on the same skeleton (`skel_path` from the
   AnimationPlayer's root node to the Skeleton3D, as `FightStagePlayer.bind` computes it at `:161-163`), then
   `globals_at` on the built animation at every exported time against the exported rows. Print
   `EXPORT ROUNDTRIP <take> max_rot_deg %.5f max_pos_mm %.4f`.
5. Print `EXPORT DONE takes=<n>` and quit.

## The test: `tests/fight_pose_bridge_test.gd`

No room, no mesh: build a `Skeleton3D` in code with 5 bones (a root with a non-identity rest rotation and offset, and a
4-bone chain with rests rotated about different axes), and an `Animation` of 0.5 s with rotation keys on three bones
and position keys on the root. At least 12 checks, including: `sample_times(0.8333, 60)` has 51 entries, first 0,
last 0.8333; `sample_times(0.5, 60)` has 31 entries; `xform_to_array` / `array_to_xform` is an identity on a rotated,
translated transform; `skeleton_block` rests equal the composed rests; `take_block` -> `animation_from` on a SECOND
skeleton with the same bone names in a DIFFERENT order -> `globals_at` matches the first skeleton's globals within
1e-4 at every time; the root's position survives; a data bone missing from the target is skipped without an error;
`validate` returns empty for good data and a non-empty list for a short pose row, for a wrong format string, and for
decreasing times. Counters live in a Dictionary (a GDScript lambda cannot increment a captured int). Last line:
`print("FIGHT_POSE_BRIDGE_TEST checks=%d failures=%d" % [...])`, then `quit()`.

## Gate, in order

1. `python Godot/tools/check_scripts.py Godot/scripts/FightPoseBridge.gd Godot/tools/export_take_poses.gd Godot/tests/fight_pose_bridge_test.gd`
2. Run Godot only through the wrapper (never pipe the console exe into PowerShell):
   `python C:/Users/user/AppData/Local/Temp/FightCamp-tools/godot_run.py C:/Users/user/AppData/Local/Temp/FightCamp-U80 tests/fight_pose_bridge_test.gd --timeout 600`
   and save its log as `C:/Users/user/AppData/Local/Temp/u102_test.log`.
3. `python C:/Users/user/AppData/Local/Temp/FightCamp-tools/godot_run.py C:/Users/user/AppData/Local/Temp/FightCamp-U80 tools/export_take_poses.gd --timeout 1200 -- side=a takes=jab,cross,hook_rear,react_head,idle out=C:/Users/user/AppData/Local/Temp/u102_f01.json fps=60`
   and save its log as `C:/Users/user/AppData/Local/Temp/u102_tool.log`. (If the wrapper's argument form differs, run
   `python C:/Users/user/AppData/Local/Temp/FightCamp-tools/godot_run.py --help` once.) A `SCRIPT ERROR` line means
   fix and rerun; rc=0 alone is not a pass.
4. `python research/U102_check.py C:/Users/user/AppData/Local/Temp/u102_f01.json C:/Users/user/AppData/Local/Temp/u102_tool.log C:/Users/user/AppData/Local/Temp/u102_test.log`
   must print `U102_CHECK PASS`. **If it cannot, do not commit: send the BLOCKED mail with its FAIL lines.** Never edit
   the check.

## Deliver

Before the commit: `git restore --staged -- AgentComms/messages` (old mail from another task may be staged in this
worktree). Commit ONLY the three owned files with their paths on the commit line
(`git commit -m "U102: ..." -- Godot/scripts/FightPoseBridge.gd Godot/tools/export_take_poses.gd Godot/tests/fight_pose_bridge_test.gd`),
`git show --stat HEAD`, `git push -u origin cursor/u102-pose-bridge`, then
`python Tools/agent_comms.py send --from cursor --to claude --topic "U102 ready" --body "<the U102_CHECK line and the worst VERIFY / ROUNDTRIP numbers>"`.
Do not commit the JSON or the logs. Do not edit HANDOFF.md or AgentComms/roadmap.json.

## The trap

Headless `Skeleton3D.get_bone_global_pose()` returns the REST in these runs - never read a pose from the skeleton; every
global comes from composing the take's keys, exactly as `_sample_global` does. And `Basis(quaternion)` drops scale while
`Basis.get_rotation_quaternion()` needs an orthonormal basis: orthonormalise before taking a rotation, and keep scale on
its own channel, or a 1.05-scaled rest turns into a 3 deg rotation error.
