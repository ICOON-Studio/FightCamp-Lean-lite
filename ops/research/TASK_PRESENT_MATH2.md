# TASK PRESENT-MATH2 - seven pure presentation modules from Ludo round 16 (sections 3-7) (cloud seat)

Operator S192: "ask ludo what is missing to make the animations like humanlike and do whatever it says". Ludo's design of record:
`research/LUDO_ROUND16_S193.md` - parts "Round 16b" (SECTION 3 knockdowns, SECTION 4 corner) and "Round 16c" (SECTION 5 camera +
replay, SECTION 6 ring presentation, SECTION 7 gym) - and the VERDICT at the end. Ludo's code there is the reference. This task is ONLY
the pure maths and one test; wiring comes later behind switches that default OFF.

## Owned files
- `Godot/scripts/present/KnockdownKineticsSolver.gd` (NEW) - Ludo 3.x (`evaluate_ataxia` + the knockdown/get-up numbers in 3.1-3.6).
- `Godot/scripts/present/CornerPhysiologySolver.gd` (NEW) - Ludo 4.x (`evaluate_corner_body` and the composure/pulse read in 4.3).
- `Godot/scripts/present/CameraCutRules.gd` (NEW) - Ludo 5.2/5.4 (`can_cut`, `validate_candidate_...`, 180-line protection).
- `Godot/scripts/present/ReplayPlanner.gd` (NEW) - Ludo 5.3/5.4 (`calculate_replay_...` speed curve, `compute_replay_cam...`).
- `Godot/scripts/present/RingPresentationDirector.gd` (NEW) - Ludo 6.x as a PURE state machine: `next_phase(phase, elapsed) -> Dictionary`
  with his phase durations (walk-out 20.0 s, intros 18.0 s, glove touch 7.0 s, round card 3.0 s, decision 12.0 s); no nodes.
- `Godot/scripts/present/HeavyBagPhysics.gd` (NEW) - Ludo 7.2 (pendulum).
- `Godot/scripts/present/GymLODManager.gd` (NEW) - Ludo 7.3 (`evaluate_lod`, `calculate_phase_of...`).
- `Godot/tests/present_math2_test.gd` (NEW) - extends SceneTree, prints `PRESENT_MATH2_TEST FAILS=<n>`, quit(1) on any fail.
- `AgentComms/messages/*` (your done note)
Every module: `extends RefCounted`, static funcs only, ZERO preloads, no nodes, no RNG (a caller passes any random roll in), every Ludo
number a named `const` with a one-line comment quoting him. Move Ludo's `run_tests()` / `assert()` cases into the test file (release
builds strip assert); the modules keep no run_tests. Grep the repo for each class_name first (no collisions; `Godot/scripts/present/`
also receives five modules from Arena's ANIM-NEXT-MATH1 - different names, do not touch them).

## Prior research
`LUDO_ROUND15_S193.md` / `LUDO_ROUND13_S193.md` for the house constraints; house style `Godot/scripts/PromoterTrap.gd` +
`Godot/tests/promoter_trap_test.gd`.

## What would a human do?
Copy Ludo's functions, keep his numbers, and turn each of his asserts and each telemetry threshold into a test case.

## Prefab check
N/A - our own rules; Ludo's code is the reference.

## Acceptance (the test, from Ludo's numbers - not from your code)
- Every `run_tests()` assertion Ludo wrote in sections 3-7 becomes a `_check` with the numbers in its message.
- Plus: camera - a cut sooner than Ludo's minimum hold is refused and one after it is allowed; a candidate camera across the 180 line is
  refused. Replay - the speed curve stays inside Ludo's min/max speed and reaches real speed at the end. Ring presentation - the five
  phases run in order with Ludo's durations and the sum is 60.0 s. Heavy bag - an impulse makes the swing decay (amplitude after 3 s
  < amplitude after 0.5 s). LOD - distance bands give Ludo's LOD levels; phase offsets for N fighters are all different.
  Knockdown - the ataxia sway is zero at full recovery and > 0 right after a knockdown. Corner - lower composure gives a lower head pose
  (Ludo 4.3 lerp 0.45 -> -0.05).
- Where Ludo's code and his own stated threshold disagree, keep the threshold, fix the code, and list each such fix in the PR.
Mutants (each must FAIL; report the FAIL counts in the PR): (a) camera minimum hold halved, (b) replay slow speed doubled, (c) ring intro
duration 18.0 -> 10.0, (d) heavy-bag damping set to 0.
Run: parse each new .gd (`--headless --path Godot --check-only --script res://scripts/present/<file>.gd`), then
`--headless --path Godot --script tests/present_math2_test.gd` -> `PRESENT_MATH2_TEST FAILS=0`, no SCRIPT ERROR, no engine ERROR line.
Push your branch, open a PR into master, never merge it, never touch other files, never delete or weaken an existing test.

Model: cloud Qwen (qwen3-coder). Tier: new files only - parse + this test.

## The one trap
Ludo's text uses LaTeX (`$...$`) around numbers - read the number, not the markup. GDScript has no `Mathf`: use the global `lerpf`,
`clampf`, `move_toward`, `smoothstep`.
