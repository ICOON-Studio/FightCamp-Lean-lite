# TASK Q228 - THE FILM ROOM: build it (room designer seat, Qwen CLI)
Model: qwen3.8-max (VISION). Owner: Qwen (U207 seat, re-tasked S139). Q225 owns lobby + floor, Q227 office + locker -
do not touch their files. Worktree E:/FightCamp/wt/Q228, branch qwen/q228-film-room (from master).
READ FIRST: `research/ROLE_QWEN_ROOM_DESIGNER.md` (role, materials, the review loop, gates), then the spec
`research/K47_FILM_ROOM_SPEC.md` (floor plan, every prop with size/position/material, people, clickables, light,
palette - where the concept image and the spec differ, the spec wins).

Why (demo path): the active milestone is "train him, scout, book a fight, watch the fight". Opponent scouting today is ONE
text line in fight camp (`FightCampPanel.gd:1626 _scouting_read` - style, stance, the coach's line, the recommended focus).
The film room is where the player SEES that read: the opponent's footage on the screen, his tendencies on the whiteboard.

## Build
1. `Godot/scripts/FilmRoom3D.gd` - a scene script (names no GameState; copy the pattern of `PhysioRoom3D.gd`, 255 lines,
   and `StaffRoom3D.gd`, 668 lines). The K47 room: 7 x 5 m, cut-away front/right walls, every prop in the spec table,
   the three downlights + window daylight, screen as the brightest object. Kit props first (`Godot/assets/models/`,
   grep the other Room3D builders for what they load), Blender (`Tools/blender_rooms/film_*`) only for the whiteboard frame.
   People: coach + two fighters from the existing fighter rigs (copy how StaffRoom3D/LockerRoom3D place people).
2. `Godot/scripts/FilmRoomPanel.gd` - hosts FilmRoom3D (copy `PhysioRoomPanel.gd`, 83 lines). Reads the game ONCE per
   rebuild: the next booked opponent of the selected fighter (find the read FightCampPanel uses - `grep -n "opponent"
   Godot/scripts/FightCampPanel.gd | head`) -> name, record, style, stance, the coach line (`FightPlans.all_plans()` by
   style name, field `coach_line`). Empty state when nothing is booked: the screen dark, one line "NO OPPONENT ON FILM".
3. Clickables (K47 s4): screen = his footage label + style/stance; whiteboard = his tendencies (style, stance, coach line);
   folder stack = his record; laptop = the recommended camp focus. Hover = thin brass outline (#B8893B) + label <= 14
   chars; ICONS OVER TEXT with tooltips (operator rule). Text drawn on the board/screen is a texture from real data.
4. Route: ONE line in `Godot/scripts/SceneRouter.gd` beside "physio" (~line 92):
   `"film_room": {"tier": "career", "scene": CAREER_ROOT_SCENE, "panel": "res://scripts/FilmRoomPanel.gd", "nav": "gym", "label": "THE FILM ROOM"},`
   and ONE entry button in FightCampPanel next to the scouting read ("WATCH FILM", icon + tooltip) that routes there.
   Another agent may edit SceneRouter.gd in parallel - change only your line.

## Owned files
New: `Godot/scripts/FilmRoom3D.gd`, `Godot/scripts/FilmRoomPanel.gd`, `Godot/assets/models/rooms/film/*`,
`Tools/blender_rooms/film_*`, `Godot/tests/film_room_test.gd`, `Godot/tools/q228_render.gd`,
`previews/q228/*`, `research/Q228_DIGEST.md`.
Edited: `Godot/scripts/SceneRouter.gd` (one route line), `Godot/scripts/FightCampPanel.gd` (1,685 lines - the one button,
near `_scouting_read`; never read it whole, `sed -n` windows). GameState.gd (17k+ lines) is NEVER read whole.

## Prior research
`python Tools/prior_research.py film room scouting`: K47_FILM_ROOM_SPEC.md (the spec), G110_ROOMS_MEDIA_SCOUTING.md
(what a scouting file holds: what you know, how sure, how old), topics/scouting_film.md, topics/gym_rooms_art.md,
S110_DIGEST (physio room - the newest room pattern). Concepts: `previews/concepts/room_film_k47_a.png`,
`room_film_k47_b.png`, `room_film.jpg`.

## What would a human do?
An environment artist: block out the room to the spec's metres, dress it with kit props, light it (window + downlights,
the screen glowing), compare to the concept side by side, fix the worst difference, repeat. A UI designer then makes the
four objects clickable and the data on them real.

## Prefab check
Kit furniture already in the repo (sofa, table, shelves, desk, laptop, TV/screen, plant, rug - grep the Room3D builders).
No purchases. Fighter rigs: the existing MPFB generator bodies.

## Test (tier: new scripts + edits)
1. `python Godot/tools/check_scripts.py <every touched .gd>` (a parse error hangs a headless test).
2. NEW `Godot/tests/film_room_test.gd`: mount FilmRoomPanel with a fixture that has a booked opponent (two DIFFERENT
   fighters - different stats, style, stance) and assert the four clickables exist and the whiteboard/screen text carries
   THAT opponent's style and stance; control arm = no booking -> the empty line and no opponent text. Break one read and
   see the test fail (say so in the digest).
3. `python Godot/tools/run_tests.py --jobs 2 --only film_room,fight_camp,scene_router,smoke`.
4. Review loop: `python Tools/room_review.py` sheets before/after, stills via
   `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/q228_render.gd`
   -> `previews/q228/`. OPEN every still and sheet before you judge it.
Watchdog before every heavy run: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once`.

## The one trap
New .png/.glb need `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --import` before a test can load them
(ResourceLoader.exists is false until then). A worktree with no import cache needs that once first.

## Finish
git add by explicit path, commit, git push -u origin qwen/q228-film-room. Never edit HANDOFF.md. Do not stop at written.
