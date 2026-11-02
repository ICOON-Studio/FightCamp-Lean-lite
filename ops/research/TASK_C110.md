# TASK C110 — CODEX — WHY THE LIVE ROOM IS CHOPPIER THAN ITS VIDEO: EVERY SOURCE OF UNEVEN FRAMES, FROM THE CODE

Model: `gpt-5.6-luna`, medium (the only setting). Owner: codex. Main checkout, launched by Claude through
`Tools/codex_task.cmd`. Stage: S4a step (1) LIVE-RUN SMOOTHNESS - forecast research for Claude's frame-time measurement.

**Test tier: RESEARCH. NO Godot run at all** (Claude is running Godot in this checkout, and the PC overheats if two
run). Read source and write two files. **Do NOT commit** (your sandbox cannot write `.git`); Claude commits.
`python research/C110_check.py` must exit 0 when you finish.

## Owned files

- `research/C110_live_room_frames.json` - NEW, yours.
- `research/C110_LIVE_ROOM_FRAMES.md` - NEW, yours, 40 lines at most.

## Why this exists

The operator watched the real-time 3D boxing room twice: as a Movie Maker video (`--write-movie`) and live in a
window. In their words, "the movement looks smoother in the video than when you run it through Godot", and "i want to
have the same result in both". Godot's Movie Maker renders every frame at a FIXED delta (1/30 s here) and waits for
each frame, however long it takes. So anything that makes a live frame late, uneven or skipped vanishes from the
video. Before Claude measures frame times, we want the map of every place in the code where that can happen.

## What to read - ONLY these

- `Godot/scripts/FightWorldLiveScreen.gd` (702 lines): `_process` (:293), `_advance_bodies` (:314), `_pump_to`
  (:323), `_present_entry` (:344), `_step_gap` (:425), `_walk_at_body_speed` (:455), `_show_side` (:516), `setup`
  (:180). Read each function whole, and nothing else in the file unless a call leads there.
- `Godot/scripts/FightStagePlayer.gd` (1,375 lines - never open it whole): `advance` (:1094), `_ground` (:1114),
  `_inertialize_joins` (:1249), `play_role` (:273), `settle` (:928), and the AnimationPlayer setup around
  `callback_mode_process` (:1079). Use `sed -n 'A,Bp'` windows.
- The watch tool, which is not on master yet - read it with
  `git show origin/claude/watchable-room:Godot/tools/watch_live_room.gd` (217 lines; read it whole).
- `Godot/project.godot` (37 lines; read it whole).

## Answer these six, each citing `file:line`

- **q1 - the clock.** What `delta` advances the room's show clock, the engine and the bodies: the raw `_process`
  delta, a clamped one or a smoothed one? When ONE frame takes 100 ms, how many engine ticks does `_pump_to` run in
  that frame? Is that bounded?
- **q2 - process against physics.** Does any AnimationPlayer, body or camera advance in `_physics_process`, or on a
  physics callback, while the screen draws at the monitor's rate? How is the manual-callback AnimationPlayer advanced,
  and by what delta?
- **q3 - the settings.** In `project.godot`: V-Sync mode, max FPS, physics ticks per second, physics interpolation,
  low-processor mode and the rendering method. Where a key is absent, say `default` and give Godot 4's default value.
- **q4 - work after the first frame.** Anything loaded, instantiated, retargeted, built or first drawn AFTER the bout
  starts (`load()`, `instantiate()`, new materials or meshes, a retarget, a first `play()` of a clip, a first use of a
  shader). Each one is a hitch candidate under Forward+, where a pipeline compiles on first draw.
- **q5 - per-frame cost.** Allocations and heavy work on every frame: Dictionary or Array literals, string
  formatting, Label text set every frame, `get_node` lookups, loops over all bones or all tracks.
- **q6 - what the video hides.** For each item above: does a fixed 1/30 s delta that waits for every frame hide it?
  Say yes or no, and why.

## The JSON's exact shape (the check reads these keys)

```
{"sources": [{"file": "Godot/scripts/FightWorldLiveScreen.gd", "line": 293, "quote": "func _process(delta",
              "kind": "clock_source", "when": "every_frame", "what": "...", "video_hides_it": "yes - ...",
              "probe": "Time.get_ticks_usec() before and after <call>, at <file:line>"}],
 "project_settings": [{"key": "display/window/vsync/vsync_mode", "value": "default"}],
 "answers": {"q1": "...", "q2": "...", "q3": "...", "q4": "...", "q5": "...", "q6": "..."}}
```

- `kind` is one of `per_frame_alloc`, `unbounded_loop`, `catch_up`, `first_use_compile`, `physics_vs_process`,
  `clock_source`, `vsync_fps_setting`, `blocking_load`, `text_redraw` or `other`.
- `when` is one of `every_frame`, `on_event` or `once_at_start`.
- `quote` is a short exact piece of the cited line.
- A `project_settings` key is written `section/key`, so `[display]` plus `window/vsync/vsync_mode` becomes
  `display/window/vsync/vsync_mode`. `value` is exactly what `project.godot` writes after `=`, or `default` when the
  key is absent.
- These six keys are required: `display/window/vsync/vsync_mode`, `application/run/max_fps`,
  `physics/common/physics_ticks_per_second`, `physics/common/physics_interpolation`,
  `application/run/low_processor_mode` and `rendering/renderer/rendering_method`.
- Every answer except q3 cites at least one `Godot/...gd:<line>` that is also a `sources` row.

## The digest (`C110_LIVE_ROOM_FRAMES.md`)

It opens with `## DECISIONS`: the three most likely causes of the live run's choppiness, in order, each with its
`file:line` and the probe that would prove or clear it. No fixes, no code changes. Claude measures, then fixes.

## When done

`python research/C110_check.py` exits 0. Then
`python Tools/agent_comms.py send --from codex --to claude --topic "C110 ready" --body "check exit 0"` (a git staging
error from that command is expected in your sandbox; the mail file is still written). Do not edit `HANDOFF.md`.

## The trap

The watch tool is on a BRANCH. The copy of `FightWorldLiveScreen.gd` you read on master is not what that tool drives
until the branch merges (it adds nine lines). Cite master's lines for master's files, and say so wherever the branch
changes the answer.
