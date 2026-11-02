# Q225 DIGEST - lobby + training floor, pass 2 (Qwen, room designer)

Branch `qwen/q225-lobby-floor-pass2`. Renders + review sheets: `previews/q225/`
(`review_lobby_before/after.png`, `review_floor_before/after.png`, opened and scored below).
Harness: `Godot/tools/q225_render.gd` (c233's, but the career carries a real gym name - a render
must never paint its task id on the club wall).

## Rubric (Tools/room_review.py --rubric), before -> after, one line of evidence each

LOBBY
- SILHOUETTE 3 -> 4: camera down from 5.4 m to a standing read from the right; cabinet left,
  poster wall mid-left, bench under it, desk right - the concept's arrangement.
- LIGHT 2 -> 4: AgX + warm shadowed key, lit cabinet shelves, poster glow, contact shadows under
  bench/sofa; pass 1 was one flat ambient wash.
- MATERIAL 1 -> 4: painted-brick walls, polished concrete tiles with sheen, wood desk/bench/cabinet
  (Bricks085 + Concrete031 from the repo; wood/rubber painted by us, see below).
- LIFE 2 -> 4: eight framed generated portraits with record plates, a lit trophy/belt cabinet of our
  cutout art + trophy.glb + cups, an UPCOMING FIGHTS board fed by get_cards_board(), two waiting
  fighters with the desk hand, cooler/plants/merch.
- CLARITY 2 -> 4: no "C233 RENDER", no floating name tags, TRIALS & MEMBERSHIP is a framed blade
  sign on wires with letters sized inside its board, desk card lines no longer overlap.
- BAR 2 -> 3: reads as a management-game room screenshot; greybox people still cap it.

TRAINING FLOOR T1
- SILHOUETTE 3 -> 3: layout and camera untouched (not a silhouette task).
- LIGHT 2 -> 3: AgX + key up to 1.7, strips to 1.0; the canvas and concrete now turn under the key.
- MATERIAL 2 -> 4: Bricks085 (normal+roughness) on the side walls, painted-block concrete back wall,
  Concrete031 floor replacing the flat mottling shader, rubber mats; the zone patches were drawing
  OPAQUE (no ALPHA blend) - that was the "flat coloured mats"; at 12% alpha they are hints on concrete.
- LIFE 2 -> 3: same clutter, but the floor stops reading as a data diagram.
- CLARITY 2 -> 4: station names off the mats (they live in the panel's station rail with hover tips,
  U202), the coach's floating "LOU AMATO / HEAD COACH" tag gone; door boards + floor mats stay
  (training_floor_3d_test contracts them), fighter tags stay (same test reads the gain off them).
- BAR 2 -> 3.

Two lowest rows: lobby MATERIAL 1->4 and LIGHT 2->4; floor LIGHT 2->3 and MATERIAL 2->4. No row went down.

## Kept contracts / deliberate deviations
- `Desk/TrialsSign`, `Doors/*/FloorSign`, fighter `Tag` nodes are test contracts - kept, restyled or
  left alone; only the coach's own tag and the lobby's name tags were removed.
- LobbyPanel was owned "the text overlap only": the overlap is fixed there (one fitted line, which
  front_door_test still reads both facts off). The fights board therefore reads GameState by path
  (`get_node_or_null("/root/GameState")` + `has_method("get_cards_board")`) inside Lobby3D - the same
  sanctioned scene-script pattern, noted here because Lobby3D's header says LobbyPanel reads the game.
- Wood and rubber maps are OURS (`Tools/blender_rooms/q225_textures.py`, PIL, seeded): the repo ships
  only brick + concrete and new CC0 downloads go through the operator. Imported with
  `--headless --path Godot --import` before any test loaded them.
- PlaneMesh lies in XZ: the first portrait pass came out as flaps off the wall; QuadMesh fixed it.

## Gates
- Parse: `check_scripts.py` on TrainingFloor3D.gd, Lobby3D.gd, LobbyPanel.gd, q225_render.gd - 0 fails.
- Tests: `run_tests.py --jobs 2 --only front_door,lobby,training_floor,gym_wing,smoke` - SUITE total=4 fails=0
  (front_door caught the first desk-card fix; the fitted one-line label passes it).
- Watchdog `-Once` before every render/suite: GREEN or AMBER-CPU, never RED.
