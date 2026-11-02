## DECISIONS

1. Unbounded simulation catch-up is the highest-risk cause: `Godot/scripts/FightWorldLiveScreen.gd:323-324` loops until the horizon with no frame cap. Probe: count iterations and time `_pump_to`.
2. Raw render delta drives both the show clock and manual body animation: `Godot/scripts/FightWorldLiveScreen.gd:293-317`. Probe: timestamp `_process`/`_advance_bodies` and compare delta, elapsed time, and `presented_seconds()`.
3. The branch watcher adds a per-frame bone camera fit and stopwatch/readout redraw: `Godot/tools/watch_live_room.gd:74-94,161-179`. Probe: timestamp `_frame` and Label writes; this is branch-only, not master.

The master room uses raw, non-negative `_process` delta, not smoothing. At its 20 Hz fight state, a 100 ms live frame advances roughly two engine ticks plus horizon work; the pump is unbounded. No named physics callback advances the AnimationPlayers, bodies, or camera. Manual animation is `AnimationPlayer.advance(delta)` followed by inertial joins and grounding (`Godot/scripts/FightStagePlayer.gd:1093-1103`).

`project.godot` explicitly selects Forward+; vsync, max FPS, physics tick rate, physics interpolation, and low-processor mode are absent and therefore Godot defaults apply: enabled vsync, unlimited FPS, 60 physics ticks/s, interpolation off, and low-processor mode off.

Startup setup loads modules, builds the arena, mounts/binds fighters, and plays idle before beginning the fight (`Godot/scripts/FightWorldLiveScreen.gd:192-207,226-263`). Later event presentation can start a new clip (`Godot/scripts/FightWorldLiveScreen.gd:344-350`; `Godot/scripts/FightStagePlayer.gd:315`), making first-use animation/render work a possible live hitch.

Per-frame master work includes catch-up, two small player-array literals, body animation, grounding/inertial work, and schedule checks. Impact-only work formats strings and rewrites Labels. The watcher additionally rewrites its clock Label and scans seven bones per fighter each frame.

Movie Maker’s fixed 1/30 s and wait-per-frame behavior hides uneven live pacing for every listed cost: it makes the frame late, not visibly skipped. It does not eliminate the work or guarantee the live loop can sustain the same cadence.
