**Use authored guard poses plus constrained two-bone IK.** Author the whole-body silhouette and arm roll; use IK to fit that pose to each boxer’s proportions and maintain glove clearance. Replacing wrist translations with IK should improve skeletal integrity, but IK alone cannot repair incorrect skin weights, missing corrective-joint behavior, or an incorrectly oriented glove.

This is a read-only analysis of `ASK_GUARDPOSE_S262.md`, `GuardPose.gd`, and the relevant `FightStagePlayer.gd` windows. No files were edited and no engine/render tests were run. Numerical recommendations below are **proposed authoring and acceptance values**, not measurements of the current MetaHuman meshes or established universal boxing standards.

**1. Two-bone IK, authored poses, and what shipped games establish**

Use three complementary layers:

| Layer | Owns |
|---|---|
| Authored style pose | Stance, shoulder placement, chest shape, chin tuck, elbow bend plane, forearm roll, fist orientation |
| Constrained arm IK | Wrist placement, proportion adaptation, small variations, face/body clearance |
| Deformation correction | Elbow volume, forearm twisting, shoulder/armpit shape |

Create one approved full-body reference pose per style first. Then author a few nearby variants—compact/open, relaxed/defensive—and interpolate within that style. Small procedural variation can produce many distinct guards from these references.

The immediate problem in the inspected code is more fundamental than a poor choice of wrist target:

- `FightStagePlayer.gd:130–136` translates a bone relative to its parent.
- Fatigue compensates wrist positions with that operation at lines 283–284.
- Guard lift translates the hands at lines 289–290.
- Glove springs translate them at lines 295–296.
- Strike clearance translates the guarding hand at line 4126.

**Moving `LeftHand` relative to `LeftLowerArm` changes the elbow-to-wrist segment vector and potentially its length.** That is not equivalent to bending an arm. A well-positioned wrist can therefore coexist with a stretched or distorted forearm.

`_tuck_elbow()` is more defensible: rotating the upper-arm subtree around the shoulder-to-wrist axis can swivel the elbow while preserving the wrist position. However, it preserves the chain it receives—including any preceding wrist translation—and does not solve deformation or forearm-roll constraints.

For the replacement, accumulate fatigue, guard height, breathing compensation, and glove spring into **effector targets**, then solve the arm once. Do not translate the hand afterward.

Public evidence supports authored motion, but not an exact claim about either game’s guard solver:

- Steel City Interactive describes capturing fighters’ movement and having animation teams process and apply that motion to the models. That supports a mocap/authored foundation for **Undisputed**; it does not disclose a head-relative guard IK implementation. [Steel City Interactive’s development account](https://blog.playstation.com/?p=396984)
- EA describes **Fight Night Champion** as using a refined physics-based animation system. That statement does not establish its elbow-pole algorithm, guard-pose representation, or blending weights. [EA’s announcement](https://news.ea.com/press-releases/press-releases-details/2010/CORRECTING-and-REPLACING-EA-to-Redefine-the-Sports-Gaming-Experience-with-Fight-Night-Champion/default.aspx)

The hybrid recommendation is an engineering conclusion for FightCamp, not a claim to reproduce either proprietary implementation.

**2. Exact style numbers and their limits**

First distinguish **wrist joint**, **glove center**, **knuckle surface**, and **face surface**. They are different locations. `GuardPose.gd` currently specifies wrist targets, despite comments sometimes describing them as glove positions.

Its coordinate tuple is `(forward, right, up)`. The origin is the Head bone, but forward is described as chest-facing. This is a **head-anchored torso frame**, not necessarily the Head bone’s rotated basis.

The exact current constants, converted to centimeters, are:

| Style | Rear wrist: forward/right/down | Lead wrist: forward/right/down | Rear/lead head distance before jitter/clamp |
|---|---:|---:|---:|
| Traditional | 15 / +8 / 16 | 24 / −7 / 15 | 23.35 / 29.15 cm |
| High guard | 15 / +7.5 / 15 | 26 / −6 / 9 | 22.50 / 28.16 cm |
| Peek-a-boo | 14 / +8.5 / 11 | 15 / −8.5 / 11 | 19.73 / 20.45 cm |
| Long guard | 16 / +7 / 16 | 38 / −4 / 16 | 23.69 / 41.42 cm |
| Philly shell | 14 / +8 / 14 | 18 / +2 / 52 | 21.35 / 55.06 cm |

These are reasonable **initial hypotheses**, not verified poses. In particular:

- Peek-a-boo’s rear constant is already inside the function’s 20 cm radius.
- The high-guard lead is 11 cm farther forward than its rear. That describes an asymmetric guard; it should not be assumed to produce two gloves close to the temples.
- A shell lead wrist at `+2 cm right` crosses the centerline. That is intentional only if the forearm lies cleanly across the torso.
- A 41 cm head-to-wrist distance is not inherently wrong for a long guard.
- The interpretation of “15 cm below Head” depends on the imported Head joint location and glove attachment transform.

**Recommended initial authoring envelope**

Keep the current wrist constants as candidate A so the comparison is attributable. Fit them to one reference body using these proposed constraints:

| Style | Lead/rear elbow skin gap from rib surface | Lead/rear upper-arm outward angle, front view | Lead/rear upper-arm forward angle, side view | Lead/rear elbow flexion |
|---|---|---|---|---|
| Traditional | 3–5 / 2–4 cm | 8–12° / 6–12° | 15–30° / 5–20° | 95–125° / 110–140° |
| High guard | 2–4 / 2–4 cm | 6–12° / 6–12° | 15–30° / 10–25° | 115–145° / 120–145° |
| Peek-a-boo | 1–3 / 1–3 cm | 4–10° / 4–10° | 10–25° / 10–25° | 120–145° / 120–145° |
| Long guard | 6–12 / 2–4 cm | 8–20° / 6–12° | 35–60° / 5–20° | 45–90° / 110–140° |
| Philly shell | 1–4 / 2–4 cm | −8–+8° / 6–12° | 5–20° / 5–20° | 70–110° / 110–140° |

Definitions matter:

- Front-view angle is signed outward flare from torso-down; a negative value means inward.
- Side-view angle is forward elevation from torso-down.
- Elbow flexion is **0° when straight**, increasing as the elbow bends.
- Rib gap is a **surface gap**, not elbow-joint-to-torso-center distance.
- These ranges are authoring preferences. They are not independent hard constraints that every wrist constant must satisfy simultaneously.

Given shoulder `S`, elbow `E`, wrist `W`, and orthonormal torso axes:

```gdscript
var upper := E - S
var fore := W - E

var flare_deg := rad_to_deg(
    atan2(upper.dot(outward), -upper.dot(up))
)
var forward_deg := rad_to_deg(
    atan2(upper.dot(forward), -upper.dot(up))
)
var elbow_flex_deg := rad_to_deg(
    acos(clampf(upper.normalized().dot(fore.normalized()), -1.0, 1.0))
)
var forearm_from_up_deg := rad_to_deg(
    acos(clampf(fore.normalized().dot(up), -1.0, 1.0))
)
```

For visual authoring, aim initially for forearm inclination from torso-up of:

| Style | Lead | Rear |
|---|---:|---:|
| Traditional | 15–40° | 5–25° |
| High guard | 5–30° | 5–20° |
| Peek-a-boo | 0–20° | 0–20° |
| Long guard | 45–85° | 5–25° |
| Philly shell | 65–100° | 5–25° |

The actual forearm angle must come from the solved geometry. Do not separately force it after choosing the shoulder, wrist, and elbow plane.

Proposed whole-body starting values:

| Style | Shoulder rise, lead/rear | Combined neck/head tuck | Torso forward lean | Pelvis lowering from upright stance |
|---|---:|---:|---:|---:|
| Traditional | 1.5 / 1 cm | 10° | 6° | 4 cm |
| High guard | 2.5 / 2 cm | 12° | 8° | 5 cm |
| Peek-a-boo | 2 / 2 cm | 14° | 10° | 8 cm |
| Long guard | 1.5 / 1 cm | 8° | 4° | 3 cm |
| Philly shell | 3 / 1 cm | 10° | 5° | 4 cm |

Shoulder rise and pelvis lowering are **measured outcomes of the pose**, not instructions to translate clavicle or pelvis bones independently of the rest of the body.

For all styles, start with wrist flexion/extension at **0°**, allow **±8°**, and allow radial/ulnar deviation of **±5°**. Use forearm roll and hand orientation to present the glove; do not obtain that appearance by sharply bending the wrist.

For final glove placement, use actual face landmarks:

- Traditional rear: jaw/cheek protection.
- High guard: glove bodies near the cheeks/temples, with a usable sightline.
- Peek-a-boo: paired, compact cheek protection.
- Long guard: forward lead hand, rear jaw protection.
- Shell: rear jaw protection, lead forearm across the torso, raised lead shoulder protecting the chin.

The toolkit’s classic-guard rule remains binding: do not raise the classic lead glove above the brow merely to satisfy an arbitrary wrist coordinate.

**3. Other bones and rotations**

A guard must involve the clavicles, thoracic spine, neck/head, forearm roll, hands, and the lower-body stance. Arm-only IK over an unrelated idle will retain that idle’s shoulder and torso character.

The following are proposed anatomical rotations relative to a calibrated upright reference, **not raw local XYZ Euler values**:

| Style | Clavicle elevation L/R | Clavicle protraction L/R | Thoracic curl | Neck flexion + Head flexion |
|---|---:|---:|---:|---:|
| Traditional | 4° / 3° | 8° / 6° | 4° | 4° + 6° |
| High guard | 7° / 6° | 10° / 10° | 6° | 5° + 7° |
| Peek-a-boo | 6° / 6° | 12° / 12° | 8° | 6° + 8° |
| Long guard | 4° / 3° | 12° / 6° | 3° | 3° + 5° |
| Philly shell | 9° / 3° | 12° / 6° | 5° | 4° + 6° |

Here L/R means orthodox lead/rear.

Distribute thoracic curl over the actual spine chain—for example **20% lower, 35% middle, 45% upper**—rather than applying it all at `UpperChest`. Keep torso lean separate from thoracic curl. Crouch requires coordinated hip/knee/ankle motion and planted feet; lowering the pelvis alone is insufficient.

For glove orientation, calibrate two local directions on each hand/glove:

- The outward normal of the striking knuckle surface.
- A secondary direction toward the thumb, fixing roll.

Then define a full target orientation. Proposed knuckle-face yaw offsets toward the centerline:

| Style | Lead/rear inward yaw |
|---|---:|
| Traditional | 15° / 25° |
| High guard | 10° / 15° |
| Peek-a-boo | 5° / 5° |
| Long guard | 0° / 25° |
| Philly shell | Authored across-body orientation / 25° |

Use **0° nominal knuckle-face pitch**, with **±10°** variation after checking the glove model. These are orientation targets, not wrist-bend commands. Shell lead orientation should be authored because the hand is across the abdomen and “face forward” is not a sufficient description.

Do not assign `Quaternion(Vector3.RIGHT, angle)` to every imported shoulder and expect anatomical flexion. Bone names do not establish local axes.

For a desired skeleton-space orientation, convert through the **current parent pose**:

```gdscript
static func set_skeleton_rotation(
        skel: Skeleton3D,
        bone: int,
        desired_global_q: Quaternion
) -> void:
    var parent := skel.get_bone_parent(bone)
    var parent_q := Quaternion.IDENTITY
    if parent >= 0:
        parent_q = skel.get_bone_global_pose(parent).basis \
            .orthonormalized().get_rotation_quaternion()

    skel.set_bone_pose_rotation(
        bone,
        (parent_q.inverse() * desired_global_q).normalized()
    )
```

This assumes a rig without nonuniform scale/shear. In Godot 4, the pose rotation is not a Godot-3-style delta that should automatically receive another multiplication by rest rotation. Preserve the calibrated rest orientation when constructing the desired pose, but do not apply it twice.

For southpaw, mirror positions, swap lead/rear roles, and use a calibrated rotation mirror. A reflection has negative determinant and cannot be converted directly into an ordinary rotation quaternion.

**4. Many variations that remain readable**

Use **persistent, correlated parameters**, not independent random joint rotations.

A practical initial space is:

| Parameter | Proposed range within an approved style |
|---|---:|
| Lead wrist forward offset | ±2 cm; long guard ±4 cm |
| Rear wrist forward offset | ±1 cm |
| Wrist sideways offset | ±1 cm per hand |
| Wrist height | ±1.5 cm |
| Elbow preferred swivel | ±5° |
| Clavicle protraction | ±3° |
| Shoulder elevation | ±2° |
| Chin tuck | ±3° |
| Torso lean | ±3° |
| Stance crouch | ±2 cm |
| Knuckle-face yaw | ±8° |
| Wrist flexion/deviation | Within the limits in question 2 |

Correlate those through a few meaningful controls:

- **Compactness:** hands closer, elbows closer, slightly more protraction.
- **Lead extension:** lead wrist forward, shoulder protraction up, elbow flexion down.
- **Defensive height:** hands higher, modest shoulder elevation and chin tuck.
- **Bladedness:** torso yaw and shoulder asymmetry together.
- **Relaxation:** modest hand lowering, reduced shoulder elevation, slightly more elbow opening.

Do not combine arbitrary extrema. Project each generated target back into a feasible set defined by reach, elbow angle, face clearance, and body clearance. If projection requires moving a nominal compact-guard target more than **3 cm**, reject that variant and fall back to an authored reference.

Current `GuardPose.pose()` behavior is exact:

- Forward/up jitter: **±2.2 cm**.
- Sideways jitter: **±1.1 cm**.
- Attribute lift at guard 20/50/80: **−9/0/+9 cm lead**, **−5.4/0/+5.4 cm rear**.
- Inputs below 20 or above 80 saturate.
- The radial clamp runs afterward, potentially changing multiple components.

That attribute lift is large enough to change the guard’s identity. For a proposed replacement, use a smaller presentation-only range:

```gdscript
var g := clampf((guard - 50.0) / 50.0, -1.0, 1.0)
var lead_height_m := 0.025 * g
var rear_height_m := 0.015 * g
```

This gives **±2.5 cm lead / ±1.5 cm rear** over 0–100. Changing the established attribute presentation contract needs an explicit implementation decision; these are recommendations, not changes made here.

Map attributes carefully:

- Guard skill: consistency and return accuracy, with limited height adjustment.
- Fatigue: temporary sag and slower recovery, applied as target changes.
- Reach/body shape: actual bone lengths and face/glove dimensions.
- Style/fight plan: selects an approved pose family.
- Aggression or other attributes: only if a mapping already exists or is accepted.

The current fallback `style_for()` can choose any of five styles from a hash, and counter/out-boxer plans can resolve to long guard or shell. That makes stylistically important decisions from an ID. Prefer an explicit saved style; use a seed for variation within it.

For deterministic identity, save the resulting parameters and a generator version. A hash-based generator does not guarantee distinct poses for every boxer.

To distinguish two boxers visibly, compare their neutral, body-normalized pose descriptors. A proposed minimum is either:

- **4 cm lead-extension difference**, or
- **3 cm guard-height difference**, or
- **8° torso-yaw difference**, or
- **4 cm crouch difference**.

If neither fighter has an explicit authored identity and they collide, select another valid variant once and save it. Never change a boxer’s guard simply because a different opponent entered the ring. Small wrist jitter alone will often disappear at the game camera.

**5. Guard → punch → guard without a pop**

Use **separate left/right guard weights and explicit punch phases**.

The current `guard_lift_weight()` moves one scalar toward zero over **0.12 seconds** whenever any strike is active. At 60 Hz that is approximately **0.1389 weight per frame**. Both elbow tucks share it. Therefore the non-punching arm loses tuck along with the punching arm.

Also, `_anim_pose_pass()` returns immediately during its locked window. That can abruptly remove corrections unless the visible result was already blended out. `_guard_hand_clearance_pass()` then operates separately and may introduce another discontinuity.

Proposed phase behavior:

| Phase | Punching arm guard weight | Non-punching arm guard weight |
|---|---:|---:|
| Idle | 1 | 1 |
| Preparation | Smooth 1 → 0 | 1 |
| Extension/contact | 0 | 1 |
| Early recovery | 0 | 1 |
| Final recovery | Smooth 0 → 1 | 1 |

Use measured clip events, including current playback speed. Starting timings for authoring:

- Release during the final **60–100 ms before extension**, nominal **80 ms**.
- Reach zero before the contact-critical interval.
- Reacquire over **120–180 ms**, nominal **160 ms**, after the hand has substantially retracted.
- Do not introduce a preparation delay into a strike that has none.

A quintic ease has zero first and second derivatives at the endpoints:

```gdscript
static func ease5(x: float) -> float:
    x = clampf(x, 0.0, 1.0)
    return x * x * x * (x * (x * 6.0 - 15.0) + 10.0)

static func guard_weight(
        t: float,
        release_start: float,
        release_end: float,
        return_start: float,
        return_end: float
) -> float:
    assert(release_start < release_end)
    assert(release_end <= return_start)
    assert(return_start < return_end)

    if t <= release_start:
        return 1.0
    if t < release_end:
        return 1.0 - ease5(
            (t - release_start) / (release_end - release_start)
        )
    if t <= return_start:
        return 0.0
    if t < return_end:
        return ease5(
            (t - return_start) / (return_end - return_start)
        )
    return 1.0
```

**A smooth weight is necessary but insufficient.** If the clip begins with its hand 15 cm from the visible guard, changing the clip can still pop. Preserve the previous final local rotations and use the existing inertial-join mechanism to reconcile the incoming clip with the shown pose. The inspected `_shown_rot` capture occurs before `_anim_pose_pass`; do not assume it already captures the final guard.

Blend local rotations with `slerp`; retain bone translations. Blending independently positioned shoulder/elbow/wrist points can break segment lengths.

For the guarding arm:

| Punch | Proposed non-punching-hand behavior |
|---|---|
| Jab | Rear remains at jaw/cheek; optionally 0–1 cm higher and 0–1 cm closer, subject to clearance |
| Cross | Lead protects cheek/temple; compact lead target may move 2–4 cm back and 0–2 cm up |
| Lead hook | Rear protects opposite jaw/temple; 0–2 cm higher, elbow stays near ribs |
| Rear hook | Lead protects opposite jaw/temple; same bounded adjustment |
| Lead uppercut | Rear stays at cheek; avoid rotating it into the face with the torso |
| Rear uppercut | Lead stays at cheek; do not let the uppercut’s body compression drag it down |

Long-guard and shell defensive-hand transitions need authored exceptions. Do not suddenly pull a shell’s low lead hand to a generic high-guard target just because the rear punches.

Use the head’s translated position but a controlled torso-facing frame. Full Head rotation inheritance can make the hands follow every nod or flinch; a fixed world target can make them slide away from the face during torso rotation.

Do not infer punch identity every frame from which wrist is farther from Head. The current fallback can switch hands during a crossing or return. Resolve and latch the effector from metadata for the action. If unknown, report it as unclassified and use a conservative authored fallback.

For combinations and interrupted recovery, start from current weights and current displayed pose. Never reset a weight directly to 0 or 1.

**6. Godot 4.7.2 and MetaHuman traps**

**Coordinate spaces and rest axes.** `get_bone_global_pose()` is skeleton-relative, not world-relative. Convert a world point using the skeleton transform’s affine inverse. Bone rest establishes the initial pose; local bone axes must be calibrated from the actual rig. [Godot Skeleton3D documentation](https://docs.godotengine.org/en/4.5/classes/class_skeleton3d.html)

For this project, retain its `_world_of(_skel)` abstraction where required; do not assume replacing it with a node property preserves hidden/off-tree behavior.

**Analytic IK edge cases.** `GuardPose.elbow_for()` currently has two concrete problems:

1. It clamps the scalar distance but does not return a correspondingly clamped wrist target. If the requested target is unreachable, the returned elbow does not necessarily have forearm length `b` to that original target.
2. Its fallback pole is also `DOWN`. If the shoulder-to-target direction is vertical and the pole is parallel, both projections can be zero. The computed elbow then loses its perpendicular component.

It also needs finite inputs, positive lengths, and elbow-flexion limits.

A safer mathematical core returns both the elbow and feasible wrist:

```gdscript
static func solve_arm_points(
        shoulder: Vector3,
        requested_wrist: Vector3,
        upper_len: float,
        fore_len: float,
        preferred_pole: Vector3,
        previous_bend: Vector3,
        previous_direction: Vector3,
        min_flex_deg: float = 15.0,
        max_flex_deg: float = 145.0
) -> Dictionary:
    if not shoulder.is_finite() or not requested_wrist.is_finite():
        return {}
    if not is_finite(upper_len) or not is_finite(fore_len):
        return {}
    if upper_len <= 0.001 or fore_len <= 0.001:
        return {}
    if min_flex_deg < 0.0 or max_flex_deg >= 180.0 \
            or min_flex_deg >= max_flex_deg:
        return {}

    var delta := requested_wrist - shoulder
    var direction := delta.normalized()

    if delta.length_squared() < 0.00000001:
        direction = previous_direction.normalized()
        if not direction.is_finite() \
                or direction.length_squared() < 0.5:
            direction = Vector3.FORWARD

    var a := upper_len
    var b := fore_len
    var aa_bb := a * a + b * b

    # Flexion is zero for a straight arm.
    var min_distance := sqrt(maxf(
        0.0, aa_bb + 2.0 * a * b * cos(deg_to_rad(max_flex_deg))
    ))
    var max_distance := sqrt(maxf(
        0.0, aa_bb + 2.0 * a * b * cos(deg_to_rad(min_flex_deg))
    ))
    var distance := clampf(delta.length(), min_distance, max_distance)
    var wrist := shoulder + direction * distance

    var bend := preferred_pole - direction * preferred_pole.dot(direction)
    if not bend.is_finite() or bend.length_squared() < 0.000001:
        bend = previous_bend - direction * previous_bend.dot(direction)

    if not bend.is_finite() or bend.length_squared() < 0.000001:
        var axis := Vector3.RIGHT
        if absf(direction.y) <= absf(direction.x) \
                and absf(direction.y) <= absf(direction.z):
            axis = Vector3.UP
        elif absf(direction.z) <= absf(direction.x) \
                and absf(direction.z) <= absf(direction.y):
            axis = Vector3.BACK
        bend = axis - direction * axis.dot(direction)

    bend = bend.normalized()

    var along := (a * a + distance * distance - b * b) \
        / (2.0 * distance)
    var height := sqrt(maxf(0.0, a * a - along * along))
    var elbow := shoulder + direction * along + bend * height

    return {
        "elbow": elbow,
        "wrist": wrist,
        "bend": bend,
        "direction": direction,
        "target_error_m": wrist.distance_to(requested_wrist)
    }
```

This is an unexecuted reference kernel, not a complete production solver. Collision constraints and bend-plane continuity still belong around it.

Use the authored elbow to obtain a pole preference:

```gdscript
var n := (target_wrist - shoulder).normalized()
var preferred := authored_elbow - shoulder
var bend := preferred - n * preferred.dot(n)
```

Near a singularity, retain the previous valid bend plane. Away from it, move toward the authored plane continuously. Do not simply flip any new pole to match the previous frame: that can prevent a deliberate transition between genuinely different poses.

The current `pole_fwd` and `pole_in` constants have no physical meaning until the caller defines their combination with torso axes and a down component. They cannot by themselves promise an elbow 3–5 cm from the ribs.

To apply the solution:

1. Start from the authored/current FK pose.
2. Rotate UpperArm so the current shoulder→elbow direction matches the solved direction.
3. Re-evaluate the chain.
4. Rotate LowerArm so elbow→wrist matches the solved wrist direction.
5. Apply calibrated hand orientation.
6. Evaluate twist/corrective joints.

Godot’s `Quaternion(from_direction, to_direction)` provides the shortest-arc rotation; normalized quaternions and `slerp` are appropriate for rotation interpolation. Near antiparallel vectors, choose a stable anatomical rotation axis rather than relying on an arbitrary roll result. [Godot 4.7 Quaternion documentation](https://docs.godotengine.org/en/4.7/classes/class_quaternion.html)

**Execution order.** Either architecture can work:

- Retain the current manual post-animation pass, with explicit restoration before the next sample and a single owner for the arm chain.
- Move the solve into `SkeletonModifier3D`, ordered after body posture and before deformation correction.

For a new modifier on the 4.7 API, use `_process_modification_with_delta(delta)`. Do not implement the solve twice in both callbacks. A modifier must be a child of `Skeleton3D`; modifier influence is applied by the skeleton. With per-arm weights implemented internally, keep the overall modifier influence at 1 to avoid multiplying the blend twice. [Godot 4.7 SkeletonModifier3D documentation](https://docs.godotengine.org/en/4.7/classes/class_skeletonmodifier3d.html)

Modifier results are applied and then restored as part of the skeleton pipeline. Capture final measurements through the appropriate completion signal; an ordinary `_process()` read may see a different stage. Order multiple modifiers deliberately. [Godot’s modifier design explanation](https://godotengine.org/article/design-of-the-skeleton-modifier-3d/)

A suitable ownership order is:

`animation → join blending → body posture → guard/contact arm solve → twist/correctives → final telemetry/skin`

The punching arm’s contact solver and guard solver must not both own it at full weight. `_inside_uppercut_pose_pass()` currently runs after clearance; include that last writer in the ownership audit.

**Additional current-code issues:**

- `_anim_pose_pass()` is called only if `anim_fatigue or anim_glove_spring`. Enabling elbow tuck or guard lift alone does not satisfy that outer condition.
- `_anim_strike_now` is refreshed inside that pass, although clearance depends on it separately.
- `elbow_swivel_deg()` accepts any flare `<= 12°`, including excessive negative inward flare.
- If no angle satisfies the threshold, it returns the smallest observed flare among searched candidates, not necessarily a valid anatomical pose.
- `GuardPose` uses a **20 cm** radial wrist floor; clearance uses **24 cm**. Layering them would systematically move several intended rear targets.
- Head-radius clearance neither proves glove/face separation nor prevents glove/torso penetration.

**Skin collapse.** MetaHuman corrective behavior is pose-dependent. Epic documents RBF systems that compare driver rotations with authored poses and produce corrective-joint outputs. Importing the helper bones does not, by itself, reproduce that evaluation. [Epic’s body-rig documentation](https://dev.epicgames.com/documentation/metahuman/metahuman-stylized-character-body-rig-editing)

Do not drive every helper with one fraction of elbow flexion. Preserve or reconstruct the relevant authored corrective behavior.

A bounded initial deformation sample set could use elbow flexion at **0°, 45°, 90°, 120°, 140°**, crossed with forearm roll at **−60°, 0°, +60°**. Those are sampling locations, not values to rotate corrective bones by. Each sample needs correct mesh deformation.

Without skin inspection, I cannot supply truthful rotations for `lowerarm_bck/fwd/in/out` or `upperarm_tricep/bicep`. They depend on the bind pose, hierarchy, and weights. Inventing those values would reproduce the current patching problem.

**7. Acceptance gate: geometry, motion, and the game camera**

No single camera measurement proves a 3D guard is correct. Use numerical skeletal/mesh checks plus the actual rendered silhouette.

Proposed static gates:

| Measurement | Proposed acceptance |
|---|---|
| Wrist error to feasible target at full IK weight | ≤5 mm |
| Upper-arm/forearm length change | ≤0.5% from calibrated length |
| Compact-guard target projection | ≤3 cm; otherwise reject variant |
| Traditional front-view elbow flare | Target 8–12°; approved variation 5–15° |
| Other style elbow angles | Their approved envelope from question 2 |
| Compact elbow-to-rib skin gap | Style-specific range, ±1 cm |
| Wrist flexion/extension | Within ±8° |
| Wrist radial/ulnar deviation | Within ±5° |
| Knuckle orientation error | ≤10° from authored target |
| Face/glove clearance | Nominal ≥5 mm surface gap; no visible penetration |
| Body/arm clearance | No penetration beyond 2 mm numerical tolerance |
| Solved data | Finite transforms, valid rotations, no pole flips |

Face and body clearance need calibrated proxy shapes or skinned geometry. A head-bone distance does not count as a surface measurement. A cheek-touching authored pose can use zero nominal gap, but must still have no visible intersection.

Proposed motion gates:

- Evaluate idle, jab, cross, lead/rear hook, lead/rear uppercut, combinations, interrupted recovery, and guard changes.
- Test both stances and representative body proportions.
- Replay at **30, 60, and 120 Hz**, comparing at equal animation timestamps.
- At equivalent timestamps, target wrist differences across frame rates should stay below **5 mm**, absent intentionally nondeterministic simulation.
- For neutral guard, constrain **added target jitter**, after subtracting body motion, to **≤2 mm per 60 Hz frame**.
- At an animation join, added discontinuity relative to the continuous trajectory should be **≤5 mm wrist position and ≤3° hand orientation**.
- During the punch contact window, the guard layer’s change to the striking wrist should be **≤2 mm and ≤1°** relative to the certified contact pose.
- For a compact guarding hand, target error during the other hand’s punch should stay **≤1 cm**. Test shell/long-guard transitions against their authored trajectories.
- Feet must retain the existing planted-foot contract; the toolkit’s stated **2 cm** slip gate should not be weakened for a better-looking upper body.

Do not apply an idle hand-speed cap to a punch. Measure discontinuity and added error separately from legitimate fast movement.

For the visible arm:

- Use the real gameplay camera and resolution, plus front, side, and three-quarter diagnostic views.
- Capture at idle, maximum preparation, extension, contact, mid-recovery, and settled guard.
- Require the shoulder→upper arm→elbow→forearm→glove contour to remain anatomically readable.
- Reject a pinched elbow, abrupt forearm-width discontinuity, corkscrew twist, detached-looking glove cuff, or glove embedded in the face even if wrist coordinates pass.
- Against an approved deformed reference at the same pose, a proposed automated warning threshold is **>15% loss of elbow cross-sectional area**. That is a diagnostic threshold, not a substitute for visual review.
- At gameplay scale, use projected error normalized by head height: settled target error should be **≤3% of projected head height**. If the head is too small for reliable measurement, use the diagnostic close-up.
- Confirm that the two fighters’ silhouette differences survive projection; numerical seed differences alone do not satisfy this.

Use the existing `move_shape_probe.gd`, `c223_guard_probe.gd`, hand-pop tooling, and framed-still workflow before introducing another harness. Final receipts should identify body, style, stance, seed, clip, timestamp, frame rate, camera, and whether values were captured before or after modifiers.

**The acceptance condition is an arm that preserves its chain and volume, a glove that clears the face and points correctly, and a guard that survives punch transitions in the final render. None of those outcomes has been demonstrated by this research-only review.**