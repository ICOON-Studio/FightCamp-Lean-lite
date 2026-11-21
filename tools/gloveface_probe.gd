extends SceneTree
## GLOVEFACE1 (S536, owner C447 "is the glove normal looking ?", C456 "this black fighters do not look good on dark
## background"): numbers and stills of the gloves and the ring light on the v2 player's own camera.
##   python tools/hidden_desktop.py run --timeout=300 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --fixed-fps 60 --script res://tools/gloveface_probe.gd -- <out_dir> tag=after [red=11 blue=10]
##   only=light   the guard on the broadcast camera and the luminance read, nothing else
##   oldglove     the glove as it was before GLOVEFACE1 (Gloves.gd reads it);  oldlights  the ring's light as it was (RingSet.gd)
## Prints GLOVE (size), GAP (glove to the wearer's face, negative = inside), LUMA (boxers against the crowd behind them).

const W := 1920
const H := 1080
const Stage := preload("res://scripts/fight3d/FightStage.gd")
const Player2 := preload("res://scripts/fight3d/v2/Player2.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const Meter := preload("res://tools/glove_face_meter.gd")

var out_dir := "user://gloveface"
var tag := "after"
var stage: Node3D
var pictures := true
var drawn: Array = [{}, {}]
var clouds: Array = [{}, {}]


func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).substr(key.length() + 1)
	return def


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	tag = _arg("tag", "after")
	pictures = DisplayServer.get_name() != "headless"
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(W, H)
	Player2.force = true
	FightClips.untouched = true
	stage = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_%s.glb" % _arg("red", "11"), "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_%s.glb" % _arg("blue", "10"), "corner": "blue"})
	if stage.v2 == null:
		print("GLOVEFACE FAIL the v2 player was not built")
		quit(1)
		return
	for i in 2:
		var sk: Skeleton3D = stage.boxers[i]["skel"]
		var d: Dictionary = drawn[i]
		sk.skeleton_updated.connect(func() -> void:
			for b in sk.get_bone_count():
				d[b] = sk.get_bone_global_pose(b))
		clouds[i] = Meter.head_cloud(stage.boxers[i]["node"], sk)
		var lo := Vector3.INF
		var hi := -Vector3.INF
		for q in (clouds[i]["pts"] as PackedVector3Array):
			lo = lo.min(q)
			hi = hi.max(q)
		print("GLOVEFACE boxer %d head cloud bounds in the head bone frame, cm: %s to %s; head rest basis x %s y %s z %s; skeleton scale %.3f" % [i, str((lo * 100.0).round()), str((hi * 100.0).round()),
			str(sk.get_bone_global_rest(sk.find_bone("Head")).basis.x.round()), str(sk.get_bone_global_rest(sk.find_bone("Head")).basis.y.round()), str(sk.get_bone_global_rest(sk.find_bone("Head")).basis.z.round()), sk.global_transform.basis.y.length()])
		print("GLOVEFACE boxer %d (mh_boxer_%s): head cloud %d points from %d surfaces" % [i, _arg("red" if i == 0 else "blue", "11" if i == 0 else "10"), (clouds[i]["pts"] as PackedVector3Array).size(), int(clouds[i]["surfaces"])])
	for f in 90:
		await process_frame
	_freeze(0)
	_freeze(1)
	for f in 6:
		await process_frame
	_dims()
	_gaps("guard")
	await _broadcast("guard")
	await _luma()
	if _arg("only", "") == "light":
		print("GLOVEFACE done")
		quit(0)
		return
	await _zoom("guard", 0)
	await _zoom("guard", 1)
	await _close("guard")
	var clip := _punch_clip(0, "jab")
	if clip != "":
		var ap: AnimationPlayer = stage.boxers[0]["ap"]
		stage.v2._play(0, clip, 0.0, "punch", true)
		var cs := float(stage.v2.db["rows"][clip].get("contact_s", 0.3))
		for f in 240:
			await process_frame
			if str(ap.current_animation) != clip or ap.current_animation_position >= cs - 0.008:
				break
		_freeze(0)
		for f in 14:
			await process_frame
		_gaps("red jab contact (%s)" % clip)
		await _broadcast("jab")
		await _zoom("jab", 0)
		await _zoom("jab", 1)
	print("GLOVEFACE done")
	quit(0)


func _freeze(i: int) -> void:
	(stage.boxers[i]["ap"] as AnimationPlayer).speed_scale = 0.0


func _punch_clip(i: int, family: String) -> String:
	var ap: AnimationPlayer = stage.boxers[i]["ap"]
	var rows: Dictionary = stage.v2.db.get("rows", {})
	var spare := ""
	for n in rows:
		var r: Dictionary = rows[n]
		if str(r.get("kind", "")) != "punch" or str(r.get("family", "")) != family or not ap.has_animation(str(n)) or not (r.get("drop", []) as Array).is_empty():
			continue
		if bool(r.get("played", false)):
			return str(n)
		if spare == "":
			spare = str(n)
	return spare


func _pose(i: int, bone: String) -> Transform3D:
	var sk: Skeleton3D = stage.boxers[i]["skel"]
	var b := sk.find_bone(bone)
	var g: Transform3D = drawn[i].get(b, sk.get_bone_global_rest(b)) if b >= 0 else Transform3D.IDENTITY
	return sk.global_transform * g


func _world(i: int, bone: String, up: float = 0.0) -> Vector3:
	return _pose(i, bone).origin + Vector3.UP * up


func _glove(i: int, side: String) -> Node3D:
	var gl: Node = stage.boxers[i].get("gloves")
	return (gl.get("gloves") as Dictionary).get(side) if gl != null else null


func _dims() -> void:
	var g := _glove(0, "l")
	if g == null:
		return
	var d := Meter.dims(g)
	var gl: Node = stage.boxers[0].get("gloves")
	print("GLOVE %s | length %.1f cm (%.1f behind the wrist, %.1f ahead) | width %.1f | depth %.1f | cuff %.1f long, %.1f across at the open end, %.1f at the glove end, flare x%.2f | front_m %.3f" % [tag,
		float(d["length"]) * 100.0, float(d["behind"]) * 100.0, float(d["ahead"]) * 100.0, float(d["width"]) * 100.0, float(d["depth"]) * 100.0,
		float(d["cuff_len"]) * 100.0, float(d["cuff_open"]) * 100.0, float(d["cuff_neck"]) * 100.0, float(d["flare"]), float(gl.front_m())])


func _gaps(label: String) -> void:
	for i in 2:
		var head := _pose(i, "Head")
		for side in ["l", "r"]:
			var g := _glove(i, side)
			if g == null:
				continue
			var r := Meter.gap(head, clouds[i], g)
			var at: Vector3 = r["at"]
			print("GAP %s | %s | %s %s glove to the face: %+.1f cm (nearest face point, head bone frame cm: %.1f %.1f %.1f); wrist to head bone %.1f cm" % [tag, label,
				"red" if i == 0 else "blue", "left" if side == "l" else "right", float(r["gap"]) * 100.0, at.x * 100.0, at.y * 100.0, at.z * 100.0,
				g.global_position.distance_to(head.origin) * 100.0])


func _framed(cam: Camera3D) -> Array:
	var bad: Array = []
	for i in 2:
		for p in [["Head", 0.14], ["LeftToes", -0.06], ["RightToes", -0.06], ["LeftHand", 0.0], ["RightHand", 0.0]]:
			var w := _world(i, str(p[0]), float(p[1]))
			var s := cam.unproject_position(w)
			if cam.is_position_behind(w) or s.x < 8.0 or s.x > W - 8.0 or s.y < 8.0 or s.y > H - 8.0:
				bad.append("%s %s at %s" % ["red" if i == 0 else "blue", str(p[0]), str(s.round())])
	return bad


## A still from the game's broadcast camera, saved only with both boxers in the picture from head to feet.
func _broadcast(name: String) -> void:
	if not pictures:
		return
	var cam: Camera3D = stage.camera
	cam.make_current()
	for f in 6:
		await process_frame
	var bad := _framed(cam)
	if not bad.is_empty():
		print("STILL_FRAMING FAIL %s: %s" % [name, "; ".join(PackedStringArray(bad))])
		return
	await _save("%s_%s_broadcast" % [tag, name])
	print("STILL_FRAMING ok %s (both boxers head to feet)" % name)


## The broadcast camera's own line, zoomed on one boxer's head and gloves (the owner's marked picture was this).
func _zoom(name: String, i: int) -> void:
	if not pictures:
		return
	var from: Camera3D = stage.camera
	var cam := Camera3D.new()
	root.add_child(cam)
	cam.global_position = from.global_position
	var look := _world(i, "Head", -0.06)
	cam.look_at(look, Vector3.UP)
	cam.fov = clampf(rad_to_deg(2.0 * atan(0.42 / cam.global_position.distance_to(look))), 4.0, 40.0)
	cam.make_current()
	for f in 5:
		await process_frame
	await _save("%s_%s_zoom_%s" % [tag, name, "red" if i == 0 else "blue"])
	from.make_current()
	cam.queue_free()
	for f in 3:
		await process_frame


## Close looks at each boxer's guard with the other hidden: side-on from both sides and from the front quarter.
func _close(name: String) -> void:
	if not pictures:
		return
	var cam := Camera3D.new()
	cam.fov = 24.0
	root.add_child(cam)
	for i in 2:
		var node: Node3D = stage.boxers[i]["node"]
		var other: Node3D = stage.boxers[1 - i]["node"]
		var fwd := node.global_transform.basis.z.normalized()
		var side := fwd.cross(Vector3.UP).normalized()
		var mid := _world(i, "Head", -0.08) + fwd * 0.10
		other.visible = false
		for view in [["side", side * 1.7 + fwd * 0.1], ["sideb", side * -1.7 + fwd * 0.1], ["front", fwd * 1.5 + side * 0.9]]:
			cam.global_position = mid + (view[1] as Vector3) + Vector3(0.0, 0.05, 0.0)
			cam.look_at(mid, Vector3.UP)
			cam.make_current()
			for f in 4:
				await process_frame
			await _save("%s_%s_close_%s_%s" % [tag, name, "red" if i == 0 else "blue", str(view[0])])
		other.visible = true
	(stage.camera as Camera3D).make_current()
	cam.queue_free()
	for f in 4:
		await process_frame


func _grab() -> Image:
	await RenderingServer.frame_post_draw
	return root.get_texture().get_image()


func _save(name: String) -> void:
	var img: Image = await _grab()
	var path := out_dir.path_join(name + ".png")
	img.save_png(path)
	print("wrote ", path)


static func _y(c: Color) -> float:
	return (0.2126 * c.r + 0.7152 * c.g + 0.0722 * c.b) * 255.0


## Each boxer against what is BEHIND her on the broadcast camera: the same pixels with the boxers drawn and hidden.
## skin = 5 px patches on the head, neck and along both arms; upper body = every pixel she changes above her hips.
## Luma = 0.2126 R + 0.7152 G + 0.0722 B of the picture as shown, 0-255.
func _luma() -> void:
	if not pictures:
		return
	var cam: Camera3D = stage.camera
	cam.make_current()
	for f in 4:
		await process_frame
	var with: Image = await _grab()
	for i in 2:
		(stage.boxers[i]["node"] as Node3D).visible = false
	for f in 4:
		await process_frame
	var without: Image = await _grab()
	for i in 2:
		(stage.boxers[i]["node"] as Node3D).visible = true
	for f in 4:
		await process_frame
	for i in 2:
		var pts: Array = [_world(i, "Head", 0.06), _world(i, "Head", 0.11), _world(i, "Neck", 0.02)]
		for side in ["Left", "Right"]:
			for seg in [["UpperArm", "LowerArm"], ["LowerArm", "Hand"]]:
				var a := _world(i, side + str(seg[0]))
				var b := _world(i, side + str(seg[1]))
				for t in [0.25, 0.5, 0.75]:
					pts.append(a.lerp(b, t))
		var skin := 0.0
		var back := 0.0
		var n := 0
		for p in pts:
			var s := cam.unproject_position(p as Vector3)
			if s.x < 4 or s.y < 4 or s.x > W - 5 or s.y > H - 5:
				continue
			for dx in range(-2, 3):
				for dy in range(-2, 3):
					skin += _y(with.get_pixel(int(s.x) + dx, int(s.y) + dy))
					back += _y(without.get_pixel(int(s.x) + dx, int(s.y) + dy))
					n += 1
		var hips := cam.unproject_position(_world(i, "Hips"))
		var head := cam.unproject_position(_world(i, "Head", 0.2))
		var x0 := int(clampf(hips.x - 330.0, 0, W - 1))
		var x1 := int(clampf(hips.x + 330.0, 0, W - 1))
		var body := 0.0
		var behind := 0.0
		var m := 0
		for y in range(int(maxf(head.y, 0.0)), int(minf(hips.y, H - 1)), 2):
			for x in range(x0, x1, 2):
				var c1 := with.get_pixel(x, y)
				var c2 := without.get_pixel(x, y)
				if absf(c1.r - c2.r) + absf(c1.g - c2.g) + absf(c1.b - c2.b) > 0.06:
					body += _y(c1)
					behind += _y(c2)
					m += 1
		print("LUMA %s | %s mh_boxer_%s | skin %.1f against %.1f behind it: gap %+.1f (%d px) | upper body %.1f against %.1f: gap %+.1f (%d px)" % [tag,
			"red" if i == 0 else "blue", _arg("red" if i == 0 else "blue", "11" if i == 0 else "10"),
			skin / maxf(n, 1), back / maxf(n, 1), (skin - back) / maxf(n, 1), n, body / maxf(m, 1), behind / maxf(m, 1), (body - behind) / maxf(m, 1), m])
