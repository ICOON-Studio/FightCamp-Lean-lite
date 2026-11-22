extends RefCounted
## AFRETARGET1 (S537, owner: "the animation looks fine on actionforge, the knee twisting is not there"): ActionForge's
## own retarget of a bought take onto mh_boxer_01, read at run time and renamed to our bone names, to hold our bake
## against. The export has the same 341 joints as our body; only the 22 mapped ones carry keys.
const MH := preload("res://scripts/fight3d/MHRig.gd")
const KR := preload("res://tools/kneeroot_lib.gd")
const AF_CROSS := "res://assets/anim/af_retarget/box1_m3_right_cross_af.glb"
const CROSS_FBX := "E:/FightCamp/packs/mocaponline_punch_pro/Boxing_01_v2/FBX/Box1_M3_Right_Cross.fbx"
## The joints read on the bought file's own skeleton and on ours (the judge of a retarget is the file: a bone's
## direction does not depend on the body's size).
const FILE_J := {"hip_L": "LeftUpLeg", "knee_L": "LeftLeg", "ankle_L": "LeftFoot", "toe_L": "LeftToeBase", "elbow_L": "LeftForeArm",
	"hand_L": "LeftHand", "thumb_L": "LeftHandThumb1", "hip_R": "RightUpLeg", "knee_R": "RightLeg", "ankle_R": "RightFoot",
	"toe_R": "RightToeBase", "elbow_R": "RightForeArm", "hand_R": "RightHand", "thumb_R": "RightHandThumb1"}
const OUR_J := {"hip_L": "LeftUpperLeg", "knee_L": "LeftLowerLeg", "ankle_L": "LeftFoot", "toe_L": "LeftToes", "elbow_L": "LeftLowerArm",
	"hand_L": "LeftHand", "thumb_L": "LeftThumbMetacarpal", "hip_R": "RightUpperLeg", "knee_R": "RightLowerLeg", "ankle_R": "RightFoot",
	"toe_R": "RightToes", "elbow_R": "RightLowerArm", "hand_R": "RightHand", "thumb_R": "RightThumbMetacarpal"}
const LEGS := ["Hips", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"]


## ActionForge's clip with bare bone-name tracks in our names (the shape of a baked .res; the hips key is absolute).
static func af_anim(path: String = AF_CROSS) -> Animation:
	var doc := GLTFDocument.new()
	var st := GLTFState.new()
	if doc.append_from_file(path, st) != OK:
		return null
	var scene := doc.generate_scene(st, 30.0)
	if scene == null:
		return null
	var ap := scene.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
	var src := ap.get_animation(ap.get_animation_list()[0])
	var out := Animation.new()
	out.length = src.length
	out.step = 1.0 / 30.0
	for t in src.get_track_count():
		var p := src.track_get_path(t)
		if p.get_subname_count() == 0:
			continue
		var bone := str(p.get_subname(0))
		var ours := str(MH.UE5_TO_OURS.get(bone, bone))
		var nt := out.add_track(src.track_get_type(t))
		out.track_set_path(nt, NodePath(ours))
		for k in src.track_get_key_count(t):
			out.track_insert_key(nt, src.track_get_key_time(t, k), src.track_get_key_value(t, k))
	scene.free()
	return out


## {bone name -> track} per kind: rot[name], pos[name].
static func tracks(anim: Animation) -> Dictionary:
	var rot := {}
	var pos := {}
	for t in anim.get_track_count():
		var nm := str(anim.track_get_path(t))
		if nm.contains(":"):
			nm = nm.get_slice(":", 1)
		if anim.track_get_type(t) == Animation.TYPE_ROTATION_3D:
			rot[nm] = t
		elif anim.track_get_type(t) == Animation.TYPE_POSITION_3D:
			pos[nm] = t
	return {"rot": rot, "pos": pos}


## Every bone's global transform (skeleton space) with the clip alone on the rest pose. `delta_hips`: the hips key is
## an offset from this body's rest (our bakes); else it is the place itself (ActionForge).
static func pose(skel: Skeleton3D, anim: Animation, tr: Dictionary, t: float, delta_hips: bool) -> Array:
	var g: Array = []
	g.resize(skel.get_bone_count())
	for i in skel.get_bone_count():
		var rest := skel.get_bone_rest(i)
		var nm := skel.get_bone_name(i)
		var q := rest.basis.get_rotation_quaternion()
		var p := rest.origin
		if (tr["rot"] as Dictionary).has(nm):
			q = anim.rotation_track_interpolate(int(tr["rot"][nm]), t)
		if (tr["pos"] as Dictionary).has(nm):
			var v: Vector3 = anim.position_track_interpolate(int(tr["pos"][nm]), t)
			p = rest.origin + v if delta_hips else v
		var local := Transform3D(Basis(q), p)
		var par := skel.get_bone_parent(i)
		g[i] = (g[par] as Transform3D) * local if par >= 0 else local
	return g


## The points KR.legs() reads, from a pose(); the facing is the skeleton's +Z (both clips stand on the same body).
static func pts(skel: Skeleton3D, g: Array) -> Dictionary:
	var out := {}
	for b in KR.GAME_BONES:
		out[b] = (g[skel.find_bone(str(KR.GAME_BONES[b]))] as Transform3D).origin
	out["fwd"] = Vector3(0, 0, 1)
	return out


## How straight the arm is (wrist from shoulder / the arm's own length, %).
static func arm(skel: Skeleton3D, g: Array, side: String) -> float:
	var s: Vector3 = (g[skel.find_bone(side + "UpperArm")] as Transform3D).origin
	var e: Vector3 = (g[skel.find_bone(side + "LowerArm")] as Transform3D).origin
	var w: Vector3 = (g[skel.find_bone(side + "Hand")] as Transform3D).origin
	return 100.0 * s.distance_to(w) / maxf(s.distance_to(e) + e.distance_to(w), 1e-4)


## The angle between two clips' rotation of bone `nm` in its PARENT's frame (deg), and the part of it about the bone's
## own long axis (twist, signed) - a bone's long axis is its local X on this skeleton.
static func local_diff(a: Animation, ta: Dictionary, b: Animation, tb: Dictionary, nm: String, t: float) -> Vector2:
	if not (ta["rot"] as Dictionary).has(nm) or not (tb["rot"] as Dictionary).has(nm):
		return Vector2.ZERO
	var qa := a.rotation_track_interpolate(int(ta["rot"][nm]), t)
	var qb := b.rotation_track_interpolate(int(tb["rot"][nm]), t)
	var d := (qa.inverse() * qb).normalized()
	if d.w < 0.0:
		d = -d
	return Vector2(rad_to_deg(d.get_angle()), rad_to_deg(2.0 * atan2(d.x, d.w)))


## ActionForge's own one-picture pops: a key more than `deg` off the middle of its two neighbours while those two agree
## within `deg` (the cross: the lead shin at 0.43 s, 24 deg). -> [[track, key]], and with `mend` the key is set to the
## middle of its neighbours. `only`: the track names to look at (all when empty).
static func pops(anim: Animation, mend: bool, deg: float = 12.0, only: Array = []) -> Array:
	var out: Array = []
	for t in anim.get_track_count():
		if anim.track_get_type(t) != Animation.TYPE_ROTATION_3D or (not only.is_empty() and not only.has(str(anim.track_get_path(t)))):
			continue
		for k in range(1, anim.track_get_key_count(t) - 1):
			var a: Quaternion = anim.track_get_key_value(t, k - 1)
			var b: Quaternion = anim.track_get_key_value(t, k)
			var c: Quaternion = anim.track_get_key_value(t, k + 1)
			var mid := a.slerp(c, 0.5)
			if rad_to_deg(mid.angle_to(b)) > deg and rad_to_deg(a.angle_to(c)) < deg:
				out.append([t, k])
				if mend:
					anim.track_set_key_value(t, k, mid)
	return out


## The bought FBX itself, read with Godot's FBX reader and nothing of the bake: one {joint -> place} per picture
## (30 a second, FILE_J's joints, the file's own metres). [] when the file is not on this machine.
static func file_frames(path: String = CROSS_FBX) -> Array:
	if not FileAccess.file_exists(path):
		return []
	var doc := FBXDocument.new()
	var st := FBXState.new()
	if doc.append_from_file(path, st) != OK:
		return []
	var scene := doc.generate_scene(st)
	var ss := scene.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var ap := scene.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
	var take: Animation = null
	for a in ap.get_animation_list():
		if take == null or ap.get_animation(a).length > take.length:
			take = ap.get_animation(a)
	var sg := Transform3D.IDENTITY
	var cur: Node = ss
	while cur != null:
		if cur is Node3D:
			sg = (cur as Node3D).transform * sg
		cur = cur.get_parent()
	var rot := {}
	var pos := {}
	for t in take.get_track_count():
		var path_t := take.track_get_path(t)
		if path_t.get_subname_count() == 0:
			continue
		var b := ss.find_bone(str(path_t.get_subname(0)))
		if take.track_get_type(t) == Animation.TYPE_ROTATION_3D:
			rot[b] = t
		elif take.track_get_type(t) == Animation.TYPE_POSITION_3D:
			pos[b] = t
	var names := {}
	for i in ss.get_bone_count():
		names[ss.get_bone_name(i).get_slice(":", ss.get_bone_name(i).get_slice_count(":") - 1)] = i
	var out: Array = []
	for fi in int(round(take.length * 30.0)) + 1:
		var g: Array = []
		g.resize(ss.get_bone_count())
		for i in ss.get_bone_count():
			var x := ss.get_bone_rest(i)
			var q: Quaternion = take.rotation_track_interpolate(int(rot[i]), fi / 30.0) if rot.has(i) else x.basis.get_rotation_quaternion()
			var o: Vector3 = take.position_track_interpolate(int(pos[i]), fi / 30.0) if pos.has(i) else x.origin
			var loc := Transform3D(Basis(q).scaled(x.basis.get_scale()), o)
			var par := ss.get_bone_parent(i)
			g[i] = (g[par] as Transform3D) * loc if par >= 0 else loc
		var p := {}
		for k in FILE_J:
			p[k] = (sg * (g[int(names[FILE_J[k]])] as Transform3D)).origin
		out.append(p)
	scene.free()
	return out


## FILE_J's joints of a pose() on our body.
static func our_joints(skel: Skeleton3D, g: Array) -> Dictionary:
	var p := {}
	for k in OUR_J:
		p[k] = (g[skel.find_bone(str(OUR_J[k]))] as Transform3D).origin
	return p


## How far one set of joints is off another (deg), each read in its own pelvis frame (x = hip to hip, y = up), so the
## facing and the size drop out: "leg" the worst thigh / shin direction, "flex" the worst knee bend, "foot" the worst
## ankle-to-toe direction, "palm" the worst turn of the hand about its forearm (by the thumb's root).
static func off(a: Dictionary, b: Dictionary) -> Dictionary:
	var out := {"leg": 0.0, "flex": 0.0, "foot": 0.0, "palm": 0.0}
	var fa := _pelvis(a).inverse()
	var fb := _pelvis(b).inverse()
	for s in ["L", "R"]:
		var tha: Vector3 = fa * ((a["knee_" + s] as Vector3) - (a["hip_" + s] as Vector3)).normalized()
		var thb: Vector3 = fb * ((b["knee_" + s] as Vector3) - (b["hip_" + s] as Vector3)).normalized()
		var sha: Vector3 = fa * ((a["ankle_" + s] as Vector3) - (a["knee_" + s] as Vector3)).normalized()
		var shb: Vector3 = fb * ((b["ankle_" + s] as Vector3) - (b["knee_" + s] as Vector3)).normalized()
		var fta: Vector3 = fa * ((a["toe_" + s] as Vector3) - (a["ankle_" + s] as Vector3)).normalized()
		var ftb: Vector3 = fb * ((b["toe_" + s] as Vector3) - (b["ankle_" + s] as Vector3)).normalized()
		out["leg"] = maxf(out["leg"], maxf(rad_to_deg(tha.angle_to(thb)), rad_to_deg(sha.angle_to(shb))))
		out["flex"] = maxf(out["flex"], absf(rad_to_deg(tha.angle_to(sha)) - rad_to_deg(thb.angle_to(shb))))
		out["foot"] = maxf(out["foot"], rad_to_deg(fta.angle_to(ftb)))
		var axa: Vector3 = fa * ((a["hand_" + s] as Vector3) - (a["elbow_" + s] as Vector3)).normalized()
		var axb: Vector3 = fb * ((b["hand_" + s] as Vector3) - (b["elbow_" + s] as Vector3)).normalized()
		var ta: Vector3 = fa * ((a["thumb_" + s] as Vector3) - (a["hand_" + s] as Vector3))
		var tb: Vector3 = Quaternion(axb, axa) * (fb * ((b["thumb_" + s] as Vector3) - (b["hand_" + s] as Vector3)))
		ta = (ta - axa * ta.dot(axa)).normalized()
		tb = (tb - axa * tb.dot(axa)).normalized()
		out["palm"] = maxf(out["palm"], absf(rad_to_deg(ta.signed_angle_to(tb, axa))))
	return out


static func _pelvis(p: Dictionary) -> Basis:
	var x: Vector3 = ((p["hip_L"] as Vector3) - (p["hip_R"] as Vector3)).normalized()
	var y := (Vector3.UP - x * Vector3.UP.dot(x)).normalized()
	return Basis(x, y, x.cross(y).normalized())
