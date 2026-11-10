extends SceneTree
## S427 stills of the shared outline (Halo.gd): the Dues tab at rest, and the same with the mouse over a board.
## python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080
##   --script res://tools/halo_still.gd -- <out_dir> [live]     (`live` keeps the halo moving: breathe + travelling light)

var main: Control
var out_dir := "user://halo"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	load("res://scripts/ui/MenuFx.gd").instant = not args.has("live")
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(6)
	main.act("newcareer")
	main.act("quick")
	main.act("go", "money:0")
	await _wait(6)
	var tab := main.find_child("DuesTab", true, false) as Button
	if tab == null:
		print("HALO_STILL FAIL no DuesTab")
		quit(1)
		return
	tab.pressed.emit()
	var guide := main.find_child("FirstWeekStrip", true, false)
	if guide != null:
		(guide as CanvasItem).visible = false
	await _wait(40)
	await _save("dues_halo")
	var cheap := main.find_child("Dues_cheap", true, false) as Control
	if cheap != null:
		cheap.mouse_entered.emit()
		await _wait(20)
		await _save("dues_halo_hover")
	print("HALO_STILL done")
	quit(0)


func _wait(frames: int) -> void:
	for i in frames:
		await process_frame


func _save(name: String) -> void:
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name + ".png"))
	print("wrote ", out_dir.path_join(name + ".png"))
