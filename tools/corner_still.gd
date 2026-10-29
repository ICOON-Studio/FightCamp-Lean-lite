extends SceneTree
## S306 corner minute clips on our boxer (ActionForge, baked by the old repo's tools/af_lean_bake.gd): one still per clip at
## its middle, from a camera at her side, so each pose can be judged before the corner scene is built. Run windowed on the
## never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path . --windowed --resolution 1280x720 \
##       --script res://tools/corner_still.gd -- <out_dir> [clips=af_a,af_b]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const CLIPS := ["af_walk", "af_walk_carry", "af_sit_enter", "af_sit_idle", "af_sit_exit", "af_crouch_idle", "af_talk",
	"af_interact", "af_drink", "af_nod_yes", "af_pickup"]

var out_dir := "user://corner_still"
var stage: Node3D


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var clips: Array = CLIPS
	if not args.is_empty():
		out_dir = args[0]
	for a in args:
		if str(a).begins_with("clips="):
			clips = Array(str(a).substr(6).split(","))
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1280, 720)
	stage = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "blue"})
	stage.set_process(false)
	(stage.boxers[1]["node"] as Node3D).visible = false
	var bx: Dictionary = stage.boxers[0]
	var at: Vector3 = (bx["node"] as Node3D).global_position
	stage.camera.position = at + Vector3(2.6, 1.2, 0.4)
	stage.camera.look_at(at + Vector3(0, 0.8, 0), Vector3.UP)
	for c in clips:
		if not stage.has_move(c):
			print("CORNER %s missing" % c)
			continue
		var length: float = (bx["ap"] as AnimationPlayer).get_animation(c).length
		Stage.IdleMatch.freeze(bx, c, length * 0.5)
		await _shot(c)
	quit(0)


func _shot(name: String) -> void:
	for i in 8:
		await process_frame
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(path)
	print("CORNER wrote ", path)
