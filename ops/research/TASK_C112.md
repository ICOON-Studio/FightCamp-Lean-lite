# TASK C112 — CODEX — THE INSTRUMENT FOR A SMOOTH LIVE RUN: TIME EVERY FRAME OF THE 3D ROOM

Model: `gpt-5.6-luna`, medium (the only setting). Owner: codex. Main checkout, launched by Claude through
`Tools/codex_task.cmd`. Stage: S4a step (1) SMOOTH LIVE RUN - forecast work: the instrument Claude measures with.

**Test tier: A NEW TOOL FILE ONLY, no game script edited.** Parse gate on your tool, then ONE short HEADLESS smoke run
(below). No test suite, no windowed run - Claude runs the windowed measurements when the PC is quiet.
No commit: your sandbox cannot write `.git`; Claude commits. `python research/C112_check.py smoke` must exit 0.

## Owned files

- `Godot/tools/measure_live_frames.gd` - NEW, yours.
- `research/C112_live_frames_smoke.json` - NEW, written by your tool's smoke run.
- `research/C112_LIVE_FRAMES.md` - NEW, yours, 25 lines at most.

## Why this exists

The operator watched the live 3D fight and found it painful to watch; a Movie Maker recording is always smooth (it
renders every frame at a fixed rate), so the LIVE run's pacing has to be measured on its own. Your C110
(`research/C110_LIVE_ROOM_FRAMES.md`, 15 lines - read it) named the suspects: the unbounded `_pump_to` catch-up
(`Godot/scripts/FightWorldLiveScreen.gd:326`), raw `_process` delta driving the show clock and the bodies (`:296`),
first-use work when a clip starts, and Godot defaults for V-Sync, max FPS and physics. Nothing has been timed yet.

## What to read - ONLY these

- `Godot/tools/watch_live_room.gd` (217 lines, read it whole): how a SceneTree script mounts
  `res://scenes/FightWorldLive.tscn`, calls `configure`, adds it to `root`, holds the room with `set_process(false)`
  and reads its fields with `_room.get("_show_s")`.
- `Godot/scripts/FightWorldLiveScreen.gd` (709 lines - NEVER open it whole): `sed -n '150,200p'` (configure,
  stage_players, setup) and `sed -n '290,420p'` (`_process`, `_advance_bodies`, `_pump_to`, `presented_seconds`).
- `Godot/scripts/FightStagePlayer.gd` (1,398 lines - NEVER open it whole): it keeps its AnimationPlayer in `var _ap`;
  read it from outside with `(player as Object).get("_ap")`.

## The tool (`measure_live_frames.gd`, extends SceneTree)

Arguments after `--`: `seed=` (default 810039), `seconds=` (default 60, WALL seconds), `vsync=`
(`enabled|disabled|mailbox|adaptive`; absent = leave the project default), `max_fps=` (absent = leave it),
`label=` (default `default`). Apply vsync with `DisplayServer.window_set_vsync_mode` and max FPS with `Engine.max_fps`
BEFORE mounting the room.

Mount the room exactly as `watch_live_room.gd` does (same `configure` options, including `fighter_b_mesh`), but
WITHOUT its walk-in, camera fit or stopwatch. Every frame, in the tool's own `_process(delta)`:
1. `_room.set_process(false)`, then time the room's own step: `t0 = Time.get_ticks_usec()`,
   `_room.call("_process", delta)`, `t1` - that is `room_process_ms`.
2. `wall_ms` = `Time.get_ticks_usec()` at the start of this frame, minus the tool's start, in ms.
3. `render_cpu_ms` / `render_gpu_ms` = `RenderingServer.viewport_get_measured_render_time_cpu/gpu` of
   `root.get_viewport().get_viewport_rid()` - switch measuring on once with `viewport_set_measure_render_time`
   (both read 0 in headless; record the 0s).
4. `presented_s` = `_room.call("presented_seconds")`.
5. `clip_changes` = how many of the two players' `_ap.current_animation` differ from the previous frame (0, 1 or 2).
Stop when `seconds` of wall time have passed, or on the first frame the bout is over
(`_room.get("_engine_over")` is true and `presented_s` stopped advancing) - then write the JSON and `quit()`.

JSON `res://research/C112_live_frames_<label>.json`, exactly:
```
{"population": {"label": "...", "seed": 0, "seconds_requested": 0.0, "ruleset": "boxing", "fighters": ["...", "..."],
                "headless": true, "vsync_mode": "...", "max_fps": 0, "physics_ticks_per_second": 0,
                "rendering_method": "..."},
 "columns": ["frame", "wall_ms", "delta_ms", "room_process_ms", "render_cpu_ms", "render_gpu_ms", "presented_s",
             "clip_changes"],
 "frames": [[0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0], ...],
 "summary": {"frames": 0, "wall_s": 0.0, "delta_sum_s": 0.0, "first_presented_frame": 0, "presented_advance_s": 0.0,
             "delta_ms": {"p50": 0, "p90": 0, "p99": 0, "max": 0}, "room_process_ms": {...}, "render_cpu_ms": {...},
             "render_gpu_ms": {...}, "clip_change_frames": 0,
             "hitches": {"threshold_ms": 0.0, "count": 0, "longest_ms": 0.0, "first_3s_count": 0, "on_clip_change": 0},
             "ended_early": false}}
```
- `fighters`: the two men's names, from `_room.call("_fighter", "a")["name"]` and `("b")` (out-boxer (A), pressure puncher (B)).
- `headless`: `DisplayServer.get_name() == "headless"`. `vsync_mode`: the mode's name. `rendering_method`:
  `RenderingServer.get_current_rendering_method()`.
- `delta_sum_s` sums the deltas of frames 1..last. `first_presented_frame`: the first frame whose `presented_s` is
  above the previous frame's. `presented_advance_s`: last `presented_s` minus that frame's.
- `delta_ms` stats cover frames 1..last; the other three cover every frame. Percentiles by linear interpolation
  between closest ranks; `max` is the rows' max.
- `hitches.threshold_ms` = 2 x the `delta_ms` p50; `count` = frames 1..last above it; `first_3s_count` = those in the
  first 3000 ms of wall time; `on_clip_change` = those within one frame of a frame with `clip_changes` > 0.
The check recomputes every summary figure from the rows and pins the clock to physics - get the rows right.

## Gate - in this order, from the repo root

1. `python Godot/tools/check_scripts.py Godot/tools/measure_live_frames.gd`.
2. The smoke run, 10 wall seconds, headless, with a hard timeout (a GDScript runtime error HANGS a headless run
   instead of exiting - if the log shows `SCRIPT ERROR` after a minute, kill it and fix):
   `python C:/Users/user/AppData/Local/Temp/FightCamp-tools/godot_run.py . tools/measure_live_frames.gd -- seconds=10 label=smoke`
   If your sandbox cannot run that wrapper, run
   `%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/measure_live_frames.gd -- seconds=10 label=smoke`
   from Python `subprocess.run(..., timeout=180)` with output to a log file - never a PowerShell pipe (it deadlocks).
3. `python research/C112_check.py smoke` exits 0.

## The digest `C112_LIVE_FRAMES.md`

Opens with `## DECISIONS`: the exact commands Claude should run for the windowed measurements (one per variant: project
default, `vsync=disabled`, `max_fps=60`), what the smoke run's `room_process_ms` p50/p99/max were in headless, and
one line on anything in the room's per-frame work that the smoke run showed to be expensive. Name the population.

## When done

Write your last message as: the three owned files, the check's last line, and the smoke run's frames and
`room_process_ms` max. Claude commits.

## The trap

Headless has no V-Sync and no GPU work, so its deltas say nothing about stutter - the smoke run only proves the
instrument. Do not draw a pacing conclusion from it, and do not let the tool read `_show_s` before the room's
`_process` has run that frame (read `presented_seconds()` after the call).
