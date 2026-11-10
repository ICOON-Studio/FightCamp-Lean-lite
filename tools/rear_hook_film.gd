extends SceneTree
## S420: the rear (right) hook frame by frame from the side, to judge where the hand travels (REARHAND5: the hand dropped
## to the hips mid-hook). Freezes the red boxer on `move` every 1/15 s and saves a close side still each time.
##   python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/rear_hook_film.gd -- <out_dir> [move=rear_hook] [end=0.9]

const W := 1920
const H := 1080
const Stage := preload("res://scripts/fight3d/FightStage.gd")

var out_dir := "user://rear_hook_film"
var stage: Node3D


func _initialize() -> void:
	var move := "rear_hook"
	var end_s := 0.9
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("move="):
			move = str(a).trim_prefix("move=")
		elif str(a).begins_with("end="):
			end_s = float(str(a).trim_prefix("end="))
		else:
			out_dir = str(a)
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(W, H)
	stage = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "blue"})
	stage.camera.position = Vector3(-0.35, 1.3, 1.7)
	stage.camera.look_at(Vector3(-0.35, 1.15, 0), Vector3.UP)
	var n := 0
	var t := 0.0
	while t <= end_s + 0.001:
		Stage.IdleMatch.freeze(stage.boxers[0], move, t)
		await _shot("h_%02d" % n)
		n += 1
		t += 1.0 / 15.0
	var line := "REAR_HOOK_FILM frames=%d move=%s clip=%s" % [n, move, str((stage.boxers[0]["ap"] as AnimationPlayer).assigned_animation)]
	print(line)
	var fa := FileAccess.open(out_dir.path_join("film.txt"), FileAccess.WRITE)   # the hidden desktop's stdout is not readable
	fa.store_line(line)
	fa.close()
	quit(0)


func _shot(name: String) -> void:
	for i in 4:
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_jpg(out_dir.path_join(name + ".jpg"), 0.88)
