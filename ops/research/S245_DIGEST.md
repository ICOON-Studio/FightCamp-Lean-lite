# S245 DIGEST - 2026-10-17 - Two Point FOV 17 gym camera, one key light, PADPAIR1W + ROOMSLOTS1 collected

## What now works (commits on master)
- **CAMFOV17** (364f1279) - operator board Q-S242-3, verbatim: "Two Point Museum FOV 17". The gym iso view is a PERSPECTIVE
  camera at FOV 17 (ClubRoomBase `ISO_FOV_DEG`), pulled back along the same view direction until it frames the floor height the
  ortho view did: `iso_distance(level) = (size/2)/tan(8.5 deg)` - floor_view 53.5 m, floor_far 120.4 m, floor_close / a room
  23.4 m. Zoom moves the camera (the pose tween), 90-degree Q/E turns keep the level's distance (`_iso_level_now`), far plane =
  floor_far distance + 200. Picking already used project_ray_origin/normal - the office desk click passes on the perspective ray.
- **Fixed-size tags on the new lens**: a `fixed_size` Label3D/Sprite3D is scaled by view DEPTH under perspective and by size/2
  under ortho, so every tag read 1/tan(8.5 deg) = 6.7x larger at FOV 17 (the "OFFICE PC" tag covered a third of the floor_far
  still - docs/previews/s245_fov17, the BEFORE). `_set_fixed_label_scale` multiplies each fixed-size tag's built pixel_size by
  tan(8.5 deg) while the iso lens is on (node_added hook, by instance id - a tag freed before the deferred call broke gym_club_3d_test).
- **One key light** - operator, on the iso stills: "are these shadows making sense to you ?" No: TrainingFloor3D's base `Sun`
  (25 deg above the horizon, yaw -70) and its `Fill` stayed on under GymLook2's `Key` (52 deg, yaw 38) - two shadow-casting
  suns from two directions, so every bag and bar threw two shadows, one long like low window light in a roofed gym. GymLook2.apply
  hides the base Sun + Fill. tests/gym_single_key_light_test.gd (red on master: ["Sun", "GymLook2/Key"]; OFF arm keeps the Sun).
- **Room view**: another room's tall furniture on the camera's line of sight now clears like exterior architecture (the
  equipment store's shelving masked the physio room centre - pre-existing, same view direction on master).
- **PADPAIR1W collected** (436851d8, Cursor #250 by diff): paired native MH pad round - coach + fighter on one clock at 1.15 m,
  facing, shared pace; GAME_ON `pad_pair`. Issue #250 closed.
- **ROOMSLOTS1 collected** (e995688b, Arena #251 by files): `scripts/rules/RoomSlots.gd` - each room's REQUIRED item slots +
  defaults (TWOPOINT_ALIGNMENT s3); `check(room, placed)` -> valid/missing/unreachable/filled. NOT wired yet.

## Evidence
- iso_camera_test: 7 FAIL on master (ortho, 60 m standoff) -> failures=0 (fov 17, distance per level, far plane, OFFICE PC
  pixel_size 0.000329, all room corners in frame, desk pick, physio/locker silent).
- iso_wall_rotation_test: failures=0 - at all 4 yaws: perspective FOV 17, floor_far distance 120.4, every room corner in frame,
  walls cut/full as before.
- room_camera_flow_test: red on master too (its "eye below 6.5 m" pose check was pre-iso, stale since S240; master's iso eye
  y=35.5) -> iso contract (FOV 17, room distance 23.4 from the room centre) + shelving fix -> 24/24.
- gym_single_key_light_test: 2 FAIL on master -> 0. pad_pair_wire_test failures=0. room_slots_test failures=0, reachable
  mutant -> 35 fails.
- run_tests --jobs 2: --only gym_hall,gym_club,coach,pads 21/0 (PADPAIR1W); --only iso,gym_club,office,station_pin,pick,
  room_camera,gym_look,single_key,pad_pair 28/0 (final tree).
- Stills on the game camera (as_game, hidden desktop): docs/previews/s245_fov17b (4 yaws x floor_far/floor_view, labels fixed),
  s245_onekey (one key light). Opened: framing matches the S243 ortho stills at each yaw; tags readable; one shadow per object.
- tools/placement_audit.gd: objects=189 flagged=61 - world AABB checks, camera-independent (no change from the lens).

## Decided (developer calls, reasons)
- Zoom = distance, lens fixed: Two Point's own camera works that way (TWOPOINT_ALIGNMENT s1); a fov tween would change the look per zoom.
- Tag scale per lens instead of retuning 6 pixel_size constants: one rule keeps every present and future fixed-size tag right on both lenses.
- room_camera_flow_test rewritten to the iso contract: its old check was red on master for a reason unrelated to the shot it guards.

## Noticed, not changed
- floor_view at yaw 45/225 puts the fighter at the frame edge (same on the ortho stills - floor_view aims at the hall, not him).
- The remaining Key light falls at 52 deg (a 2.3 m pull-up bar throws ~1.8 m of shadow); real ceiling strips throw shorter, near-
  vertical shadows. Ludo's GymLook2 number - goes to Ludo before any change (no defaults without direction).
- The blue cylinder on the stretch mats = GymLook2/Dressing/foam_roller_1 (0.24 x 0.45 m, standing on end - correct; plain mesh).

## Board
- Review: "Gym camera now Two Point Museum FOV 17 ..." (9 stills) and "Shadows: one key light now ..." (3 stills).
- Q-S242-4 (approval, still attached): OK to close CAMFOV17?

## Next (roadmap now)
(0) Read Q-S242-4 + his review comments. (1) PADPAIR1 visual gate - game-camera stills at the pads station (guard / contact),
mitts on the coach if the hands read bare. (2) Ask Ludo: key light angle for an indoor gym (with the s245_onekey still uploaded)
+ PLACEMENT1 slice C build-mode look (hammer, ghost colours, reason tooltip, buy panel) with RoomSlots in the ask. (3) Brief
Cursor slice C (B key, ghost via PlacementRules.check, RoomSlots.check for room validity). (4) ASSETAUDIT1 part B swaps.
(5) NIGHTLY8 Grok Dev PRs (fight_identity rivalry heat no-effect bug is in its brief).
