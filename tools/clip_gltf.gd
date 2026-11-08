extends SceneTree
## S368 (operator: "can argon work with cascadeur and blender ?" -> "Yes, pilot the jab"; on the board's clips: "they all need
## work on the footing and smoothness"): a baked fight clip (assets/anim/baked/<stem>.res - bone rotations + the hips' offset
## from its body's rest, 30 fps) goes out to Blender on the game's own boxer as glTF, and comes back to the same tracks.
##   export: <godot.exe> --headless --path . --script res://tools/clip_gltf.gd -- export clip=<stem> out=<file.glb> [glb=mh_boxer_10]
##   import: <godot.exe> --headless --path . --script res://tools/clip_gltf.gd -- import glb=<file.glb> like=<stem> out=<file.res>
##   check:  <godot.exe> --headless --path . --script res://tools/clip_gltf.gd -- check a=<file.res|stem> b=<file.res|stem>
## glTF both ways (Godot's GLTFDocument out, Blender's own importer/exporter, GLTFDocument back) so neither side converts
## bone spaces by hand. `check` prints the largest rotation (deg) and hips (m) difference per track: the round trip with no
## edit must stay under 0.5 deg / 5 mm (CLIPGLTF lines; exit 1 over that).

const MH := preload("res://scripts/fight3d/MHRig.gd")
const Smooth := preload("res://tools/owned_mocap_smooth.gd")
const BAKED := "res://assets/anim/baked/"
const BODY_DIR := "res://assets/models/metahuman/"
const MAX_DEG := 0.5
const MAX_M := 0.005


func _initialize() -> void:
	var args := {}
	var mode := ""
	for a in OS.get_cmdline_user_args():
		if str(a).contains("="):
			args[str(a).get_slice("=", 0)] = str(a).get_slice("=", 1)
		else:
			mode = str(a)
	match mode:
		"export":
			quit(_export(str(args["clip"]), str(args["out"]), str(args.get("glb", "mh_boxer_10"))))
		"import":
			quit(_import(str(args["glb"]), str(args["like"]), str(args["out"])))
		"check":
			quit(_check(str(args["a"]), str(args["b"])))
		"smooth":
			quit(_smooth_dir(str(args["in"]), str(args["out"]), float(args.get("hz", "3.0")),
				str(args.get("part", "all"))))
		_:
			print("CLIPGLTF usage: export | import | check")
			quit(2)


static func _anim(stem_or_path: String) -> Animation:
	var p := stem_or_path if stem_or_path.contains("/") or stem_or_path.contains("\\") else BAKED + stem_or_path + ".res"
	return load(p) as Animation if ResourceLoader.exists(p) else ResourceLoader.load(p) as Animation


static func _skel(n: Node) -> Skeleton3D:
	return n.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D


static func _smooth_dir(in_dir: String, out_dir: String, hz: float, part: String) -> int:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(out_dir))
	var names := ["LeftLowerLeg", "RightLowerLeg"] if part == "calves" else \
		["Hips", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"]
	var count := 0
	for file in DirAccess.get_files_at(in_dir):
		if not file.ends_with(".res"):
			continue
		var anim := (load(in_dir.path_join(file)) as Animation).duplicate(true) as Animation
		for track in anim.get_track_count():
			if anim.track_get_type(track) != Animation.TYPE_ROTATION_3D \
				or not names.has(str(anim.track_get_path(track))):
				continue
			var values := []
			for key in anim.track_get_key_count(track):
				values.append(anim.track_get_key_value(track, key))
			values = Smooth.filter_rot(values, Smooth.kernel(hz))
			for key in values.size():
				anim.track_set_key_value(track, key, values[key])
		if ResourceSaver.save(anim, out_dir.path_join(file)) != OK:
			return 1
		count += 1
	print("CLIPGLTF smooth hz=%.1f part=%s clips=%d -> %s" % [hz, part, count, out_dir])
	return 0


## The clip on the boxer, the way FightClips._add_baked plays it (hips = this body's rest + the clip's offset), out as glTF.
func _export(stem: String, out: String, glb: String) -> int:
	var src := _anim(stem)
	var body := MH.load_fighter(BODY_DIR + glb + ".glb")
	root.add_child(body)
	var skel := _skel(body)
	var ap := AnimationPlayer.new()
	body.add_child(ap)
	ap.root_node = ap.get_path_to(body)
	var anim := src.duplicate(true) as Animation
	var prefix := str(body.get_path_to(skel))
	var hips_rest := skel.get_bone_rest(skel.find_bone("Hips")).origin
	for t in anim.get_track_count():
		anim.track_set_path(t, NodePath("%s:%s" % [prefix, str(anim.track_get_path(t))]))
		if anim.track_get_type(t) == Animation.TYPE_POSITION_3D:
			for k in anim.track_get_key_count(t):
				anim.track_set_key_value(t, k, hips_rest + (anim.track_get_key_value(t, k) as Vector3))
	var lib := AnimationLibrary.new()
	lib.add_animation(stem, anim)
	ap.add_animation_library("", lib)
	var doc := GLTFDocument.new()
	var state := GLTFState.new()
	if doc.append_from_scene(body, state) != OK or doc.write_to_filesystem(state, ProjectSettings.globalize_path(out) if out.begins_with("res://") else out) != OK:
		print("CLIPGLTF export FAILED")
		return 1
	print("CLIPGLTF export %s -> %s (%d tracks, %.3f s, hips rest %s)" % [stem, out, anim.get_track_count(), anim.length, hips_rest])
	return 0


## The glTF back onto the clip's own tracks: each track of `like` sampled from the imported animation at its own key times;
## the hips back to an offset from the exporting body's rest.
func _import(glb: String, like: String, out: String) -> int:
	var src := _anim(like)
	var doc := GLTFDocument.new()
	var state := GLTFState.new()
	if doc.append_from_file(glb, state) != OK:
		print("CLIPGLTF import FAILED to read ", glb)
		return 1
	var scene := doc.generate_scene(state)
	root.add_child(scene)
	var aps := scene.find_children("*", "AnimationPlayer", true, false)
	if aps.is_empty():
		print("CLIPGLTF import FAILED: no AnimationPlayer in ", glb)
		return 1
	var ap := aps[0] as AnimationPlayer
	var names := ap.get_animation_list()
	var got := ap.get_animation(names[0])
	var skel := _skel(scene)
	var hips_rest := skel.get_bone_rest(skel.find_bone("Hips")).origin
	var by_bone := {}   # "<bone>|<type>" -> track index in `got`
	for t in got.get_track_count():
		var p := got.track_get_path(t)
		var bone := str(p.get_concatenated_subnames()) if p.get_subname_count() > 0 else str(p.get_name(p.get_name_count() - 1))
		by_bone["%s|%d" % [bone, got.track_get_type(t)]] = t
	var fresh := src.duplicate(true) as Animation
	var missing: Array = []
	for t in fresh.get_track_count():
		var key := "%s|%d" % [str(fresh.track_get_path(t)), fresh.track_get_type(t)]
		if not by_bone.has(key):
			# A bone whose track never moves goes out with no glTF channel (Godot's exporter drops constant tracks): in glTF
			# that bone holds its node transform, which the imported skeleton keeps as its pose.
			var b := skel.find_bone(str(fresh.track_get_path(t)))
			if b < 0:
				missing.append(key)
				continue
			for k in fresh.track_get_key_count(t):
				if fresh.track_get_type(t) == Animation.TYPE_ROTATION_3D:
					fresh.track_set_key_value(t, k, skel.get_bone_pose_rotation(b))
				elif fresh.track_get_type(t) == Animation.TYPE_POSITION_3D:
					fresh.track_set_key_value(t, k, skel.get_bone_pose_position(b) - hips_rest)
			continue
		var g: int = by_bone[key]
		var off: float = got.track_get_key_time(g, 0) if got.track_get_key_count(g) > 0 else 0.0
		for k in fresh.track_get_key_count(t):
			var at := fresh.track_get_key_time(t, k) + off
			if fresh.track_get_type(t) == Animation.TYPE_ROTATION_3D:
				fresh.track_set_key_value(t, k, got.rotation_track_interpolate(g, at))
			elif fresh.track_get_type(t) == Animation.TYPE_POSITION_3D:
				fresh.track_set_key_value(t, k, got.position_track_interpolate(g, at) - hips_rest)
	if not missing.is_empty():
		print("CLIPGLTF import: no track in the glTF for ", missing)
		return 1
	if ResourceSaver.save(fresh, out) != OK:
		print("CLIPGLTF import FAILED to save ", out)
		return 1
	print("CLIPGLTF import %s -> %s (%d tracks)" % [glb, out, fresh.get_track_count()])
	return 0


func _check(a_path: String, b_path: String) -> int:
	var a := _anim(a_path)
	var b := _anim(b_path)
	var worst_deg := 0.0
	var worst_m := 0.0
	var at := ""
	for t in a.get_track_count():
		var tb := b.find_track(a.track_get_path(t), a.track_get_type(t))
		if tb < 0:
			print("CLIPGLTF check: b has no track ", a.track_get_path(t))
			return 1
		for k in a.track_get_key_count(t):
			var time := a.track_get_key_time(t, k)
			if a.track_get_type(t) == Animation.TYPE_ROTATION_3D:
				var qa: Quaternion = a.track_get_key_value(t, k)
				var qb := b.rotation_track_interpolate(tb, time)
				var d := rad_to_deg(qa.angle_to(qb))
				if d > worst_deg:
					worst_deg = d
					at = "%s at %.3f s" % [a.track_get_path(t), time]
			elif a.track_get_type(t) == Animation.TYPE_POSITION_3D:
				worst_m = maxf(worst_m, (a.track_get_key_value(t, k) as Vector3).distance_to(b.position_track_interpolate(tb, time)))
	var ok := worst_deg <= MAX_DEG and worst_m <= MAX_M
	print("CLIPGLTF check worst_rot_deg=%.3f (%s) worst_hips_m=%.4f %s" % [worst_deg, at, worst_m, "PASS" if ok else "FAIL"])
	return 0 if ok else 1
