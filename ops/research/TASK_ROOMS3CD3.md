# TASK ROOMS3CD3 - the dark strip under every room view + the door over the RECEPTION label (S236)

Seat: Codex (rooms exception, operator S234 - office/physio/reception only). Worktree `E:/FightCamp/wt/ROOMS3CD`, branch `codex/rooms3cd`
(merge origin/master into your branch first: round 2 is NOT on master - the S236 collect refused it, see FIRST below). Model: gpt-6-astra, high. Discipline: BOXING (the demo's club rooms).
Claude collects by diff. No feature switch (look fix).

## FIRST: round 2 broke four tests that pass on master (collect S236 refused it; run each in your worktree)
- equipment_store_props_test: "sweep sees six loaded floor props (found 7)"; "door to shelving / medicine_ball_tree / glove_airing_tree /
  bag_gantry / pegboard loaded sweep 0.000 m >= 0.9" - the new door leaf (a walking obstacle) seals the doorway or is counted as a prop.
- reception_club_props_test: "street to hall >= 1.4 m (measured 0.000 m)"; "door 0 to counter / phone / bell loaded-mesh sweep 0.000 m";
  "room fighter information has a visible backing plate"; "trophy cabinet is clear of the fighter information backing".
- gym_floor_view_test: "room <every room> open: hall front wall cut to a stub (16 walls)" at 1920x1080 and 1280x720.
- room_info_hud_test: "<every room> plate encloses all fighter information" (the room-HUD hide in fix 5 likely hid or shrank the plate).
Fix the cause in your code (never the tests' thresholds), then the strip below. Every one of these four must be green before you hand over.

## The defect (measured on round 2's own stills, docs/previews/rooms3cd2/after_*/02_*.jpg, 1920x1080)
1. The bottom ~7-12% of every room view is a dark grey corridor strip: physio strip mean RGB ~(60,60,59) = 0.28 of the room floor's
   brightness; reception 0.63. The operator marked it on S235 ("a dark slab fills the bottom of the frame"). Maria M45 section 3
   (research/M45_DOORS_CUTAWAY_REPLY.md): the strip shows the corridor floor as polished concrete #8C8780 (or the training-floor mat
   where the room opens onto it), at least 1.5 m deep in the default framing, ~20% darker than the room interior and never black; on the
   outer wall (office) the pavement #9A958C with a kerb; never the end of the world.
2. Reception: the open door leaf at the front partition hides the floor label ("REC PTION"). Move the label or swing the leaf so the whole
   word reads; same check for every room's floor label vs its door leaves.

## Do
- Find what the camera sees in that strip (corridor floor material / its light / a floor-edge face) - grep `_build_building`, `_build_line`,
  the corridor floor in GymClub3D.gd (never read whole) and ClubRoomBase.gd. Give it Maria's colour and light it to ~0.8 of the room floor.
- Labels: every room's floor label fully visible in its room view (no door leaf, prop or wall stub over it).

## ADDED S236 (operator, verbatim): "i want an option to remove all walls"
3. WALLS TOGGLE (new feature -> switch `walls_toggle` in GameSwitches.GAME_ON, read with GameSwitches.on()): a HUD button "WALLS" on the club
   floor AND in every room view, plus key `V`, cycling WALLS UP (full height) -> CUT (today's cutaway, the default) -> WALLS DOWN (every wall,
   partition and outer wall of the club lowered to its stub: floor, furniture, doors' frames at stub height and people stay; wall-mounted art
   hides with its wall, never floating - Maria M45 "Floating objects"). The Sims / Two Point Hospital walls-down button. The choice persists
   while the club scene lives. Walking routes and click targets do not change in any mode.
   Test (red first): `tests/walls_toggle_test.gd` - OFF control: no button, walls as today; ON: three presses cycle the modes; in DOWN every
   wall MeshInstance3D above stub height is hidden or scaled to the stub in office/physio/reception/locker/equipment/hall; no wall-mounted
   graphic stays visible above a lowered wall; routes from rooms_doors_test unchanged. Stills: one club-floor still in DOWN, one room in DOWN.

## Test (red on master first)
- Extend `tests/rooms_near_wall_test.gd` (or a new `tests/rooms_corridor_strip_test.gd`): the corridor floor material albedo within 10% of
  #8C8780 (or the zone mat) for office/physio/reception, and no door-leaf AABB overlapping a floor label's AABB (projected on the floor).
- Stills: club_room_still.gd -- as_game for office, physio, reception (after only); report the bottom-strip mean RGB and its ratio to the
  room floor the way this brief does (target 0.7-0.9).
- Bounded gate (never `--only room`): `python Godot/tools/run_tests.py --jobs 2 --only rooms_office_physio,club_rooms_split,gym_club_layout,office_room,reception_desk,rooms_doors,rooms_near_wall,rooms_training_hud,equipment_store_props,reception_club_props,gym_floor_view,room_info_hud,locker_club_props,see_through_occluders,room_camera_flow`
  (the S236 collect runs every test naming a touched script - 50 tests; a narrower gate is how round 2 shipped 4 reds)

## Prior research
M45_DOORS_CUTAWAY_REPLY.md (Maria), ROOMS3CD_DIGEST.md (your rounds 1-2), Feedback/2026-10-17-01..04 marked.png (operator marks).

## What would a human do?
The Sims / Two Point Hospital: the cut room sits in its building - a band of real corridor floor in front of the cut wall, a little darker
than the room, so the eye goes in.

## Prefab check
None - materials and light on existing geometry.

## The one trap
Brightening the corridor by adding a light that spills into the room changes the room's look the operator is reviewing - light the strip,
not the room (light mask, or albedo only).

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped scene: it must read RED on the defect; paste that number in your report.
2. Stills only via club_room_still.gd -- as_game (game camera).
3. For every still report: the strip RGB + ratio, labels fully readable, clipping, floating, paths, dark zones, HUD.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.
