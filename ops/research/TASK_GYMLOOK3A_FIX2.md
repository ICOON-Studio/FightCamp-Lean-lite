# TASK GYMLOOK3A_FIX2 - round 3: three defects survive round 2 (Cursor, branch cursor/gymlook3a)

Model: Cursor default (same seat). Spec: `research/LUDO_ROUND44_VERDICT_S212.md` (operator-approved Q-S211-1).
Your digest: `GYMLOOK3A_DIGEST.md` (round 2 section). Round-2 brief: `TASK_GYMLOOK3A_FIX1.md`.

## Prior research
`GYMLOOK3A_DIGEST.md` rounds 1-2, `LUDO_ROUND44_VERDICT_S212.md`, `TASK_GYMLOOK3A_FIX1.md`.
## What would a human do?
Look at the still, find the node that paints the wrong pixels, fix it, re-shoot, look again.
## Prefab check
Textures are CC0 ambientCG already in the tree - nothing new to fetch.

## Round 2 kept (do not regress)
FPS after 34.2 >= before 31.0; dust particles off; zone mat colours (cardio navy, strength near-black, stretch blue) read right.

## What Claude saw in YOUR round-2 stills (opened with the file tool, 2026-10-12 23:45)
Your digest says "brick/posters expected" - you could not open the PNG. They are NOT there:
1. BACK WALL STILL WHITE. after_01_overview.png: the far wall behind the bag line (top of frame, y ~240-330) is flat white
   plaster; no brick, no posters. after_03_training_fighter.png: the wall behind the four heavy bags (y ~130-340) is white.
   The game camera looks at the NORTH wall (the one the heavy bags hang in front of). Your brick sits on `Club/Walls` at
   `z<0.35` - check which wall the camera actually faces (print the camera basis and each wall node's global normal) and
   put brick + 2 posters on the wall facing the camera. The legacy shell wall may also still draw on top of yours.
2. TAN SQUARE ON THE RING EMBLEM. after_02_ring_zone.png: a flat tan/beige square (~200x150 px at x~1060-1210, y~270-350)
   covers the centre of the emblem decal. Something opaque still draws at canvas centre (old centre-paint mesh, a
   MeshInstance pad, or the decal's albedo with no alpha). Find the node and remove/hide it under look3a.
3. FLOOR STILL READS ORANGE, NOT MAPLE. after_03: the boxing floor is saturated orange (~#D2752E), not #C48E56 light maple
   with visible grain. Check: albedo_color multiply on Wood094 (should be white or a light tint, not #C48E56 on top of an
   already brown texture = double darkening/saturation), the sRGB flag on the albedo texture, and over-exposure from the
   ring/bag spots (the hotspots in after_03 are blown white).
4. BROWN BOXES in the top-left and top-right corners of after_01 and the top-left of after_03 - a large brown slab sits
   between the camera and the hall (ceiling beam end, lamp housing, or a shell piece). Name the node; hide it from the
   game camera (cull layer or remove under look3a) if it is not meant to be seen.
5. REPORT ONLY: what body the floor fighter ("NIKO PARK", green shorts) uses - path of the scene/mesh. Do not change it.

## Acceptance (you cannot see images - prove it with PIXELS)
Write `Godot/tools/gymlook3a_pixel_check.py` (Python + Pillow, pure, no Godot) that reads the after stills and prints
PASS/FAIL per check; put its output verbatim in the digest:
- Back wall: mean RGB of a box on the wall region of after_03 (behind the bags) is NOT near-white (max channel < 200) and
  red > green > blue (brick); stdev of luminance there > 12 (texture, not flat paint).
- Emblem: after_02 centre box (x 1080-1190, y 280-340) luminance stdev > 15 (emblem detail, not a flat square).
- Maple: after_03 floor box away from hotspots (x 600-900, y 600-750) mean within 30 per channel of (196,142,86).
- Corners: after_01 boxes (x 0-300, y 70-220) and (x 1480-1900, y 70-260) contain no large brown slab: fraction of
  pixels with R in 90-200, G in 50-130, B < 100 is < 0.10.
Shoot the stills as before; the checker must go RED on the round-2 stills first (run it on them before your fix and paste
that output too).
- FPS after >= before in the same harness (state both + draw calls).
- Parse gate: `python Godot/tools/check_scripts.py <every touched .gd>`.
- Test: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/gym_look2_shell_test.gd`
  (exe in %LOCALAPPDATA%\Programs\Godot\), then `python Godot/tools/run_tests.py --only gym_look --jobs 1`.
- Stills ONLY via `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <args>`, and saved with the
  harness as before. Never open an image with start/explorer/Photos/browser. `Tools\pc_watchdog.ps1 -Once` before each
  Godot run; RED = wait.
- Commit on cursor/gymlook3a and push; digest gets a "Round 3" section. Do not edit HANDOFF.md.

## Owned files
`Godot/scripts/club_look/GymLook2.gd`, `GymLook2Materials.gd`, `GymLook2Shell.gd`, `GymLook2Dress.gd`,
`Godot/assets/data/gym_look2.json`, `Godot/tools/gymlook3a_stills.gd`, `Godot/tools/gymlook3a_pixel_check.py`,
`Godot/tests/gym_look2_shell_test.gd`, `previews/gymlook3a/**`, `research/GYMLOOK3A_DIGEST.md`.

## The one trap
Headless tests keep `gym_look3a`/`gym_look2` OFF; only the stills harness turns them on. Never change either default in data.
