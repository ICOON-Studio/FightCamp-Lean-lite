extends SceneTree
## S338 a still of the coach's plan board on the boxing move map (PLANSCREEN1), windowed on the hidden desktop: plan mode,
## a full plan built by taking moves out (a stay-on-the-card move first, so its loop shows), saves <out>.png.
##   python tools/hidden_desktop.py run <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/plan_still.gd -- <out.png>

const Map := preload("res://scripts/rules/StrikeMap.gd")

var out := "user://plan_still.png"


func _initialize() -> void:
	if not OS.get_cmdline_user_args().is_empty():
		out = OS.get_cmdline_user_args()[0]
	root.size = Vector2i(1920, 1080)
	var s: Control = load("res://scenes/dev/StrikeBrowser.tscn").instantiate()
	root.add_child(s)
	for i in 10:
		await process_frame
	s._set_plan_mode(true)
	var guard := 0
	while s.plan.size() < s._arrow_limit() and guard < 20:
		guard += 1
		var outs: Array = Map.outs(s.current).filter(func(m): return Map.grey_reason(m, s.DEMO_MASTERY) == "")
		if outs.is_empty():
			break
		var stay: Array = outs.filter(func(m): return str(m["from"]) == str(m["to"]))
		var pick: Dictionary = stay[0] if (not stay.is_empty() and s.plan.size() % 3 == 0) else outs[s.plan.size() % outs.size()]
		s._take(pick, true)
		await process_frame
	print("PLAN arrows=%d limit=%d" % [s.plan.size(), s._arrow_limit()])
	for i in 6:
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out)
	print("wrote ", out)
	quit(0)
