# TASK GYMLOOK2B - the gym's equipment colours and a busy morning on the floor (S197)

## Owned files
- `Godot/assets/data/gym_look2.json`
- `Godot/scripts/GymClub3D.gd`
- `Godot/scripts/TrainingFloor3D.gd`
- `Godot/scripts/club_look/GymLook2.gd`
- `Godot/scripts/club_look/GymLook2BagSway.gd`
- `Godot/scripts/club_look/GymLook2Dress.gd`
- `Godot/scripts/club_zones/ClubZoneFloor.gd`
- `Godot/scripts/club_zones/ClubZones.gd`
- `Godot/tests/gym_look2_props_test.gd`

Model: Codex gpt-6-luna MEDIUM (or Cursor). Starts AFTER GYMFILL1 is merged (same item builder). Worktree E:/FightCamp/wt/GYMLOOK2B.
Operator S197 approved Ludo's gym look ("approve all", Q-S196-1) and wants "the next stills to be beautiful"; he will see the UI only
"when everything is wired in a proper way to make sense for me to play". Spec: research/LUDO_ROUND32_S197.txt PART 1
(1.1 equipment palette, 1.4 environmental life and props). The lighting/environment half is already built (scripts/club_look/GymLook2.gd,
assets/data/gym_look2.json, switch gym_look2).

## Build, behind the same switch `gym_look2`
1. Palette (1.1): every catalogue item's greybox gets Ludo's three materials by category (primary shell / accent trim / hardware:
   albedo hex, roughness, metallic). Put the table in gym_look2.json `palette` keyed by catalogue `category` (equipment_catalog.json);
   apply where the club builds item meshes (find the builder GYMFILL1 uses; one place, never a second builder).
2. Life (1.4), data-driven (`props` in gym_look2.json, per zone): towels, chalk bowls, water bottles, loose plates near racks, gym bags,
   foam rollers, resistance bands, a whiteboard, corner buckets + stools in the ring, 6 posters on the brick wall, the Wall of Fame
   frames, sweat/scuff decals under bags, cardio and the ring. Simple primitive meshes are fine (box/cylinder/quad + material) - no
   external assets. Heavy bags sway slightly (amplitude 0.08-0.35 m, only when a person trains there or idle micro-sway).
   450 dust motes as one GPUParticles3D (lifetime 12 s, slow drift) - skip on the low preset.
3. No prop may sit in a walkway, a door lane or the ring clearance (reuse gym_club_clearance_test geometry).
4. Test `Godot/tests/gym_look2_props_test.gd`: with gym_look2 ON the hall has >= 1 prop per zone listed in 1.4, every catalogue category
   has a palette entry, no prop AABB overlaps a station footprint/walkway/door/ring clearance; with it OFF none of it exists.
5. Stills (Claude opens them; you cannot see images): 
   `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --resolution 1920x1080 --script tools/gym_club_stills.gd -- as_game gym3d_main gym4_club club_zones gym_look2 out=docs/previews/gymlook2b`

## Gates
Parse: `python Godot/tools/check_scripts.py <touched .gd>`; focused test above (NEVER _console.exe; pass = exit 0 + no SCRIPT ERROR + no FAIL);
related: `python Godot/tools/run_tests.py --only club_ --jobs 2`, `--only gym_club --jobs 2`, `--only gym_hall --jobs 2`.
## Prior research
LUDO_ROUND31_S197.txt Part 3, LUDO_ROUND32_S197.txt Part 1, S196_DIGEST.md (zones, catalogue, capacity), feedback "Gym floor = training floor"
(no bath, board or chairs on the training floor - the whiteboard goes on the stretch-zone wall).
## What would a human do?
A set dresser walks the floor zone by zone and adds the clutter real gyms have, then the lighter checks the shot.
## Prefab check
CC0 prop packs (Kenney, Quaternius gym props) - name the licence if used; primitives are acceptable for this pass.
## The one trap
Props on the floor block the fighter's walk paths - keep them on walls, racks, benches and zone edges. Commit on your branch, push; never master.
