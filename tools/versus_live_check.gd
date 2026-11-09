extends SceneTree
## S412 the live versus screen on the hidden desktop: four stills across a few seconds, the load time and the frame time.
##   python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 --audio-driver Dummy \
##       --script res://tools/versus_live_check.gd -- <out_dir>
## Writes <out_dir>/live_<n>.png and prints VERSUS_LIVE lines into <out_dir>/numbers.txt.

const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const Sim := preload("res://scripts/state/Sim.gd")


func _initialize() -> void:
	MenuFx.instant = true
	var out := str(OS.get_cmdline_user_args()[0])
	DirAccess.make_dir_recursive_absolute(out)
	root.size = Vector2i(1920, 1080)
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	main.act("quick")
	var c: Career = main.career
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	c.guide = ""
	var opp: Dictionary = (load("res://scripts/state/Data.gd").OPPONENTS[0] as Dictionary).duplicate(true)
	c.fighters[0]["offers"].append(load("res://scripts/state/Bouts.gd")._offer("lucy:still", opp, c.day + 30, c.day + 6, 4))
	var t0 := Time.get_ticks_msec()
	main.act("openBout", "lucy:still")
	var load_ms := Time.get_ticks_msec() - t0
	var lines: Array = ["VERSUS_LIVE load_ms=%d" % load_ms]
	for i in 30:
		await process_frame
	for n in 4:
		var from := Time.get_ticks_msec()
		var frames := 0
		while Time.get_ticks_msec() - from < 1500:
			await process_frame
			frames += 1
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png(out.path_join("live_%d.png" % n))
		lines.append("VERSUS_LIVE shot %d frame_ms=%.1f" % [n, 1500.0 / maxf(1.0, frames)])
	var f := FileAccess.open(out.path_join("numbers.txt"), FileAccess.WRITE)
	f.store_string("\n".join(lines) + "\n")
	f.close()
	quit(0)
