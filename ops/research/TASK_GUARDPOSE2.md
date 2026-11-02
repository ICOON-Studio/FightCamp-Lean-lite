# TASK GUARDPOSE2 - the guard-pose math kernel: a safe two-bone IK, per-arm guard weights, arm measurements (S262)
Model: Arena default (cloud). Discipline: boxing = demo.
Repo: ICOON-Studio/FightCamp, branch off master. Never Arena's "Merge PR" button; Claude merges.

## Why
The operator (S261) on the boxer's guard: "doesn't look like an arm", "it's just a guard pose and we need a shit ton of
variations". Ludo (research/ludo_rx/LUDO_GUARDPOSE_S261.txt) and Codex (research/CODEX_GUARDPOSE_S262.md) both say:
authored base pose per style + constrained two-bone IK on top. Claude wires the IK into FightStagePlayer.gd (NOT your job).
Your job is the PURE MATH the wiring calls, in `Godot/scripts/rules/GuardPose.gd` (86 lines, read it whole), with a unit test.

## Build (all in GuardPose.gd - pure, extends RefCounted, ZERO preloads, every input passed in; keep every existing function
## and its signature working - `pose`, `style_for`, `to_world`, `elbow_for` stay callable with the same results for valid input)
1. `static func solve_arm(s: Vector3, want: Vector3, a: float, b: float, pole: Vector3, prev_bend: Vector3,
   min_flex_deg: float = 15.0, max_flex_deg: float = 145.0) -> Dictionary`
   Returns `{"elbow", "wrist", "bend", "target_error_m"}` or `{}` on bad input (non-finite vectors, a or b <= 0.001,
   min_flex < 0, max_flex >= 180, min >= max). Flexion = 0 deg for a STRAIGHT arm. Clamp the shoulder->wrist distance to
   [sqrt(a2+b2+2ab cos(max_flex)), sqrt(a2+b2+2ab cos(min_flex))] and RETURN the clamped wrist (so |elbow-wrist| == b always).
   Bend direction: `pole` projected off the shoulder->wrist axis; if that is degenerate use `prev_bend` projected; if still
   degenerate use the world axis least aligned with the direction, projected. Zero-length s->want: use prev direction or FORWARD.
   Reference kernel: CODEX_GUARDPOSE_S262.md section 6 `solve_arm_points` (adapt it; the test below is the contract).
2. Re-implement `elbow_for(s, t, a, b, pole)` as `solve_arm(s, t, a, b, pole, Vector3.DOWN, 0.5, 179.0)["elbow"]` (fallback
   `s + DOWN * a` when it returns `{}`), so the old caller gets the safe kernel. Its result for a reachable target with a
   non-degenerate pole must stay within 1 mm of master's.
3. `static func pole_dir(f: Vector3, r: Vector3, u: Vector3, lead: bool, southpaw: bool, pole_fwd: float, pole_in: float) -> Vector3`
   = normalized(-u + f * pole_fwd + inward * pole_in), inward = toward the body midline for that hand: orthodox lead = LEFT hand
   -> inward = +r; rear = RIGHT hand -> inward = -r; southpaw flips both.
4. `static func mirror(offset: Vector3) -> Vector3` = Vector3(x, -y, z) (southpaw head-frame offset).
5. `static func ease5(x: float) -> float` (quintic smootherstep, clamped 0..1) and
   `static func guard_weight(t, release_start, release_end, return_start, return_end) -> float`:
   1 before release_start, eased 1->0 to release_end, 0 until return_start, eased 0->1 to return_end, 1 after.
   Bad ordering (not rs < re <= ts < te) -> return 1.0 (never assert - the game must not crash).
6. `static func arm_weights(punching: String, w: float) -> Dictionary` -> `{"lead": x, "rear": y}`: the punching arm
   ("lead"/"rear") gets `w`, the other arm stays 1.0; punching "" -> both 1.0. (Codex s5: one shared weight dropped BOTH arms.)
7. `static func measure_arm(s: Vector3, e: Vector3, w: Vector3, f: Vector3, out: Vector3, u: Vector3) -> Dictionary` ->
   `{"flare_deg", "forward_deg", "flex_deg", "forearm_from_up_deg"}` exactly per CODEX_GUARDPOSE_S262.md section 2 formulas
   (flare = atan2(upper.out, -upper.u); forward = atan2(upper.f, -upper.u); flex = angle(upper, fore); forearm vs +u).
   This is what the visual gate prints per still.

Header comment: add one line per new function (what it is for), keep the existing header.

## Test: `Godot/tests/guard_pose_test.gd` (NEW, extends SceneTree, pure - preload GuardPose.gd only, no scenes, no assets/LFS)
Print `GUARD_POSE failures=<n>` last; quit(1) if n > 0. Checks (each a named FAIL line when it fails):
- solve_arm over a grid: 5 shoulders x 40 targets (reachable, too far, too close, straight above, straight below, on the pole
  axis) x 3 (a,b) pairs incl. a != b: |elbow-s| == a and |wrist-elbow| == b within 1e-4; all finite; target_error_m == 0
  (1e-4) for reachable targets inside the flex limits; flexion of the result within [min_flex-0.1, max_flex+0.1] deg.
- Degenerate pole (pole parallel to s->want) still gives a finite elbow with |elbow - s| == a and a non-zero bend.
- Bad inputs return {}: NAN target, a = 0, max_flex = 180, min > max.
- elbow_for parity: 200 seeded random reachable (s, t, pole not within 10 deg of the axis): new vs a COPY of master's formula
  (paste master's old body into the test as `_old_elbow_for`) within 1 mm.
- pole_dir: orthodox lead hand -> dot(pole, r) > 0, rear -> < 0, southpaw flips; dot(pole, u) < 0; unit length.
- guard_weight: 1.0 at t<=rs, 0.0 in [re, ts], 1.0 at t>=te, monotone on each ramp (100 samples), C1-smooth at endpoints
  (|w(rs+1e-4) - 1| < 1e-6); bad ordering -> 1.0.
- arm_weights: "lead" 0.3 -> {lead 0.3, rear 1.0}; "rear" -> mirrored; "" -> both 1.
- measure_arm: a hand-built arm (upper straight down, forearm straight forward) -> flare 0, forward 0, flex 90, forearm_from_up 90
  (0.01 deg); an arm flared 10 deg outward -> flare 10 (0.01).
- Existing behaviour untouched: for each of the 5 styles and 3 seeds, `pose()` returns the same lead/rear as master (paste
  master's 5x3 values computed in the test from a copy of master's `pose`, or just assert lengths >= 0.20 and style key echoed).
- Mutant proof (in the PR body, not the test): break solve_arm's clamp (return want instead of the clamped wrist) -> the test
  goes red; break arm_weights (both arms get w) -> red. Paste both red lines.

## Contract
OWNS: Godot/scripts/rules/GuardPose.gd, Godot/tests/guard_pose_test.gd
RED_TEST: Godot/tests/guard_pose_test.gd -> GUARD_POSE failures=0
REGRESSION: guard_pose_test
VISUAL: no - pure math; Claude wires it into FightStagePlayer and takes the game-camera stills.

## Run
- Parse: `python Godot/tools/check_scripts.py Godot/scripts/rules/GuardPose.gd Godot/tests/guard_pose_test.gd`
- `python Godot/tools/run_tests.py --jobs 2 --only guard_pose_test`
- On master (before your change) the test must FAIL (functions missing = SCRIPT ERROR counts). Paste that red line.
- PR body: `RESULT: tests/guard_pose_test.gd -> GUARD_POSE failures=0`, the master red line, the two mutant red lines.

## Prior research
CODEX_GUARDPOSE_S262.md (sections 2, 5, 6 - the kernel, phases, measurement formulas), ludo_rx/LUDO_GUARDPOSE_S261.txt (hybrid
verdict), LUDO_ELBOW_S261 (wrist 0.21-0.23 m from head, elbow 3-5 cm off ribs, upper arm 8-12 deg), J50_HOW_A_DEFENDER_DEFENDS.md.

## What would a human do?
An animator poses the arm by hand, then lets an IK handle hold the glove while the body moves - the elbow never pops because
the pole is stable and the arm never stretches. This kernel is that IK handle, made safe for every input.

## Prefab check
Godot 4.7 has `TwoBoneIK3D`/SkeletonModifier3D, but our arm pass runs after a manual pose pass and needs per-arm weights and a
returned clamped wrist for telemetry - a pure analytic kernel is ~60 lines and testable headless. No asset needed.

## The one trap
Do not change `pose()` numbers, `STYLES`, `GUARD_LIFT_SPAN` or `style_for` - the operator has guard-height stills pending on the
review board built from them. Never delete or loosen a test to go green (Claude reads the CI log).

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped clip: it must read RED on <the defect>; paste that number in your report.
2. Stills only via record_room.gd -- as_game + still_framing.gd save_if_framed: guard, contact frame, one between.
3. For every still report: gap between bodies / where each nose points / wrists in line / feet / the defect / which bodies.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.
