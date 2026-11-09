extends SceneTree
## S408: the guard knee, measured as a knock-knee really is: how far the knee sits out of the plane through hip, ankle and
## foot direction. + = towards her own midline (the anatomical side, never a guess from the hip line). A straight leg in a
## wide stance reads 0 here; the KNEERAW rulers read it as knock-kneed (knee against the ankle only).
## Only frames that play a guard clip count, each setup is its own process, and it says which clips it saw.
##   <godot.exe> --headless --path . --audio-driver Dummy --fixed-fps 30 --script res://tools/knee_plane_probe.gd -- [arm=GAME] [off=all|<names>] [phase=rest] [glb0=..] [glb1=..]
##   windowed on the hidden desktop, a front-on picture of each boxer in guard: -- still=<dir>
## Same maths on the source take: tools/knee_plane_raw.py.

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const DT := 1.0 / 30.0
const WARMUP := 30
const FRAMES := 240

var drawn: Array = [[], []]   # per boxer: [lead, rear], each {hip, knee, ankle, ball, left}


func _arg(k: String, dflt: String) -> String:
	for a in OS.get_cmdline_user_args():
		if a.begins_with(k + "="):
			return a.substr(k.length() + 1)
	return dflt


static func off_plane(hip: Vector3, knee: Vector3, ankle: Vector3, ball: Vector3, is_left: bool) -> float:
	var foot := ball - ankle
	foot.y = 0.0
	if foot.length() < 1e-5:
		return 0.0
	foot = foot.normalized()
	var n := (ankle - hip).normalized().cross(foot).normalized()
	var right := foot.cross(Vector3.UP).normalized()
	var medial := right if is_left else -right
	if n.dot(medial) < 0.0:
		n = -n
	return (knee - hip).dot(n)


static func flex(hip: Vector3, knee: Vector3, ankle: Vector3) -> float:
	return 180.0 - rad_to_deg((hip - knee).angle_to(ankle - knee))


## Facing +Z in Godot her left is +X.
static func selftest() -> bool:
	var ok := true
	var h := Vector3(0.1, 1.0, 0.0)
	var a := Vector3(0.1, 0.0, 0.0)
	var b := Vector3(0.1, 0.0, 0.15)
	ok = ok and absf(off_plane(h, Vector3(0.1, 0.5, 0.0), a, b, true)) < 1e-4   # straight
	ok = ok and absf(off_plane(h, Vector3(0.1, 0.5, 0.1), a, b, true)) < 1e-4   # bent over the toes
	ok = ok and off_plane(h, Vector3(0.05, 0.5, 0.0), a, b, true) > 0.04        # left knee in
	ok = ok and off_plane(h, Vector3(0.15, 0.5, 0.0), a, b, true) < -0.04       # left knee out
	var hr := Vector3(-0.1, 1.0, 0.0)
	var ar := Vector3(-0.1, 0.0, 0.0)
	var br := Vector3(-0.1, 0.0, 0.15)
	ok = ok and off_plane(hr, Vector3(-0.05, 0.5, 0.0), ar, br, false) > 0.04   # right knee in
	var wide_a := Vector3(0.4, 0.0, 0.0)
	var wide_b := Vector3(0.4, 0.0, 0.15)
	ok = ok and absf(off_plane(h, Vector3(0.25, 0.5, 0.0), wide_a, wide_b, true)) < 1e-4   # straight leg, wide stance
	print("KNEEPLANE_SIGN %s" % ("ok" if ok else "FAIL"))
	return ok


func _watch(skel: Skeleton3D, idx: int, rig: Node) -> void:
	skel.skeleton_updated.connect(func():   # the pose as drawn: read only inside this signal
		var xf := skel.global_transform
		var legs: Array = []
		for j in 2:
			var ids: Array = rig._legs[j]["ids"]   # already [lead, rear] for her stance
			legs.append({"hip": xf * skel.get_bone_global_pose(ids[0]).origin, "knee": xf * skel.get_bone_global_pose(ids[1]).origin,
				"ankle": xf * skel.get_bone_global_pose(ids[2]).origin, "ball": xf * skel.get_bone_global_pose(ids[3]).origin,
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


func _modifiers(skel: Skeleton3D) -> String:
	var out: Array = []
	for c in skel.get_children():
		if c is SkeletonModifier3D:
			var m := c as SkeletonModifier3D
			out.append("%s:%s:%.2f" % [_label(c), "on" if m.active else "off", m.influence])
	return ", ".join(out)


static func _is_guard(clip: String) -> bool:
	return clip.begins_with("pro_idle") or clip.begins_with("rk_guard")


func _initialize() -> void:
	if not selftest():
		quit(1)
		return
	if OS.get_cmdline_user_args().has("selftest"):
		quit(0)
		return
	var still := _arg("still", "")
	if still != "":
		root.size = Vector2i(1920, 1080)
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
	if still != "":
		await _stills(stage, bx, still)
	else:
		await _measure(stage, bx)
	quit(0)


func _measure(stage: Node3D, bx: Array) -> void:
	var arm := _arg("arm", "GAME")
	var off := _arg("off", "")
	var phase := _arg("phase", "")
	var rows: Array = []
	var clips: Array = [{}, {}]
	var rig_w: Array = [0.0, 0.0]
	for i in 2:
		rows.append([{"off": [], "norm": [], "flex": []}, {"off": [], "norm": [], "flex": []}])
	for f in WARMUP + FRAMES:
		if phase != "":
			stage.aim({"phase": phase, "who": -1, "move": "jab"})
		for i in 2:
			var hit := _switch_off(bx[i]["skel"], off)
			if f == 0 and off != "":
				print("KNEEPLANE_OFF %s boxer=%d switched %d: %s" % [arm, i, hit.size(), ", ".join(hit)])
		stage._process(DT)
		await process_frame
		if f == WARMUP:
			print("KNEEPLANE_LAYERS %s red: %s" % [arm, _modifiers(bx[0]["skel"])])
		if f < WARMUP:
			continue
		for i in 2:
			var clip := str((bx[i]["ap"] as AnimationPlayer).current_animation)
			(clips[i] as Dictionary)[clip] = int((clips[i] as Dictionary).get(clip, 0)) + 1
			rig_w[i] = float(rig_w[i]) + float(bx[i]["rig"].w) / float(FRAMES)
			if not _is_guard(clip) or (drawn[i] as Array).size() < 2:
				continue
			for j in 2:
				var d: Dictionary = drawn[i][j]
				var v := off_plane(d["hip"], d["knee"], d["ankle"], d["ball"], d["left"])
				var leg: float = (d["hip"] as Vector3).distance_to(d["ankle"])
				rows[i][j]["off"].append(v)
				rows[i][j]["norm"].append(v / maxf(leg, 1e-4))
				rows[i][j]["flex"].append(flex(d["hip"], d["knee"], d["ankle"]))
	for i in 2:
		var corner := "red orthodox" if i == 0 else "blue southpaw"
		print("KNEEPLANE_CLIPS %s %s rig_w=%.2f %s" % [arm, corner, float(rig_w[i]), str(clips[i])])
		for j in 2:
			var r: Dictionary = rows[i][j]
			var o := _stats(r["off"])
			var n := _stats(r["norm"])
			var fx := _stats(r["flex"])
			print("KNEEPLANE %s %s %s frames=%d off=%.4f(%.4f..%.4f) norm=%.4f(%.4f..%.4f) flex=%.1f" % [arm, corner, "lead" if j == 0 else "rear",
				(r["off"] as Array).size(), o["mean"], o["min"], o["max"], n["mean"], n["min"], n["max"], fx["mean"]])


func _stats(arr: Array) -> Dictionary:
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


func _stills(stage: Node3D, bx: Array, dir: String) -> void:
	DirAccess.make_dir_recursive_absolute(dir)
	var cam: Camera3D = stage.camera
	cam.fov = 46.0
	for i in 2:
		(bx[1 - i]["skel"] as Node3D).visible = false
		(bx[i]["skel"] as Node3D).visible = true
		for f in 150:
			stage._process(DT)
			await process_frame
			if f >= 40 and _is_guard(str((bx[i]["ap"] as AnimationPlayer).current_animation)):
				break
		var skel: Skeleton3D = bx[i]["skel"]
		var legs: Array = drawn[i]
		var mid: Vector3 = ((legs[0]["hip"] as Vector3) + (legs[1]["hip"] as Vector3)) * 0.5
		var other: Vector3 = (bx[1 - i]["skel"] as Node3D).global_position
		var fwd := other - skel.global_position
		fwd.y = 0.0
		fwd = fwd.normalized()
		var side := fwd.cross(Vector3.UP).normalized()
		var shots := {"front": fwd * 2.6, "front_left": (fwd + side * 0.7).normalized() * 2.6, "front_right": (fwd - side * 0.7).normalized() * 2.6}
		for name_shot in shots:
			cam.global_position = Vector3(mid.x, 0.95, mid.z) + (shots[name_shot] as Vector3)
			cam.look_at(Vector3(mid.x, 0.92, mid.z), Vector3.UP)
			await process_frame
			await RenderingServer.frame_post_draw
			var path := dir.path_join("knee_%s_%s.png" % ["red_orthodox" if i == 0 else "blue_southpaw", name_shot])
			root.get_texture().get_image().save_png(path)
			print("wrote ", path, " clip=", (bx[i]["ap"] as AnimationPlayer).current_animation)
