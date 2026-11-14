extends SceneTree
## S472: the rear knee in a settled guard, head to feet, from the front and from her rear side, to judge the rig's rear knee band
## (BoxerFootworkRig REAR_BAND_DEG) by eye. The source take's own rear knee sits 17.8 deg inside its toes (boxer_footwork_test's
## measure); the rig at band 0 sits over the toes. Run on the never-shown desktop, once per band:
##   python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/knee_band_still.gd -- <out_dir> kneeband=<deg>

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const SETTLE_S := 2.5

var out_dir := "user://knee_band_still"
var stage: Node3D


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var band := "0"
	if not args.is_empty():
		out_dir = args[0]
	for a in args:
		if str(a).begins_with("kneeband="):
			band = str(a).trim_prefix("kneeband=")
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	stage = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "blue"})
	(stage.boxers[1]["node"] as Node3D).visible = false
	await create_timer(SETTLE_S).timeout
	var body := stage.boxers[0]["node"] as Node3D
	var at := body.global_position
	var fwd := -body.global_basis.z
	var right := body.global_basis.x
	var cam := Camera3D.new()   # our own: the stage's RingCamera follows the pair every frame
	stage.add_child(cam)
	cam.fov = 30.0
	cam.make_current()
	stage.set_process(false)    # the pose holds still between the two shots
	for v in [["front", fwd * 4.2], ["side", right * 4.2]]:
		cam.global_position = at + (v[1] as Vector3) + Vector3(0, 0.95, 0)
		cam.look_at(at + Vector3(0, 0.9, 0), Vector3.UP)
		for i in 6:
			await process_frame
		await RenderingServer.frame_post_draw
		var path := out_dir.path_join("knee_band_%s_%s.png" % [band, v[0]])
		root.get_texture().get_image().save_png(path)
		print("wrote ", path)
	print("KNEE_BAND_STILL done band=", band)
	quit(0)
