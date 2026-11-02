# TASK GRAPPLE-MATH1 - pure grappling maths + contact specs from Ludo rounds 14/15 (cloud seat)

Operator S193 (verbatim): "ask it also to solve the grappling animation (how to make a realistic humanlike bjj fight , takedowns and
everything that is related to animations needs to be solved by ludo nad passed on to codex if it is possible". Ludo's design of record:
`research/LUDO_GRAPPLING_R14_S193.md` (read the VERDICT at the end first), `LUDO_ROUND15_S193.md` section 2.3 (contact specs 1-11),
`LUDO_ROUND15C_S193.md` (specs 11-13 + PART 4 modules). This task is ONLY pure maths + data + one test; Codex wires it later.

## Owned files
- `Godot/scripts/grapple/GrappleSocketTable.gd` (NEW) - Ludo 4.1, but the sockets are DATA: read `Godot/assets/data/grapple_sockets.json`.
- `Godot/assets/data/grapple_sockets.json` (NEW) - Ludo's 14 sockets (bone, offset, normal) + HEAD (bone "head", offset (0, 0.10, 0),
  normal (0, 1, 0)) because the triangle spec uses it.
- `Godot/scripts/grapple/ProceduralTapGen.gd` (NEW) - Ludo 4.2 exactly (period 0.222 s, amplitude 0.085 m, impact at phase >= 0.30).
- `Godot/scripts/grapple/BallisticFallSolver.gd` (NEW) - Ludo 4.3 (GRAVITY -11.5 as a named const) PLUS
  `static func impact_time(p0_y: float, v0_y: float, floor_y: float) -> float` (closed form: the positive root of
  p0 + v0 t + GRAVITY t^2 / 2 = floor).
- `Godot/scripts/grapple/SubmissionStrain.gd` (NEW) - Ludo 4.4 exactly (k 3.2, tap at >= 0.85, break at >= 0.99 or excess >= 1.5 x scale)
  PLUS `static func resist_stiffness(k0: float, strain: float, max_strain: float) -> float` = k0 * exp(3.2 * strain / max_strain)
  (round 14 step 8).
- `Godot/assets/data/grapple_contact_specs.json` (NEW) - Ludo's 13 contact specs (MOUNT .. CLINCH_THAI_PLUM) transcribed, with these
  corrections: every grip_lock gets `"source_body": "ATT"|"VIC"` (the clinch ties list both men's hands - read each pair as ATT's hands
  then VIC's hands in Ludo's order); MOUNT, SIDE_CONTROL, CLOSED_GUARD and HALF_GUARD alignment becomes `{"axis": "chest_normal",
  "target_dot": <Ludo's step-6 rule: -1.0 for mount/guard/half guard, 0.0 for side control>, "tolerance": 0.15}`; the triangle keeps "HEAD".
- `Godot/scripts/grapple/GrappleContactSpec.gd` (NEW) - `static func validate(spec: Dictionary, sockets: Dictionary) -> Array[String]`
  returning every problem found: unknown socket, a grip without source_body, min_dist > max_dist, a ground hold (pose_id not starting
  CLINCH_) with no mat_pins, the same (source_body, source_bone) used twice in one spec.
- `Godot/tests/grapple_math1_test.gd` (NEW) - extends SceneTree, prints `GRAPPLE_MATH1_TEST FAILS=<n>`, quit(1) on any fail.
- `AgentComms/messages/*` (your done note)
Every .gd: `extends RefCounted`, static funcs only, ZERO preloads of game scripts, no nodes, no RNG; every Ludo number is a named const
with a one-line comment quoting him. Grep the repo for each class_name before you use it (no collisions).

## Prior research
`research/topics/paired_holds.md`, `research/topics/ground.md` (FightPoseSolver, GroundGraph, G84 where the hands are in five holds).

## What would a human do?
Put Ludo's numbers in data, write one function per rule, and test each rule against the number Ludo gave.

## Prefab check
N/A - our own rules; Ludo's PART 4 is the reference code.

## Acceptance (the test, written from Ludo's numbers - not from your code)
1. Tap: displacement at t=0 is 0.085; t=0.075 is an impact frame; cadence in [4.4, 4.6] Hz; sampled every 1/60 s over 1.0 s there are
   4 or 5 impact onsets (Ludo: 3-5 taps before the release).
2. Ballistic: from (0,2,0) with v (1,0,0) one 0.1 s step goes down and does not land; from y 0.02 with v (0,-5,0) it lands at exactly
   y 0; impact_time(1.0, 0.0, 0.0) = sqrt(2 / 11.5) within 1e-4.
3. Strain: 90 vs limit 110 -> 0.0; 120 vs 110 (scale 12) -> > 0.85 and tap_required; 140 vs 110 -> bone_break;
   resist_stiffness(1.0, 0.5, 1.0) = exp(1.6) within 1e-4.
4. Sockets: 15 sockets load; NECK = bone "neck", offset (0, 0.02, -0.04); an unknown socket name -> empty bone.
5. Specs: all 13 load and validate() returns [] for each; a copy with socket "HEADX" returns exactly one problem; a copy with one
   source_body removed returns exactly one problem.
Mutants (each must FAIL the test; report the FAIL counts in the PR): (a) tap period 0.222 -> 0.30, (b) GRAVITY -11.5 -> -9.81,
(c) strain k 3.2 -> 2.0, (d) the HEAD socket deleted from the JSON.
Run (Linux: the Godot 4.7.2 headless binary from Tools/cloud_setup.sh): parse each new .gd with `--headless --path Godot --check-only
--script res://scripts/grapple/<file>.gd`, then `--headless --path Godot --script tests/grapple_math1_test.gd` ->
`GRAPPLE_MATH1_TEST FAILS=0`, no SCRIPT ERROR. Push your branch, open a PR into master, never merge it, never touch other files, never
delete or weaken an existing test.

Model: cloud Qwen (qwen3-coder). Tier: new files only - parse + this test.

## The one trap
Godot's JSON gives every number as float and every array as Array: build Vector3 from the 3-element arrays yourself; compare floats with
an epsilon, never ==.
