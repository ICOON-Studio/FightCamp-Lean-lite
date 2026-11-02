# TASK MHRBF1 - MetaHuman corrective joints from a sampled table: the RBF playback module (S262)
Model: Arena default (cloud). Discipline: boxing = demo.
Repo: ICOON-Studio/FightCamp, branch off master. Never Arena's "Merge PR" button; Claude merges.

## Why
Operator S262: "the MH models do not look very nice or real". In Unreal a MetaHuman body drives its helper joints
(lowerarm_bck/fwd/in/out, upperarm_bicep/tricep, clavicle_out/scap...) with RBF pose drivers: the elbow bends, the helpers
move, the skin keeps its volume. Godot imports the helpers but nothing drives them (S261 drives four with a guess), so elbows
pinch and shoulders collapse. Claude will SAMPLE Unreal (UE 5.8 headless): pose the driver joints on a grid, record every
helper's local transform -> a JSON table. YOUR job: the pure module that plays that table back in Godot, with a test.

## Build: `Godot/scripts/rules/CorrectiveRBF.gd` (NEW, extends RefCounted, pure, ZERO preloads, every input passed in)
Table format (JSON-able Dictionary; the module never reads files):
```
{"version": 1, "solvers": [ {
   "name": "elbow_l", "driver": "lowerarm_l",            # driver joint (its LOCAL rotation is the input)
   "distance": "quat" | "swing" | "twist",               # how two driver rotations are compared (UE FRBFSolver)
   "twist_axis": [1,0,0],                                 # bone-local axis for swing/twist split
   "function": "gaussian",                                # gaussian | linear | cubic | quintic | exponential
   "radius_deg": 40.0,                                    # kernel width
   "samples": [ {"driver_q": [x,y,z,w],                  # driver local rotation at this sample
                 "outputs": {"lowerarm_bck_l": {"t": [x,y,z], "q": [x,y,z,w]}, ...}} , ... ] } ] }
```
Functions (static):
1. `static func validate(table: Dictionary) -> Array` -> list of error strings ([] = valid): version, every solver has driver,
   >= 2 samples, unit quaternions (|q| within 1e-3 of 1), every sample has the same output joint set, radius > 0.
2. `static func distance(q_a: Quaternion, q_b: Quaternion, method: String, twist_axis: Vector3) -> float` (radians):
   quat = shortest angle between rotations (handle q and -q as the same rotation); swing = angle between the rotated
   twist axes; twist = |difference of twist angles about twist_axis| (swing-twist decomposition).
3. `static func kernel(d: float, radius: float, function: String) -> float`: gaussian exp(-(d/r)^2 ...) - document the exact
   formula you pick and keep kernel(0) == 1 and monotone non-increasing in d for every function.
4. `static func weights(table_solver: Dictionary, q: Quaternion) -> PackedFloat32Array`: per-sample weight, normalised to
   sum 1 (if all kernels are ~0, the nearest sample gets 1). A query EQUAL to a sample's driver_q gives that sample weight
   >= 0.99 when samples are at least radius apart.
5. `static func evaluate(table_solver: Dictionary, q: Quaternion) -> Dictionary` -> {joint: {"t": Vector3, "q": Quaternion}}:
   translations blended linearly by weight; rotations blended by weighted quaternion average (sign-align to the first,
   normalise) - not chained slerps.
6. `static func evaluate_all(table: Dictionary, driver_rotations: Dictionary) -> Dictionary`: every solver whose driver is in
   driver_rotations; later solvers never overwrite an output joint an earlier solver set (first wins) - report the clash
   in a returned "_clashes" array instead.

## Test: `Godot/tests/corrective_rbf_test.gd` (NEW, extends SceneTree, pure: preload CorrectiveRBF.gd only, no assets/LFS)
Prints `CORRECTIVE_RBF failures=<n>` last; quit(1) if n > 0. Build a synthetic table in the test: driver = elbow flex about
the bone-local X axis at 0/45/90/135 deg, output joint "helper" with t = (0, 0.01*k, 0) and q = rotation about Z by 10*k deg
(k = sample index). Checks (named FAIL lines):
- validate: the good table -> []; broken copies (missing driver, 1 sample, non-unit q, output sets differ, radius 0) -> each
  gives >= 1 error.
- At each sample's own driver_q: weight of that sample >= 0.99, output t/q within 1e-3 of the sample.
- Halfway (22.5 deg): t.y strictly between samples 0 and 1, q angle strictly between 0 and 10 deg; continuity: 200 steps
  0..135 deg, no step changes t by > 0.002 m or q by > 1 deg.
- q and -q queries give identical outputs (1e-6).
- swing vs twist: a pure twist about twist_axis has swing distance ~0 and twist distance = the angle; a pure swing the reverse.
- kernel(0) == 1 and non-increasing over 0..3r for every function name; unknown function -> treated as gaussian (documented).
- Far outside the samples (e.g. 179 deg about Y) -> weights still sum to 1, finite outputs.
- evaluate_all with two solvers writing the same joint -> first wins, "_clashes" lists it.
- Mutant proof (PR body only): drop the q/-q sign alignment -> red; skip normalisation -> red. Paste both red lines.

## Contract
OWNS: Godot/scripts/rules/CorrectiveRBF.gd, Godot/tests/corrective_rbf_test.gd
RED_TEST: Godot/tests/corrective_rbf_test.gd -> CORRECTIVE_RBF failures=0
REGRESSION: corrective_rbf_test
VISUAL: no - pure math; Claude samples Unreal, wires it into MetaHumanRig, takes the stills.

## Run
- Parse: `python Godot/tools/check_scripts.py Godot/scripts/rules/CorrectiveRBF.gd Godot/tests/corrective_rbf_test.gd`
- `python Godot/tools/run_tests.py --jobs 2 --only corrective_rbf_test`
- On master the test must FAIL (module missing). PR body: `RESULT: tests/corrective_rbf_test.gd -> CORRECTIVE_RBF failures=0`,
  the master red line, the two mutant red lines.

## Prior research
CODEX_GUARDPOSE_S262.md s6 "Skin collapse" (Epic RBF correctives; sample elbow 0/45/90/120/140 x roll -60/0/+60),
S261_DIGEST.md (four elbow helpers driven by a guess - MetaHumanCorrective.gd), MetaHumanTwist.gd (the twist joints we drive).
Unreal's FRBFSolver (Engine/Source/Runtime/AnimGraphRuntime/.../RBF) is the reference for distance methods and kernels.

## What would a human do?
A rigger in Unreal sets up pose drivers: "when the elbow is at 90 deg, move the back-of-elbow joint here". We copy what
Unreal's drivers output at many poses and blend between them - the same thing the RBF node does.

## Prefab check
No Godot RBF pose-driver addon on the Asset Library for 4.x that reads our format; UE's solver is C++ inside the engine.
A ~150-line pure module is cheaper than a port.

## The one trap
Weighted quaternion blending with q/-q sign flips gives a helper that spins 360 deg between two samples - align signs to the
first sample before summing. Never delete or loosen a test to go green (Claude reads the CI log).

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped clip: it must read RED on <the defect>; paste that number in your report.
2. Stills only via record_room.gd -- as_game + still_framing.gd save_if_framed: guard, contact frame, one between.
3. For every still report: gap between bodies / where each nose points / wrists in line / feet / the defect / which bodies.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.
