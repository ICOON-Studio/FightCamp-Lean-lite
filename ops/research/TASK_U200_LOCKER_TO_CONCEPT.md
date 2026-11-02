# TASK U200 - the locker room, dressed to its concept art (Cursor, after U199; S131 brief)

Model: claude-sonnet-5-thinking-high (as U199 - it can see renders). You MUST open the concept image and every render you make and compare them.

## Goal (operator 2026-09-30: "then cursor another" - the next room after the lobby)
Make the in-game locker room read like its target `previews/locker_target/locker_target_concept.jpg`:
a clean fight-gym locker room - a BANK OF BLUE LOCKERS with NAME PLATES (one per fighter on the roster - the room
already builds a locker per fighter), a DIGITAL WEIGH-IN SCALE with a big kg readout and a coach with a clipboard beside
it, a GLASS SHOWER stall with a towel hook, a GLOVE RACK (gloves and mitts hanging), a WEIGHT-CLASSES poster on a mirror
wall, a slatted wooden BENCH with kit bags where a cornerman WRAPS A FIGHTER'S HANDS, a laundry bin, rubber mats, grey
tile floor, bright strip lights. Bright and alive (project rule).

## Prior research (research/) - all concept art for every room: `previews/concepts/CONCEPT_ART_INDEX.md`
- `topics/gym_rooms_art.md` - the rooms (S105-S111), Kenney CC0 + Tripo props, seated/calm idles, bright and alive.
- `D54_DIGEST.md` - fresh-eyes review of THIS locker room; `G122_WHAT_THE_WALLS_DO.md` - walls; `J16_THE_GYM_FLOOR_PLAN.md`
  - never copy a real gym's plan or graphics.

## What would a human do?
A set dresser blocks the big shapes from the game camera first (locker bank, scale, shower, bench), then the people
(weigh-in pair, hand-wrap pair), then wall dressing and small props, then lighting - render and compare after each.
Real sizes: locker 0.4 x 0.5 x 1.8 m; bench seat 0.45 m; scale platform 0.5 x 0.5 m with a 1.2 m column; shower stall
1.0 x 1.0 x 2.1 m.

## Prefab check (use what exists first)
Repo: `Godot/assets/models/props/kenney/` (36 Kenney Furniture Kit models, CC0: bench, benchCushion, bathroomSink,
bathroomMirror, shower, coatRackStanding, cardboardBoxClosed, rugRectangle, plants ...); `Godot/assets/models/props/gym/`
(Tripo, ours: focus_mitts_locker(_t3/_worn), first_aid, heavy/double-end/speed bags, compact_weights ...); fighters under
`Godot/assets/models/fighters/` with the calm/seated idles the rooms already use (C219/C220). Blender 5.2.1 headless
(`"C:/Program Files/Blender Foundation/Blender 5.2/blender.exe" --background --python <x.py>`, exports GLB) for props you
model (scale with readout, glove rack, name plates, kit bags, wraps): GLB into `Godot/assets/models/props/locker/`,
each < 1 MB, the .py under `Godot/tools/blender/`. Poster text is plain typography; no real people, no web images.
NO downloads, NO purchases.

## Owned files (edit ONLY these; anything else = send-back)
- `Godot/scripts/LockerRoom3D.gd` (253 lines). Anchors: `_build_locker_shell` (77), `_build_lockers` (112 - one per
  fighter, MAX_LOCKERS 8, keep that data binding), `_build_board` (157), `_build_scale` (182), `_build_bench_and_wash`
  (212), `_build_locker_camera` (241), `_practicals` (252). Keep `build(new_layout)` and every public signature and any
  clickable object ids the panel uses.
- NEW: `Godot/assets/models/props/locker/*`, `Godot/tools/blender/locker_*.py`, `previews/u200/*`,
  `research/U200_DIGEST.md`.

## Parse gate (before every render)
`python Godot/tools/check_scripts.py Godot/scripts/LockerRoom3D.gd`

## Render (every pass; windowed Godot moved off-screen - never --headless)
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/s106_render_lockers.gd`
(read its header for where it writes; copy each result to `previews/u200/pass<N>.png` and look at it).

## Test (tier: one script edited) - at the end
`python Godot/tools/run_tests.py --only locker_room`

## Acceptance
1. `docs/previews/u200/final.png` from the game camera shows, at a glance: the named locker bank, the weigh-in scale with
   a readout and the coach, the shower, the glove rack, the weight-class poster, the bench with a hand-wrap pair; nothing
   floating, clipping or overlapping; real scale.
2. `locker_room_test` 0 failures; parse clean; no SCRIPT ERROR in the render log.
3. Branch `cursor/u200-locker`; explicit `git add` of your files (never `git add .`); commit listing each prop's source
   (Kenney CC0 / Blender-made / ours); push. 10-line `U200_DIGEST.md`: what changed, sources, what still differs.

## The one trap
Renders need a window (godot_hidden.ps1). A render at ~0.15 core writing nothing died on a SCRIPT ERROR - read the log.
Never kill Godot by image name.
