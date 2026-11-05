extends SceneTree
## S387 frames of the poster coming together after Accept, on the hidden desktop (ffmpeg joins them):
##   python tools/hidden_desktop.py run --timeout=120 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/poster_reveal_film.gd -- <out_dir>

const Bouts := preload("res://scripts/state/Bouts.gd")

var main: Node
var out_dir := "user://poster"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(8)
	main.act("quick")
	main.act("guideskip")
	main.close_modal()
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("hire", "reid")
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	for i in 40:
		if not (f["offers"] as Array).is_empty():
			break
		c.review_pending = false
		Clock.step(c)
	main.close_modal()
	var id := str((f["offers"] as Array).filter(func(o): return not bool(o["mismatch"]))[0]["id"])
	main.act("openBout", id)
	await _settle(10)
	main.act("accept", id)
	for i in 30:
		await create_timer(0.1).timeout
		root.get_texture().get_image().save_png("%s/f_%03d.png" % [out_dir, i])
	print("POSTER_FILM done modal=%s" % str(main.modal.get("type", "")))
	quit(0)


func _settle(n: int) -> void:
	for i in n:
		await process_frame
