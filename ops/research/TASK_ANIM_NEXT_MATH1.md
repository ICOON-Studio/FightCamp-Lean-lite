# TASK ANIM-NEXT-MATH1 - five pure presentation modules from Ludo round 16 section 1 (Arena)

Model: Arena Agent Mode. Repo ICOON-Studio/FightCamp, branch from master; work ONLY on your own arena/ branch, open a PR into master,
NEVER merge it. Write ONLY the NEW files below; edit nothing else. Do not delete or weaken any existing test.

Operator S192: "ask ludo what is missing to make the animations like humanlike and do whatever it says". Ludo's design of record:
`research/LUDO_ROUND16_S193.md` SECTION 1 (1.1-1.5) - read it whole; every number below is his. This task is ONLY the pure maths
and its test; wiring into the fight comes later, behind switches that default OFF.

## Owned files
- `Godot/scripts/present/RopePhysicsSolver.gd` (NEW) - Ludo 1.1.
- `Godot/scripts/present/PunchImpactKinetics.gd` (NEW) - Ludo 1.2.
- `Godot/scripts/present/CanvasWearManager.gd` (NEW) - Ludo 1.3 (the pure `evaluate_foot_scuff` + `fade_alpha(alpha0, age)` only;
  no pooling, no nodes).
- `Godot/scripts/present/GloveGripSolver.gd` (NEW) - Ludo 1.4.
- `Godot/scripts/present/GazeAttentionDirector.gd` (NEW) - Ludo 1.5.
- `Godot/tests/anim_next_math1_test.gd` (NEW) - extends SceneTree, prints `ANIM_NEXT_MATH1_TEST FAILS=<n>`, quit(1) on any fail.
Every module: `extends RefCounted`, static funcs only, ZERO preloads, no nodes, no RNG; every Ludo number a named `const` with a one-line
comment quoting him. No `assert()` and no `run_tests()` inside the modules - all checks live in the test file.

## Prior research
Ludo rounds 11-15 (`LUDO_ANIMATION_S192.md`, `LUDO_ANIMATION_R12_S192.md`, `LUDO_ANIMATION_R13_S193.md`, `LUDO_ROUND15_S193.md`) for
the house constraints. House style for a pure module + test: `Godot/scripts/PromoterTrap.gd` + `Godot/tests/promoter_trap_test.gd`.

## What would a human do?
Copy Ludo's functions, fix only what his own numbers contradict (listed below), and test every number he gave.

## Prefab check
N/A - our own rules; Ludo's section 1 is the reference code.

## Corrections to Ludo's code (his numbers win over his code)
1. Rope (1.1): his `run_tests` asserts `displacement == 0.0` far from the rope, but his decay branch returns `next_disp` (0 only when the
   start is 0 - keep it, and test the decay separately: from disp 0.2, vel 0, 60 steps of 1/60 s far from the rope -> |disp| < 0.02).
   Explicit-Euler with k 4200 at dt 1/60 is unstable for a unit mass: integrate the decay with a CRITICALLY DAMPED closed form or
   sub-steps so that it never grows (test: |disp| never exceeds its start over those 60 steps).
2. Impact (1.2): Ludo's threshold "compression >= 0.018 m within 0-35 ms" must be reachable at impact speed 9 m/s: return
   `compression_m` too and test max over t in [0, 0.035] >= 0.018 at v = 9. If his curve cannot reach it, report the measured max in the
   PR and do NOT change the threshold.
3. Gaze (1.5): use `move_toward` as he wrote; return `yaw_offset_rad` with the sign of a right-handed Y-up yaw (a referee on the +X side
   of a fighter facing +Z must give the same sign as Godot's `Vector2.angle_to` in his own test) - test both sides.

## Acceptance (the test, written from Ludo's numbers - not from your code)
1. Rope: far from every rope height -> no push; a bone at (0, 1.02, 3.10) r 0.15 on rope 2 with outward axis +Z -> displacement > 0 and
   push.z < 0; displacement never exceeds 0.38; the decay case in correction 1.
2. Impact: at t 0.02, v 8.5, dir +Z -> glove_scale_z < 0.98, wrist_pitch_rad > 0.05, clavicle_offset.z < 0; t < 0 or t > 0.09 -> neutral
   (scale 1, pitch 0, offset 0); wrist pitch max over [0, 0.09] in [12, 24] degrees at v 9 (Ludo's wrist threshold).
3. Scuff: a resting foot -> no spawn; (0.5,0,0.5) v (0.6,0,0) yaw 4.5 rad/s grounded -> spawn; airborne -> no spawn; within 8 cm of the
   last spawn -> no spawn; fade_alpha(1.0, 25.0) = exp(-1) within 1e-6.
4. Grip: from 0, STRIKE with dt 0.1 -> > 0.8 rad; from 1.0, OPEN with dt 0.1 -> < 0.3; CLINCH_GRIP target 1.48; an unknown mode -> moves
   toward REST 0.26; Ludo's latency: from 0.2*1.22 rad, STRIKE reaches >= 0.95*1.22 within 80 ms at dt 1/60.
5. Gaze: referee intervening, w from 0 with dt 0.1 -> w = 0.65 (6.5/s); not intervening, w from 1 with dt 0.1 -> 0.6 (4.0/s); yaw and
   pitch clamped to 65 / 35 degrees (a target behind the fighter); both referee sides per correction 3.
Mutants (each must FAIL the test; report the FAIL counts in the PR): (a) rope MAX_DEFLECTION 0.38 -> 0.60, (b) FOAM_COMPRESSION_MAX
0.038 -> 0.010, (c) gaze BLEND_IN_SPEED 6.5 -> 3.0, (d) grip FULL_CLENCH_RAD 1.22 -> 0.80.
Run: parse each new .gd (`--headless --path Godot --check-only --script res://scripts/present/<file>.gd`), then
`--headless --path Godot --script tests/anim_next_math1_test.gd` -> `ANIM_NEXT_MATH1_TEST FAILS=0`, no SCRIPT ERROR, no engine ERROR line.
CI has no LFS: this test loads no models.

## The one trap
Godot's `move_toward` and `lerpf` are global functions in GDScript 4 (no Mathf); `Vector2.angle_to` is signed - test the sign, not
only the magnitude.
