# TASK C225 - the training floor (the hub), tier 1, dressed to its concept art (Codex, S131)

Model: gpt-6-astra, reasoning effort HIGH (operator: "for codex (careful with model selection and effort) a more
important one" - the frontier model for visual judgement; not xhigh/max/ultra, the weekly limit was just reset).
You MUST open the concept image and every render you make and compare them side by side before each next pass.

## Goal
The training floor is the screen the player sees EVERY DAY - the most important room in the game. Make the tier-1 floor
read like `previews/concepts/gym_tier1_backroom_club.jpg`: a garage boxing club - bare BRICK walls,
DAYLIGHT through a big ROLL-UP DOOR, one row of heavy bags, a small mat area, worn concrete, hand-made signs and
flyers, the ring as the centrepiece; lived-in, BRIGHT and warm (project rule: dark or empty reads "abandoned").
Also read `concepts/CONCEPT_ART_INDEX.md` and look at `gym_tier2_boxing_academy.jpg` / `gym_tier34_team_hq.jpg` so tier 1
reads as the humble start of that ladder.

## Prior research (research/)
- `topics/gym_rooms_art.md` (canonical) - the floor, the six rooms, props, lighting pass S114, "bright and alive".
- `G130_WHAT_A_BETTER_GYM_LOOKS_LIKE.md` (tier by tier), `G122_WHAT_THE_WALLS_DO.md`, `G123_DECOR_AS_A_GAME_LAYER.md`,
  `D61_DIGEST.md` (fresh eyes on THIS floor as the hub), `D42`/`D43` (tier and wear read), `J16_THE_GYM_FLOOR_PLAN.md`
  (never copy a real gym). Search more: `python Tools/prior_research.py floor tier brick lighting`.

## What would a human do?
A lighting artist + set dresser: first the walls, the roll-up door and the daylight (the mood is 70% light and walls),
then signage/flyers/decor, then small lived-in props - re-rendering the SAME camera after each change.

## Prefab check
Repo props: `Godot/assets/models/props/gym/` (Tripo, ours - bags, weights, first aid, mitts ...), `props/kenney/` (CC0).
Blender 5.2.1 headless (`"C:/Program Files/Blender Foundation/Blender 5.2/blender.exe" --background --python x.py`,
exports GLB) for a roll-up door, brick trim, signs: GLB into `Godot/assets/models/props/floor/`, each < 1 MB, script under
`Godot/tools/blender/`. Brick/concrete textures: procedural (Godot noise/material) or Blender-baked - no downloads,
no purchases, no web images.

## Owned (edit ONLY these; everything else = send-back)
- `Godot/scripts/TrainingFloor3D.gd` (1771 lines - never read it whole; `sed -n` windows): ONLY code paths that run for
  tier 1 (guard every change with the tier value, e.g. `int(preset.get("tier", 1)) <= 1`). Anchors: `_build_shell` (206),
  `_build_floor` (288), `_build_walkway` (262), `_build_mirrors` (368), `_build_decor` (1568), `_build_camera` (1238 - do
  not move the camera; the player's view stays). DO NOT edit `_build_environment` (125) or anything else the room
  scripts inherit (Lobby3D, Office3D, LockerRoom3D, MatRoom3D, StaffRoom3D, PhysioRoom3D extend this script and other
  agents are editing those rooms right now). Stations, doors, fighters, coach, mastery, clock: untouched.
- NEW: `Godot/assets/models/props/floor/*`, `Godot/tools/blender/floor_*.py`, `previews/c225/*`,
  `research/C225_DIGEST.md`.

## Parse gate (before every render)
`python Godot/tools/check_scripts.py Godot/scripts/TrainingFloor3D.gd`

## Render (every pass; windowed Godot moved off-screen, never --headless)
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/s104_render_floor_t12.gd`
(writes tier-1 and tier-2 PNGs to `previews/s104/`; copy the tier-1 one to `docs/previews/c225/pass<N>.png`
and look at it; the tier-2 one must NOT change).

## Tests (tier: one script edited) - at the end
`python Godot/tools/run_tests.py --only training_floor_3d,gym_floor_layout` - 0 failures.

## Acceptance
1. `c225/final.png` (tier 1, game camera): brick walls, a roll-up door with daylight, the bag row, the mat, signs and
   flyers, the ring - readable at a glance, bright; nothing floating/clipping; real scale.
2. The tier-2 render is unchanged (pixel diff of `s104` tier-2 before/after reported in the digest); the six rooms still
   build (the tests above).
3. Branch `codex/c225-floor-tier1`; explicit `git add` of your files (never `git add .`); commit listing each prop's
   source; push. 10-line `C225_DIGEST.md`: what changed, sources, tier-2 diff, what still differs from the concept.

## The one trap
This file is shared by every room: a change outside a tier-1 guard changes rooms other agents are building. Renders need
a window (godot_hidden.ps1); a render at ~0.15 core writing nothing died on a SCRIPT ERROR - read the log.
