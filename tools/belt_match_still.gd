extends SceneTree
## S369 BJJMATCH1: stills of a belt match - the first open call (the panel's 2-3 offers with odds and miss costs) and the
## end. Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=400 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/belt_match_still.gd -- match=1 out=<dir>
## The first call is answered with offer 2 (a player's call), the rest go to her plan.

var b: Node
var out_dir := "user://belt_match_still"
var _shot_call := false
var _t := 0.0


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("out="):
			out_dir = str(a).substr(4)
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	b = load("res://scenes/dev/GrappleBrowser.tscn").instantiate()
	root.add_child(b)


func _process(delta: float) -> bool:
	_t += delta
	var m: Node = b.get_node_or_null("BeltMatch")
	if m == null:
		return false
	if not _shot_call and not (m.get("_call") as Array).is_empty():
		_shot_call = true
		_call_then_act(m)
	if bool(m.get("st")["over"]) and _t > 1.0:
		_save("belt_match_end")
		return true
	return _t > 380.0


## The shot first (the panel with the offers), then the player's call: offer 2.
func _call_then_act(m: Node) -> void:
	var offers: Array = (m.get("_call") as Array).duplicate()
	await _save("belt_match_call")
	m.call("_act", 0, offers[mini(1, offers.size() - 1)], true)


func _save(name: String) -> void:
	await RenderingServer.frame_post_draw
	var p := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(p)
	print("BELT_STILL wrote ", p)
