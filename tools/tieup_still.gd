extends SceneTree
## S338 stills of the Tie-ups tab (TIEUPS1) as the player sees it: the collar tie with its answers, the Snapdown answer half
## way, where it lands (the tab comes back), then the linked Front headlock. Real pictures only (the never-shown desktop):
##   python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/tieup_still.gd -- <out_dir>

const TieUpPanel := preload("res://scripts/grapple/TieUpPanel.gd")
const WC := preload("res://scripts/rules/WrestleChains.gd")

var out_dir := "user://tieup_still"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	var b: Control = load("res://scenes/dev/GrappleBrowser.tscn").instantiate()
	root.add_child(b)
	for i in 30:
		await process_frame
	b._open_ties()
	TieUpPanel.pick(b, "collar_tie")
	await _shot("t01_collar_tie")
	var snap: Dictionary = WC.answer_for("collar_tie", "leans in on the tie")
	TieUpPanel.play_answer(b, snap)
	await _wait(b.player.length_s() * 0.5)
	await _shot("t02_snapdown_half")
	await _wait(b.player.length_s() * 0.5 + 0.5)
	await _shot("t03_landed")
	TieUpPanel.pick(b, "front_headlock")
	await _shot("t04_front_headlock")
	quit(0)


func _wait(s: float) -> void:
	var t := 0.0
	while t < s:
		t += await _frame_dt()


func _frame_dt() -> float:
	var a := Time.get_ticks_msec()
	await process_frame
	return (Time.get_ticks_msec() - a) / 1000.0


func _shot(name: String) -> void:
	for i in 4:
		await process_frame
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(path)
	print("wrote ", path)
