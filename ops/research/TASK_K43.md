# TASK K43 — KALLI — WHY A GODOT 4 3D SCENE STUTTERS ON WINDOWS, AND WHICH SETTINGS MAKE IT SMOOTH

Model: Grok Bot (Kalli), research. Owner: kalli. Stage: S4a step (1) SMOOTH LIVE RUN - forecast research.

**Research only.** No code, no downloads, no sign-ups. Links and dates. One pass. Reply in this chat.

## Why this exists

Our game is Godot **4.7.2**, renderer **Forward+** on **Vulkan**, Windows 11. A live 3D fight scene (two skinned
fighters with AnimationPlayers advanced manually each frame, one camera, simple gym) must look as smooth live as a
fixed-rate video capture does. Every Godot setting that affects pacing is at its default in our project: V-Sync on,
max FPS unlimited, 60 physics ticks/s, physics interpolation off, low-processor mode off. We are about to time every
frame; we need to know what the known causes and fixes are before we read the numbers.

## What we already hold - do NOT re-research

Our own code audit of the scene's per-frame work. Movie Maker renders at a fixed rate and hides live pacing.

## What to find - one row each, labelled DOCUMENTED (official docs / engine source / PR) / SECONDARY / NOT FOUND

1. **Delta smoothing:** what `application/run/delta_smoothing` does in Godot 4.x, its default, which versions, and
   whether it applies with V-Sync on, off, or both. Quote the docs or the PR.
2. **V-Sync modes on Windows + Vulkan:** enabled / adaptive / mailbox / disabled - which present modes they map to,
   and any documented frame-pacing or judder problems with each (GitHub issues with numbers, dates, and whether fixed).
3. **Physics interpolation in 3D** (added in 4.4?): what it fixes, what it does NOT fix, and whether it matters for a
   scene that moves nodes and advances AnimationPlayers in `_process` rather than `_physics_process`.
4. **Shader and pipeline compilation hitches:** the first time a material or skinned mesh draws, does Godot 4.x
   Forward+ compile pipelines on the fly? What 4.3-4.7 added to avoid it (pipeline cache, the shader baker, warm-up
   tricks such as drawing everything once off-screen), and what is recommended for a game that spawns its fighters at
   scene start.
5. **AnimationPlayer / AnimationMixer cost:** is `callback_mode_process` MANUAL with `advance(delta)` each frame the
   documented way to drive it? Any documented hitch when `play()` switches to an animation for the first time.
6. **Measuring:** the documented way to find frame-time spikes in a Godot 4 game - the built-in Profiler and Visual
   Profiler, `Performance` monitors, `RenderingServer.viewport_get_measured_render_time_cpu/gpu` - and what each one
   can and cannot see.
7. **What shipped Godot 4 3D games or official demos do** for smooth presentation (one or two examples with sources).

## Your answer's first section: `## DECISIONS`

At most six lines, each an action for our scene:
- the V-Sync mode and max FPS to test first, and why;
- delta smoothing: leave, or set, and to what;
- physics interpolation: needed or not, for our `_process`-driven scene;
- the pipeline/shader warm-up to add, if any;
- the one most likely cause of a stutter we should look for first in our frame-time numbers.

Claude collects as: `research/K43_GODOT_FRAME_PACING.md`
