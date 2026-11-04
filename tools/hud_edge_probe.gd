extends SceneTree
## S379 (operator on the fight film: "your resolution is out of focus for the sides, the holo head pointer is cut and doesnt
## show"): does the fight HUD - the two body panels, their HEAD / LIVER / RIBS close-ups and the corner rings - sit inside
## the picture? Opens Danny's bout, prints the window / visible rect / each panel's screen rect, saves the picture.
##   python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1280x720 \
##     --script res://tools/hud_edge_probe.gd -- out=<png> [film]      (`film` sizes the root as the film tools do)

const TestJump := preload("res://scripts/ui/TestJump.gd")

var main: Node
var fails := 0


func _initialize() -> void:
	var out := "user://hud_edge.png"
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("out="):
			out = str(a).trim_prefix("out=")
	if OS.get_cmdline_user_args().has("film"):
		root.size = Vector2i(1280, 720)
	if OS.get_cmdline_user_args().has("keep"):   # the picture stays 16:9 (letterboxed) whatever the window's shape
		root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	if OS.get_cmdline_user_args().has("unmax"):  # a plain 16:9 window instead of the project's maximized one
		root.mode = Window.MODE_WINDOWED
		root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("HUDEDGE jump ", TestJump.run(main, "men_fight"))
	await _wait(4)
	main.act("fightstep", "start")
	var view: Node = main._fight_layer.get_child(0)
	var waited := 0.0
	while not bool(view.playing) and waited < 60.0:
		await process_frame
		waited += root.get_process_delta_time()
	await _wait(3)
	var vis := root.get_visible_rect()
	print("HUDEDGE window %s root.size %s visible %s content_scale %s" % [DisplayServer.window_get_size(), root.size, vis,
		root.content_scale_size])
	for n in ["BodyPanel0", "BodyPanel1"]:
		var p := view.find_child(n, true, false) as Control
		if p == null:
			print("HUDEDGE %s missing" % n)
			fails += 1
			continue
		_inside(n, p.get_global_rect(), vis)
		for b in p.find_child("BodyCallouts", true, false).get_children():
			if b is Control and (b as Control).mouse_filter == Control.MOUSE_FILTER_STOP:
				_inside("%s close-up %s" % [n, str(b.get("spot").get("name", "?"))], (b as Control).get_global_rect(), vis)
	var img := root.get_texture().get_image()
	img.save_png(out)
	print("HUDEDGE picture %s (%dx%d)" % [out, img.get_width(), img.get_height()])
	print("HUDEDGE failures=%d" % fails)
	quit(1 if fails > 0 else 0)


func _inside(what: String, r: Rect2, vis: Rect2) -> void:
	var ok := vis.encloses(r)
	if not ok:
		fails += 1
	print("%s %s on screen (rect %s, picture %s)" % ["PASS" if ok else "FAIL", what, r, vis])


func _wait(s: float) -> void:
	var t := 0.0
	while t < s:
		await process_frame
		t += root.get_process_delta_time()
