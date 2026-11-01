extends SceneTree
## S343 the tape room on a real picture (operator Q-S294-68 + "wanna try also your idea ?"): quick start -> Lucy in camp with
## film study -> the tape room, on each opponent named below (default: the jump's own, Maria Ortega), every film played in
## real time. Saves per film: <i>_tell.png (the moment her tell shows - SPOT pressed there when it is hidden, its three
## choices on screen) and <i>_end.png (her whole flow, the counters). The risk test of TAPEROOM_S342: does each tell READ
## on screen? Real pictures only (run it on the never-shown desktop):
##   python tools/hidden_desktop.py run --timeout=400 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/taperoom_still.gd -- <out_dir> [opp=<Data.OPPONENTS index or rival name>,...]
## Prints TAPESTILL <file> per still and TAPESTILL done.

const W := 1920
const H := 1080
const TestJump := preload("res://scripts/ui/TestJump.gd")
const TapeClips := preload("res://scripts/rules/TapeClips.gd")
const Data := preload("res://scripts/state/Data.gd")
const FastDraw := preload("res://tools/fast_draw.gd")

var out_dir := "user://taperoom"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var opps: Array = []
	for a in args:
		if str(a).begins_with("opp="):
			opps = str(a).trim_prefix("opp=").split(",")
		elif not str(a).contains("="):
			out_dir = str(a)
	DirAccess.make_dir_recursive_absolute(out_dir)
	FastDraw.begin()
	root.size = Vector2i(W, H)
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	if not TestJump.run(main, "taperoom"):
		print("TAPESTILL FAIL no tape room")
		quit(1)
		return
	var f: Dictionary = main.career.fighter()
	if opps.is_empty():
		opps = [""]
	for o in opps:
		var room: Node = main.get_node_or_null("TapeRoom")
		if str(o) != "":
			if room != null:
				room.queue_free()
				await _wait(2)
			f["bout"]["opp"] = _opponent(str(o))
			main.act("taperoom", str(f["id"]))
			room = main.get_node_or_null("TapeRoom")
		await _wait(30)
		var tag := str(f["bout"]["opp"]["first"]).to_lower()
		for i in (room.clips as Array).size():
			await _film(room, i, tag)
	print("TAPESTILL done")
	quit(0)


## Film i in real time: the still at her tell (SPOT pressed there when it is hidden), then the end.
func _film(room: Node, i: int, tag: String) -> void:
	room.play(i)
	var c: Dictionary = room.clips[i]
	var w := TapeClips.spot_window(c, room.opp)
	var at := float((c["nodes"] as Array)[int(c["tell_node"])]["t"]) + 0.45
	var hidden := not TapeClips.known(room.opp, c)
	while room.playing and room.t < at:
		await process_frame
	if hidden and room.t <= w.y:
		room.spot()
		await _wait(6)
	_save("%s_%d_%s_tell.png" % [tag, i + 1, c["shape"]])
	if room.spotting:
		room.spot_pick(str(TapeClips.SPOT_WORDS[str(c["shape"])]))
	while room.playing:
		await process_frame
	await _wait(20)
	_save("%s_%d_%s_end.png" % [tag, i + 1, c["shape"]])


func _opponent(key: String) -> Dictionary:
	if key.is_valid_int():
		return (Data.OPPONENTS[int(key)] as Dictionary).duplicate(true)
	for r in Data.RIVALS:
		if str(r["name"]).to_lower().contains(key.to_lower()):
			return (r as Dictionary).duplicate(true)
	return (Data.OPPONENTS[0] as Dictionary).duplicate(true)


func _save(name: String) -> void:
	var img := root.get_texture().get_image()
	var path := out_dir.path_join(name)
	img.save_png(path)
	print("TAPESTILL ", path)


func _wait(n: int) -> void:
	for k in n:
		await process_frame
