extends SceneTree
## S321 (operator C148 on the S319 inside-hook still: "clipping ?"): plays fight night like the board's test (TestJump
## "fight", the game's own camera) and saves a still at the first MAX landed INSIDE contacts with the reach on (the frame
## FightStage records the hit: PunchRange.record), with the glove-to-face miss in the name - so the fix is judged on the
## moments the operator saw, not on a pose test.
##   python tools/hidden_desktop.py run --timeout=500 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --fixed-fps 30 --script res://tools/contact_stills.gd -- <out_dir> [<prefix>] [<arms>]

const TestJump := preload("res://scripts/ui/TestJump.gd")
const FastDraw := preload("res://tools/fast_draw.gd")
const MAX := 4
const SECS := 150.0

var main: Node


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var out_dir: String = args[0] if args.size() > 0 else "user://contact"
	var prefix: String = args[1] if args.size() > 1 else "contact"
	DirAccess.make_dir_recursive_absolute(out_dir)
	FastDraw.begin()
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("CONTACT reached fight night: ", TestJump.run(main, "fight"))
	await _wait(4)
	main.act("fightstep", "start")
	var view: Node = main._fight_layer.get_child(0)
	await _until(func(): return bool(view.playing), 120.0)
	var seen := 0
	var saved := 0
	while saved < MAX and bool(view.playing) and float(view.t) < SECS:
		await process_frame
		var rows: Array = view.stage.hit_gaps
		while seen < rows.size():
			var r: Dictionary = rows[seen]
			seen += 1
			if str(r["phase"]) != "inside" or float(r.get("w", 0.0)) <= 0.0 or saved >= MAX:
				continue
			var img: Image = await FastDraw.shot(self)
			var path := out_dir.path_join("%s_%d_%s_miss%02dcm.png" % [prefix, saved, str(r["move"]), int(float(r["miss"]) * 100.0)])
			img.save_png(path)
			print("CONTACT wrote ", path, " t=%.1f" % float(view.t))
			saved += 1
	quit(0)


func _wait(n: int) -> void:
	for k in n:
		await process_frame


func _until(cond: Callable, max_s: float) -> void:
	var left := max_s
	while left > 0.0 and not cond.call():
		await process_frame
		left -= 1.0 / 30.0
