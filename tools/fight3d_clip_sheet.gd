extends SceneTree
## Review stills of every clip whose name starts with a prefix (default mc_ = MoCap Online): one boxer alone in the ring,
## side-on at 3.4 m, posed at six evenly spaced moments of each clip. Real pictures only (hidden desktop):
##   python tools/hidden_desktop.py run --timeout=600 <godot.exe> --path . --windowed --resolution 1280x720 \
##       --script res://tools/fight3d_clip_sheet.gd -- <out_dir> [prefix=mc_] [glb=mh_boxer_10]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const SHOTS := 6

var out_dir := "user://clip_sheet"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var prefix := "mc_"
	var who := "mh_boxer_10"
	for a in args:
		var s := str(a)
		if s.begins_with("prefix="):
			prefix = s.substr(7)
		elif s.begins_with("glb="):
			who = s.substr(4)
		elif not s.contains("="):
			out_dir = s
	DirAccess.make_dir_recursive_absolute(out_dir)
	var stage: Node3D = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/%s.glb" % who, "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "blue"})
	stage.set_process(false)
	(stage.boxers[1]["node"] as Node3D).visible = false
	var body: Node3D = stage.boxers[0]["node"]
	var ap: AnimationPlayer = stage.boxers[0]["ap"]
	var names: Array = []
	# prefix= may list several, comma-separated (S301: exact clip names for a take check)
	var prefixes := prefix.split(",")
	for n in ap.get_animation_list():
		if Array(prefixes).any(func(p): return str(n).begins_with(str(p))):
			names.append(str(n))
	names.sort()
	for name in names:
		var length: float = ap.get_animation(name).length
		for i in SHOTS:
			var t: float = length * float(i) / float(SHOTS - 1)
			stage.pose(0, name, t)
			await _wait(2)
			var c: Vector3 = body.global_position + Vector3(0, 0.95, 0)
			var side: Vector3 = body.global_transform.basis.x
			stage.camera.fov = 40.0
			stage.camera.look_at_from_position(c + side * 3.4 + Vector3(0, 0.25, 0), c, Vector3.UP)
			await _shot("%s_%d_%.2fs" % [name, i, t])
		print("SHEET %s %.2fs" % [name, length])
	print("SHEET DONE %d clips" % names.size())
	quit(0)


func _wait(n: int) -> void:
	for i in n:
		await process_frame


func _shot(name: String) -> void:
	await _wait(2)
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name + ".png"))
