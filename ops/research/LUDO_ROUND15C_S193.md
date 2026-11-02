# LUDO ROUND 15c (S193, 2026-10-10) - the rest of the big request: clinch ties, grapple benchmark + grader, overlay, next 5 flaws, 4 pure modules

Continues `LUDO_ROUND15_S193.md` (which stops inside 2.3 at the over-under tie's mat_pins). Sent (verbatim): "CONTINUE. TEXT ONLY. Continue
from 2.3 exactly where you stopped (finish the contact-spec tables ...), then 2.4 (grapple CSV columns + the full grapple_metrics.py,
stdlib + numpy, report line STEP n PASS|FAIL measured=x threshold=y), 2.5 (the grappling overlay in text, colors and meaning), and PART 3
(the next 5 animation/presentation problems, ranked ...). Then, if room remains, PART 4: the complete typed GDScript for the grapple-socket
table, the procedural tap generator, the ballistic fall + landing and the submission strain curve as pure static modules ... with their
test cases." Ludo's answer verbatim below (code fences added; LaTeX simplified). This answer is COMPLETE (no cut).

## Ludo's answer (verbatim)

Continuation of 2.3: Contact-Spec Data Format (Completing Clinch Ties)
```
    {"body": "ATT", "bones": ["foot_l", "foot_r"], "normal": [0,1,0]},
    {"body": "VIC", "bones": ["foot_l", "foot_r"], "normal": [0,1,0]}
  ]
}

12. Clinch: Double Underhooks
{
  "pose_id": "CLINCH_DOUBLE_UNDERHOOKS",
  "mat_anchor": {"primary_fighter": "ATT", "bone": "foot_l", "ground_y": 0.0},
  "alignment": {"axis_att": [0,0,1], "axis_vic": [0,0,-1], "target_dot": -0.99},
  "surface_contacts": [
    {"bone_a": "spine_02", "bone_b": "spine_02", "min_dist": 0.0, "max_dist": 0.02},
    {"bone_a": "head", "bone_b": "clavicle_r", "min_dist": 0.0, "max_dist": 0.03}
  ],
  "grip_locks": [
    {"source_bone": "hand_l", "target_body": "VIC", "socket": "BACK_UPPER"},
    {"source_bone": "hand_r", "target_body": "VIC", "socket": "BACK_UPPER"},
    {"source_bone": "hand_l", "target_body": "ATT", "socket": "TRICEP_R"},
    {"source_bone": "hand_r", "target_body": "ATT", "socket": "TRICEP_L"}
  ],
  "mat_pins": [
    {"body": "ATT", "bones": ["foot_l", "foot_r"], "normal": [0,1,0]},
    {"body": "VIC", "bones": ["foot_l", "foot_r"], "normal": [0,1,0]}
  ]
}

13. Clinch: Thai Plum (Collar Tie)
{
  "pose_id": "CLINCH_THAI_PLUM",
  "mat_anchor": {"primary_fighter": "ATT", "bone": "foot_l", "ground_y": 0.0},
  "alignment": {"axis_att": [0,0,1], "axis_vic": [0,0,-1], "target_dot": -0.95},
  "surface_contacts": [
    {"bone_a": "forearm_l", "bone_b": "neck", "min_dist": 0.0, "max_dist": 0.015},
    {"bone_a": "forearm_r", "bone_b": "neck", "min_dist": 0.0, "max_dist": 0.015}
  ],
  "grip_locks": [
    {"source_bone": "hand_l", "target_body": "VIC", "socket": "NECK"},
    {"source_bone": "hand_r", "target_body": "ATT", "socket": "WRIST_L"}
  ],
  "mat_pins": [
    {"body": "ATT", "bones": ["foot_l", "foot_r"], "normal": [0,1,0]},
    {"body": "VIC", "bones": ["foot_l", "foot_r"], "normal": [0,1,0]}
  ]
}
```

2.4 Morozov-vs-Silva Grapple Benchmark & Telemetry Suite
Per-Frame CSV Schema (60 FPS / 60.0 Seconds = 3600 Frames)

| Column Name | Unit | Type | Description |
| :--- | :--- | :--- | :--- |
| timestamp_sec | seconds | float | Simulation timestamp [0.000, 60.000] |
| sim_event_name | string | enum | NONE, SHOT, CLINCH, TAKEDOWN, SLAM, PASS, SUB_LOCK, TAP |
| root_drift_cm | cm | float | Separation distance between paired master and slave roots |
| surface_gap_cm | cm | float | Mean signed distance between colliding body capsules |
| grip_error_cm | cm | float | Euclidean distance from grasping hand bone to target socket |
| mat_penetration_cm | cm | float | Maximum bone depth below ground level (Y < 0.0) |
| slam_vert_acc_m_s2 | m/s^2 | float | Vertical acceleration during takedown/slam flight phases |
| micro_tremor_amp_mm | mm | float | High-frequency procedural tremor amplitude on pinned torso |
| trans_jitter_deg | deg | float | Angular velocity variance during ground seat transitions |
| joint_strain_norm | normalized | float | Submission strain factor [0.0, 1.0] against anatomical limit |
| tap_cadence_hz | Hz | float | Frequency of submission tap cycle |

Automated Telemetry Grading Engine (grapple_metrics.py)
```
#!/usr/bin/env python3
"""
grapple_metrics.py
FightCamp 60-Second Grappling Benchmark Telemetry Evaluator.
Standard library + numpy only.
"""

import sys
import csv
import numpy as np

def load_data(filepath: str) -> dict[str, np.ndarray]:
    with open(filepath, "r", encoding="utf-8") as f:
        reader = csv.reader(f)
        header = [col.strip() for col in next(reader)]
        columns: dict[str, list] = {k: [] for k in header}
        for row in reader:
            for k, val in zip(header, row):
                try:
                    columns[k].append(float(val))
                except ValueError:
                    columns[k].append(val)
    return {k: np.array(v) for k, v in columns.items()}

def get_window(t: np.ndarray, t0: float, t1: float) -> np.ndarray:
    return np.where((t >= t0) & (t <= t1))[0]

def test_step_1(d: dict) -> tuple[bool, float, float]:
    idx = get_window(d["timestamp_sec"], 0.0, 60.0)
    measured = float(np.max(d["root_drift_cm"][idx]))
    threshold = 1.50
    return measured <= threshold, measured, threshold

def test_step_2(d: dict) -> tuple[bool, float, float]:
    idx = get_window(d["timestamp_sec"], 15.0, 45.0)
    measured = float(np.mean(d["surface_gap_cm"][idx]))
    threshold = 0.80
    return measured <= threshold, measured, threshold

def test_step_3(d: dict) -> tuple[bool, float, float]:
    idx = get_window(d["timestamp_sec"], 5.0, 55.0)
    measured = float(np.max(d["grip_error_cm"][idx]))
    threshold = 1.20
    return measured <= threshold, measured, threshold

def test_step_4(d: dict) -> tuple[bool, float, float]:
    idx = get_window(d["timestamp_sec"], 0.0, 60.0)
    measured = float(np.max(d["mat_penetration_cm"][idx]))
    threshold = 0.20
    return measured <= threshold, measured, threshold

def test_step_5(d: dict) -> tuple[bool, float, float]:
    idx = get_window(d["timestamp_sec"], 8.0, 14.0)
    measured = float(np.max(d["slam_vert_acc_m_s2"][idx]))
    threshold = 9.80
    return measured >= threshold, measured, threshold

def test_step_6(d: dict) -> tuple[bool, float, float]:
    idx = get_window(d["timestamp_sec"], 20.0, 30.0)
    measured = float(np.mean(d["micro_tremor_amp_mm"][idx]))
    threshold = 0.50
    return measured >= threshold, measured, threshold

def test_step_7(d: dict) -> tuple[bool, float, float]:
    idx = get_window(d["timestamp_sec"], 25.0, 35.0)
    measured = float(np.max(d["trans_jitter_deg"][idx]))
    threshold = 4.50
    return measured <= threshold, measured, threshold

def test_step_8(d: dict) -> tuple[bool, float, float]:
    idx = get_window(d["timestamp_sec"], 48.0, 56.0)
    measured = float(np.max(d["joint_strain_norm"][idx]))
    threshold = 0.95
    return measured >= threshold, measured, threshold

def test_step_9(d: dict) -> tuple[bool, float, float]:
    idx = get_window(d["timestamp_sec"], 54.0, 58.0)
    tap_frames = np.where(d["sim_event_name"][idx] == "TAP")[0]
    if len(tap_frames) == 0:
        return False, 0.0, 4.0
    measured = float(np.mean(d["tap_cadence_hz"][idx[tap_frames]]))
    threshold = 4.0
    return measured >= threshold, measured, threshold

def main() -> None:
    if len(sys.argv) < 2:
        print("Usage: python grapple_metrics.py <telemetry.csv>")
        sys.exit(1)
    data = load_data(sys.argv[1])
    tests = [
        (1, test_step_1), (2, test_step_2), (3, test_step_3),
        (4, test_step_4), (5, test_step_5), (6, test_step_6),
        (7, test_step_7), (8, test_step_8), (9, test_step_9)
    ]
    all_pass = True
    for step_num, fn in tests:
        passed, measured, threshold = fn(data)
        if not passed:
            all_pass = False
        status_str = "PASS" if passed else "FAIL"
        print(f"STEP {step_num} {status_str} measured={measured:.4f} threshold={threshold:.4f}")
    sys.exit(0 if all_pass else 1)

if __name__ == "__main__":
    main()
```

2.5 Grappling Debug Overlay Specification

The grappling overlay provides direct visualization of the physical constraints governing interactions between the two fighters:

```
+-------------------------------------------------------------------------+
| [GRAPPLE SIM: GROUND_ENGAGED]  AUTHORITY: ATTACKER  SEAT: MOUNT -> SIDE |
| ANCHOR DRIFT: 0.22cm | SURFACE PEN: 0.04cm | STR_FACTOR: 88.4% (ARMBAR) |
+-------------------------------------------------------------------------+
|                                                                         |
|                (O) Grip Target (Cyan Circle)                            |
|                 |                                                       |
|                 +--- Target Bone IK Trace (Yellow Dashed)               |
|                 |                                                       |
|        [#] Hand (Green Locked / Red Missed)                             |
|                                                                         |
|      =================== MAT CONTACT PLANE (Y=0) ======================  |
|            |_| Clamped Foot (Green Diamond, Normal: Up)                 |
|                                                                         |
+-------------------------------------------------------------------------+
```

Visual Gizmo Elements & Semantics

Grip Sockets & Links:

Solid Cyan Dot (Ø 8 px): Socket position on target body.
Dashed Yellow Line: Vector between grabbing hand and target socket. Length represents instantaneous grip offset error.
Solid Green Square (Ø 10 px): Grip within <= 1.2 cm threshold (locked authority).
Flashing Red Square: Broken grip or kinematic separation > 1.2 cm.

Surface Contact & Capsule Penetration:

Translucent White Wireframe: Convex bounding envelopes and capsule bounds for colliding limbs.
Solid Red Spike Vector: Surface penetration normals at overlapping depths > 0.0 cm. Length indicates penetration severity.
Magenta Point: Geometric contact barycenter between the two fighters.

Center of Mass & Mat Projection:

Solid Orange Sphere (Ø 12 px): Attacker Center of Mass (CoM_att).
Solid Blue Sphere (Ø 12 px): Victim Center of Mass (CoM_vic).
Combined White Center Point: Dynamic shared system balance point.
Dashed White Drop Line: Normal projection downward onto canvas (Y=0).

Mat Floor Clamping:

Green Wireframe Diamond: Bone clamped to mat plane.
Red Downward Vector: Penetration penalty vector pushing bone up to Y >= 0.0.

Phase Authority Indicator:

Displayed in top center panel:
FREE_STANDING (Grey): Full independent locomotion.
SHARED_CLINCH (Yellow): Dual roots synchronized to midpoint.
ATTACKER_MASTER (Green): Takedown/Throw slam phase; attacker dictates world position.
GROUND_GRAPH (Cyan): Two-body solver running against mat boundary.
PART 3: Top 5 Animation & Presentation Flaws (Post-Implementation)

| Rank | Flaw Name | Domain | Observable Symptom (Why the Player Notices) |
| :---: | :--- | :--- | :--- |
| 1 | Rope/Ring Boundary Penetration | Boxing / Physics | A fighter getting backed up has their calves, elbows, or head clip straight through the ring ropes instead of indenting the vinyl strands under tension. |
| 2 | Uniform Glove Deceleration on Impact | Boxing / Impact | Punches land like rigid sticks instead of showing anatomical kinetic collapse: glove compression, wrist micro-flexion, and shoulder recoil shockwaves. |
| 3 | Canvas Decal Slip on Pivot / Scramble | Both / VFX | Sweat, blood pools, and canvas logo graphics do not deform, smear, or register dynamic footprints when shoes grind into the canvas during hard pivots and sweeps. |
| 4 | Rigid Finger Clashing in Open Clinch | MMA / Clinch | Hands resemble static curved mitts when hunting collar ties, sliding into mesh geometry like rigid blocks instead of curling fingers naturally over the trapezius. |
| 5 | Static Fighter Gaze During Referee Stoppage | Presentation / Logic | When the ref steps between fighters, both boxers maintain dead, unbroken 1000-yard stares at each other's chests rather than breaking gaze to track the referee waving his hands. |

PART 4: Typed GDScript Static Core Modules

Four standalone numerical math libraries extending RefCounted with zero node/scene dependencies, complete with deterministic self-tests.

Pure Static Module Architecture:
```
GrappleSocketTable.gd   <-- Pure lookup table & socket offsets
ProceduralTapGen.gd     <-- Deterministic harmonic slap generator
BallisticFallSolver.gd  <-- Parabolic ballistic ODE integrator
SubmissionStrain.gd     <-- Exponential soft-tissue limit model
```

4.1 GrappleSocketTable.gd
```
class_name GrappleSocketTable
extends RefCounted

enum SocketID {
	NONE,
	COLLAR_L, COLLAR_R,
	TRICEP_L, TRICEP_R,
	WRIST_L, WRIST_R,
	HIP_L, HIP_R,
	KNEE_L, KNEE_R,
	ANKLE_L, ANKLE_R,
	BACK_UPPER,
	NECK
}

static func get_socket_def(socket: SocketID) -> Dictionary:
	match socket:
		SocketID.COLLAR_L:
			return {"bone": "clavicle_l", "offset": Vector3(0.04, 0.02, 0.05), "normal": Vector3(0.0, 1.0, 0.2)}
		SocketID.COLLAR_R:
			return {"bone": "clavicle_r", "offset": Vector3(-0.04, 0.02, 0.05), "normal": Vector3(0.0, 1.0, 0.2)}
		SocketID.TRICEP_L:
			return {"bone": "upperarm_l", "offset": Vector3(0.0, -0.12, -0.04), "normal": Vector3(-1.0, 0.0, 0.0)}
		SocketID.TRICEP_R:
			return {"bone": "upperarm_r", "offset": Vector3(0.0, -0.12, -0.04), "normal": Vector3(1.0, 0.0, 0.0)}
		SocketID.WRIST_L:
			return {"bone": "hand_l", "offset": Vector3(0.0, -0.02, 0.0), "normal": Vector3(0.0, 0.0, 1.0)}
		SocketID.WRIST_R:
			return {"bone": "hand_r", "offset": Vector3(0.0, -0.02, 0.0), "normal": Vector3(0.0, 0.0, 1.0)}
		SocketID.HIP_L:
			return {"bone": "thigh_l", "offset": Vector3(0.05, -0.05, 0.0), "normal": Vector3(1.0, 0.0, 0.0)}
		SocketID.HIP_R:
			return {"bone": "thigh_r", "offset": Vector3(-0.05, -0.05, 0.0), "normal": Vector3(-1.0, 0.0, 0.0)}
		SocketID.KNEE_L:
			return {"bone": "calf_l", "offset": Vector3(0.0, 0.04, 0.05), "normal": Vector3(0.0, 0.0, 1.0)}
		SocketID.KNEE_R:
			return {"bone": "calf_r", "offset": Vector3(0.0, 0.04, 0.05), "normal": Vector3(0.0, 0.0, 1.0)}
		SocketID.ANKLE_L:
			return {"bone": "foot_l", "offset": Vector3(0.0, 0.03, -0.02), "normal": Vector3(0.0, 1.0, 0.0)}
		SocketID.ANKLE_R:
			return {"bone": "foot_r", "offset": Vector3(0.0, 0.03, -0.02), "normal": Vector3(0.0, 1.0, 0.0)}
		SocketID.BACK_UPPER:
			return {"bone": "spine_02", "offset": Vector3(0.0, 0.05, -0.10), "normal": Vector3(0.0, 0.0, -1.0)}
		SocketID.NECK:
			return {"bone": "neck", "offset": Vector3(0.0, 0.02, -0.04), "normal": Vector3(0.0, 0.0, -1.0)}
		_:
			return {"bone": "", "offset": Vector3.ZERO, "normal": Vector3.UP}

static func run_tests() -> bool:
	var def_neck: Dictionary = get_socket_def(SocketID.NECK)
	assert(def_neck["bone"] == "neck", "Test Failed: Neck bone name mismatch")
	assert(def_neck["offset"] == Vector3(0.0, 0.02, -0.04), "Test Failed: Neck offset mismatch")
	var def_invalid: Dictionary = get_socket_def(SocketID.NONE)
	assert(def_invalid["bone"] == "", "Test Failed: Default socket invalid")
	return true
```

4.2 ProceduralTapGen.gd
```
class_name ProceduralTapGen
extends RefCounted

const TAP_PERIOD_SEC: float = 0.222 # ~4.5 Hz rhythm
const MAX_STRIKE_AMPLITUDE_M: float = 0.085

static func evaluate_tap(
	elapsed_time: float,
	origin_point: Vector3,
	surface_normal: Vector3
) -> Dictionary:
	var cycle: float = fmod(elapsed_time, TAP_PERIOD_SEC)
	var phase: float = cycle / TAP_PERIOD_SEC
	var disp: float = 0.0
	var is_impact: bool = false

	# Downward slap: phase in [0.0, 0.35], return in [0.35, 1.0]
	if phase < 0.35:
		var u: float = phase / 0.35
		disp = lerpf(MAX_STRIKE_AMPLITUDE_M, 0.0, u * u)
		if phase >= 0.30:
			is_impact = true
	else:
		var u: float = (phase - 0.35) / 0.65
		disp = lerpf(0.0, MAX_STRIKE_AMPLITUDE_M, sin(u * PI * 0.5))

	var calculated_pos: Vector3 = origin_point + (surface_normal.normalized() * disp)
	return {
		"position": calculated_pos,
		"impact_frame": is_impact,
		"displacement": disp,
		"cadence_hz": 1.0 / TAP_PERIOD_SEC
	}

static func run_tests() -> bool:
	var origin: Vector3 = Vector3(0.0, 0.0, 0.0)
	var norm: Vector3 = Vector3(0.0, 1.0, 0.0)
	var t_apex: Dictionary = evaluate_tap(0.0, origin, norm)
	assert(absf(t_apex["displacement"] - MAX_STRIKE_AMPLITUDE_M) < 0.001, "Test Failed: Initial tap apex")
	var t_impact: Dictionary = evaluate_tap(0.075, origin, norm)
	assert(t_impact["impact_frame"] == true, "Test Failed: Tap impact frame detection")
	return true
```

4.3 BallisticFallSolver.gd
```
class_name BallisticFallSolver
extends RefCounted

const GRAVITY: float = -11.50 # Accelerated fall to simulate slam force

static func step_trajectory(
	pos_current: Vector3,
	vel_current: Vector3,
	delta: float,
	mat_floor_y: float = 0.0
) -> Dictionary:
	var next_vel: Vector3 = vel_current + Vector3(0.0, GRAVITY * delta, 0.0)
	var next_pos: Vector3 = pos_current + (next_vel * delta)
	var landed: bool = false

	if next_pos.y <= mat_floor_y:
		next_pos.y = mat_floor_y
		next_vel = Vector3.ZERO
		landed = true

	return {
		"position": next_pos,
		"velocity": next_vel,
		"landed": landed
	}

static func run_tests() -> bool:
	var p0: Vector3 = Vector3(0.0, 2.0, 0.0)
	var v0: Vector3 = Vector3(1.0, 0.0, 0.0)
	var res: Dictionary = step_trajectory(p0, v0, 0.1, 0.0)
	assert(res["position"].y < 2.0, "Test Failed: Gravity pull")
	assert(res["landed"] == false, "Test Failed: Premature ground impact")

	# Step down to floor contact
	var landed_res: Dictionary = step_trajectory(Vector3(0.0, 0.02, 0.0), Vector3(0.0, -5.0, 0.0), 0.1, 0.0)
	assert(landed_res["landed"] == true, "Test Failed: Mat contact clamp")
	assert(landed_res["position"].y == 0.0, "Test Failed: Floor level penetration detected")
	return true
```

4.4 SubmissionStrain.gd
```
class_name SubmissionStrain
extends RefCounted

static func calculate_joint_strain(
	current_angle_deg: float,
	anatomical_limit_deg: float,
	hyper_extension_scale: float = 12.0
) -> Dictionary:
	var delta: float = current_angle_deg - anatomical_limit_deg
	var strain_norm: float = 0.0
	var tap_required: bool = false
	var bone_break: bool = false

	if delta > 0.0:
		strain_norm = 1.0 - exp(-3.2 * (delta / maxf(hyper_extension_scale, 0.001)))
		strain_norm = clampf(strain_norm, 0.0, 1.0)
		if strain_norm >= 0.85:
			tap_required = true
		if strain_norm >= 0.99 or delta >= (hyper_extension_scale * 1.5):
			bone_break = true

	return {
		"strain_factor": strain_norm,
		"excess_angle": maxf(0.0, delta),
		"tap_required": tap_required,
		"bone_break": bone_break
	}

static func run_tests() -> bool:
	var res_nominal: Dictionary = calculate_joint_strain(90.0, 110.0)
	assert(res_nominal["strain_factor"] == 0.0, "Test Failed: Angle inside safe range")
	var res_strained: Dictionary = calculate_joint_strain(120.0, 110.0, 12.0)
	assert(res_strained["strain_factor"] > 0.85, "Test Failed: Expected tap-level strain")
	assert(res_strained["tap_required"] == true, "Test Failed: Tap signal expected")
	var res_extreme: Dictionary = calculate_joint_strain(140.0, 110.0, 12.0)
	assert(res_extreme["bone_break"] == true, "Test Failed: Extreme strain break condition")
	return true
```

Technical Appendix: Core Rig Definition

All kinematic steps map explicitly to these rig bone indices:

| Bone Index | Rig Map Property | Target Skeleton Node | Function |
| :---: | :--- | :--- | :--- |
| 1 | bone_pelvis | root/pelvis | Base locomotion anchor, Step 4 hip torque, CoM origin |
| 2 | bone_spine_01 | root/pelvis/spine_01 | Lumbar spine, Step 8 fatigue hunch |
| 3 | bone_spine_02 | root/pelvis/spine_01/spine_02 | Thoracic spine, contact surface relaxation anchor |
| 4 | bone_neck | .../spine_02/neck | Cervical spine, Step 5 tracking, Step 1 whip recoil |
| 5 | bone_head | .../neck/head | Cranium, Step 3 flinch displacement, Step 1 hit snap |
| 6 | bone_clavicle_l | .../spine_02/clavicle_l | Left shoulder girdle, punch reach extension |
| 7 | bone_upperarm_l | .../clavicle_l/upperarm_l | Left humerus, Step 2 surface collision capsule |
| 8 | bone_forearm_l | .../upperarm_l/forearm_l | Left radius/ulna, guard barrier calculations |
| 9 | bone_hand_l | .../forearm_l/hand_l | Left wrist/fist, Step 9 spring, Step 3 grip target |
| 10 | bone_clavicle_r | .../spine_02/clavicle_r | Right shoulder girdle, punch reach extension |
| 11 | bone_upperarm_r | .../clavicle_r/upperarm_r | Right humerus, Step 2 surface collision capsule |
| 12 | bone_forearm_r | .../upperarm_r/forearm_r | Right radius/ulna, guard barrier calculations |
| 13 | bone_hand_r | .../forearm_r/hand_r | Right wrist/fist, Step 9 spring, Step 3 grip target |
| 14 | bone_thigh_l | root/pelvis/thigh_l | Left femur, Step 7 ground polygon boundary |
| 15 | bone_calf_l | .../thigh_l/calf_l | Left tibia, Step 4 ground mat contact pinning |
| 16 | bone_foot_l | .../calf_l/foot_l | Left ankle/foot, Step 2 foot lock gating, Step 7 BOS |
| 17 | bone_thigh_r | root/pelvis/thigh_r | Right femur, Step 7 ground polygon boundary |
| 18 | bone_calf_r | .../thigh_r/calf_r | Right tibia, Step 4 ground mat contact pinning |
| 19 | bone_foot_r | .../calf_r/foot_r | Right ankle/foot, Step 4 pivot ankle, Step 7 BOS |

(Ludo's next offers: contact-spec tables for every remaining hold; the full grapple_metrics.py + CSV + report format; a readable 3D grappling
overlay mock-up.)
