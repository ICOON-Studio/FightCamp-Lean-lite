extends SceneTree
## S390: one still of each GrappleMap position on the game's bodies, to choose finish poses by eye.
##   python tools/hidden_desktop.py run --timeout=200 --log=<f> <godot> --path . --windowed --resolution 960x540 --audio-driver Dummy \
##       --script res://tools/grapple_pose_sheet.gd -- ids=248,282 out=E:/FightCamp/tmp/poses

var ids: Array = []
var out := "user://poses"
var b: Node
var _i := -1
var _wait := 0


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		if s.begins_with("ids="):
			for x in s.substr(4).split(","):
				ids.append(int(x))
		elif s.begins_with("out="):
			out = s.substr(4)
	DirAccess.make_dir_recursive_absolute(out)
	b = load("res://scenes/dev/GrappleBrowser.tscn").instantiate()
	root.add_child(b)
	_wait = 60


func _process(_d: float) -> bool:
	_wait -= 1
	if _wait > 0:
		return false
	if _i >= 0:
		root.get_texture().get_image().save_png("%s/p%03d.png" % [out, int(ids[_i])])
	_i += 1
	if _i >= ids.size():
		print("POSES done")
		return true
	b.call("go_position", int(ids[_i]))
	_wait = 130
	return false
