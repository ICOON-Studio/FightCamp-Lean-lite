extends SceneTree
## S408 BOXERLEAN1: how far does the guard lean forward? Neck minus hips, against her facing, in degrees, + = forward.
## Her facing: horizontal, square to the hip line, on the side her toes point. Same maths as the footwork test's lean
## (atan2(tor.dot(fwd), tor.y)) and the Blender source reader (tools/torso_lean_raw.py).
##   <godot.exe> --headless --path . --audio-driver Dummy --fixed-fps 30 --script res://tools/torso_lean_probe.gd -- [mode=clip|game] [glb0=..]
## CLIP: pro_idle, every SkeletonModifier3D off (the bake alone). GAME: rig on, GuardWeave off (the fight as wired).
const Stage := preload("res://scripts/fight3d/FightStage.gd")
const DT := 1.0 / 30.0
const WARMUP := 30
const FRAMES := 240


func _arg(k: String, dflt: String) -> String:
	for a in OS.get_cmdline_user_args():
		if a.begins_with(k + "="):
			return a.substr(k.length() + 1)
	return dflt


static func lean_deg(neck: Vector3, hips: Vector3, fwd: Vector3) -> float:
	var tor := neck - hips
	return rad_to_deg(atan2(tor.dot(fwd), tor.y))


static func facing_from_feet(ltoe: Vector3, lankle: Vector3, rtoe: Vector3, rankle: Vector3) -> Vector3:
	var hl := lankle - rankle
	hl.y = 0.0
	if hl.length() < 1e-5:
		return Vector3.FORWARD
	var f := Vector3(-hl.z, 0.0, hl.x)
	if f.length() < 1e-5:
		return Vector3.FORWARD
	f = f.normalized()
	var toes := (ltoe - lankle) + (rtoe - rankle)
	toes.y = 0.0
	if f.dot(toes) < 0.0:
		f = -f
	return f


static func selftest() -> bool:
	var ok := true
	var hips := Vector3(0, 1, 0)
	var neck_fwd := hips + Vector3(0, cos(deg_to_rad(10)), sin(deg_to_rad(10))).normalized()
	var fwd := Vector3(0, 0, 1)
	ok = ok and absf(lean_deg(neck_fwd, hips, fwd) - 10.0) < 0.1
	var neck_back := hips + Vector3(0, cos(deg_to_rad(10)), -sin(deg_to_rad(10))).normalized()
	ok = ok and absf(lean_deg(neck_back, hips, fwd) - (-10.0)) < 0.1
	var neck_up := hips + Vector3(0, 1, 0)
	ok = ok and absf(lean_deg(neck_up, hips, fwd)) < 0.1
	var lt := Vector3(0.1, 0, 0.5)
	var la := Vector3(0.1, 0, 0)
	var rt := Vector3(-0.1, 0, 0.5)
	var ra := Vector3(-0.1, 0, 0)
	var f_t := facing_from_feet(lt, la, rt, ra)
	ok = ok and f_t.z > 0.0
	var neck_t := hips + Vector3(0, cos(deg_to_rad(10)), 0) + f_t * sin(deg_to_rad(10))
	ok = ok and absf(lean_deg(neck_t, hips, f_t) - 10.0) < 0.1
	var yaw := deg_to_rad(30)
	var lt2 := Vector3(cos(yaw) * 0.1, 0, sin(yaw) * 0.5)
	var la2 := Vector3(cos(yaw) * 0.1, 0, sin(yaw) * 0.0)
	var rt2 := Vector3(-cos(yaw) * 0.1 + sin(yaw) * 0.0, 0, -sin(yaw) * 0.1 + cos(yaw) * 0.5)
	var ra2 := Vector3(-cos(yaw) * 0.1 + sin(yaw) * 0.0, 0, -sin(yaw) * 0.1 + cos(yaw) * 0.0)
	var f2 := facing_from_feet(lt2, la2, rt2, ra2)
	var neck2 := hips + Vector3(0, cos(deg_to_rad(10)), 0) + f2 * sin(deg_to_rad(10))
	ok = ok and absf(lean_deg(neck2, hips, f2) - 10.0) < 0.1
	print("TORSOLEAN_SIGN %s" % ("ok" if ok else "FAIL"))
	return ok


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


static func _stats(arr: Array) -> Dictionary:
	if arr.is_empty():
		return {"min": 0.0, "mean": 0.0, "max": 0.0}
	var mn: float = arr[0]
	var mx: float = arr[0]
	var s := 0.0
	for v in arr:
		mn = minf(mn, float(v))
		mx = maxf(mx, float(v))
		s += float(v)
	return {"min": mn, "mean": s / float(arr.size()), "max": mx}


func _measure(mode: String, glb0: String) -> void:
	var glb1 := "res://assets/models/metahuman/mh_boxer_02.glb"
	if glb0 == "res://assets/models/metahuman/mh_boxer_02.glb":
		glb1 = "res://assets/models/metahuman/mh_boxer_01.glb"
	var stage: Node3D = Stage.new()
	stage.process_mode = Node.PROCESS_MODE_DISABLED
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": glb0, "corner": "red"}, {"glb": glb1, "corner": "blue", "stance": "southpaw"})
	stage.set_process(false)
	stage.process_mode = Node.PROCESS_MODE_INHERIT
	var bx: Array = stage.boxers
	for i in 2:
		var skel: Skeleton3D = bx[i]["skel"]
		if mode == "clip":
			_switch_off(skel, "all")
		else:
			if bx[i].get("weave") != null:
				(bx[i]["weave"] as SkeletonModifier3D).active = false
		var ap: AnimationPlayer = bx[i]["ap"]
		if ap.has_animation("pro_idle"):
			ap.play("pro_idle")
			ap.seek(0.0, true)
			ap.get_animation("pro_idle").loop_mode = Animation.LOOP_LINEAR
	var draws: Array = [{}, {}]
	for i in 2:
		var skel: Skeleton3D = bx[i]["skel"]
		skel.skeleton_updated.connect(func():
			var xf := skel.global_transform
			var lt := xf * skel.get_bone_global_pose(skel.find_bone("LeftToes")).origin
			var la := xf * skel.get_bone_global_pose(skel.find_bone("LeftFoot")).origin
			var rt := xf * skel.get_bone_global_pose(skel.find_bone("RightToes")).origin
			var ra := xf * skel.get_bone_global_pose(skel.find_bone("RightFoot")).origin
			draws[i] = {
				"neck": xf * skel.get_bone_global_pose(skel.find_bone("Neck")).origin,
				"hips": xf * skel.get_bone_global_pose(skel.find_bone("Hips")).origin,
				"fwd": facing_from_feet(lt, la, rt, ra),
			})
	var clips: Array = [{}, {}]
	var leans: Array = [[], []]
	var clip_len_0: float = (bx[0]["ap"] as AnimationPlayer).get_animation("pro_idle").length if (bx[0]["ap"] as AnimationPlayer).has_animation("pro_idle") else 0.0
	var clip_len_1: float = (bx[1]["ap"] as AnimationPlayer).get_animation("pro_idle").length if (bx[1]["ap"] as AnimationPlayer).has_animation("pro_idle") else 0.0
	for f in WARMUP + FRAMES:
		if mode == "clip":
			for i in 2:
				var ap: AnimationPlayer = bx[i]["ap"]
				var cl := clip_len_0 if i == 0 else clip_len_1
				if cl > 0.0:
					ap.play("pro_idle")
					ap.seek(fmod(f * DT, cl), true)
					ap.pause()
		else:
			stage._process(DT)
		await process_frame
		if f < WARMUP:
			continue
		for i in 2:
			var clip := str((bx[i]["ap"] as AnimationPlayer).current_animation)
			if mode == "clip":
				clip = "pro_idle"
			(clips[i] as Dictionary)[clip] = int((clips[i] as Dictionary).get(clip, 0)) + 1
			if clip != "pro_idle":
				continue
			if draws[i].is_empty():
				continue
			var d: Dictionary = draws[i]
			leans[i].append(lean_deg(d["neck"], d["hips"], d["fwd"]))
	for i in 2:
		var corner := "red" if i == 0 else "blue"
		var body_name := glb0 if i == 0 else glb1
		print("TORSOLEAN_CLIPS %s %s rig_w=%.2f %s" % [mode, corner, float(bx[i]["rig"].w) if bx[i].get("rig") != null else 0.0, str(clips[i])])
		var s := _stats(leans[i])
		print("TORSOLEAN %s %s body=%s frames=%d min=%.1f mean=%.1f max=%.1f" % [mode, corner, body_name.get_file(), (leans[i] as Array).size(), float(s["min"]), float(s["mean"]), float(s["max"])])


func _initialize() -> void:
	Engine.max_fps = 30
	var mode := _arg("mode", "clip")
	var glb0 := _arg("glb0", "res://assets/models/metahuman/mh_boxer_01.glb")
	if mode != "selftest":
		if not selftest():
			quit(1)
			return
	else:
		selftest()
		quit(0)
		return
	await _measure(mode, glb0)
	quit(0)
