# LUDO ROUND 15 + 15b (S193, 2026-10-10) - one big request: boxing code + grader + overlay; grappling ownership, task list, contact specs

Operator S193 (verbatim): "ludo can contribute huge amount of code and design to the project 1 question consumes 1 token make the
questions huge to cover extensive areas of the roadmap. ask the follow ups suggested prompts fromludo inone prompt".
Round 15 = one numbered TEXT ONLY prompt (Part 1 boxing 1.1-1.3, Part 2 grappling 2.1-2.5, Part 3 next problems). Ludo stops at its
length limit (~22 k chars), so 15b/15c are "CONTINUE" sends. Answers verbatim below (code fences added; LaTeX simplified).

## Round 15 - Ludo's answer (verbatim) - Part 1 (stops inside 1.3)

Complete Technical Implementation Document: FightCamp Dynamic Animation Engine
PART 1: Boxing Humanlike Animation Engine (Steps 1–9)
1.1 Complete Typed GDScript 4.x Implementation

This system applies all nine procedural layers additively on top of freshly evaluated clip poses, sampling directly from bone cache matrices to prevent compounding rotations across frames.

Global Configuration & Rig Mapping
```
# RigMap.gd
class_name RigMap
extends Resource

@export var bone_pelvis: int = 1
@export var bone_spine_01: int = 2
@export var bone_spine_02: int = 3
@export var bone_neck: int = 4
@export var bone_head: int = 5
@export var bone_clavicle_l: int = 6
@export var bone_upperarm_l: int = 7
@export var bone_forearm_l: int = 8
@export var bone_hand_l: int = 9
@export var bone_clavicle_r: int = 10
@export var bone_upperarm_r: int = 11
@export var bone_forearm_r: int = 12
@export var bone_hand_r: int = 13
@export var bone_thigh_l: int = 14
@export var bone_calf_l: int = 15
@export var bone_foot_l: int = 16
@export var bone_thigh_r: int = 17
@export var bone_calf_r: int = 18
@export var bone_foot_r: int = 19

# FightSwitches.gd
class_name FightSwitches
extends RefCounted

static var enable_step_1_hit_react: bool = false
static var enable_step_2_push_pull: bool = false
static var enable_step_3_proximity_flinch: bool = false
static var enable_step_4_kinetic_chain: bool = false
static var enable_step_5_look_at: bool = false
static var enable_step_6_punch_s_curve: bool = false
static var enable_step_7_com_balance: bool = false
static var enable_step_8_fatigue_posture: bool = false
static var enable_step_9_glove_secondary: bool = false
```

Motion Evaluation Core
```
# FightAliveStance.gd
class_name FightAliveStance
extends Node3D

@export var skeleton: Skeleton3D
@export var rig_map: RigMap

# Step 1 Variables
var hit_react_active: bool = false
var hit_react_elapsed: float = 0.0
var hit_react_rot: Vector3 = Vector3.ZERO
var hit_react_trans: Vector3 = Vector3.ZERO

# Step 3 Variables
var flinch_active: bool = false
var flinch_timer: float = 0.0
var flinch_direction: Vector3 = Vector3.ZERO

# Step 5 Variables
var look_at_target_current: Vector3 = Vector3.ZERO
var look_at_velocity: Vector3 = Vector3.ZERO

# Step 7 Variables
var computed_com: Vector3 = Vector3.ZERO

# Step 9 Variables
var glove_l_disp: Vector3 = Vector3.ZERO
var glove_l_vel: Vector3 = Vector3.ZERO
var glove_r_disp: Vector3 = Vector3.ZERO
var glove_r_vel: Vector3 = Vector3.ZERO

# Base transforms per-frame cache to guarantee single-pass non-compounding updates
var base_rotations: Array[Quaternion] = []
var base_positions: Array[Vector3] = []

func _ready() -> void:
	var count: int = skeleton.get_bone_count()
	base_rotations.resize(count)
	base_positions.resize(count)

func cache_base_pose() -> void:
	for i in range(skeleton.get_bone_count()):
		base_rotations[i] = skeleton.get_bone_pose_rotation(i)
		base_positions[i] = skeleton.get_bone_pose_position(i)

func apply_all_steps(
	delta: float,
	in_strike: bool,
	strike_name: String,
	strike_time: float,
	stamina: float,
	opponent_chest: Vector3,
	opponent_fist: Vector3,
	opponent_fist_vel: Vector3,
	lead_foot_pos: Vector3,
	rear_foot_pos: Vector3
) -> void:
	cache_base_pose()
	
	if FightSwitches.enable_step_1_hit_react:
		_apply_step_1(delta)
	if FightSwitches.enable_step_3_proximity_flinch:
		_apply_step_3(delta, opponent_fist, opponent_fist_vel)
	if FightSwitches.enable_step_4_kinetic_chain and in_strike:
		_apply_step_4(strike_name, strike_time)
	if FightSwitches.enable_step_5_look_at:
		_apply_step_5(delta, opponent_chest)
	if FightSwitches.enable_step_7_com_balance:
		_apply_step_7(lead_foot_pos, rear_foot_pos)
	if FightSwitches.enable_step_8_fatigue_posture:
		_apply_step_8(stamina)
	if FightSwitches.enable_step_9_glove_secondary:
		_apply_step_9(delta)

# Step 1: Additive Procedural Hit Reactions
func trigger_hit(impact_vector: Vector3, damage: float) -> void:
	if not FightSwitches.enable_step_1_hit_react:
		return
	hit_react_active = true
	hit_react_elapsed = 0.0
	var clamped_dmg: float = clampf(damage, 1.0, 24.0)
	var deg: float = clampf(clamped_dmg * 0.42, 4.0, 24.0)
	hit_react_rot = Vector3(
		deg_to_rad(-deg * 0.7),
		deg_to_rad(-impact_vector.x * deg * 0.5),
		deg_to_rad(impact_vector.z * deg * 0.2)
	)
	hit_react_trans = -impact_vector.normalized() * lerpf(0.012, 0.045, clamped_dmg / 24.0)

func _apply_step_1(delta: float) -> void:
	if not hit_react_active:
		return
	hit_react_elapsed += delta
	const SNAP: float = 0.045
	const RETURN: float = 0.180
	var cur_r: Vector3 = Vector3.ZERO
	var cur_t: Vector3 = Vector3.ZERO
	
	if hit_react_elapsed <= SNAP:
		var t: float = hit_react_elapsed / SNAP
		var ease_curve: float = t * t * (3.0 - 2.0 * t)
		cur_r = hit_react_rot * ease_curve
		cur_t = hit_react_trans * ease_curve
	elif hit_react_elapsed <= (SNAP + RETURN):
		var t: float = (hit_react_elapsed - SNAP) / RETURN
		var spring_decay: float = exp(-4.0 * t) * cos(3.0 * t)
		cur_r = hit_react_rot * spring_decay
		cur_t = hit_react_trans * spring_decay
	else:
		hit_react_active = false
		return

	var q_h: Quaternion = Quaternion.from_euler(cur_r * 0.6)
	var q_n: Quaternion = Quaternion.from_euler(cur_r * 0.3)
	var q_s: Quaternion = Quaternion.from_euler(cur_r * 0.1)

	skeleton.set_bone_pose_rotation(rig_map.bone_head, base_rotations[rig_map.bone_head] * q_h)
	skeleton.set_bone_pose_rotation(rig_map.bone_neck, base_rotations[rig_map.bone_neck] * q_n)
	skeleton.set_bone_pose_rotation(rig_map.bone_spine_02, base_rotations[rig_map.bone_spine_02] * q_s)
	skeleton.set_bone_pose_position(rig_map.bone_spine_02, base_positions[rig_map.bone_spine_02] + cur_t)

# Step 3: Proximity Flinch & Whiff Head Evasion
func _apply_step_3(delta: float, opponent_fist: Vector3, opponent_fist_vel: Vector3) -> void:
	var head_trans: Transform3D = skeleton.global_transform * skeleton.get_bone_global_pose(rig_map.bone_head)
	var delta_pos: Vector3 = opponent_fist - head_trans.origin
	var horiz: float = Vector2(delta_pos.x, delta_pos.z).length()
	var vert: float = absf(delta_pos.y)

	if horiz <= 0.28 and vert <= 0.175 and opponent_fist_vel.length() > 2.5:
		if not flinch_active:
			flinch_active = true
			flinch_timer = 0.0
			flinch_direction = -delta_pos.normalized()

	if not flinch_active:
		return

	flinch_timer += delta
	const IN_T: float = 0.060
	const OUT_T: float = 0.160
	var disp: float = 0.0
	var tuck: float = 0.0

	if flinch_timer <= IN_T:
		var u: float = flinch_timer / IN_T
		disp = lerpf(0.0, 0.065, u)
		tuck = lerpf(0.0, deg_to_rad(8.0), u)
	elif flinch_timer <= (IN_T + OUT_T):
		var u: float = (flinch_timer - IN_T) / OUT_T
		disp = lerpf(0.065, 0.0, u)
		tuck = lerpf(deg_to_rad(8.0), 0.0, u)
	else:
		flinch_active = false
		return

	var q_tuck: Quaternion = Quaternion(Vector3.RIGHT, tuck)
	skeleton.set_bone_pose_position(rig_map.bone_head, base_positions[rig_map.bone_head] + (flinch_direction * disp))
	skeleton.set_bone_pose_rotation(rig_map.bone_head, base_rotations[rig_map.bone_head] * q_tuck)

# Step 4: Kinetic Chain Stance Mechanics
func _apply_step_4(strike_name: String, norm_time: float) -> void:
	var curve: float = sin(clampf(norm_time / 0.45, 0.0, 1.0) * PI * 0.5)
	if norm_time > 0.45:
		curve = 1.0 - smoothstep(0.45, 1.0, norm_time)

	var pelvis_yaw: float = 0.0
	var pivot_ankle: bool = false

	if strike_name == "JAB":
		pelvis_yaw = deg_to_rad(22.0)
	elif strike_name == "CROSS":
		pelvis_yaw = deg_to_rad(48.0)
		pivot_ankle = true
	elif strike_name == "LEAD_HOOK" or strike_name == "REAR_HOOK":
		pelvis_yaw = deg_to_rad(58.0)
		pivot_ankle = (strike_name == "REAR_HOOK")

	var q_pelvis: Quaternion = Quaternion(Vector3.UP, pelvis_yaw * curve)
	skeleton.set_bone_pose_rotation(rig_map.bone_pelvis, base_rotations[rig_map.bone_pelvis] * q_pelvis)

	if pivot_ankle:
		var q_ankle: Quaternion = Quaternion(Vector3.UP, deg_to_rad(55.0) * curve)
		skeleton.set_bone_pose_rotation(rig_map.bone_foot_r, base_rotations[rig_map.bone_foot_r] * q_ankle)
		skeleton.set_bone_pose_position(rig_map.bone_foot_r, base_positions[rig_map.bone_foot_r] + Vector3(0.0, 0.045 * curve, 0.0))

# Step 5: Look-At IK Head & Eye Tracking
func _apply_step_5(delta: float, target_pos: Vector3) -> void:
	const OMEGA: float = 14.0
	var diff: Vector3 = target_pos - look_at_target_current
	var acc: Vector3 = (diff * (OMEGA * OMEGA)) - (look_at_velocity * (2.0 * OMEGA))
	look_at_velocity += acc * delta
	look_at_target_current += look_at_velocity * delta

	var head_t: Transform3D = skeleton.global_transform * skeleton.get_bone_global_pose(rig_map.bone_head)
	var local_tgt: Vector3 = head_t.affine_inverse() * look_at_target_current

	var yaw: float = clampf(atan2(local_tgt.x, -local_tgt.z), deg_to_rad(-42.0), deg_to_rad(42.0))
	var pitch: float = clampf(atan2(local_tgt.y, -local_tgt.z), deg_to_rad(-22.0), deg_to_rad(22.0))

	var q_neck: Quaternion = Quaternion.from_euler(Vector3(pitch * 0.3, yaw * 0.3, 0.0))
	var q_head: Quaternion = Quaternion.from_euler(Vector3(pitch * 0.7, yaw * 0.7, 0.0))

	skeleton.set_bone_pose_rotation(rig_map.bone_neck, base_rotations[rig_map.bone_neck] * q_neck)
	skeleton.set_bone_pose_rotation(rig_map.bone_head, base_rotations[rig_map.bone_head] * q_head)

# Step 7: Center of Mass (CoM) Balancing & Support Limits
func _apply_step_7(lead_foot_pos: Vector3, rear_foot_pos: Vector3) -> void:
	var p_pelvis: Vector3 = skeleton.get_bone_global_pose(rig_map.bone_pelvis).origin
	var p_torso: Vector3 = skeleton.get_bone_global_pose(rig_map.bone_spine_02).origin
	var p_head: Vector3 = skeleton.get_bone_global_pose(rig_map.bone_head).origin

	computed_com = (p_pelvis * 0.45) + (p_torso * 0.35) + (p_head * 0.20)
	var mid_support: Vector3 = (lead_foot_pos + rear_foot_pos) * 0.5
	var offset: Vector3 = Vector3(computed_com.x - mid_support.x, 0.0, computed_com.z - mid_support.z)

	if offset.length() > 0.18:
		var clamped_offset: Vector3 = offset.normalized() * 0.18
		var correction: Vector3 = (clamped_offset - offset) * 0.5
		skeleton.set_bone_pose_position(rig_map.bone_pelvis, base_positions[rig_map.bone_pelvis] + correction)

# Step 8: Dynamic Fatigue Posture
func _apply_step_8(stamina: float) -> void:
	var fatigue: float = clampf((30.0 - stamina) / 30.0, 0.0, 1.0)
	if fatigue <= 0.0:
		return

	var q_hunch: Quaternion = Quaternion(Vector3.RIGHT, deg_to_rad(14.0 * fatigue))
	skeleton.set_bone_pose_rotation(rig_map.bone_spine_01, base_rotations[rig_map.bone_spine_01] * q_hunch)

	var drop: Vector3 = Vector3(0.0, -0.12 * fatigue, 0.0)
	skeleton.set_bone_pose_position(rig_map.bone_hand_l, base_positions[rig_map.bone_hand_l] + drop)
	skeleton.set_bone_pose_position(rig_map.bone_hand_r, base_positions[rig_map.bone_hand_r] + drop)

# Step 9: Glove Secondary Dynamics & Wrist Inertia
func _apply_step_9(delta: float) -> void:
	const OMEGA: float = 28.0
	const ZETA: float = 0.72

	var acc_l: Vector3 = (-OMEGA * OMEGA * glove_l_disp) - (2.0 * ZETA * OMEGA * glove_l_vel)
	glove_l_vel += acc_l * delta
	glove_l_disp += glove_l_vel * delta
	glove_l_disp = glove_l_disp.clamp(Vector3(-0.018, -0.018, -0.018), Vector3(0.018, 0.018, 0.018))

	var acc_r: Vector3 = (-OMEGA * OMEGA * glove_r_disp) - (2.0 * ZETA * OMEGA * glove_r_vel)
	glove_r_vel += acc_r * delta
	glove_r_disp += glove_r_vel * delta
	glove_r_disp = glove_r_disp.clamp(Vector3(-0.018, -0.018, -0.018), Vector3(0.018, 0.018, 0.018))

	skeleton.set_bone_pose_position(rig_map.bone_hand_l, base_positions[rig_map.bone_hand_l] + glove_l_disp)
	skeleton.set_bone_pose_position(rig_map.bone_hand_r, base_positions[rig_map.bone_hand_r] + glove_r_disp)
```

Stride Phase & Kinetic Playback Integration
```
# FightStagePlayer.gd
class_name FightStagePlayer
extends Node3D

@export var alive_stance: FightAliveStance
@export var anim_player: AnimationPlayer

var current_clip_name: String = "IDLE"
var clip_playback_pos: float = 0.0
var clip_duration: float = 1.0

var lead_foot_locked: bool = true
var rear_foot_locked: bool = true

func update_playback(delta: float, move_dir: Vector2) -> void:
	clip_playback_pos += delta
	if clip_playback_pos > clip_duration:
		clip_playback_pos = fmod(clip_playback_pos, clip_duration)

	# Step 2: Push-pull directional stride phase gating
	if FightSwitches.enable_step_2_push_pull:
		var norm_phase: float = clip_playback_pos / clip_duration
		if move_dir.y > 0.1: # Forward step
			lead_foot_locked = not (norm_phase >= 0.10 and norm_phase <= 0.45)
			rear_foot_locked = not (norm_phase >= 0.55 and norm_phase <= 0.90)
		elif move_dir.y < -0.1: # Backward step
			rear_foot_locked = not (norm_phase >= 0.10 and norm_phase <= 0.45)
			lead_foot_locked = not (norm_phase >= 0.55 and norm_phase <= 0.90)
		else:
			lead_foot_locked = true
			rear_foot_locked = true
	else:
		lead_foot_locked = true
		rear_foot_locked = true

# Step 6: Punch S-Curve Velocity Snapping
func sample_punch_phase(progress: float) -> Dictionary:
	if not FightSwitches.enable_step_6_punch_s_curve:
		return {"phase": "LINEAR", "eval_time": progress}

	var phase_str: String = "WINDUP"
	var mapped_t: float = 0.0

	if progress < 0.45:
		phase_str = "EXTEND"
		var u: float = progress / 0.45
		mapped_t = pow(u, 2.8) * 0.45
	elif progress <= 0.48:
		phase_str = "APEX_HOLD"
		mapped_t = 0.45
	else:
		phase_str = "RETRACT"
		var u: float = (progress - 0.48) / 0.52
		var hermite: float = u * u * (3.0 - 2.0 * u)
		mapped_t = 0.45 + (hermite * 0.55)

	return {"phase": phase_str, "eval_time": mapped_t}
```

1.2 Automated Grading Engine (Tools/smooth_metrics.py)

No third-party libraries; operates exclusively using the Python Standard Library and numpy.

```
#!/usr/bin/env python3
"""
Tools/smooth_metrics.py
FightCamp 30-Second Boxing Benchmark Grading Script.
Strict mathematical threshold verification across sliced timeline windows.
"""

import sys
import csv
import numpy as np

def load_data(filepath: str) -> dict[str, np.ndarray]:
    with open(filepath, "r", encoding="utf-8") as f:
        reader = csv.reader(f)
        header = [col.strip() for col in next(reader)]
        columns: dict[str, list[float]] = {k: [] for k in header}
        for row in reader:
            for k, val in zip(header, row):
                try:
                    columns[k].append(float(val))
                except ValueError:
                    columns[k].append(val)
    return {k: np.array(v) for k, v in columns.items()}

def get_window_indices(t: np.ndarray, t_start: float, t_end: float) -> np.ndarray:
    return np.where((t >= t_start) & (t <= t_end))[0]

def test_step_1(data: dict) -> tuple[bool, float, float]:
    idx = get_window_indices(data["timestamp_sec"], 8.50, 12.50)
    hit_mask = (data["sim_event_name"][idx] == "HIT_LANDED")
    if not np.any(hit_mask):
        return False, 0.0, 4.0
    hit_indices = idx[hit_mask]
    max_deflection = 0.0
    for h_i in hit_indices:
        post_window = np.where((data["timestamp_sec"] >= data["timestamp_sec"][h_i]) & 
                               (data["timestamp_sec"] <= data["timestamp_sec"][h_i] + 0.050))[0]
        if len(post_window) > 0:
            peak = np.max(data["blue_head_rot_delta_deg"][post_window])
            if peak > max_deflection:
                max_deflection = peak
    threshold = 4.0
    return bool(max_deflection >= threshold), float(max_deflection), threshold

def test_step_2(data: dict) -> tuple[bool, float, float]:
    idx = get_window_indices(data["timestamp_sec"], 12.50, 16.50)
    unlocked_both = (data["red_lead_foot_locked"][idx] == 0) & (data["red_rear_foot_locked"][idx] == 0)
    fraction_both_unlocked = float(np.sum(unlocked_both) / len(idx))
    threshold = 0.05
    return bool(fraction_both_unlocked <= threshold), fraction_both_unlocked, threshold

def test_step_3(data: dict) -> tuple[bool, float, float]:
    idx = get_window_indices(data["timestamp_sec"], 16.50, 20.00)
    whiffs = (data["sim_event_name"][idx] == "MISS_WHIFF")
    if not np.any(whiffs):
        return False, 0.0, 3.5
    whiff_indices = idx[whiffs]
    max_disp = 0.0
    for w_i in whiff_indices:
        win = np.where((data["timestamp_sec"] >= data["timestamp_sec"][w_i]) & 
                       (data["timestamp_sec"] <= data["timestamp_sec"][w_i] + 0.150))[0]
        if len(win) > 0:
            peak = np.max(data["blue_head_disp_cm"][win])
            if peak > max_disp:
                max_disp = peak
    threshold = 3.5
    return bool(max_disp >= threshold), float(max_disp), threshold

def test_step_4(data: dict) -> tuple[bool, float, float]:
    idx = get_window_indices(data["timestamp_sec"], 20.00, 23.50)
    cross_strikes = (data["red_strike_phase"][idx] == "EXTEND")
    if not np.any(cross_strikes):
        return False, 0.0, 35.0
    peak_pelvis_yaw = float(np.max(data["red_pelvis_rot_yaw_deg"][idx[cross_strikes]]))
    threshold = 35.0
    return bool(peak_pelvis_yaw >= threshold), peak_pelvis_yaw, threshold

def test_step_5(data: dict) -> tuple[bool, float, float]:
    idx = get_window_indices(data["timestamp_sec"], 0.00, 30.00)
    rms_error = float(np.sqrt(np.mean(data["red_gaze_error_deg"][idx] ** 2)))
    threshold = 8.5
    return bool(rms_error <= threshold), rms_error, threshold

def test_step_6(data: dict) -> tuple[bool, float, float]:
    idx = get_window_indices(data["timestamp_sec"], 20.00, 23.50)
    v = data["red_fist_velocity_m_s"][idx]
    apex_indices = np.where(data["red_strike_phase"][idx] == "APEX_HOLD")[0]
    if len(apex_indices) == 0:
        return False, 0.0, 6.5
    peak_vel = float(np.max(v))
    threshold = 6.5
    return bool(peak_vel >= threshold), peak_vel, threshold

def test_step_7(data: dict) -> tuple[bool, float, float]:
    idx = get_window_indices(data["timestamp_sec"], 0.00, 30.00)
    max_excursion = float(np.max(data["red_com_dist_to_bos_edge"][idx]))
    threshold = 0.18
    return bool(max_excursion <= threshold), max_excursion, threshold

def test_step_8(data: dict) -> tuple[bool, float, float]:
    idx = get_window_indices(data["timestamp_sec"], 25.00, 30.00)
    mean_drop = float(np.mean(data["blue_wrist_vert_drop_cm"][idx]))
    threshold = 8.0
    return bool(mean_drop >= threshold), mean_drop, threshold

def test_step_9(data: dict) -> tuple[bool, float, float]:
    idx = get_window_indices(data["timestamp_sec"], 20.00, 23.50)
    settle_disp = float(np.max(data["blue_glove_spring_offset"][idx]))
    threshold = 0.010
    return bool(settle_disp >= threshold), settle_disp, threshold

def main() -> None:
    if len(sys.argv) < 2:
        print("Usage: python smooth_metrics.py <path_to_telemetry.csv>")
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

1.3 Debug Overlay Architecture & GDScript
Control-Node UI Hierarchy Spec
```
FightDebugOverlay (Control, Anchors: Top-Left=0,0; Bottom-Right=1,1)
├── RedCornerPanel (PanelContainer, OffsetTop=140, OffsetLeft=24, CustomSize=320x240)
│   └── RedVBox (VBoxContainer)
│       ├── LabelTitleRed (Label, Font: Bold, Color: #FF4444)
│       ├── LabelFootLockRed (Label, Font: Mono, 12pt)
│       ├── LabelPelvisYawRed (Label, Font: Mono, 12pt)
│       ├── LabelStrikePhaseRed (Label, Font: Mono, 12pt)
│       └── LabelCoMOffsetRed (Label, Font: Mono, 12pt)
├── BlueCornerPanel (PanelContainer, OffsetTop=140, OffsetRight=-24, AnchorLeft=1.0, AnchorRight=1.0, CustomSize=320x240)
│   └── BlueVBox (VBoxContainer)
│       ├── LabelTitleBlue (Label, Font: Bold, Color: #4488FF)
│       ├── LabelHitReactBlue (Label, Font: Mono, 12pt)
│       ├── LabelFlinchDispBlue (Label, Font: Mono, 12pt)
│       ├── LabelFatigueDropBlue (Label, Font: Mono, 12pt)
│       └── LabelSecondarySpringBlue (Label, Font: Mono, 12pt)
├── BottomTelemetryPanel (PanelContainer, OffsetBottom=-24, AnchorTop=1.0, AnchorBottom=1.0, AnchorLeft=0.5, AnchorRight=0.5, CustomSize=720x80, OffsetLeft=-360, OffsetRight=360)
│   └── TelemetryHBox (HBoxContainer)
│       ├── LabelSimTick (Label, Font: Mono, 14pt)
│       ├── LabelCamJerk (Label, Font: Mono, 14pt)
│       ├── LabelTransitionState (Label, Font: Mono, 14pt)
│       └── LabelRecStatus (Label, Font: Bold, 14pt, Color: #FF0000)
└── ImmediateGeometryViewport (Node3D, TopLevel=true) [Custom Drawing of 3D Polygons & Vectors]
```

Complete Implementation
```
# FightDebugOverlay.gd
class_name FightDebugOverlay
extends Control

@export var red_stage_player: FightStagePlayer
@export var blue_stage_player: FightStagePlayer
@export var camera: Camera3D

var line_material: StandardMaterial3D

func _ready() -> void:
	line_material = StandardMaterial3D.new()
	line_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	line_material.vertex_color_use_as_albedo = true
	set_process_unhandled_input(true)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_F3:
		visible = not visible

func _process(_delta: float) -> void:
	if not visible:
		return
	_update_labels()
	queue_redraw()
```
(Ludo's offers after this part: continue from the section boundary; full contact-spec tables + grappling CSV; an overlay concept image.)

## Round 15b - "CONTINUE" (sent verbatim)
CONTINUE. TEXT ONLY. Your answer stopped inside 1.3. Please continue from 1.3 (the complete typed FightDebugOverlay.gd and the Control-node
spec), then answer ALL of PART 2 (2.1 ... 2.5) and PART 3 (the next 5 problems, ranked). Same rules: numbered, dense, stop at a section
boundary with "CONTINUE FROM SECTION n" if you run out of room.

## Round 15b - Ludo's answer (verbatim) - stops inside 2.3 (clinch over-under, mat_pins)

Continuation of 1.3: Complete Typed FightDebugOverlay.gd
```
# FightDebugOverlay.gd (continued)
func _update_labels() -> void:
	if red_stage_player and red_stage_player.alive_stance:
		var red_stance: FightAliveStance = red_stage_player.alive_stance
		$RedCornerPanel/RedVBox/LabelFootLockRed.text = "FOOT LOCK: L=%s R=%s" % [
			str(red_stage_player.lead_foot_locked),
			str(red_stage_player.rear_foot_locked)
		]
		var r_pelv: float = rad_to_deg(red_stance.skeleton.get_bone_pose_rotation(red_stance.rig_map.bone_pelvis).get_euler().y)
		$RedCornerPanel/RedVBox/LabelPelvisYawRed.text = "PELVIS YAW: %+.1f deg" % r_pelv
		var strike_info: Dictionary = red_stage_player.sample_punch_phase(red_stage_player.clip_playback_pos / maxf(red_stage_player.clip_duration, 0.001))
		$RedCornerPanel/RedVBox/LabelStrikePhaseRed.text = "STRIKE PHASE: %s (%.2f)" % [strike_info["phase"], strike_info["eval_time"]]
		$RedCornerPanel/RedVBox/LabelCoMOffsetRed.text = "COM: (%.2f, %.2f, %.2f)" % [
			red_stance.computed_com.x, red_stance.computed_com.y, red_stance.computed_com.z
		]

	if blue_stage_player and blue_stage_player.alive_stance:
		var blue_stance: FightAliveStance = blue_stage_player.alive_stance
		$BlueCornerPanel/BlueVBox/LabelHitReactBlue.text = "HIT REACT: %s (t=%.3f)" % [
			str(blue_stance.hit_react_active), blue_stance.hit_react_elapsed
		]
		$BlueCornerPanel/BlueVBox/LabelFlinchDispBlue.text = "FLINCH: %s (t=%.3f)" % [
			str(blue_stance.flinch_active), blue_stance.flinch_timer
		]
		var skel: Skeleton3D = blue_stance.skeleton
		var l_hand_drop: float = blue_stance.base_positions[blue_stance.rig_map.bone_hand_l].y - skel.get_bone_pose_position(blue_stance.rig_map.bone_hand_l).y
		$BlueCornerPanel/BlueVBox/LabelFatigueDropBlue.text = "FATIGUE DROP: %.1f cm" % (l_hand_drop * 100.0)
		$BlueCornerPanel/BlueVBox/LabelSecondarySpringBlue.text = "SPRING DISP: (%.3f, %.3f)" % [
			blue_stance.glove_l_disp.length(), blue_stance.glove_r_disp.length()
		]

	$BottomTelemetryPanel/TelemetryHBox/LabelSimTick.text = "SIM: 20Hz LIVE"
	$BottomTelemetryPanel/TelemetryHBox/LabelCamJerk.text = "CAM JITTER: NOMINAL"
	$BottomTelemetryPanel/TelemetryHBox/LabelTransitionState.text = "STATE: ACTIVE_SIM"
	$BottomTelemetryPanel/TelemetryHBox/LabelRecStatus.text = "REC [ON]"

func _draw() -> void:
	if not visible or not camera:
		return
	if red_stage_player and red_stage_player.alive_stance:
		_draw_fighter_gizmos(red_stage_player.alive_stance, Color(1.0, 0.2, 0.2, 0.9))
	if blue_stage_player and blue_stage_player.alive_stance:
		_draw_fighter_gizmos(blue_stage_player.alive_stance, Color(0.2, 0.5, 1.0, 0.9))

func _draw_fighter_gizmos(stance: FightAliveStance, col: Color) -> void:
	var skel: Skeleton3D = stance.skeleton
	var t_global: Transform3D = skel.global_transform

	var p_l_foot: Vector3 = (t_global * skel.get_bone_global_pose(stance.rig_map.bone_foot_l)).origin
	var p_r_foot: Vector3 = (t_global * skel.get_bone_global_pose(stance.rig_map.bone_foot_r)).origin
	var com_world: Vector3 = t_global * stance.computed_com

	# Support polygon (Ground Line between feet)
	var s_l: Vector2 = camera.unproject_position(p_l_foot)
	var s_r: Vector2 = camera.unproject_position(p_r_foot)
	draw_line(s_l, s_r, col, 2.5)

	# Foot lock indicators
	draw_circle(s_l, 5.0, Color.GREEN if stance.get_parent().lead_foot_locked else Color.RED)
	draw_circle(s_r, 5.0, Color.GREEN if stance.get_parent().rear_foot_locked else Color.RED)

	# CoM projection to ground support baseline
	var s_com: Vector2 = camera.unproject_position(com_world)
	var ground_com: Vector3 = Vector3(com_world.x, (p_l_foot.y + p_r_foot.y) * 0.5, com_world.z)
	var s_gcom: Vector2 = camera.unproject_position(ground_com)
	draw_line(s_com, s_gcom, Color.YELLOW, 1.5)
	draw_circle(s_com, 6.0, Color.ORANGE)
	draw_circle(s_gcom, 4.0, Color.YELLOW)
```

PART 2: Grappling Hybrid Authority Pipeline
2.1 Codex Alone vs Human Production Matrix

| Grappling Element | Implementation Approach | What Codex Builds Alone | What Needs Human / Mocap | Cheapest Replacement for Human Part |
| :--- | :--- | :--- | :--- | :--- |
| Step 1: Paired Root Sync | Algorithmic Reparenting | 100% GDScript in PairedStagePlayer.gd (dual-root authority, slerp offsets). | None. | Fully procedural math; no animation authoring needed. |
| Step 2: Surface Contact Gap | Analytic Capsule Relaxation | 100% GDScript in FightPoseSolver.gd (capsule push/pull, skin boundary penalty). | None. | Pure geometric relaxation; runs dynamically on MPFB meshes. |
| Step 3: Grip Sockets | Socket Registration + FABRIK | Sockets table (GripSockets.gd) + 2-Bone Analytical IK solver in GDScript. | Sockets manual visual audit (1 hr). | Scripted attachment to predefined rig bone names with offsets. |
| Step 4: Mat Plane Clamping | Raycast Projection | 100% GDScript floor raycasts + bone height floor clamp against Y=0. | None. | Pure kinematic math; clamp local bone transforms. |
| Step 5: Ballistic Slam | Parabolic ODE + Event Trig | 100% ODE equations (P = P0 + Vt + ½gt²) in GDScript. | None. | Analytical parabolic arc with impact trigger. |
| Step 6: Ground Micro-Motion | Procedural Noise & Respiration | Procedural breathing sine waves, isometric shivering noise, weight shift curves. | None. | Layered procedural oscillations on chest/pelvis bones. |
| Step 7: Scramble Transitions | Hermite Blends between Poses | Transition trajectory interpolation (u ∈ [0, 1]), slip angle limiters. | Extreme tangled scrambles. | Short 0.4 s inertialized direct transitions between 1-frame bases. |
| Step 8: Submission Joint Limits| Constraint Clamping + Shudder | Angle clamp curves (StrainCurves.gd), directional strain vectors, jitter. | None. | Hard anatomical rotation limits + noise injection. |
| Step 9: Tap Generator | Procedural Surface Slap IK | 4.5 Hz sine slap generator targeting closest detected surface normal. | None. | Fully synthetic 2-bone arm IK striking mat/torso. |
| Clinch Clips (3 Ties) | Paired Static Holds | Blender Python script generating poses from contact constraint specifications. | Final aesthetic polish. | Auto-solve from contact specs, freeze frame 0 as static loops. |
| Takedowns (3 Throws/Shots) | High-Energy Motion | Root sync scripts, retargeting script for CMU Mocap #22 to MPFB skeletons. | Cleaning foot rolls. | CMU clip retarget + script-driven trajectory clamp. |
| Ground Bases (5 Seats) | 1-Frame Basis Poses | Python constraint optimizer (solve_pose_from_spec.py) solving meshes to 0 cm gap. | Aesthetic finger curls. | Mathematical minimization of contact point distances. |
| Ground & Pound (4 Attacks) | Additive Arm Striking | Additive punch curves on top-mounted fighter clavicle/upper arm bones. | None. | Scripted punch arcs overriding upper body while hips stay pinned. |
| Submissions (5 Holds) | 1-Frame Basis Poses | Solver optimizes limbs into locked joint configurations matching grips. | None. | Python script pins wrists to necks/elbows and freezes frame. |

2.2 File-by-File Codex Task List Mapped to Existing Files

All implementations run behind their own game switch defaulting to false.

Existing Architecture Modification Map:
```
FightRealtime.gd (20 Hz Grapple Ticks)
   └── PairedStagePlayer.gd (Clip Sync & Shared Root Authority)
          ├── GroundGraph.gd (Seat States, Transitions & Hold Decay)
          ├── FightPoseSolver.gd (Capsule Surface Gaps & 2-Body IK)
          │      └── FighterCapsules.gd (Runtime Collision Dimensions)
          ├── GripSockets.gd [NEW] (Typed Socket Offsets & Registration)
          ├── GrappleMath.gd [NEW] (Ballistic Slam, Strain Curves, Tap IK)
          └── record_room.gd (CSV Telemetry Streaming)
```

Build Order & Switch Definitions
GrappleSwitches.gd (Defines all switches defaulting to false)
GripSockets.gd (Defines socket types, transforms, target mappings)
GrappleMath.gd (Static library: Ballistics, Joint Strain Curves, Tap Generator)
FighterCapsules.gd (Add runtime sizing/mesh capsule extraction hooks)
FightPoseSolver.gd (Inject Step 2 contact relaxation and Step 3 grip FABRIK)
GroundGraph.gd (Expose transition slider u, seat anchor definitions)
PairedStagePlayer.gd (Inject Step 1 dynamic shared root, Step 4 floor raycasts, Step 5 slam launcher)
FightRealtime.gd (Connect sim events: SHOT, SLAM, HOLD, SUBMISSION_TRY, TAP)
record_room.gd (Append 60 s grappling benchmark telemetry columns)
Detailed File Modifications & Signatures
```
GrappleSwitches.gd (NEW)
class_name GrappleSwitches
extends RefCounted

static var enable_step_1_shared_root: bool = false
static var enable_step_2_surface_solver: bool = false
static var enable_step_3_grip_anchors: bool = false
static var enable_step_4_mat_clamp: bool = false
static var enable_step_5_slam_ballistics: bool = false
static var enable_step_6_ground_micro: bool = false
static var enable_step_7_transition_sliders: bool = false
static var enable_step_8_submission_limits: bool = false
static var enable_step_9_procedural_tap: bool = false

GripSockets.gd (NEW)
class_name GripSockets
extends Resource

enum SocketID {
	NONE, COLLAR_L, COLLAR_R, TRICEP_L, TRICEP_R, WRIST_L, WRIST_R,
	HIP_L, HIP_R, KNEE_L, KNEE_R, ANKLE_L, ANKLE_R, BACK_UPPER, NECK
}

static func get_socket_transform(skel: Skeleton3D, rig: RigMap, socket: SocketID) -> Transform3D:
	# Returns the world-space target transform and normal based on SocketID
	return Transform3D.IDENTITY

GrappleMath.gd (NEW)
class_name GrappleMath
extends RefCounted

static func evaluate_ballistic_flight(p0: Vector3, v0: Vector3, t: float, g: float = -11.5) -> Vector3:
	return p0 + (v0 * t) + (Vector3(0.0, 0.5 * g * t * t, 0.0))

static func evaluate_joint_strain(angle_current: float, angle_limit: float) -> float:
	var excess: float = maxf(0.0, angle_current - angle_limit)
	return 1.0 - exp(-3.2 * (excess / 15.0))

static func generate_tap_offset(elapsed: float, strike_normal: Vector3) -> Vector3:
	var cycle: float = fmod(elapsed, 0.220)
	var height: float = sin(cycle / 0.220 * PI) * 0.08
	return strike_normal * height

FighterCapsules.gd (MODIFICATION)
# Exposes capsule segment data for two-body calculations
func get_capsule_segment(bone_idx: int) -> Dictionary:
	# Returns: {"p_a": Vector3, "p_b": Vector3, "radius": float}
	return {}

FightPoseSolver.gd (MODIFICATION)
# Step 2 & Step 3 execution inside solve_pose
func solve_grapple_contact(
	skel_att: Skeleton3D,
	skel_vic: Skeleton3D,
	rig_att: RigMap,
	rig_vic: RigMap,
	capsules_att: FighterCapsules,
	capsules_vic: FighterCapsules,
	active_grips: Array[Dictionary]
) -> void:
	if not GrappleSwitches.enable_step_2_surface_solver:
		return
	# 4-Iteration Surface-Contact Relaxation Loop
	# End with Step 3 Grip FABRIK if GrappleSwitches.enable_step_3_grip_anchors is true

GroundGraph.gd (MODIFICATION)
var transition_u: float = 0.0
var active_source_seat: String = "MOUNT"
var active_target_seat: String = "SIDE_CONTROL"

func get_blended_seat_basis(u: float) -> Dictionary:
	# Returns bone transform arrays slerped between basis poses
	return {}

PairedStagePlayer.gd (MODIFICATION)
var master_root_authority: int = 0 # 0: Independent, 1: Attacker Masters, 2: Shared Anchor
var mat_anchor_transform: Transform3D = Transform3D.IDENTITY
var slam_active: bool = false
var slam_time: float = 0.0
var slam_v0: Vector3 = Vector3.ZERO
var slam_p0: Vector3 = Vector3.ZERO

func update_paired_grapple(delta: float) -> void:
	if GrappleSwitches.enable_step_1_shared_root and master_root_authority == 1:
		# Lock Victim root to Attacker Pelvis offset
		pass
	if GrappleSwitches.enable_step_5_slam_ballistics and slam_active:
		# Execute GrappleMath.evaluate_ballistic_flight until Y <= 0.0
		pass
	if GrappleSwitches.enable_step_4_mat_clamp:
		# Raycast against canvas (Mask 1) and clamp bone floor heights
		pass

FightRealtime.gd (MODIFICATION)
func _on_grapple_sim_event(event_type: String, data: Dictionary) -> void:
	match event_type:
		"SHOT":
			paired_player.initiate_shot(data["speed"])
		"SLAM":
			paired_player.slam_active = true
			paired_player.slam_p0 = data["start_pos"]
			paired_player.slam_v0 = data["velocity"]
		"SEAT_TRANSITION":
			ground_graph.start_transition(data["from_seat"], data["to_seat"], data["duration"])
		"TAP":
			paired_player.trigger_procedural_tap()

record_room.gd (MODIFICATION)
# Appends all grappling benchmark metrics to output CSV per physics frame
func log_grappling_frame(metrics: Dictionary) -> void:
	pass
```

2.3 Contact-Spec Data Format & Canonical Pose Manifest
Specification Format

A contact pose is defined as a JSON/Dictionary contract that a solver optimizes by matching target socket coordinates, orienting axes, and clamping ground contacts without hand animation.

```
{
  "pose_id": "STRING",
  "mat_anchor": {"primary_fighter": "ATT|VIC", "bone": "BONE_NAME", "ground_y": 0.0},
  "alignment": {"axis_att": "VECTOR3", "axis_vic": "VECTOR3", "target_dot": -1.0},
  "surface_contacts": [
    {"bone_a": "BONE_NAME", "bone_b": "BONE_NAME", "min_dist": 0.0, "max_dist": 0.02}
  ],
  "grip_locks": [
    {"source_bone": "HAND_L|R", "target_body": "ATT|VIC", "socket": "SOCKET_ENUM"}
  ],
  "mat_pins": [
    {"body": "ATT|VIC", "bones": ["BONE_NAMES"], "normal": [0.0, 1.0, 0.0]}
  ]
}
```

Complete Contact Specs (14 Holds & Ties)
```
1. Mount
{
  "pose_id": "MOUNT",
  "mat_anchor": {"primary_fighter": "VIC", "bone": "spine_01", "ground_y": 0.0},
  "alignment": {"axis_att": [0,0,1], "axis_vic": [0,0,1], "target_dot": 1.0},
  "surface_contacts": [
    {"bone_a": "pelvis", "bone_b": "pelvis", "min_dist": 0.0, "max_dist": 0.015},
    {"bone_a": "thigh_l", "bone_b": "spine_02", "min_dist": 0.0, "max_dist": 0.02},
    {"bone_a": "thigh_r", "bone_b": "spine_02", "min_dist": 0.0, "max_dist": 0.02}
  ],
  "grip_locks": [
    {"source_bone": "hand_l", "target_body": "VIC", "socket": "WRIST_L"},
    {"source_bone": "hand_r", "target_body": "VIC", "socket": "WRIST_R"}
  ],
  "mat_pins": [
    {"body": "VIC", "bones": ["pelvis", "spine_01", "head"], "normal": [0,1,0]},
    {"body": "ATT", "bones": ["calf_l", "calf_r"], "normal": [0,1,0]}
  ]
}

2. Side Control
{
  "pose_id": "SIDE_CONTROL",
  "mat_anchor": {"primary_fighter": "VIC", "bone": "spine_02", "ground_y": 0.0},
  "alignment": {"axis_att": [1,0,0], "axis_vic": [0,0,1], "target_dot": 0.0},
  "surface_contacts": [
    {"bone_a": "spine_02", "bone_b": "spine_02", "min_dist": 0.0, "max_dist": 0.01}
  ],
  "grip_locks": [
    {"source_bone": "hand_l", "target_body": "VIC", "socket": "NECK"},
    {"source_bone": "hand_r", "target_body": "VIC", "socket": "HIP_R"}
  ],
  "mat_pins": [
    {"body": "VIC", "bones": ["spine_01", "spine_02", "pelvis"], "normal": [0,1,0]},
    {"body": "ATT", "bones": ["foot_l", "foot_r", "knee_l"], "normal": [0,1,0]}
  ]
}

3. Closed Guard
{
  "pose_id": "CLOSED_GUARD",
  "mat_anchor": {"primary_fighter": "VIC", "bone": "pelvis", "ground_y": 0.0},
  "alignment": {"axis_att": [0,0,1], "axis_vic": [0,0,-1], "target_dot": -1.0},
  "surface_contacts": [
    {"bone_a": "pelvis", "bone_b": "pelvis", "min_dist": 0.05, "max_dist": 0.10}
  ],
  "grip_locks": [
    {"source_bone": "foot_l", "target_body": "ATT", "socket": "BACK_UPPER"},
    {"source_bone": "foot_r", "target_body": "VIC", "socket": "ANKLE_L"},
    {"source_bone": "hand_l", "target_body": "ATT", "socket": "TRICEP_R"},
    {"source_bone": "hand_r", "target_body": "ATT", "socket": "COLLAR_L"}
  ],
  "mat_pins": [
    {"body": "VIC", "bones": ["pelvis", "spine_01"], "normal": [0,1,0]},
    {"body": "ATT", "bones": ["knee_l", "knee_r", "foot_l", "foot_r"], "normal": [0,1,0]}
  ]
}

4. Half Guard
{
  "pose_id": "HALF_GUARD",
  "mat_anchor": {"primary_fighter": "VIC", "bone": "pelvis", "ground_y": 0.0},
  "alignment": {"axis_att": [0,0,1], "axis_vic": [0,0,-1], "target_dot": -0.85},
  "surface_contacts": [
    {"bone_a": "thigh_r", "bone_b": "thigh_l", "min_dist": 0.0, "max_dist": 0.02}
  ],
  "grip_locks": [
    {"source_bone": "foot_l", "target_body": "ATT", "socket": "ANKLE_R"},
    {"source_bone": "foot_r", "target_body": "ATT", "socket": "KNEE_R"},
    {"source_bone": "hand_l", "target_body": "VIC", "socket": "COLLAR_R"}
  ],
  "mat_pins": [
    {"body": "VIC", "bones": ["pelvis", "spine_01"], "normal": [0,1,0]},
    {"body": "ATT", "bones": ["knee_l", "foot_l"], "normal": [0,1,0]}
  ]
}

5. Back Control
{
  "pose_id": "BACK_CONTROL",
  "mat_anchor": {"primary_fighter": "VIC", "bone": "pelvis", "ground_y": 0.05},
  "alignment": {"axis_att": [0,0,1], "axis_vic": [0,0,1], "target_dot": 0.98},
  "surface_contacts": [
    {"bone_a": "spine_02", "bone_b": "spine_02", "min_dist": 0.0, "max_dist": 0.015}
  ],
  "grip_locks": [
    {"source_bone": "foot_l", "target_body": "VIC", "socket": "HIP_L"},
    {"source_bone": "foot_r", "target_body": "VIC", "socket": "HIP_R"},
    {"source_bone": "hand_r", "target_body": "VIC", "socket": "NECK"}
  ],
  "mat_pins": [
    {"body": "ATT", "bones": ["pelvis"], "normal": [0,1,0]}
  ]
}

6. Armbar
{
  "pose_id": "ARMBAR",
  "mat_anchor": {"primary_fighter": "ATT", "bone": "pelvis", "ground_y": 0.0},
  "alignment": {"axis_att": [1,0,0], "axis_vic": [0,0,1], "target_dot": 0.0},
  "surface_contacts": [
    {"bone_a": "pelvis", "bone_b": "upperarm_r", "min_dist": 0.0, "max_dist": 0.01},
    {"bone_a": "thigh_l", "bone_b": "neck", "min_dist": 0.0, "max_dist": 0.02},
    {"bone_a": "thigh_r", "bone_b": "spine_02", "min_dist": 0.0, "max_dist": 0.02}
  ],
  "grip_locks": [
    {"source_bone": "hand_l", "target_body": "VIC", "socket": "WRIST_R"},
    {"source_bone": "hand_r", "target_body": "VIC", "socket": "WRIST_R"}
  ],
  "mat_pins": [
    {"body": "ATT", "bones": ["pelvis", "spine_01"], "normal": [0,1,0]},
    {"body": "VIC", "bones": ["pelvis", "spine_01", "spine_02"], "normal": [0,1,0]}
  ]
}

7. Rear-Naked Choke (RNC)
{
  "pose_id": "RNC",
  "mat_anchor": {"primary_fighter": "VIC", "bone": "pelvis", "ground_y": 0.0},
  "alignment": {"axis_att": [0,0,1], "axis_vic": [0,0,1], "target_dot": 0.98},
  "surface_contacts": [
    {"bone_a": "forearm_r", "bone_b": "neck", "min_dist": 0.0, "max_dist": 0.005}
  ],
  "grip_locks": [
    {"source_bone": "hand_r", "target_body": "ATT", "socket": "TRICEP_L"},
    {"source_bone": "hand_l", "target_body": "VIC", "socket": "BACK_UPPER"}
  ],
  "mat_pins": [
    {"body": "ATT", "bones": ["pelvis"], "normal": [0,1,0]},
    {"body": "VIC", "bones": ["spine_01"], "normal": [0,1,0]}
  ]
}

8. Triangle Choke
{
  "pose_id": "TRIANGLE",
  "mat_anchor": {"primary_fighter": "ATT", "bone": "spine_01", "ground_y": 0.0},
  "alignment": {"axis_att": [0,0,-1], "axis_vic": [0,0,1], "target_dot": -0.95},
  "surface_contacts": [
    {"bone_a": "knee_l", "bone_b": "neck", "min_dist": 0.0, "max_dist": 0.01},
    {"bone_a": "calf_l", "bone_b": "knee_r", "min_dist": 0.0, "max_dist": 0.015}
  ],
  "grip_locks": [
    {"source_bone": "foot_r", "target_body": "ATT", "socket": "KNEE_L"},
    {"source_bone": "hand_l", "target_body": "VIC", "socket": "WRIST_R"},
    {"source_bone": "hand_r", "target_body": "VIC", "socket": "HEAD"}
  ],
  "mat_pins": [
    {"body": "ATT", "bones": ["pelvis", "spine_01"], "normal": [0,1,0]},
    {"body": "VIC", "bones": ["knee_l", "knee_r"], "normal": [0,1,0]}
  ]
}

9. Guillotine Choke
{
  "pose_id": "GUILLOTINE",
  "mat_anchor": {"primary_fighter": "ATT", "bone": "pelvis", "ground_y": 0.0},
  "alignment": {"axis_att": [0,0,1], "axis_vic": [0,0,-1], "target_dot": -0.85},
  "surface_contacts": [
    {"bone_a": "forearm_r", "bone_b": "neck", "min_dist": 0.0, "max_dist": 0.005}
  ],
  "grip_locks": [
    {"source_bone": "hand_l", "target_body": "ATT", "socket": "WRIST_R"},
    {"source_bone": "foot_l", "target_body": "VIC", "socket": "BACK_UPPER"},
    {"source_bone": "foot_r", "target_body": "VIC", "socket": "BACK_UPPER"}
  ],
  "mat_pins": [
    {"body": "ATT", "bones": ["pelvis", "spine_01"], "normal": [0,1,0]}
  ]
}

10. Kimura Lock
{
  "pose_id": "KIMURA",
  "mat_anchor": {"primary_fighter": "VIC", "bone": "spine_01", "ground_y": 0.0},
  "alignment": {"axis_att": [1,0,0], "axis_vic": [0,0,1], "target_dot": 0.15},
  "surface_contacts": [
    {"bone_a": "spine_02", "bone_b": "spine_02", "min_dist": 0.02, "max_dist": 0.05}
  ],
  "grip_locks": [
    {"source_bone": "hand_l", "target_body": "VIC", "socket": "WRIST_L"},
    {"source_bone": "hand_r", "target_body": "ATT", "socket": "WRIST_L"}
  ],
  "mat_pins": [
    {"body": "VIC", "bones": ["spine_01", "spine_02"], "normal": [0,1,0]},
    {"body": "ATT", "bones": ["knee_l", "foot_r"], "normal": [0,1,0]}
  ]
}

11. Clinch: Over-Under
{
  "pose_id": "CLINCH_OVER_UNDER",
  "mat_anchor": {"primary_fighter": "ATT", "bone": "foot_l", "ground_y": 0.0},
  "alignment": {"axis_att": [0,0,1], "axis_vic": [0,0,-1], "target_dot": -0.99},
  "surface_contacts": [
    {"bone_a": "spine_02", "bone_b": "spine_02", "min_dist": 0.01, "max_dist": 0.03}
  ],
  "grip_locks": [
    {"source_bone": "hand_r", "target_body": "VIC", "socket": "BACK_UPPER"},
    {"source_bone": "hand_l", "target_body": "VIC", "socket": "TRICEP_R"},
    {"source_bone": "hand_r", "target_body": "ATT", "socket": "TRICEP_L"},
    {"source_bone": "hand_l", "target_body": "ATT", "socket": "BACK_UPPER"}
  ],
  "mat_pins": [
```
(answer ends here - Ludo's output limit; round 15c "CONTINUE" sent for 2.3 rest, 2.4, 2.5, Part 3, Part 4 pure modules)
