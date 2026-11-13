extends SceneTree
## S447: run on any FBX folder (purchased packs) before retarget work; see ops/research/AILIVE_SPEED_S447.md.
##   <godot.exe> --headless --audio-driver Dummy --script res://tools/fbx_speed_probe.gd -- <folder of .fbx>
## Glove (hand bone) speed of each FBX clip in a folder, loaded at runtime (FBXDocument), sampled at 60 Hz.
## Scale from the skeleton: head bone height over feet at frame 0 = metres via TARGET_H.
const HZ := 60.0
const TARGET_H := 1.62   # head bone height above the feet of a 1.75 m boxer (approx)

func _initialize() -> void:
	var dir: String = OS.get_cmdline_user_args()[0]
	for f in DirAccess.get_files_at(dir):
		if not f.to_lower().ends_with(".fbx"):
			continue
		var doc := FBXDocument.new()
		var st := FBXState.new()
		if doc.append_from_file(dir.path_join(f), st) != OK:
			print("LOAD FAIL ", f); continue
		var root: Node = doc.generate_scene(st)
		var sk: Skeleton3D = root.find_children("*", "Skeleton3D", true, false)[0]
		var ap: AnimationPlayer = root.find_children("*", "AnimationPlayer", true, false)[0]
		var names := []
		for i in sk.get_bone_count(): names.append(sk.get_bone_name(i))
		var hands := []
		for i in sk.get_bone_count():
			var n := sk.get_bone_name(i).to_lower()
			if n.ends_with("hand") or n.ends_with("hand_l") or n.ends_with("hand_r") or n.ends_with("_hand"):
				hands.append(i)
		var head := -1; var feet := []
		for i in sk.get_bone_count():
			var n := sk.get_bone_name(i).to_lower()
			if head < 0 and n.ends_with("head"): head = i
			if n.ends_with("foot") or n.ends_with("foot_l") or n.ends_with("foot_r") or n.ends_with("_foot"): feet.append(i)
		var anim_name: String = ap.get_animation_list()[0]
		var a: Animation = ap.get_animation(anim_name)
		ap.play(anim_name); ap.pause()
		var frames := int(a.length * HZ)
		var prev := {}; var top := {}; var top_t := {}
		var scale := 1.0
		for k in frames + 1:
			_pose(sk, a, k / HZ)
			var g: Transform3D = _chain(sk)
			if k == 0 and head >= 0 and feet.size() > 0:
				var fy := (g * _gp(sk, feet[0]).origin).y
				var hy := (g * _gp(sk, head).origin).y
				scale = TARGET_H / maxf(0.001, hy - fy)
			for h in hands:
				var p: Vector3 = g * _gp(sk, h).origin * scale
				if prev.has(h) and k >= 2:
					var v: float = p.distance_to(prev[h]) * HZ
					if v > float(top.get(h, 0.0)): top[h] = v; top_t[h] = k / HZ
				prev[h] = p
		var row := "%s len=%.2fs scale=%.4f" % [f, a.length, scale]
		# stance and the other hand at the punching hand's top-speed moment
		var ph := -1; var best := -1.0
		for h in hands:
			if not sk.get_bone_name(h).begins_with("ik") and float(top.get(h, 0.0)) > best: best = float(top[h]); ph = h
		if ph >= 0:
			_pose(sk, a, float(top_t[ph]))
			var g2: Transform3D = _chain(sk)
			var fl := sk.find_bone("foot_l"); var fr := sk.find_bone("foot_r")
			var other := sk.find_bone("hand_r" if sk.get_bone_name(ph) == "hand_l" else "hand_l")
			var hy := (g2 * _gp(sk, head).origin).y * scale
			var oy := (g2 * _gp(sk, other).origin).y * scale
			var fa := (g2 * _gp(sk, fl).origin) * scale; var fb := (g2 * _gp(sk, fr).origin) * scale
			_pose(sk, a, 0.0)
			var g0: Transform3D = _chain(sk)
			var fa0 := (g0 * _gp(sk, fl).origin) * scale; var fb0 := (g0 * _gp(sk, fr).origin) * scale
			var o0 := (g0 * _gp(sk, other).origin).y * scale; var h0 := (g0 * _gp(sk, head).origin).y * scale
			row += "  | feet apart start %.2f m, at punch %.2f m | other hand below head: start %.2f m, at punch %.2f m |" % [
				Vector2(fa0.x - fb0.x, fa0.z - fb0.z).length(), Vector2(fa.x - fb.x, fa.z - fb.z).length(), h0 - o0, hy - oy]
		for h in hands:
			row += "  %s top=%.1f m/s at %.2fs" % [sk.get_bone_name(h), float(top.get(h, 0.0)), float(top_t.get(h, 0.0))]
		print("FBX_SPEED ", row)
		root.queue_free()
	quit(0)


func _chain(n: Node) -> Transform3D:
	var t := Transform3D.IDENTITY
	var c: Node = n
	while c != null:
		if c is Node3D:
			t = (c as Node3D).transform * t
		c = c.get_parent()
	return t


func _pose(sk: Skeleton3D, a: Animation, t: float) -> void:
	for tr in a.get_track_count():
		var path: NodePath = a.track_get_path(tr)
		if path.get_subname_count() == 0:
			continue
		var b := sk.find_bone(str(path.get_subname(0)))
		if b < 0:
			continue
		match a.track_get_type(tr):
			Animation.TYPE_POSITION_3D:
				sk.set_bone_pose_position(b, a.position_track_interpolate(tr, t))
			Animation.TYPE_ROTATION_3D:
				sk.set_bone_pose_rotation(b, a.rotation_track_interpolate(tr, t))
			Animation.TYPE_SCALE_3D:
				sk.set_bone_pose_scale(b, a.scale_track_interpolate(tr, t))
	sk.force_update_all_bone_transforms()


func _gp(sk: Skeleton3D, b: int) -> Transform3D:
	var t: Transform3D = sk.get_bone_pose(b)
	var p := sk.get_bone_parent(b)
	while p >= 0:
		t = sk.get_bone_pose(p) * t
		p = sk.get_bone_parent(p)
	return t
