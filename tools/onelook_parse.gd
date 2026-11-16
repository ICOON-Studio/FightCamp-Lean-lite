extends SceneTree
## ONELOOK1: loads every screen script under scripts/ui and scripts/fight3d (headless) so a parse error shows before a render.
##   Godot_v4.7.2-stable_win64.exe --headless --audio-driver Dummy --path . --script res://tools/onelook_parse.gd

var bad := 0
var n := 0


func _initialize() -> void:
	for root_dir in ["res://scripts/ui", "res://scripts/fight3d"]:
		_walk(root_dir)
	print("ONELOOK_PARSE loaded=%d failed=%d" % [n, bad])
	quit(1 if bad > 0 else 0)


func _walk(path: String) -> void:
	var da := DirAccess.open(path)
	if da == null:
		return
	for d in da.get_directories():
		_walk(path.path_join(d))
	for f in da.get_files():
		if f.ends_with(".gd"):
			n += 1
			var s: Script = load(path.path_join(f))
			if s == null or not s.can_instantiate():
				bad += 1
				print("PARSE FAIL ", path.path_join(f))
