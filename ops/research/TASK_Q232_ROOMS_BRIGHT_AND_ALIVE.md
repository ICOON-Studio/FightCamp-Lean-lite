# TASK Q232 - the eight gym rooms, brightness + consistency pass: bright and alive again (room designer, Qwen CLI)
Model: qwen3.8-max (VISION). Owner: Qwen (fourth Token Plan seat, S139). Worktree E:/FightCamp/wt/Q232, branch
qwen/q232-rooms-bright (from master at b0271915 or later). READ FIRST: `research/ROLE_QWEN_ROOM_DESIGNER.md`.

## Why (a seen defect)
Pass 2 merged S139 (b0271915): Q225 lobby + training floor, Q227 office + locker, Q228 film room, Q229 mat + staff +
physio. Every room gained real materials, props and people - and every room came out DARKER than pass 1 (Claude's
side-by-side of the eight before/after stills). House rule (CLAUDE.md product rules + your ROLE file): "the gym is bright
and alive - never dark, never empty". The reference look: `Godot/assets/ui/bot_art/training_floor_look.jpg` and
`gym_with_ring.jpg` (the operator's picks), `previews/concepts/gym_tier1_backroom_club.jpg`.

## What to do
1. Measure first: render all eight rooms as they are on master (see Tests) and print each still's mean luminance and
   the share of near-black pixels (L < 0.08) - write a tiny script `Godot/tools/q232_luma.py` (Pillow) for it. That is
   your BEFORE table.
2. Lift to the bright reference WITHOUT losing the pass-2 materials: the shared environment in
   `Godot/scripts/TrainingFloor3D.gd` `_apply_room_fx` (line ~125: ambient_light_energy 0.5, tonemap_exposure 1.12) and
   each room's own `_apply_room_fx` / `_practicals` / `_daylight` overrides (Lobby3D, Office3D, LockerRoom3D, MatRoom3D,
   PhysioRoom3D, StaffRoom3D, FilmRoom3D). Prefer brighter motivated light (overhead fluorescents/LED panels a real gym
   has, window daylight) and lighter albedo on walls/ceilings over a blanket exposure push that washes the textures out.
   The film room may stay the dimmest (a screen room) but not dark.
3. One look across all eight: the same daylight colour temperature family, the same exposure range, so walking room to
   room does not flicker between moods.
4. AFTER table with the same script; every room's mean luminance up and near-black share down, none clipped to white
   (share of L > 0.97 under 2%). Before/after review sheets via `python Tools/room_review.py`; rubric LIGHT row per room.

## Owned files
`_apply_room_fx`, `_practicals`, `_daylight`, light and environment code and wall/ceiling albedo constants in the eight
room scripts above (name each with line ranges in the digest); `Godot/tools/q232_render.gd`, `Godot/tools/q232_luma.py`,
`previews/q232/*`, `research/Q232_DIGEST.md`. Do NOT rename or re-sign any helper: the rooms inherit
from each other (TrainingFloor3D -> Office3D -> Locker/Mat/Physio/Staff/Film; TrainingFloor3D -> Lobby3D) and S139 just
fixed three clashing `_pbr` helpers (now `_pbr` / `_office_pbr` / `_room_pbr`). Parse every one of the eight after editing.

## Prior research
`python Tools/prior_research.py gym rooms bright lighting`: topics/gym_rooms_art.md, Q225/Q227/Q228/Q229 digests,
S105-S111 room digests, the ROLE file's review loop.

## What would a human do?
A lighting artist on a sports-management game: one lighting rig per room type, calibrated against a reference still,
checked with a luminance read, so the whole building reads as one bright place.

## Prefab check
Nothing to buy or download: Godot environment + lights + the textures already in the repo.

## Tests
Parse gate on the eight scripts; `python Godot/tools/run_tests.py --jobs 2 --only lobby,training_floor,front_door,gym_wing,office,locker,film_room,mat_room,staff,physio,smoke`.
Renders through `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/q232_render.gd`
(copy the camera/fixture setup from tools/q225_render.gd, q227_render.gd, q228_render.gd, q229_render.gd). Watchdog
GREEN before each heavy run (if RED wait 2 min and re-check; never kill a process you did not start). LOOK at every
image with your file-read tool only - never open a viewer, browser or app (it pops up on the operator's screens).

## The one trap
A worktree with no `.godot` cache needs one `--headless --path Godot --import`; it rewrites thousands of unrelated
`.import` files - stage ONLY your own files.

## Finish
git add by explicit path, commit, git push -u origin qwen/q232-rooms-bright. Never edit HANDOFF.md. Do not stop at written.
