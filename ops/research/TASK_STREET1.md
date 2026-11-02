# TASK STREET1 (S224) - no black void outside the gym: the floor camera sees a street (Ludo r61 C6)

Model: Goose (label `goose`, long cloud job). Branch goose/issue-<n>; never master. Read `.github/CLOUD_AGENT.md` first.
Approved: operator Q-S221-3 "Approve, build it" on `research/LUDO_ROUND61_VERDICT_S223.md` C6 ("a low-poly street outside
(brick neighbours, alley, city skyline) so the camera never shows black"). Ludo's words: `LUDO_ROUND61_REPLY_S223.txt` ~line 197.

## What exists
- `Godot/scripts/GymHallPanel.gd` (1202 lines) hosts the main floor screen; it can build `GymHall3D.gd` (HALL, ~line 13, 1918 lines)
  or `GymClub3D.gd` (CLUB, ~line 15, 2404 lines) - find which one the game shows with every GAME_ON switch on (`GameSwitches.gd`).
- `GymClub3D.gd` ALREADY builds a street (`_build_building`, ~lines 389-420): sidewalk, road, a 160 m ground plane, a neighbour
  building either side (STREET_WALL brick colour, line 76). The void Ludo saw is outside the north and west walls (the back and the
  left) and past the ground plane - and/or the scene the floor uses does not get this block at all.
- The WorldEnvironment's background (clear colour) shows where nothing is drawn.

## Do (switch `street_vista`, added to GameSwitches.GAME_ON - ships ON, read with `GameSwitches.on()`)
1. Move the street block into a small new script `Godot/scripts/club_look/StreetVista.gd` (static `build(parent: Node3D, w: float,
   d: float, h: float) -> Node3D`, primitives only - BoxMesh/PlaneMesh/QuadMesh, no imported assets, no LFS files) and call it from
   whichever hall scene the floor shows (and keep GymClub3D using it, same look as today when the switch is off).
2. Add what is missing so no camera angle the floor allows (all three zoom levels, every orbit the player can reach) shows the clear
   colour: a brick warehouse wall behind the north wall and the west wall (8-14 m tall, a few window rows as darker quads, 1-2 fire
   escapes as thin dark boxes), an alley strip of asphalt between, and a city skyline ring - 24-40 flat boxes in 3 grey-blue tones
   (#2A3240 / #3A4456 / #4A5568) at 60-120 m, heights 15-60 m, some lit windows as small emissive quads (warm #F2C46B, energy low).
3. Set the environment background to a dusk sky gradient (top #1B2233 -> horizon #4A3A3A), never pure black.
4. Budget: the whole vista under 120 MeshInstance3D nodes (use MultiMesh for windows if needed) and no shadows cast from the skyline.
OFF (`street_vista` off = plain --script tests): exactly today's scene.

## Gate
- Parse: `python Godot/tools/check_scripts.py <every touched .gd>`.
- New test `Godot/tests/street_vista_test.gd` (extends SceneTree; prints STREET_VISTA PASS checks=N / FAIL, quits non-zero): build the
  floor's hall scene with the switch ON (`GameSwitches` test override the other switch tests use) and check: nodes named
  "NeighbourN", "NeighbourW", "Alley", "Skyline" exist; skyline box count in 24..40; every skyline box 60-120 m from the hall centre;
  mesh node count of the vista <= 120; the environment background mode is not a black clear colour; then ray-cast from the floor
  camera's position at its 3 zoom levels over 36 yaw angles x 3 pitches (use the camera rig's own limits) and assert every ray hits
  a vista or hall mesh AABB or the sky - none escapes to an empty clear colour. OFF -> none of those nodes.
- Existing: `python Godot/tools/run_tests.py --jobs 2 --only gym_club,gym_hall,club_`.
- Claude makes the stills on the PC (game camera, all 3 zooms) - you do not need a GPU.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md, screen form)
1. Claude: a still of today's floor first (RED: black outside the north/west walls).
2. Claude: stills at the 3 zoom levels from the game's own flow (`-- as_game`, `Godot/tools/gymlook3a_stills.gd`).
3. Per still: any black, the skyline reads as a city, nothing hides the gym's own zones.
4. Not accepted until the operator sees them.

## Prior research
LUDO_ROUND61_REPLY_S223.txt part C; GymClub3D.gd S-notes at its header (Two Point / The Sims zoom levels); M_STYLE_SHEET_S206
(gym bright and alive).

## What would a human do?
Two Point Hospital / Theme Hospital: the plot sits in a dressed street; the camera can never look into nothing.

## Prefab check
Kenney City Kit (CC0) would fit but needs imported GLBs (LFS, no cloud CI) - primitives first; Claude may swap in Kenney later.

## The one trap
GymClub3D.gd and GymHall3D.gd are 2,400 / 1,900 lines and other agents work in them - move only the street block, keep every
other line; never read them whole (grep, sed -n windows).
