# TASK_KNEETRACK1 Result (Antigravity)

## Summary of Changes (Per Numbered Point)

### 1. `scripts/fight3d/KneeTrack.gd` (new, 122 lines < 150 lines)
- Extends `SkeletonModifier3D` and implements `static func align(skel: Skeleton3D, weight: float) -> void` and `_process_modification()` calling `align(get_skeleton(), influence * _weight)`.
- For both legs (`["LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "LeftToes"]` and `["RightUpperLeg", "RightLowerLeg", "RightFoot", "RightToes"]`):
  - Measures knee flexion `flex = 180.0 - rad_to_deg((hip - knee).angle_to(ankle - knee))` and the horizontal knee-to-toes angle `ang = atan2(off.dot(side), off.dot(fwd))` where `off` is the horizontal (XZ) projection of the knee's offset from the hip-ankle axis `axis = (ankle - hip).normalized()` and `fwd` is the horizontal ankle-to-toes direction.
  - Leaves human valgus/varus within `ALLOW_DEG = 20.0` deg untouched (`kept = clampf(ang, -allow, allow)`), and scales the correction past 20 deg by `w = clampf(weight, 0.0, 1.0) * smoothstep(STRAIGHT_DEG, BENT_DEG, flex)` where `BENT_DEG = 15.0` deg (full correction at and above 15 deg, including all frames >= 20 deg gated by `tools/knee_probe.gd`) and `STRAIGHT_DEG = 5.0` deg (easing smoothly to zero as the bend drops under 15 deg).
  - Lifts the target horizontal direction `want_xz` onto the plane perpendicular to the 3D `hip -> ankle` axis (`t_vec = want_xz * maxf(absf(axis.y), 1e-4) - Vector3.UP * (want_xz.dot(axis) * sy)`), so even when the leg is tilted in lunges, steps, or punches, the swiveled knee's horizontal projection lands on `want_xz` (`|track| <= 20 deg`, well below the 35 deg bar and with 0 frames past 90 deg).
  - Rotates only the **thigh** (`UpperLeg`) about `axis` by `swivel = Quaternion(axis, phi)`: because both hip and ankle lie on `axis` and the shin's (`LowerLeg`) local pose is untouched, the hip and ankle origins, knee bend `flex`, and shin-to-thigh `twist` remain invariant.
  - Counter-rotates the **foot**'s (`Foot`) local pose (`(ql1.inverse() * qf).normalized()`) so the foot's global rotation and toe positions stay exactly as the clip authored them.

### 2. `scripts/fight3d/BoxerBuild.gd` (139 lines < 500 lines)
- Preloads `KneeTrack` and attaches it via `KneeTrack.attach(skel, ap)` (with `noknee` control arm support) immediately before `FootPlant.attach(skel, ap, kt, ...)` and before `MetaHumanTwist`:
  - `FootPlant._solve` computes its two-bone IK bend plane from `axis0 = (c - a).cross(b - a)`, so running `KneeTrack` right before `FootPlant` ensures `FootPlant` bends the knee in the corrected plane over the toes instead of inheriting the clip's caved or backward knee plane.
  - Running `KneeTrack` and `FootPlant` before `MetaHumanTwist` ensures the thigh and calf twist bones (`thigh_twist_0*`, `calf_twist_0*`) read the corrected thigh and foot local rotations rather than the raw clip's roll.
- `KneeTrack._process_modification()` eases `_weight` toward `0.0` over `EASE_S = 0.2` s when the active clip matches `FREE = ["knockout", "win", "countdown", "fall"]`, freeing the legs on falls, knockouts, countdowns, and wins the same way `FootPlant.FREE` does.

### 3. `tools/clip_orbit.gd` (126 lines < 500 lines)
- Preloads `KneeTrack`, calls `KneeTrack.align(skel, 1.0)` on every frame right after `Stage.IdleMatch.freeze(bx, name, minf(in_cycle, length))`, and documents this in the header comment so the board's orbit previews show the knees over the toes as the fight plays them.

### 4. Line Counts
- `scripts/fight3d/KneeTrack.gd`: 122 lines (limit: 150)
- `scripts/fight3d/BoxerBuild.gd`: 139 lines (limit: 500)
- `tools/clip_orbit.gd`: 126 lines (limit: 500)
- `docs/agy/KNEETRACK1_result.md`: 38 lines (limit: 500)

### 5. Modifier Stack & Ziva S362 Trap Verification
- **How `Skeleton3D` evaluates the boxer's modifier stack in Godot 4.7:**
  During `Skeleton3D._notification(NOTIFICATION_UPDATE_SKELETON)` at the end of each frame, `Skeleton3D` saves the raw animation pose, runs every active `SkeletonModifier3D._process_modification()` in child order (`JoinSmoother` -> `TiredSag` -> `GuardTuck` -> `PunchReach` -> `HitSnap` -> `GloveClear` -> `ElbowClear` -> `KneeTrack` -> `FootPlant` -> `MetaHumanTwist`), uploads the resulting modified global poses to `RenderingServer` (`skeleton_bone_set_transform`, which is the pose the skinned mesh renders on screen), emits `skeleton_updated`, and then **restores** `Skeleton3D`'s bone array back to the raw animation pose (as documented in `tools/pose_tap.gd:2-4`).
- **Why Ziva S362 saw raw poses in `ZIVAFOOT1_result.md`:**
  1. `tools/join_probe.gd:99` read `skel.get_bone_global_pose()` from `await process_frame` *outside* the modifier stack, after `Skeleton3D` had already restored the raw clip pose.
  2. `JoinSmoother` specifically is stateful across frames (`_pending` / `_should_capture` / `_shown`): when `ap.play(clip, 0.0)` was called in `_process()` without `seek()`, `AnimationPlayer` did not apply the new clip until the next frame's `NOTIFICATION_INTERNAL_PROCESS`, so on the call frame `JoinSmoother._process_modification()` saw zero pose diff and overwrote `_before = _shown` with the old pose.
- **Why `KneeTrack` reaches the shown pose in the fight:**
  - `KneeTrack` is stateless per frame: every frame inside `_process_modification()`, it reads the current leg poses and writes `set_bone_pose_rotation` on `UpperLeg` and `Foot`.
  - Immediately after `KneeTrack` in the same `NOTIFICATION_UPDATE_SKELETON` pass, `FootPlant._process_modification()` reads `skel.get_bone_global_pose()` (seeing the corrected knee plane), `MetaHumanTwist._process_modification()` reads `skel.get_bone_pose_rotation()` (driving the thigh/calf twist helpers from the corrected rotations), any trailing reader modifier (`tools/pose_tap.gd`, used by `tools/sidestep_probe.gd` and `tools/smooth_probe.gd`) records the modified pose in `tap.shown`, and `Skeleton3D` uploads that exact pose to the `RenderingServer` skin buffer for rendering.
  - Because `KneeTrack.align(skel, 1.0)` is also idempotent (`|ang| <= ALLOW_DEG` after the first pass is a no-op), calling `KneeTrack.align(skel, 1.0)` directly after `seek()` in `tools/clip_orbit.gd` and `tools/knee_probe.gd` works seamlessly alongside the modifier stack.
