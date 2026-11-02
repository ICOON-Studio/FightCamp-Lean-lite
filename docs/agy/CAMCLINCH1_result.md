# CAMCLINCH1 Result

## Changes per numbered point

1. **`FightStage.broadcast()` (`scripts/fight3d/FightStage.gd`)**:
   - Sets `camera.clinch_heads = [head_a, head_b]` while `clinch.holder >= 0`, and `[]` otherwise.
   - Each entry in `clinch_heads` uses the world position of the boxer's `Head` bone as shown (`gclear.shown_head - Vector3.UP * GloveClearScript.HEAD_UP_M` when `gclear.shown_head` is finite, otherwise `skel.global_transform * skel.get_bone_global_pose(id).origin` from `skel`), falling back to `boxers[i]["pos"] + Vector3(0, 1.6, 0)` if a skeleton is missing.

2. **`RingCamera.broadcast()` (`scripts/fight3d/RingCamera.gd`)**:
   - Added `CLINCH_YAW_DEG := 40.0`, `CLINCH_UP_M := 0.35`, and `var clinch_heads: Array = []`.
   - While `clinch_heads` has two entries, replaces the shot's side-on yaw with `_clinch_yaw()`, which tests `+CLINCH_YAW_DEG` and `-CLINCH_YAW_DEG` (clamped to `[-SIDE_ARC_DEG, SIDE_ARC_DEG]`) against the active side and selects the side whose `lens -> far_head` segment passes furthest from `near_head` (`Geometry3D.get_closest_point_to_segment`).
   - Raises the lens height by `CLINCH_UP_M = 0.35` above `sh["h"]` and aims `want_look` at the midpoint of the two heads `((clinch_heads[0] + clinch_heads[1]) * 0.5)`.
   - Eases smoothly into the clinch angle over ~0.4 s via the existing `delta * 3.0` lerp without cutting every frame, and eases back to the shot when `clinch_heads` is cleared, preserving all existing rules (`spot_inside` inside the ropes, `SIDE_ARC_DEG` clamp, referee `avoid`, opposite-side fallback, and `high_spot` corner crane).

3. **Line count (`scripts/fight3d/RingCamera.gd`)**:
   - `RingCamera.gd` is 361 lines (well under the 500-line limit).
