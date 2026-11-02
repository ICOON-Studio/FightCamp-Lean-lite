# TASK Q230 - the fight venues, look pass: paper_hall, iron_parish, north_dock_leisure (venue designer, Qwen CLI on qwen3.7-plus)
Model: qwen3.7-plus (VISION). Owner: Qwen (re-tasked S139). Worktree E:/FightCamp/wt/Q230, branch qwen/q230-venues-regional (from master).
READ FIRST: `research/ROLE_QWEN_ROOM_DESIGNER.md` (role, materials, review loop, gates, and NEVER open a viewer -
look at renders with your file tool only). The recipe that worked in the gym rooms (Q225/Q227 digests): world-scale
triplanar CC0 maps already in the repo (`Godot/assets/venues/iron_parish/textures/` Bricks085, Concrete031), your own
seeded maps from Blender (`Tools/blender_rooms/q225_textures.py`), AgX, a shadowed motivated key, practicals, story props.

Why: every fight the player watches happens in one of the seven G74 venues (`VenueLadder`: regional -> national ->
international). Operator S138: "none of what i saw so far is even close to AAA ... i still see a grey ring ... always
compare titles from our researches and try to surpass them visually". The renders show grey untextured walls, flat
floors and empty ceilings (`previews/venues/*_establishing.png`). The bar: S138_AAA_VISUAL_GAP.md "The bar"
(Undisputed's bright white centre ring and dark house; avoid Fight Night Champion's "arenas too dark").
NOT YOURS: the ring (ArenaRig.gd - Claude did V1), the crowd/seating (`_crowd_row`, `_crowd_mass_block`,
`_add_seated_silhouette`, `_add_*_bleachers`, `_add_*_bowl`, `_add_back_wall_crowd` - Grok G157 is replacing them with
people), entrance markers (Codex C232). Other agents edit VenueRig.gd in parallel: change ONLY the functions you own and
keep every node name a test reads (grep Godot/tests for VenueRig node names first).

## Targets
paper_hall, iron_parish, north_dock_leisure (the REGIONAL tier - every career starts here). Per venue: MATERIAL (no flat-colour wall, floor or ceiling left), LIGHT (a dark house and a bright ring:
motivated rig lights, truss, practicals; haze reads in the beams), LIFE (banners with OUR venue/promotion names only -
D12 bars real organisation logos -, the scorer's table, cameras, ring-side press, exit signs), CLARITY (no floating text).
Each tier must look clearly richer than the one below it (the reward for progressing).

## Owned functions in `Godot/scripts/VenueRig.gd` (1,699 lines - `sed -n` windows, never read it whole)
`_build_paper_hall` + `_add_paper_*`, `_build_north_dock` + `_add_north_dock_lights`, the shared shell helpers `_add_walls`, `_wall_panel`, `_side_wall_split`, `_add_floor`, `_add_ceiling`, `_add_ceiling_corner_baffles`, `_add_environment`, `_add_house_fixtures`, `_add_fire_exit` (iron_parish uses the shared shell). Plus `Godot/assets/venues/<your venue ids>/*`, `Tools/blender_venues/q230_*`,
`previews/q230/*`, `research/Q230_DIGEST.md`.

## Prior research / human / prefab
`python Tools/prior_research.py venue arena look`: S138_AAA_VISUAL_GAP.md, G74 digests (the venue specs,
`assets/data/venue_specs.json`), topics/camera_broadcast.md. A human: an environment artist dressing a set for the
broadcast camera - block, dress, light, compare to the reference, fix the worst thing, repeat. CC0 maps already in the
repo and Blender first; no downloads, no purchases.

## Tests
Parse gate on VenueRig.gd; `python Godot/tools/run_tests.py --jobs 2 --only venue,arena,fight_night,smoke`.
Stills: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once` (GREEN; if RED wait 2 min and
re-check, never kill a process you did not start), then per venue
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/capture_venue.gd --resolution 1280x720 -- venue=<id> discipline=boxing seed=5150 bare=1`
(writes docs/previews/venues/<id>_{standing,establishing,house_wide}.png - copy BEFORE renders to docs/previews/q230/before/
first). Build before/after sheets (`python Tools/room_review.py`), rubric per venue, OPEN every image with your file tool.

## The one trap
capture_venue.gd prints gate metrics (canvas/background luminance split, void fraction, house visible) - a brighter
house can fail the split gate; keep the canvas the brightest thing (the Undisputed look) and read the metrics each pass.
New textures need `--headless --path Godot --import` before a test loads them; that rewrites many unrelated .import
files - stage ONLY your own files.

## Finish
git add by explicit path, commit, git push -u origin qwen/q230-venues-regional. Never edit HANDOFF.md. Do not stop at written.
