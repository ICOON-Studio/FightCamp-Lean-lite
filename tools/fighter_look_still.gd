extends SceneTree
## FIGHTERLOOK1 stills: the two boxers of the corner film (Lucy Jackson v Maria Ortega) on the 3D ring, built from their own
## data, then a wide shot and face close-ups of each at a few moments (the eyes find the other's face, blink, the rest poses
## drift). Real pictures only (the never-shown desktop):
##   python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/fighter_look_still.gd -- <out_dir> [art=toon] [nolook]
## Prints FIGHTER_LOOK eyes=<n> life=<n> (eye surfaces swapped, life layers attached per boxer).

const W := 1920
const H := 1080
const Stage := preload("res://scripts/fight3d/FightStage.gd")
const Data := preload("res://scripts/state/Data.gd")
const Faces := preload("res://scripts/rules/Faces.gd")

var out_dir := "user://fighter_look"
var stage: Node3D
var cam: Camera3D


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty() and not str(args[0]).contains("="):
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(W, H)
	stage = Stage.new()
	root.add_child(stage)
	await process_frame
	var lucy: Dictionary = Data.lucy()
	var maria: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate()
	if OS.get_cmdline_user_args().has("ortho"):
		maria["stance"] = "orthodox"   # diagnostic: the blue boxer orthodox (she is a southpaw)
	var p := Faces.pair(lucy, maria)
	stage.setup({"glb": Faces.glb(p[0]), "corner": "red", "who": lucy},
		{"glb": Faces.glb(p[1]), "corner": "blue", "who": maria, "stance": str(maria.get("stance", "orthodox"))})
	var eyes := 0
	var life := 0
	for bx in stage.boxers:
		if bx.get("life") != null:
			life += 1
			eyes += (bx["life"].eyes as Array).size()
	print("FIGHTER_LOOK eyes=%d life=%d look0=%s look1=%s" % [eyes, life,
		str((stage.boxers[0].get("look", {}) as Dictionary).get("posture", "-")),
		str((stage.boxers[1].get("look", {}) as Dictionary).get("posture", "-"))])
	await _wait(40)
	await _shot("l01_wide")
	if OS.get_cmdline_user_args().has("wideonly"):
		await _wait(30)
		await _shot("l01b_wide")
		quit(0)
		return
	# Our own lens for the close-ups (the ring camera follows the fight every frame).
	cam = Camera3D.new()
	stage.add_child(cam)
	cam.current = true
	for k in 3:
		for i in 2:
			_close(i, 0.32, 0.6 if i == 0 else -0.6)
			await _wait(2)
			await _shot("l%02d_face_%d_t%d" % [2 + k * 2 + i, i, k])
		await _wait(37 + k * 23)
	_close(0, 1.6, 0.25)
	await _wait(2)
	await _shot("l09_half_red")
	_close(1, 1.6, -0.25)
	await _wait(2)
	await _shot("l10_half_blue")
	quit(0)


## A lens `dist` in front of boxer `i`'s face (a little to the side), looking at it.
func _close(i: int, dist: float, side: float) -> void:
	var skel: Skeleton3D = stage.boxers[i]["skel"]
	var hb := skel.find_bone("Head")
	var head: Vector3 = skel.global_transform * skel.get_bone_global_pose(hb).origin
	var other: Skeleton3D = stage.boxers[1 - i]["skel"]
	var oh: Vector3 = other.global_transform * other.get_bone_global_pose(hb).origin
	var to := (oh - head)
	to.y = 0.0
	to = to.normalized()
	var right := to.cross(Vector3.UP).normalized()
	var at := head + Vector3(0, 0.07, 0)
	cam.position = at + to * dist + right * side + Vector3(0, 0.02, 0)
	cam.look_at(at - Vector3(0, 0.03 * dist, 0), Vector3.UP)
	cam.fov = 30.0


func _wait(n: int) -> void:
	for i in n:
		await process_frame


func _shot(name: String) -> void:
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(path)
	print("wrote ", path)
