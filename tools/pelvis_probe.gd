extends SceneTree
## PELVIS1: measure the rig's pelvis the same way tools/stance_raw.py measures the source take.
## Same stage as tests/guard_knee_test.gd (two boxers, same settle), same bones, same six numbers:
## ball_to_ball along / across, rear_toe_yaw_vs_lead, hips_above_balls, pelvis_line_vs_front, rear_ankle_vs_hip_across.
## Front = the lead foot's toe line (flattened horizontal). No fix, just the measure.
## Run: python ops/Tools/godot_slot.py run --who pelvis1 -- <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/pelvis_probe.gd

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const DT := 1.0 / 60.0
const WARMUP := 60
const FRAMES := 300
const SETTLE_S := 0.5
const MIN_FRAMES := 15

var drawn: Array = [[], []]


func _watch(skel: Skeleton3D, idx: int, rig: Node) -> void:
	skel.skeleton_updated.connect(func():
		var xf := skel.global_transform
		var hips_id := skel.find_bone("Hips")
		var hips_pos := xf * skel.get_bone_global_pose(hips_id).origin if hips_id >= 0 else Vector3.ZERO
		var legs: Array = []
		for j in 2:
			var ids: Array = rig._legs[j]["ids"]
			legs.append({"hip": xf * skel.get_bone_global_pose(ids[0]).origin,
				"knee": xf * skel.get_bone_global_pose(ids[1]).origin,
				"ankle": xf * skel.get_bone_global_pose(ids[2]).origin,
				"ball": xf * skel.get_bone_global_pose(ids[3]).origin})
		drawn[idx] = {"legs": legs, "hips": hips_pos})


func _initialize() -> void:
	Engine.max_fps = 60
	var stage: Node3D = Stage.new()
	stage.process_mode = Node.PROCESS_MODE_DISABLED
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_01.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_02.glb", "corner": "blue", "stance": "southpaw"})
	stage.set_process(false)
	stage.process_mode = Node.PROCESS_MODE_INHERIT
	var bx: Array = stage.boxers
	for i in 2:
		_watch(bx[i]["skel"], i, bx[i]["rig"])
	var sums := []
	var counts := []
	for i in 2:
		sums.append({"along": 0.0, "across": 0.0, "yaw": 0.0, "hip_h": 0.0, "pel_ang": 0.0, "ra": 0.0})
		counts.append(0)
	var age := [0.0, 0.0]
	for f in WARMUP + FRAMES:
		stage._process(DT)
		await process_frame
		if f < WARMUP:
			continue
		for i in 2:
			age[i] += root.get_process_delta_time() if str((bx[i]["ap"] as AnimationPlayer).current_animation) == "pro_idle" else 0.0
			if age[i] < SETTLE_S or (drawn[i] as Dictionary).is_empty():
				continue
			var data: Dictionary = drawn[i]
			var legs: Array = data["legs"]
			var lead_toe := (legs[0]["ball"] as Vector3) - (legs[0]["ankle"] as Vector3)
			var rear_toe := (legs[1]["ball"] as Vector3) - (legs[1]["ankle"] as Vector3)
			lead_toe.y = 0.0
			rear_toe.y = 0.0
			if lead_toe.length() < 1e-5 or rear_toe.length() < 1e-5:
				continue
			lead_toe = lead_toe.normalized()
			rear_toe = rear_toe.normalized()
			var mean_dir := (lead_toe + rear_toe).normalized()
			var is_lead_left := (legs[0]["ankle"] as Vector3 - legs[1]["ankle"] as Vector3).dot(mean_dir) > 0.0
			var front := lead_toe if is_lead_left else rear_toe
			var rf := rear_toe if is_lead_left else lead_toe
			var across := Vector3(-front.z, 0.0, front.x)
			var d := (legs[1]["ball"] as Vector3) - (legs[0]["ball"] as Vector3)
			d.y = 0.0
			var along := absf(d.dot(front))
			var across_v := absf(d.dot(across))
			var yaw := rad_to_deg(atan2(front.cross(rf).y, front.dot(rf)))
			var hips_y := (data["hips"] as Vector3).y
			var min_ball_y := minf((legs[0]["ball"] as Vector3).y, (legs[1]["ball"] as Vector3).y)
			var hip_h := hips_y - min_ball_y
			var pelvis := (legs[0]["hip"] as Vector3) - (legs[1]["hip"] as Vector3)
			pelvis.y = 0.0
			var pel_ang := rad_to_deg(atan2(front.cross(pelvis).y, front.dot(pelvis)))
			var ra := ((legs[1]["ankle"] as Vector3) - (legs[1]["hip"] as Vector3)).dot(across)
			sums[i]["along"] += along
			sums[i]["across"] += across_v
			sums[i]["yaw"] += yaw
			sums[i]["hip_h"] += hip_h
			sums[i]["pel_ang"] += pel_ang
			sums[i]["ra"] += ra
			# S473: leg length (hip-knee + knee-ankle, mean of both legs) so the hips height can be read as a share of the leg
			var leg := 0.0
			for lg in legs:
				leg += ((lg["knee"] as Vector3) - (lg["hip"] as Vector3)).length() + ((lg["ankle"] as Vector3) - (lg["knee"] as Vector3)).length()
			sums[i]["leg"] = float(sums[i].get("leg", 0.0)) + leg * 0.5
			for j in 2:
				var lg: Dictionary = legs[j]
				var ll := ((lg["knee"] as Vector3) - (lg["hip"] as Vector3)).length() + ((lg["ankle"] as Vector3) - (lg["knee"] as Vector3)).length()
				var key := "st_lead" if (j == 0) == is_lead_left else "st_rear"
				sums[i][key] = float(sums[i].get(key, 0.0)) + ((lg["ankle"] as Vector3) - (lg["hip"] as Vector3)).length() / ll
			counts[i] += 1
	for i in 2:
		if counts[i] < MIN_FRAMES:
			print("PELVIS boxer=%d FRAMES=%d (need %d)" % [i, counts[i], MIN_FRAMES])
			continue
		var n := float(counts[i])
		print("PELVIS boxer=%d ball_to_ball_along=%.3f" % [i, sums[i]["along"] / n])
		print("PELVIS boxer=%d ball_to_ball_across=%.3f" % [i, sums[i]["across"] / n])
		print("PELVIS boxer=%d rear_toe_yaw_vs_lead=%.1f" % [i, sums[i]["yaw"] / n])
		print("PELVIS boxer=%d hips_above_balls=%.3f" % [i, sums[i]["hip_h"] / n])
		print("PELVIS boxer=%d pelvis_line_vs_front=%.1f" % [i, sums[i]["pel_ang"] / n])
		print("PELVIS boxer=%d rear_ankle_vs_hip_across=%.3f" % [i, sums[i]["ra"] / n])
		print("PELVIS boxer=%d leg_straight lead=%.3f rear=%.3f" % [i, sums[i]["st_lead"] / n, sums[i]["st_rear"] / n])
		print("PELVIS boxer=%d leg_len=%.3f hips_over_leg=%.3f" % [i, sums[i]["leg"] / n, sums[i]["hip_h"] / sums[i]["leg"]])
	print("PELVIS_PROBE done")
	quit(0)
