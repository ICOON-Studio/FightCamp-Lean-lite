# TASK Q218 - the staff room, dressed to its concept art (Qwen, S131)

Model: qwen3-coder (qwen_task.cmd, --yolo). Open the concept image and every render you make and compare them.

## Goal (operator 2026-09-30: "also use qwen")
Make the in-game staff room read like `previews/concepts/room_staff.jpg`: the coaches' room - a big ROTA
BOARD on the wall (coach photos on one side, fighter photos on the other, red strings between who trains whom), a row
of COACH LOCKERS with name plates, a KITCHENETTE (coffee machine, sink, microwave, small fridge, mugs), a wooden MEETING
TABLE with two coaches talking over a clipboard, a leather SOFA with a coach resting and a coffee table with magazines,
motivational posters, a window onto the gym, and a JOB CANDIDATE waiting outside the door holding a CV (the hiring
feature). Bright and warm (project rule: dark or empty reads "abandoned").

## Prior research (research/)
- `topics/gym_rooms_art.md` (canonical page for rooms); `D57_DIGEST.md` (fresh eyes on THIS staff room);
  `G122_WHAT_THE_WALLS_DO.md`; `J16_THE_GYM_FLOOR_PLAN.md` (never copy a real gym). All concept art:
  `previews/concepts/CONCEPT_ART_INDEX.md`.

## What would a human do?
Block the big shapes from the game camera (rota board wall, lockers, kitchenette, table, sofa), then the people, then
wall dressing and small props, then light - re-render the same camera after each block and compare with the concept.

## Prefab check
Repo: `Godot/assets/models/props/kenney/` (36 Kenney Furniture Kit models, CC0: loungeSofa, desk, chair, chairDesk,
kitchenCabinet, kitchenCabinetUpper, kitchenCoffeeMachine, kitchenFridgeSmall, bathroomSink, rugRectangle, pottedPlant,
bookcaseClosedDoors, books, coatRackStanding ...); fighters/coaches under `Godot/assets/models/fighters/` with the calm and
seated idles the room already uses. Blender 5.2.1 headless (`"C:/Program Files/Blender Foundation/Blender 5.2/blender.exe"
--background --python x.py`, exports GLB) for the rota board, lockers, microwave, CV sheet: GLB into
`Godot/assets/models/props/staff/`, each < 1 MB, script under `Godot/tools/blender/`. Photos on the board: render stills of
OUR fighters/coaches (never real people or web images). NO downloads, NO purchases.

## Owned (edit ONLY these; anything else = send-back)
- `Godot/scripts/StaffRoom3D.gd` (263 lines). Anchors: `_build_staff_shell` (75), `_build_table` (104), `_build_coaches`
  (129), `_build_whiteboard` (170 - becomes the rota board), `_build_hiring` (195 - the candidate at the door),
  `_build_coffee` (223 - the kitchenette), `_build_staff_camera` (251), `_practicals` (262). Keep `build(new_layout)`,
  every public signature and every clickable object id the panel uses.
- NEW: `Godot/assets/models/props/staff/*`, `Godot/tools/blender/staff_*.py`, `previews/q218/*`,
  `research/Q218_DIGEST.md`.
- Do NOT edit TrainingFloor3D.gd (every room inherits it; another agent is editing it), any test, or any fight file.

## Parse gate (before every render)
`python Godot/tools/check_scripts.py Godot/scripts/StaffRoom3D.gd`

## Render (every pass; windowed Godot moved off-screen, never --headless)
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/s109_render_staff_room.gd`
(read its header for where it writes; copy each result to `previews/q218/pass<N>.png` and look at it).

## Tests (tier: one script edited) - at the end
`python Godot/tools/run_tests.py --only staff_room,staff_hub_panel` - 0 failures.

## Acceptance
1. `q218/final.png` from the game camera shows, at a glance: the rota board with photos and strings, the coach lockers,
   the kitchenette, the meeting table with two coaches, the sofa, the candidate with a CV at the door; nothing floating,
   clipping or overlapping; real scale; bright.
2. The tests above 0 failures; parse clean; no SCRIPT ERROR in the render log.
3. Branch `qwen/q218-staff-room`; explicit `git add` of your files (never `git add .`); commit listing each prop's source
   (Kenney CC0 / Blender-made / ours); push. 10-line `Q218_DIGEST.md`: what changed, sources, what still differs.

## The one trap
Renders need a window (godot_hidden.ps1). A render at ~0.15 core writing nothing died on a SCRIPT ERROR - read the log,
fix, rerun. Never kill Godot by image name. Do not stop at "written": run the render and the tests yourself.
