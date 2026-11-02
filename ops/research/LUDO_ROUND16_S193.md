# LUDO ROUND 16 (S193, 2026-10-10) - boxing demo animation + presentation: 5 next flaws, referee, knockdowns, corner, camera, ring, gym

Operator S193 rule: one huge TEXT ONLY question covering wide roadmap areas, Ludo's follow-ups folded in. Ludo's length limit cuts each
answer (~24 k chars); "CONTINUE" sends follow (16b, 16c ...). Answers verbatim below (code fences added; LaTeX simplified).

## Round 16 - question (sent verbatim, abridged only where marked)
ROUND 16 - ONE BIG REQUEST for the boxing demo's animation and presentation. TEXT ONLY (no image). Number every section, be dense (tables +
typed GDScript 4.x + numbers), and if you run out of room stop at a section boundary and write "CONTINUE FROM SECTION n". Same constraints
as before: every feature is a game switch defaulting OFF; additive layers apply once per frame on the freshly sampled pose (base-pose
cache); bones via a rig map; pure maths in static RefCounted modules with test cases; every feature has a hard pass/fail threshold a script
can measure from the per-frame CSV, and a 1-line "what the player sees" reason.
Our files: FightRealtime.gd (20 Hz sim, emits events ...), FightStagePlayer.gd, FightAliveStance.gd, FightActiveRagdoll.gd,
FightCameraDirector.gd + FightCameraRig.gd, FightWorldLiveScreen.gd, BroadcastScorebug.gd, CornerBreak.gd, GymClub3D.gd, record_room.gd.
SECTION 1 - your 5 next flaws, each fully solved: 1.1 rope contact, 1.2 glove impact compression + wrist flex + shoulder recoil,
1.3 canvas footprints / scuffs, 1.4 finger curl and grip, 1.5 gaze breaks to the referee.
SECTION 2 - THE REFEREE as a third body (spacing, movement, clinch break, knockdown count, wave-off, hand raise).
SECTION 3 - KNOCKDOWNS AND GET-UPS (falls by hit type, active-ragdoll blend in/out, get-up stages, wobbly legs, neutral-corner walk).
SECTION 4 - THE CORNER BETWEEN ROUNDS (60 s) mapped to CornerBreak actions and tones.
SECTION 5 - CAMERA DIRECTOR + REPLAYS. SECTION 6 - RING PRESENTATION. SECTION 7 - GYM TRAINING ANIMATIONS + a living gym cheaply.
SECTION 8 - build order + what needs content + a 60 s presentation benchmark.

## Round 16 - Ludo's answer, part 1 (verbatim; stops inside 2.3 at the RefState enum)

SECTION 1 — The Next 5 Presentation Flaws
1.1 Rope Contact & Dynamic Deflection
Design & Physics

Standard ring ropes clip through fighter meshes when backed into corners or driven into the perimeter. A realistic ring requires 4 rope strands per side (Y = [0.41, 0.71, 1.02, 1.32] m) that deflect elastically when contacted by the boxer’s pelvis, back, or limbs. In return, the rope applies an equal and opposite penalty restoring force to the fighter's skeleton, preventing backward penetration past maximum elasticity while introducing dynamic torso lean.

```
       [POST] o=============================o [POST]
                         \       /  <-- Deflected Strand
                          \ [B] /   <-- Boxer Pelvis / Torso
```

The 4 ropes per edge are treated as discrete piecewise damped spring lines with anchor points pinned to the rigid corner ring turnbuckles.

Mathematical Formulation

Let each rope k ∈ {0, 1, 2, 3} on edge e ∈ {0, 1, 2, 3} have rest endpoints P0(e), P1(e) ∈ R³. For a fighter capsule segment j with centerline segment (A_j, B_j) and radius r_j, the closest points between the rope segment and the capsule line segment determine minimum distance d.

If d < r_j, penetration depth is δ = r_j - d along normal n.
The rope midpoint lateral displacement x_rope and restoring tension force F_rope are governed by:
F_rope = -k_rope x_rope - c_rope ẋ_rope
a_bone = (1/m_eff) Σ F_rope · n
Where:

k_rope = 4200.0 N/m (stiff steel core enclosed in vinyl padding)
c_rope = 180.0 N·s/m
Maximum displacement clamp: |x_rope| <= 0.38 m (safety limit before ring apron clearance).
Telemetry Thresholds
Pass/Fail Threshold: Maximum bone penetration depth behind rest rope line <= 0.035 m (measured on pelvis, spine_02, calf_l, calf_r).
Rope Deflection Metric: Max rope sag under 80 kg fighter back lean: >= 0.12 m and <= 0.38 m.
Player Perception: Boxer bodies bounce and deform against taut ring ropes rather than phasing through them like open air.
File Modifications
RopeSystem3D.gd: Procedural multi-strand cable simulation updating multi-mesh rope visuals.
FightPoseSolver.gd: Post-animation skeletal bone projection away from the ring boundary plane.
Typed GDScript Implementation
```
# RopePhysicsSolver.gd
class_name RopePhysicsSolver
extends RefCounted

const ROPE_HEIGHTS: Array[float] = [0.41, 0.71, 1.02, 1.32]
const STIFFNESS: float = 4200.0
const DAMPING: float = 180.0
const MAX_DEFLECTION: float = 0.38
const RING_HALF_WIDTH: float = 3.05 # 20ft ring inside ropes

static func solve_rope_displacement(
	bone_pos: Vector3,
	bone_radius: float,
	rope_idx: int,
	rope_side_axis: Vector3, # Unit normal pointing outside ring
	dt: float,
	current_disp: float,
	current_vel: float
) -> Dictionary:
	var rope_y: float = ROPE_HEIGHTS[clampi(rope_idx, 0, 3)]
	var y_dist: float = absf(bone_pos.y - rope_y)
	if y_dist > bone_radius:
		# Decay back to rest
		var spring_force: float = -STIFFNESS * current_disp - DAMPING * current_vel
		var next_vel: float = current_vel + spring_force * dt
		var next_disp: float = current_disp + next_vel * dt
		if absf(next_disp) < 0.001 and absf(next_vel) < 0.001:
			return {"displacement": 0.0, "velocity": 0.0, "bone_push": Vector3.ZERO}
		return {"displacement": next_disp, "velocity": next_vel, "bone_push": Vector3.ZERO}

	# Compute radial depth across perimeter boundary
	var radial_pos: float = bone_pos.dot(rope_side_axis)
	var penetration: float = (radial_pos + bone_radius) - RING_HALF_WIDTH
	var push_vec: Vector3 = Vector3.ZERO

	if penetration > 0.0:
		var target_disp: float = minf(penetration, MAX_DEFLECTION)
		var delta_disp: float = target_disp - current_disp
		var force: float = delta_disp * STIFFNESS - current_vel * DAMPING
		current_vel += force * dt
		current_disp = clampf(current_disp + current_vel * dt, 0.0, MAX_DEFLECTION)
		
		# Clamping offset to push the bone inside boundaries
		var excess_pen: float = maxf(0.0, penetration - MAX_DEFLECTION)
		push_vec = -rope_side_axis * (excess_pen + (penetration * 0.4))
	else:
		current_disp = lerpf(current_disp, 0.0, dt * 10.0)
		current_vel = lerpf(current_vel, 0.0, dt * 10.0)

	return {
		"displacement": current_disp,
		"velocity": current_vel,
		"bone_push": push_vec
	}

static func run_tests() -> bool:
	var res_out: Dictionary = solve_rope_displacement(Vector3(0, 1.0, 0), 0.2, 2, Vector3(0,0,1), 0.016, 0.0, 0.0)
	assert(res_out["displacement"] == 0.0, "Test Failed: Out-of-range displacement not zero")
	var res_hit: Dictionary = solve_rope_displacement(Vector3(0, 1.02, 3.10), 0.15, 2, Vector3(0,0,1), 0.016, 0.0, 0.0)
	assert(res_hit["displacement"] > 0.0, "Test Failed: Rope did not deflect on intrusion")
	assert(res_hit["bone_push"].z < 0.0, "Test Failed: Pushback vector did not orient inward")
	return true
```

1.2 Glove Impact Compression, Wrist Flexion, & Shoulder Recoil
Design & Physics

Rigid punch animations make impacts look like stiff plastic rods colliding with rocks. When an 8 oz or 10 oz leather glove hits a target:

The glove foam compresses along the impact normal vector (z-axis of fist).
The wrist joint passively absorbs kinetic shock, flexing backward (12° to 22°) into anatomical hyperextension before snapping back.
The shockwave propagates along the humerus, driving the clavicle and shoulder girdle backward into an additive recoil displacement.
Mathematical Formulation

Upon punch contact at time t0, impact energy E_k = ½ m_arm v_impact² generates:

Glove Compression: ΔL_glove(t) = C_max · exp(-(t - t0)/τ_foam) · sin(π (t - t0)/T_impact) Where C_max = 0.038 m (3.8 cm compression), τ_foam = 0.024 s, T_impact = 0.045 s.
Wrist Dorsiflexion (Rotational Spring): I_hand θ'' + c_wrist θ' + k_wrist θ = τ_impact Where k_wrist = 65.0 N·m/rad, peak flex θ_max ∈ [0.21, 0.38] rad.
Clavicle/Shoulder Linear Recoil: d_clavicle = -v_impact · M_recoil · exp(-(t - t0)/τ_clavicle) Where M_recoil = 0.022 s, max linear translation = 0.045 m.
Telemetry Thresholds
Pass/Fail Threshold: Contact compression along impact vector >= 0.018 m during window t ∈ [0, 35] ms post-impact.
Wrist Flex Threshold: Angular deflection on hand_l/hand_r >= 12.0° and <= 24.0°.
Player Perception: Punches connect with a heavy, elastic thud that squishes the glove and buckles the puncher's wrist rather than stopping abruptly.
File Modifications
FightAliveStance.gd: Evaluate additive wrist rotation and clavicle translation on attacker frame.
FightPoseSolver.gd: Apply glove mesh bone-scale compression.
Typed GDScript Implementation
```
# PunchImpactKinetics.gd
class_name PunchImpactKinetics
extends RefCounted

const FOAM_COMPRESSION_MAX: float = 0.038
const IMPACT_DURATION: float = 0.045
const FOAM_DECAY: float = 0.024
const SHOULDER_RECOIL_MAX: float = 0.045
const WRIST_FLEX_MAX_RAD: float = 0.35 # ~20 deg

static func compute_impact_deformation(
	elapsed_since_impact: float,
	impact_vel_mag: float,
	strike_dir_world: Vector3
) -> Dictionary:
	if elapsed_since_impact < 0.0 or elapsed_since_impact > IMPACT_DURATION * 2.0:
		return {
			"glove_scale_z": 1.0,
			"wrist_pitch_rad": 0.0,
			"clavicle_offset": Vector3.ZERO
		}

	var intensity: float = clampf(impact_vel_mag / 9.0, 0.4, 1.2)
	var t: float = elapsed_since_impact

	# Glove mesh foam squish factor along local forward axis
	var compression_factor: float = 0.0
	if t <= IMPACT_DURATION:
		var half_sine: float = sin((t / IMPACT_DURATION) * PI)
		var decay: float = exp(-t / FOAM_DECAY)
		compression_factor = FOAM_COMPRESSION_MAX * half_sine * decay * intensity
	var scale_z: float = clampf(1.0 - (compression_factor / 0.18), 0.72, 1.0)

	# Wrist flex spring curve
	var flex_curve: float = sin(clampf(t / (IMPACT_DURATION * 1.5), 0.0, 1.0) * PI)
	var wrist_rot: float = WRIST_FLEX_MAX_RAD * flex_curve * intensity

	# Shoulder linear recoil backwards
	var shoulder_disp: float = SHOULDER_RECOIL_MAX * exp(-t / 0.05) * intensity
	var clavicle_disp: Vector3 = -strike_dir_world * shoulder_disp

	return {
		"glove_scale_z": scale_z,
		"wrist_pitch_rad": wrist_rot,
		"clavicle_offset": clavicle_disp
	}

static func run_tests() -> bool:
	var res_mid: Dictionary = compute_impact_deformation(0.02, 8.5, Vector3(0, 0, 1))
	assert(res_mid["glove_scale_z"] < 0.98, "Test Failed: Glove did not compress")
	assert(res_mid["wrist_pitch_rad"] > 0.05, "Test Failed: Wrist did not flex")
	assert(res_mid["clavicle_offset"].z < 0.0, "Test Failed: Clavicle failed to recoil backward")
	return true
```

1.3 Canvas Footprints and Scuff Decals on Pivots
Design & Physics

Fighters constantly drag their balls-of-feet, pivot their rear feet when driving hooks, and push sweat and resin across the mat. A pristine, sterile blue/grey canvas looks synthetic.

When a foot's downward normal load exceeds 350 N while rotating at > 120°/s or sliding at linear velocities > 0.35 m/s, rubber friction leaves a transient scuff mark.
Sweat drops landing on the canvas darken the texture dynamically via a local decal instancer or a runtime texture-blend footprint canvas.
```
       [Foot Pivot Point]
              \
            (   ) <-- Arced Rubber Scuff Decal (Opacity ~ angular speed)
```

Mathematical Formulation

For foot f ∈ {lead, rear}:

Ground contact trigger: Y_foot <= Y_mat + 0.015 m.
Tangential sliding velocity: v_t = v_foot - (v_foot · n_mat) n_mat.
Angular yaw velocity: ω_y = |θ'_y|.
Scuff Intensity Factor: α_scuff = clamp((|v_t| - 0.35)/1.2 + (ω_y - 2.1)/5.0, 0.0, 1.0)
If α_scuff > 0.15 and distance traveled from last decal spawn > 0.08 m (or angular change > 15°), spawn a projected Quad/Decal with lifetime t_life = 45.0 s decaying through exponential fade: α(t) = α_init · exp(-t / 25.0)
Telemetry Thresholds
Pass/Fail Threshold: Maximum decal spawn latency <= 16.6 ms post ground-pivot condition.
Dynamic Scuff Density: A 3-minute aggressive round generates between 45 and 180 persistent mat scuff instances.
Player Perception: Ring surface shows visible wear, darkened canvas patches, and circular shoe friction burns around high-action zones.
File Modifications
CanvasWearManager.gd: Handles ring canvas decal pooling, sizing, and decay timers.
FightAliveStance.gd: Feeds foot contacts, linear slip, and yaw velocities to canvas manager.
Typed GDScript Implementation
```
# CanvasWearManager.gd
class_name CanvasWearManager
extends RefCounted

const MIN_SLIP_VEL: float = 0.35
const MIN_YAW_VEL: float = 2.094 # 120 deg/s in rad
const MAX_DECALS: int = 256

class ScuffMark:
	var pos: Vector3
	var rotation_y: float
	var alpha: float
	var scale: Vector2
	var age: float = 0.0

static func evaluate_foot_scuff(
	foot_pos: Vector3,
	foot_vel: Vector3,
	yaw_rate: float,
	is_grounded: bool,
	last_spawn_pos: Vector3
) -> Dictionary:
	if not is_grounded:
		return {"should_spawn": false, "intensity": 0.0}

	var planar_vel: float = Vector2(foot_vel.x, foot_vel.z).length()
	var dist_sq: float = foot_pos.distance_squared_to(last_spawn_pos)

	if dist_sq < (0.08 * 0.08):
		return {"should_spawn": false, "intensity": 0.0}

	var slip_over: float = maxf(0.0, planar_vel - MIN_SLIP_VEL) / 1.0
	var yaw_over: float = maxf(0.0, absf(yaw_rate) - MIN_YAW_VEL) / 5.0
	var intensity: float = clampf(slip_over + yaw_over, 0.0, 1.0)

	if intensity > 0.15:
		return {
			"should_spawn": true,
			"intensity": intensity,
			"position": Vector3(foot_pos.x, 0.002, foot_pos.z),
			"scale": Vector2(0.12, 0.24 * (1.0 + slip_over))
		}

	return {"should_spawn": false, "intensity": 0.0}

static func run_tests() -> bool:
	var rest_test: Dictionary = evaluate_foot_scuff(Vector3.ZERO, Vector3.ZERO, 0.0, true, Vector3(1,0,1))
	assert(rest_test["should_spawn"] == false, "Test Failed: Rest foot generated scuff")
	var hard_pivot: Dictionary = evaluate_foot_scuff(Vector3(0.5, 0, 0.5), Vector3(0.6, 0, 0), 4.5, true, Vector3.ZERO)
	assert(hard_pivot["should_spawn"] == true, "Test Failed: High-speed pivot failed to trigger scuff")
	return true
```

1.4 Finger Curl and Grip in Clinch & Glove Guards
Design & Physics

Boxing gloves do not permit individual finger splay, but the thumb and four-finger mitt block undergo variable curvature:

In resting guard, the mitt is semi-open (25% curled) to allow parrying.
In tight earmuff guard or during incoming impact, the hand compresses into a white-knuckle fist (100% curled).
In a clinch (collar tie, underhook, bicep tie), the thumb and fingers clamp down over the opponent's neck, triceps, or trapezius to form a hook shape.
```
   Open Palm / Parry:       Tight Fist Guard:        Clinch Wrap / Hook:
      [||||]                   [@@@@]                  //||\\
        \                        \                    ( ==== ) <-- Wrapped
```

Mathematical Formulation

Define glove curl factor C_glove ∈ [0.0, 1.0].

0.0: Relaxed / open mitt (parry window).
0.5: Resting boxing guard.
1.0: Clenched fist (punch launch or high-guard shell).
1.2: Clinch grip wrap (curl angle overdrive wrapping around a foreign limb mesh).

Rotation of proximal finger phalanx bones θ_finger:
θ_finger = θ_rest + C_glove · Δθ_clench
Where Δθ_clench = 70.0° (1.22 rad). Thumb undergoes oppositional yaw rotation θ_thumb = 45.0° · C_glove.

Telemetry Thresholds
Pass/Fail Threshold: Finger bones curl to >= 60.0° during clenched strikes; clamp around opponent limb radius <= 0.03 m during collar ties.
Guard Clench Latency: Clench transitions from open (0.2) to fist (1.0) in <= 80 ms upon detecting incoming punch trajectory.
Player Perception: Gloves do not look like static rigid spatulas; they tighten into fists on punches and wrap naturally over shoulders in clinches.
File Modifications
FightAliveStance.gd: Add finger curl solver overriding hand child bones (finger_proximal, finger_distal, thumb).
FightPoseSolver.gd: Inject clinch wrap curvature constraints.
Typed GDScript Implementation
```
# GloveGripSolver.gd
class_name GloveGripSolver
extends RefCounted

const REST_CURL_RAD: float = 0.26 # ~15 deg
const FULL_CLENCH_RAD: float = 1.22 # ~70 deg
const CLINCH_WRAP_RAD: float = 1.48 # ~85 deg

static func compute_finger_curl(
	target_mode: String, # "OPEN", "RESTING", "GUARD_SHELL", "STRIKE", "CLINCH_GRIP"
	current_curl: float,
	dt: float
) -> float:
	var target_curl: float = REST_CURL_RAD
	var lerp_speed: float = 14.0

	match target_mode:
		"OPEN":
			target_curl = 0.0
			lerp_speed = 18.0
		"RESTING":
			target_curl = REST_CURL_RAD
			lerp_speed = 8.0
		"GUARD_SHELL":
			target_curl = FULL_CLENCH_RAD * 0.85
			lerp_speed = 22.0
		"STRIKE":
			target_curl = FULL_CLENCH_RAD
			lerp_speed = 35.0
		"CLINCH_GRIP":
			target_curl = CLINCH_WRAP_RAD
			lerp_speed = 16.0

	return lerpf(current_curl, target_curl, clampf(dt * lerp_speed, 0.0, 1.0))

static func run_tests() -> bool:
	var c_strike: float = compute_finger_curl("STRIKE", 0.0, 0.1)
	assert(c_strike > 0.8, "Test Failed: Strike clench too sluggish")
	var c_open: float = compute_finger_curl("OPEN", 1.0, 0.1)
	assert(c_open < 0.3, "Test Failed: Finger extension did not release")
	return true
```

1.5 Gaze Breaks to the Referee at Stoppages and Breaks
Design & Physics

When the referee yells "Break!", waves their arms to stop action, or steps between fighters during a knockdown, fighters who continue staring blankly forward create a robotic impression.

The fighter's head and eye target vectors must interpolate from the opponent’s sternum/head to the referee's head bone.
The gaze shift initiates within 150 ms of the referee state trigger.
Saccadic motion snaps the eye vector first, followed by damped cervical rotation of the neck and head bones.
```
       [Opponent]
          \
           \  (Old Gaze Vector)
            \
     [Boxer Head] --------> [Referee] (New Snapped Gaze Vector)
```

Mathematical Formulation

Let P_head be the fighter's cranium bone position in world space.
Let P_opp be the opponent cranium, and P_ref be the referee cranium.
Target gaze point P_gaze(t) is a weighted blend:
P_target = (1.0 - w_ref) P_opp + w_ref P_ref
Where w_ref ∈ [0.0, 1.0] is driven by the sim event status:

If event is BREAK, KNOCKDOWN, ROUND_END, or STOPPAGE: w_ref → 1.0 at rate dw/dt = 6.5 s^-1.
Otherwise: w_ref → 0.0 at rate dw/dt = 4.0 s^-1.

Cervical look-at rotation quaternion Q_cervical is clamped:
Yaw ∈ [-65.0°, 65.0°], Pitch ∈ [-30.0°, 35.0°]

Telemetry Thresholds
Pass/Fail Threshold: Gaze tracking error angle to referee head <= 8.5° within 350 ms of a referee stoppage event.
Reversion Timing: Return gaze to opponent within 600 ms once referee signals "Box!".
Player Perception: Fighter looks at the referee the moment the ref intervenes or issues commands.
File Modifications
FightAliveStance.gd: Update neck/head look-at target logic in procedural additive pass.
FightRealtime.gd: Notify stance players of referee focus states.
Typed GDScript Implementation
```
# GazeAttentionDirector.gd
class_name GazeAttentionDirector
extends RefCounted

const BLEND_IN_SPEED: float = 6.5
const BLEND_OUT_SPEED: float = 4.0
const MAX_YAW_DEG: float = 65.0
const MAX_PITCH_DEG: float = 35.0

static func update_gaze_target(
	head_pos: Vector3,
	head_forward: Vector3,
	opponent_head_pos: Vector3,
	referee_head_pos: Vector3,
	referee_intervening: bool,
	current_weight: float,
	dt: float
) -> Dictionary:
	var target_w: float = 1.0 if referee_intervening else 0.0
	var speed: float = BLEND_IN_SPEED if referee_intervening else BLEND_OUT_SPEED
	var weight: float = move_toward(current_weight, target_w, dt * speed)

	var blended_target: Vector3 = opponent_head_pos.lerp(referee_head_pos, weight)
	var dir_to_target: Vector3 = (blended_target - head_pos).normalized()

	# Compute local yaw and pitch offsets
	var flat_forward: Vector2 = Vector2(head_forward.x, head_forward.z).normalized()
	var flat_target: Vector2 = Vector2(dir_to_target.x, dir_to_target.z).normalized()
	var yaw_angle_rad: float = flat_forward.angle_to(flat_target)
	var pitch_angle_rad: float = asin(clampf(dir_to_target.y, -1.0, 1.0))

	# Clamping
	yaw_angle_rad = clampf(yaw_angle_rad, -deg_to_rad(MAX_YAW_DEG), deg_to_rad(MAX_YAW_DEG))
	pitch_angle_rad = clampf(pitch_angle_rad, -deg_to_rad(MAX_PITCH_DEG), deg_to_rad(MAX_PITCH_DEG))

	return {
		"weight": weight,
		"clamped_target_pos": head_pos + (dir_to_target * 5.0),
		"yaw_offset_rad": yaw_angle_rad,
		"pitch_offset_rad": pitch_angle_rad
	}

static func run_tests() -> bool:
	var res: Dictionary = update_gaze_target(
		Vector3.ZERO, Vector3(0,0,1), Vector3(0,0,3), Vector3(2,0,2), true, 0.0, 0.1
	)
	assert(res["weight"] > 0.5, "Test Failed: Weight failed to ramp to referee")
	assert(res["yaw_offset_rad"] > 0.0, "Test Failed: Yaw failed to bias toward referee")
	return true
```

SECTION 2 — The Referee as a Third Body
```
               [FIGHTER BLUE]
                     |
       (1.8 - 2.8m)  |  (Action Axis)
                     |
               [FIGHTER RED]
                   /
                  /
                 / (Maintain triangle: 2.2 - 3.5m distance)
                v
          [REFEREE]
              |
              +--- MUST NOT CROSS Camera Visual Frustum
```

2.1 Referee Spatial Positioning Rules

The referee maintains a spatial triangle with the two combatants, enforcing three strict geometric constraints:

Safety Envelope: Keep a minimum radius of 2.0 m and maximum of 3.6 m from the two-fighter midpoint P_mid = ½(P_red + P_blue).
Camera Frustum Occlusion Prevention: The referee must never enter the visual cone between the broadcast camera and the fighters. If C is camera position, R is referee position, and F_i is a fighter position, the projection of R onto segment (C, P_mid) must maintain a perpendicular clearance distance: d_perp = |(R - C) × (P_mid - C)| / |P_mid - C| >= 1.40 m
Ring Boundary Clamping: Must stay strictly inside the ropes (X, Z ∈ [-2.6, 2.6] m).
2.2 Locomotion & State Machine
```
      +------------+        Clinch Trigger        +-----------------+
      |  CIRCLING  | ---------------------------> | BREAKING_CLINCH |
      +------------+                              +-----------------+
         ^        |                                     |
         |        | Action Stops                        | Action Resumes
         |        v                                     v
   +--------------------+     Knockdown Hit       +-----------------+
   | CORNER_SUPERVISION | <---------------------- | KNOCKDOWN_COUNT |
   +--------------------+                         +-----------------+
```

| State | Movement Type | Speed (m/s) | Hand Pose | Look-At Focus |
| :--- | :--- | :--- | :--- | :--- |
| CIRCLING | Lateral shuffle / arc glide | 0.6 - 1.4 | Low hands, fingers relaxed | Action center of fighters |
| BREAKING_CLINCH | Fast forward close-down | 2.8 - 3.8 | Open palms slicing between arms | Clinch grip intersection |
| KNOCKDOWN_COUNT | Wide squat stance | 0.0 | Visual finger counting chops | Downed fighter's eyes |
| CORNER_SUPERVISION| Backward perimeter escort| 1.2 - 1.8 | Palm out directing standing man | Standing fighter's chest |
| STOPPAGE_WAVE | Athletic lunge between | 2.5 | Crossing waving overhead arms | Victim's corner / camera |
| DECISION_RAISE | Static stand between | 0.0 | Gripping both fighters' wrists | Ring announcer / center |

2.3 State Timings, Numbers, & Thresholds
Clinch Intervention Reaction: Referee initiates movement within 0.40 s of a locked clinch condition persisting > 1.50 s.
Separation Force Execution: Applies outward repulsive force F_sep = 450.0 N to both fighters for 0.80 s until distance > 1.40 m.
Knockdown Count Interval: Exactly 1.000 s ± 0.015 s per count number, with hand chop apex landing at t = n × 1.000 s.
Telemetry Pass/Fail: Referee camera occlusion frames must equal 0 throughout any 60-second broadcast round sample (d_perp >= 1.40 m).
Typed GDScript Implementation
```
# RefereeController3D.gd
class_name RefereeController3D
extends RefCounted

enum RefState {
	CIRCLING,
	BREAKING_CLINCH,
	KNOCKDOWN_COUNT,
	CORNER_SUPERVISION,
	STOPPAGE_WAVE,
	DECISION_RAISE
}
```
(part 1 ends here - Ludo's output limit; 16b "CONTINUE" sent for the rest of 2, then 3-8)


## Round 16b - "CONTINUE" (sent): continue with the rest of SECTION 2, then SECTIONS 3-8 (same rules).

## Round 16b - Ludo's answer (verbatim, saved byte-exact from the page via Tools/arena_rx.py; LaTeX left as Ludo wrote it; stops inside SECTION 5)

Continuation of 2.3: Typed GDScript Referee Implementation
	var current_state: RefState = RefState.CIRCLING
	var ref_pos: Vector3 = Vector3(0.0, 0.0, 2.2)
	var ref_vel: Vector3 = Vector3.ZERO
	var current_count: int = 0
	var count_timer: float = 0.0
	var hand_chop_phase: float = 0.0
	var separation_timer: float = 0.0
	var winner_id: int = -1

	const RING_BOUNDS: float = 2.60
	const IDEAL_DIST_MIN: float = 2.00
	const IDEAL_DIST_MAX: float = 3.60
	const CAM_CLEARANCE_MIN: float = 1.40
	const COUNT_INTERVAL: float = 1.000
	const SEPARATION_FORCE: float = 450.0

	func update(
		dt: float,
		f1_pos: Vector3,
		f2_pos: Vector3,
		cam_pos: Vector3,
		sim_event: String,
		downed_fighter_pos: Vector3
	) -> Dictionary:
		var midpoint: Vector3 = (f1_pos + f2_pos) * 0.5
		var output: Dictionary = {
			"state": current_state,
			"pos": ref_pos,
			"look_at": midpoint,
			"count_num": current_count,
			"hand_l_target": Vector3.ZERO,
			"hand_r_target": Vector3.ZERO,
			"separation_force_f1": Vector3.ZERO,
			"separation_force_f2": Vector3.ZERO,
			"wave_off_alpha": 0.0,
			"raise_hand_alpha": 0.0
		}

		match current_state:
			RefState.CIRCLING:
				_update_circling(dt, midpoint, f1_pos, f2_pos, cam_pos)
				if sim_event == "CLINCH":
					current_state = RefState.BREAKING_CLINCH
					separation_timer = 0.0
				elif sim_event == "KNOCKDOWN":
					current_state = RefState.CORNER_SUPERVISION
					current_count = 0
					count_timer = 0.0
				elif sim_event == "STOPPAGE":
					current_state = RefState.STOPPAGE_WAVE
				elif sim_event == "DECISION":
					current_state = RefState.DECISION_RAISE

			RefState.BREAKING_CLINCH:
				separation_timer += dt
				var to_mid: Vector3 = midpoint - ref_pos
				to_mid.y = 0.0
				ref_pos += to_mid.normalized() * (3.2 * dt)
				output["look_at"] = midpoint

				# Hand placement: left palm to f1 shoulder, right palm to f2 shoulder
				var f_axis: Vector3 = (f2_pos - f1_pos).normalized()
				output["hand_l_target"] = midpoint - (f_axis * 0.35) + Vector3(0.0, 1.25, 0.0)
				output["hand_r_target"] = midpoint + (f_axis * 0.35) + Vector3(0.0, 1.25, 0.0)

				# Outward repulsive force
				output["separation_force_f1"] = -f_axis * SEPARATION_FORCE
				output["separation_force_f2"] = f_axis * SEPARATION_FORCE

				if separation_timer >= 0.80 and f1_pos.distance_to(f2_pos) > 1.40:
					current_state = RefState.CIRCLING

			RefState.CORNER_SUPERVISION:
				# Step toward standing fighter, point arm to neutral corner
				var standing_pos: Vector3 = f1_pos if f1_pos.distance_to(downed_fighter_pos) > 0.5 else f2_pos
				var to_standing: Vector3 = (standing_pos - ref_pos).normalized()
				to_standing.y = 0.0
				ref_pos += to_standing * (1.5 * dt)
				output["look_at"] = standing_pos
				output["hand_r_target"] = standing_pos + Vector3(0.0, 1.4, 0.0) # Pointing gesture

				if ref_pos.distance_to(standing_pos) < 2.0:
					current_state = RefState.KNOCKDOWN_COUNT

			RefState.KNOCKDOWN_COUNT:
				count_timer += dt
				output["look_at"] = downed_fighter_pos
				current_count = mini(10, int(count_timer / COUNT_INTERVAL) + 1)
				output["count_num"] = current_count

				# Hand count 1..10 timing: downward chop at each second apex
				var phase: float = fmod(count_timer, COUNT_INTERVAL) / COUNT_INTERVAL
				hand_chop_phase = sin(phase * PI)
				var count_hand_base: Vector3 = ref_pos + (ref_pos.direction_to(downed_fighter_pos) * 0.6)
				count_hand_base.y = 1.1 + (hand_chop_phase * 0.45)
				output["hand_r_target"] = count_hand_base

				if sim_event == "STAND_UP":
					current_state = RefState.CIRCLING
				elif current_count >= 10 or sim_event == "STOPPAGE":
					current_state = RefState.STOPPAGE_WAVE

			RefState.STOPPAGE_WAVE:
				count_timer += dt
				output["wave_off_alpha"] = 1.0
				# Overhead crossing arm wave at 2.2 Hz
				var wave_osc: float = sin(count_timer * 13.8) * 0.35
				output["hand_l_target"] = ref_pos + Vector3(-0.2 + wave_osc, 1.95, 0.4)
				output["hand_r_target"] = ref_pos + Vector3(0.2 - wave_osc, 1.95, 0.4)

			RefState.DECISION_RAISE:
				output["raise_hand_alpha"] = 1.0
				ref_pos = midpoint - Vector3(0.0, 0.0, 0.6) # Stand between fighters
				output["look_at"] = cam_pos
				output["hand_l_target"] = f1_pos + Vector3(0.0, 1.1, 0.0)
				output["hand_r_target"] = f2_pos + Vector3(0.0, 1.1, 0.0)
				if winner_id == 0:
					output["hand_l_target"] = f1_pos + Vector3(0.0, 2.05, 0.0) # Raised high
				elif winner_id == 1:
					output["hand_r_target"] = f2_pos + Vector3(0.0, 2.05, 0.0)

		# Clamp within inner ring canvas boundary
		ref_pos.x = clampf(ref_pos.x, -RING_BOUNDS, RING_BOUNDS)
		ref_pos.z = clampf(ref_pos.z, -RING_BOUNDS, RING_BOUNDS)
		ref_pos.y = 0.0
		output["pos"] = ref_pos
		return output

	func _update_circling(
		dt: float,
		midpoint: Vector3,
		f1_pos: Vector3,
		f2_pos: Vector3,
		cam_pos: Vector3
	) -> void:
		var dist_to_mid: float = ref_pos.distance_to(midpoint)
		var rad_dir: Vector3 = (ref_pos - midpoint).normalized()
		rad_dir.y = 0.0

		# Radial correction
		var radial_move: Vector3 = Vector3.ZERO
		if dist_to_mid < IDEAL_DIST_MIN:
			radial_move = rad_dir * (IDEAL_DIST_MIN - dist_to_mid) * 2.0
		elif dist_to_mid > IDEAL_DIST_MAX:
			radial_move = -rad_dir * (dist_to_mid - IDEAL_DIST_MAX) * 2.0

		# Tangential circling step
		var tangent: Vector3 = Vector3(-rad_dir.z, 0.0, rad_dir.x)
		var target_vel: Vector3 = (tangent * 0.9) + radial_move

		# Camera occlusion repulsion vector
		var cam_to_mid: Vector3 = midpoint - cam_pos
		cam_to_mid.y = 0.0
		var cam_axis: Vector3 = cam_to_mid.normalized()
		var ref_proj: Vector3 = cam_pos + cam_axis * ((ref_pos - cam_pos).dot(cam_axis))
		var perp_dist: float = ref_pos.distance_to(ref_proj)

		if perp_dist < CAM_CLEARANCE_MIN:
			var push_dir: Vector3 = (ref_pos - ref_proj).normalized()
			if push_dir.length_squared() < 0.01:
				push_dir = tangent
			target_vel += push_dir * (CAM_CLEARANCE_MIN - perp_dist) * 4.5

		ref_vel = ref_vel.lerp(target_vel, clampf(dt * 6.0, 0.0, 1.0))
		ref_pos += ref_vel * dt

static func run_tests() -> bool:
	var ref: RefereeController3D = RefereeController3D.new()
	var f1: Vector3 = Vector3(-1.0, 0.0, 0.0)
	var f2: Vector3 = Vector3(1.0, 0.0, 0.0)
	var cam: Vector3 = Vector3(0.0, 1.8, 6.0)

	# Test 1: Camera occlusion avoidance moves referee laterally
	ref.ref_pos = Vector3(0.0, 0.0, 3.0) # Directly on camera line
	var out1: Dictionary = ref.update(0.05, f1, f2, cam, "NONE", Vector3.ZERO)
	assert(absf(out1["pos"].x) > 0.0, "Test Failed: Ref did not step off camera line")

	# Test 2: Clinch generates separation force on both fighters
	var out2: Dictionary = ref.update(0.05, f1, f2, cam, "CLINCH", Vector3.ZERO)
	assert(out2["separation_force_f1"].length() > 0.0, "Test Failed: Missing clinch separation force")

	# Test 3: Knockdown count cadence exactly 1.0 s
	ref.current_state = RefState.KNOCKDOWN_COUNT
	ref.count_timer = 2.01
	var out3: Dictionary = ref.update(0.01, f1, f2, cam, "NONE", f1)
	assert(out3["count_num"] == 3, "Test Failed: Count index mismatch at 2.01s")
	return true

SECTION 3 — Knockdowns and Get-Ups
3.1 Knockdown Classification & Trajectory Profiles
FLASH KD:       [H1] ------------> (Elastic Pelvis Rebound) ------> Stumble / Kneel
BODY CRUMPLE:   [H2] (Solar Plexus) \
                                     +---> (Delayed 0.4s) -> Abdominal Fold -> Pelvis Drop
ACCUMULATED:    [H3] (Legs Turn to Rubber) ----> Asymmetric Knee Buckle -> Lateral Fall
FACE-FIRST:     [H4] (Complete Decerebrate) ---> Rigid Spine -> Forward Plunge -> Canvas Impact


| KD Type | Trigger Conditions | Initial Linear Vel ($X,Z$) | Initial Angular Vel ($\omega$) | Physics Blend Delay | Stumble Steps |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Flash KD | Counter hit, Chin $\ge 65$, Power $\ge 70$ | $3.4\text{ m/s}$ backward | $1.2\text{ rad/s}$ pitch | $0.08\text{ s}$ | $1 - 2$ steps backward |
| Accumulated | Groggy status, 3+ clean head shots | $1.1\text{ m/s}$ lateral | $2.8\text{ rad/s}$ roll | $0.22\text{ s}$ | $0$ (knees collapse outward) |
| Body Crumple | Clean liver shot / solar plexus hook | $0.4\text{ m/s}$ forward | $0.8\text{ rad/s}$ forward pitch | $0.45\text{ s}$ (delayed reaction) | $1$ step forward, drop to both knees |
| Face-First KO | Chin $< 20$, Crit flush punch | $2.2\text{ m/s}$ forward | $0.4\text{ rad/s}$ pitch | $0.00\text{ s}$ (instant ragdoll) | $0$ (stiff drop, zero bracing) |

3.2 Active-Ragdoll Transition Architecture
ANIMATED CLIP  -->  [BLEND-IN: 0.0 - 0.25s]  -->  FULL RAGDOLL  -->  [SETTLE CHECK]
(Pre-impact)        PD-Controller Drives Bones    (60 Hz Godot)       Linear Vel < 0.08 m/s
                                                                            |
RECOVERY CLIP  <--  [BLEND-OUT: 0.35s]        <--  MATCHED POSE   <---------+
(Roll / Kneel)      Inertialization Spring        (Root Anchored to Canvas)

Blend-In Window ($0.0\text{ s} \to 0.25\text{ s}$): Physical bone capsules inherit animated bone velocities. A proportional-derivative (PD) drive smoothly drops skeletal muscle torque: $$\tau = k_p (\theta_{\text{target}} - \theta_{\text{current}}) - k_d \dot{\theta}$$ Where $k_p$ drops from $800.0\text{ N}\cdot\text{m/rad}$ to $0.0$ over $250\text{ ms}$; $k_d$ increases from $40.0$ to $120.0\text{ N}\cdot\text{s/rad}$ (flaccid joint damping).
Impact & Canvas Rest: Body reaches static equilibrium when the linear velocity of pelvis, head, and chest remains $< 0.08\text{ m/s}$ for $> 0.30\text{ s}$.
Blend-Out Window ($0.35\text{ s}$):
The ragdoll's dynamic world transform of pelvis is copied to the kinematic node root.
The closest recovery animation clip is selected based on resting surface normal:
Prone ($\text{facing down}$) $\to$ kd_recover_prone
Supine ($\text{facing up}$) $\to$ kd_recover_supine
Lateral ($\text{side}$) $\to$ kd_recover_side_roll
Bones blend from ragdoll poses to clip keyframes via quintic hermite inertialization smoothing to prevent visual pops.
3.3 Get-Up Sequence Stages
[REST ON CANVAS] 
       |
       v  (Count 1 - 4: Unresponsive / Agonal Breaths)
[STAGE 1: ROLL TO BELLY] (Duration: 1.20 s)
       |
       v  (Count 5 - 6: Postural Orientation)
[STAGE 2: QUADRUPED / KNEE] (Duration: 1.45 s)
       |
       v  (Count 7 - 8: Weight Transfer to Soles / Rope Push)
[STAGE 3: BIPEDAL STAGGER STAND] (Duration: 0.95 s)
       |
       v  (Count 9: Erect, Guard Checked by Ref)
[STAGE 4: WOBBLY LEGS RECOVERY] (Duration: 3.50 - 8.00 s)

Stage 1 (Roll to Belly): Head lifts, hands plant flat beneath shoulders ($Y=0$). Pelvis rotates around the long axis to align torso normal with $[0, 1, 0]$.
Stage 2 (Quadruped / Single Knee): Pushes upper torso off ground; dominant knee slides forward beneath hip socket ($Z_{\text{knee}} \approx Z_{\text{pelvis}}$). Hand rests on the forward thigh or reaches outward for ring ropes.
Stage 3 (Bipedal Stagger Stand): Head elevates past $1.35\text{ m}$. Pelvis rises with lateral wobble. Hands peel away from canvas. Feet step wide to establish an enlarged base of support ($0.75\text{ m}$ stance width vs normal $0.55\text{ m}$).
Stage 4 (Wobbly Legs Stagger): Procedural ataxia layer active for $T_{\text{wobble}} = (100 - \text{Composure}) \times 0.08\text{ s}$.
3.4 Procedural Wobbly Legs & Ataxia Implementation
          [Target Stance Pelvis]
                    |
    (Noise Sway)    |     (Periodic Knee Buckle: Frequency 1.4 Hz)
       <---------[PELVIS]--------->
                 /     \
    (Buckle L)  /       \ (Buckle R)
               v         v
            [KNEE_L]  [KNEE_R]   <-- Drop Y by 0.08 - 0.16m on buckle trigger


During ataxia:

Low-Frequency Pelvis Sway: Multi-octave Perlin drift displacing pelvis horizontally by up to $\pm 0.14\text{ m}$.
Knee Buckle Events: Randomly triggers knee flexion drops ($\Delta Y = -0.12\text{ m}$) on alternating legs at cadence $f = 1.2 - 1.8\text{ Hz}$.
Stagger Steps: If Center of Mass (CoM) projects outside the foot convex hull, a reflexive rapid shuffle step triggers ($0.22\text{ s}$ duration) to regain balance.
3.5 Neutral-Corner Walk of the Standing Boxer

Upon confirmation of a knockdown:

Standing boxer's current animation cancels into an alert disengagement turn ($0.25\text{ s}$).
Pathfinding assigns a target to the farthest unoccupied neutral corner turnbuckle ($(\pm 2.8, 0, \pm 2.8)\text{ m}$).
Locomotion: Walking speed $1.45\text{ m/s}$ with high chest, gloves dropped to collar level, head turned over shoulder tracking the downed opponent every $1.2\text{ s}$ (duration: $0.6\text{ s}$).
Corner Arrival: Boxers place both gloved hands on adjacent top ropes, face inward toward the referee, and hold until the referee releases the bout.
3.6 Telemetry Thresholds
Pass/Fail Threshold: Zero foot-sliding during get-up phases ($V_{\text{plant_foot}} < 0.03\text{ m/s}$ while vertical ground normal force $> 200\text{ N}$).
Pose Blend Metric: No joint angular velocity discontinuity $> 35.0^{\circ}/\text{s}^2$ across ragdoll-to-clip transition boundary.
Player Perception: Fighter falls cleanly based on where he was hit, crawls up realistically, displays jelly-legs upon rising, and is not teleported or snapped between ragdoll and keyframes.
# KnockdownKineticsSolver.gd
class_name KnockdownKineticsSolver
extends RefCounted

const ATX_FREQ: float = 1.4
const MAX_SWAY_M: float = 0.14
const BUCKLE_DROP_M: float = 0.12

static func evaluate_ataxia(
	elapsed: float,
	composure: float,
	pelvis_base: Vector3,
	dt: float
) -> Dictionary:
	var intensity: float = clampf((65.0 - composure) / 65.0, 0.0, 1.0)
	if intensity <= 0.0:
		return {
			"pelvis_offset": Vector3.ZERO,
			"knee_buckle_l": 0.0,
			"knee_buckle_r": 0.0,
			"stagger_step_required": false
		}

	# Procedural sway using trigonometric harmonic sum
	var sway_x: float = (sin(elapsed * 2.1) + sin(elapsed * 0.77)) * 0.5 * MAX_SWAY_M * intensity
	var sway_z: float = (cos(elapsed * 1.8) + cos(elapsed * 0.93)) * 0.5 * (MAX_SWAY_M * 0.7) * intensity

	# Periodic knee buckling
	var buckle_cycle: float = fmod(elapsed * ATX_FREQ, 1.0)
	var buckle_l: float = 0.0
	var buckle_r: float = 0.0

	if buckle_cycle < 0.25:
		var u: float = sin((buckle_cycle / 0.25) * PI)
		buckle_l = BUCKLE_DROP_M * u * intensity
	elif buckle_cycle > 0.50 and buckle_cycle < 0.75:
		var u: float = sin(((buckle_cycle - 0.50) / 0.25) * PI)
		buckle_r = BUCKLE_DROP_M * u * intensity

	var total_drop: float = maxf(buckle_l, buckle_r)
	var pelvis_disp: Vector3 = Vector3(sway_x, -total_drop, sway_z)
	var needs_stagger: bool = Vector2(sway_x, sway_z).length() > (MAX_SWAY_M * 0.85)

	return {
		"pelvis_offset": pelvis_disp,
		"knee_buckle_l": buckle_l,
		"knee_buckle_r": buckle_r,
		"stagger_step_required": needs_stagger
	}

static func run_tests() -> bool:
	var calm: Dictionary = evaluate_ataxia(1.0, 80.0, Vector3.ZERO, 0.016)
	assert(calm["pelvis_offset"] == Vector3.ZERO, "Test Failed: Calm fighter has ataxia sway")
	var rocked: Dictionary = evaluate_ataxia(0.18 / ATX_FREQ, 20.0, Vector3.ZERO, 0.016)
	assert(rocked["knee_buckle_l"] > 0.05, "Test Failed: Rocked fighter did not buckle knee")
	return true

SECTION 4 — The Corner Between Rounds (60 Seconds)
Time (s): 0.0           5.0                      50.0        55.0       60.0
Phase:    [SIT DOWN] -> [TREATMENT & TACTICAL] -> [WHISTLE] -> [STAND] -> [ROUND START]
Actors:   Second        Cutman: Enswell/Swab     Seconds      Fighter     Bell
          Places Stool  Coach: Verbal Strategy   Exit Ring    Steps Out   Rings

4.1 Corner Timeline Execution (60 Seconds)

| Timestamp ($t$) | Corner Event Phase | Cutman Action | Head Coach Action | Assistant Second | Fighter State / Stool |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0.00 – 4.50 s | Stool Insertion | Climbs apron stairs | Climbs apron, grabs water | Slides stool beneath fighter | Fighter drops onto stool, elbows on ropes |
| 4.50 – 25.00 s | Medical Priority | Enswell compressed to cut/swelling | Kneeling at eye-level, hands on knees | Inserts mouthguard rinse, holds spit bucket | Deep diaphragmatic heave; pulse reads |
| 25.00 – 50.00 s| Tactical Delivery | Coagulant grease / swab bleed | Lean-in posture ($0.35\text{ m}$ from face) | Neck towel ice pack compression | Pupil tracking; head nods to coaching tone |
| 50.00 s | 10-Second Whistle | Packs medical tray | Steps back, gives chest slap | Grabs stool and bucket, exits ring | Fighter sits up rigid, mouthguard re-inserted |
| 55.00 – 60.00 s| Bell Preparation | Stands on outer apron | Shouts final trigger key from apron | Clears ropes, locks ring gate | Fighter stands, taps gloves together, lunges |

4.2 Mapping CornerBreak.gd Actions to Visuals
[CornerBreak Action] -----------------> [Animation Layer Executed]
Ice Swelling (Enswell)                 Iron compress pushed flat against eye socket; ice smoke VFX
Swab Bleed (Adrenaline)                Q-tip cotton swab twirled inside supraorbital eyebrow cut
Grease Brow (Vaseline)                 Glove thumb smears petroleum jelly over orbital ridge
Deep Coagulant Pack                    Gauze pad pressed into laceration with two-handed force

               [FIGHTER SEATED ON STOOL]
                      /        \
                     /          \
   [HEAD COACH: LEAN-IN]       [CUTMAN: ENSWELL COMPRESSION]
   Tone: CALM / FIRE / TRUTH   Tool: Iron wedge on orbital bone (20-40 N load)

Cutman Bone-Socket Alignment:
The Cutman's hand uses an inverse kinematics target pinned to the fighter’s damaged brow socket (brow_l or brow_r).
Normal force is represented by skin mesh displacement: skin vertex displacement shader compresses brow mesh by $2.5\text{ mm}$ under the metal Enswell tool.
Coach Posture Driven by Selected Tone:
Calm Tone: Coach keeps hands flat on boxer’s knee; slow, rhythmic nodding ($0.6\text{ Hz}$); torso inclined at $20^{\circ}$.
Fire Him Up: Coach grabs both shoulder straps or grips sides of neck; high-frequency speech head-shakes ($2.8\text{ Hz}$); aggressive pointing gestures; torso inclined at $42^{\circ}$ into boxer's personal space ($0.22\text{ m}$ distance).
Tell Him the Truth: Coach crosses arms, tilts head down at a sharp angle ($25^{\circ}$), holds an open technical grease board, taps index finger firmly on fighter's chest once per point.
4.3 Fighter Physical Read by Composure & Pulse
# CornerPhysiologySolver.gd
class_name CornerPhysiologySolver
extends RefCounted

static func evaluate_corner_body_language(
	pulse_bpm: float,
	composure: float, # 0 to 100
	cut_severity_pips: int, # 0 to 5
	selected_tone: String, # "CALM", "FIRE", "TRUTH"
	corner_elapsed_sec: float
) -> Dictionary:
	# Heavy breathing thoracic expansion (0.5 to 1.8 Hz driven by pulse)
	var breath_hz: float = lerpf(0.5, 1.8, clampf((pulse_bpm - 80.0) / 120.0, 0.0, 1.0))
	var breath_expansion: float = sin(corner_elapsed_sec * breath_hz * TAU) * 0.5 + 0.5
	var chest_scale_y: float = 1.0 + (breath_expansion * 0.045)

	# Torso posture: low composure slumps forward onto knees
	var slump_rad: float = lerpf(0.38, 0.08, composure / 100.0) # Radian pitch forward
	var head_droop_rad: float = lerpf(0.45, -0.05, composure / 100.0)

	# Tone reception reaction: does the fighter accept or reject the corner?
	var tone_adherence_alpha: float = 1.0
	var head_shake_amp: float = 0.0

	if composure < 30.0 and selected_tone == "FIRE":
		# Panicked fighter rejects aggressive shouting: flinches backward, shakes head
		tone_adherence_alpha = 0.2
		head_shake_amp = sin(corner_elapsed_sec * 8.0) * 0.12
	elif composure > 70.0 and selected_tone == "CALM":
		# High confidence fighter locks eyes steadily
		tone_adherence_alpha = 1.0
		slump_rad *= 0.6

	# Pain flinch during cutman work (seconds 5 to 45)
	var cut_flinch_offset: Vector3 = Vector3.ZERO
	if cut_severity_pips >= 2 and corner_elapsed_sec > 6.0 and corner_elapsed_sec < 45.0:
		var twitch: float = sin(corner_elapsed_sec * 3.1)
		if twitch > 0.85:
			cut_flinch_offset = Vector3(-0.02, -0.015, -0.03) # Pulls head away from tool

	return {
		"spine_pitch_rad": slump_rad,
		"neck_pitch_rad": head_droop_rad + (head_shake_amp * 0.5),
		"neck_yaw_rad": head_shake_amp,
		"chest_scale_y": chest_scale_y,
		"head_flinch_offset": cut_flinch_offset,
		"pupil_dilation": clampf(1.0 - (composure / 150.0), 0.2, 0.9)
	}

static func run_tests() -> bool:
	var exhaustion: Dictionary = evaluate_corner_body_language(190.0, 15.0, 3, "FIRE", 12.0)
	assert(exhaustion["spine_pitch_rad"] > 0.30, "Test Failed: Exhausted fighter did not slump")
	assert(exhaustion["neck_yaw_rad"] != 0.0, "Test Failed: Fighter did not reject fire tone when broken")
	return true

4.4 Telemetry Thresholds
Pass/Fail Threshold: Cutman Enswell contact error to target brow socket $< 0.008\text{ m}$ throughout compression sequence ($t \in [8, 22]\text{ s}$).
Breathing Cadence Metric: Chest scaling oscillation matches simulated BPM: $$\left|\text{Frequency} - \frac{\text{BPM}}{60}\right| \le 0.05\text{ Hz}$$
Player Perception: The 60-second corner feels like a real boxing break: cutman works on blood, coach speaks face-to-face, fighter heaves for breath and shows confidence or despair.
SECTION 5 — Camera Director + Replays
================================= RING GEOMETRY =================================
       CORNER NEUTRAL 2                     CORNER BLUE (STOOL)
               o====================================o
               |                 |                  |
               |             (MIDPOINT)             |  <-- 180° Action Axis
               |                 |                  |
               o====================================o
       CORNER RED (STOOL)                   CORNER NEUTRAL 1
=================================================================================
  CAM_CLOSE_SLOT           CAM_BROADCAST_MAIN          CAM_LOW_CORNER
  (Elevation: 1.4m)        (Elevation: 3.2m, Dist: 9m)  (Elevation: 0.6m)
  ------------------ STRICT BROADCAST CAMERA HEMISPHERE -------------------------

5.1 Broadcast Camera Shot Catalog

| Shot Identifier | Rig Type | FOV ($^{\circ}$) | Target Framing | Position / Elevation | Min Hold Time ($s$) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| CAM_MAIN_BROADCAST | Smooth rail dolly | $34.0$ | Midpoint of both fighters + $0.5\text{ m}$ buffer | $R = 9.2\text{ m}$, Elev $= 3.4\text{ m}$ | $3.50\text{ s}$ |
| CAM_MEDIUM_ORBIT | Damped track swivel | $42.0$ | Boxer chest-up framing | $R = 5.2\text{ m}$, Elev $= 1.8\text{ m}$ | $2.20\text{ s}$ |
| CAM_TIGHT_IMPACT | Shake spring snap | $26.0$ | Attacker glove to victim head | $R = 3.8\text{ m}$, Elev $= 1.5\text{ m}$ | $1.20\text{ s}$ |
| CAM_LOW_APRON | Static ground tripod | $55.0$ | Silhouette looking up past ropes | Apron edge, Elev $= 0.4\text{ m}$ | $2.80\text{ s}$ |
| CAM_CORNER_OVER_SHOULDER| Static crane | $28.0$ | Coach shoulder looking at

Can you continue from Section 2.3 and complete Sections 2–8 with typed GDScript, tables, thresholds, and no omissions?
Can you provide the remaining camera shot list, cut rules, 180-line protection, and knockdown replay implementation?
Can you create a visual presentation board showing the FightCamp ring broadcast, referee, ropes, camera angles, and gym training stations?


## Round 16c - "CONTINUE" (sent): finish SECTION 5 from CAM_CORNER_OVER_SHOULDER (shot list, cut rules, 180 line, knockdown replay +
CameraCutRules / ReplayPlanner modules), then SECTIONS 6, 7, 8 (same rules).

## Round 16c - Ludo's answer (verbatim, saved byte-exact via Tools/arena_rx.py; LaTeX as Ludo wrote it; the 8.2 benchmark table is cut by his limit)

| Shot Identifier | Rig Type | FOV ($^{\circ}$) | Target Framing | Position / Elevation | Min Hold Time ($s$) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| CAM_CORNER_OVER_SHOULDER | Static crane | $28.0$ | Coach shoulder foreground, fighter face center | Corner post apron, Elev $= 1.4\text{ m}$ | $3.00\text{ s}$ |
| CAM_REVERSE_SLOT | High boom | $38.0$ | Neutral corner looking down on referee count | Post bracket, Elev $= 4.1\text{ m}$ | $2.50\text{ s}$ |
| CAM_REPLAY_SUPER_SLO | Tracking dolly | $22.0$ | Fist-to-jaw impact point + spray | $R = 3.2\text{ m}$, Elev $= 1.35\text{ m}$ | $1.80\text{ s}$ |

                       [FIGHTER A]
                            *
      BROADCAST             |            FORBIDDEN
      SEMICIRCLE            |            CROSSING ZONE
    (All live cuts          |            (Never place live
     must live here)        |             cameras here)
                            *
                       [FIGHTER B]
  ================== 180° ACTION AXIS ==================

5.2 Broadcast Cut Rules & 180-Degree Protection
The 180° Action Axis: The primary action vector $\mathbf{v}{\text{axis}} = \frac{\mathbf{P}{\text{B}} - \mathbf{P}{\text{A}}}{|\mathbf{P}{\text{B}} - \mathbf{P}{\text{A}}|}$ partitions world space through midpoint $\mathbf{P}{\text{mid}} = \frac{1}{2}(\mathbf{P}{\text{A}} + \mathbf{P}{\text{B}})$. Every active broadcast camera position $\mathbf{C}$ must satisfy: $$(\mathbf{C} - \mathbf{P}{\text{mid}}) \cdot \mathbf{n}{\text{broadcast}} \ge 0.75\text{ m}$$ Where $\mathbf{n}_{\text{broadcast}} = (0, 0, 1)$ establishes the ringside production truck side. Crossing to the far apron ($\mathbf{n} \cdot \mathbf{C} < 0$) flips fighter screen-space orientation and is blocked during active live rounds. Replays may cross if and only if preceded by an interstitial stinger transition graphic.
Hold-Time Enforcement: No cut may trigger if current shot elapsed time $t_{\text{shot}} < T_{\text{hold_min}}$. Hard minimums: $3.5\text{ s}$ for wide coverage, $1.8\text{ s}$ for medium action, $1.2\text{ s}$ for punch impact reaction cuts.
Pacing Rules:
Cuts are barred while a punch sequence is in flight (windup through terminal recovery).
A cut triggers immediately on impact only when a clean knockdown occurs, transitioning to CAM_MEDIUM_ORBIT tracking the victim's trajectory.
Distance between consecutive camera placements must exceed $1.8\text{ m}$ or difference in elevation must exceed $0.6\text{ m}$ to prevent jump cuts.
5.3 Slow-Motion Knockdown Replay Architecture
T_hit - 0.75s            T_hit                     T_hit + 0.45s           T_hit + 1.80s
[LEAD-IN: 1.0x SPEED] -> [COMPRESSION: 0.12x SLOW] -> [HEAD ROTATION: 0.18x] -> [CANVAS DROP: 0.50x]

Frame Selection Window: Buffers ring state into a circular frame ring of length $N = 240$ ($4.0\text{ s}$ at $60\text{ Hz}$).
Replay capture start: $t_{\text{hit}} - 0.75\text{ s}$ (captures feint, slip, weight transfer).
Impact apex: $t_{\text{hit}}$ (punch penetrates guard surface).
Canvas drop: $t_{\text{hit}} + 1.80\text{ s}$ (knee/glove contacts canvas).
Playback Speed Curve: $$S(t) = \begin{cases} 1.00 & t < t_{\text{hit}} - 0.20\text{ s} \ 1.00 - 0.88 \left(\frac{t - (t_{\text{hit}} - 0.20)}{0.20}\right) & t \in [t_{\text{hit}} - 0.20, t_{\text{hit}}] \ 0.12 + 0.06 \left(\frac{t - t_{\text{hit}}}{0.45}\right) & t \in [t_{\text{hit}}, t_{\text{hit}} + 0.45] \ 0.18 + 0.32 \left(\frac{t - (t_{\text{hit}} + 0.45)}{1.35}\right) & t > t_{\text{hit}} + 0.45\text{ s} \end{cases}$$
Camera Angle Selection: Evaluates visibility to ensure the puncher's arm does not occlude the point of contact. The replay camera is placed along a vector perpendicular to the impact normal $\mathbf{n}{\text{impact}}$ on the unoccluded side of the victim's cranium: $$\mathbf{C}{\text{replay}} = \mathbf{P}{\text{impact}} + \left(\mathbf{n}{\text{impact}} \times \mathbf{u}{\text{up}}\right) \cdot d{\text{replay}} + \mathbf{u}{\text{up}} \cdot h{\text{elev}}$$ Where $d_{\text{replay}} = 3.2\text{ m}$ and $h_{\text{elev}} = 0.35\text{ m}$.
5.4 CameraCutRules & ReplayPlanner GDScript Modules
# CameraCutRules.gd
class_name CameraCutRules
extends RefCounted

const MIN_HOLD_WIDE: float = 3.50
const MIN_HOLD_MEDIUM: float = 2.20
const MIN_HOLD_IMPACT: float = 1.20
const AXIS_EPSILON: float = 0.75
const MIN_CUT_SPATIAL_SEPARATION: float = 1.80

static func can_cut(
	current_shot_type: String,
	elapsed_in_shot: float,
	is_punch_in_flight: bool,
	is_knockdown_frame: bool
) -> bool:
	if is_knockdown_frame:
		return true
	if is_punch_in_flight:
		return false

	var min_hold: float = MIN_HOLD_WIDE
	match current_shot_type:
		"CAM_MEDIUM_ORBIT":
			min_hold = MIN_HOLD_MEDIUM
		"CAM_TIGHT_IMPACT":
			min_hold = MIN_HOLD_IMPACT
		"CAM_CORNER_OVER_SHOULDER":
			min_hold = 3.00

	return elapsed_in_shot >= min_hold

static func validate_candidate_camera(
	candidate_pos: Vector3,
	active_cam_pos: Vector3,
	fighter_a_pos: Vector3,
	fighter_b_pos: Vector3,
	broadcast_normal: Vector3 = Vector3(0, 0, 1)
) -> bool:
	# Rule 1: Jump cut prevention
	if candidate_pos.distance_to(active_cam_pos) < MIN_CUT_SPATIAL_SEPARATION:
		return false

	# Rule 2: 180-degree axis crossing check
	var midpoint: Vector3 = (fighter_a_pos + fighter_b_pos) * 0.5
	var to_candidate: Vector3 = candidate_pos - midpoint
	if to_candidate.dot(broadcast_normal) < AXIS_EPSILON:
		return false

	return true

static func run_tests() -> bool:
	assert(not can_cut("CAM_MAIN_BROADCAST", 1.2, false, false), "Failed: Permitted premature cut")
	assert(can_cut("CAM_MAIN_BROADCAST", 1.2, false, true), "Failed: Denied urgent knockdown cut")
	assert(not can_cut("CAM_MEDIUM_ORBIT", 4.0, true, false), "Failed: Permitted cut during punch flight")

	var f_a: Vector3 = Vector3(-1.0, 0, 0)
	var f_b: Vector3 = Vector3(1.0, 0, 0)
	var good_cam: Vector3 = Vector3(0.0, 2.5, 6.0)
	var illegal_cam: Vector3 = Vector3(0.0, 2.5, -6.0) # Crossed line
	var cur_cam: Vector3 = Vector3(-2.0, 2.5, 5.0)

	assert(validate_candidate_camera(good_cam, cur_cam, f_a, f_b), "Failed: Valid camera rejected")
	assert(not validate_candidate_camera(illegal_cam, cur_cam, f_a, f_b), "Failed: 180-line crossing accepted")
	return true

# ReplayPlanner.gd
class_name ReplayPlanner
extends RefCounted

const PRE_IMPACT_SEC: float = 0.75
const POST_IMPACT_SEC: float = 1.80
const REPLAY_RADIUS: float = 3.20
const REPLAY_ELEV: float = 0.35

static func calculate_replay_speed(elapsed_relative_to_hit: float) -> float:
	var t: float = elapsed_relative_to_hit
	if t < -0.20:
		return 1.00
	elif t <= 0.0:
		var u: float = (t + 0.20) / 0.20
		return lerpf(1.00, 0.12, u)
	elif t <= 0.45:
		var u: float = t / 0.45
		return lerpf(0.12, 0.18, u)
	elif t <= POST_IMPACT_SEC:
		var u: float = (t - 0.45) / (POST_IMPACT_SEC - 0.45)
		return lerpf(0.18, 0.50, u)
	return 1.00

static func compute_replay_camera_transform(
	impact_pos: Vector3,
	impact_normal: Vector3,
	victim_head_pos: Vector3,
	broadcast_normal: Vector3
) -> Transform3D:
	var lateral_axis: Vector3 = impact_normal.cross(Vector3.UP).normalized()
	# Select side respecting broadcast quadrant
	if lateral_axis.dot(broadcast_normal) < 0.0:
		lateral_axis = -lateral_axis

	var cam_pos: Vector3 = impact_pos + (lateral_axis * REPLAY_RADIUS) + Vector3(0.0, REPLAY_ELEV, 0.0)
	var forward: Vector3 = (victim_head_pos - cam_pos).normalized()
	var right: Vector3 = forward.cross(Vector3.UP).normalized()
	var up: Vector3 = right.cross(forward).normalized()

	return Transform3D(Basis(right, up, -forward), cam_pos)

static func run_tests() -> bool:
	var speed_lead: float = calculate_replay_speed(-0.50)
	var speed_apex: float = calculate_replay_speed(0.0)
	var speed_tail: float = calculate_replay_speed(1.00)

	assert(is_equal_approx(speed_lead, 1.00), "Failed: Pre-impact replay speed not 1.0")
	assert(is_equal_approx(speed_apex, 0.12), "Failed: Apex replay speed not 0.12")
	assert(speed_tail > 0.18 and speed_tail < 0.50, "Failed: Post-impact replay curve invalid")
	return true

5.5 Telemetry Thresholds
Pass/Fail Threshold: Zero camera line flips ($(\mathbf{C} - \mathbf{P}{\text{mid}}) \cdot \mathbf{n}{\text{broadcast}} < 0$) across entire live match playback CSV.
Replay Window Precision: Impact apex frame centers within $\pm 2$ frames of designated ultra-slow timestamp $t_{\text{hit}}$.
Player Perception: Broadcast cuts feel like live TV sports direction with zero disorienting screen-inversions and high-impact slow-motion replays on knockdowns.
SECTION 6 — Ring Presentation
========================= PRESENTATION TIMELINE =========================
PHASE 1: WALK-OUT & ENTRY       (20.0s)  -- Low cost procedural path + drape
PHASE 2: IN-RING INTRODUCTIONS   (18.0s)  -- Authored camera orbits, stat bug
PHASE 3: TOUCH GLOVES INSTRUCTION (7.0s)  -- Paired referee sync
PHASE 4: ROUND START / CARD     (3.0s)   -- High-angle apron card walk + bell
PHASE 5: POST-FIGHT DECISION    (12.0s)  -- Authored hand-raise sequence
=========================================================================

6.1 Presentation Sequence Architecture

| Beat / Event | Duration ($s$) | Authored Asset Requirements | Cheap Procedural Elements | Audio / Event Trigger |
| :--- | :--- | :--- | :--- | :--- |
| Walk-Out | $20.0$ | Entrance robe mesh, walk cycle clip | Apron spline pathing, corner rope duck IK | Walk-out music cue, crowd cheer ramp |
| Tale of the Tape | $18.0$ | None (uses idle poses) | Camera turntable orbit, UI stat fly-in | Announcer voice clip, arena reverb |
| Referee Instruction | $7.0$ | Paired "Touch Gloves" clip | Stance spacing clamp, eye contact IK | "Protect yourselves at all times... box!" |
| Round Card | $3.0$ | Ring-card girl model, strut cycle | Spline path around apron outer track | Round start bell sound (single strike) |
| Final Bell | $0.5$ | Exhaustion exhale pose blend | Camera pull to medium wide | Three rapid bell rings ($3\times$) |
| Decision Hand Raise| $12.0$ | Announcer envelope read, hand-raise | Dual wrist gripping IK, winner arm extend | "And the winner by unanimous decision..." |

                       [RING ANNOUNCER]
                       Center: (0, 0, -0.6)
                            |
         +------------------+------------------+
         |                                     |
    [BOXER RED]           [REFEREE]       [BOXER BLUE]
    (-0.85, 0, 0)        (0, 0, 0)        (0.85, 0, 0)
         \                   |                 /
          +---- Wrist L -----+----- Wrist R --+

6.2 Implementation Economy: Procedural vs. Authored
Procedural Elements (Codex Built):
Apron Duck-Under: When traversing from apron to ring floor, fighter pelvis drops from $Y = 1.0\text{ m}$ to $Y = 0.55\text{ m}$ via procedural spline bend while head tilts down, clearing the middle rope ($Y = 0.71\text{ m}$).
Tale of the Tape Turntable: Pure camera orbit mathematically rotating around fighters at $R = 4.2\text{ m}$, $\omega = 0.35\text{ rad/s}$ with Depth-of-Field focus pinned to chest.
Dual Wrist Gripping: Inverse Kinematics constraint links Referee hand_l and hand_r directly to Boxer Red wrist_r and Boxer Blue wrist_l.
Authored Requirements (Artist Built):
1 Entrance robe model with cloth simulation bones (skinned to body).
1 Paired glove touch interaction clip (3.0 seconds duration, frame-matched).
1 Ring card bearer walk cycle (high heels strut, sign held overhead).
2 Victory reaction idles (1 jubilation leaping hook, 1 humble head nod).
6.3 Ring Presentation State Machine
# RingPresentationDirector.gd
class_name RingPresentationDirector
extends RefCounted

enum Stage {
	WALKOUT,
	INTROS,
	TOUCH_GLOVES,
	ROUND_START_BELL,
	ACTION_LIVE,
	FINAL_BELL,
	DECISION_READING
}

var current_stage: Stage = Stage.ROUND_START_BELL
var stage_elapsed: float = 0.0

const DUR_WALKOUT: float = 20.0
const DUR_INTROS: float = 18.0
const DUR_TOUCH: float = 7.0
const DUR_DECISION: float = 12.0

func advance_presentation(dt: float, event_trigger: String = "") -> Dictionary:
	stage_elapsed += dt
	var output: Dictionary = {
		"stage": current_stage,
		"camera_mode": "BROADCAST",
		"ui_banner": "",
		"bell_trigger": false,
		"blend_pose_id": ""
	}

	match current_stage:
		Stage.WALKOUT:
			output["camera_mode"] = "CAM_MEDIUM_ORBIT"
			output["ui_banner"] = "FIGHTER ENTRANCE"
			output["blend_pose_id"] = "walkout_strut"
			if stage_elapsed >= DUR_WALKOUT or event_trigger == "SKIP":
				current_stage = Stage.INTROS
				stage_elapsed = 0.0

		Stage.INTROS:
			output["camera_mode"] = "CAM_TALE_OF_TAPE"
			output["ui_banner"] = "TALE OF THE TAPE"
			output["blend_pose_id"] = "intro_corner_pump"
			if stage_elapsed >= DUR_INTROS or event_trigger == "SKIP":
				current_stage = Stage.TOUCH_GLOVES
				stage_elapsed = 0.0

		Stage.TOUCH_GLOVES:
			output["camera_mode"] = "CAM_MEDIUM_ORBIT"
			output["ui_banner"] = "REFEREE INSTRUCTIONS"
			output["blend_pose_id"] = "touch_gloves_paired"
			if stage_elapsed >= DUR_TOUCH:
				current_stage = Stage.ROUND_START_BELL
				stage_elapsed = 0.0

		Stage.ROUND_START_BELL:
			output["bell_trigger"] = true
			output["ui_banner"] = "ROUND 1"
			output["camera_mode"] = "CAM_MAIN_BROADCAST"
			current_stage = Stage.ACTION_LIVE
			stage_elapsed = 0.0

		Stage.ACTION_LIVE:
			if event_trigger == "BOUT_END":
				current_stage = Stage.FINAL_BELL
				stage_elapsed = 0.0

		Stage.FINAL_BELL:
			output["bell_trigger"] = true
			output["ui_banner"] = "FINAL BELL"
			output["camera_mode"] = "CAM_MAIN_BROADCAST"
			if stage_elapsed >= 1.5:
				current_stage = Stage.DECISION_READING
				stage_elapsed = 0.0

		Stage.DECISION_READING:
			output["camera_mode"] = "CAM_DECISION_CENTER"
			output["ui_banner"] = "OFFICIAL DECISION"
			output["blend_pose_id"] = "hand_raise_stand"
			if stage_elapsed >= DUR_DECISION:
				output["ui_banner"] = "POST_FIGHT_SUMMARY"

	return output

static func run_tests() -> bool:
	var rpd: RingPresentationDirector = RingPresentationDirector.new()
	rpd.current_stage = Stage.WALKOUT
	var out: Dictionary = rpd.advance_presentation(21.0)
	assert(rpd.current_stage == Stage.INTROS, "Failed: Walkout did not advance to Intros")
	return true

6.4 Telemetry Thresholds
Pass/Fail Threshold: Ring presentation transitions execute with zero skipped audio cues (bell fires within $16.6\text{ ms}$ of state enter).
Presentation Symmetry: Corner introductions place fighters precisely at $(\pm 2.2, 0, \pm 2.2)\text{ m}$ prior to the touch-gloves command.
Player Perception: Bouts are framed with authentic fight-night television structure, from walkout sequence through corner introductions to official decision reading.
SECTION 7 — Gym Training Animations
========================== GYM FLOOR LAYOUT ==========================
 [PAD STATION]                [HEAVY BAGS (3x)]        [SPARRING RING]
 Coach + Boxer Paired IK      Pendulum Physics         Full Sim Loop
 
 [SPEED BAG RACK]             [JUMP ROPE ZONE]         [MIRROR / SHADOW]
 Tri-phase Rebound Sim        Procedural Cable Curve   Offset Replay Layer
======================================================================

7.1 Paired Focus Mitt Interaction (Coach & Fighter)
[BOXER HAND] -------------------- (Impact Distance < 0.02m) -------------------> [PAD MITT]
Trajectory: Hook Strike               |                               Trajectory: Damped Recoil
Velocity: 7.2 m/s                     v                               Displacement: -0.06m
                              [AUDIO CRACK + SPARK]                   Absorb Angle: 12.0 deg

Target Attachment: Pad target nodes are attached via inverse kinematics to coach hand_l and hand_r.
Coach Anticipation: $120\text{ ms}$ prior to punch launch, the pad-holder presents the mitt surface perpendicular to incoming strike trajectory.
Collision Absorption: When strike penetrates within $0.02\text{ m}$ of pad center:
Puncher hand snaps to rest on the pad surface.
Coach arm undergoes an additive backward impulse: displacement $\Delta x = -0.06\text{ m}$, rotational shock $\Delta \theta = 12.0^{\circ}$, recovering over $0.14\text{ s}$ via critically damped spring.
7.2 Heavy Bag Pendulum Mechanics
       CEILING ANCHOR: (0, 3.2, 0)
              |
              |  Length L = 1.90 m
              |
              *  Cylinder Center of Mass: (X, Y, Z)
             / \
            /   \  Mass M = 45 kg
           [ BAG ]


The heavy bag is modeled as an unconstrained rigid spherical pendulum with continuous contact impulse integration.
Equations of motion:
$$\ddot{\theta} = -\frac{g}{L} \sin(\theta) - \frac{c_{\text{air}}}{M L} \dot{\theta} + \frac{F_{\text{impact}} \cos(\phi)}{M L}$$
Where $L = 1.90\text{ m}$, $M = 45.0\text{ kg}$, $c_{\text{air}} = 2.4\text{ N}\cdot\text{s/m}$.

Fighter Rhythm & Spacing

Boxers wait for the bag to swing back into the strike zone:

Punch triggers when $\dot{\theta} < 0$ (bag moving toward boxer) and $\theta \in [0.05, 0.18]\text{ rad}$.
Hitting a retreating bag ($\dot{\theta} > 0$) causes an overextension miss animation with off-balance stumble.
# HeavyBagPhysics.gd
class_name HeavyBagPhysics
extends RefCounted

const BAG_LENGTH: float = 1.90
const BAG_MASS: float = 45.0
const GRAVITY: float = 9.81
const DAMPING: float = 0.85

var angle: float = 0.0
var angular_velocity: float = 0.0
var swing_axis: Vector3 = Vector3(1, 0, 0)

func apply_punch_impact(force_newtons: float, strike_direction: Vector3, contact_height_ratio: float) -> void:
	# contact_height_ratio: 0.0 (bottom) to 1.0 (top chain)
	var torque_arm: float = BAG_LENGTH * (1.0 - contact_height_ratio)
	var impulse: float = (force_newtons * 0.035) / BAG_MASS # 35ms impact window
	swing_axis = strike_direction.cross(Vector3.UP).normalized()
	angular_velocity += impulse / torque_arm

func integrate(dt: float) -> Dictionary:
	var angular_accel: float = -(GRAVITY / BAG_LENGTH) * sin(angle) - (DAMPING / BAG_MASS) * angular_velocity
	angular_velocity += angular_accel * dt
	angle += angular_velocity * dt

	var bag_displacement: Vector3 = Vector3(sin(angle) * BAG_LENGTH, -cos(angle) * BAG_LENGTH + BAG_LENGTH, 0.0)

	return {
		"angle_rad": angle,
		"displacement": bag_displacement,
		"angular_velocity": angular_velocity
	}

static func run_tests() -> bool:
	var bag: HeavyBagPhysics = HeavyBagPhysics.new()
	bag.apply_punch_impact(850.0, Vector3(0, 0, 1), 0.3)
	assert(bag.angular_velocity > 0.0, "Failed: Bag received no momentum from punch")
	var sim: Dictionary = bag.integrate(0.1)
	assert(sim["angle_rad"] > 0.0, "Failed: Bag did not displace after impact")
	return true

7.3 Jump Rope, Shadow Boxing, & Low-Cost Living Gym
LEVEL OF DETAIL (LOD) FOR GYM POPULATION:
- LOD 0 (Within 4m): Full skeletal IK + cloth physics + sweat particles (Active Campers)
- LOD 1 (4m - 12m):  Shared animation cycles + vertex displacement + no IK
- LOD 2 (> 12m):      Impostor meshes, locked 15 Hz tick, static look-at

Procedural Jump Rope Geometry:
Visualized using an immediate 16-segment curved spline pinned between the boxer's two hands.
Sag curve height $Y_{\text{bottom}} = Y_{\text{hands}} - R \cos(\omega_{\text{rope}} t)$.
Fighter vertical hop triggers at rope phase: $$\Delta Y_{\text{boxer}} = H_{\text{hop}} \max(0, \sin(\omega_{\text{rope}} t))$$ Where $H_{\text{hop}} = 0.045\text{ m}$, synchronization phase delta $< 0.015\text{ s}$.
Phase-Offset Animation Sharing:
8 background sparring/shadow fighters share only 2 distinct animation stream resources.
De-synchronization is achieved through static per-instance phase offsets: $$t_{\text{instance}} = t_{\text{global}} + \Delta t_i, \quad \Delta t_i = i \cdot 0.375\text{ s}$$
Rotational variations applied via instance transforms: $[0^{\circ}, 45^{\circ}, 90^{\circ}, 180^{\circ}]$.
# GymLODManager.gd
class_name GymLODManager
extends RefCounted

const DIST_LOD1_SQ: float = 16.0 # 4.0m
const DIST_LOD2_SQ: float = 144.0 # 12.0m

static func evaluate_lod(camera_pos: Vector3, actor_pos: Vector3) -> int:
	var dist_sq: float = camera_pos.distance_squared_to(actor_pos)
	if dist_sq < DIST_LOD1_SQ:
		return 0 # Full IK, dynamic reaction
	elif dist_sq < DIST_LOD2_SQ:
		return 1 # Shared cycles, decoupled IK
	return 2 # 15Hz low update tick, mesh only

static func calculate_phase_offset(instance_index: int, total_instances: int) -> float:
	return (float(instance_index) / float(maxi(1, total_instances))) * TAU

static func run_tests() -> bool:
	assert(evaluate_lod(Vector3.ZERO, Vector3(0, 0, 3.0)) == 0, "Failed: LOD 0 check")
	assert(evaluate_lod(Vector3.ZERO, Vector3(0, 0, 8.0)) == 1, "Failed: LOD 1 check")
	assert(evaluate_lod(Vector3.ZERO, Vector3(0, 0, 15.0)) == 2, "Failed: LOD 2 check")
	return true

7.4 Telemetry Thresholds
Pass/Fail Threshold: Rope cable clearance under feet during jump phase $\ge 0.015\text{ m}$ (no clipping through shoe soles).
Pad Impact Synchronization: Coach pad shock response lag $\le 16.6\text{ ms}$ (1 frame) of fighter punch apex contact.
Gym Frame Budget: 12 simulated gym background fighters process skeletal updates in $< 1.8\text{ ms}$ total on CPU via LOD distribution.
Player Perception: Gym feels active and populated; heavy bags swing naturally, pads make a tight pop on hit, and background boxers move without synchronized robotic unison.
SECTION 8 — Build Order & 60-Second Presentation Benchmark
8.1 Engine Build Order & Dependency Architecture
+---------------------------------------------------------------------------------+
| PHASE A: CODEX STANDALONE (Pure RefCounted Math & Solvers)                     |
| - RopePhysicsSolver.gd, PunchImpactKinetics.gd, CanvasWearManager.gd           |
| - GloveGripSolver.gd, GazeAttentionDirector.gd, KnockdownKineticsSolver.gd     |
| - CornerPhysiologySolver.gd, CameraCutRules.gd, ReplayPlanner.gd                |
+---------------------------------------------------------------------------------+
                                       |
                                       v
+---------------------------------------------------------------------------------+
| PHASE B: GODOT SCENE INTEGRATION (Rig & Node Hooks)                             |
| - Ref Skeleton IK constraints (Hand placement, wrist grips)                     |
| - Ring canvas decal pooling system                                              |
| - Dynamic rope multi-mesh cylinder rendering                                    |
+---------------------------------------------------------------------------------+
                                       |
                                       v
+---------------------------------------------------------------------------------+
| PHASE C: AUTHORED CONTENT INJECTION (Artists & Riggers)                         |
| - 4 Recovery get-up clips (Prone, Supine, Lateral, Wobbly legs)                 |
| - Paired Referee-Boxer touch-gloves sequence                                    |
| - Cutman enswell and coagulant swabbing animations                              |
+---------------------------------------------------------------------------------+

Responsibility Matrix

| Feature Module | Codex Pure Build (Code Only) | Authored Content Required (Mesh/Clips) |
| :--- | :--- | :--- |
| Rope Contact | Piecewise spring physics + bone offset math | None (uses default ring post & rope models) |
| Impact Kinetics | Glove compression scale + wrist flex math | None (procedural skeletal bone transforms) |
| Foot Scuffs | Dynamic slip math + decal manager logic | Decal texture masks (rubber scuff, sweat) |
| Finger Curl | Hand joint curl solver + grip state triggers| None (driven by procedural bone rotations) |
| Referee Controller | AI state machine + frustum clearing math | 1 Ref idle, 1 lateral shuffle, 1 hand-raise |
| Knockdowns | Active-ragdoll blend timings + ataxia sway | 4 Recovery clips (prone/supine/side/wobble) |
| Corner Sequence | Stool timeline + breathing expansion solver | Cutman tool meshes (enswell, swab, bucket) |
| Camera Director | 180° line enforcement + replay speed curves | None (uses engine Camera3D node hierarchy) |
| Gym Mechanics | Heavy bag pendulum + LOD management system | 1 Jump rope cycle, 1 pad combination set |

8.2 The 60-Second Presentation Benchmark Timeline

This test benchmark evaluates all integrated systems in a single 60-second headless run.

0.0s          15.0s        32.0s        40.0s          48.0s           60.0s
[ROUND START] -> [ACTION] -> [KNOCKDOWN] -> [GET-UP] -> [ROUND END] -> [CORNER BREAK]
Bell Rings       Punches     Ragdoll Drop    Count 1..8  Final Bell      Stool Inserted
Apron Clear      Scuffs      Replay Trips    Ataxia      Corner Enters   Breathing Heave


| Time ($t$) | Simulated Event | Active Subsystems | Hard Pass/Fail Telemetry Metric | Player Visual Read |
| :--- | :--- | :--- | :--- | :--- |
| 0.00 – 1.00 s | Round 1 Bell | RingPresentationDirector, CameraCutRules | Bell audio fires at $t = 0.00\text{ s}$; active camera holds $\ge 3.5\text{ s}$ | Apron card girl clears out, camera establishes action |
| 1.00 – 14.00 s| Cir

Continue from Section 5 with the complete CameraCutRules and ReplayPlanner modules, tests, and measurable thresholds.
Continue through Sections 6–8, including ring presentation, gym animation modules, build order, and the 60-second benchmark.
Generate a stylized 3D FightCamp presentation board showing walk-out, knockdown replay, corner break, and gym training scenes.

## CLAUDE'S VERDICT - round 16 (boxing presentation) - under the operator's S192 ruling ("do whatever it says"), every piece behind a switch defaulting OFF
TAKE: Ludo's three phases. PHASE A (pure maths, cloud seats, now): ANIM-NEXT-MATH1 = RopePhysicsSolver, PunchImpactKinetics,
CanvasWearManager, GloveGripSolver, GazeAttentionDirector (Arena, chat 01a123eb); PRESENT-MATH2 = KnockdownKineticsSolver,
CornerPhysiologySolver, CameraCutRules, ReplayPlanner, RingPresentationDirector, HeavyBagPhysics, GymLODManager (cloud Qwen).
PHASE B (wiring, Codex, after the boxing HUMAN steps): ropes into FightPoseSolver, impact + grip + gaze into FightAliveStance, decals,
the referee body, knockdown blend through FightActiveRagdoll, the corner scene from CornerBreak, cuts + replays in FightCameraDirector.
PHASE C (content, Claude sources from what we own first - Mixamo/QuickMagic/owned packs, then generators): 4 get-up clips (prone,
supine, side, wobble), referee idle / lateral shuffle / hand-raise, a paired touch-gloves, cutman enswell + swab, a jump-rope cycle,
a pad combination set.
CORRECT (our record wins): ring size, rope heights and post positions come from OUR ring model, never Ludo's 20 ft constants;
"card girl" is a taste call for the operator, not built by default; every module's run_tests()/assert moves into a tests/*.gd file
(Godot release builds strip assert); the 8.2 benchmark beats become PRESENT-BENCH1 after Phase B (the table is cut - ask Ludo for the
rest when that task starts).
