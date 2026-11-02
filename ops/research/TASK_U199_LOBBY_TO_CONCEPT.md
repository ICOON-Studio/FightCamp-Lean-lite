# TASK U199 - the lobby, dressed to its concept art (Cursor, S131)

Model: claude-sonnet-5-thinking-high (operator 2026-09-30: "Sonnet 5" - you MUST look at your own renders and the
concept image; compare them side by side before you call a pass done).

## Goal (operator, verbatim: "why dont you assign another agent to work on this", pointing at the status deck's
"LOBBY AND RECEPTION - today vs target")
Make the in-game lobby read like the target concept `previews/lobby_target/lobby_target_concept.jpg`:
a warm boxing-gym reception - a TROPHY WALL (shelves of cups + championship belts), a PHOTO WALL (framed fighter
photos / fight posters), MERCHANDISE (t-shirts on a rack or wall, gloves/boxes on shelves), the reception DESK with a
person behind it, and walk-in PROSPECTS WAITING ON THE BENCH (seated). Bright and alive (project rule: dark or empty
reads "abandoned"). It is a management game's room, seen from the room camera - read at a glance, not a showroom.

## Prior research (read these first; all in research/)
- `topics/gym_rooms_art.md` (canonical page for rooms) - the six rooms, Kenney CC0 furniture + Tripo hero props, seated
  idles (C219/C220), "gym art is bright and alive".
- `G124_THE_FRONT_DOOR.md` - the walk-in funnel: door -> desk greeting -> wall of belts/photos -> trial. Reception is a desk
  at the door in a small club.
- `G122_WHAT_THE_WALLS_DO.md`, `S90_DIGEST.md` - what gym walls carry (earned vs bought decor: fighter photo row,
  trophy cabinet, framed posters).
- `D55_DIGEST.md` - fresh-eyes review of this lobby: "warm and furnished, but reads a bit static"; wants small
  human-scale details (mug/notebook on the desk, towel on the bench); fix overlaps (sign wires across frames).
- `J16_THE_GYM_FLOOR_PLAN.md` - do not copy a real gym's plan or graphics.

## What would a human do?
A set dresser works from the concept: blocks the three walls first (trophies / photos / merch) at readable scale from
the game camera, then the desk and the bench with people, then small lived-in details, then lighting - checking a
render against the concept after each block. Believable real-world sizes: counter ~1.05 m high, bench seat ~0.45 m,
shelf boards 0.3 m deep, a belt ~1.2 m long, frames 0.4-0.7 m.

## Prefab check (use what exists before building)
In the repo, licences known: `Godot/assets/models/props/kenney/` (36 Kenney Furniture Kit models, CC0 - bench,
benchCushion, desk, chairDesk, bookcaseClosedDoors, books, cardboardBoxClosed, coatRackStanding, plants, rugs, radio,
computerScreen ...); `Godot/assets/models/props/gym/` (18 Tripo gym props, ours); the fighters under
`Godot/assets/models/fighters/` (receptionist + prospects, as Lobby3D already mounts them) with the seated idle clip
Lobby3D already uses (`SEATED_IDLE_CLIP`). Blender 5.2 is installed ("C:/Program Files/Blender Foundation/Blender 5.2")
for simple props you model yourself (cups, belts, frames, shelves, folded t-shirts): export GLB under
`Godot/assets/models/props/lobby/`, keep each file small (< 1 MB), save the .py you used under `Godot/tools/blender/`.
Photos/posters: render stills of OUR fighters (never real people, never images from the web) and use them as textures.
NO downloads, NO purchases, NO web images: everything from the repo, Blender or procedural Godot meshes.

## Owned files (you may edit ONLY these; anything else = send-back)
- `Godot/scripts/Lobby3D.gd` (286 lines). Anchors: `_build_lobby_shell` (73), `_build_museum` (105, the honours wall -
  becomes the trophy + belt wall), `_build_desk` (158), `_build_furniture` (218), `_build_waiting_area` (250, the bench +
  seated prospects), `_build_lobby_camera` (270), `_practicals` (282, lights). Keep `build(new_layout)` and every public
  function signature unchanged - LobbyPanel.gd and the router call them.
- NEW: `Godot/assets/models/props/lobby/*` (GLB + textures), `Godot/tools/blender/lobby_*.py`,
  `previews/u199/*` (your renders).
- Do NOT edit LobbyPanel.gd, GameState.gd, TrainingFloor3D.gd, any fight script, any test.

## Render (every pass)
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/s107_render_lobby.gd`
(it writes `previews/s107/lobby.png`; copy it to `previews/u199/pass<N>.png` after each pass).
Look at the PNG and at the concept image before the next pass.

## Parse gate (before any render)
`python Godot/tools/check_scripts.py Godot/scripts/Lobby3D.gd` - a parse error hangs Godot.

## Test (tier: one script edited)
parse gate + the render above + `python Godot/tools/run_tests.py --only front_door` (the one test that builds Lobby3D/LobbyPanel; run once at the end).

## Acceptance
1. `docs/previews/u199/final.png` from the game's lobby camera shows, readable at a glance: a trophy/belt wall, a photo
   wall, merchandise, the desk with a person, >=2 prospects seated on the bench; nothing floating, clipping into walls, or
   overlapping (D55's sign-over-frames defect gone).
2. Every prop sits on its floor/shelf/wall (no gaps, no interpenetration); real-world scale.
3. `run_tests.py --only front_door` 0 failures; parse gate clean; no SCRIPT ERROR in the render log.
4. Commit on your branch with a message listing the props and their sources (Kenney CC0 / Blender-made / ours); push.
   Write a 10-line `research/U199_DIGEST.md`: what changed, sources, what you could not match in the concept.

## The one trap
The render runs in a WINDOWED Godot moved off-screen (godot_hidden.ps1) - never run it with `--headless` (no GPU
output = black PNG), and never kill Godot by image name. If a render reads ~0.15 core and writes nothing, the script
died on a SCRIPT ERROR - read the log, fix, rerun.
