extends SceneTree
## S379 CALLOUTPOP stills (operator: "make these popout outlined only when a hit lands ... and also show up as a tooltip when
## player moves mouse over the each body area"): Danny's bout (men_fight) as the game plays it, the picture kept 16:9
## (KEEP, the S379 film fix), four pictures of the body view's close-ups:
##   a_no_hit      no punch landed lately - no close-up showing
##   b_liver_pop   a body hook just landed on blue's liver - blue's LIVER card popped in the right strip
##   c_mid_fade    the hold is over, the LIVER card half faded
##   d_hover_head  the mouse on red's holo head - red's HEAD card in the left strip
## The round's own punches are held back while the pictures are taken (only the fired body hook lands).
##   python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/callout_pop_still.gd -- [out=<dir>]

const TestJump := preload("res://scripts/ui/TestJump.gd")
const BodyCallouts := preload("res://scripts/ui/BodyCallouts.gd")

var main: Node
var view: Node
var out := "E:/FightCamp/tmp/s379/callouts"
var fails := 0


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("out="):
			out = str(a).trim_prefix("out=")
	DirAccess.make_dir_recursive_absolute(out)
	root.mode = Window.MODE_WINDOWED   # a plain 16:9 window (the project opens maximized: 1920x1009 on the hidden desktop)
	root.size = Vector2i(1920, 1080)
	root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _secs(1.0)
	print("CALLOUT_POP jump ", TestJump.run(main, "men_fight"))
	await _secs(1.0)
	main.act("fightstep", "start")
	view = main._fight_layer.get_child(0)
	await _until(func(): return bool(view.playing), 90.0)
	if not bool(view.playing):
		print("CALLOUT_POP FAIL the round never started")
		quit(1)
		return
	print("CALLOUT_POP window %s visible %s" % [DisplayServer.window_get_size(), root.get_visible_rect()])
	await _secs(1.5)
	_hush(40.0)
	await _until(func(): return _shown_all().is_empty(), 10.0)
	await _secs(0.3)
	await _shot("a_no_hit", _shown_all().is_empty(), "no close-up showing")
	var t0 := float(view.t)
	view._fire({"t": t0, "who": "a", "move": "body_hook", "result": "lands", "big": false, "knockback": false, "caption": "", "def": ""})
	var co: Node = _co(1)
	await _until(func(): return bool(co.shown(1)), 5.0)
	await _secs(0.22)
	await _shot("b_liver_pop", _shown_all() == ["1:LIVER"], "blue's LIVER only: %s  line \"%s\"" % [_shown_all(), co.line_of(1)])
	await _until(func(): return float(co._hold[1]) <= 0.0, 5.0)
	await _secs(0.2)
	var a: float = (co._bubbles[1] as Control).modulate.a
	await _shot("c_mid_fade", bool(co.shown(1)) and a > 0.1 and a < 0.9, "LIVER alpha %.2f" % a)
	await _until(func(): return _shown_all().is_empty(), 5.0)
	var fig: Control = view.body.figures[0]
	var head: Vector2 = fig.get_global_transform_with_canvas() * fig.centre_of("head")
	var mm := InputEventMouseMotion.new()
	mm.position = head + Vector2(0, -6)
	mm.global_position = mm.position
	root.push_input(mm, true)   # viewport coords
	await _secs(0.45)
	await _shot("d_hover_head", _shown_all() == ["0:HEAD"], "red's HEAD only: %s  hover %s  line \"%s\"" % [_shown_all(),
		fig.get_node("BodyTip").hover, _co(0).line_of(0)])
	print("CALLOUT_POP failures=%d" % fails)
	quit(1 if fails > 0 else 0)


## The round's scripted beats for the next `secs` of round time do not fire (the pictures show only the fired punch).
func _hush(secs: float) -> void:
	var bs: Array = view.beats
	while int(view.next) < bs.size() and float(bs[int(view.next)]["t"]) < float(view.t) + secs:
		view.next = int(view.next) + 1


func _co(side: int) -> Node:
	return (view.body.figures[side] as Control).get_node_or_null("BodyCallouts")


## Every close-up showing, "<side>:<NAME>".
func _shown_all() -> Array:
	var out_l: Array = []
	for side in 2:
		var co := _co(side)
		for k in BodyCallouts.SPOTS.size():
			if co != null and bool(co.shown(k)):
				out_l.append("%d:%s" % [side, BodyCallouts.SPOTS[k]["name"]])
	return out_l


func _shot(name: String, ok: bool, what: String) -> void:
	await process_frame
	await RenderingServer.frame_post_draw
	var path := out.path_join(name + ".png")
	root.get_texture().get_image().save_png(path)
	if not ok:
		fails += 1
	print("%s %s %s (%s)" % ["PASS" if ok else "FAIL", name, path, what])


func _secs(s: float) -> void:
	var end := Time.get_ticks_msec() + int(s * 1000.0)
	while Time.get_ticks_msec() < end:
		await process_frame


func _until(cond: Callable, max_s: float) -> void:
	var end := Time.get_ticks_msec() + int(max_s * 1000.0)
	while Time.get_ticks_msec() < end and not cond.call():
		await process_frame
