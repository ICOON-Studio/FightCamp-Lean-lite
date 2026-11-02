# TASK ANIMBALANCE1A - centre of mass + base of support maths (benchmark STEP 7), pure module + blind test

Model: Goose (cloud, long task). Repo ICOON-Studio/FightCamp, work on branch goose/issue-<n>, PR into master; never merge.
Approved: operator board Q-S204-1 "build it all with your corrections" (Ludo r38 plan). This is the PURE half of step 7; the
pose controller that uses it inside FightStagePlayer is a later task.

## What it is
Step 7 of our human-motion benchmark: during a slip the boxer's centre of mass must stay at least 3 cm inside the area his feet
cover. Today nothing measures it (the benchmark column `red_com_dist_to_bos_edge_m` is always 0.0).

## Spec - NEW `Godot/scripts/animation/BodyBalance.gd`, `extends RefCounted`, `class_name BodyBalance`, static funcs only
PURE: no preload/load, no GameState, no Node, no Skeleton3D, no file access, no randomness; never mutate an argument.
Input is plain data: `joints: Dictionary` bone name -> Vector3 world position (Mixamo-style names WITHOUT prefix: Hips, Spine,
Spine2, Neck, HeadTop_End, LeftArm, LeftForeArm, LeftHand, LeftHandMiddle3, RightArm, RightForeArm, RightHand,
RightHandMiddle3, LeftUpLeg, LeftLeg, LeftFoot, LeftToeBase, RightUpLeg, RightLeg, RightFoot, RightToeBase). Y is up; the
ground plane is XZ.
1. `const SEGMENTS` - Ludo r38 reply1 s3.1 table (research/LUDO_ROUND38_S204_reply1.txt lines 304-350; Dempster /
   de Leva): 16 segments {name, proximal, distal, mass_frac, com_frac}. CORRECTION: Ludo's mass percentages sum to 106.25 %,
   not 100 % - keep his relative values but NORMALISE them so the 16 fractions sum to exactly 1.0, and say so in a comment
   with the source (de Leva 1996, J Biomech 29(9)) and the raw sum.
2. `static func com(joints: Dictionary) -> Vector3` - mass-weighted mean of each segment's point proximal.lerp(distal, com_frac);
   a segment with a missing joint is skipped and the remaining fractions renormalised; no joints -> Vector3.ZERO.
3. `static func support_polygon(joints: Dictionary, left_planted: bool, right_planted: bool, pivot_right: bool = false) ->
   PackedVector2Array` - Ludo s3.2: each planted foot = 4 sole corners on XZ (heel at Foot, toe at ToeBase, half-width 4.5 cm
   perpendicular to heel->toe); double support = convex hull of both soles (counter-clockwise); single support = that sole;
   pivot_right = a 4.5 cm-radius 12-gon around RightToeBase (replaces the right sole). Neither planted -> empty.
4. `static func margin(point_xz: Vector2, polygon: PackedVector2Array) -> float` - signed distance to the nearest edge: positive
   inside, negative outside, -INF for an empty polygon.
5. `static func hip_correction(joints, left_planted, right_planted, min_margin_m := 0.03, max_shift_m := 0.06) -> Dictionary`
   -> {"shift": Vector2 (XZ, toward the polygon's centroid; the smallest shift that gives margin >= min_margin, capped at
   max_shift), "margin_before": float, "margin_after": float, "step_out": bool (true when even max_shift cannot reach
   min_margin - Ludo's "step out" fallback)}. Shifting the hips moves the CoM by shift * (pelvis + abdomen + thorax + head mass
   share) - write that ratio as a named constant with its derivation.

## Test - NEW `Godot/tests/body_balance_test.gd` (extends SceneTree, `_initialize()`, prints `BODY_BALANCE total=N fails=M`,
quit(1) on fail; `const BodyBalance = preload("res://scripts/animation/BodyBalance.gd")`). Written from THIS contract.
TWO DIFFERENT bodies as literal joint tables (never identical - one 1.68 m short-limbed, one 1.88 m long-limbed; boxing stance,
feet ~0.45 m apart, lead foot forward). Checks at least: fractions sum to 1.0 (1e-6); CoM of a symmetric T-pose lies on the
mid-line; CoM lies between the feet in stance for both bodies; hull convex + counter-clockwise; margin positive at the polygon
centroid, negative 10 cm outside, 0 on an edge (1e-6); single support smaller than double; pivot polygon radius 4.5 cm;
hip_correction: already-safe stance -> zero shift; CoM pushed 2 cm outside -> margin_after >= 0.03; CoM pushed 30 cm outside ->
step_out true; no argument mutated; an inline MUTANT (margin with the sign flipped) must fail a check; a source scan of
BodyBalance.gd for preload / load( / GameState / randf / randi / Skeleton3D / FileAccess (must be absent).

## Owned files
Godot/scripts/animation/BodyBalance.gd (new), Godot/tests/body_balance_test.gd (new). Nothing else.

## Gate
`python Godot/tools/check_scripts.py Godot/scripts/animation/BodyBalance.gd Godot/tests/body_balance_test.gd`, then
`godot --headless --path Godot --script tests/body_balance_test.gd` -> `BODY_BALANCE total=N fails=0`; CI green on the PR.
GDScript 4 syntax: `const` (never `static const`), `for x in arr` (never `for var x`), `dict.has()`, `is_empty()`, SceneTree
tests use `_initialize()`. Never delete or shrink an existing test. No LFS in CI - do not load models.

## Prior research
Ludo r38 reply1 s3 (segment table, support polygon, Ludo's BalanceCoMController draft - a starting spec, not code to paste);
LUDO_ROUND38_VERDICT_S204.md (our rules: two different bodies; nothing moves feet in a certified contact window).

## What would a human do?
Biomechanics labs compute CoM from segment tables and the stability margin to the support polygon - exactly this, as a library.

## Prefab check
No Godot addon computes anthropometric CoM; ~180 lines of maths.

## The one trap
Godot's Geometry2D.convex_hull returns a CLOSED hull (first point repeated) - drop the duplicate or every margin is off.
