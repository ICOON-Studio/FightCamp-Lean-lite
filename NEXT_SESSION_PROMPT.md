# S320 - next session (written S319, 2026-10-31)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.

Where it stands: update 22 exported (Lean 7d98932, 37/37 tests): short punches up close (SHOVEL1: BeatFire + ShortPunch +
clip_travel.json, glove travel p50 ~0.2 m vs 0.86 m), motion blur really in the exe (glsl sources beside it), FightView
split (BeatFire.gd). Digest: Game Godot/research/S319_DIGEST.md (the control-arm table is there).

1. Board: Q-S294-33 (update 22 short punches), Q-S294-32 (update 21 body map), Q-S294-31 (update 20 TV look). If the
   short punches look jumpy to him, turn them off (`noshort` path) and keep the rest.
2. Smoothness frame by frame: our kinks are 445/min (502 with short punches). Top clips of OURS: pro_left_hook_v2 (~100),
   retreat (~75). Extend tools/smooth_probe.gd to print the frames around each kink of those clips with the live modifier
   state (PunchReach.last_weight, GloveClear.pushes delta, HitSnap active, join active) and fix the one cause. Measured and
   NOT helping (do not retry): a soft GloveClear zone, a longer/smootherstep PunchReach ramp, a longer join for short
   punches, a step starting inside the step grace.
3. Give Qwen the next pure piece the moment one appears (worktree E:\FightCamp\wt\LEAN_BODYMAP1, branch per task).

Traps: parse-check Lean files with `godot --headless --path . --check-only --script <file>` and gate every probe batch
on it (S319 lost two runs to an untyped `:=`); run a probe on the exe with `Builds/FightCamp.exe --script
E:/FightCamp/Lean/tools/<probe>.gd` (tools/ is not packed); a pure module tuned on one RoundScript is 6x off the live game.
