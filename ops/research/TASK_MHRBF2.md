# TASK MHRBF2 - CorrectiveRBF: the exact RigLogic solver mode (interpolative, UE kernels, normalise + threshold) (S263)
Model: Arena default (cloud). Discipline: boxing = demo.
Repo: ICOON-Studio/FightCamp, branch off master. Never Arena's "Merge PR" button; Claude merges.

## Why
S262 MHRBF1 (merged 0d7cdd1a) built `Godot/scripts/rules/CorrectiveRBF.gd` for a SAMPLED table, with its own compact kernel
(exp(-4u^2) cut at the radius) and additive normalisation. S263 read the REAL MetaHuman body rig instead: the body DNA holds
the solvers, and the tables are now on master (`Godot/assets/data/mh_correctives_boxer01..04.json`, made by
`Tools/mh_corrective_table.py`). Each solver there says `"solver_type": "interpolative"`, `"normalize": "always"`,
`"weight_threshold": 0.001`, `"function": "gaussian"`, `"distance": "swing"`. Unreal evaluates those with Epic's RigLogic
(OpenRigLogic, MIT, github.com/EpicGames/OpenRigLogic, `src/riglogic/rbf/cpu/RBFSolver.cpp`, `InterpolativeRBFSolver.cpp`,
`AdditiveRBFSolver.cpp`). To make our helpers move like Unreal's, CorrectiveRBF must evaluate those fields the same way.
Keep every existing behaviour for tables WITHOUT `solver_type` (the MHRBF1 test must stay green unchanged).

## The math (from OpenRigLogic RBFSolver.cpp; d = distance in RADIANS, r = radius in RADIANS = deg_to_rad(radius_deg))
Kernels (UE / RigLogic exactly - note the Gaussian divides by r SQUARED and does NOT square d):
- gaussian    w = exp(-d / (r*r))
- exponential w = exp(-2*d / r)
- linear      w = max(0, 1 - d/r)
- cubic       w = max(0, 1 - (d/r)^3)
- quintic     w = max(0, 1 - (d/r)^5)
Distances: swing = reduce both rotations to their swing about twist_axis, then the quaternion arc
`arc = acos(clamp(2*dot(qa,qb)^2 - 1, -1, 1))`; quat = that arc on the full rotations; twist = |twist angle difference|.
Solvers:
- additive:      w_i = kernel(dist(x, t_i))
- interpolative: A[i][j] = kernel(dist(t_i, t_j)) for all target pairs (diagonal = kernel(0) = 1); solve once per solver
  (cache it), then w = clamp(A^-1 * phi(x), 0, 1) element-wise, where phi_i(x) = kernel(dist(x, t_i)).
  Use LU or Gauss-Jordan with partial pivoting in GDScript (N <= 16 here). If A is singular (pivot < 1e-9), fall back to
  the additive weights for that solver and report it.
Normalise + cut: s = sum(w). ratio = 1/s if (s > 1 or normalize == "always") and s > 1e-12, else 1. w_i *= ratio *
pose_scale_i (pose_scale defaults 1.0 - a sample may carry "scale"). Then w_i = 0 when w_i <= weight_threshold.
Outputs keep MHRBF1's blend (linear t, sign-aligned weighted quaternion average) - but when the weights sum to < 1 (a
threshold cut everything / normalize "above_one"), the remaining (1 - sum) goes to the sample named "default" if present
(the rest pose), so a far query rests instead of collapsing.

## Build (edit only these two files)
- `Godot/scripts/rules/CorrectiveRBF.gd`: `weights()` branches on `table_solver.get("solver_type", "")`:
  "" -> today's code untouched; "additive"/"interpolative" -> the math above. New static
  `ue_kernel(d: float, r: float, function: String) -> float` and `solve_matrix(table_solver: Dictionary) -> Dictionary`
  ({"inv": Array of PackedFloat32Array, "singular": bool}); cache the inverse on the solver Dictionary under "_inv".
- `Godot/tests/corrective_rbf_ue_test.gd` (NEW, extends SceneTree, preload CorrectiveRBF.gd only; no assets, no LFS).
  Prints `CORRECTIVE_RBF_UE failures=<n>` last; quit(1) if n > 0. Checks (named FAIL lines):
  1. ue_kernel values: gaussian(0.5, 1.0) == exp(-0.5); exponential(0.5,1) == exp(-1); linear/cubic/quintic at d = r/2
     and d = r (0) - 1e-6.
  2. Interpolative EXACTNESS: a synthetic solver (5 swing targets: rest, 35/75/110 deg about local Z, 35 deg about Y; twist
     axis X; gaussian; radius = mean pairwise distance) queried AT each target gives that target weight >= 0.999 and every
     other <= 0.001 (the interpolation property - additive cannot do this with a wide kernel; show it in the PR).
  3. Normalise "always": weights sum to 1 (1e-5) over a 300-step sweep 0..110 deg; "above_one" sum <= 1 + 1e-5.
  4. Threshold: a weight that lands at 0.0005 with threshold 0.001 becomes exactly 0.
  5. Continuity over the sweep: no output step > 0.004 m or > 2 deg (outputs as in MHRBF1's synthetic helper).
  6. Singular A (two identical targets) -> no NaN, "singular" reported, falls back to additive, weights finite.
  7. Legacy: a table without solver_type gives byte-identical weights to master's `weights()` (copy master's function into
     the test as `_legacy_weights` and compare 200 seeded queries).
  8. Real-data smoke WITHOUT files: paste ONE solver literal into the test (the `lowerarm_l_UERBFSolver` driver_q list and
     radius from `Godot/assets/data/mh_correctives_boxer01.json` - 9 targets) and check property 2 on it.
- Mutant proof (PR body): (a) gaussian with d squared -> red; (b) skip the A^-1 solve (use phi directly) -> red on check 2.

## Contract
OWNS: Godot/scripts/rules/CorrectiveRBF.gd, Godot/tests/corrective_rbf_ue_test.gd
RED_TEST: Godot/tests/corrective_rbf_ue_test.gd -> CORRECTIVE_RBF_UE failures=0
REGRESSION: corrective_rbf_test, corrective_rbf_ue_test
VISUAL: no - pure math; Claude wires it into MetaHumanRig and takes the game-camera stills.

## Run
- Parse: `python Godot/tools/check_scripts.py Godot/scripts/rules/CorrectiveRBF.gd Godot/tests/corrective_rbf_ue_test.gd`
- `python Godot/tools/run_tests.py --jobs 2 --only corrective_rbf_test,corrective_rbf_ue_test`
- On master the new test must FAIL (ue_kernel missing). PR body: `RESULT: tests/corrective_rbf_ue_test.gd -> CORRECTIVE_RBF_UE failures=0`,
  `RESULT: tests/corrective_rbf_test.gd -> CORRECTIVE_RBF failures=0`, the master red line, both mutant red lines.
- Never delete, loosen or re-threshold a test.

## Prior research
research/ASK_MHCORR_JOHN_S262_JOHN.md (John: route A, OpenRigLogic formulas Q4), TASK_MHRBF1.md (the module's first
version), Tools/mh_corrective_table.py header (how the table fields map to the DNA), S263 commit 02c314c2.

## What would a human do?
A technical animator porting a MetaHuman to another engine copies RigLogic's solver one-to-one (it is MIT) and checks that
each authored pose comes back exactly when the arm is put in that pose - the interpolation property.

## Prefab check
OpenRigLogic (MIT, C++) is the reference; no GDScript port exists on the Asset Library or GitHub; we port the RBF part only.

## VISUAL GATE
Not a visual task: pure math + unit test. The visual close (elbow/shoulder/scapula stills on the fight camera, guard AND
mid-punch, red on the shipped tree first) is Claude's when the module is wired into MetaHumanRig.
