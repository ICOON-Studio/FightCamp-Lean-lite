# S319 digest (2026-10-31) - Lean update 22: short punches up close, motion blur in the exe

Lean 6b51aa5..7d98932 (pushed). 37/37 tests. Board Q-S294-33. Stills: research/S319_stills (review board S319).

## What changed
- SHOVEL1, SHORT PUNCHES UP CLOSE (John J_INSIDE2: inside punches travel 15-30 cm). `tools/clip_travel.gd` measures each
  punch clip's glove path relative to the hips up to its contact (59 clips -> `assets/data/clip_travel.json`; a long hook
  travels 1.0-1.6 m). Qwen's pure `scripts/rules/ShortPunch.gd` (+ `tests/short_punch_test.gd`, collected ad9c200) picks
  the clip time where only want(move) = 0.20-0.25 m (+-0.04 by the beat's roll) is left before contact. `BeatFire` applies
  it when `Footwork.phase() == "inside"` (`-- noshort` = control arm) and joins slower (0.09 s half-life, 0.35 s).
  `tools/shovel_probe.gd` round 1: inside glove travel p50 0.17-0.20 m, 56-62 % in 15-30 cm; control 0.86 m, 0 %.
- MOTION BLUR WAS NEVER IN THE EXE (updates 20-21). The easy-compositor addon compiles its .glsl SOURCE at run time
  (FileAccess on the resource path); an export packs only the imported RDShaderFile, so the exe logged 192 "cannot
  dispatch invalid shader stage" errors and drew no blur. The sources now ship beside the exe (`tools/export.sh`) and
  `compiled_shader_stage.gd` falls back to them (as RawAsset does for the boxers): 0 errors. An `include_filter` of
  `addons/*.glsl` does NOT work (the importer still replaces the file).
- FightView.gd hit the 500-line cap: the beat switch moved to `scripts/fight3d/BeatFire.gd` (FightView 421 lines).
- Begin-fight click in the exe: worst frame 46-50 ms (S312 fix holds; Ziva's 3-5 s was the editor).

## Measured (smooth_probe, 1.8 min of round 1, our kinks/min = fight tops the raw clip by > 2 cm/frame)
| arm | ours/min | at a clip change |
|---|---|---|
| plain (S318 code) | 445 | 243 |
| noguard | 517 | 342 |
| noreach | 377 | 230 |
| nosnap | 400 | 220 |
| noglove | 357 | 231 |
| nojoin | 1002 | 462 |
| nofeet | 457 | 258 |
| soft GloveClear zone + PunchReach 0.20/0.22 smootherstep, noshort | 465 | 253 |
| short punches, join 0.09 | 502 | 295 |
| short punches, join 0.12 | 512 | 299 |
GloveClear, PunchReach and HitSnap add kinks; HitSnap's snap is the punch power he asked for (S302) and stays. The guard
and the join smoother remove kinks. Smoothing the two layers' ramps did NOT help (reverted, do not retry). The short
punches cost +12 %, half at the punch start, half in the clip; a longer join does not change it.

## Decisions (Claude)
- Short punches ship ON (new features ship ON; real-world numbers); the cost is on the board for his eye (Q-S294-33).
- Exe checks run the probe from its absolute path: `FightCamp.exe --script E:/FightCamp/Lean/tools/<probe>.gd`
  (tools/ is excluded from the pck).

## Traps
- `var x := stage.feet.phase() == ...` - stage is a Node3D, `feet` untyped: ":=" cannot infer -> parse error; two probe
  runs read zero frames before the parse check caught it. Gate every probe batch on the parse check.
- A probe's plain baseline must be re-run on the same code as the arm (the S319 first "worse" reading mixed two changes).

## Next
S320: board answers (Q-S294-33, 32, 31). Smoothness frame by frame on pro_left_hook_v2 and retreat (the top two of OURS):
print the frames around each kink with the live modifier weights and fix that one cause.
