# TASK ANIMC224A - the C224 inside-uppercut gate as pure geometry + blind test

Model: Qwen (cloud seat, issue label `qwen`). Repo ICOON-Studio/FightCamp, branch qwen/issue-<n>, PR into master; never merge.
Approved: operator board Q-S204-1 (Ludo r38 s6.3: a gate that would have caught boxing_inside_uppercut swinging OVER the
opponent's head at chest-to-chest range; that move stays out of the demo until it passes).

## Spec - NEW `Godot/scripts/animation/UppercutGate.gd` (`extends RefCounted`, `class_name UppercutGate`, static funcs, PURE: no
preload/load, GameState, Node, Skeleton3D, files or randomness).
Input: `frames: Array` of Dictionaries, one per sampled frame of the attacker's strike, each {"t": float seconds,
"shoulder": Vector3, "elbow": Vector3, "hand": Vector3, "opp_crown": Vector3, "opp_chin": Vector3, "opp_pelvis": Vector3,
"att_pelvis": Vector3} (world space, Y up), plus `contact_t: float` (the clip's contact time).
1. `static func elbow_angle_deg(shoulder: Vector3, elbow: Vector3, hand: Vector3) -> float` - interior angle, 180 = straight arm.
2. `static func evaluate(frames: Array, contact_t: float) -> Dictionary` -> {"pass": bool, "reasons": Array of Strings,
   "elbow_at_contact_deg", "glove_peak_above_crown_m", "pelvis_gap_m", "hand_to_chin_at_contact_m"}. FAIL reasons:
   "over_the_head" when the hand ever rises above opp_crown.y (peak > 0.0); "elbow" when the elbow angle at the frame nearest
   contact_t is outside [82, 98] degrees (Ludo); "miss" when the hand at contact is more than 0.12 m from opp_chin;
   "range" when the XZ pelvis gap at contact is outside [0.9, 1.1] m (this gate is only for inside range).
   Empty frames -> pass false, reasons ["no_frames"].

## Test - NEW `Godot/tests/uppercut_gate_test.gd` (SceneTree `_initialize()`, prints `UPPERCUT_GATE total=N fails=M`, quit(1) on
fail, `const UppercutGate = preload("res://scripts/animation/UppercutGate.gd")`). Blind, from this contract. Literal frame
tables for TWO DIFFERENT pairs (attacker 1.70 m vs opponent 1.85 m, and attacker 1.85 m vs opponent 1.72 m): a GOOD inside
uppercut (elbow ~90 deg, hand rises inside the guard to the chin) passes; today's BAD one (arm swings up over the crown) fails
with "over_the_head"; a straight-arm one fails "elbow"; one that stops 20 cm short fails "miss"; pelvis gap 1.4 m fails
"range"; elbow_angle_deg exact for a right angle and a straight arm; inputs not mutated; an inline MUTANT (the crown check
loosened to "> 0.05 m") lets the bad uppercut pass, so one of your checks must fail on it; a source scan of UppercutGate.gd for
preload / load( / GameState / randf / randi / Skeleton3D / FileAccess (must be absent).

## Owned files
The two new files only.

## Gate
`python Godot/tools/check_scripts.py <both files>`, then `godot --headless --path Godot --script tests/uppercut_gate_test.gd`
-> fails=0; CI green on the PR. GDScript 4 syntax: `const` (never `static const`), `for x in arr`, `dict.has()`,
`_initialize()` in SceneTree tests. Never delete or shrink a test. No LFS models.

## Prior research
research/LUDO_ROUND38_S204_reply2.txt lines 320-461 (Ludo's diagnosis of the bad clip + his C224 test draft).

## What would a human do?
Turn the animation reviewer's rule ("the glove never goes over his head, the elbow stays bent") into a number check.

## Prefab check
None - 80 lines of vector maths.

## The one trap
"Over the head" is a HEIGHT test (y), not a distance test - a hand can be far from the crown and still be above it.
