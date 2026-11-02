# TASK BAGRIG1 - every hanging bag hangs from a visible wall-mounted rig (no poles, no roof, nothing from nowhere) (S199)
Model: Codex gpt-6-luna medium (hard layout bits: gpt-6.1-sol). Worktree E:/FightCamp/wt/BAGRIG1, NEW branch codex/bagrig1 from origin/master
(`git worktree add E:/FightCamp/wt/BAGRIG1 -b codex/bagrig1 origin/master`). Behind a NEW switch `bag_rig` (career key, then cmdline user arg, default OFF; same pattern as `_use_skip_drawer` in GymHallPanel.gd). OFF = byte-identical to master.

## Operator (S199, verbatim): "remove the poles and ask ludo how to make the heavy bags design so that it doesnt show they hanging from nowhere"; "new asset generation is approved if needed for any asset that doesn't qualify for AAA-grade game".
The poles (a per-bag goalpost frame) are already reverted (474ba45c..). Chains still run to a 3.6 m "ceiling" (TrainingFloor3D.BAG_CEILING_M) that the roof-off camera never draws.

## Ludo's answer (saved verbatim): research/LUDO_ROUND34_S199.txt - READ lines 30-157 (recommendation, dimensions, materials, pendulum, speed bag + double-end bag).
Chosen system = WALL-MOUNTED CANTILEVER: a W150x18-style I-beam arm bolted to the wall through a 300x300x12 plate (4 bolts), a 60x60 SHS kicker strut at 45 deg up to an upper anchor plate, a swivel collar + shackle at the arm tip, 4 short chains (0.45 m, 35 deg pyramid) to the bag's triangle tabs. Steel #1E232A rough 0.45 metal 0.85; zinc bolts/chains/swivel #64748B rough 0.28 metal 0.92.
LUDO'S COORDINATES ARE MIRRORED AND DO NOT MATCH OUR HALL: his north wall at z=16.5-18 is OUR back wall z=0 (z_ours = 18 - z_ludo). Use his shapes and dimensions, not his coordinates. Bag centre must hang about 1.2-1.5 m from the wall (arm reach); arm at y ~2.2 so the bag top (1.65-1.8) clears; wall height 3.6.

## Facts about our hall (Claude measured)
- Station places heavy_bag_1..4 (gym_club.json "places"): zones [3.0..10.5, 0.2..2.2] = against the BACK wall, work z 1.9: these fit the rig as they are (reach ~1.2 m).
- speed_bag_1/2 places [0.3..2.7, 0.1..1.5]: wall boards with their own post (shape wall_board) - keep, but the cord/ball must hang from the board, no cord to the ceiling.
- floor_zones items (gym_club.json "floor_zones", capacity-packed decor): heavy_bag in `bag_line` (x 0.58, 3.58, z 3.08) and `bag_east` (x 19.68, 22.68, 25.68, z 3.08) and ONE in `strength_east` (22.33, 12.16, mid-floor, wrong kind of zone) are 3-12 m from any wall: they cannot hang from a wall rig.
- Chain/cord code: TrainingFloor3D.gd `BAG_CEILING_M` (~514), model path chain (~663-667), ball cords (~655-658), greybox chain (~853). Operator rejected: floor-standing frames/poles, a floating ceiling slab.

## Owned files
- `Godot/scripts/TrainingFloor3D.gd` (large: sed windows; add a `_bag_wall_rig(node, reach, ...)` helper; the chain then ends at the shackle, NOT at 3.6)
- NEW `Godot/scripts/club_look/BagRig.gd` (the rig builder; keep TrainingFloor3D growth small)
- `Godot/assets/data/gym_club.json` (floor_zones heavy_bag items only; places only if a rig needs a node moved - then keep every layout/clearance test green)
- NEW `Godot/tests/bag_rig_test.gd`

## Spec
1. A rig is built per hanging heavy bag whose centre is within 2.0 m of a wall (back z=0, west x=0, east x=30): arm perpendicular to that wall, strut, two plates, 4 bolt heads, swivel+shackle, 4 chains from shackle to the bag top. NO part may exist above the wall top (3.6) or float: the arm's wall end must touch the wall plane (test: arm AABB min/max reaches the wall face).
2. Heavy bags that cannot be wall-adjacent: relocate to a free wall-adjacent spot ONLY if the zone stays valid (club_fill, club_zones, props, clearance tests), otherwise REMOVE them and keep the zone's variety (>=3 distinct kinds for strength zones, club_fill_test); report exactly which moved/removed. The strength_east heavy bag is wrong for its zone: replace with a strength item.
3. Double-end ball: arm from the wall at ~2.4 m with a short bungee to the ball, 8 mm cord down to a floor D-ring plate; if the ball is not within 2.0 m of a wall, relocate or remove it likewise.
4. Speed bag: keep the board+post; remove any cord to the ceiling; the bag hangs under the swivel.
5. Pivot: the shackle is a named `Marker3D` "Shackle" under the station node (so the future BagSwing/BAGHIT1 rotates the bag around it). Do NOT implement hit reactions here.
6. Visual only: no collision change; materials per Ludo's palette; total rig <= 950 tris per station (boxes/cylinders).
7. This is procedural PLACEHOLDER-QUALITY geometry done right. Ludo-generated AAA models for the bag (Ludo asset 01) and the rack (asset 02) come later (EQUIP3 runbook); keep `_bag_wall_rig` replaceable by a model.

## Test `bag_rig_test.gd` (extends SceneTree; prints `BAGRIG total=N fails=M`; quit(1) on fail, never quit(0) on pass)
(a) switch OFF: station node trees identical to master (child names + counts); (b) ON: every heavy bag station has Arm, Strut, 2 plates, Shackle marker, 4 chains; (c) arm touches the wall plane and nothing exceeds y=3.6; (d) no chain top is above its shackle (no chain to 3.6); (e) every heavy bag in `floor_zones` is within 2.0 m of a wall (else the test names it); (f) double-end ball and speed bag have no member above the wall top; (g) tris per station <= 950. 3 real mutants red.

## Gates
`python Godot/tools/check_scripts.py <touched .gd>`; bag_rig_test; then ALL: training_floor_3d_test, gym_prop_models_test, gym_club_3d_test, gym_club_layout_test, gym_club_clearance_test, club_fill_test, club_zones_test, gym_look2_props_test, gym_hall_3d_test, floor_pick_station_test, ludo_camera_test (S199: two neighbours broke when one test was run).
Godot only `Godot_v4.7.2-stable_win64.exe --headless` from the REPO ROOT (`--path Godot`; running from inside Godot/ runs nothing). If a class-cache error "Identifier not found" appears for an existing class, run `Godot --headless --path Godot --import` once.
## What would a human do? / Prefab check
A gym fitter bolts a steel arm to the wall and hangs the bag from it. Prefab: Ludo asset 01/02 (generated later, brand-new factory finish, operator-approved); no downloads now.
## The one trap
Codex cannot see images: do not claim it looks right. Claude shoots the game-camera stills (`as_game gym3d_main gym4_club club_zones gym_look2 [ludo_camera]`, tools/gym_club_stills*.gd) and judges. Commit explicit paths, push the branch, never master.
