extends RefCounted
## S399 ROKOKO2 (operator S399: "these animations are good why you removed them and changed them with crap"; S270 on the
## old repo's renders of the same takes: "videos are perfect", "all these are perfect"). The OLD repo's working route for a
## Mixamo-skeleton mocap take onto our MetaHuman, ported whole and trimmed to what that route ran:
##   MixamoMotion.build (assets/anim/mixamo_s215, old repo)  ->  FightClipRetarget.retarget_clip  +  BoneRestFixer
##   + MetaHumanRig.fold_intermediate_rests
## Per bone: the source's GLOBAL rotation times a rest correction (source T-pose global -> our rest re-aimed along the
## source's limb lines, "silhouette rest", torso pairs left as ours), then made local to the nearest MAPPED parent and
## folded through the unmapped MetaHuman joints between (spine_02/04, neck_02). The hips carry the take's HEIGHT, scaled by
## hip-above-floor of the two bodies (old S4a (c), "hip_ratio": feet -0.026 m lowest on 336 rows). The ONE change from the
## old route is `carry_xz` (see build): the take's own hips travel on the floor, so a planted foot stays planted.
## It reads the raw FBX bytes (RawAsset: exported builds ship the takes beside the exe, tools/export.sh).
##   build(skel, fbx_path, start_s, end_s, carry_xz) -> Animation (tracks named by our bone names, 30 fps keys) or null

const RawAsset := preload("res://scripts/fight3d/RawAsset.gd")
const MH := preload("res://scripts/fight3d/MHRig.gd")

const FPS := 30.0
const MIXAMO_TO_OURS := {
	"Hips": "Hips", "Spine": "Spine", "Spine1": "Chest", "Spine2": "UpperChest", "Neck": "Neck", "Head": "Head",
	"LeftShoulder": "LeftShoulder", "LeftArm": "LeftUpperArm", "LeftForeArm": "LeftLowerArm", "LeftHand": "LeftHand",
	"RightShoulder": "RightShoulder", "RightArm": "RightUpperArm", "RightForeArm": "RightLowerArm", "RightHand": "RightHand",
	"LeftUpLeg": "LeftUpperLeg", "LeftLeg": "LeftLowerLeg", "LeftFoot": "LeftFoot", "LeftToeBase": "LeftToes",
	"RightUpLeg": "RightUpperLeg", "RightLeg": "RightLowerLeg", "RightFoot": "RightFoot", "RightToeBase": "RightToes",
}
## Old FightClipRetarget.SILHOUETTE_SEGMENTS minus MixamoMotion.TORSO_PAIRS (the torso keeps our own rest lines).
const SEGMENTS := [
	["Neck", "Head", "keep_end"],
	["LeftShoulder", "LeftUpperArm"], ["LeftUpperArm", "LeftLowerArm"], ["LeftLowerArm", "LeftHand"],
	["RightShoulder", "RightUpperArm"], ["RightUpperArm", "RightLowerArm"], ["RightLowerArm", "RightHand"],
	["LeftUpperLeg", "LeftLowerLeg"], ["LeftLowerLeg", "LeftFoot"], ["LeftFoot", "LeftToes"],
	["RightUpperLeg", "RightLowerLeg"], ["RightLowerLeg", "RightFoot"], ["RightFoot", "RightToes"],
]
const FLOOR_BONES := ["LeftFoot", "LeftToes", "RightFoot", "RightToes"]

## Sampled source frames per take file: {path: {"index": .., "rest": .., "clip": Animation, "scene": Node}} - the FBX is
## parsed once per run, the windows are cut from it per body.
static var _takes: Dictionary = {}
## Probe knob (tools/rokoko_feet_probe.gd `rkxz=<k>`): the floor travel's gain over the height scale. 1.0 = the same scale.
static var xz_gain := 1.0
## The contact hold (`-- rknocontact` = off, the probe's control arm): see _hold_contacts.
static var hold_contacts := not OS.get_cmdline_user_args().has("rknocontact")
const PLANT_M := 0.03


## One window [start_s, end_s] of the take at `fbx_path`, built on `skel`. `carry_xz`: the hips also carry the take's own
## floor travel from the window's first frame (scaled like the height); false = the old route (height only, X/Z held).
static func build(skel: Skeleton3D, fbx_path: String, start_s: float, end_s: float, carry_xz: bool = true) -> Animation:
	var take := _take(fbx_path)
	if take.is_empty():
		return null
	var index: Dictionary = take["index"]
	var map: Dictionary = take["map"]
	var source_rest: Dictionary = take["rest"]
	var clip: Animation = take["clip"]
	var virtual := silhouette_rest(skel, source_rest, SEGMENTS)
	var corr := {}
	for bone in source_rest:
		if virtual.has(bone):
			corr[bone] = (source_rest[bone] as Transform3D).basis.orthonormalized().inverse() * (virtual[bone] as Basis)
	var parent_of := _parent_of(skel)
	var carry := _hip_carry(skel, (source_rest["Hips"] as Transform3D).origin.y)
	var t1 := minf(end_s, clip.length)
	var n := maxi(2, int(round((t1 - start_s) * FPS)) + 1)
	var anim := Animation.new()
	anim.length = t1 - start_s
	anim.step = 1.0 / FPS
	var tracks := {}
	var hips_track := -1
	var xz0 := Vector2.INF
	var balls: Array = []   # the source's toe balls per frame (source space), for the contact hold
	for k in n:
		var t := minf(start_s + k / FPS, t1)
		var g := _to_ours(_globals(index, _local_at(index, clip, t)), map)
		var bases := {}
		for b in g:
			bases[b] = (g[b] as Transform3D).basis.orthonormalized()
		var locals := _pose_frame(bases, corr, parent_of)
		for b in locals:
			if not tracks.has(b):
				tracks[b] = anim.add_track(Animation.TYPE_ROTATION_3D)
				anim.track_set_path(tracks[b], NodePath(str(b)))
			anim.rotation_track_insert_key(tracks[b], t - start_s, Quaternion((locals[b] as Basis).orthonormalized()))
		if carry.is_empty() or not g.has("Hips"):
			continue
		balls.append([(g["LeftToes"] as Transform3D).origin, (g["RightToes"] as Transform3D).origin])
		var o: Vector3 = (g["Hips"] as Transform3D).origin
		var pos: Vector3 = (carry["rest_origin"] as Vector3) + (carry["up"] as Vector3) * (o.y - float(carry["source_h"])) * float(carry["scale"])
		if carry_xz:
			if xz0 == Vector2.INF:
				xz0 = Vector2(o.x, o.z)
			var d := (Vector2(o.x, o.z) - xz0) * float(carry["scale"]) * xz_gain
			pos += (carry["x_axis"] as Vector3) * d.x + (carry["z_axis"] as Vector3) * d.y
		if hips_track < 0:
			hips_track = anim.add_track(Animation.TYPE_POSITION_3D)
			anim.track_set_path(hips_track, NodePath("Hips"))
		anim.position_track_insert_key(hips_track, t - start_s, pos)
	_fold_intermediate_rests(anim, skel)
	if hips_track >= 0 and balls.size() == n:
		_hold_contacts(anim, skel, hips_track, balls, carry, carry_xz and hold_contacts)
	anim.set_meta("source", fbx_path)
	anim.set_meta("rk_scale", float(carry.get("scale", 1.0)))
	anim.set_meta("rokoko_window", [start_s, t1])
	return anim


## THE CONTACT HOLD (S399 ROKOKO2). Same rotations, our own leg and foot lengths: a foot the actor keeps planted still
## moved on our body (tools/rokoko_feet_probe.gd mode=clip: guard_b 0.41 m of planted slide against the raw take's 0.27, the
## jab 0.09 against 0.03; scaling the hips' travel 0.8-1.5x only made it worse - the length ratio is right, the shape
## differs). So the hips, and only their floor position, are corrected frame by frame: while the SOURCE holds a foot down
## (its ball within PLANT_M of its lowest point in the window, both frames), our ball must travel what the source's
## travelled (scaled); the hips take up the difference, averaged over the planted feet, and keep it while no foot is
## planted. Legs, arms, spine and the hips' height and turn are the take's own.
static func _hold_contacts(anim: Animation, skel: Skeleton3D, hips_track: int, balls: Array, carry: Dictionary, hold: bool) -> void:
	var scale := float(carry["scale"])
	var chains: Array = []
	for toe in ["LeftToes", "RightToes"]:
		var chain: Array = []
		var w := skel.find_bone(toe)
		while w >= 0:
			chain.push_front(w)
			w = skel.get_bone_parent(w)
		chains.append(chain)
	var rot_of := {}
	for t in anim.get_track_count():
		if anim.track_get_type(t) == Animation.TYPE_ROTATION_3D:
			rot_of[skel.find_bone(str(anim.track_get_path(t)))] = t
	var hips := skel.find_bone("Hips")
	var low := [INF, INF]
	for b in balls:
		for i in 2:
			low[i] = minf(low[i], (b[i] as Vector3).y)
	var ours_prev: Array = []
	var c := Vector2.ZERO
	var low_ours := INF
	for k in anim.track_get_key_count(hips_track):
		var at := anim.track_get_key_time(hips_track, k)
		var hp: Vector3 = anim.track_get_key_value(hips_track, k)
		var ours: Array = []
		for chain in chains:
			var g := Transform3D.IDENTITY
			for bi in chain:
				var rest := skel.get_bone_rest(bi)
				var basis: Basis = Basis(anim.rotation_track_interpolate(rot_of[bi], at)) if rot_of.has(bi) else rest.basis
				g = g * Transform3D(basis, hp if bi == hips else rest.origin)
			ours.append(g.origin)
		if hold and k > 0 and k < balls.size():
			var sum := Vector2.ZERO
			var wsum := 0.0
			for i in 2:
				var a: Vector3 = balls[k - 1][i]
				var b: Vector3 = balls[k][i]
				if (a.y - float(low[i])) * scale < PLANT_M and (b.y - float(low[i])) * scale < PLANT_M:
					var want := Vector2(b.x - a.x, b.z - a.z) * scale
					var have := Vector2((ours[i] as Vector3).x - (ours_prev[i] as Vector3).x, (ours[i] as Vector3).z - (ours_prev[i] as Vector3).z)
					var wt := 1.0 / (want.length() + 0.002)   # the foot the actor keeps stillest anchors the hips
					sum += (want - have) * wt
					wsum += wt
			if wsum > 0.0:
				c += sum / wsum
		ours_prev = ours
		low_ours = minf(low_ours, minf((ours[0] as Vector3).y, (ours[1] as Vector3).y))
		anim.track_set_key_value(hips_track, k, hp + (carry["x_axis"] as Vector3) * c.x + (carry["z_axis"] as Vector3) * c.y)
	# THE FLOOR (S399): the old height carry left the toe balls 3.5 cm under the canvas on these takes (the old fight then
	# re-planted them per frame - "plant_skin_floor" - a layer). One constant per window instead: its lowest ball sits at
	# the ball's rest height, so the take's own rise and fall are untouched.
	var rest_ball := minf(skel.get_bone_global_rest(skel.find_bone("LeftToes")).origin.y, skel.get_bone_global_rest(skel.find_bone("RightToes")).origin.y)
	if low_ours < INF:
		var lift: Vector3 = (carry["up"] as Vector3) * (rest_ball - low_ours)
		for k in anim.track_get_key_count(hips_track):
			anim.track_set_key_value(hips_track, k, (anim.track_get_key_value(hips_track, k) as Vector3) + lift)


static func _take(path: String) -> Dictionary:
	if _takes.has(path):
		return _takes[path]
	var out := {}
	var scene := _load_fbx(path)
	if scene != null:
		var index := _index(scene)
		var map := {}
		for key in index:
			var j := str(key).trim_prefix("mixamorig_").trim_prefix("mixamorig:")
			if MIXAMO_TO_OURS.has(j):
				map[str(key)] = MIXAMO_TO_OURS[j]
		var clip := _anim_of(scene)
		if map.size() == MIXAMO_TO_OURS.size() and clip != null:
			out = {"index": index, "map": map, "clip": clip, "scene": scene,
				"rest": _to_ours(_globals(index, _local_at(index, null, 0.0)), map)}
		else:
			push_error("RkRetarget: %s mapped %d of %d joints" % [path, map.size(), MIXAMO_TO_OURS.size()])
			scene.free()
	_takes[path] = out
	return out


static func _load_fbx(res_path: String) -> Node:
	if not RawAsset.exists(res_path):
		return null
	var doc := FBXDocument.new()
	var state := FBXState.new()
	if doc.append_from_buffer(RawAsset.read(res_path), res_path.get_base_dir(), state) != OK:
		return null
	return doc.generate_scene(state, FPS)


static func _anim_of(scene: Node) -> Animation:
	var aps := scene.find_children("*", "AnimationPlayer", true, false)
	if aps.is_empty():
		return null
	var ap := aps[0] as AnimationPlayer
	for name in ap.get_animation_list():   # a "with skin" Mixamo FBX lists an empty "Take 001" first (old S238 REBAKE1)
		var a := ap.get_animation(name)
		if a != null and a.get_track_count() > 0:
			return a
	return null


## Source joints: name -> {skel, bone_idx, parent, path} (the FBX imports one Skeleton3D).
static func _index(root: Node) -> Dictionary:
	var out := {}
	var found := root.find_children("*", "Skeleton3D", true, false)
	if found.is_empty():
		return out
	var skel := found[0] as Skeleton3D
	var sp := str(root.get_path_to(skel))
	for i in skel.get_bone_count():
		var raw := skel.get_bone_name(i)
		var p := skel.get_bone_parent(i)
		out[_strip(raw)] = {"skel": skel, "bone_idx": i, "parent": _strip(skel.get_bone_name(p)) if p >= 0 else "", "path": "%s:%s" % [sp, raw]}
	return out


static func _strip(n: String) -> String:
	var i := n.rfind(":")
	return n.substr(i + 1) if i >= 0 else n


## The take's LOCAL transforms at time t; anim == null = the file's own rest (the T-pose).
static func _local_at(index: Dictionary, anim: Animation, t: float) -> Dictionary:
	var locals := {}
	for k in index:
		locals[k] = ((index[k] as Dictionary)["skel"] as Skeleton3D).get_bone_rest(int(index[k]["bone_idx"]))
	if anim == null:
		return locals
	var by_path := {}
	for k in index:
		by_path[str(index[k]["path"])] = k
	for tr in anim.get_track_count():
		var raw := str(anim.track_get_path(tr))
		if not by_path.has(raw):
			continue
		var key: String = by_path[raw]
		var x: Transform3D = locals[key]
		match anim.track_get_type(tr):
			Animation.TYPE_POSITION_3D:
				x.origin = anim.position_track_interpolate(tr, t)
			Animation.TYPE_ROTATION_3D:
				x.basis = Basis(anim.rotation_track_interpolate(tr, t)).scaled(x.basis.get_scale())
			Animation.TYPE_SCALE_3D:
				x.basis = x.basis.orthonormalized().scaled(anim.scale_track_interpolate(tr, t))
		locals[key] = x
	return locals


static func _globals(index: Dictionary, locals: Dictionary) -> Dictionary:
	var out := {}
	var guard := 0
	while out.size() < index.size() and guard < 64:
		guard += 1
		for k in index:
			if out.has(k):
				continue
			var p := str(index[k]["parent"])
			if p == "":
				out[k] = locals[k] as Transform3D
			elif out.has(p):
				out[k] = (out[p] as Transform3D) * (locals[k] as Transform3D)
	return out


static func _to_ours(by_node: Dictionary, map: Dictionary) -> Dictionary:
	var out := {}
	for src in map:
		var k := _strip(str(src))
		if by_node.has(k):
			out[str(map[src])] = by_node[k]
	return out


## Our rest with each segment re-aimed along the source rest's line (old FightClipRetarget.silhouette_rest): our bone name
## -> GLOBAL rest Basis. "keep_end" gives the end bone (the head) back its own global orientation.
static func silhouette_rest(skel: Skeleton3D, source_rest: Dictionary, segments: Array) -> Dictionary:
	var local: Array = []
	var origin: Array = []
	for i in skel.get_bone_count():
		local.append(skel.get_bone_rest(i).basis)
		origin.append(skel.get_bone_rest(i).origin)
	var order := _parent_first(skel)
	var raw := _compose(skel, order, local, origin)
	for pair in segments:
		var si := skel.find_bone(str(pair[0]))
		var ei := skel.find_bone(str(pair[1]))
		if si < 0 or ei < 0 or not source_rest.has(str(pair[0])) or not source_rest.has(str(pair[1])):
			continue
		var comp := _compose(skel, order, local, origin)
		var have: Vector3 = (comp[ei] as Transform3D).origin - (comp[si] as Transform3D).origin
		var want: Vector3 = (source_rest[str(pair[1])] as Transform3D).origin - (source_rest[str(pair[0])] as Transform3D).origin
		var p := skel.get_bone_parent(si)
		local[si] = _align_local(local[si], (comp[p] as Transform3D).basis if p >= 0 else Basis.IDENTITY, have, want)
		if pair.size() > 2 and str(pair[2]) == "keep_end":
			var ep := skel.get_bone_parent(ei)
			if ep >= 0:
				var re := _compose(skel, order, local, origin)
				local[ei] = (re[ep] as Transform3D).basis.orthonormalized().inverse() * (raw[ei] as Transform3D).basis
	var fin := _compose(skel, order, local, origin)
	var out := {}
	for i in skel.get_bone_count():
		out[skel.get_bone_name(i)] = (fin[i] as Transform3D).basis
	return out


static func _align_local(local_basis: Basis, parent_global: Basis, have: Vector3, want: Vector3) -> Basis:
	if have.length() < 1e-6 or want.length() < 1e-6 or have.normalized().dot(want.normalized()) < -0.999999:
		return local_basis
	var q := Basis(Quaternion(have.normalized(), want.normalized()))
	var p := parent_global.orthonormalized()
	return p.inverse() * q * p * local_basis


static func _compose(skel: Skeleton3D, order: PackedInt32Array, local: Array, origin: Array) -> Array:
	var g: Array = []
	g.resize(skel.get_bone_count())
	for i in order:
		var x := Transform3D(local[i] as Basis, origin[i] as Vector3)
		var p := skel.get_bone_parent(i)
		g[i] = x if p < 0 else (g[p] as Transform3D) * x
	return g


static func _parent_first(skel: Skeleton3D) -> PackedInt32Array:
	var order := PackedInt32Array()
	var placed := {}
	var guard := 0
	while order.size() < skel.get_bone_count() and guard < 256:
		guard += 1
		for i in skel.get_bone_count():
			if not placed.has(i) and (skel.get_bone_parent(i) < 0 or placed.has(skel.get_bone_parent(i))):
				order.append(i)
				placed[i] = true
	return order


## Our bone -> its nearest MAPPED ancestor (old FightClipRetarget._parent_of).
static func _parent_of(skel: Skeleton3D) -> Dictionary:
	var mapped := {}
	for v in MIXAMO_TO_OURS.values():
		mapped[str(v)] = true
	var out := {}
	for b in mapped:
		var i := skel.find_bone(str(b))
		if i < 0:
			continue
		var w := skel.get_bone_parent(i)
		var found := ""
		while w >= 0:
			if mapped.has(skel.get_bone_name(w)):
				found = skel.get_bone_name(w)
				break
			w = skel.get_bone_parent(w)
		out[b] = found
	return out


## Old BoneRestFixer.pose_frame: global = source global * correction, local = parent global^-1 * global.
static func _pose_frame(bases: Dictionary, corr: Dictionary, parent_of: Dictionary) -> Dictionary:
	var re := {}
	for b in bases:
		re[b] = (bases[b] as Basis) * (corr.get(b, Basis.IDENTITY) as Basis)
	var out := {}
	for b in re:
		var p := str(parent_of.get(b, ""))
		out[b] = ((re[p] as Basis) if p != "" and re.has(p) else Basis.IDENTITY).inverse() * (re[b] as Basis)
	return out


## Old FightClipRetarget.hip_carry: our Hips' local rest origin, the up / floor axes in the Hips' parent frame, and the
## scale = our hips above our rest floor / the source T-pose pelvis height.
static func _hip_carry(skel: Skeleton3D, source_h: float) -> Dictionary:
	var hips := skel.find_bone("Hips")
	if source_h <= 0.0 or hips < 0:
		return {}
	var local: Array = []
	var origin: Array = []
	for i in skel.get_bone_count():
		local.append(skel.get_bone_rest(i).basis)
		origin.append(skel.get_bone_rest(i).origin)
	var g := _compose(skel, _parent_first(skel), local, origin)
	var floor_y := INF
	for b in FLOOR_BONES:
		var fi := skel.find_bone(b)
		if fi >= 0:
			floor_y = minf(floor_y, (g[fi] as Transform3D).origin.y)
	var above: float = (g[hips] as Transform3D).origin.y - floor_y
	if floor_y == INF or above <= 0.0:
		return {}
	var pb := Basis.IDENTITY
	if skel.get_bone_parent(hips) >= 0:
		pb = (g[skel.get_bone_parent(hips)] as Transform3D).basis
	return {"source_h": source_h, "rest_origin": origin[hips], "up": pb.inverse() * Vector3.UP,
		"x_axis": pb.inverse() * Vector3.RIGHT, "z_axis": pb.inverse() * Vector3.BACK, "scale": above / source_h}


## Old MetaHumanRig.fold_intermediate_rests: a mapped bone whose skeleton parent is an UNMAPPED joint (spine_02, spine_04,
## neck_02) gets that joint chain's rest rotation taken out of its keys.
static func _fold_intermediate_rests(anim: Animation, skel: Skeleton3D) -> void:
	var mapped := {}
	for v in MH.UE5_TO_OURS.values():
		mapped[str(v)] = true
	for t in anim.get_track_count():
		if anim.track_get_type(t) != Animation.TYPE_ROTATION_3D:
			continue
		var bi := skel.find_bone(str(anim.track_get_path(t)))
		if bi < 0:
			continue
		var chain: Array = []
		var w := skel.get_bone_parent(bi)
		while w >= 0 and not mapped.has(skel.get_bone_name(w)):
			chain.push_front(w)
			w = skel.get_bone_parent(w)
		if w < 0 or chain.is_empty():
			continue
		var inter := Basis.IDENTITY
		for i in chain:
			inter = inter * skel.get_bone_rest(i).basis
		var inv := inter.get_rotation_quaternion().inverse()
		for k in anim.track_get_key_count(t):
			anim.track_set_key_value(t, k, (inv * (anim.track_get_key_value(t, k) as Quaternion)).normalized())
