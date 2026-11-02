# TASK HITFEEL1 - hit stop + the hit man's reaction numbers (pure module + test)

Model: Qwen (cloud, small pure module). Discipline: BOXING (demo) - the fight's sense of weight.
Operator S279 (chat): "do it" - on Claude's proposal: hit stop on a clean landed blow scaled by power, and a SHORT reaction on the man
who is hit only (head + upper torso, impulse from the punch's wrist speed x the engine's power, back to the clip in 0.15-0.25 s); the
thrower stays pure mocap (S274 clips_only_base stands). Ranges the operator pasted (industry recipe): joint damping 2-6, joint
stiffness 10-50 (stance) -> 0-5 (ragdoll), hit stop 4-12 frames, head:torso mass 1:6 to 1:8, recovery blend 0.1-0.3 s. Claude wires it
later (HITFEEL2, Ziva). Kalli reviews the numbers in parallel; the constants may move after, the functions stay.

## Spec - Godot/scripts/rules/HitFeel.gd (new, extends RefCounted; no preload, no autoload, no file I/O, no class_name)
1. `static func hitstop_frames(contact: String, power01: float, region: String) -> int` - contact "clean" = 4 + round(8 x power01)
   (4..12); "glancing" = half of clean rounded down, min 2; "absorbed"/"blocked"/"missed"/"slipped"/unknown = 0. region "body"
   = clean value - 2 (min 0 for non-clean, min 3 for clean); "head_neck" as computed. power01 clamped 0..1.
2. `static func hitstop_seconds(frames: int, fps: float = 60.0) -> float` = frames / fps (0 for frames <= 0 or fps <= 0).
3. `static func impulse(wrist_speed_mps: float, power01: float, contact: String, glove_kg: float = 0.45, arm_kg: float = 3.5)
   -> float` - N*s on the struck segment: effective mass (glove + arm x 0.5) x wrist speed x (0.5 + 0.5 x power01) x contact factor
   (clean 1.0, glancing 0.45, absorbed 0.2, others 0). Negative/NaN inputs -> 0. Cap at 25.0.
4. `static func reaction_profile(severity: String) -> Dictionary` -> {"stiffness_from", "stiffness_to", "damping", "recovery_s",
   "head_torso_mass_ratio", "segments": Array}: "light" = 50 -> 20, damping 6, recovery 0.15, ratio 7, ["Head"];
   "solid" = 50 -> 8, damping 4, recovery 0.20, ratio 7, ["Head", "Neck", "UpperChest"]; "heavy" = 50 -> 3, damping 2, recovery
   0.25, ratio 6.5, ["Head", "Neck", "UpperChest", "Chest"]. Unknown -> "light".
5. `static func severity_for(impulse_ns: float) -> String` - < 6 "light", < 14 "solid", else "heavy".
6. `static func stiffness_at(profile: Dictionary, t_s: float) -> float` - drop from stiffness_from to stiffness_to over the first 30%
   of recovery_s, hold, then linear back to stiffness_from by recovery_s; t < 0 or t >= recovery_s -> stiffness_from.

## Test - Godot/tests/hit_feel_test.gd (extends SceneTree, PASS/FAIL lines, last line `HIT_FEEL failures=<n>`, quit(1) on failure)
Every number above against the spec; hitstop at power 0/0.5/1 for each contact and both regions; impulse cap and each contact
factor; severity boundaries at 5.999/6/13.999/14; stiffness_at at t=0, 0.3 x recovery, mid-recovery, recovery_s; mutant check: flip
`<` to `<=` at a severity boundary in your head - a case must catch it.

## Contract
OWNS: Godot/scripts/rules/HitFeel.gd, Godot/tests/hit_feel_test.gd
RED_TEST: Godot/tests/hit_feel_test.gd -> HIT_FEEL failures=0
REGRESSION: attribute_profile_test
VISUAL: no

## Prior research
research/topics/hit_reactions.md (Settled: C188 struck-segment physics NOT ACCEPTED on a contact gate - this module is
numbers only), G86_PHYSICS_HIT_REACTIONS.md, K51_THE_HIT_RESPONSE.md (hook ~71 g), Godot/scripts/rules/Attributes.gd ~L165
(hitstop_frames 1-3 by power, target_head_disp_m - unused today), research/GDSCRIPT_TRAPS.md.

## What would a human do?
Write the spec's numbers as constants, a boundary test per function, then the code.

## Prefab check
None - our own numbers.

## The one trap
Pure module only - do NOT touch FightWorldLiveScreen.gd, FightStagePlayer.gd, FightActiveRagdoll.gd or GameSwitches.gd. Plain
`--script` test, no preloads except the module.

## Output
PR with `RESULT: tests/hit_feel_test.gd -> HIT_FEEL failures=0`.
Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/hit_feel_test.gd`.
