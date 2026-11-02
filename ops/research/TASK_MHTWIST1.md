# TASK MHTWIST1 - TwistSwing: RigLogic's twist/swing joint layer as a pure module + contract test (S264)

Model: Arena default (cloud). Discipline: BOXING (demo) - the MetaHuman boxer's forearm/upper-arm/thigh twist joints in the fight.
Repo: **ICOON-Studio/FightCamp-lite** (code-only mirror, same paths; your PR there is relayed to ICOON-Studio/FightCamp), branch
off master. Never Arena's "Merge PR" button; Claude merges.

## Why
S263 wired the MetaHuman body's DNA correctives (scripts/MetaHumanCorrectiveRBF.gd, RigLogic's RBF solvers, exact since MHRBF2).
The DNA also carries a TWIST/SWING layer: 8 twist joints (forearm, upper arm, thigh, calf twists) whose rotation is a fixed
fraction of their driver's twist about its own axis. Today scripts/MetaHumanTwist.gd drives them by hand-picked fractions.
This task ports RigLogic's evaluator exactly as a pure module; Claude extracts the DNA's setups to JSON and wires it afterwards.

## The math - Epic's own source, ported line for line
Source: UE 5.8 `Engine/Plugins/Animation/RigLogic/Source/RigLogicLib/Private/riglogic/joints/cpu/twistswing/TwistSwingJointsEvaluator.h`
and `Public/tdm/Computations.h`. Quaternions are (x, y, z, w); `*` is the Hamilton product (identical to Godot's `Quaternion * Quaternion`).
- `separate_twist(q, axis)`: axis 0 = X -> t = (q.x, 0, 0, q.w); 1 = Y -> (0, q.y, 0, q.w); 2 = Z -> (0, 0, q.z, q.w).
  If t.length_squared() == 0 -> IDENTITY, else t.normalized().
- `rl_inverse(q)` = conjugate(q) * (1 / q.length_squared()).
- `rl_slerp(q1, q2, t)` (tdm::slerp - NOT Godot's slerp; port it exactly, no normalisation at the end):
  c = dot(q1, q2); tmp = q2; if c < 0: tmp = -tmp, c = -c.
  if c > 1 - FLT_EPSILON (1.1920929e-07): t1 = 1 - t, t2 = t
  else: th = acos(c); s = sin(th); t1 = sin((1 - t) * th) / s; t2 = sin(t * th) / s.
  return q1 * t1 + tmp * t2   (component-wise scale + add)
- One SETUP (a Dictionary) evaluates as:
  ```
  inv_twist = IDENTITY
  if setup has swing_input:
      q = inputs[swing_input]
      twist = separate_twist(q, swing_axis)
      inv_twist = rl_inverse(twist)
      swing = q * inv_twist
      inv_swing = rl_inverse(swing)
      for i: out[swing_outputs[i]] = inv_twist * rl_slerp(inv_swing, IDENTITY, swing_weights[i])
  if setup has twist_input and NOT swing_input:
      q = inputs[twist_input]
      inv_twist = separate_twist(q, twist_axis)          # Epic: "No actual inversion is needed here"
  for i: out[twist_outputs[i]] = rl_slerp(inv_twist, IDENTITY, twist_weights[i])
  ```
  Note both quirks exactly as Epic wrote them: a merged setup (swing + twist on the same input) feeds the twist outputs the
  INVERSE twist; a twist-only setup feeds the twist itself. A weight of 1 gives IDENTITY, a weight of 0 gives the full
  (inverse) twist. Do not "fix" either.

## Build (NEW files only)
- `Godot/scripts/rules/TwistSwing.gd` (`extends RefCounted`, static funcs, no preloads, no assets):
  `separate_twist(q: Quaternion, axis: int) -> Quaternion`, `rl_inverse(q: Quaternion) -> Quaternion`,
  `rl_slerp(q1: Quaternion, q2: Quaternion, t: float) -> Quaternion`,
  `evaluate(setup: Dictionary, inputs: Dictionary) -> Dictionary` (output joint name -> Quaternion), and
  `evaluate_all(setups: Array, inputs: Dictionary) -> Dictionary` (later setups overwrite earlier keys, as RigLogic writes the
  same output buffer in order). Setup keys: `twist_axis` int, `twist_input` String, `twist_weights` Array[float],
  `twist_outputs` Array[String], `swing_axis` int, `swing_input` String, `swing_weights` Array[float], `swing_outputs`
  Array[String]; a missing/empty `*_input` = that half absent. `validate(setup) -> Array` of error strings (weights and outputs
  the same length, axis 0..2, input present in `inputs` is checked by evaluate, not validate).
- `Godot/tests/twist_swing_test.gd` (NEW, `extends SceneTree`, preload TwistSwing.gd only). Prints `TWIST_SWING failures=<n>`
  last; `quit(1)` if n > 0. Named FAIL lines. Checks (tolerance 1e-5 unless stated):
  1. separate_twist: q = 70 deg about X composed with 30 deg about Z (q = qZ30 * qX70): axis 0 returns a pure-X quaternion
     (y = z = 0) of unit length; q with x = w = 0 (e.g. 180 deg about Y) on axis 0 returns IDENTITY.
  2. rl_slerp: t = 0 -> q1, t = 1 -> q2 (sign-aligned), q1 = IDENTITY, q2 = 90 deg about X, t = 0.5 -> 45 deg about X;
     q2 = -q2 gives the same result (shortest path); near-equal inputs (c > 1 - eps) take the linear branch (q1 = q2 =
     IDENTITY, t = 0.3 -> IDENTITY exactly, no NaN).
  3. Twist-only setup, driver = 80 deg about X, weights [0.0, 0.5, 1.0]: outputs = 80 deg, 40 deg, 0 deg about X.
  4. Merged setup (swing_input == twist_input), driver = qZ40 * qX60, swing axis X, swing weight 0.5, twist weight 0.25:
     twist output = rl_slerp(inverse(twistX60), IDENTITY, 0.25) = -45 deg about X; swing output = invTwist *
     rl_slerp(invSwing, IDENTITY, 0.5) - compare with a hand-written expected built from Godot's Quaternion(axis, angle)
     in the test (independent of the module's functions).
  5. evaluate_all: two setups writing the same output name - the later one wins.
  6. validate: mismatched weights/outputs and axis 3 each return an error; a good setup returns [].
  7. MUTANTS (prove in the PR body, then revert): (a) separate_twist without normalise -> check 3 or 4 red; (b) merged
     setup twist outputs using the twist instead of its inverse -> check 4 red; (c) rl_slerp replaced by Godot's
     Quaternion.slerp -> check 2's near-equal or sign case red OR say in the PR which checks stay green and why.

## Contract
OWNS: Godot/scripts/rules/TwistSwing.gd, Godot/tests/twist_swing_test.gd
RED_TEST: tests/twist_swing_test.gd -> TWIST_SWING failures=0
REGRESSION: twist_swing_test
VISUAL: no

## VISUAL GATE
Not visual in this task: a pure module, nothing in the game calls it yet. Claude wires it (MetaHumanRig, switch
mh_dna_twist) and takes it through .claude/skills/visual-gate (live fight camera stills, guard + mid-punch, forearm/elbow
twist read on the still) before it ships ON.

## Prior research
research/S263_DIGEST.md (DNA correctives from RigLogic source; TwistSwingJointsEvaluator named there), TASK_MHRBF2.md
(same port discipline: Epic's math, no improvements), scripts/MetaHumanCorrectiveRBF.gd lines 8-9 + 102-109 (the swing
formula already used for the corrective roots - your module must agree with it for weight 0.5).

## What would a human do?
A rigger reproducing a MetaHuman outside Unreal ports RigLogic's twist/swing evaluator verbatim and unit-tests it against
hand-built quaternions before trusting it on the body.

## Prefab check
RigLogic itself is the reference (C++, UE source, not shippable inside Godot); no GDScript port exists (checked: Asset Library,
GitHub "riglogic godot"). Porting ~40 lines is the smallest correct route.

## Rules
research/GDSCRIPT_TRAPS.md (Variant `:=`, `%%` in format strings). No preloads besides the module in the test. Never
delete, loosen or re-threshold a test. Godot is usually not installed in your sandbox: if you cannot run the test, say so and
write the RESULT lines as "expected, not observed" - Claude runs them (S264: that honesty is what we want).
PR body: `RESULT: tests/twist_swing_test.gd -> TWIST_SWING failures=0` + the three mutant lines.
