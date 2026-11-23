extends SceneTree
## BODYCROSS1 (S542, ops/research/TASK_BODYCROSS1.md step 4): THE BODY CROSS, AUTHORED OFFLINE. No take on disk throws
## the rear straight to the body (tools/pics2d_bodycross_probe.gd: the nearest straight right arm stops 0.29 m over the
## ribs). This bakes ONE new take from the plain cross the game shows today (the ActionForge-legged Punch PRO cross,
## assets/anim/af_retarget/mc_Box1_M3_Right_Cross.res) with the level change in its own keys - no runtime layer:
##   - the hips sink DROP_M (the knees bend; both feet stay exactly where the take has them: a two-bone leg solve
##     per key, the knee kept over its toes), eased in from the take's first key to the contact, held, eased out;
##   - the trunk hinges forward LEAN_DEG (pelvis, spine, chest share it), the neck and head give most of it back so
##     the eyes stay on the other man;
##   - the punching arm's line is pitched from the shoulder by what is left (a degree or two), solved so the glove front is at the
##     other man's rib point (the census's rule) on the contact key - the elbow, forearm and fist are the take's own;
##   - the load (first LOAD_S of the take) is played LOAD_STRETCH x slower, so the sink is not faster than a body falls;
##     the drive itself keeps the take's speed.
## Reference: ops/research/REFERENCE_PUNCH_TARGETS_S439.md (Blood & Canvas body forms: fist 0.30-0.40 m lower than the
## head form, head down ~0.22 m, same timing within one key) and our own bought body take (pro_body_shot: hips down
## 0.17-0.22 m, knees 94-119 deg, head down 0.27-0.30 m). Saved beside the other takes as mc_Box1_M3_Body_Cross.res
## (FightClips loads it as pro_body_cross; ClipCensus.STEMS files it under the family body_cross, which no fight
## picker asks for: only the pictures use it).
##   <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/pics2d_bodycross_bake.gd -- [dry] [drop=0.18] [lean=10]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const PR := preload("res://scripts/fight3d/PunchReach.gd")
const Orbit := preload("res://tools/clip_orbit.gd")
const SRC := "res://assets/anim/af_retarget/mc_Box1_M3_Right_Cross.res"
const SRC_NAME := "pro_right_cross"
const OUT := "res://assets/anim/baked/mc_Box1_M3_Body_Cross.res"
const KNEE_REF := ["pro_body_shot", 0.45]   # a take and a time with both knees well bent: the knees' hinge axes are read there
const SRC_CONTACT_S := 0.30   # the plain cross's furthest reach (clip_db contact_s 0.3, the probe's peak)
const LOAD_S := 0.1333        # the take's load, before its drive
const LOAD_STRETCH := 1.45
const HOLD_S := 0.07
const OUT_S := 0.38
const LEAN_SHARE := {"Hips": 0.4, "Spine": 0.3, "Chest": 0.3}
const FACE_BACK := {"Neck": -0.4, "Head": -0.4}
const ARM_MAX_DEG := 30.0

var skel: Skeleton3D
var ap: AnimationPlayer
var fwd := Vector3.BACK      # skeleton space
var side := Vector3.RIGHT
var front := 0.15
var scale := 1.0
var drop_m := 0.18
var lean_deg := 10.0
var hinge := {}              # "Left" / "Right" -> the knee's hinge axis in the thigh bone's own frame
var shift := 0.0


func _arg(key: String, def: float) -> float:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return float(str(a).substr(key.length() + 1))
	return def


func _initialize() -> void:
	var dry := OS.get_cmdline_user_args().has("dry")
	drop_m = _arg("drop", drop_m)
	lean_deg = _arg("lean", lean_deg)
	FightClips.as_bought = true
	var st: Node3D = Stage.new()
	root.add_child(st)
	await process_frame
	st.setup({"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "blue"})
	await process_frame
	st.set_process(false)
	var bx: Dictionary = st.boxers[0]
	skel = bx["skel"]
	ap = bx["ap"]
	scale = (bx["node"] as Node3D).scale.x
	front = float(bx.get("front", 0.15))
	Orbit.strip_modifiers(skel)
	var inv := skel.global_transform.basis.orthonormalized().inverse()
	fwd = (inv * (bx["node"] as Node3D).global_transform.basis.z).normalized()
	side = Vector3.UP.cross(fwd).normalized()
	# the other man's rib height (the census's rule), in the thrower's skeleton space
	var d: Dictionary = st.boxers[1]
	var ds: Skeleton3D = d["skel"]
	Orbit.strip_modifiers(ds)
	var dap: AnimationPlayer = d["ap"]
	dap.play(BeatClips.first(BeatClips.GUARD, dap.has_animation))
	dap.seek(0.0, true)
	var ribs_world: float = (ds.global_transform * ds.get_bone_global_pose(ds.find_bone("Chest")).origin).y - 0.14 * float((d["node"] as Node3D).scale.x)
	var ribs_y: float = (ribs_world - skel.global_transform.origin.y) / skel.global_transform.basis.get_scale().y
	_hinges()
	var src := load(SRC) as Animation
	var out := src.duplicate(true) as Animation
	shift = LOAD_S * (LOAD_STRETCH - 1.0)
	var tc := _warp(SRC_CONTACT_S)
	out.length = src.length + shift
	var times: Array = []
	for k in src.track_get_key_count(0):
		times.append(src.track_get_key_time(0, k))
	# the arm's pitch on the contact key, solved so the glove front is at rib height there
	var lo := -ARM_MAX_DEG
	var hi := ARM_MAX_DEG
	for it in 24:
		var mid := (lo + hi) * 0.5
		_edit(SRC_CONTACT_S, 1.0, mid)
		if _glove("Right").y > ribs_y:
			lo = mid
		else:
			hi = mid
	var arm_deg := (lo + hi) * 0.5
	print("BODYCROSS_BAKE drop %.3f m, lean %.1f deg, arm pitched down %.1f deg (ribs %.3f m); contact %.3f -> %.3f s, length %.3f -> %.3f s" % [
		drop_m, lean_deg, arm_deg, ribs_y, SRC_CONTACT_S, tc, src.length, out.length])
	var bones: Array = []
	var pos_track := -1
	for t in out.get_track_count():
		if out.track_get_type(t) == Animation.TYPE_POSITION_3D:
			pos_track = t
		bones.append(str(out.track_get_path(t)))
		while out.track_get_key_count(t) > 0:
			out.track_remove_key(t, 0)
	var hips := skel.find_bone("Hips")
	var foot_err := 0.0
	var rows: Array = []
	for ts in times:
		var to := _warp(float(ts))
		var w := _env(to, tc)
		ap.play(SRC_NAME)
		ap.seek(float(ts), true)
		var before := _read()
		var err := _edit(float(ts), w, arm_deg)
		foot_err = maxf(foot_err, err)
		for t in out.get_track_count():
			var b := skel.find_bone(str(bones[t]))
			if t == pos_track:
				out.position_track_insert_key(t, to, skel.get_bone_pose_position(hips) - skel.get_bone_rest(hips).origin)
			else:
				out.rotation_track_insert_key(t, to, skel.get_bone_pose_rotation(b))
		var after := _read()
		rows.append({"t": snappedf(to, 0.001), "w": snappedf(w, 0.01), "glove_y": [snappedf(before["glove"].y, 0.001), snappedf(after["glove"].y, 0.001)],
			"hips_y": [snappedf(before["hips"].y, 0.001), snappedf(after["hips"].y, 0.001)], "head_y": [snappedf(before["head"].y, 0.001), snappedf(after["head"].y, 0.001)],
			"head_side": [snappedf(before["head"].dot(side), 0.001), snappedf(after["head"].dot(side), 0.001)],
			"head_fwd": [snappedf((before["head"] - before["hips"]).dot(fwd), 0.001), snappedf((after["head"] - after["hips"]).dot(fwd), 0.001)],
			"knee_l": [snappedf(before["kl"], 0.1), snappedf(after["kl"], 0.1)], "knee_r": [snappedf(before["kr"], 0.1), snappedf(after["kr"], 0.1)],
			"lean": [snappedf(before["lean"], 0.1), snappedf(after["lean"], 0.1)], "reach": [snappedf(before["reach"], 0.001), snappedf(after["reach"], 0.001)],
			"lead_glove_to_head": [snappedf(before["lead"], 0.001), snappedf(after["lead"], 0.001)], "elbow": [snappedf(before["elbow"], 0.1), snappedf(after["elbow"], 0.1)]})
	for r in rows:
		print("BODYCROSS_KEY %s" % JSON.stringify(r))
	print("BODYCROSS_BAKE feet off their recorded spots by at most %.4f m" % foot_err)
	if not dry:
		out.set_meta("bodycross1", {"from": SRC, "drop_m": drop_m, "lean_deg": lean_deg, "arm_deg": snappedf(arm_deg, 0.1), "contact_s": snappedf(tc, 0.001)})
		var e := ResourceSaver.save(out, OUT)
		print("BODYCROSS_BAKE saved %s (err %d)" % [OUT, e])
	print("BODYCROSS_BAKE DONE")
	quit(0)


## The take's time after the load is slowed: the load LOAD_STRETCH x longer, the rest as recorded.
func _warp(ts: float) -> float:
	return ts * LOAD_STRETCH if ts <= LOAD_S else ts + shift


## How much of the level change is on at take time t: in from the first key to the contact, held, out.
func _env(t: float, tc: float) -> float:
	if t <= tc:
		return _smooth(t / tc)
	if t <= tc + HOLD_S:
		return 1.0
	return 1.0 - _smooth((t - tc - HOLD_S) / OUT_S)


static func _smooth(x: float) -> float:
	x = clampf(x, 0.0, 1.0)
	return x * x * (3.0 - 2.0 * x)


func _g(bone: String) -> Transform3D:
	return skel.get_bone_global_pose(skel.find_bone(bone))


## Turns a bone about its own joint by R (skeleton space); its children follow.
func _turn(bone: String, r: Basis) -> void:
	var b := skel.find_bone(bone)
	var g := skel.get_bone_global_pose(b)
	g.basis = r * g.basis
	skel.set_bone_global_pose(b, g)


func _glove(s: String) -> Vector3:
	var hand: Vector3 = _g(s + "Hand").origin
	var axis: Vector3 = (_g(s + "MiddleProximal").origin - hand).normalized()
	var fore: Vector3 = (hand - _g(s + "LowerArm").origin).normalized()
	if PR.STRAIGHT > 0.0 and axis.angle_to(fore) > 1e-3:
		axis = axis.slerp(fore, PR.STRAIGHT).normalized()
	return hand + axis * front * scale / skel.global_transform.basis.get_scale().y


static func _ang(a: Vector3, k: Vector3, b: Vector3) -> float:
	return rad_to_deg((a - k).angle_to(b - k))


func _read() -> Dictionary:
	var hips: Vector3 = _g("Hips").origin
	var head: Vector3 = _g("Head").origin
	var gl := _glove("Right")
	return {"glove": gl, "hips": hips, "head": head, "lean": rad_to_deg((head - hips).angle_to(Vector3.UP)), "reach": (gl - hips).dot(fwd),
		"kl": _ang(_g("LeftUpperLeg").origin, _g("LeftLowerLeg").origin, _g("LeftFoot").origin),
		"kr": _ang(_g("RightUpperLeg").origin, _g("RightLowerLeg").origin, _g("RightFoot").origin),
		"lead": _glove("Left").distance_to(head), "elbow": _ang(_g("RightUpperArm").origin, _g("RightLowerArm").origin, _g("RightHand").origin)}


## Each knee's hinge axis in its thigh's own frame, read where the knees are well bent.
func _hinges() -> void:
	ap.play(str(KNEE_REF[0]))
	ap.seek(float(KNEE_REF[1]), true)
	for s in ["Left", "Right"]:
		var u := _g(s + "UpperLeg")
		var k: Vector3 = _g(s + "LowerLeg").origin
		var n: Vector3 = (k - u.origin).cross(_g(s + "Foot").origin - k).normalized()
		hinge[s] = u.basis.orthonormalized().inverse() * n
		print("BODYCROSS_BAKE %s knee hinge read at %.0f deg" % [s, _ang(u.origin, k, _g(s + "Foot").origin)])


## Poses the source take at ts, then puts the level change on at weight w. Leaves the skeleton posed (read it after).
## Returns how far the feet ended from where the take has them (the leg solve's error).
func _edit(ts: float, w: float, arm_deg: float) -> float:
	ap.play(SRC_NAME)
	ap.seek(ts, true)
	var feet := {}
	var toes := {}
	var knees := {}
	for s in ["Left", "Right"]:
		feet[s] = _g(s + "Foot")
		toes[s] = _g(s + "Toes").origin
		knees[s] = [_g(s + "UpperLeg").origin, _g(s + "LowerLeg").origin]
	if w <= 0.0:
		return 0.0
	# 1. the hips sink
	var hips := skel.find_bone("Hips")
	var par := skel.get_bone_parent(hips)
	var pb: Basis = skel.get_bone_global_pose(par).basis.orthonormalized() if par >= 0 else Basis.IDENTITY
	skel.set_bone_pose_position(hips, skel.get_bone_pose_position(hips) + pb.inverse() * (Vector3.DOWN * drop_m * w))
	# 2. the trunk hinges forward, the face stays up
	for b in LEAN_SHARE:
		_turn(str(b), Basis(side, deg_to_rad(lean_deg * w * float(LEAN_SHARE[b]))))
	for b in FACE_BACK:
		_turn(str(b), Basis(side, deg_to_rad(lean_deg * w * float(FACE_BACK[b]))))
	# 3. the punching arm's line down from the shoulder
	var sh: Vector3 = _g("RightUpperArm").origin
	var dir: Vector3 = (_glove("Right") - sh) * Vector3(1, 0, 1)
	if dir.length() > 0.05:
		_turn("RightUpperArm", Basis(dir.normalized().cross(Vector3.UP).normalized(), -deg_to_rad(arm_deg * w)))
	# 4. the legs: both feet back where the take has them
	var err := 0.0
	for s in ["Left", "Right"]:
		err = maxf(err, _leg(str(s), feet[s], toes[s], knees[s], w))
	return err


func _leg(s: String, foot: Transform3D, toe: Vector3, was: Array, w: float) -> float:
	var ui := skel.find_bone(s + "UpperLeg")
	var li := skel.find_bone(s + "LowerLeg")
	var fi := skel.find_bone(s + "Foot")
	var h: Vector3 = skel.get_bone_global_pose(ui).origin
	var k0: Vector3 = skel.get_bone_global_pose(li).origin
	var a0: Vector3 = skel.get_bone_global_pose(fi).origin
	var t: Vector3 = foot.origin
	var l1 := (k0 - h).length()
	var l2 := (a0 - k0).length()
	var d := clampf((t - h).length(), 0.05, (l1 + l2) * 0.9995)
	var dir := (t - h).normalized()
	# the knee's side of the hip-ankle line: the take's own, turned over the toes as the sink comes on
	var over: Vector3 = ((toe - foot.origin) * Vector3(1, 0, 1)).normalized()
	var own: Vector3 = (was[1] as Vector3) - (was[0] as Vector3)
	var line: Vector3 = (foot.origin - (was[0] as Vector3)).normalized()
	own -= line * own.dot(line)
	var pole: Vector3 = over if own.length() < 0.03 else own.normalized().lerp(over, w).normalized()
	pole = (pole - dir * pole.dot(dir)).normalized()
	var a := (l1 * l1 - l2 * l2 + d * d) / (2.0 * d)
	var k1 := h + dir * a + pole * sqrt(maxf(0.0, l1 * l1 - a * a))
	_turn(s + "UpperLeg", Basis(Quaternion((k0 - h).normalized(), (k1 - h).normalized())))
	# the thigh's twist: the knee's hinge square to the plane the leg bends in
	var axis := (k1 - h).normalized()
	var want := axis.cross(t - k1)
	if want.length() > 0.02:
		var have: Vector3 = skel.get_bone_global_pose(ui).basis.orthonormalized() * (hinge[s] as Vector3)
		have = (have - axis * have.dot(axis)).normalized()
		want = want.normalized()
		_turn(s + "UpperLeg", Basis(axis, have.signed_angle_to(want, axis)))
	k1 = skel.get_bone_global_pose(li).origin
	_turn(s + "LowerLeg", Basis(Quaternion((skel.get_bone_global_pose(fi).origin - k1).normalized(), (t - k1).normalized())))
	var g := skel.get_bone_global_pose(fi)
	g.basis = foot.basis
	skel.set_bone_global_pose(fi, g)
	return skel.get_bone_global_pose(fi).origin.distance_to(t)
