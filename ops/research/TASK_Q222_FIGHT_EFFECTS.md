# TASK Q222 - fight effects: hits, knockdowns and the bell you can SEE (engine/visual, Qwen)
Owner: Qwen (qwen3-coder --yolo). Worktree D:/FightCamp/wt/Q222, branch qwen/q222-fight-vfx (from master).
Operator 2026-10-01, verbatim: "we also need effects special effect on the fight and on the menus an rooms".

## Why
The game has NO particle effect anywhere (grep GPUParticles/CPUParticles over Godot/scripts: 0 files). A landed punch,
a knockdown and the bell look the same as air. Renderer: GL Compatibility - use CPUParticles3D, not GPUParticles3D.

## Prior research
`python Tools/prior_research.py impact effect sweat knockdown slow motion camera shake`; `research/J51_FIGHT_CAMERA_CRAFT.md`;
`research/topics/camera_broadcast.md`. `Godot/scripts/FightWorldLiveScreen.gd` is 5,781 lines - never read whole:
`_apply_hit_cam` ~line 4701 (the existing hit camera), the beat loop ~5190-5215 (`beat.get('knockdown')`), the switch list
(`grep -n "DEMO_SWITCHES\|_switch" Godot/scripts/FightWorldLiveScreen.gd`).

## What would a human do?
Broadcast boxing restraint: a SMALL spray of sweat droplets off the head on a clean significant shot (none on a blocked
one), a puff of canvas dust when a man hits the floor, a short hit-stop (2-3 frames, presentation only) on a heavy landed
shot, the existing hit camera kept, and the round bell as a brief warm light pulse over the ring. No cartoon stars, no blood.

## Prefab check
Godot built-ins only (CPUParticles3D, a small SphereMesh/QuadMesh droplet, StandardMaterial3D unshaded). No downloads.

## Owned files
- NEW `Godot/scripts/FightVfx.gd` (static builders, no class_name): `sweat_burst(at: Vector3, dir: Vector3, power: float)`,
  `canvas_dust(at: Vector3)`, `bell_pulse(ring: Node3D)`. Each returns a Node3D that frees itself (one_shot + timer).
- `Godot/scripts/FightWorldLiveScreen.gd`: ONE hook where a beat lands (significant hit -> sweat_burst at the receiver's
  head/torso, power from the beat's damage), ONE at knockdown (canvas_dust at the downed man's hips), ONE at the round
  bell. All behind a new switch `fight_vfx`: game ON, `--script`/tests OFF - exactly as the other room switches work.
  Name every line range you edit in the digest.
- NEW `Godot/tests/fight_vfx_test.gd`: builders make nodes with the expected particle settings and free themselves;
  switch OFF adds nothing to the room (the control arm).
- Stills (windowed, hidden), e.g. `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/capture_arena_art_frame.gd --resolution 1280x720 -- discipline=boxing seed=92012 as_game frame=<n> out=q222_<n>.png`
  at frames that show a landed hit and a knockdown (find a seed with one) -> copy into `previews/q222/`.
  OPEN THEM before you call it done.
- NEW `research/Q222_DIGEST.md`.

## Tests
Parse gate: `python Godot/tools/check_scripts.py <touched .gd>`. The test alone, then
`python Godot/tools/run_tests.py --jobs 2 --only fight_vfx,fight_world_live,fight_world_mount,fight_strike_whole`.
Watchdog first: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once` (RED = wait).

## The one trap
A hit-stop must never change the FIGHT clock (FightRealtime) - presentation only. fight_strike_whole compares events
byte-for-byte and must stay green; headless runs keep `fight_vfx` OFF.

## Finish
git add by explicit path, commit, git push -u origin qwen/q222-fight-vfx. Do not stop at "written".
