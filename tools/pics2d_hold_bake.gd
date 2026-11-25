extends SceneTree
## HOLDTAKES1 (S553, ops/research/TASK_HOLDTAKES1.md): THE FOUR ONE-HAND HOLDS OF RING SWITCHES, AUTHORED OFFLINE.
## The owner's game (S551) is one choice a hand: punch, or be HELD high or low ("a hand left off defends"). Our library
## has no take that holds ONE hand (docs/RINGANIM1_RESULT.md), and its two-hand blocks lift a glove over the head
## (BeatClips DEFENCE, S304). This bakes four short takes in their own keys, no runtime layer (the BODYCROSS1 route,
## tools/pics2d_bodycross_bake.gd): the body is the guard's own first picture, held; ONE arm goes from its guard place to
## the hold in MOVE_S (a two-bone solve a key, the elbow turned to the side the pose names, the fist carried by the
## forearm), and stays. The other hand is not touched: it is the guard's, key for key.
##   lead_high  stops his jab and cross      the lead glove in front of the nose and brow, the elbow under it
##   lead_low   stops his body punches       the lead elbow on the ribs, the forearm down across the stomach (J50)
##   rear_high  stops his hook and overhand  the rear glove on the temple and cheek, the forearm upright (S531: the guard
##                                           protects the head - AT the head, never over the crown, never out in front)
##   rear_low   stops his uppercuts          the rear glove under the chin, the forearm across the chest
## Where a wrist goes is written from a landmark of the same body in the guard (head / face / chest / hips), as
## [toward him, out to the hand's own side, up] in metres - GuardHold.AT's reading (scripts/fight3d/v2/GuardHold.gd).
## Saved as assets/anim/baked/holds/hold_<name>.res (bone-name tracks, Hips as a delta from the rest: FightClips._add_baked
## reads them). The game does not load them yet; tools/pics2d_anim_more.gd adds them for the pictures.
## Both hands held at once (the page: a hand that does not punch is held high or low) = both arms solved on the same
## keys: hold_both_<lead>_<rear>.res.
##   <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/pics2d_hold_bake.gd -- [dry]
##       [only=lead_low] [at=f,o,u] [pole=f,o,u] [roll=deg] [set=m|w]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const Orbit := preload("res://tools/clip_orbit.gd")
const OUT_DIR := "res://assets/anim/baked/holds/"
const BASE := ["st_wait", "pro_idle"]   # the guard the v2 player shows (Player2.MOVING_GUARD), else the bought idle
const BODIES := {"m": ["02", "01"], "w": ["11", "14"]}
const HZ := 60.0
const MOVE_S := 0.32
const HOLD_S := 0.42
## name -> side, the landmark, the wrist [toward him, out, up] m from it, the elbow's side of the shoulder-wrist line
## (same reading), the fist rolled about the forearm (deg), `guards`: the place it covers, from a landmark.
const POSES := {
	"lead_high": {"side": "Left", "from": "face", "at": Vector3(0.09, 0.02, -0.10), "pole": Vector3(0.35, 0.25, -1.0), "roll": 0.0,
		"guards": ["face", Vector3(0.0, 0.0, 0.0)]},
	# the forearm laid ACROSS the stomach, the glove past the centre line (owner S553 on the first pose, a glove hanging
	# at the belt with its arm hidden behind the body: "the right hand of blue is not right")
	"lead_low": {"side": "Left", "from": "hips", "at": Vector3(0.15, -0.08, 0.14), "pole": Vector3(0.0, 1.0, -0.3), "roll": 0.0,
		"guards": ["chest", Vector3(0.11, 0.0, -0.08)]},
	# the elbow comes UP in front of the chin and the glove goes to the ear ("answering the phone"): the hook's block
	"rear_high": {"side": "Right", "from": "head", "at": Vector3(0.05, 0.10, -0.02), "pole": Vector3(1.0, 0.2, -0.2), "roll": 0.0,
		"guards": ["head", Vector3(0.03, 0.08, 0.07)]},
	# the glove drops to the chest under the chin, on the uppercut's way up, the elbow by the ribs
	"rear_low": {"side": "Right", "from": "chest", "at": Vector3(0.14, 0.02, 0.17), "pole": Vector3(-0.4, 0.8, -0.5), "roll": 0.0,
		"guards": ["face", Vector3(0.02, 0.0, -0.30)]},
}

var skel: Skeleton3D
var ap: AnimationPlayer
var fwd := Vector3.BACK      # skeleton space: toward the other man
var right := Vector3.LEFT    # ... the boxer's own right
var kk := 1.0                # one metre on this body, in skeleton units
var front := 0.15
var base := ""
var hinge := {}              # "Left" / "Right" -> the elbow's hinge axis in the upper arm's own frame


func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).substr(key.length() + 1)
	return def


func _vec(key: String, def: Vector3) -> Vector3:
	var s := _arg(key, "")
	if s == "":
		return def
	var p := s.split(",")
	return Vector3(float(p[0]), float(p[1]), float(p[2]))


func _initialize() -> void:
	var dry := OS.get_cmdline_user_args().has("dry")
	var only := _arg("only", "")
	FightClips.untouched = true
	var st: Node3D = Stage.new()
	root.add_child(st)
	await process_frame
	var pair: Array = BODIES[_arg("set", "m")]
	st.setup({"glb": "res://assets/models/metahuman/mh_boxer_%s.glb" % pair[0], "corner": "red", "stance": "orthodox"},
		{"glb": "res://assets/models/metahuman/mh_boxer_%s.glb" % pair[1], "corner": "blue", "stance": "orthodox"})
	await process_frame
	st.set_process(false)
	var bx: Dictionary = st.boxers[0]
	skel = bx["skel"]
	ap = bx["ap"]
	front = float(bx.get("front", 0.15))
	kk = (bx["node"] as Node3D).scale.x / skel.global_transform.basis.get_scale().y
	Orbit.strip_modifiers(skel)
	var inv := skel.global_transform.basis.orthonormalized().inverse()
	fwd = (inv * (bx["node"] as Node3D).global_transform.basis.z).normalized()
	right = fwd.cross(Vector3.UP).normalized()
	for b in BASE:
		if ap.has_animation(str(b)):
			base = str(b)
			break
	if base == "":
		print("HOLD_BAKE FAIL no guard take (%s)" % str(BASE))
		quit(1)
		return
	_pose_base()
	for s in ["Left", "Right"]:
		var ua := _g(s + "UpperArm")
		var el: Vector3 = _g(s + "LowerArm").origin
		var hd: Vector3 = _g(s + "Hand").origin
		hinge[s] = ua.basis.orthonormalized().inverse() * (el - ua.origin).cross(hd - el).normalized()
		print("HOLD_BAKE %s arm in the guard (%s): elbow %.0f deg, upper arm %.3f m, forearm %.3f m; wrist from the head %s, from the face %s, from the chest %s, from the hips %s; glove centre from the face %s" % [
			s, base, rad_to_deg((ua.origin - el).angle_to(hd - el)), (el - ua.origin).length() / kk, (hd - el).length() / kk,
			_rel(hd, "head", s), _rel(hd, "face", s), _rel(hd, "chest", s), _rel(hd, "hips", s), _rel(_glove(s), "face", s)])
	print("HOLD_BAKE landmarks (m, from the hips): head %s face %s chest %s; one metre = %.3f skeleton units" % [_rel(_mark("head"), "hips", "Right"), _rel(_mark("face"), "hips", "Right"), _rel(_mark("chest"), "hips", "Right"), kk])
	var src: Animation = ap.get_animation(base)
	if only == "" and not dry:
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUT_DIR))
		for l in ["high", "low"]:
			for r in ["high", "low"]:
				var both := _bake(src, [POSES["lead_" + l], POSES["rear_" + r]])
				both.set_meta("holdtakes1", {"both": [l, r], "base": base, "move_s": MOVE_S})
				print("HOLD_BAKE saved %shold_both_%s_%s.res (err %d)" % [OUT_DIR, l, r, ResourceSaver.save(both, OUT_DIR + "hold_both_%s_%s.res" % [l, r])])
	for key in POSES:
		if only != "" and str(key) != only:
			continue
		var p: Dictionary = (POSES[key] as Dictionary).duplicate()
		if only != "":
			p["at"] = _vec("at", p["at"])
			p["pole"] = _vec("pole", p["pole"])
			p["roll"] = float(_arg("roll", str(p["roll"])))
		var out := _bake(src, [p])
		_pose_base()
		_arm(p, 1.0)
		var s: String = p["side"]
		var o: String = "Right" if s == "Left" else "Left"
		var g: Array = p["guards"]
		var place: Vector3 = _mark(str(g[0])) + _off(g[1], s)
		var gl := _glove(s)
		print("HOLD_BAKE %s: wrist %s from the %s; glove centre %.3f m from the place it guards, %.3f m under the top of the head, %.3f m from the face; elbow %.0f deg, elbow %s from the chest; the other hand moved %.4f m" % [
			key, _rel(_g(s + "Hand").origin, str(p["from"]), s), p["from"], gl.distance_to(place) / kk, (_mark("head").y + 0.16 * kk - gl.y) / kk, gl.distance_to(_mark("face")) / kk,
			rad_to_deg((_g(s + "UpperArm").origin - _g(s + "LowerArm").origin).angle_to(_g(s + "Hand").origin - _g(s + "LowerArm").origin)),
			_rel(_g(s + "LowerArm").origin, "chest", s), 0.0 if o == "" else _other_moved(o)])
		if not dry:
			DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUT_DIR))
			out.set_meta("holdtakes1", {"side": s, "from": p["from"], "at": p["at"], "pole": p["pole"], "roll": p["roll"], "base": base, "move_s": MOVE_S})
			var e := ResourceSaver.save(out, OUT_DIR + "hold_%s.res" % key)
			print("HOLD_BAKE saved %shold_%s.res (err %d, %.2f s)" % [OUT_DIR, key, e, out.length])
	print("HOLD_BAKE DONE")
	quit(0)


## One take: the guard's first picture on every key, the arm (or both) on its way to the hold, then held.
func _bake(src: Animation, ps: Array) -> Animation:
	var out := Animation.new()
	out.length = MOVE_S + HOLD_S
	out.loop_mode = Animation.LOOP_NONE
	var bones: Array = []
	var hips := skel.find_bone("Hips")
	for t in src.get_track_count():
		var ty := src.track_get_type(t)
		var bone := str(src.track_get_path(t).get_concatenated_subnames())
		var b := skel.find_bone(bone)
		if b < 0 or not (ty == Animation.TYPE_ROTATION_3D or (ty == Animation.TYPE_POSITION_3D and b == hips)):
			continue
		var nt := out.add_track(ty)
		out.track_set_path(nt, NodePath(bone))
		bones.append([nt, b, ty])
	var n := int(round(out.length * HZ))
	for k in n + 1:
		var t := float(k) / HZ
		_pose_base()
		for p in ps:
			_arm(p, _ease(t / MOVE_S))
		for row in bones:
			if int(row[2]) == Animation.TYPE_POSITION_3D:
				out.position_track_insert_key(int(row[0]), t, skel.get_bone_pose_position(hips) - skel.get_bone_rest(hips).origin)
			else:
				out.rotation_track_insert_key(int(row[0]), t, skel.get_bone_pose_rotation(int(row[1])))
	return out


func _pose_base() -> void:
	ap.play(base)
	ap.seek(0.0, true)


## A hand leaves slowly, travels, and settles: slower out than a plain smoothstep, no bounce.
static func _ease(x: float) -> float:
	x = clampf(x, 0.0, 1.0)
	return x * x * x * (x * (x * 6.0 - 15.0) + 10.0)


func _g(bone: String) -> Transform3D:
	return skel.get_bone_global_pose(skel.find_bone(bone))


func _turn(bone: String, r: Basis) -> void:
	var b := skel.find_bone(bone)
	var g := skel.get_bone_global_pose(b)
	g.basis = r * g.basis
	skel.set_bone_global_pose(b, g)


## [toward him, out to side s's own side, up] in metres -> skeleton space.
func _off(v: Vector3, s: String) -> Vector3:
	return (fwd * v.x + right * v.y * (-1.0 if s == "Left" else 1.0) + Vector3.UP * v.z) * kk


## A point of the body in the guard: the head bone, the face (FightStage.target_point's), the chest bone, the hips.
func _mark(m: String) -> Vector3:
	match m:
		"face": return _g("Head").origin + (fwd * Stage.FACE_FWD_M + Vector3.UP * Stage.FACE_UP_M) * kk
		"chest": return _g("Chest").origin
		"hips": return _g("Hips").origin
	return _g("Head").origin


## Point p from landmark m, read back as [toward him, out, up] metres (two decimals, for the log).
func _rel(p: Vector3, m: String, s: String) -> String:
	var d := (p - _mark(m)) / kk
	return "[%.2f, %.2f, %.2f]" % [d.dot(fwd), d.dot(right) * (-1.0 if s == "Left" else 1.0), d.y]


## The middle of the glove on side s (the padding's centre: half-way to its striking face).
func _glove(s: String) -> Vector3:
	var hand: Vector3 = _g(s + "Hand").origin
	var axis: Vector3 = (_g(s + "MiddleProximal").origin - hand).normalized()
	return hand + axis * front * 0.5 * kk


func _other_moved(o: String) -> float:
	var now: Vector3 = _g(o + "Hand").origin
	var had := now
	_pose_base()
	had = _g(o + "Hand").origin
	return now.distance_to(had) / kk


## The arm of pose p, share k of the way from the guard (the skeleton is in the guard when this is called).
func _arm(p: Dictionary, k: float) -> void:
	if k <= 0.0:
		return
	var s: String = p["side"]
	var sh: Vector3 = _g(s + "UpperArm").origin
	var e0: Vector3 = _g(s + "LowerArm").origin
	var w0: Vector3 = _g(s + "Hand").origin
	var hand: Basis = _g(s + "Hand").basis
	var l1 := (e0 - sh).length()
	var l2 := (w0 - e0).length()
	var tgt: Vector3 = w0.lerp(_mark(str(p["from"])) + _off(p["at"], s), k)
	var d := clampf((tgt - sh).length(), 0.05, (l1 + l2) * 0.999)
	var u := (tgt - sh).normalized()
	var own := (e0 - sh) - u * (e0 - sh).dot(u)
	var want: Vector3 = _off(p["pole"], s)
	want -= u * want.dot(u)
	var pole := want.normalized() if own.length() < 0.01 else own.normalized().slerp(want.normalized(), k).normalized()
	pole = (pole - u * pole.dot(u)).normalized()
	var a := (l1 * l1 - l2 * l2 + d * d) / (2.0 * d)
	var e1 := sh + u * a + pole * sqrt(maxf(0.0, l1 * l1 - a * a))
	var w1 := sh + u * d
	_turn(s + "UpperArm", Basis(Quaternion((e0 - sh).normalized(), (e1 - sh).normalized())))
	# the upper arm's twist: the elbow's hinge square to the plane the arm bends in
	var axis := (e1 - sh).normalized()
	var plane := axis.cross(w1 - e1)
	if plane.length() > 0.02 * kk:
		var have: Vector3 = _g(s + "UpperArm").basis.orthonormalized() * (hinge[s] as Vector3)
		have = (have - axis * have.dot(axis)).normalized()
		_turn(s + "UpperArm", Basis(axis, have.signed_angle_to(plane.normalized(), axis)))
	var e2: Vector3 = _g(s + "LowerArm").origin
	var fa := (w1 - e2).normalized()
	_turn(s + "LowerArm", Basis(Quaternion((_g(s + "Hand").origin - e2).normalized(), fa)))
	# the fist goes with the forearm, rolled about it if the pose says so
	var hi := skel.find_bone(s + "Hand")
	var hg := skel.get_bone_global_pose(hi)
	hg.basis = Basis(fa, deg_to_rad(float(p["roll"])) * k) * Basis(Quaternion((w0 - e0).normalized(), fa)) * hand
	skel.set_bone_global_pose(hi, hg)
