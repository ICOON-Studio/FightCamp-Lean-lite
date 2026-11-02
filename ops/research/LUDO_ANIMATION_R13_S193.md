# LUDO ROUND 13 (S193, 2026-10-10) - Ludo's text answer, verbatim: typed GDScript per step, Codex file order, CSV schema, grader

Question and the first (image-only) answer: `LUDO_ROUND13_14_S193.md`. Overlay mock-up image: `previews/ludo_s193/r13_overlay_mock.jpg`.
The answer below was cut off by Ludo's own length limit inside test_step_2_locomotion. Code fences added; text unchanged.

## Ludo's answer (verbatim)

FightCamp: Complete Animation Engine Implementation Spec (Steps 1–9)

This technical specification details the complete implementation for Godot 4.x, the data-collection pipeline, the deterministic 30-second benchmark runner, and the automated evaluation harness in Python.

Part 1: Architecture, Typed GDScript 4.x Pseudocode & Codex Task List

To ensure every step is independently testable and will not cause regressions, all nine systems sit behind feature flags stored in a unified configuration singleton or dictionary (AnimationFeatureFlags).

```
# AnimationFeatureFlags.gd
class_name AnimationFeatureFlags
extends RefCounted

static var enable_step_1_additive_hit_react: bool = true
static var enable_step_2_locomotion_push_pull: bool = true
static var enable_step_3_proximity_flinch: bool = true
static var enable_step_4_kinetic_chain: bool = true
static var enable_step_5_look_at_ik: bool = true
static var enable_step_6_punch_s_curves: bool = true
static var enable_step_7_com_balance: bool = true
static var enable_step_8_fatigue_posture: bool = true
static var enable_step_9_glove_secondary: bool = true
```

1. Typed GDScript 4.x Implementations (Steps 1–9)
Step 1: Additive Procedural Hit Reactions
```
# Inside FightAliveStance.gd
var hit_react_active: bool = false
var hit_react_elapsed: float = 0.0
var hit_react_impulse_rot: Vector3 = Vector3.ZERO
var hit_react_impulse_trans: Vector3 = Vector3.ZERO
var hit_react_weight: float = 0.0

func apply_hit_impulse(impact_dir: Vector3, damage: float, is_head: bool) -> void:
	if not AnimationFeatureFlags.enable_step_1_additive_hit_react:
		return
	hit_react_active = true
	hit_react_elapsed = 0.0
	var clamped_damage: float = clampf(damage, 1.0, 24.0)
	var snap_angle_deg: float = clampf(clamped_damage * 0.42, 4.0, 24.0)
	
	# Pitch back, yaw away from impact vector
	hit_react_impulse_rot = Vector3(
		deg_to_rad(-snap_angle_deg * 0.7),
		deg_to_rad(-impact_dir.x * snap_angle_deg * 0.5),
		deg_to_rad(impact_dir.z * snap_angle_deg * 0.2)
	)
	var push_back_dist: float = lerpf(0.012, 0.045, clamped_damage / 24.0) # 1.2 to 4.5 cm
	hit_react_impulse_trans = -impact_dir.normalized() * push_back_dist

func _process_step_1_hit_react(delta: float, skeleton: Skeleton3D, spine_idx: int, neck_idx: int, head_idx: int) -> void:
	if not hit_react_active:
		hit_react_weight = 0.0
		return
		
	hit_react_elapsed += delta
	const SNAP_TIME: float = 0.045 # 45 ms
	const RETURN_TIME: float = 0.180 # 180 ms
	const TOTAL_TIME: float = SNAP_TIME + RETURN_TIME
	
	var current_rot: Vector3 = Vector3.ZERO
	var current_trans: Vector3 = Vector3.ZERO
	
	if hit_react_elapsed < SNAP_TIME:
		var t: float = hit_react_elapsed / SNAP_TIME
		var ease_snap: float = t * t * (3.0 - 2.0 * t)
		current_rot = hit_react_impulse_rot * ease_snap
		current_trans = hit_react_impulse_trans * ease_snap
		hit_react_weight = ease_snap
	elif hit_react_elapsed < TOTAL_TIME:
		var t_ret: float = (hit_react_elapsed - SNAP_TIME) / RETURN_TIME
		# Critically damped spring return
		var damp: float = exp(-4.0 * t_ret) * cos(3.0 * t_ret)
		current_rot = hit_react_impulse_rot * damp
		current_trans = hit_react_impulse_trans * damp
		hit_react_weight = clampf(damp, 0.0, 1.0)
	else:
		hit_react_active = false
		hit_react_weight = 0.0
		return
		
	# Distribute across spine, neck, and head
	var q_head: Quaternion = Quaternion.from_euler(current_rot * 0.6)
	var q_neck: Quaternion = Quaternion.from_euler(current_rot * 0.3)
	var q_spine: Quaternion = Quaternion.from_euler(current_rot * 0.1)
	
	skeleton.set_bone_pose_rotation(head_idx, skeleton.get_bone_pose_rotation(head_idx) * q_head)
	skeleton.set_bone_pose_rotation(neck_idx, skeleton.get_bone_pose_rotation(neck_idx) * q_neck)
	skeleton.set_bone_pose_rotation(spine_idx, skeleton.get_bone_pose_rotation(spine_idx) * q_spine)
	skeleton.set_bone_pose_position(spine_idx, skeleton.get_bone_pose_position(spine_idx) + current_trans)
```

Step 2: 4-Way Push-Pull Locomotion & Stance-Aware Directional Steps
```
# Inside FightStagePlayer.gd
@export var blend_tree: AnimationTree
var current_locomotion_vector: Vector2 = Vector2.ZERO
var lead_foot_planted: bool = true
var rear_foot_planted: bool = true
const STRIDE_CYCLE_LEN: float = 0.48 # 48 cm
const MIN_STANCE_WIDTH: float = 0.32 # 32 cm floor

func update_locomotion(world_velocity: Vector3, facing_dir: Vector3, delta: float) -> void:
	if not AnimationFeatureFlags.enable_step_2_locomotion_push_pull:
		return
		
	# Project world velocity into local boxer basis
	var fwd: Vector3 = -facing_dir.normalized()
	var right: Vector3 = fwd.cross(Vector3.UP).normalized()
	var local_x: float = world_velocity.dot(right)
	var local_z: float = world_velocity.dot(fwd)
	
	var target_vector: Vector2 = Vector2(local_x, local_z).limit_length(1.8)
	current_locomotion_vector = current_locomotion_vector.move_toward(target_vector, 8.0 * delta)
	
	# Feed blend space
	blend_tree.set("parameters/locomotion/blend_position", current_locomotion_vector)
	
	# Determine foot lock timing using playback phase
	var phase: float = fmod(blend_tree.get("parameters/locomotion/playback_position"), 1.0)
	# Push-pull gating: Forward (lead lifts first), Backward (rear lifts first)
	if current_locomotion_vector.y > 0.1: # Moving forward
		lead_foot_planted = not (phase >= 0.1 && phase <= 0.45)
		rear_foot_planted = not (phase >= 0.55 && phase <= 0.90)
	elif current_locomotion_vector.y < -0.1: # Moving backward
		rear_foot_planted = not (phase >= 0.1 && phase <= 0.45)
		lead_foot_planted = not (phase >= 0.55 && phase <= 0.90)
	else:
		lead_foot_planted = true
		rear_foot_planted = true
```

Step 3: Proximity Flinch & Whiff Head Evasion
```
# Inside FightAliveStance.gd
var flinch_active: bool = false
var flinch_timer: float = 0.0
var flinch_dir: Vector3 = Vector3.ZERO
var flinch_disp_current: float = 0.0

const CYLINDER_RADIUS: float = 0.28 # 28 cm
const CYLINDER_HEIGHT: float = 0.35 # 35 cm

func evaluate_proximity_flinch(head_global_pos: Vector3, opp_glove_pos: Vector3, opp_glove_velocity: Vector3, is_struck: bool) -> void:
	if not AnimationFeatureFlags.enable_step_3_proximity_flinch or is_struck:
		flinch_active = false
		return
		
	var delta_pos: Vector3 = opp_glove_pos - head_global_pos
	var horiz_dist: float = Vector2(delta_pos.x, delta_pos.z).length()
	var vert_dist: float = absf(delta_pos.y)
	
	if horiz_dist <= CYLINDER_RADIUS and vert_dist <= (CYLINDER_HEIGHT * 0.5):
		if opp_glove_velocity.length() > 2.5 and not flinch_active:
			flinch_active = true
			flinch_timer = 0.0
			flinch_dir = -delta_pos.normalized()

func _process_step_3_flinch(delta: float, skeleton: Skeleton3D, head_idx: int) -> void:
	if not flinch_active:
		flinch_disp_current = 0.0
		return
		
	flinch_timer += delta
	const RISE: float = 0.060 # 60 ms
	const FALL: float = 0.160 # 160 ms
	var target_disp: float = 0.0
	var chin_tuck: float = 0.0
	
	if flinch_timer < RISE:
		var t: float = flinch_timer / RISE
		target_disp = lerpf(0.0, 0.065, t) # 6.5 cm max
		chin_tuck = lerpf(0.0, deg_to_rad(8.0), t) # 8 deg chin tuck
	elif flinch_timer < (RISE + FALL):
		var t: float = (flinch_timer - RISE) / FALL
		target_disp = lerpf(0.065, 0.0, t)
		chin_tuck = lerpf(deg_to_rad(8.0), 0.0, t)
	else:
		flinch_active = false
		return
		
	flinch_disp_current = target_disp
	var local_trans: Vector3 = flinch_dir * target_disp
	skeleton.set_bone_pose_position(head_idx, skeleton.get_bone_pose_position(head_idx) + local_trans)
	
	var q_tuck: Quaternion = Quaternion(Vector3.RIGHT, chin_tuck)
	skeleton.set_bone_pose_rotation(head_idx, skeleton.get_bone_pose_rotation(head_idx) * q_tuck)
```

Step 4: Kinetic Chain Stance Mechanics
```
# Inside FightAliveStance.gd
func apply_kinetic_chain(skeleton: Skeleton3D, strike_name: String, normalized_strike_time: float, pelvis_idx: int, rear_ankle_idx: int) -> void:
	if not AnimationFeatureFlags.enable_step_4_kinetic_chain:
		return
	if normalized_strike_time < 0.0 or normalized_strike_time > 1.0:
		return
		
	# Pelvis precedence window: 0.0 -> 0.35, Peak before hand apex (0.45)
	var max_pelvis_yaw: float = 0.0
	var needs_ankle_pivot: bool = false
	
	match strike_name:
		"JAB":
			max_pelvis_yaw = deg_to_rad(22.0)
		"CROSS":
			max_pelvis_yaw = deg_to_rad(48.0)
			needs_ankle_pivot = true
		"REAR_HOOK", "LEAD_HOOK":
			max_pelvis_yaw = deg_to_rad(58.0)
			needs_ankle_pivot = (strike_name == "REAR_HOOK")
			
	var pelvis_curve: float = sin(clampf(normalized_strike_time / 0.45, 0.0, 1.0) * PI * 0.5)
	if normalized_strike_time > 0.45:
		pelvis_curve = 1.0 - smoothstep(0.45, 1.0, normalized_strike_time)
		
	var rot_pelvis: Quaternion = Quaternion(Vector3.UP, max_pelvis_yaw * pelvis_curve)
	skeleton.set_bone_pose_rotation(pelvis_idx, skeleton.get_bone_pose_rotation(pelvis_idx) * rot_pelvis)
	
	if needs_ankle_pivot:
		var ankle_pivot_yaw: float = deg_to_rad(55.0) * pelvis_curve
		var heel_elevation: float = 0.045 * pelvis_curve # 4.5 cm
		var q_ankle: Quaternion = Quaternion(Vector3.UP, ankle_pivot_yaw)
		skeleton.set_bone_pose_rotation(rear_ankle_idx, skeleton.get_bone_pose_rotation(rear_ankle_idx) * q_ankle)
		skeleton.set_bone_pose_position(rear_ankle_idx, skeleton.get_bone_pose_position(rear_ankle_idx) + Vector3(0, heel_elevation, 0))
```

Step 5: Look-At IK Head & Eye Tracking
```
# Inside FightAliveStance.gd
var look_at_current_target: Vector3 = Vector3.ZERO
var look_at_vel: Vector3 = Vector3.ZERO

func solve_look_at(skeleton: Skeleton3D, opp_chest_pos: Vector3, neck_idx: int, head_idx: int, delta: float) -> void:
	if not AnimationFeatureFlags.enable_step_5_look_at_ik:
		return
		
	# Critically damped spring tracking
	const OMEGA: float = 14.0 # rad/s
	var diff: Vector3 = opp_chest_pos - look_at_current_target
	var acc: Vector3 = (diff * (OMEGA * OMEGA)) - (look_at_vel * (2.0 * OMEGA))
	look_at_vel += acc * delta
	look_at_current_target += look_at_vel * delta
	
	var head_global_trans: Transform3D = skeleton.global_transform * skeleton.get_bone_global_pose(head_idx)
	var local_look: Vector3 = head_global_trans.affine_inverse() * look_at_current_target
	
	var yaw: float = clampf(atan2(local_look.x, -local_look.z), deg_to_rad(-42.0), deg_to_rad(42.0))
	var pitch: float = clampf(atan2(local_look.y, -local_look.z), deg_to_rad(-22.0), deg_to_rad(22.0))
	
	var q_neck: Quaternion = Quaternion.from_euler(Vector3(pitch * 0.3, yaw * 0.3, 0.0))
	var q_head: Quaternion = Quaternion.from_euler(Vector3(pitch * 0.7, yaw * 0.7, 0.0))
	
	skeleton.set_bone_pose_rotation(neck_idx, skeleton.get_bone_pose_rotation(neck_idx) * q_neck)
	skeleton.set_bone_pose_rotation(head_idx, skeleton.get_bone_pose_rotation(head_idx) * q_head)
```

Step 6: Punch S-Curve Velocity Snapping
```
# Inside FightStagePlayer.gd
func sample_punch_phase_timeline(progress: float) -> Dictionary:
	# Progress normalized 0.0 to 1.0 over nominal attack clip duration
	if not AnimationFeatureFlags.enable_step_6_punch_s_curves:
		return {"phase": "RAW", "eval_time": progress}
		
	var phase_name: String = "WINDUP"
	var remapped_time: float = 0.0
	
	if progress < 0.45:
		phase_name = "EXTEND"
		# Cubic acceleration (exponent 2.8) to apex
		var t: float = progress / 0.45
		remapped_time = pow(t, 2.8) * 0.45
	elif progress <= 0.48: # 1-frame apex hold (16.6 ms on 0.5s total time)
		phase_name = "APEX_HOLD"
		remapped_time = 0.45
	else:
		phase_name = "RETRACT"
		var t_ret: float = (progress - 0.48) / 0.52
		# Fast Hermite return
		var ease_ret: float = t_ret * t_ret * (3.0 - 2.0 * t_ret)
		remapped_time = 0.45 + (ease_ret * 0.55)
		
	return {"phase": phase_name, "eval_time": remapped_time}
```

Step 7: Center of Mass (CoM) Balancing & Dynamic Weight Transfer
```
# Inside FightAliveStance.gd
var calculated_com_proj: Vector3 = Vector3.ZERO

func compute_center_of_mass(skeleton: Skeleton3D, pelvis_idx: int) -> Vector3:
	# Fast multi-mass proxy: Pelvis (45%), Torso (35%), Head/Arms (20%)
	var p_pelvis: Vector3 = skeleton.get_bone_global_pose(pelvis_idx).origin
	var p_torso: Vector3 = skeleton.get_bone_global_pose(skeleton.find_bone("Spine2")).origin
	var p_head: Vector3 = skeleton.get_bone_global_pose(skeleton.find_bone("Head")).origin
	
	var com: Vector3 = (p_pelvis * 0.45) + (p_torso * 0.35) + (p_head * 0.20)
	calculated_com_proj = com
	calculated_com_proj.y = 0.0 # Canvas plane projection
	return calculated_com_proj

func enforce_com_ground_limits(lead_foot_pos: Vector3, rear_foot_pos: Vector3, skeleton: Skeleton3D, pelvis_idx: int) -> void:
	if not AnimationFeatureFlags.enable_step_7_com_balance:
		return
	var mid_point: Vector3 = (lead_foot_pos + rear_foot_pos) * 0.5
	mid_point.y = 0.0
	var offset: Vector3 = calculated_com_proj - mid_point
	# Hard limit excursion to 18 cm max
	if offset.length() > 0.18:
		var clamped_offset: Vector3 = offset.normalized() * 0.18
		var root_correction: Vector3 = (clamped_offset - offset) * 0.5
		skeleton.set_bone_pose_position(pelvis_idx, skeleton.get_bone_pose_position(pelvis_idx) + root_correction)
```

Step 8: Dynamic Fatigue Posture & Composure Degradation
```
# Inside FightAliveStance.gd
func apply_fatigue_posture(skeleton: Skeleton3D, stamina: float, spine1_idx: int, l_wrist_idx: int, r_wrist_idx: int) -> void:
	if not AnimationFeatureFlags.enable_step_8_fatigue_posture:
		return
		
	var fatigue_factor: float = clampf((30.0 - stamina) / 30.0, 0.0, 1.0) # Active below 30 stamina
	if fatigue_factor <= 0.0:
		return
		
	# Thoracic hunch (+14 deg Spine1 pitch)
	var hunch_rot: Quaternion = Quaternion(Vector3.RIGHT, deg_to_rad(14.0 * fatigue_factor))
	skeleton.set_bone_pose_rotation(spine1_idx, skeleton.get_bone_pose_rotation(spine1_idx) * hunch_rot)
	
	# Guard height drop (-12 cm on wrist height)
	var drop_offset: Vector3 = Vector3(0.0, -0.12 * fatigue_factor, 0.0)
	skeleton.set_bone_pose_position(l_wrist_idx, skeleton.get_bone_pose_position(l_wrist_idx) + drop_offset)
	skeleton.set_bone_pose_position(r_wrist_idx, skeleton.get_bone_pose_position(r_wrist_idx) + drop_offset)
```

Step 9: Glove Secondary Dynamics & Wrist Inertia
```
# Inside FightAliveStance.gd
var l_glove_spring_offset: Vector3 = Vector3.ZERO
var l_glove_vel: Vector3 = Vector3.ZERO
var r_glove_spring_offset: Vector3 = Vector3.ZERO
var r_glove_vel: Vector3 = Vector3.ZERO

func apply_glove_secondary_dynamics(skeleton: Skeleton3D, l_hand_idx: int, r_hand_idx: int, delta: float) -> void:
	if not AnimationFeatureFlags.enable_step_9_glove_secondary:
		return
		
	const OMEGA: float = 28.0 # rad/s
	const ZETA: float = 0.72 # Damping ratio
	
	# Compute spring settle for left and right hands
	var acc_l: Vector3 = (-OMEGA * OMEGA * l_glove_spring_offset) - (2.0 * ZETA * OMEGA * l_glove_vel)
	l_glove_vel += acc_l * delta
	l_glove_spring_offset += l_glove_vel * delta
	l_glove_spring_offset = l_glove_spring_offset.clamp(Vector3(-0.018, -0.018, -0.018), Vector3(0.018, 0.018, 0.018))
	
	skeleton.set_bone_pose_position(l_hand_idx, skeleton.get_bone_pose_position(l_hand_idx) + l_glove_spring_offset)
	skeleton.set_bone_pose_position(r_hand_idx, skeleton.get_bone_pose_position(r_hand_idx) + r_glove_spring_offset)
```

2. File-by-File Codex Implementation Order & Task List

Codex should construct the components in strict sequential order. Each step remains behind its boolean flag in AnimationFeatureFlags.gd.

Build Order:
1. AnimationFeatureFlags.gd (New configuration singleton)
2. Forced-Action Hook (Sim Scripting Queue for deterministic bench)
3. FightStagePlayer.gd (Locomotion BlendSpace & S-Curve Sampling)
4. FightAliveStance.gd (Spring Layers, Look-At IK, CoM & Dynamics)
5. FightDebugOverlay.gd (Viewport Geometric Renderer)
6. record_room.gd (Expanded CSV Telemetry Logger)
7. Tools/smooth_metrics.py (Automated Validation Suite)

File 1: AnimationFeatureFlags.gd (New File)
Order: Task 1.
Add static booleans enable_step_1_additive_hit_react through enable_step_9_glove_secondary.
File 2: FightSimScriptHook.gd (New File - Forced Action Hook)
Order: Task 2.
Feeds scripted commands into the 20 Hz simulation tick to bypass the AI during benchmarks.
Signatures:
queue_action(timestamp_sec: float, fighter_id: int, action_type: String, params: Dictionary) -> void
step_tick(sim_current_time: float) -> void
load_deterministic_benchmark_sequence() -> void
File 3: FightStagePlayer.gd
Order: Task 3 (Step 2, Step 6).
Signatures:
update_locomotion(world_velocity: Vector3, facing_dir: Vector3, delta: float) -> void
sample_punch_phase_timeline(progress: float) -> Dictionary
set_strike_clip_with_hermite(anim_name: String, speed: float) -> void
File 4: FightAliveStance.gd
Order: Task 4 (Steps 1, 3, 4, 5, 7, 8, 9).
Signatures:
apply_hit_impulse(impact_dir: Vector3, damage: float, is_head: bool) -> void
evaluate_proximity_flinch(head_pos: Vector3, glove_pos: Vector3, vel: Vector3, struck: bool) -> void
apply_kinetic_chain(skel: Skeleton3D, strike: String, norm_time: float, pelvis: int, ankle: int) -> void
solve_look_at(skel: Skeleton3D, opp_chest: Vector3, neck: int, head: int, delta: float) -> void
compute_center_of_mass(skel: Skeleton3D, pelvis: int) -> Vector3
apply_fatigue_posture(skel: Skeleton3D, stam: float, spine: int, l_wrist: int, r_wrist: int) -> void
apply_glove_secondary_dynamics(skel: Skeleton3D, l_hand: int, r_hand: int, delta: float) -> void
File 5: FightDebugOverlay.gd (New File)
Order: Task 5.
Mountable via one line inside FightWorldLiveScreen.gd: add_child(FightDebugOverlay.new())
Signatures:
_unhandled_input(event: InputEvent) -> void (Detects KEY_F3)
draw_3d_geometry() -> void (Renders BoS, CoM, Flinch Cylinder, Discs)
update_telemetry(red_stats: Dictionary, blue_stats: Dictionary) -> void
File 6: record_room.gd
Order: Task 6.
Signatures:
init_csv_writer(file_path: String) -> void
log_frame_record(frame_idx: int, time_sec: float, red_data: Dictionary, blue_data: Dictionary) -> void
flush_and_close() -> void
File 7: Tools/smooth_metrics.py
Order: Task 7.
Implements mathematical regression tests against the generated CSV log.
Part 2: Exact CSV Schema & Benchmark Grading Engine
1. Frame CSV Schema (record_room.gd)

Written at fixed rendering intervals (60 Hz / 16.667 ms). 25 total columns per row.

| Column Header | Unit | Data Type | Description |
| :--- | :--- | :--- | :--- |
| frame_idx | integer | int | Monotonic render frame counter |
| timestamp_sec | seconds | float | Exact benchmark elapsed time (0.000 to 30.000) |
| vance_pelvis_pos_x | meters | float | World X coordinate of Vance pelvis |
| vance_pelvis_pos_z | meters | float | World Z coordinate of Vance pelvis |
| vance_lead_foot_locked | boolean | int | 1 = Planted (Locked), 0 = Free |
| vance_rear_foot_locked | boolean | int | 1 = Planted (Locked), 0 = Free |
| vance_stance_width | meters | float | Euclidean distance between lead and rear foot joints |
| vance_pelvis_rot_yaw_deg | degrees | float | Local yaw of pelvis |
| vance_gaze_error_deg | degrees | float | Angular error between head forward ray and opponent chest |
| vance_strike_phase | enum string | string | NONE, EXTEND, APEX_HOLD, RETRACT |
| vance_fist_velocity_m_s | m/s | float | Active striking fist velocity magnitude |
| vance_com_dist_to_bos_edge | meters | float | Signed distance from CoM ground projection to BoS polygon edge |
| miller_pelvis_pos_x | meters | float | World X coordinate of Miller pelvis |
| miller_pelvis_pos_z | meters | float | World Z coordinate of Miller pelvis |
| miller_lead_foot_locked | boolean | int | 1 = Planted (Locked), 0 = Free |
| miller_rear_foot_locked | boolean | int | 1 = Planted (Locked), 0 = Free |
| miller_stance_width | meters | float | Euclidean distance between lead and rear foot joints |
| miller_head_rot_delta_deg | degrees | float | Angular deflection from hit reaction/flinch layer |
| miller_head_disp_cm | centimeters | float | Head translation deviation from baseline clip |
| miller_glove_to_head_dist | meters | float | Minimum distance between inbound glove and head |
| miller_wrist_vert_drop_cm | centimeters | float | Vertical drop offset applied to guard wrists |
| miller_glove_spring_offset | centimeters | float | Magnitude of secondary spring-damper offset |
| sim_event_name | identifier | string | Simulation log tag (e.g., HIT_LANDED, MISS_WHIFF, NONE) |
| sim_damage_value | damage pts | float | Simulation nominal damage score |
| camera_accel_jerk | m/s^3 | float | Camera jerk value to confirm camera smoothness |

2. Benchmark Grading Harness (Tools/smooth_metrics.py)
```
#!/usr/bin/env python3
"""
FightCamp Animation Benchmark Automated Grading Script.
Reads frame telemetry CSV generated across the 30-second benchmark segment.
"""

import sys
import pandas as pd
import numpy as np

WINDOW_TOLERANCE_SEC = 0.05

def segment_window(df: pd.DataFrame, t_start: float, t_end: float) -> pd.DataFrame:
    return df[(df['timestamp_sec'] >= (t_start - WINDOW_TOLERANCE_SEC)) & 
              (df['timestamp_sec'] <= (t_end + WINDOW_TOLERANCE_SEC))]

def test_step_1_hit_react(df: pd.DataFrame) -> tuple[bool, float, str]:
    # Window: 08.50s - 12.50s (Landed Straight Right on Miller)
    win = segment_window(df, 8.50, 12.50)
    hit_events = win[win['sim_event_name'] == 'HIT_LANDED']
    if hit_events.empty:
        return False, 0.0, "No hit event logged in simulation window."
    
    max_deflection = 0.0
    for idx, hit in hit_events.iterrows():
        hit_time = hit['timestamp_sec']
        # Look 50 ms (3 frames) post hit
        post_window = win[(win['timestamp_sec'] >= hit_time) & (win['timestamp_sec'] <= hit_time + 0.050)]
        peak = post_window['miller_head_rot_delta_deg'].max()
        max_deflection = max(max_deflection, peak)
        
    passed = max_deflection >= 4.0
    return passed, max_deflection, "Head deflection >= 4.0 deg within 50 ms of hit."

def test_step_2_locomotion(df: pd.DataFrame) -> tuple[bool, float, str]:
    # Window: 12.50s - 16.50s (Lateral steps and pivoting)
    win = segment_window(df, 12.50, 16.50)
    # Check for hopping: both feet unlocked during locomotion
    vance_both_unlocked = win[(win['vance
```
(answer ends here - Ludo's output limit)

Ludo's next offers (round 13): the complete typed GDScript for all nine steps without ellipses; the full smooth_metrics.py with exact
windows, thresholds and report output; a clean overlay mockup beneath the HUD cards showing every metric panel.

## Claude's verdict (round 13) - taken
- KEEP as the build spec for BENCH1 + HUMAN1-6: the per-step maths and numbers (hit snap 45 ms + 180 ms return, head/neck/spine
  0.6/0.3/0.1, flinch cylinder 28 x 35 cm, rise 60 / fall 160 ms, pelvis yaw 22/48/58 deg peaking at 0.45 of the strike, look-at
  omega 14 + clamps 42/22, S-curve exponent 2.8 + apex hold + Hermite retract, fatigue below 30 stamina, glove spring omega 28 zeta 0.72
  clamp 1.8 cm), the 7-file build order, the FightSimScriptHook signatures, and the 25-column CSV (columns named red_/blue_ instead of
  vance_/miller_ so any cast works).
- CORRECT before building (our record wins over the pseudocode):
  (a) Flags: NOT a new AnimationFeatureFlags class defaulting TRUE - every step is one of OUR game switches and defaults OFF, so headless
      tests stay the control arm (CLAUDE.md s6) and the operator turns each on after its video.
  (b) Step 2: no AnimationTree/BlendSpace2D conversion (S192 ruling, TASK_ANIM_SMOOTH1 prefab note) - foot-lock phases come from
      FightStagePlayer's own clip time; the lead-first / rear-first push-pull rule is kept.
  (c) Bone writes: the pseudocode multiplies onto get_bone_pose_* every frame, which ACCUMULATES unless the clip rewrites the pose first.
      Our additive layers apply on top of the freshly sampled pose once per frame (the modifier pass; see memory
      feedback_modifiers_run_only_in_the_deferred_update) - Codex proves it with a test that an idle fighter's head does not drift.
  (d) Step 1's return "exp(-4t)cos(3t)" is under-damped, not critically damped as its comment says - keep the look (a small overshoot
      reads human) but name it right. Step 7's CoM proxy (pelvis/torso/head 45/35/20) is a first cut - check against the mesh later.
  (e) Bone names: our MPFB rig names differ from "Spine2"/"Head" - map them through the existing rig map, never find_bone literals.
  (f) smooth_metrics.py: stdlib + numpy if pandas is not installed (check first); report = one line per step
      "STEP n PASS|FAIL measured=<x> threshold=<y>".
- No round 13b for the full code: the spec is enough for Codex; Ludo's credits go to grappling (round 14).
