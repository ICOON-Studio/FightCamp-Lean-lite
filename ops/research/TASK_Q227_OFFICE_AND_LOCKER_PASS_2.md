# TASK Q227 - office + locker room, pass 2: textured, lit, alive (room designer #2, Qwen CLI on qwen3.8-max)
Model: qwen3.8-max (VISION). Owner: Qwen (second designer seat; Q225 has the lobby + floor - do not touch those files).
Worktree E:/FightCamp/wt/Q227, branch qwen/q227-office-locker-pass2 (from master).
READ FIRST: `research/ROLE_QWEN_ROOM_DESIGNER.md` (role, materials, the review loop, gates).

## Targets
- OFFICE (`Godot/scripts/OfficeRoomPanel.gd` and its 3D scene - grep for the builder): concept in `docs/previews/concepts/`
  (office) and the operator's pick `Godot/assets/ui/bot_art/gym_office.jpg` (desk, belt on the wall, warm lamp light).
  The trophy wall uses our art: `Godot/assets/ui/trophy_*_cutout.png`, `belt_*_cutout.png`, `bot_art/belt_world_title.png`
  framed on the wall; the trophy cabinet reflects GameState.get_gym_medal_entries().
- LOCKER ROOM (`Godot/scripts/LockerRoomPanel.gd` + its 3D): concept `docs/previews/concepts/room_locker.jpg` - a locker
  per fighter with his name, the scale, the fight-week board, benches, towels, tape, bags.
Do the ROLE loop for both rooms: review_before/after sheets (`python Tools/room_review.py`), rubric scores, CLARITY first
(no floating/debug text, no overlapping panels), then MATERIAL (real PBR, no flat colours), LIGHT (motivated key with
shadows, AgX/SSAO), LIFE (story props, people).

## Owned files
The office and locker 3D builders + panels (name them with line ranges in the digest), `Godot/assets/models/rooms/office/*`,
`Godot/assets/models/rooms/locker/*`, `Tools/blender_rooms/office_*`, `locker_*`, `Godot/tools/q227_render.gd`,
`previews/q227/*`, `research/Q227_DIGEST.md`.

## Prior research / human / prefab
S105_DIGEST (office), S106 (locker), U199/U200 *_TO_CONCEPT; an environment artist's block-out -> dress -> light -> compare
loop; repo props first, Blender for the rest, no purchases.

## Tests
Parse gate; `python Godot/tools/run_tests.py --jobs 2 --only office,locker,smoke`; OPEN every sheet.

## The one trap
New .png/.glb need the `--headless --path Godot --import` step before a test can load them.

## Finish
git add by explicit path, commit, git push -u origin qwen/q227-office-locker-pass2. Never edit HANDOFF.md. Do not stop at written.
