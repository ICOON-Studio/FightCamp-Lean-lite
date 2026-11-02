# Q222 Digest - fight VFX: hits, knockdowns, bell pulse

## What landed
- `Godot/scripts/FightVfx.gd` — static builders, no class_name. `sweat_burst(at, dir, power)` for clean significant hits, `canvas_dust(at)` for knockdowns, `bell_pulse(ring)` for the round bell. Each returns a Node3D that frees itself via `tree_entered` + timer/tween. CPUParticles3D (GL Compatibility), billboard rendering, no mesh draw pass (4.7.2 has no `set_draw_pass_mesh` on CPUParticles3D).
- `Godot/scripts/FightWorldLiveScreen.gd` — four edits:
  - Line ~763: `var _fight_vfx: bool = demo_switches_on()` (game ON, tests OFF)
  - Line ~938: `_fight_vfx = bool(options.get("fight_vfx", _fight_vfx))`
  - Line ~1383: bell hook after `FIGHT_AUDIO.begin_round()` — `bell_pulse` on ArenaRig
  - Line ~2165: hit/knockdown hook after `_feed_hit_cam(beat)` — sweat on significant landed, dust on knockdown
- `Godot/tests/fight_vfx_test.gd` — 22 checks, 0 failures. Builders return nodes with correct particle settings, groups, one_shot, direction, warm light colour. Null-ring bell_pulse doesn't crash.
- `previews/q222/` — three stills: bell frame (60), mid-fight significant hit (180, seed 92012), glancing hook (120, seed 77321).

## Gates
- Parse: FightVfx.gd + fight_vfx_test.gd clean. FightWorldLiveScreen.gd pre-existing parse errors (FightClipBinding, Quantise — same on master).
- fight_vfx_test: 22/0
- fight_strike_whole: 932/0 (unchanged — fight_vfx OFF in --script mode, hooks inert)
- run_tests.py wrapper flags pre-existing font cache errors (environment issue, not code)

## Design notes
- No hit-stop: presentation-only clock freeze would need a separate mechanism; out of scope for this task.
- Sweat power scales particle count (5-15) from beat damage.
- Bell pulse: OmniLight3D warm (1.0, 0.85, 0.6), energy 2.0→0 over 0.8s via tween.
- All VFX nodes in `fight_vfx` group for bulk cleanup if needed.

Co-Authored-By: Qwen Code <noreply@qwen.ai>
