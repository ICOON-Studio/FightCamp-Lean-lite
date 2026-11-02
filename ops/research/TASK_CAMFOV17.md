# TASK CAMFOV17 - the gym camera becomes Two Point Museum's: perspective FOV 17 (S245 first item)

Operator board Q-S242-3 (2026-10-17 16:15 UTC), verbatim answer: "Two Point Museum FOV 17". Supersedes Q-S239-1's orthographic iso
(Ludo's recommendation then). Discipline: BOXING (demo). Owner: Claude (camera + stills = GPU/visual). Frame:
research/TWOPOINT_ALIGNMENT.md section 1 (measured: FOV 17, pitch 35-90 deg down + zoom pitch offset +21 near -> 0 far,
initial yaw 235, height 20-280 m). Stills already prove the look: docs/previews/s244_fov17 (tools/fov24_stills.gd fov=17).

## Route (traced S244)
- `scripts/club_rooms/ClubRoomBase.gd`: `_sync_iso_projection(level)` sets PROJECTION_ORTHOGONAL + ISO_NEAR/ISO_FAR when
  `_iso_camera_active_for_level`; `_iso_ortho_size(level)` (ISO_SIZE_FAR 36 / VIEW 16 / CLOSE 7, lines 24-26) and `_tween_iso_size`
  drive the zoom; `_iso_pose_from_target(target)` (line ~260) places the camera; `iso_turn` / IsoWallCut keep the 90-degree steps.
- Change: PROJECTION_PERSPECTIVE, fov 17, camera distance d = (size / 2) / tan(8.5 deg) along the same view direction (floor_view
  16 -> 53.5 m, floor_far 36 -> 120 m, floor_close 7 -> 23.4 m); zoom tweens the DISTANCE, not `size`; near 1.0, far d + 200.
  Keep the 90-degree Q/E steps for live play (ISOWALL1, Ludo r110 C1); TPM's free yaw only arrives with build mode (PLACEMENT1 C).
  Pitch: keep today's iso pitch at floor_view/far; floor_close may add TPM's zoom pitch offset (+ up to ~15 deg) - stills decide.
- Labels: `Label3D.fixed_size = true` with pixel_size tuned for ortho (GymClub3D lines ~1329, 1341, 1446, 1967, 2030; the
  OFFICE PC tag blew up at FOV 24) - retune so each reads the same height on screen as in the ortho stills.
- Picking: anything that turns a screen point into a floor point for ortho (project_ray_origin/normal assumptions, pick marks,
  station pins, office desk click) must work with a perspective ray - test the office desk click and a station pick.
- Ceiling: the iso cutaway hides (S244) key off `iso_view_active()` - keep that true for the new camera.

## Tests (red on master first)
- `tests/iso_camera_test.gd` + `tests/iso_wall_rotation_test.gd` assert the projection/size - update them to the new contract
  (perspective, fov 17, distance per level) - the OFF arm (plain --script) keeps the old perspective broadcast camera.
- New check: at floor_view the whole hall fits (all 4 hall corners project inside the viewport) at each of the 4 yaws.
- `--only iso,gym_club,office,station_pin,pick --jobs 2` unchanged or better.

## Visual gate
Stills on the game camera at all 4 yaws (tools/isowall_stills.gd) + tools/placement_audit.gd clean + the office PC tag readable;
review_add + the operator's OK.

## Prior research
TWOPOINT_ALIGNMENT.md, TWOPOINT_MUSEUM_STUDY_S243.md, Ludo r110 C1 (FOV 24 proposal), S243/S244 digests.

## What would a human do?
Copy the reference game's lens and keep everything else: same view direction, same framing, a long telephoto so the gym reads like
a model under glass with just enough depth.

## Prefab check
Godot Camera3D built-in - no asset.
