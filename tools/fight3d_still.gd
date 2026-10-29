extends SceneTree
## Stills of the 3D ring from the broadcast camera, for the visual gate: guard, each punch at contact, and a close-up.
## Real pictures only (run it windowed on the never-shown desktop):
##   python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/fight3d_still.gd -- <out_dir>

const W := 1920
const H := 1080
const Stage := preload("res://scripts/fight3d/FightStage.gd")

var out_dir := "user://fight3d"
var stage: Node3D


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(W, H)
	stage = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "blue"})
	print("FIGHT3D gap_m=%.3f" % stage.gap_m)
	await _shot("f01_guard")
	Stage.IdleMatch.freeze(stage.boxers[0], "jab", Stage.CONTACT_S)
	await _shot("f02_red_jab_contact")
	stage.guard(0)
	Stage.IdleMatch.freeze(stage.boxers[1], "cross", Stage.CONTACT_S)
	await _shot("f03_blue_cross_contact")
	stage.guard(1)
	Stage.IdleMatch.freeze(stage.boxers[0], "lead_hook", Stage.CONTACT_S)
	await _shot("f04_red_hook_contact")
	stage.guard(0)
	stage.camera.position = Vector3(-2.4, 1.55, 0.0)
	stage.camera.look_at(Vector3(0, 1.35, 0), Vector3.UP)
	await _shot("f05_close_guard")
	quit(0)


func _shot(name: String) -> void:
	for i in 6:
		await process_frame
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(path)
	print("wrote ", path)
