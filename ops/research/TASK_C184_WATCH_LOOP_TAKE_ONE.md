# TASK_C184 - the watch loop's first take: a 60 s MMA bout from the live room that reaches standing, clinch AND ground (Codex, full branch)

Model: gpt-5.6-luna, medium (recording + tooling, not animation authoring). Owner: codex. Assigned S64, 2026-09-24.

## Why
Operator decision 2026-09-24, verbatim: 'go with S64 and the watch loop'. From S65 every animation
session opens by SENDING the operator a recording, taking the three things they say look worst, fixing
those, and re-recording the same seed. THE OPERATOR'S EYE IS THE GATE. Per-hold authoring paused after
C183. This task produces take one so S65 starts with a video in hand, not a render queue.

## Part 1 - find a seed that shows all three phases
`Godot/tools/record_room.gd` records the live room (read its header; it documents every arg). On the PC
there is a display, so no xvfb: run it WINDOWED and HIDDEN through
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <godot args>`
(operator 2026-09-23: agent windows run silently; `--position` never hid anything). Use
`--write-movie <abs path>.avi --fixed-fps 30 --resolution 1280x720 --quit-after 1800` (1800 frames = 60 s),
`-- seed=<n> discipline=mma` and the default room options (engine_positions, body_layers,
pair_grip_solve all ON - do not pass switches). Seed 92000 grounded in S62; confirm it still does on
today's master, and if the 60 s never reaches the ground, try seeds 92001.. until one reaches standing,
clinch AND ground inside 60 s. Print how you know which phase each second is in (the room's own state,
not your eye).

## Part 2 - the deliverable
1. Convert the .avi to H.264 .mp4 (imageio-ffmpeg is on the PC: `python -c "import imageio_ffmpeg; print(imageio_ffmpeg.get_ffmpeg_exe())"`).
   Save it as `research/_captures/watch_loop/take1_seed<n>.mp4`. It must be under 50 MB; lower the CRF, never the resolution.
2. A 12-tile contact sheet (one frame every 5 s, timestamp and phase burned into each tile) at
   `previews/watch_loop_take1_sheet.png`. OPEN IT before you report - a sheet you did not look at is not evidence.
3. A phase timeline table in the digest: second ranges for standing / clinch / ground, and the pair keys that played.

## Owned files
`research/_captures/watch_loop/` (new), `previews/watch_loop_take1_sheet.png` (new),
`Godot/tools/watch_loop_sheet.py` if you need a sheet script (new), `research/C184_DIGEST.md` (new).
Do NOT edit any `.gd` in `scripts/`. If record_room.gd itself is broken, report the line; do not patch around it.

## Gate (tier: research + new tool, no script edited)
No parse gate unless you add a .gd; no suite. Run `git status -s` before staging. Branch
`codex/c184-watch-loop-take1`, worktree off `origin/master`; run `--headless --import` once in the fresh
worktree first (Godot's class cache). Commit, push, one `python Tools/agent_comms.py send` line per part.
Do NOT edit HANDOFF.md.
Trap: `--quit-after` is FRAMES, not seconds, and the movie runs on the fixed clock - a 60 s take at 30 fps
is 1800 frames however long the render takes. Do not "fix" a slow render by cutting frames.
