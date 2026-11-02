# TASK G148 - the manager's office, dressed to its concept art (Grok Build CLI, S131)

Model: Grok 4.7 (Grok Build CLI default). You MUST look at the concept image and at every render you make, side by side.

## Goal (operator 2026-09-30: "you also have grok with cli he can make another scene?")
Make the in-game office read like its target concept `previews/office_target/office_target_concept.jpg`:
a warm wooden manager's office - a WHITEBOARD FIGHT CALENDAR on the wall, framed fight POSTERS, a big WINDOW looking
onto the gym ring, a wooden DESK (desk phone, laptop with charts, a CONTRACTS tray of papers, a desk lamp, a coffee mug),
a leather executive chair + a visitor chair, a BOOKSHELF of binders with a small trophy and a plant, a floor SAFE with a
framed "first dollar" above it, a patterned RUG on a wooden floor. Keep it BRIGHT and warm (project rule: dark reads
"abandoned") - the concept is an evening mood; ours is daytime-warm.

## Prior research (read first; research/)
- `topics/gym_rooms_art.md` - canonical page for the rooms (six rooms S105-S111, Kenney CC0 + Tripo props, bright and alive).
- `S90_DIGEST.md`, `G122_WHAT_THE_WALLS_DO.md` - what gym walls carry; `D53_DIGEST.md` - fresh-eyes review of THIS office.
- `J16_THE_GYM_FLOOR_PLAN.md` - never copy a real gym's plan or graphics.

## What would a human do?
A set dresser blocks the big shapes first from the game camera (window + calendar + desk + shelf + safe), then desk
clutter and wall frames, then lighting - rendering and comparing with the concept after each block. Real sizes: desk
0.75 m high, 1.6 x 0.8 m; whiteboard ~1.8 x 1.1 m; poster 0.5 x 0.7 m; safe ~0.6 x 0.6 x 0.9 m; bookshelf 1.2 m high.

## Prefab check (use what exists before building)
In the repo: `Godot/assets/models/props/kenney/` (36 Kenney Furniture Kit models, CC0: desk, chairDesk, chair,
bookcaseClosedDoors, books, computerScreen, computerKeyboard, computerMouse, lampSquareTable, lampSquareFloor, pottedPlant,
plantSmall1, rugRectangle, radio, cardboardBoxClosed, coatRackStanding ...); `Godot/assets/models/props/gym/` (Tripo, ours);
the fighters under `Godot/assets/models/fighters/` (the owner already sits here - OWNER_MODEL). Blender 5.2.1 is installed
(`"C:/Program Files/Blender Foundation/Blender 5.2/blender.exe" --background --python <script.py>` works headless and
exports GLB) for props you model yourself (whiteboard, safe, frames, contracts tray, desk phone, mug): export to
`Godot/assets/models/props/office/`, each file < 1 MB, keep the .py under `Godot/tools/blender/`. Poster/photo images:
render stills of OUR fighters or plain typography - never real people, never web images. The window view onto the ring
may be a render of our own gym floor or ring used as a texture. NO downloads, NO purchases.

## Owned files (edit ONLY these; anything else = send-back)
- `Godot/scripts/Office3D.gd` (347 lines). Anchors: `layout_for` (static, ~42) - you may move object `at`/`size` but KEEP
  the five ids and routes in `OBJECTS` (books -> finances, phone -> promotions, cabinet -> contracts, calendar -> fight
  calendar, photos -> the photo wall) and keep `object_at(screen_point)` picking every one of them;
  `_build_office_shell` (93), `_build_desk` (132), `_build_dressing` (203), `_build_cabinet` (232), `_build_calendar`
  (259), `_build_photos` (279), `_build_office_camera` (331), `_practicals` (343). Keep every public signature.
- NEW: `Godot/assets/models/props/office/*`, `Godot/tools/blender/office_*.py`, `previews/g148/*`,
  `research/G148_DIGEST.md`.
- Do NOT edit any other script, any test, GameState.gd, the router, or any fight file.

## Parse gate (before every render)
`python Godot/tools/check_scripts.py Godot/scripts/Office3D.gd` - a parse error hangs Godot.

## Render (every pass)
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/s105_render_office.gd`
It writes `previews/s105/office.png`; copy it to `previews/g148/pass<N>.png` and LOOK at it.

## Test (tier: one script edited) - run at the end
`python Godot/tools/run_tests.py --only office_room` (the test that builds Office3D and checks the clickable objects).

## Acceptance
1. `docs/previews/g148/final.png` from the game's office camera shows, readable at a glance: the whiteboard fight
   calendar, framed posters, the window onto a ring, the desk with phone + laptop + contracts tray + lamp, the bookshelf,
   the safe, the rug. Nothing floating, clipping into walls, or overlapping; real-world scale.
2. All five clickable objects still open their screens (`office_room_test` 0 failures); parse clean; no SCRIPT ERROR.
3. Commit on branch `grok/g148-office` (explicit `git add` of your files - never `git add .`), message listing each prop
   and its source (Kenney CC0 / Blender-made / ours); `git push -u origin grok/g148-office`. Write a 10-line
   `research/G148_DIGEST.md`: what changed, sources, what still differs from the concept.

## The one trap
Renders need a WINDOW: use godot_hidden.ps1 exactly as above, never `--headless` (black PNG). Never kill Godot by
image name. A render that sits at ~0.15 core and writes nothing died on a SCRIPT ERROR - read the log, fix, rerun.
