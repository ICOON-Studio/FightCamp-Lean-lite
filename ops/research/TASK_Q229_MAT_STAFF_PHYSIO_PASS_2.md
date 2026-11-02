# TASK Q229 - mat room + staff room + physio, pass 2: textured, lit, alive (room designer, Qwen CLI on qwen3.8-max)
Model: qwen3.8-max (VISION). Owner: Qwen (Q225 seat, re-tasked S139). Q227 has office + locker, Q228 builds the film room,
Q225's lobby + floor are merged - do not touch those files. Worktree E:/FightCamp/wt/Q229, branch qwen/q229-rooms-pass2
(from master). READ FIRST: `research/ROLE_QWEN_ROOM_DESIGNER.md` (role, materials, the review loop, gates), then
your own Q225 digest on master (`research/Q225_DIGEST.md` if merged, else `git show origin/qwen/q225-lobby-floor-pass2:research/Q225_DIGEST.md`) -
the recipe that worked: world-scale triplanar Bricks085 + Concrete031 (already in `Godot/assets/venues/iron_parish/textures/`),
your own seeded wood/rubber maps (`Tools/blender_rooms/q225_textures.py`), AgX, a shadowed key, practicals, story props.

## Targets (the rooms built S108-S110 as pass 1, flat colours)
- MAT ROOM: `Godot/scripts/MatRoom3D.gd` (208 lines) + `MatRoomPanel.gd` (117) - the members' evening class: mats with
  real rubber/vinyl, wall pads, a class in motion (people), the dues board.
- STAFF ROOM: `Godot/scripts/StaffRoom3D.gd` (668) + `StaffRoomPanel.gd` (91) - concept `previews/concepts/room_staff.jpg`.
- PHYSIO: `Godot/scripts/PhysioRoom3D.gd` (255) + `PhysioRoomPanel.gd` (83) - concept `room_recovery_suite.jpg`: the
  treatment table, ice bath, tape, the body chart per fighter.
Do the ROLE loop per room: review_before/after sheets (`python Tools/room_review.py`), rubric scores, CLARITY first (no
floating/debug text, no overlapping panels), then MATERIAL (real PBR, no flat colours), LIGHT (motivated key with
shadows), LIFE (story props, people). Gym art is bright and alive (product rule).

## Owned files
The three Room3D builders + their panels (name them with line ranges in the digest), `Godot/assets/models/rooms/mat/*`,
`.../staff/*`, `.../physio/*`, `Tools/blender_rooms/mat_*`, `staff_*`, `physio_*`, `Godot/tools/q229_render.gd`,
`previews/q229/*`, `research/Q229_DIGEST.md`.

## Prior research / human / prefab
S108_DIGEST (mat room), S109 (staff), S110 (physio), topics/gym_rooms_art.md; an environment artist's block-out -> dress
-> light -> compare loop; repo props and CC0 textures already in the repo first, Blender for the rest, no downloads, no purchases.

## Tests
Parse gate on every touched .gd; `python Godot/tools/run_tests.py --jobs 2 --only mat_room,staff,physio,smoke`; OPEN every sheet.

## The one trap
New .png/.glb need `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --import` before a test can load them.
That import rewrites hundreds of unrelated .import files - stage ONLY your own files.

## Finish
git add by explicit path, commit, git push -u origin qwen/q229-rooms-pass2. Never edit HANDOFF.md. Do not stop at written.
