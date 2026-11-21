extends SceneTree
## FP2POSE1 (S536, owner C454, C458) stills of the v2 player's poses on the game's cameras: the guard and the close
## guard (the camera of fight3d_still f05), the blue cross and the red lead hook on their contact pictures. Both men
## head to feet, or the still is refused. The same frames every run (fixed 60 Hz): a before and an after are comparable.
##   python tools/hidden_desktop.py run --timeout=300 --log=<file> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --fixed-fps 60 --script res://tools/fp2pose_still.gd -- <out_dir> tag=after [red=02 blue=01] [cross=<take>]
##   loop=<take,take>  (FP2POSE2) also films blue from his guard through each take and back, 30 pictures a second:
##                     <tag>_loop_<take>_NNN.jpg (every picture framed head to feet, or the loop is refused)

const W := 1920
const H := 1080
const Stage := preload("res://scripts/fight3d/FightStage.gd")
const Player2 := preload("res://scripts/fight3d/v2/Player2.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")

var out_dir := "user://fp2pose"
var tag := "after"
var stage: Node3D
var drawn: Array = [{}, {}]


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
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(W, H)
	Player2.force = true
	FightClips.untouched = true
	stage = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_%s.glb" % _arg("red", "02"), "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_%s.glb" % _arg("blue", "01"), "corner": "blue"})
	if stage.v2 == null:
		print("FP2POSE_STILL FAIL the v2 player was not built")
		quit(1)
		return
	for i in 2:
		var sk: Skeleton3D = stage.boxers[i]["skel"]
		var d: Dictionary = drawn[i]
		sk.skeleton_updated.connect(func() -> void:
			for b in sk.get_bone_count():
				d[b] = sk.get_bone_global_pose(b))
	for f in 90:
		await process_frame
	_freeze(0)
	_freeze(1)
	await _shot("guard")
	var cam: Camera3D = stage.camera
	var was := cam.global_transform
	cam.position = Vector3(-2.4, 1.55, 0.0)
	cam.look_at(Vector3(0, 1.35, 0), Vector3.UP)
	await _shot("close_guard")
	cam.global_transform = was
	for shot in [[1, "cross", _arg("cross", "")], [0, "lead_hook", ""], [0, "jab", ""]]:
		var who := int(shot[0])
		var clip := str(shot[2]) if str(shot[2]) != "" else _punch_clip(who, str(shot[1]))
		var ap: AnimationPlayer = stage.boxers[who]["ap"]
		if clip == "" or not ap.has_animation(clip):
			print("FP2POSE_STILL no %s take on boxer %d" % [str(shot[1]), who])
			continue
		ap.speed_scale = 1.0
		stage.v2.guard(who)
		for f in 50:
			await process_frame
		stage.v2._play(who, clip, 0.0, "punch", true)
		var cs := float(stage.v2.db["rows"][clip].get("contact_s", 0.3))
		for f in 240:
			await process_frame
			if str(ap.current_animation) != clip or ap.current_animation_position >= cs - 0.008:
				break
		_freeze(who)
		for f in 14:
			await process_frame
		print("FP2POSE_STILL %s %s = %s at %.2f s" % ["red" if who == 0 else "blue", str(shot[1]), clip, cs])
		await _shot("%s_%s" % ["red" if who == 0 else "blue", str(shot[1])])
		ap.speed_scale = 1.0
		stage.v2.guard(who)
		for f in 50:
			await process_frame
		_freeze(who)
	for take in _arg("loop", "").split(",", false):
		await _loop(str(take))
	print("FP2POSE_STILL done")
	quit(0)


## Blue alone: half a second of his guard, the take whole, and his guard again; every second frame saved.
func _loop(take: String) -> void:
	var ap: AnimationPlayer = stage.boxers[1]["ap"]
	if not ap.has_animation(take):
		print("FP2POSE_STILL no take %s" % take)
		return
	(stage.boxers[0]["ap"] as AnimationPlayer).speed_scale = 1.0
	ap.speed_scale = 1.0
	stage.v2.guard(0)
	stage.v2.guard(1)
	for f in 60:
		await process_frame
	var total := 30 + int(ap.get_animation(take).length * 60.0) + 50
	var n := 0
	for f in total:
		if f == 30:
			stage.v2._play(1, take, 0.0, "punch", true)
		await process_frame
		if f % 2 == 1:
			continue
		if not _framed().is_empty():
			print("STILL_FRAMING FAIL loop %s frame %d: %s" % [take, f, "; ".join(PackedStringArray(_framed()))])
			return
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_jpg(out_dir.path_join("%s_loop_%s_%03d.jpg" % [tag, take, n]), 0.92)
		n += 1
	print("STILL_FRAMING ok loop %s -> %d pictures" % [take, n])


func _freeze(i: int) -> void:
	(stage.boxers[i]["ap"] as AnimationPlayer).speed_scale = 0.0


func _punch_clip(i: int, family: String) -> String:
	var ap: AnimationPlayer = stage.boxers[i]["ap"]
	var rows: Dictionary = stage.v2.db.get("rows", {})
	for n in rows:
		var r: Dictionary = rows[n]
		if str(r.get("kind", "")) == "punch" and str(r.get("family", "")) == family and ap.has_animation(str(n)) and (r.get("drop", []) as Array).is_empty() and bool(r.get("played", false)):
			return str(n)
	return ""


func _world(i: int, bone: String, up: float = 0.0) -> Vector3:
	var sk: Skeleton3D = stage.boxers[i]["skel"]
	var b := sk.find_bone(bone)
	var g: Transform3D = drawn[i].get(b, sk.get_bone_global_rest(b)) if b >= 0 else Transform3D.IDENTITY
	return sk.global_transform * g.origin + Vector3.UP * up


## Who is not in the picture head to feet (empty = both men are).
func _framed() -> Array:
	var cam: Camera3D = stage.camera
	var bad: Array = []
	for i in 2:
		for p in [["Head", 0.14], ["LeftToes", -0.06], ["RightToes", -0.06], ["LeftHand", 0.0], ["RightHand", 0.0]]:
			var w := _world(i, str(p[0]), float(p[1]))
			var s := cam.unproject_position(w)
			if cam.is_position_behind(w) or s.x < 8.0 or s.x > W - 8.0 or s.y < 8.0 or s.y > H - 8.0:
				bad.append("%s %s at %s" % ["red" if i == 0 else "blue", str(p[0]), str(s.round())])
	return bad


func _shot(name: String) -> void:
	var cam: Camera3D = stage.camera
	cam.make_current()
	for f in 6:
		await process_frame
	var bad := _framed()
	if not bad.is_empty():
		print("STILL_FRAMING FAIL %s: %s" % [name, "; ".join(PackedStringArray(bad))])
		return
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join("%s_%s.png" % [tag, name])
	root.get_texture().get_image().save_png(path)
	print("STILL_FRAMING ok %s -> %s" % [name, path])
