extends SceneTree
const MH := preload("res://scripts/fight3d/MHRig.gd")
const Plant := preload("res://tools/owned_mocap_plant.gd")
const Smooth := preload("res://tools/owned_mocap_smooth.gd")
const Fit := preload("res://tools/owned_mocap_fit.gd")
const TEMPLATE := "res://assets/anim/baked/mc_Box1_M3_Idle.res"
const FPS := 30.0

const AIM := {
	"Spine": "Chest", "Chest": "UpperChest", "UpperChest": "Neck", "Neck": "Head",
	"LeftShoulder": "LeftUpperArm", "LeftUpperArm": "LeftLowerArm", "LeftLowerArm": "LeftHand", "LeftHand": "LeftHandEnd",
	"RightShoulder": "RightUpperArm", "RightUpperArm": "RightLowerArm", "RightLowerArm": "RightHand", "RightHand": "RightHandEnd",
	"LeftUpperLeg": "LeftLowerLeg", "LeftLowerLeg": "LeftFoot", "LeftFoot": "LeftToes",
	"RightUpperLeg": "RightLowerLeg", "RightLowerLeg": "RightFoot", "RightFoot": "RightToes",
}
const OUR_END := {"LeftHandEnd": "LeftMiddleProximal", "RightHandEnd": "RightMiddleProximal"}
const MAPPED := ["Hips", "Spine", "Chest", "UpperChest", "Neck", "Head",
	"LeftShoulder", "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightShoulder", "RightUpperArm", "RightLowerArm", "RightHand",
	"LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "LeftToes", "RightUpperLeg", "RightLowerLeg", "RightFoot", "RightToes"]

const MIXAMO := {
	"Hips": "Hips", "Spine": "Spine", "Chest": "Spine1", "UpperChest": "Spine2", "Neck": "Neck", "Head": "Head",
	"HeadTop": "HeadTop_End",
	"LeftShoulder": "LeftShoulder", "LeftUpperArm": "LeftArm", "LeftLowerArm": "LeftForeArm", "LeftHand": "LeftHand",
	"LeftHandEnd": "LeftHandMiddle1",
	"RightShoulder": "RightShoulder", "RightUpperArm": "RightArm", "RightLowerArm": "RightForeArm", "RightHand": "RightHand",
	"RightHandEnd": "RightHandMiddle1",
	"LeftUpperLeg": "LeftUpLeg", "LeftLowerLeg": "LeftLeg", "LeftFoot": "LeftFoot", "LeftToes": "LeftToeBase",
	"LeftToesEnd": "LeftToe_End",
	"RightUpperLeg": "RightUpLeg", "RightLowerLeg": "RightLeg", "RightFoot": "RightFoot", "RightToes": "RightToeBase",
	"RightToesEnd": "RightToe_End",
}
const UNREAL := {
	"Hips": "pelvis", "Spine": "spine_01", "Chest": "spine_02", "UpperChest": "spine_03", "Neck": "neck_01", "Head": "head",
	"LeftShoulder": "clavicle_l", "LeftUpperArm": "upperarm_l", "LeftLowerArm": "lowerarm_l", "LeftHand": "hand_l",
	"LeftHandEnd": "middle_01_l",
	"RightShoulder": "clavicle_r", "RightUpperArm": "upperarm_r", "RightLowerArm": "lowerarm_r", "RightHand": "hand_r",
	"RightHandEnd": "middle_01_r",
	"LeftUpperLeg": "thigh_l", "LeftLowerLeg": "calf_l", "LeftFoot": "foot_l", "LeftToes": "ball_l",
	"RightUpperLeg": "thigh_r", "RightLowerLeg": "calf_r", "RightFoot": "foot_r", "RightToes": "ball_r",
}
const TRACKED := ["Hips", "LeftFoot", "RightFoot", "LeftToes", "RightToes", "Head", "LeftHand", "RightHand", "LeftUpperLeg", "RightUpperLeg"]
func _initialize() -> void:
	var args := {}
	var mode := ""
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		if s.contains("="):
			args[s.get_slice("=", 0)] = s.substr(s.find("=") + 1)
		else:
			mode = s
	_passes = int(args.get("passes", "4"))
	_final_fit = str(args.get("final_fit", "1")) != "0"
	_follow = int(args.get("follow", "2"))
	_final_smooth = str(args.get("final_smooth", "0")) != "0"
	_facing = str(args.get("facing", "0" if mode == "json_batch" else "1")) != "0"
	_fit_bare = str(args.get("fitbare", "0")) != "0"
	Fit.room_soft = float(args.get("room", str(Fit.ROOM)))
	Fit.room_hard = float(args.get("hard", str(Fit.HARD_ROOM)))
	Fit.exact_round = str(args.get("exact", "0")) != "0"
	Fit.double_pull = str(args.get("dbl", "1")) != "0"
	Fit.pin_last = str(args.get("pinlast", "0")) != "0"
	Fit.lock_planted = str(args.get("lock", "0")) != "0"
	Fit.hard_hz = float(args.get("hardhz", str(Fit.HARD_HZ)))
	Fit.still_plants = str(args.get("still", "1")) != "0"
	Fit.smooth_target = float(args.get("target", "0.05"))
	Fit.pre_smooth = str(args.get("presmooth", "0")) != "0"
	if mode in ["batch", "json_batch"]:
		var folder := str(args["in"])
		var extension := ".json" if mode == "json_batch" else ".fbx"
		var errors := 0
		var files := DirAccess.get_files_at(folder)
		var out_dir := str(args.get("dir", "res://assets/anim/baked"))
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(out_dir))
		files.sort()
		for file in files:
			if not file.to_lower().ends_with(extension):
				continue
			var stem := "mc_" + file.get_basename().replace("_ ", "_").replace(" ", "_")
			var out := out_dir.path_join(stem + ".res")
			var old := out.get_basename() + "_old.res"
			if ResourceLoader.exists(out) and not ResourceLoader.exists(old):
				errors += 1 if ResourceSaver.save((load(out) as Animation).duplicate(true), old) != OK else 0
			var one := _from_json(folder.path_join(file), 0.0, -1.0) if mode == "json_batch" else _from_fbx(folder.path_join(file), 0.0, -1.0)
			if one.is_empty():
				errors += 1
				continue
			one["hold"] = []
			_pin = str(args.get("pin", "1")) != "0"
			_smooth = str(args.get("smooth", "1")) != "0"
			errors += _bake(one, out, str(args.get("glb", "mh_boxer_10")), stem)
		print("OWNEDMOCAP BATCH clips=%d errors=%d" % [files.size(), errors])
		quit(1 if errors else 0)
		return
	var src := {}
	match mode:
		"fbx":
			src = _from_fbx(str(args["in"]), float(args.get("t0", "0")), float(args.get("t1", "-1")))
		"json":
			src = _from_json(str(args["in"]), float(args.get("t0", "0")), float(args.get("t1", "-1")))
		_:
			print("OWNEDMOCAP usage: fbx|json in=<file> out=<stem> [t0=] [t1=] [glb=] [dir=]")
			quit(2)
			return
	if src.is_empty():
		quit(1)
		return
	src["hold"] = Array(str(args.get("hold", "LeftHand,RightHand,LeftToes,RightToes" if mode == "json" else "")).split(",", false))
	var dir := str(args.get("dir", "res://assets/anim/baked"))
	_pin = str(args.get("pin", "1")) != "0"
	_smooth = str(args.get("smooth", "1")) != "0"
	quit(_bake(src, dir.path_join(str(args["out"]) + ".res"), str(args.get("glb", "mh_boxer_08")), str(args["out"])))
static func _chain_xf(n: Node) -> Transform3D:
	var x := Transform3D.IDENTITY
	var cur := n
	while cur != null:
		if cur is Node3D:
			x = (cur as Node3D).transform * x
		cur = cur.get_parent()
	return x
static func _strip(n: String) -> String:
	var re := RegEx.create_from_string("^mixamorig\\d*[:_]")
	return re.sub(n, "")
func _from_fbx(path: String, t0: float, t1: float) -> Dictionary:
	var doc := FBXDocument.new()
	var st := FBXState.new()
	if doc.append_from_file(path, st) != OK:
		print("OWNEDMOCAP FAILED to read ", path)
		return {}
	var scene := doc.generate_scene(st)
	root.add_child(scene)
	var skel := scene.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var ap := scene.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
	var anim: Animation = null
	for nm in ap.get_animation_list():
		var a := ap.get_animation(nm)
		if anim == null or a.length > anim.length:
			anim = a
	var names := {}
	for i in skel.get_bone_count():
		names[_strip(skel.get_bone_name(i))] = i
	var rig: Dictionary = MIXAMO if names.has("LeftUpLeg") else UNREAL
	if rig == UNREAL and names.has("spine_05"):
		rig = UNREAL.duplicate()
		rig["Chest"] = "spine_03"
		rig["UpperChest"] = "spine_05"
	var idx := {}
	for ours in rig:
		if names.has(rig[ours]):
			idx[ours] = names[rig[ours]]
	for need in MAPPED:
		if not idx.has(need):
			print("OWNEDMOCAP FAILED: %s has no bone for %s (%s)" % [path, need, rig.get(need, "?")])
			return {}
	var tr := {}
	for t in anim.get_track_count():
		var p := anim.track_get_path(t)
		if p.get_subname_count() == 0:
			continue
		var b := skel.find_bone(str(p.get_subname(0)))
		if b >= 0:
			tr["%d|%d" % [b, anim.track_get_type(t)]] = t
	var t_first := Smooth.fbx_cubic(anim, tr.values(), tr.get("%d|%d" % [idx["Hips"], Animation.TYPE_POSITION_3D], -1))
	var sg := _chain_xf(skel)
	var rest_g := []
	for i in skel.get_bone_count():
		rest_g.append(sg * skel.get_bone_global_rest(i))
	var rest := {}
	for ours in idx:
		rest[ours] = (rest_g[idx[ours]] as Transform3D).origin
	var end := anim.length if t1 < 0.0 else minf(t1, anim.length)
	var frames := []
	var t := maxf(t0, t_first)
	while t <= end + 0.0001:
		var g := []
		g.resize(skel.get_bone_count())
		for i in skel.get_bone_count():
			var pos := skel.get_bone_rest(i).origin
			var rot := skel.get_bone_rest(i).basis.get_rotation_quaternion()
			var scl := skel.get_bone_rest(i).basis.get_scale()
			var k := "%d|%d" % [i, Animation.TYPE_POSITION_3D]
			if tr.has(k):
				pos = anim.position_track_interpolate(tr[k], t)
			k = "%d|%d" % [i, Animation.TYPE_ROTATION_3D]
			if tr.has(k):
				rot = anim.rotation_track_interpolate(tr[k], t)
			k = "%d|%d" % [i, Animation.TYPE_SCALE_3D]
			if tr.has(k):
				scl = anim.scale_track_interpolate(tr[k], t)
			var local := Transform3D(Basis(rot).scaled(scl), pos)
			var par := skel.get_bone_parent(i)
			g[i] = (g[par] as Transform3D) * local if par >= 0 else local
		var D := {}
		var P := {}
		for ours in MAPPED:
			var w := (sg * (g[idx[ours]] as Transform3D)).basis.get_rotation_quaternion()
			D[ours] = (w * (rest_g[idx[ours]] as Transform3D).basis.get_rotation_quaternion().inverse()).normalized()
		for j in TRACKED:
			P[j] = (sg * (g[idx[j]] as Transform3D)).origin
		frames.append({"D": D, "P": P})
		t += 1.0 / FPS
	scene.free()
	print("OWNEDMOCAP source %s: rig %s, take %.2f s, used %.2f-%.2f s, %d frames" % [
		path.get_file(), "mixamo" if rig == MIXAMO else "unreal", anim.length, t0, end, frames.size()])
	return {"name": path.get_file(), "rest": rest, "frames": frames}
func _from_json(path: String, t0: float, t1: float) -> Dictionary:
	var d: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(path))
	var rest := {}
	for j in d["rest"]:
		var v: Array = d["rest"][j]
		rest[j] = Vector3(v[0], v[1], v[2])
	var frames := []
	var n: int = (d["frames"] as Array).size()
	var i0 := int(round(t0 * FPS))
	var i1 := n if t1 < 0.0 else mini(n, int(round(t1 * FPS)) + 1)
	for i in range(i0, i1):
		var f: Dictionary = d["frames"][i]
		var D := {}
		var P := {}
		for b in f["D"]:
			var q: Array = f["D"][b]
			D[b] = Quaternion(q[0], q[1], q[2], q[3]).normalized()
		for j in f["P"]:
			var v: Array = f["P"][j]
			P[j] = Vector3(v[0], v[1], v[2])
		frames.append({"D": D, "P": P})
	print("OWNEDMOCAP source %s: %d frames (%.2f-%.2f s)" % [str(d["source"]), frames.size(), t0, (i1 - 1) / FPS])
	return {"name": str(d["source"]), "rest": rest, "frames": frames}
static func _frame_basis(lateral: Vector3, up: Vector3) -> Basis:
	var u := up.normalized()
	var l := (lateral - u * lateral.dot(u)).normalized()
	return Basis(l, u, l.cross(u).normalized())
static func _yaw_about(up: Vector3, from: Vector3, to: Vector3) -> Quaternion:
	var a := (from - up * from.dot(up)).normalized()
	var b := (to - up * to.dot(up)).normalized()
	return Quaternion(up, a.signed_angle_to(b, up))
var _pin := true; var _smooth := true; var _passes := 4; var _final_fit := true; var _follow := 2; var _final_smooth := false; var _fit_bare := false; var _facing := true
var _fk_par: Array = []; var _fk_rot: Array = []; var _fk_pos: Array = []
func _g(i: int) -> Transform3D:
	var x := Transform3D(Basis(_fk_rot[i] as Quaternion), _fk_pos[i] as Vector3)
	var p: int = _fk_par[i]
	while p >= 0:
		x = Transform3D(Basis(_fk_rot[p] as Quaternion), _fk_pos[p] as Vector3) * x
		p = _fk_par[p]
	return x
func _bake(src: Dictionary, out: String, glb: String, stem: String) -> int:
	var body := MH.load_fighter("res://assets/models/metahuman/%s.glb" % glb)
	root.add_child(body)
	var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var up_t := (_chain_xf(skel).basis.inverse() * Vector3.UP).normalized()
	var bi := {}
	for n in MAPPED:
		bi[n] = skel.find_bone(n)
	for e in OUR_END:
		bi[e] = skel.find_bone(OUR_END[e])
	var rest_t := {}
	for n in bi:
		rest_t[n] = skel.get_bone_global_rest(bi[n]).origin
	var rest_s: Dictionary = src["rest"]
	var frames: Array = src["frames"]
	var leg0: float = (rest_s["LeftUpperLeg"] - rest_s["LeftLowerLeg"]).length() + (rest_s["LeftLowerLeg"] - rest_s["LeftFoot"]).length()
	var cut := 0
	while frames.size() > 2 and ((frames[1]["P"]["Hips"] as Vector3) - (frames[0]["P"]["Hips"] as Vector3)).length() > 0.1 * leg0:
		frames.pop_front()
		cut += 1
	if cut > 0:
		print("OWNEDMOCAP dropped %d leading frame(s): the hips jump on the take's first key" % cut)
	var bs := _frame_basis(rest_s["LeftUpperLeg"] - rest_s["RightUpperLeg"], Vector3.UP)
	var bt := _frame_basis(rest_t["LeftUpperLeg"] - rest_t["RightUpperLeg"], up_t)
	var Q := (bt * bs.inverse()).get_rotation_quaternion()
	var fwd_s := bs.z
	var acc := Vector3.ZERO
	for i in mini(frames.size(), int(FPS)):
		acc += (frames[i]["D"]["Hips"] as Quaternion) * fwd_s
	var Y0 := _yaw_about(Vector3.UP, acc, fwd_s)
	# RETARGET2B: a bought take is already on its mark; Y0 squares the hips to the camera, which turns a bladed boxer side-on.
	var S := (Q * (Y0 if _facing else Quaternion.IDENTITY)).normalized()
	var Qi := Q.inverse()
	var leg_s := 0.0
	var leg_t := 0.0
	for side in ["Left", "Right"]:
		leg_s += (rest_s[side + "UpperLeg"] - rest_s[side + "LowerLeg"]).length() + (rest_s[side + "LowerLeg"] - rest_s[side + "Foot"]).length()
		leg_t += (rest_t[side + "UpperLeg"] - rest_t[side + "LowerLeg"]).length() + (rest_t[side + "LowerLeg"] - rest_t[side + "Foot"]).length()
	var k := leg_t / leg_s
	var lows: Array = []
	for f in frames:
		lows.append(minf((f["P"]["LeftToes"] as Vector3).y, (f["P"]["RightToes"] as Vector3).y))
	lows.sort()
	var floor_s: float = lows[int(lows.size() * 0.1)]
	var toe_t := minf(rest_t["LeftToes"].dot(up_t), rest_t["RightToes"].dot(up_t))
	var hips_t: Vector3 = rest_t["Hips"]
	var h0: Vector3 = frames[0]["P"]["Hips"]
	var hj_off_s: Vector3 = (rest_s["LeftUpperLeg"] + rest_s["RightUpperLeg"]) * 0.5 - rest_s["Hips"]
	_fk_par.clear()
	_fk_rot.clear()
	_fk_pos.clear()
	for i in skel.get_bone_count():
		_fk_par.append(skel.get_bone_parent(i))
		_fk_rot.append(skel.get_bone_rest(i).basis.get_rotation_quaternion())
		_fk_pos.append(skel.get_bone_rest(i).origin)
	var order: Array = MAPPED.duplicate()
	order.sort_custom(func(a, b): return bi[a] < bi[b])
	for n in order:
		if not AIM.has(n) or not rest_s.has(AIM[n]):
			continue
		var b: int = bi[n]
		var want: Vector3 = Q * (rest_s[AIM[n]] - rest_s[n])
		var have: Vector3 = _g(bi[AIM[n]]).origin - _g(b).origin
		var swing := Quaternion(have.normalized(), want.normalized())
		var g := swing * _g(b).basis.get_rotation_quaternion()
		var par := skel.get_bone_parent(b)
		var pg := _g(par).basis.get_rotation_quaternion() if par >= 0 else Quaternion.IDENTITY
		_fk_rot[b] = (pg.inverse() * g).normalized()
	var ref_local := []
	for i in skel.get_bone_count():
		ref_local.append(_fk_rot[i])
	var gref := {}
	for n in MAPPED:
		gref[n] = _g(bi[n]).basis.get_rotation_quaternion()
	var tmpl := load(TEMPLATE) as Animation
	var anim := Animation.new()
	anim.length = (frames.size() - 1) / FPS
	anim.step = 1.0 / FPS
	var tracks := {}
	for t in tmpl.get_track_count():
		var nt := anim.add_track(tmpl.track_get_type(t))
		anim.track_set_path(nt, tmpl.track_get_path(t))
		anim.track_set_interpolation_type(nt, tmpl.track_get_interpolation_type(t))
		tracks[nt] = skel.find_bone(str(tmpl.track_get_path(t)))
	var hb: int = bi["Hips"]
	var hpar := skel.get_bone_parent(hb)
	var hrest := skel.get_bone_rest(hb).origin
	var feet := {"L": [], "R": []}; var hps := []
	var offs := {"L": [], "R": []}; var corr := []
	for fi in frames.size():
		var f: Dictionary = frames[fi]
		for i in skel.get_bone_count():
			_fk_rot[i] = ref_local[i]
		for n in order:
			if (src["hold"] as Array).has(n):
				continue
			var b: int = bi[n]
			var g := (S * (f["D"][n] as Quaternion) * Qi) * (gref[n] as Quaternion)
			var par := skel.get_bone_parent(b)
			var pg := _g(par).basis.get_rotation_quaternion() if par >= 0 else Quaternion.IDENTITY
			_fk_rot[b] = (pg.inverse() * g).normalized()
		var hs: Vector3 = f["P"]["Hips"]
		var dxz := Vector3(hs.x - h0.x, 0.0, hs.z - h0.z)
		var hj_y: float = hs.y + ((f["D"]["Hips"] as Quaternion) * hj_off_s).y
		var rise := (hj_y - floor_s) * k
		_fk_pos[hb] = hrest
		var off_t: Vector3 = (_g(bi["LeftUpperLeg"]).origin + _g(bi["RightUpperLeg"]).origin) * 0.5 - _g(hb).origin
		var hp := hips_t - up_t * hips_t.dot(up_t) + up_t * (toe_t + rise - off_t.dot(up_t)) + (S * dxz) * k
		var local_pos := (_g(hpar).affine_inverse() * hp) if hpar >= 0 else hp
		_fk_pos[hb] = local_pos
		var time := fi / FPS
		for nt in tracks:
			var b: int = tracks[nt]
			if anim.track_get_type(nt) == Animation.TYPE_ROTATION_3D:
				anim.rotation_track_insert_key(nt, time, _fk_rot[b])
		hps.append(hp)
		var wsum := 0.0
		var acc_c := Vector3.ZERO
		for side in ["L", "R"]:
			var nm := "Left" if side == "L" else "Right"
			var toe := _g(bi[nm + "Toes"]).origin
			offs[side].append(toe - hp)
			var ps: Vector3 = f["P"][nm + "Toes"]
			var w := clampf(1.0 - (ps.y - floor_s) / 0.03, 0.0, 1.0)
			if w > 0.0:
				var want_xz: Vector3 = (S * Vector3(ps.x - h0.x, 0.0, ps.z - h0.z)) * k + (hips_t - up_t * hips_t.dot(up_t))
				var d: Vector3 = want_xz - toe
				d -= up_t * d.dot(up_t)
				acc_c += d * w
				wsum += w
		corr.append(acc_c / wsum if wsum > 0.05 else null)
	var n_f := corr.size()
	var filled := []
	filled.resize(n_f)
	var last_i := -1
	for i in n_f:
		if corr[i] != null:
			if last_i < 0:
				for j in i:
					filled[j] = corr[i]
			else:
				for j in range(last_i + 1, i):
					filled[j] = (corr[last_i] as Vector3).lerp(corr[i], float(j - last_i) / float(i - last_i))
			filled[i] = corr[i]
			last_i = i
	for j in range(last_i + 1, n_f):
		filled[j] = corr[last_i] if last_i >= 0 else Vector3.ZERO
	var hpos_t := -1
	for nt in tracks:
		if anim.track_get_type(nt) == Animation.TYPE_POSITION_3D:
			hpos_t = nt
	for i in n_f:
		var sm := Vector3.ZERO
		var cnt := 0
		for j in range(maxi(0, i - 3), mini(n_f, i + 4)):
			sm += filled[j]
			cnt += 1
		var hp_final: Vector3 = (hps[i] as Vector3) + sm / cnt
		anim.position_track_insert_key(hpos_t, i / FPS, hp_final - hrest)
		for side in ["L", "R"]:
			feet[side].append(hp_final + (offs[side][i] as Vector3))
	var raw_h: Array = []
	for side in feet:
		for p in feet[side]:
			raw_h.append((p as Vector3).dot(up_t))
	raw_h.sort()
	var lift: float = toe_t - float(raw_h[int(raw_h.size() * 0.05)])
	for nt in tracks:
		if anim.track_get_type(nt) == Animation.TYPE_POSITION_3D:
			for kk in anim.track_get_key_count(nt):
				anim.track_set_key_value(nt, kk, (anim.track_get_key_value(nt, kk) as Vector3) + up_t * lift)
	for side in feet:
		for i in (feet[side] as Array).size():
			feet[side][i] = (feet[side][i] as Vector3) + up_t * lift
	var punch: Dictionary = Plant.punch_exempt(anim, skel)
	if _smooth:
		Smooth.smooth(anim, [], punch)
	var pinned: Dictionary = Plant.pin(anim, skel, up_t) if _pin else {}
	if _smooth and _pin:
		Smooth.smooth(anim, ["LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"], {}, 0.05)
		pinned = Plant.pin(anim, skel, up_t)
	var fit_tr: Dictionary = Plant._tracks(anim)
	var fit_want := {}
	var fit_on := {}
	var goals := Fit.targets(anim, skel, fit_tr, bi, frames, S, k)
	fit_want = goals["want"]
	fit_on = goals["on"]
	for side in ["Left", "Right"]:
		var leg := [bi[side + "UpperLeg"], bi[side + "LowerLeg"], bi[side + "Foot"]]
		for fi in frames.size():
			Plant._leg_ik(anim, skel, fit_tr, side, leg, fi, (fit_want[side][fi] as Vector3) - Plant._glob(skel, anim, fit_tr, leg[2], fi).origin)
	if _smooth or _fit_bare:
		for _pass in (_passes if _smooth else 0):
			Smooth.smooth(anim, ["Hips", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
				"RightUpperLeg", "RightLowerLeg", "RightFoot"], {}, 0.05)
		Plant.pin(anim, skel, up_t)
		var hips_track: int = fit_tr["Hips@pos"]
		var parent_basis := skel.get_bone_global_rest(hpar).basis if hpar >= 0 else Basis.IDENTITY
		for fi in frames.size():
			var correction := Vector3.ZERO
			var count := 0
			for side in ["Left", "Right"]:
				var foot: int = bi[side + "Foot"]
				var current: Vector3 = Plant._glob(skel, anim, fit_tr, foot, fi).origin
				var delta: Vector3 = fit_want[side][fi] - current
				correction.y += delta.y * 0.5
				if fit_on[side][fi]:
					correction += Vector3(delta.x, 0.0, delta.z)
					count += 1
			if count > 0:
				correction = Vector3(correction.x / count, correction.y, correction.z / count)
			var hp_key: Vector3 = anim.track_get_key_value(hips_track, fi)
			anim.track_set_key_value(hips_track, fi, hp_key + parent_basis.inverse() * correction)
		if _final_fit:
			Fit.finish(anim, skel, fit_tr, bi, frames, k, fit_want, fit_on, _follow, up_t)
			if _final_smooth:
				Smooth.smooth(anim, ["LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"], {}, Fit.smooth_target)
	if ResourceSaver.save(anim, out) != OK:
		print("OWNEDMOCAP FAILED to save ", out)
		return 1
	print("OWNEDMOCAP %s %s secs=%.2f pinned L=%d R=%d k=%.3f -> %s" % [stem, str(src["name"]), anim.length, int(pinned.get("Left", 0)), int(pinned.get("Right", 0)), k, out])
	body.free()
	return 0
