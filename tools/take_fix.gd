extends SceneTree
## S334 TAKEFIX1: clean the six OFF takes that fling the rear arm back. Find the window where fling exceeds the margin,
## then blend the hips and upper body rotations toward the plain take over that window with smooth ramps.
## Headless:
##   <godot.exe> --headless --path . --script res://tools/take_fix.gd

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BAKED := "res://assets/anim/baked/"
const FLING_MARGIN_M := 0.10
const RAMP_S := 0.10

## The six OFF takes and their plain takes.
const FIXES := {
	"mc_Box1_M3_Left_Hook_Hurt_FT.res": "mc_Box1_M3_Left_Hook.res",
	"mc_Box1_M3_Left_Hook_Miss.res": "mc_Box1_M3_Left_Hook.res",
	"mc_Box1_M3_Right_Cross_Miss.res": "mc_Box1_M3_Right_Cross.res",
	"mc_Box1_M3_Right_Hook_Hard_FT.res": "mc_Box1_M3_Right_Hook.res",
	"mc_Box1_M3_Right_Hook_Miss.res": "mc_Box1_M3_Right_Hook.res",
	"mc_Box1_M3_Right_Uppercut_Hurt_FT.res": "mc_Box1_M3_Right_Uppercut.res",
}

## Bones to blend (hips and upper body including rear arm, NOT the punching left arm).
const BLEND_BONES := ["Hips", "Spine", "spine_02", "Chest", "spine_04", "UpperChest",
	"RightShoulder", "RightUpperArm", "RightLowerArm", "RightHand"]
## Leg chains for lift fixes.
const RIGHT_LEG := ["RightUpperLeg", "RightLowerLeg", "RightFoot"]
const LEFT_LEG := ["LeftUpperLeg", "LeftLowerLeg", "LeftFoot"]


func _initialize() -> void:
	var stage: Node3D = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "blue"})
	stage.set_process(false)
	var bx: Dictionary = stage.boxers[0]
	
	for take_file in FIXES.keys():
		var plain_file: String = FIXES[take_file]
		var take_name: String = take_file.replace(".res", "").replace("mc_Box1_M3_", "pro_").to_lower()
		var plain_name: String = plain_file.replace(".res", "").replace("mc_Box1_M3_", "pro_").to_lower()
		
		# Load animations
		var take_path: String = BAKED + take_file
		var take_anim: Animation = load(take_path)
		var plain_anim: Animation = load(BAKED + plain_file)
		
		# Find the window where fling exceeds margin
		var fling_window := _find_fling_window(stage, bx, take_name, plain_name)
		
		if fling_window.size() > 0:
			# Blend bones in the window with ramps
			var blended_count := _blend_window(take_anim, plain_anim, BLEND_BONES, fling_window[0], fling_window[1])
			print("TAKE FIX %s fling window %.2f-%.2f blended %d keys" % [take_file, fling_window[0], fling_window[1], blended_count])
		
		# Find the window where lift exceeds margin
		var lift_window := _find_lift_window(stage, bx, take_name, plain_name)
		
		if lift_window.size() > 0:
			var leg_chain: Array = LEFT_LEG if lift_window[2] == "left" else RIGHT_LEG
			var blended_count := _blend_window(take_anim, plain_anim, leg_chain, lift_window[0], lift_window[1])
			print("TAKE FIX %s lift window %.2f-%.2f (%s leg) blended %d keys" % [take_file, lift_window[0], lift_window[1], lift_window[2], blended_count])
		
		if fling_window.size() > 0 or lift_window.size() > 0:
			# Save
			var err := ResourceSaver.save(take_anim, take_path)
			if err != OK:
				print("TAKE FIX %s SAVE ERROR %d" % [take_file, err])
				continue
		else:
			print("TAKE FIX %s no windows found" % take_file)
	
	print("TAKE FIX DONE")
	quit(0)


## Find the window [t_start, t_end] where fling exceeds the margin.
func _find_fling_window(stage: Node3D, bx: Dictionary, take: String, plain: String) -> Array:
	var ap: AnimationPlayer = bx["ap"]
	var length: float = ap.get_animation(take).length
	var t := 0.0
	var start := -1.0
	var end := -1.0
	while t <= length:
		var take_hips: Vector3 = Stage.IdleMatch.pose_point(bx, take, t, "Hips")
		var take_hand: Vector3 = Stage.IdleMatch.pose_point(bx, take, t, "RightHand")
		var plain_hips: Vector3 = Stage.IdleMatch.pose_point(bx, plain, t, "Hips")
		var plain_hand: Vector3 = Stage.IdleMatch.pose_point(bx, plain, t, "RightHand")
		var take_fling: float = take_hips.z - take_hand.z
		var plain_fling: float = plain_hips.z - plain_hand.z
		if take_fling > plain_fling + FLING_MARGIN_M:
			if start < 0.0:
				start = t
			end = t
		t += 1.0 / 15.0
	if start < 0.0:
		return []
	return [maxf(0.0, start - 0.05), minf(length, end + 0.05)]


## Find the window [t_start, t_end, "left"/"right"] where lift exceeds the margin.
func _find_lift_window(stage: Node3D, bx: Dictionary, take: String, plain: String) -> Array:
	var ap: AnimationPlayer = bx["ap"]
	var length: float = ap.get_animation(take).length
	var t := 0.0
	var start := -1.0
	var end := -1.0
	var foot_name := ""
	while t <= length:
		for foot in ["LeftFoot", "RightFoot"]:
			var take_pos: Vector3 = Stage.IdleMatch.pose_point(bx, take, t, foot)
			var plain_pos: Vector3 = Stage.IdleMatch.pose_point(bx, plain, t, foot)
			var guard_pos: Vector3 = Stage.IdleMatch.pose_point(bx, take, 0.0, foot)
			var take_lift: float = take_pos.y - guard_pos.y
			var plain_lift: float = plain_pos.y - guard_pos.y
			if take_lift > plain_lift + 0.08:  # LIFT_MARGIN_M
				if start < 0.0:
					start = t
					foot_name = foot
				end = t
		t += 1.0 / 15.0
	if start < 0.0:
		return []
	return [maxf(0.0, start - 0.05), minf(length, end + 0.05), "left" if foot_name.contains("Left") else "right"]


## Blend rotation keys in `bones` over [t_start, t_end] with smooth ramps.
func _blend_window(take: Animation, plain: Animation, bones: Array, t_start: float, t_end: float) -> int:
	var total_keys := 0
	for bone in bones:
		var track_idx := -1
		for i in take.get_track_count():
			if take.track_get_type(i) == Animation.TYPE_ROTATION_3D and str(take.track_get_path(i)) == bone:
				track_idx = i
				break
		if track_idx < 0:
			continue
		
		var plain_idx := -1
		for i in plain.get_track_count():
			if plain.track_get_type(i) == Animation.TYPE_ROTATION_3D and str(plain.track_get_path(i)) == bone:
				plain_idx = i
				break
		if plain_idx < 0:
			continue
		
		for k in take.track_get_key_count(track_idx):
			var kt: float = take.track_get_key_time(track_idx, k)
			if kt >= t_start and kt <= t_end:
				var take_val: Quaternion = take.rotation_track_interpolate(track_idx, kt)
				var plain_val: Quaternion = plain.rotation_track_interpolate(plain_idx, kt)
				var base_weight: float = _ramp_weight(kt, t_start, t_end)
				# Use higher weight for right arm (doesn't affect punching hand), lower for hips/spine
				var weight: float = base_weight * (0.8 if bone in ["Hips", "Spine", "spine_02", "Chest", "spine_04", "UpperChest"] else 1.0)
				var blended: Quaternion = take_val.slerp(plain_val, weight)
				take.track_set_key_value(track_idx, k, blended)
				total_keys += 1
	
	return total_keys


## Smooth weight: 0 at edges, 1 in middle, with RAMP_S transitions.
func _ramp_weight(t: float, t_start: float, t_end: float) -> float:
	var duration: float = t_end - t_start
	if duration <= 0.0:
		return 0.0
	var local_t: float = t - t_start
	if local_t < RAMP_S:
		return local_t / RAMP_S
	if local_t > duration - RAMP_S:
		return (duration - local_t) / RAMP_S
	return 1.0
