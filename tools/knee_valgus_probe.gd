extends SceneTree
## KNEERULER1: the valgus ruler from tests/boxer_footwork_test.gd (_read, line ~388) on the raw take (rig off) and rig on.
## Same maths: the shin's tilt in the foot's frontal plane, + = knee on the hip's side (valgus).
## Plays the guard idle, collects per-frame valgus per leg per boxer, reports worst and mean over settled guard frames.
##   <godot.exe> --headless --path . --audio-driver Dummy --fixed-fps 30 --script res://tools/knee_valgus_probe.gd -- [off=all]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const DT := 1.0 / 30.0
const WARMUP := 30
const FRAMES := 240

var drawn: Array = [[], []]


func _arg(k: String, dflt: String) -> String:
	for a in OS.get_cmdline_user_args():
		if a.begins_with(k + "="):
			return a.substr(k.length() + 1)
	return dflt


static func _is_guard(clip: String) -> bool:
	return clip.begins_with("pro_idle") or clip.begins_with("rk_guard")


func _watch(skel: Skeleton3D, idx: int, rig: Node) -> void:
	skel.skeleton_updated.connect(func():
		var xf := skel.global_transform
		var legs: Array = []
		for j in 2:
			var ids: Array = rig._legs[j]["ids"]
			legs.append({"hip": xf * skel.get_bone_global_pose(ids[0]).origin,
				"knee": xf * skel.get_bone_global_pose(ids[1]).origin,
				"ankle": xf * skel.get_bone_global_pose(ids[2]).origin,
				"ball": xf * skel.get_bone_global_pose(ids[3]).origin,
				"left": skel.get_bone_name(ids[0]).begins_with("Left")})
		drawn[idx] = legs)


func _label(c: Node) -> String:
	var sc: Variant = c.get_script()
	return str(c.name) if sc == null else (sc as Script).resource_path.get_file().get_basename()


func _switch_off(skel: Skeleton3D, off: String) -> Array:
	var hit: Array = []
	if off == "":
		return hit
	var words := off.split(",", false)
	for c in skel.get_children():
		if not (c is SkeletonModifier3D):
			continue
		var lab := _label(c)
		var match_it := off == "all"
		for w in words:
			match_it = match_it or lab.to_lower().contains(w.to_lower())
		if match_it:
			(c as SkeletonModifier3D).active = false
			hit.append(lab)
	return hit


static func valgus(hip: Vector3, knee: Vector3, ankle: Vector3, ball: Vector3) -> float:
	var foot := Vector2(ball.x - ankle.x, ball.z - ankle.z).normalized()
	var lat := Vector3(foot.x, 0.0, foot.y).cross(Vector3.UP)
	var shin := Vector2((knee - ankle).dot(lat), (knee - ankle).y)
	return rad_to_deg(atan2(shin.x * signf((hip - ankle).dot(lat)), shin.y))


func _initialize() -> void:
	var stage: Node3D = Stage.new()
	stage.process_mode = Node.PROCESS_MODE_DISABLED
	root.add_child(stage)
	await process_frame
	var glb0 := _arg("glb0", "res://assets/models/metahuman/mh_boxer_01.glb")
	var glb1 := _arg("glb1", "res://assets/models/metahuman/mh_boxer_02.glb")
	stage.setup({"glb": glb0, "corner": "red"}, {"glb": glb1, "corner": "blue", "stance": "southpaw"})
	stage.set_process(false)
	stage.process_mode = Node.PROCESS_MODE_INHERIT
	var bx: Array = stage.boxers
	for i in 2:
		_watch(bx[i]["skel"], i, bx[i]["rig"])
	var off := _arg("off", "")
	var vals: Array = []
	for i in 2:
		vals.append([[], []])
	for f in WARMUP + FRAMES:
		for i in 2:
			var hit := _switch_off(bx[i]["skel"], off)
			if f == 0 and off != "":
				print("VALGUS_OFF boxer=%d switched %d: %s" % [i, hit.size(), ", ".join(hit)])
		stage._process(DT)
		await process_frame
		if f < WARMUP:
			continue
		for i in 2:
			var clip := str((bx[i]["ap"] as AnimationPlayer).current_animation)
			if not _is_guard(clip) or (drawn[i] as Array).size() < 2:
				continue
			for j in 2:
				var d: Dictionary = drawn[i][j]
				var v := valgus(d["hip"], d["knee"], d["ankle"], d["ball"])
				(vals[i][j] as Array).append(v)
	for i in 2:
		var corner := "red orthodox" if i == 0 else "blue southpaw"
		for j in 2:
			var arr: Array = vals[i][j]
			if arr.is_empty():
				print("VALGUS %s %s frames=0" % [corner, "lead" if j == 0 else "rear"])
				continue
			var mn: float = arr[0]
			var mx: float = arr[0]
			var s := 0.0
			for v in arr:
				mn = minf(mn, float(v))
				mx = maxf(mx, float(v))
				s += float(v)
			print("VALGUS %s %s frames=%d mean=%.1f worst=%.1f min=%.1f" % [corner, "lead" if j == 0 else "rear", arr.size(), s / float(arr.size()), mx, mn])
	quit(0)
