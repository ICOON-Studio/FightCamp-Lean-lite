extends SceneTree
## KNEEROOT1 (S537): the bought take beside the game on ONE FIXED camera (owner S537: before/after films on a fixed side
## camera on the punching boxer, both halves framed the same). Two passes of the same sequence in one run:
##   src   the take as baked onto our body and nothing else: every pose layer of the boxer off (the skin's twist and
##         corrective joints stay: they move no limb), the glove rigid on its hand
##   game  the v2 player as it ships
## Per boxer (who=1 blue, 0 red): a still of the guard and of the cross on its contact from the SIDE and from the FRONT
## (the other man's side: a knee that caves shows there), a film of guard -> cross -> guard on the side camera, and a
## 4 s film of the waiting guard on a closer side camera (the gloves). The camera never moves inside a film.
##   python tools/hidden_desktop.py run --timeout=600 --log=<file> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --fixed-fps 60 --script res://tools/kneeroot_still.gd -- <out_dir> [who=1,0] [take=pro_right_cross] [red=02 blue=01]
## Pictures: <pass>_<red|blue>_<name>.png and <pass>_<red|blue>_<film>_NNN.jpg (30 a second); tools/kneeroot_pair.py puts
## the two passes side by side.

const W := 960
const H := 1080
const Stage := preload("res://scripts/fight3d/FightStage.gd")
const Player2 := preload("res://scripts/fight3d/v2/Player2.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const SKIN_LAYERS := ["MetaHumanTwist", "MetaHumanCorrectiveRBF"]

var out_dir := "user://kneeroot"
var stage: Node3D
var cam: Camera3D
var mark: Array = []


func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).substr(key.length() + 1)
	return def


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
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
		print("KNEEROOT_STILL FAIL the v2 player was not built")
		quit(1)
		return
	cam = Camera3D.new()
	cam.fov = 40.0
	root.add_child(cam)
	cam.make_current()
	for f in 90:
		await process_frame
	mark = [stage.v2._home[0], stage.v2._home[1]]
	var take := _arg("take", "pro_right_cross")
	for w in _arg("who", "1,0").split(",", false):
		for pass_name in ["src", "game"]:
			await _run(int(w), pass_name, take)
	print("KNEEROOT_STILL done")
	quit(0)


func _aim(who: int, view: String) -> void:
	var node: Node3D = stage.boxers[who]["node"]
	var at := node.global_position
	var fwd := node.global_transform.basis.z
	fwd = Vector3(fwd.x, 0.0, fwd.z).normalized()
	if view == "front":
		cam.fov = 40.0
		cam.global_position = at + fwd * 3.3 + Vector3.UP * 1.0
		cam.look_at(at + Vector3.UP * 0.95, Vector3.UP)
	elif view == "gloves":
		cam.fov = 30.0
		cam.global_position = Vector3(-2.6, 1.45, at.z + fwd.z * 0.15)
		cam.look_at(Vector3(0.0, 1.38, at.z + fwd.z * 0.15), Vector3.UP)
	else:
		cam.fov = 40.0
		cam.global_position = Vector3(-3.3, 1.0, at.z + fwd.z * 0.15)
		cam.look_at(Vector3(0.0, 0.95, at.z + fwd.z * 0.15), Vector3.UP)


func _run(who: int, pass_name: String, take: String) -> void:
	var p2: Node = stage.v2
	var bx: Dictionary = stage.boxers[who]
	var ap: AnimationPlayer = bx["ap"]
	var sk: Skeleton3D = bx["skel"]
	var gl: Node = bx["gloves"]
	var tag := "%s_%s" % [pass_name, "red" if who == 0 else "blue"]
	var off: Array = []
	var face: Variant = gl.get("_face")
	var face_n: Variant = gl.get("_face_n")
	if pass_name == "src":
		for c in sk.get_children():
			if c is SkeletonModifier3D and (c as SkeletonModifier3D).active and not SKIN_LAYERS.has(str(c.name)):
				(c as SkeletonModifier3D).active = false
				off.append(c)
		gl.set("_face", PackedVector3Array())
	# the other man out of the way of the front camera: he stands, the camera looks past him
	var other: Node3D = stage.boxers[1 - who]["node"]
	await _home(who)
	var cs := float(p2.db["rows"][take].get("contact_s", 0.3))
	# 1. the guard, still
	ap.speed_scale = 0.0
	_aim(who, "side")
	await _shot(tag + "_guard_side")
	other.visible = false
	_aim(who, "front")
	await _shot(tag + "_guard_front")
	other.visible = true
	# 2. the waiting guard, 4 s, the closer camera
	await _home(who)
	_aim(who, "gloves")
	await _film(tag + "_idle", 240)
	# 3. the cross on its contact, still: played once for each camera
	for view in ["side", "front"]:
		await _home(who)
		_aim(who, view)
		other.visible = view != "front"
		p2._play(who, take, 0.0, "punch", true)
		for f in 240:
			await process_frame
			if str(ap.current_animation) != take or ap.current_animation_position >= cs - 0.008:
				break
		ap.speed_scale = 0.0
		await _shot("%s_cross_%s" % [tag, view])
		other.visible = true
	# 4. guard -> cross -> guard on the side camera (it stays where the guard put it)
	await _home(who)
	_aim(who, "side")
	var total := 30 + int(ap.get_animation(take).length * 60.0) + 50
	var n := 0
	for f in total:
		if f == 30:
			p2._play(who, take, 0.0, "punch", true)
		await process_frame
		if f % 2 == 1:
			continue
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_jpg(out_dir.path_join("%s_cross_%03d.jpg" % [tag, n]), 0.9)
		n += 1
	print("KNEEROOT_STILL %s cross film %d pictures (%s, contact %.2f s)" % [tag, n, take, cs])
	p2.guard(who)
	for m in off:
		(m as SkeletonModifier3D).active = true
	if pass_name == "src":
		gl.set("_face", face)
		gl.set("_face_n", face_n)
	for f in 60:
		await process_frame


## Both men in their waiting guard, back on their marks (a cross leaves a man where it carried him).
func _home(who: int) -> void:
	var p2: Node = stage.v2
	for i in 2:
		(stage.boxers[i]["ap"] as AnimationPlayer).speed_scale = 1.0
		p2.guard(i)
	for f in 80:
		for i in 2:
			p2._home[i] = (p2._home[i] as Vector3).lerp(mark[i], 0.2)
		await process_frame


func _film(name: String, frames: int) -> void:
	var n := 0
	for f in frames:
		await process_frame
		if f % 2 == 1:
			continue
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_jpg(out_dir.path_join("%s_%03d.jpg" % [name, n]), 0.9)
		n += 1
	print("KNEEROOT_STILL %s film %d pictures" % [name, n])


func _shot(name: String) -> void:
	for f in 6:
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name + ".png"))
	print("KNEEROOT_STILL ok %s" % name)
