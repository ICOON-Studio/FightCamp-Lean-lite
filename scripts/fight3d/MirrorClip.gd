extends RefCounted
## S302 southpaw: a southpaw boxer plays every clip mirrored (lead = right). The clips were captured orthodox, so each one
## is rebuilt on her own skeleton: per frame, every animated bone's pose in skeleton space is taken from its left/right
## counterpart and reflected across her centre plane (the plane between her shoulders), then turned back into bone-local
## keys. A per-bone rest correction keeps the mirrored rest pose exactly her rest pose, whatever the bones' local axes.
## Names stay the same (BeatClips needs no change); the hand that punches swaps (FightStage asks hand()).
##   mirror_library(ap, skel)  -> clips mirrored      counterpart(name) -> "LeftHand" <-> "RightHand"

const FPS := 30.0


## "LeftHand" <-> "RightHand", "upperarm_l" <-> "upperarm_r", "thigh_l_twist" <-> "thigh_r_twist"; else the name itself.
static func counterpart(name: String) -> String:
	if name.contains("Left"):
		return name.replace("Left", "Right")
	if name.contains("Right"):
		return name.replace("Right", "Left")
	for pair in [["_l_", "_r_"], ["_r_", "_l_"]]:
		if name.contains(pair[0]):
			return name.replace(pair[0], pair[1])
	if name.ends_with("_l"):
		return name.trim_suffix("_l") + "_r"
	if name.ends_with("_r"):
		return name.trim_suffix("_r") + "_l"
	return name


## Replaces every clip in `ap`'s default library with its mirror on `skel`. Returns how many were mirrored.
static func mirror_library(ap: AnimationPlayer, skel: Skeleton3D) -> int:
	var lib: AnimationLibrary = ap.get_animation_library("")
	var plane := _plane(skel)
	var n := 0
	for name in lib.get_animation_list():
		var m := mirror(lib.get_animation(name), skel, plane)
		if m != null:
			lib.remove_animation(name)
			lib.add_animation(name, m)
			n += 1
	return n


## The reflection across her centre plane, in skeleton space (normal = shoulder to shoulder at rest).
static func _plane(skel: Skeleton3D) -> Basis:
	var l := skel.get_bone_global_rest(skel.find_bone("LeftUpperArm")).origin
	var r := skel.get_bone_global_rest(skel.find_bone("RightUpperArm")).origin
	var nrm := (l - r).normalized() if (l - r).length() > 1e-4 else Vector3.RIGHT
	# H = I - 2 n n^T (a reflection, determinant -1).
	return Basis(Vector3.RIGHT - 2.0 * nrm.x * nrm, Vector3.UP - 2.0 * nrm.y * nrm, Vector3.BACK - 2.0 * nrm.z * nrm)


static func mirror(anim: Animation, skel: Skeleton3D, h: Basis) -> Animation:
	var rot_tracks := {}     # bone index -> track index
	var pos_tracks := {}
	var prefix := ""
	for t in anim.get_track_count():
		var path := anim.track_get_path(t)
		var bone := skel.find_bone(str(path.get_concatenated_subnames()))
		if bone < 0:
			continue
		prefix = str(path).get_slice(":", 0)
		if anim.track_get_type(t) == Animation.TYPE_ROTATION_3D:
			rot_tracks[bone] = t
		elif anim.track_get_type(t) == Animation.TYPE_POSITION_3D:
			pos_tracks[bone] = t
	if rot_tracks.is_empty():
		return null
	# Every bone the clip moves, its counterpart, and all their parents.
	var bones := {}
	for b in rot_tracks:
		for x in [b, skel.find_bone(counterpart(skel.get_bone_name(b)))]:
			var p: int = x
			while p >= 0 and not bones.has(p):
				bones[p] = true
				p = skel.get_bone_parent(p)
	var mate := {}
	var fix := {}            # rest correction F_b^-1 per bone
	for b in bones:
		var c := skel.find_bone(counterpart(skel.get_bone_name(b)))
		mate[b] = c if c >= 0 and bones.has(c) else b
		var rest_b := skel.get_bone_global_rest(b).basis.orthonormalized()
		var rest_c := skel.get_bone_global_rest(int(mate[b])).basis.orthonormalized()
		var f := rest_b.inverse() * (h * rest_c * h)
		fix[b] = f.inverse()
	var out := Animation.new()
	out.length = anim.length
	out.loop_mode = anim.loop_mode
	var new_rot := {}
	for b in rot_tracks:
		var t := out.add_track(Animation.TYPE_ROTATION_3D)
		out.track_set_path(t, NodePath("%s:%s" % [prefix, skel.get_bone_name(b)]))
		new_rot[b] = t
	var new_pos := {}
	for b in pos_tracks:
		var t := out.add_track(Animation.TYPE_POSITION_3D)
		out.track_set_path(t, NodePath("%s:%s" % [prefix, skel.get_bone_name(b)]))
		new_pos[b] = t
	var frames := maxi(1, int(ceil(anim.length * FPS)))
	for i in frames + 1:
		var at := minf(float(i) / FPS, anim.length)
		var glob := {}
		for b in bones:
			_global(skel, anim, rot_tracks, b, at, glob)
		var mglob := {}
		for b in bones:
			mglob[b] = (h * (glob[int(mate[b])] as Basis) * h) * (fix[b] as Basis)
		for b in rot_tracks:
			var p := skel.get_bone_parent(b)
			var parent: Basis = mglob[p] if p >= 0 else Basis.IDENTITY
			var local: Basis = (parent.inverse() * (mglob[b] as Basis)).orthonormalized()
			out.rotation_track_insert_key(int(new_rot[b]), at, local.get_rotation_quaternion())
		for b in pos_tracks:
			# A position key (the hips) is in its parent's space: reflect it through her plane seen from the parent at rest.
			var src: Vector3 = anim.position_track_interpolate(int(pos_tracks[int(mate[b])] if pos_tracks.has(mate[b]) else pos_tracks[b]), at)
			var p := skel.get_bone_parent(b)
			var to_parent: Basis = skel.get_bone_global_rest(p).basis.orthonormalized() if p >= 0 else Basis.IDENTITY
			var rest_pos := skel.get_bone_rest(b).origin
			var mirrored := to_parent.inverse() * (h * (to_parent * (src - rest_pos))) + rest_pos
			out.position_track_insert_key(int(new_pos[b]), at, mirrored)
	return out


## Bone b's rotation in skeleton space at time `at` (its clip key, else its rest), memoised in `glob`.
static func _global(skel: Skeleton3D, anim: Animation, rot_tracks: Dictionary, b: int, at: float, glob: Dictionary) -> Basis:
	if glob.has(b):
		return glob[b]
	var local: Basis
	if rot_tracks.has(b):
		local = Basis(anim.rotation_track_interpolate(int(rot_tracks[b]), at))
	else:
		local = skel.get_bone_rest(b).basis.orthonormalized()
	var p := skel.get_bone_parent(b)
	var g: Basis = (_global(skel, anim, rot_tracks, p, at, glob) * local) if p >= 0 else local
	glob[b] = g
	return g
