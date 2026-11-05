extends SceneTree
## S387 frames of the breathing promo shot on HOME and on the roster, on the hidden desktop, one PNG every 0.5 s (ffmpeg joins them):
##   python tools/hidden_desktop.py run --timeout=120 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/promo_film.gd -- <out_dir>

const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")

var main: Node
var out_dir := "user://promo"


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
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	FirstWeek.skip(main.career)
	main.render()
	await _settle(20)
	for i in 16:
		await create_timer(0.5).timeout
		root.get_texture().get_image().save_png("%s/home_%02d.png" % [out_dir, i])
	main.act("area", "fighters")
	await _settle(20)
	root.get_texture().get_image().save_png("%s/roster.png" % out_dir)
	print("PROMO_FILM done")
	quit(0)


func _settle(n: int) -> void:
	for i in n:
		await process_frame
