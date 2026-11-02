# TASK Q225 - lobby + training floor, pass 2: clean, textured, alive (room designer, Qwen)
Model: qwen3.8-max (VISION - you can see your renders; launched with QWEN_MODEL). Owner: Qwen.
Worktree E:/FightCamp/wt/Q225, branch qwen/q225-lobby-floor-pass2 (from master).
READ FIRST: `research/ROLE_QWEN_ROOM_DESIGNER.md` (your standing role, materials, working loop, gates).

## What Claude saw in your C233 stills (primary source: docs/previews/c233/floor.png, lobby.png)
- LOBBY: the desk panel's bottom two text lines overlap each other ("A player..." over "member pays $12 a week");
  "C233 RENDER" text sits in the 3D room (debug string); "TRIALS & MEMBERSHIP" and "LOU AMATO ON THE DESK BETWEEN
  CLASSES" float in mid-air; the trophy shelf is empty boxes; walls are flat colours; the concept
  (`concepts/room_lobby.jpg`) has: 8 framed fighter posters with records, a lit trophy/belt cabinet, a merch rack, an
  "UPCOMING FIGHTS" board, a bench with two waiting fighters and gym bags, a tiled floor, plants, a water cooler, warm
  ceiling light. Review sheet of pass 1: run room_review on concept vs c233/lobby.png - it scores low on MATERIAL,
  LIFE, CLARITY.
- FLOOR: floating floor labels ("LOU AMATO HEAD COACH", station names painted on the mats as debug-like text), flat
  coloured mats, no textures on walls/floor, the light is flat.

## Do
1. CLARITY first: fix the lobby text overlap; remove every floating/debug 3D label (signs only on walls; station names
   go to tooltips/hover); no "C233 RENDER".
2. MATERIAL: real PBR textures on every wall and floor of both rooms (brick, concrete, rubber gym flooring, tiled lobby
   floor - repo textures; ask Claude for new CC0 ones), wood/vinyl on the desk and benches.
3. LIFE (lobby): the poster wall (use rendered fighter portraits if `FighterPortrait` works, otherwise framed generic
   boxing posters you model - no real people, no AI photos), the trophy/belt cabinet using our art
   (`Godot/assets/ui/trophy_*_cutout.png`, `belt_*_cutout.png` as framed plates on the shelves), merch rack, the
   upcoming-fights board fed by the real booked bouts (GameState), waiting fighters on the bench.
4. LIGHT: a warm motivated key with shadows + fill, AgX/SSAO environment in both rooms.
5. Review sheets before/after for both rooms + rubric scores in the digest.

## Owned files
- `Godot/scripts/Lobby3D.gd`, `Godot/scripts/TrainingFloor3D.gd`, `Godot/scripts/LobbyPanel.gd` (the text overlap only)
- `Godot/assets/models/rooms/lobby/*`, `Godot/assets/models/rooms/floor/*` (new props), `Tools/blender_rooms/*` (your Blender scripts)
- `Godot/tools/q225_render.gd`, `previews/q225/*`, `research/Q225_DIGEST.md`

## Prior research
`python Tools/prior_research.py lobby floor concept room` - K82_FLOOR_LOBBY_TO_CONCEPT.md, C233_DIGEST.md, S91/S88 notes.

## What would a human do?
An environment artist: block out against the concept at the same camera, dress with real materials and story props,
light it, then compare side by side and iterate.

## Prefab check
Repo props/textures first (ROLE file); Blender for the rest; no purchases.

## Tests
Parse gate; `python Godot/tools/run_tests.py --jobs 2 --only lobby,training_floor,gym_wing,smoke`. OPEN every sheet.

## The one trap
A new .png/.glb needs `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --import` before a test can load it.

## Finish
git add by explicit path, commit, git push -u origin qwen/q225-lobby-floor-pass2. Never edit HANDOFF.md. Do not stop at written.
