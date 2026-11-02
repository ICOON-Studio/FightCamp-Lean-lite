# TASK SHAPEGATE1 (S217) - punch-shape checks as one pure, tested maths module (Ludo round 50 bands)

Model: Arena (cloud, free). Repo ICOON-Studio/FightCamp, base `master`. Work on your own `arena/...` branch, open a PR, NEVER merge.

## Why
The CEO rejected an animated lead body hook: the two boxers' bodies overlapped, their heads looked away from each other and
their wrists were twisted - and every automatic check had passed it. Our lead designer (Ludo, round 50) gave exact acceptance
bands. We need ONE pure GDScript module that turns per-frame joint positions into those measurements, so every clip check and
the live game use the same maths. Pure = no scene, no Skeleton3D, no preloads, no autoloads: it takes Vector3s and Dictionaries.

## Do - new file `Godot/scripts/PunchShapeMath.gd` (`extends RefCounted`)
Godot is Y-up; the ground plane is XZ. All angles in degrees, all distances in metres.
```gdscript
static func ground_distance(a: Vector3, b: Vector3) -> float          # horizontal (XZ) distance, Y ignored
static func joint_angle_deg(a: Vector3, b: Vector3, c: Vector3) -> float   # interior angle at b between b->a and b->c (0..180)
static func elbow_flexion_deg(shoulder: Vector3, elbow: Vector3, wrist: Vector3) -> float  # 180 - joint_angle_deg; straight arm = 0
static func collinearity_deg(a: Vector3, b: Vector3, c: Vector3) -> float  # angle between (b-a) and (c-b); a straight line = 0
static func gaze_error_deg(head_pos: Vector3, head_forward: Vector3, target: Vector3) -> Dictionary
    # {"yaw": unsigned horizontal angle between head_forward and (target-head_pos) projected on XZ,
    #  "pitch": signed angle of head_forward above (+) / below (-) the horizontal plane}
static func lateral_offset(point: Vector3, line_from: Vector3, line_to: Vector3) -> float
    # signed horizontal distance of point from the XZ line from->to; + = LEFT of the direction from->to (looking along it, Y up)
static func line_yaw_deg(l: Vector3, r: Vector3, from: Vector3, to: Vector3) -> float
    # signed yaw (-180..180] of the horizontal shoulder line l->r relative to the horizontal reference from->to
static func check_frame(frame: Dictionary, bands: Dictionary) -> Array
    # frame keys (all Vector3, metres): "a_chest","b_chest","a_head","a_head_fwd","b_head","b_head_fwd",
    #   "a_lowerarm","a_hand","a_knuckle","a_shoulder","a_elbow"; any missing key -> that check is skipped (not failed).
    # bands: Dictionary, see BANDS below. Returns an Array of failure Dictionaries {"check": String, "value": float,
    #   "min": float, "max": float}; empty Array = frame passes.
const BANDS := {   # Ludo r50 contact-frame bands for the lead body hook (verdict LUDO_ROUND50_VERDICT_S217.md)
    "chest_distance": [0.495, 0.545],   # 52 +-2.5 cm, spine_03 to spine_03 horizontal
    "chest_distance_hard_min": 0.48,    # fail on any frame
    "a_gaze_yaw": [0.0, 8.0], "b_gaze_yaw": [0.0, 6.0],
    "a_gaze_pitch": [-16.0, -12.0],
    "wrist_line": [0.0, 2.5],           # collinearity a_lowerarm -> a_hand -> a_knuckle
    "elbow_flexion": [88.0, 94.0],
}
```
`check_frame` runs: chest_distance (ground_distance a_chest/b_chest vs the band AND the hard min), a_gaze_yaw/a_gaze_pitch
(target = b_chest), b_gaze_yaw (target = a_head), wrist_line, elbow_flexion. Guard every input: NaN/inf/zero-length vectors
never crash - a degenerate direction makes that check report value NAN and FAIL with a clear "check" name suffix "_degenerate".

## Test - new `Godot/tests/punch_shape_math_test.gd` (extends SceneTree; prints `PUNCH_SHAPE_MATH_TEST PASS (<n> checks)` or
FAIL lines; quit(0/1)). Blind, from this contract, with hand-built geometry:
1. ground_distance ignores Y; joint_angle 90 for an L; elbow_flexion 0 straight / 90 at a right angle; collinearity 0 on a line,
   ~45 for a 45-degree bend.
2. gaze: forward pointing straight at the target -> yaw 0; rotated 30 deg about Y -> yaw 30 (+-0.01); looking 14 deg down -> pitch -14.
3. lateral_offset: a point to the left of a +X line (Y up, looking along +X, left is -Z) is positive; on the line 0.
4. line_yaw: shoulder line parallel to the reference -> 0; rotated 42 deg -> 42 (sign as specified, check both signs).
5. check_frame: a hand-built frame that matches every band -> []; then one mutated frame per check (chest 0.45 m, head turned
   40 deg, wrist bent 10 deg, elbow straight) -> exactly that check fails; a frame with missing keys -> no crash, those skipped.
6. Degenerate: zero-length head_fwd -> "a_gaze_yaw_degenerate" failure, no crash.
At least 60 checks.

## Run (CI has Godot; pure, no LFS)
`python Godot/tools/check_scripts.py Godot/scripts/PunchShapeMath.gd Godot/tests/punch_shape_math_test.gd`
`godot --headless --path Godot --script tests/punch_shape_math_test.gd`

## Owned files
Godot/scripts/PunchShapeMath.gd (new), Godot/tests/punch_shape_math_test.gd (new). Touch nothing else.

## The one trap
GDScript: `abs()` on mixed types returns Variant - use `absf`; `Vector3.angle_to` returns radians; `signed_angle_to(to, axis)`
for signed yaw; a Variant from a Dictionary needs an explicit cast (`frame["a_chest"] as Vector3`). Never delete or loosen a
test to go green - the CI guard fails a deleted test and Claude reads the CI log.
